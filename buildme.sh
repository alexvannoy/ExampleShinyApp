#! /bin/bash

# Documentation function
function usage(){
    cat <<EOF
    Usage: A script to build the docker image and push to public docker.io repository
    
    -r: The version of R to use when building the docker image. Uses 4.1.0 by default.
    -v: The version of the package to pin to the docker image. Uses the Version value from the DESCRIPTION file by default.
    -h: Print this help documentation.
    
EOF
}

# Read in arguments
while getopts hrv flag
do
    case "${flag}" in
        h) usage; exit 0;;
        r) rversion=${OPTARG};;
        v) version=${OPTARG};;
        *) usage; exit 1;;
    esac
done

# Load the parse_yaml function
. parse_yaml.sh

# Set default R-version
if [[ -z "$rversion" ]]; then
  rversion=4.1.0
fi
echo "Building image with R-version $rversion"

# Set default docker image version pin
if [[ -z "$version" ]]; then
  # read yaml file
  eval $(parse_yaml DESCRIPTION "config_")
  version="${config_Version/$'\r'/}"
fi
echo "Tagging image as version $version"

# This abuses the fact that I'm already logged in.
docker login
# Build docker image & push to repo
# NOTE: This obviously won't work for anyone else.
docker buildx build --platform linux/amd64,linux/arm64,linux/arm/v7,linux/arm/v6 --build-arg rversion=$rversion . -t "aavannoy/r-shinyapp:$version" --push

exit 0