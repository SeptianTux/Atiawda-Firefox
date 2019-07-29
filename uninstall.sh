#!/bin/bash

_THEME_NAME=""
_FIREFOX_DIR=~/.mozilla/firefox
_FIREFOX_PROFILE_NAME=""

function helpMe() {
    echo -e "usage\t:"
    echo -e "\t$0 [option-1] [option-2]=[value]..."
    echo
    echo -e "option\t:"
    echo -e "\t--theme-name\t\t\t: Theme name."
    echo -e "\t--firefox-dir\t\t\t: Firefox directory. " \
            "\n\t\t\t\t\t  Default value is ~/.mozilla/firefox"
    echo -e "\t--firefox-profile-name\t\t: Firefox profile name." \
            "\n\t\t\t\t\t  Default value is *.default* "
    echo -e "\t--help\t\t\t\t: Show help."
    echo
    echo -e "example\t:"
    echo -e "\t$0\t--theme-name=Atiawda --firefox-dir=~/.mozilla-new/firefox " \
            "\\ \n \t\t\t--firefox-profile-dir=fr8frj3w0sk.custom-test"

    exit 0
}

function typo() {
    echo -e "use \"--help\" for help."

    exit 1
}

function parseArg() {
    for i in "$@"
    do
        case $i in
            --theme-name=*)
                _THEME_NAME="${i#*=}"
                shift
            ;;
            --firefox-dir=*)
                _FIREFOX_DIR="${i#*=}"
                shift
            ;;
            --firefox-profile-name=*)
                _FIREFOX_PROFILE_NAME="${i#*=}"
                shift
            ;;
            --help)
                helpMe
            ;;
            *)
                typo
            ;;
        esac
    done
}

function setFirefoxProfileToDefault() {
    local profile

    if [ ! -d $_FIREFOX_DIR ]
    then
        echo "$_FIREFOX_DIR is not a directory."
        exit 2
    fi

    profile=$(find $_FIREFOX_DIR -maxdepth 1 -type d -name "*.default*")

    if [ -z $profile ]
    then
        echo "Can't find default profile. Please use \"--firefox-profile-name\" option."
        exit 1
    fi

    _FIREFOX_PROFILE_NAME=$(basename $profile)
}

function uninstallNow() {
    rm -v $_FIREFOX_DIR/$_FIREFOX_PROFILE_NAME/user.js
    rm -rv $_FIREFOX_DIR/$_FIREFOX_PROFILE_NAME/chrome/$_THEME_NAME
    rm -v $_FIREFOX_DIR/$_FIREFOX_PROFILE_NAME/chrome/userChrome.css

    if ! find $_FIREFOX_DIR/$_FIREFOX_PROFILE_NAME/chrome -mindepth 1 | read; then
       rm -rv $_FIREFOX_DIR/$_FIREFOX_PROFILE_NAME/chrome
    fi
}

function init() {
    parseArg $@

    if [ -z $_FIREFOX_PROFILE_NAME ]
    then
        setFirefoxProfileToDefault
    fi

    if [ -z $_THEME_NAME ]
    then
        echo -e "\$_THEME_NAME is NULL"
        exit 1
    fi

    uninstallNow
}

init $@
