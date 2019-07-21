#!/bin/bash

_THEME_NAME=""
_HIDE_SINGLE_TAB=0
_MATCHING_AUTO_COMPLETE_WIDTH=0
_SYSTEM_ICON=0
_SYMBOLIC_TAB_ICON=0
_FIREFOX_DIR=~/.mozilla/firefox
_FIREFOX_PROFILE_DIR=$_FIREFOX_DIR/*.default

function parseArg() {
    for i in "$@"
    do
        case $i in
            --theme-name=*)
                _THEME_NAME="${i#*=}"
                shift # past argument=value
            ;;
            --hide-single-tab)
                _HIDE_SINGLE_TAB=1
                shift # past argument=value
            ;;
            --matching-auto-complete-width)
                _MATCHING_AUTO_COMPLETE_WIDTH=1
                shift # past argument=value
            ;;
            --system-icon)
                _SYSTEM_ICON=1
                shift # past argument=value
            ;;
            --symbolic-tab-icon)
                _SYMBOLIC_TAB_ICON=1
                shift # past argument=value
            ;;
            --firefox-dir=*)
                _FIREFOX_DIR="${i#*=}"
                shift # past argument=value
            ;;
            --firefox-profile-dir=*)
                _FIREFOX_PROFILE_DIR="${i#*=}"
                shift # past argument=value
            ;;
            *)
                echo "unknown option $i"
                exit 1
            ;;
        esac
    done
}

function printArg() {
    echo "_THEME_NAME = $_THEME_NAME"
    echo "_HIDE_SINGLE_TAB = $_HIDE_SINGLE_TAB"
    echo "_MATCHING_AUTO_COMPLETE_WIDTH = $_MATCHING_AUTO_COMPLETE_WIDTH"
    echo "_SYSTEM_ICON = $_SYSTEM_ICON"
    echo "_SYMBOLIC_TAB_ICON = $_SYMBOLIC_TAB_ICON"
    echo "_FIREFOX_DIR = $_FIREFOX_DIR"
    echo "_FIREFOX_PROFILE_DIR = $_FIREFOX_PROFILE_DIR"
}

function init() {
    parseArg $@

    if [ ! -d build ]
    then
        echo "build dir is missing...."
        exit 1
    fi
}



init $@
printArg
