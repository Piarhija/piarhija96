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
	echo "" > ../permanav/index/content.htm;
	for f in *; do #PREBERE MAPO PHOTOGRAPHY
		#echo "<h3>${f}/</h3><ul>" >> ../permanav/index/content.htm;
		echo "<ul>" >> ../permanav/index/content.htm;
		cd $f;
		for f in *; do #ZDAJ PREBERE PODMAPO PHOTOGRAPHY
			clean_name="${f//_/ }" 
			echo "<li><a href='${site}/${f}.html'>${clean_name}</a></li>" >> ../../permanav/index/content.htm; ##IN GENERIRA LINK PODMAPE
		done
		cd ..
		echo "</ul>" >> ../permanav/index/content.htm;
	done
	echo "Setup index -- DONE"
}

setupgungalarc() {
	for f in *; do
		categoryname=$f;
		mkdir -p ../permanav/${categoryname}
		echo "<ul>" > ../permanav/${categoryname}/content.htm
		cd $f;
		for f in *; do #ZDAJ GREV PODMAPO PHOTOGRAPHY
			clean_name="${f//_/ }"  # Remove underscores
			echo "<li><a href='${site}/${f}.html'>${clean_name}</a></li>" >> ../../permanav/${categoryname}/content.htm; ##IN GENERIRA LINK PODMAPE
		done
		cd ..
		echo "</ul>" >> ../permanav/${categoryname}/content.htm;
		#začasen metagen za index_F
		echo "<title>PIARHIJA - "${categoryname}"</title> <meta name='description' content='index of "${categoryname}"' />
" >../permanav/${categoryname}/meta.htm;
	echo "setup gungalarc -- DONE"
	done
}

sitenav() {
	echo "<header><a href="home.html"><img src="../assets/logosmoll.png"></a></header><nav class='sitenav'><ul>" > ../inc/nav.htm;
	#echo "<li><a href='home.html'>/PIARHIJA</a></li>" >> ../inc/nav.htm;
	for f in *; do
		if [ $f != 'index' ]; then
			clean_name="${f//_/ }" 
			echo "<li><a href='${f}.html'>${clean_name}</a></li>" >>../inc/nav.htm;
		fi
	done
	echo "<li><a href='index.html'>index</a></li>" >> ../inc/nav.htm;
	echo "<li><a href='about.html'>about</a></li>" >> ../inc/nav.htm;
	echo "</ul></nav>" >> ../inc/nav.htm;
	echo "nav"
}


footy() {
	datum=$(date +%d-%m-%Y);
	letina=$(date +%Y);
	
	#echo "<footer><a>Ganga 95© ${letina} </a> <a>Gangad: ${datum}</a></footer></main>" >../inc/footer.htm;

	echo "<span><a><small>|MODIFIED: ${datum} </small></a>| <a href="index.html">index</a></span>"  >../inc/footer.htm;

}
related() {
   if [ -f "related.txt" ] && [ -s "related.txt" ]; then
        # Read the content of related.txt and create a link
        relatedLinks=$(cat related.txt)
        linksMarkup="<div class='related-links'> <b>Related:</b> "
        # Loop through each link in related.txt
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



