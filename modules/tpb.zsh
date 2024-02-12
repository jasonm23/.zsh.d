
tpb() {
        local search_string="$*"
        local search="$(perl -MURI::Escape -e "print uri_escape('${search_string}')")"
        local url="https://tpb.party/search/${search}/1/99/0"
        local html=$(curl -s "$url")
        local scrape="$(echo "${html}" | scrape_tpb)"
        local selected_line="$(fzf --header "Searching for ${search_string}"  <<<"${scrape}")"
        [[ "${selected_line}" == "" ]] && return
        local selected=$(cut -c1-2 <<<"${selected_line}" )
        local magnet="$(echo "${html}" | scrape_tpb ${selected})"
        echo "${magnet}"
}

findtorrent() {
        local transmission_host=192.168.1.26
        local magnet="$(tpb "$*")"
        [[ "$magnet" == "" ]] && return
        transmission-remote http://${transmission_host}:9091/transmission -a "$magnet"
}
