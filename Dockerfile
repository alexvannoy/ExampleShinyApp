# Pull base image
ARG rversion=4.1.0
# Note to self: tidyverse includes devtools
FROM rocker/tidyverse:${rversion} as shinybase
LABEL image=shinybase

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
  && Rscript -e "remotes::install_version('shiny', '1.6.0')" 

# Copy the directory into the base image
WORKDIR /
COPY . app
WORKDIR /ExampleRAPI

# TODO: Figure out how to test shiny apps...
# Test the shiny app
# FROM shinybase as test
# LABEL image=test
# RUN mkdir scripts/results && (Rscript inst/server.R &) && sleep 2 && Rscript scripts/run_tests_docker.R

# Create the release image
FROM shinybase as release
LABEL image=release
WORKDIR /app/
EXPOSE 8888
CMD [ "Rscript", "shiny::runApp(appDir = '.', host = '0.0.0.0', port = 8888, launch.browser = FALSE')" ]
