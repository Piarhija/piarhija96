#!/bin/sh -e
site=../site
content=content
headerA=../../inc/header-top.htm
headerB=../../inc/header-bottom.htm
sitenav=../../inc/nav.htm
meta=meta.htm
contentFile=content.htm
foottop=../../inc/footer-top.htm
foot=../../inc/footer.htm
footbot=../../inc/footer-bottom.htm
bottom=../../inc/html-bottom.htm
tally=0

rm -rf $site
mkdir -p $site

# List the index
setupindex() {
	echo "<div class="indexul">" > ../permanav/index/content.htm;
	for f in *; do 
		uppercase=$(echo "$f" | tr 'a-z' 'A-Z')
		echo "<ul><h3>${uppercase}</h3>" >> ../permanav/index/content.htm;
		cd $f;
		for f in *; do 
			clean_name="${f//_/ }" 
			echo "<li><a href='${site}/${f}.html'>${clean_name}</a></li>" >> ../../permanav/index/content.htm; 
		done
		cd ..
		echo "</ul>" >> ../permanav/index/content.htm;
	done
	echo "</div>" >> ../permanav/index/content.htm;
	echo "Setup index -- DONE"
}

setupgungalarc() {
	for f in *; do
		categoryname=$f;
		mkdir -p ../permanav/${categoryname}
		echo "<ul>" > ../permanav/${categoryname}/content.htm
		cd $f;
		for f in *; do 
			clean_name="${f//_/ }"  
			echo "<li><a href='${site}/${f}.html'>${clean_name}</a></li>" >> ../../permanav/${categoryname}/content.htm; ##IN GENERIRA LINK PODMAPE
		done
		cd ..
		echo "</ul>" >> ../permanav/${categoryname}/content.htm;
		echo "<title>PIARHIJA - "${categoryname}"</title> <meta name='description' content='index of "${categoryname}"' />
" >../permanav/${categoryname}/meta.htm;
	echo "setup gungalarc -- DONE"
	done
}

sitenav() {
	echo "<nav class='sitenav'><ul><li><a href="home.html"><img src="../assets/logosmoll.png"></a></li>" > ../inc/nav.htm;
	for f in *; do
		if [ $f != 'index' ]; then
			clean_name="${f//_/ }" 
			echo "<li><a href='${f}.html'>${clean_name}</a></li>" >>../inc/nav.htm;
		fi
	done
	echo "<li><a href='about.html'>about</a></li>" >> ../inc/nav.htm;
	echo "</ul></nav>" >> ../inc/nav.htm;
	echo "nav"
}

footy() {
	datum=$(date +" %R %d-%m-%Y");
	letina=$(date +%Y);
	echo "<div class="right"><a>Modified: ${datum} </a></div>"  >../inc/footer.htm;
	
}


	


related() {
   if [ -f "related.txt" ] && [ -s "related.txt" ]; then
        relatedLinks=$(cat related.txt)
        linksMarkup="<div class='related-links'> <b>Related:</b> "
        IFS=',' read -ra LINKS <<< "$relatedLinks"
        for link in "${LINKS[@]}"; do
            link=$(echo "$link" | xargs)  # Remove any extra spaces
			clean_name="${link//_/ }" 
            linksMarkup+="<a href=\"$link.html\">${clean_name}</a> "  # Add a space after each link
        done
        linksMarkup+="</div>"
        markup="$linksMarkup"
    fi
}


lastpost() {
  if [ "$f" == "home" ]; then
    if [ -d "home" ]; then
      cd home || { echo "Failed to enter 'home' directory"; return 1; }
        if [ -f "content.htm" ] && [ -f "lastpost.txt" ]; then
        last_post_content=$(<lastpost.txt)
        sed -i '' '$d' "content.htm"  
        clean_name="${last_post_content//_/ }" 
         echo "<p>Latest post:<a href="${last_post_content}.html">${clean_name}</a></p>" >> "content.htm"
        echo "Replaced the last line with new text in content.htm."
      else
        echo "'content.htm' does not exist in 'home' directory!"
      fi
      cd .. || { echo "Failed to go back to the parent directory"; return 1; }
    else
      echo "'home' directory does not exist!"
    fi
  else
    echo "The folder '$f' is not 'home'. No action taken."
  fi
}

# Setup topics
cd $content
footy;
sitenav;
setupindex;
setupgungalarc;

for f in *; do
	cd $f;
	for f in *; do
		cd $f;
		markup=''
		topPart=$(cat ../$headerA $meta ../$headerB);
		nav=$(cat ../$sitenav);
		contentText=$(cat $contentFile $test);
		footer=$(cat ../$foottop ../$foot ../$footbot);
		closefile=$(cat ../$bottom);
		mainContent="<main>${contentText}";
		related;
		relatedmarkup="${markup}";
		echo ${topPart}${nav}"${mainContent}"${relatedmarkup}${footer}${closefile} > ../../../$site/${f}.html
		cd ..
		tally=$((tally+1))
	done
	cd ..
done
cd ..
cd permanav   #nardi .html fajle samo na bullshit v permanavu
for f in *; do
	lastpost;
	cd $f;
	markup=''
	topPart=$(cat $headerA $meta $headerB);
	nav=$(cat $sitenav);
	contentText=$(cat $contentFile);
	footer=$(cat $foottop $foot $footbot);
	closefile=$(cat $bottom);
	mainContent="<main>${contentText}</main>";
	echo ${topPart}${nav}"${mainContent}"${sideBar}${footer}${closefile} > ../../$site/${f}.html
	cd ..
done
echo "${tally} topics built"
echo "mijau mijau"



