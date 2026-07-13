#!/bin/bash
# Define an array of catchphrases
PHRASES=("We think you're awesome!" "LDUR!" "Are you running Arch, btw?" "Thanks Nerd" "Is it Wednesday, btw?")

# Randomly select a phrase
RANDOM_INDEX=$(( RANDOM % ${#PHRASES[@]} ))
SELECTED_PHRASE=${PHRASES[$RANDOM_INDEX]}

# Print the messages with figlet
figlet -w 200 -f flowerpower "$SELECTED_PHRASE"