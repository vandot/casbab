#!/usr/bin/env bash
#
#/ Usage:
#/   casbab.sh <style> [words...]
#/   ... | casbab.sh <style>          (converts stdin line by line)
#/
#/ Description:
#/   CLI tool and bash library for converting the representation style
#/   of compound words or phrases.
#/
#/ Examples:
#/   $ ./casbab.sh pascal Camel Snake Kebab
#/   CamelSnakeKebab
#/   $ echo camel-Snake-Kebab | ./casbab.sh camel
#/   camelSnakeKebab
#/
#/ As a library (bash 3.2+):
#/   source casbab.sh
#/   casbab_snake camelSnakeKebab        # camel_snake_kebab
#/
#/ Styles:
#/   camel           camelSnakeKebab
#/   pascal          CamelSnakeKebab
#/   snake           camel_snake_kebab
#/   camelsnake      Camel_Snake_Kebab
#/   screamingsnake  CAMEL_SNAKE_KEBAB
#/   kebab           camel-snake-kebab
#/   camelkebab      Camel-Snake-Kebab
#/   screamingkebab  CAMEL-SNAKE-KEBAB
#/   lower           camel snake kebab
#/   title           Camel Snake Kebab
#/   screaming       CAMEL SNAKE KEBAB
#/
#/ Word splitting:
#/   If the input contains any of '_', '-' or whitespace, those (in any mix
#/   and any run length) are the word boundaries. Otherwise words are split
#/   on case changes, keeping acronyms together (HTTPServer -> http server).
#/
#/ Options:
#/   -h, --help  Show this help

# Nothing here changes shell options or calls `exit` unless the file is run
# directly, so sourcing it is safe. Public functions are prefixed casbab_.

CASBAB_STYLES="camel pascal snake camelsnake screamingsnake kebab camelkebab screamingkebab lower title screaming"

# Print the input as lowercase, single-space-separated words, one line per
# input line. Takes the words as arguments, or reads stdin when given none.
_casbab_words() {
  {
    if (( $# )); then printf '%s\n' "$*"; else cat; fi
  } | sed -E '
    /[-_[:space:]]/!{
      s/([[:lower:][:digit:]])([[:upper:]])/\1 \2/g
      s/([[:upper:]]+)([[:upper:]][[:lower:]])/\1 \2/g
    }
    s/[-_[:space:]]+/ /g
    s/^ //
    s/ $//
  ' | tr '[:upper:]' '[:lower:]'
}

# Join the words read from stdin.
#   $1  case of the first word: l (lower), t (Title), U (UPPER)
#   $2  case of the remaining words
#   $3  separator
_casbab_format() {
  awk -v first="$1" -v rest="$2" -v sep="$3" '
    function fmt(w, mode) {
      if (mode == "U") return toupper(w)
      if (mode == "t") return toupper(substr(w, 1, 1)) substr(w, 2)
      return w
    }
    {
      out = ""
      for (i = 1; i <= NF; i++) out = out (i > 1 ? sep : "") fmt($i, i == 1 ? first : rest)
      print out
    }'
}

casbab_camel()          { _casbab_words "$@" | _casbab_format l t ''; }
casbab_pascal()         { _casbab_words "$@" | _casbab_format t t ''; }
casbab_snake()          { _casbab_words "$@" | _casbab_format l l '_'; }
casbab_camelsnake()     { _casbab_words "$@" | _casbab_format t t '_'; }
casbab_screamingsnake() { _casbab_words "$@" | _casbab_format U U '_'; }
casbab_kebab()          { _casbab_words "$@" | _casbab_format l l '-'; }
casbab_camelkebab()     { _casbab_words "$@" | _casbab_format t t '-'; }
casbab_screamingkebab() { _casbab_words "$@" | _casbab_format U U '-'; }
casbab_lower()          { _casbab_words "$@" | _casbab_format l l ' '; }
casbab_title()          { _casbab_words "$@" | _casbab_format t t ' '; }
casbab_screaming()      { _casbab_words "$@" | _casbab_format U U ' '; }

_casbab_usage() {
  grep '^#/' "${BASH_SOURCE[0]}" | cut -c4-
}

_casbab_main() {
  local style=${1:-}

  if [[ $style == -h || $style == --help ]]; then
    _casbab_usage
    return 0
  fi
  if [[ -z $style || " $CASBAB_STYLES " != *" $style "* ]]; then
    [[ -z $style ]] || echo "casbab: unknown style '$style'" >&2
    _casbab_usage >&2
    return 2
  fi
  shift

  if (( $# )); then
    "casbab_$style" "$@"
  elif [[ ! -t 0 ]]; then
    "casbab_$style"
  else
    echo "casbab: no input (pass words as arguments or pipe them in)" >&2
    return 2
  fi
}

if [[ ${BASH_SOURCE[0]} == "$0" ]]; then
  set -euo pipefail
  _casbab_main "$@"
fi
