#!/bin/bash
connected_network=$(iwctl station wlan0 show | rg "Connected network" | awk '{print $3}')

if [[ "$connected_network" == "" ]]
then
    echo "Not connected"
else
    echo $connected_network
fi
