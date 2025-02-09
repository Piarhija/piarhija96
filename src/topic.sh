#!/bin/sh -e
# Define the parent directory where all maps (topics) are located


function wheretopic() {
	
echo "Where is the topic located?"
read topic_name

# Construct the full path to the directory
topic_path="$topic_name"

# Check if the directory exists
if [ -d "$topic_path" ]; then
    # Navigate to the directory
    cd "$topic_path"
    echo "Navigated to $topic_path"
else
    # Print error if the directory does not exist
    echo "Topic '$topic_name' not found."
fi



}


read -p "Topic Name: " name;
slug=$(echo "${name}" | tr '[:upper:]' '[:lower:]' | tr ' ' '_')
if test -d slug; then
	echo "Topic already exists"
else
	read -p "Topic Description: " description;
	cd content;
	wheretopic;
	mkdir $slug;
	cd $slug;
	touch content.htm
	echo "<h3>${name}</h3>" > content.htm
	touch meta.htm
	echo "<title>PIARHIJA - ${name}</title><meta name='description' content='${description}' />" > meta.htm
	echo "$(date +%d-%m-%Y)" > date.txt
	
	touch related.txt;

	#twtxt
	cd ../../../../ ;
	current_time=$(date +"%Y-%m-%dT%H:%M:%S"+01:00)
	# Output the result
	echo "${current_time}\t ${name} ${description}" >> twtxt.txt
	cd src/permanav/home;
	
	echo "${name// /_}" > lastpost.txt #write name, repalce space with _
fi



