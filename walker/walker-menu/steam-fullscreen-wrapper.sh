#!/bin/bash

# Launch the actual game
"$@" &

# Wait 5 seconds
sleep 15

# Send Super+F
ydotool key 125:1 33:1 33:0 125:0
