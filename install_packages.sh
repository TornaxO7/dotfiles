#!/bin/sh

PACK_DIR="$HOME/.cache/my_packages"

if [[ $1 == "pre" ]]
then
    rm -rf $PACK_DIR
elif [[ $1 == "post" ]]
then
    echo "Creating directory $PACK_DIR"
    mkdir -p $PACK_DIR

    for package_list in $("$PACK_DIR"/*)
    do
        sudo pacman -S --needed < $package_list
    done
fi

