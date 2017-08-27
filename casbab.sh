#!/usr/bin/env bash

set -euo pipefail

#/
#/ Usage: 
#/ ./casbab.sh option [string]
#/ 
#/ Description:
#/ CLI "tool" and a bash "library" for converting representation style of compound words or phrases
#/ 
#/ Examples:
#/ Read from stdin
#/ $ echo camel-Snake-Kebab | ./casbab.sh camel
#/ $ camelSnakeKebab
#/
#/ Pass as a argument
#/ $ ./casbab.sh pascal Camel Snake Kebab
#/ $ CamelSnakeKebab
#/
#/ You can source this file and use it's functions
#/ camel camelSnakeKebab
#/
#/ Options:

usage() { grep '^#/' "$0" | cut -c4- ; exit 0 ; }
expr "$*" : ".*--help" > /dev/null && usage

detect() {
  # Return normalized string, all lower and with spaces as separators
  arg=( "${@:-}" )
  helper=""
  for i in '_' '-' ' '; do
    if [[ ${arg[*]} == *$i* ]]; then
      helper="yes"
      echo "${arg[*]}" | tr '[:upper:]' '[:lower:]' | tr -s "${i}" ' '
    fi
  done
  # If '_','-' and ' ' are not used as a separator try by case
  if [[ -z $helper ]] && [[ ${arg[0]} != '' ]]; then
    dif_case "${@:-}" | tr '[:upper:]' '[:lower:]'
  fi
}

check_case() {
  # Check char case
  if [[ ${1:-} == [[:upper:]] ]]; then
    echo 0
  elif [[ ${1:-} == [[:lower:]] ]]; then
    echo 1
  fi
}

dif_case() {
  # Parse string char by char
  arg=( "${@:-}" )
  helper=""
  for (( i=0; i<${#arg}; i++ )); do
    if [[ $i == 0 ]]; then
      helper="${arg:$i:1}"
    elif ([[ $(check_case "${arg:$i:1}") == 0 ]] && [[ $(check_case "${arg:((i+1)):1}") == 1 ]]) || ([[ $(check_case "${arg:$i:1}") == 0 ]] && [[ $(check_case "${arg:((i-1)):1}") == 1 ]]); then
      helper="${helper} ${arg:$i:1}"
    elif [[ $i == [^a-zA-Z] ]] || [[ $(check_case "${arg:$i:1}") == $(check_case "${arg:((i-1)):1}") ]] || ([[ $(check_case "${arg:$i:1}") == 1 ]] && [[ $(check_case "${arg:((i-1)):1}") == 0 ]]);then
      helper="${helper}${arg:$i:1}"
    else
      echo "Unknown character: ${arg:$i:1}"
      exit 1
    fi
  done
  echo "${helper}"
}

first_up() {
  # Set first letter upper in a single word
  helper=${1}
  echo "$(tr '[:lower:]' '[:upper:]' <<< "${helper:0:1}")${helper:1}"
}

camelcase() {
  # Set camel case with space separator
  arg=( $(detect "${@:-}") )
  if [[ ${#arg[@]} -eq 0 ]]; then
    echo ' '
    exit 0
  fi
  helper=""
  COUNTER=0
  for i in "${arg[@]}"; do
    if [[ $COUNTER == 0 ]]; then
      helper="$i"
    else
      helper="${helper} $(first_up "${i}")"
    fi
    COUNTER=$((COUNTER + 1))
  done
  echo "${helper}"
}

pascalcase() {
  # Set pascal case with space separator
  arg=( $(detect "${@:-}") )
  if [[ ${#arg[@]} -eq 0 ]]; then
    echo ' '
    exit 0
  fi
  helper=""
  COUNTER=0
  for i in "${arg[@]}"; do
    if [[ $COUNTER == 0 ]]; then
      helper=$(first_up "${i}")
    else
      helper="${helper} $(first_up "${i}")"
    fi
    COUNTER=$((COUNTER + 1))
  done
  echo "${helper}"
}

screamingcase() {
  # Set screaming case and keep space separator
  arg=( $(detect "${@:-}") )
  if [[ ${#arg[@]} -eq 0 ]]; then
    echo ' '
    exit 0
  fi
  echo "${arg[*]}" | tr '[:lower:]' '[:upper:]'
}

delete() {
  # Read from stdin and remove ' '
  cat | tr -d ' '
}

replace() {
  # Read from stdin and replace ' ' with $1
  cat | tr -s ' ' "${1}"
}

#/   camel returns "camelSnakeKebab"
camel() {
  camelcase "${@:-}" | delete
}

#/   pascal return "CamelSnakeKebab"
pascal() {
  pascalcase "${@:-}" | delete
}

#/   snake returns "camel_snake_kebab"
snake() {
  detect "${@:-}" | replace '_'
}

#/   camelsnake returns "Camel_Snake_Kebab"
camelsnake() {
  pascalcase "${@:-}" | replace '_'
}

#/   screamingsnake returns "CAMEL_SNAKE_KEBAB"
screamingsnake() {
  screamingcase "${@:-}" | replace '_'
}

#/   kebab returns "camel-snake-kebab"
kebab() {
  detect "${@:-}" | replace '-'
}

#/   camelkebab returns "Camel-Snake-Kebab"
camelkebab() {
  pascalcase "${@:-}" | replace '-'
}

#/   screamingkebab returns "CAMEL-SNAKE-KEBAB"
screamingkebab() {
  screamingcase "${@:-}" | replace '-'
}

#/   lower returns "camel snake kebab"
lower() {
  detect "${@:-}"
}

#/   title returns "Camel Snake Kebab"
title() {
  pascalcase "${@:-}"
}

#/   screaming returns "CAMEL SNAKE KEBAB"
screaming() {
  screamingcase "${@:-}"
}

#/
#/   --help: Display this help message
#/

if [[ "${BASH_SOURCE[0]}" = "$0" ]]; then

  arg=( "${@:2}" )

  if [[ -t 0 && -z ${arg[*]} ]]; then
    if [[ ${#arg[*]} -eq 1 ]]; then
      arg[0]=' '
    else
      usage
    fi 
  fi
  
  arg=( ${arg:-$(cat -)} )

  case ${1:-} in
    camel)
      camel "${arg[*]:-""}"
    ;;
    pascal)
      pascal "${arg[*]:-""}"
    ;;
    snake)
      snake "${arg[*]:-""}"
    ;;
    camelsnake)
      camelsnake "${arg[*]:-""}"
    ;;
    screamingsnake)
      screamingsnake "${arg[*]:-""}"
    ;;
    kebab)
      kebab "${arg[*]:-""}"
    ;;
    camelkebab)
      camelkebab "${arg[*]:-""}"
    ;;
    screamingkebab)
      screamingkebab "${arg[*]:-""}"
    ;;
    lower)
      lower "${arg[*]:-""}"
    ;;
    title)
      title "${arg[*]:-""}"
    ;;
    screaming)
      screaming "${arg[*]:-""}"
    ;;
    *)
      usage
    ;;
  esac
fi