tpb() {
        search_string="$*"
        search="$(perl -MURI::Escape -e "print uri_escape('${search_string}')")"
        url="https://tpb.party/search/${search}/1/99/0"
        html=$(curl -s "$url")
        scrape="$(echo "${html}" | scrape_tpb)"
        selected_line="$(fzf --header "Searching for ${search_string}"  <<<"${scrape}")"
        [[ "${selected_line}" == "" ]] && return
        selected=$(cut -c1-2 <<<"${selected_line}" )
        magnet="$(echo "${html}" | scrape_tpb ${selected})"
        echo "${magnet}"
}

findtorrent() {
        magnet="$(tpb "$*")"
        [[ "$magnet" == "" ]] && return
        transmission-remote http://192.168.1.27:9091/transmission -a "$magnet"
}
