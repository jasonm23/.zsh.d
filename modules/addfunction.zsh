addfunction() {
  fn=${1:-$(fzf --preview 'builtin which {1}' <<<${(kF)functions})}

	if [[ "$(which $fn)" =~ "() " ]]; then
		<<-FN
		$(which ${fn})

		Add this to ~/.zsh.d/modules/functions.zsh ?
		FN
        read -sq
		if [[ $? == 0 ]]; then
          wc_l=$(which $fn | wc -l | tr -d ' \n' )
          echo >> ~/.zsh.d/modules/functions.zsh
          which $1 >> ~/.zsh.d/modules/functions.zsh
          grep -n -A$wc_l "$fn" ~/.zsh.d/modules/functions.zsh
		fi
	else
		<<-HELP
		Usage: addfuncton <function>

		Add function to ~/.zsh.d/modules/functions.zsh
		HELP
	fi
}

func-to-script () {
  fn=${1:-$(fzf --preview 'builtin which {1}' <<<${(kF)functions})}
  if [[ -z $fn  ]]; then
    return 1
  fi
  if [[ "" == "$2" ]]; then
    echo "Write $fn to filename: "
    read filename
  else
    filename="$2"
  fi
  if [[ "$fn" != "" && "$filename" != "" && "$(which $fn)" =~ "() " ]]; then
    if [[ -f "$filename"  ]]; then
      file_msg="overwrite ${filename}?"
    else
      file_msg="Write to ${filename}?"
    fi
		<<-FN
		#!/bin/sh
		$(which ${fn} | sed '1d; $d')

		$file_msg
		FN
		read -sq
		if [[ $? == 0 ]]; then
      <<-WRITE > "${filename}"
			#!/bin/sh
			$(which ${fn} | sed '1d; $d')
			WRITE
			bat -n "${filename}"
		fi
	else
		<<-HELP
		Usage: $0 <function> <filename>

		Write FUNCTION to a script FILENAME.
		HELP
	fi
}
