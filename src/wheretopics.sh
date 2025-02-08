#!/bin/bash

# Define the parent directory where all maps (topics) are located
MAPS_DIRECTORY="content/"

# Prompt the user for the name of the topic (map)
echo "Where is the topic located?"
read topic_name

# Construct the full path to the directory
topic_path="$MAPS_DIRECTORY/$topic_name"

# Check if the directory exists
if [ -d "$topic_path" ]; then
    # Navigate to the directory
    cd "$topic_path"
    echo "Navigated to $topic_path"
else
    # Print error if the directory does not exist
    echo "Topic '$topic_name' not found."
fi
