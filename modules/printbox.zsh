#!/usr/bin/env zsh

longest_str_len() {
  MAX=0
  for a in $@; do
      if (( ${#a} > MAX )); then
        MAX=${#a}
      fi
  done
  echo $MAX
}

printboxsq0() {
  LEN=$( longest_str_len $@)
  ((MAX=LEN + 2))
  printf "┌"; printf "%0.s─" {1..$MAX}; printf "┐\n"
  for line in $@; do
    printf "│ ${line}"; printf "%0.s " {1..$(( MAX - ${#line} - 1 ))}; printf "│\n"
  done
  printf "└"; printf "%0.s─" {1..$MAX}; printf "┘\n"
}

printboxsq() {
  LEN=$( longest_str_len $@)
  ((MAX=LEN + 2))
  printf "┌"; printf "%0.s─" {1..$MAX}; printf "┐\n"
  for line in $@; do
    if [[ "$line" == "$@[$#]" ]];then
      printf "├"; printf "%0.s─" {1..$MAX}; printf "┤\n"
    fi
    printf "│ ${line}"; printf "%0.s " {1..$(( MAX - ${#line} - 1 ))}; printf "│\n"
  done
  printf "└"; printf "%0.s─" {1..$MAX}; printf "┘\n"
}

printbox0() {
  LEN=$( longest_str_len $@)
  ((MAX=LEN + 2))

  printf "╭"; printf "%0.s─" {1..$MAX}; printf "╮\n"
  for line in $@; do
    printf "│ ${line}"; printf "%0.s " {1..$(( MAX - ${#line} - 1 ))}; printf "│\n"
  done
  printf "╰"; printf "%0.s─" {1..$MAX}; printf "╯\n"
}

printbox() {
  LEN=$( longest_str_len $@)
  ((MAX=LEN + 2))

  printf "╭"; printf "%0.s─" {1..$MAX}; printf "╮\n"
  for line in $@; do
    if [[ "$line" == "$@[$#]" ]];then
      printf "├"; printf "%0.s─" {1..$MAX}; printf "┤\n"
    fi
    printf "│ ${line}"; printf "%0.s " {1..$(( MAX - ${#line} - 1 ))}; printf "│\n"
  done
  printf "╰"; printf "%0.s─" {1..$MAX}; printf "╯\n"
}
