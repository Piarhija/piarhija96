#!/bin/bash -e

# Define paths
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

# Create site directory
rm -rf $site
mkdir -p $site

# Setup index
setupindex() {
  echo "<div class='indexul'>" > ../permanav/index/content.htm
  for category in */; do
    category_name=$(basename "$category")
    echo "<ul><h3>${category_name^^}</h3>" >> ../permanav/index/content.htm
    for subcategory in "$category"*/; do
      clean_name=$(basename "$subcategory" | tr '_' ' ')
      echo "<li><a href='${site}/$(basename "$subcategory").html'>${clean_name}</a></li>" >> ../permanav/index/content.htm
    done
    echo "</ul>" >> ../permanav/index/content.htm
  done
  echo "</div>" >> ../permanav/index/content.htm
  echo "Setup index -- DONE"
}

# Setup category pages (gungalarc)
setupgungalarc() {
  for category in */; do
    category_name=$(basename "$category")
    mkdir -p ../permanav/${category_name}
    echo "<ul>" > ../permanav/${category_name}/content.htm
    for subcategory in "$category"*/; do
      clean_name=$(basename "$subcategory" | tr '_' ' ')
      echo "<li><a href='${site}/$(basename "$subcategory").html'>${clean_name}</a></li>" >> ../permanav/${category_name}/content.htm
    done
    echo "</ul>" >> ../permanav/${category_name}/content.htm
    echo "<title>PIARHIJA - ${category_name}</title><meta name='description' content='index of ${category_name}' />" > ../permanav/${category_name}/meta.htm
    echo "setup gungalarc -- DONE"
  done
}

# Setup navigation bar
sitenav() {
  echo "<header><a href='home.html'><img src='../assets/logosmoll.png'></a></header><nav class='sitenav'><ul>" > ../inc/nav.htm
  for category in */; do
    [ "$category" != "index/" ] && clean_name=$(basename "$category" | tr '_' ' ') && echo "<li><a href='${category}.html'>${clean_name}</a></li>" >> ../inc/nav.htm
  done
  echo "<li><a href='about.html'>about</a></li></ul></nav>" >> ../inc/nav.htm
  echo "nav"
}

# Setup footer
footy() {
  datum=$(date +"%R %d-%m-%Y")
  echo "<a>Modified: ${datum} </a>" > ../inc/footer.htm
}

# Generate related links
related() {
  if [ -f "related.txt" ] && [ -s "related.txt" ]; then
    links_markup="<div class='related-links'><b>Related:</b> "
    while IFS=',' read -ra LINKS; do
      for link in "${LINKS[@]}"; do
        clean_name=$(echo "$link" | xargs | tr '_' ' ')
        links_markup+="<a href='${link}.html'>${clean_name}</a> "
      done
    done < related.txt
    echo "${links_markup}</div>"
  fi
}

# Update last post
lastpost() {
  if [ -f "content.htm" ] && [ -f "lastpost.txt" ]; then
    last_post_content=$(<lastpost.txt)
    sed -i '' '$d' "content.htm"
    clean_name=$(echo "$last_post_content" | tr '_' ' ')
    echo "<p>Latest post: <a href='${last_post_content}.html'>${clean_name}</a></p>" >> "content.htm"
    echo "Updated last post in content.htm."
  else
    echo "'content.htm' or 'lastpost.txt' does not exist!"
  fi
}

# Main content generation loop
generate_content() {
  for category in "$content"/*/; do
    for subcategory in "$category"*/; do
      subcategory_name=$(basename "$subcategory")
      markup=$(related)
      topPart=$(cat $headerA $meta $headerB)
      nav=$(cat $sitenav)
      contentText=$(cat "$subcategory/$contentFile")
      footer=$(cat $foottop $foot $footbot)
      closefile=$(cat $bottom)
      mainContent="<main>${contentText}${markup}</main>"
      echo "${topPart}${nav}${mainContent}${footer}${closefile}" > "$site/$subcategory_name.html"
      tally=$((tally + 1))
    done
  done
}

# Setup pages and generate content
cd $content
footy
sitenav
setupindex
setupgungalarc
generate_content
echo "${tally} topics built"
echo "mijau mijau"
