#!/bin/bash
state=$(eww get show_example)

if [[ $state == "true" ]]
then
    eww update show_example=false
else
    eww update show_example=true
fi
