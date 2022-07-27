movie-missing-thai-srt () {
    movies=${1:-/Volumes/NextStep/Movies}
	fd --type directory . "$movies" | while read d
	do
		[[ "$(fd '.*srt$' "$d" | tr -d "\n" )" =~ "th.srt" ]] || echo $d
	done
}

movie-missing-srt () {
    movies=${1:-/Volumes/NextStep/Movies}
	fd --type directory . "$movies" | while read d
	do
		[[ "$(fd '.*srt$' "$d" | tr -d "\n" )" =~ ".srt" ]] || echo $d
	done
}

movie-has-thai-srt () {
    movies=${1:-/Volumes/NextStep/Movies}
	fd  --type directory . "$movies"  | while read d
	do
		[[ "$(fd '.*srt$' "$d" | tr -d "\n" )" =~ "th.srt" ]] && echo $d
	done
}

get_subs() {
	 py ~/workspace/OpenSubtitlesDownload/OpenSubtitlesDownload.py \
         -u jasonm23 \
         -p "$(security find-generic-password -w -s OpenSubtitlesKey -a OPEN_SUBS_KEY)" \
         --cli \
         -l eng "$1"
}

get-missing-subtitles () {
	folder="$(movie-missing-srt | fzf)"
	if [[ -d "${folder}" ]]
	then
		movie=$(fd "(mp4|mkv|avi)$" "${folder}" | fzf)
		if [[ -f "${movie}" ]]
		then
			get_subs "${movie}"
			downloaded="${movie%.*}.srt"
			if [[ -f "${downloaded}" ]]
			then
				english_srt="${movie%.*}.en.srt"
				mv "${movie%.*}.srt" "${english_srt}"
				echo "${folder}:"
				ls -G -s1 "$folder"
				open -a Progression
				srt translate "${english_srt}" > "${english_srt/.en./.th.}"
			else
				echo "Sorry, no subtitles were downloaded for $(basename "${movie}")"
				return 1
			fi
		else
			return 1
		fi
	else
		return 1
	fi
}
