@ECHO OFF
SET CMD=%1

IF "%1" == "" (
  ECHO Valid commands:
  ECHO build: builds the docker image as tag r-shinyapp:dev
  ECHO run-bash: runs the dev image with bash as the entrypoint
  ECHO web-app: build the docker image as :dev-api, then runs the image
)

if "%1" == "build" (
  docker build --build-arg rversion=4.1.0 . -t r-shinyapp:dev
)

if "%1" == "run-bash" (
  docker build --build-arg rversion=4.1.0 . -t r-shinyapp:dev
  docker run --entrypoint=/bin/bash -it r-shinyapp:dev
)

if "%1" == "web-app" (
  docker stop run-r-shinyapp
  docker container rm run-r-shinyapp
  docker image prune
  ECHO ON
  docker build --build-arg rversion=4.1.0 . -t docker.io/library/r-shinyapp:dev
  docker run -p 8080:8080 -it --name run-r-shinyapp docker.io/library/r-shinyapp:dev
  EXIT /B 0
)
