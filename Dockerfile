# Pull base image
ARG rversion=4.1.0
# Note to self: tidyverse includes devtools
FROM rocker/tidyverse:${rversion} as base
LABEL image=base

# Install debian package dependencies
RUN apt-get update -qq && apt-get -y --no-install-recommends install \
    libxml2-dev \
    libcairo2-dev \
    libsqlite3-dev \
    libmariadb-dev \
    libpq-dev \
    libssh2-1-dev \
    libcurl4-openssl-dev \
    libssl-dev

# Update system libraries
RUN apt-get update && \
  apt-get upgrade -y && \
  apt-get clean 
  
# Install pinned versions of R package dependencies
RUN Rscript -e "install.packages('remotes')" \
  && Rscript -e "remotes::install_version('jsonlite', '1.7.2')" \
  && Rscript -e "remotes::install_version('R.utils', '2.10.1')" \
  && Rscript -e "remotes::install_version('usethis', '2.0.1')" \
  && Rscript -e "remotes::install_version('testthat', '3.0.2')" \
  && Rscript -e "devtools::install_github('dselivanov/RestRserve@v0.4.1')"

# Copy the directory into the base image
WORKDIR /
COPY . ExampleRAPI
WORKDIR /ExampleRAPI

# Test the R package
FROM base as test
LABEL image=test
RUN mkdir scripts/results && (Rscript inst/server.R &) && sleep 2 && Rscript scripts/run_tests_docker.R

# Install the R package
FROM base as prerelease
label image=prerelease
RUN mkdir man \
  && Rscript -e 'devtools::document(roclets = c("rd", "collate", "namespace"))' \
  && R CMD build . \
  && R CMD check ExampleRAPI_*.tar.gz --no-tests --no-manual \
  && rm -rf man \
  && R CMD INSTALL ExampleRAPI_*.tar.gz

# Create the release image
FROM prerelease as release
LABEL image=release
WORKDIR /ExampleRAPI/inst
EXPOSE 8080
RUN ln -s /tmp/swagger-ui.html swagger-ui.html \
  && rm -rf ./ExampleRAPI.Rcheck
ENTRYPOINT [ "Rscript", "server.R" ]
