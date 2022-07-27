
tmbvurl() {
  u=$1
  o=50
  p=${2:-0}
  ((c=$p * $o))
  url="http://tumblrview.com/onepage.php?user=${u}&offset=$c&limit=${o}&page=${p}"
  echo $url
}

getpage_tmb() {
  u=$1
  p=$2
  curl -s `tmbvurl ${u} ${p}` \
      | pup 'img attr{src}'
}

getpage_list_tmb() {
  u=$1
  o=50
  curl -s "http://tumblrview.com/index.php?user=${u}&offset=0&limit=${o}&submit=GO" \
      | pup ".number text{}" \
      | tr "\n" " "
}
