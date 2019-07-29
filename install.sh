#!/bin/bash

_THEME_NAME="Atiawda"
_HIDE_SINGLE_TAB=0
_MATCHING_AUTO_COMPLETE_WIDTH=0
_SYSTEM_ICON=0
_SYMBOLIC_TAB_ICON=0
_FIREFOX_DIR=~/.mozilla/firefox
_FIREFOX_PROFILE_NAME=""
_FIREFOX_PROFILE_DIR=""

function helpMe() {
    echo -e "usage\t:"
    echo -e "\t$0 [option-1] [option-2]=[value]..."
    echo
    echo -e "option\t:"
    echo -e "\t--theme-name\t\t\t: Theme name.\n\t\t\t\t\t  Default value is Adtiawda."
    echo -e "\t--hide-single-tab\t\t: Hide single tab"
    echo -e "\t--matching-auto-complete-width\t: Matching autocomplete width."
    echo -e "\t--system-icon\t\t\t: Use system icon."
    echo -e "\t--symbolic-tab-icon\t\t: Symbolic icon tab."
    echo -e "\t--firefox-dir\t\t\t: Firefox directory.\n\t\t\t\t\t  Default value is ~/.mozilla/firefox"
    echo -e "\t--firefox-profile-name\t\t: Firefox profile name." \
            "\n\t\t\t\t\t  Default value is *.default* "
    echo -e "\t--help\t\t\t\t: Show help."
    echo
    echo -e "example\t:"
    echo -e "\t# use all availible option"
    echo -e "\t$0\t--theme-name=Atiawda --hide-single-tab" \
            "\\ \n \t\t\t--firefox-dir=~/.mozilla-new" \
            "\\ \n \t\t\t--firefox-profile-name=w4u48fe6395.custom-test" \
            "\\ \n \t\t\t--symbolic-tab-icon --system-icon " \
            "\\ \n \t\t\t--matching-auto-complete-width"
    echo
    echo -e "\t# use default settign"
    echo -e "\t$0"

    exit 0
}

function typo() {
    echo -e "unknown option \"$1\"."
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
            --hide-single-tab)
                _HIDE_SINGLE_TAB=1
            ;;
            --matching-auto-complete-width)
                _MATCHING_AUTO_COMPLETE_WIDTH=1
            ;;
            --system-icon)
                _SYSTEM_ICON=1
            ;;
            --symbolic-tab-icon)
                _SYMBOLIC_TAB_ICON=1
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
                typo $i
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

function installNow() {
    if [ ! -d ./src/theme/$_THEME_NAME ]
    then
        echo "./src/theme/$_THEME_NAME is not a directory"
        exit 3
    fi

    cp -rv ./build/$_THEME_NAME $_FIREFOX_PROFILE_DIR/chrome

    if [ ! -f $_FIREFOX_PROFILE_DIR/chrome/userChrome.css ]
    then
        touch $_FIREFOX_PROFILE_DIR/chrome/userChrome.css
    else
        echo -n "" > $_FIREFOX_PROFILE_DIR/chrome/userChrome.css
    fi

    echo -e "@import \"$_THEME_NAME/gnome-theme.css\";" \
            >> $_FIREFOX_PROFILE_DIR/chrome/userChrome.css

    if [ $_HIDE_SINGLE_TAB -gt 0 ]
    then
        echo -e "@import \"$_THEME_NAME/hide-single-tab.css\";" \
                >> $_FIREFOX_PROFILE_DIR/chrome/userChrome.css
    fi

    if [ $_MATCHING_AUTO_COMPLETE_WIDTH -gt 0 ]
    then
        echo -e "@import \"$_THEME_NAME/matching-autocomplete-width.css\";" \
                >> $_FIREFOX_PROFILE_DIR/chrome/userChrome.css
    fi

    if [ $_SYSTEM_ICON -gt 0 ]
    then
        echo -e "@import \"$_THEME_NAME/system-icons.css\";" \
                >> $_FIREFOX_PROFILE_DIR/chrome/userChrome.css
    fi

    if [ $_SYMBOLIC_TAB_ICON -gt 0 ]
    then
        echo -e "@import \"$_THEME_NAME/symbolic-tab-icons.css\";" \
                >> $_FIREFOX_PROFILE_DIR/chrome/userChrome.css
    fi

    if [ -f $_FIREFOX_PROFILE_DIR/user.js ]
    then
        rm -v $_FIREFOX_PROFILE_DIR/user.js
    fi

    cp -v src/configuration/user.js $_FIREFOX_PROFILE_DIR/user.js
}

function init() {
    parseArg $@

    _THEME_NAME=$(basename $_THEME_NAME)

    if [ ! -d build ]
    then
        echo "build dir is missing...."
        exit 1
    fi
    
    if [ -z $_FIREFOX_PROFILE_DIR ]
    then
        if [ -z $_FIREFOX_PROFILE_NAME ]
        then
            setFirefoxProfileToDefault
        fi

        _FIREFOX_PROFILE_NAME=$(basename $_FIREFOX_PROFILE_NAME)
        _FIREFOX_PROFILE_DIR=$_FIREFOX_DIR/$_FIREFOX_PROFILE_NAME
    fi

    if [ ! -d $_FIREFOX_PROFILE_DIR ]
    then
        echo "$_FIREFOX_PROFILE_DIR is not a directory"
        exit 1
    fi

    if [ ! -d $_FIREFOX_PROFILE_DIR/chrome ]
    then
        mkdir -v $_FIREFOX_PROFILE_DIR/chrome
    fi

    installNow
}

init $@
