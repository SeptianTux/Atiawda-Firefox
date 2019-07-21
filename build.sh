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

function buildBackup() {
    _NEW_NAME=""

    if [ ! -d ./build ]
    then
        echo "this is not build dir."
        exit 5
    fi

    echo "yeay $1"

    for i in $(ls $1)
    do
        if [ -d $1/$i ]
        then
            echo "build $1/$i"
            build $1/$i
        fi

        if [ -f $1/$i ]
        then
            if [ $(echo $1/$i | grep -c ".scss$") -eq 1 ]
            then
                _NEW_NAME=$(basename $(echo $1/$i | sed 's/.scss/.css/g'))
                echo  "sassc -t compact $1/$i $1/$_NEW_NAME"
                sassc -t compact $1/$i $1/$_NEW_NAME

                if [ $? -gt 0 ]
                then
                    echo "sassc error...."
                    exit 1
                fi

                rm -v $1/$i
            fi
        fi
    done
}

function build() {
    _NEW_NAME=""

    if [ ! -d ./build ]
    then
        echo "build dir is missing."
        exit 5
    fi

    for i in $(find ./build -type f -name "*.scss")
    do
        _NEW_NAME=$(echo $i | sed 's/.scss/.css/g')
        sassc -t compact $i $_NEW_NAME
        
        if [ $? -gt 0 ]
        then
            echo "sassc error...."
            exit 1
        fi

        echo "sassc -t compact $i $_NEW_NAME"
    done        
}

buildInit
build

