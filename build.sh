#!/bin/bash

function ifFail() {
    if [ $1 -gt 0 ]
    then
        if [ ! -z $2 ]
        then
            echo $2
        fi

        if [ ! -z $3 ]
        then
            exit $3
        fi

        exit $1
    fi
}

function buildInit() {
    declare -a arr=("build")

    for i in "${arr[@]}"
    do
        mkdir -v $i
        ifFail $?
    done

    cp -Rv src/theme/* build
    ifFail $? "build init failed..." 2
}

function build() {
    _NEW_NAME=""

    buildInit

    if [ ! -d ./build ]
    then
        ifFail 5 "build dir is missing." 5
    fi

    for i in $(find ./build -type f -name "*.scss")
    do
        _NEW_NAME=$(echo $i | sed 's/.scss/.css/g')

        sassc -t compact $i $_NEW_NAME
        echo "sassc -t compact $i $_NEW_NAME"

        ifFail $? "sacc error..."

        rm -v $i
    done        
}

build

