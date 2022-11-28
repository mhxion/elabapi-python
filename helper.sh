#!/usr/bin/env bash
# This script will generate a python library from the openapi definition file.

# the docker image used to generate the client code
docker_image="swaggerapi/swagger-codegen-cli-v3"
# where to grab the definition file
openapi_yaml_url="https://raw.githubusercontent.com/elabftw/elabftw/hypernext/apidoc/v2/openapi.yaml"
# folder with the generated python code
lib="generated"

function generate {
    # clean up first
    rm -rfv "$lib"
    # now generate the lib
    docker run --user "$(id -u)":"$(id -gn)" --rm -v "${PWD}":/local "$docker_image" generate -i "$openapi_yaml_url" -l python -o /local/"$lib" -c /local/config.json --git-user-id elabftw --git-repo-id elabapi-python
}

function build {
    cd "$lib" || exit 1
    python setup.py sdist bdist_egg bdist_wheel
    cd ..
}

function publish {
    build
    cd "$lib" || exit 1
    twine upload dist/*
    cd ..
}

"$1"