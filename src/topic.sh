#!/bin/sh -e

function prompt(){
	read -p "Do you want sidebar $1? " -r yn
	case "${yn}" in
		[Yy]* ) touch $1.txt; break;;
		[Nn]* ) break;;
		* ) echo "Please answer yes or no.";;
	esac
	unset yn;
}

read -p "Topic Name: " name;
slug=$(echo "${name}" | tr '[:upper:]' '[:lower:]' | tr ' ' '_')
if test -d slug; then
	echo "Topic already exists"
else
	read -p "Topic Description: " description;
	cd content;
	mkdir $slug;
	cd $slug;
	touch content.htm
	echo "<h1>${name}</h1>" > content.htm
	touch meta.htm
	echo "<title>${name}</title><meta name='description' content='${description}' />" > meta.htm
	prompt links;
	touch related.txt;
fi