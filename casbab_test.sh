#!/usr/bin/env bash
# Run: SHUNIT2=/path/to/shunit2 bash casbab_test.sh
# shellcheck disable=SC1090,SC1091,SC2317

. ./casbab.sh

TEST_STRING=( "camelSnakeKebab" "CamelSnakeKebab" "camel_snake_kebab" "Camel_Snake_Kebab" "CAMEL_SNAKE_KEBAB" "camel-snake-kebab" "Camel-Snake-Kebab" "CAMEL-SNAKE-KEBAB" "camel__snake_kebab" "camel___snake_kebab" "camel____snake_kebab" "camel--snake-kebab" "camel---snake-kebab" "camel----snake-kebab" "camel_snake-kebab" "camel-_ snake kebab" "camelSNAKEKebab" "_camel_snake_kebab_" )

EMPTY_STRING=""

SPACE_STRING=" caMel   Snake keBab"

# assert_style <style> <expected>: every TEST_STRING converts to <expected>
assert_style() {
  local string
  for string in "${TEST_STRING[@]}"; do
    assertEquals "$1: $string" "$2" "$("casbab_$1" "$string")"
  done
}

test_camel()          { assert_style camel          "camelSnakeKebab"; }
test_pascal()         { assert_style pascal         "CamelSnakeKebab"; }
test_snake()          { assert_style snake          "camel_snake_kebab"; }
test_camelsnake()     { assert_style camelsnake     "Camel_Snake_Kebab"; }
test_screamingsnake() { assert_style screamingsnake "CAMEL_SNAKE_KEBAB"; }
test_kebab()          { assert_style kebab          "camel-snake-kebab"; }
test_camelkebab()     { assert_style camelkebab     "Camel-Snake-Kebab"; }
test_screamingkebab() { assert_style screamingkebab "CAMEL-SNAKE-KEBAB"; }
test_lower()          { assert_style lower          "camel snake kebab"; }
test_title()          { assert_style title          "Camel Snake Kebab"; }
test_screaming()      { assert_style screaming      "CAMEL SNAKE KEBAB"; }

test_acronyms_and_digits() {
  assertEquals "http_server"     "$(casbab_snake HTTPServer)"
  assertEquals "parse_json2_yaml" "$(casbab_snake parseJSON2Yaml)"
  assertEquals "user_id_v2"      "$(casbab_snake user_id-v2)"
  assertEquals "a"               "$(casbab_snake a)"
  assertEquals "A"               "$(casbab_pascal a)"
}

test_no_glob_expansion() {
  local dir
  dir=$(mktemp -d)
  touch "$dir/camelXsnake"
  assertEquals "camel*snake" "$(cd "$dir" && casbab_snake 'camel*snake')"
  rm -rf "$dir"
}

test_sourcing_is_safe() {
  # Sourcing must not change the caller's shell options or exit it.
  assertEquals "still alive" "$(bash -c 'set +eu; . ./casbab.sh; casbab_camel "" >/dev/null; [[ $- != *e* && $- != *u* ]] && echo "still alive"')"
}

test_arg() {
  local string
  for string in "${TEST_STRING[@]}"; do
    assertEquals "string: $string" "camel_snake_kebab" "$(./casbab.sh snake "$string")"
  done
}

test_multiple_args() {
  assertEquals "CamelSnakeKebab" "$(./casbab.sh pascal Camel Snake Kebab)"
}

test_stdin() {
  local string
  for string in "${TEST_STRING[@]}"; do
    assertEquals "string: $string" "camelSnakeKebab" "$(echo "$string" | ./casbab.sh camel)"
  done
}

test_stdin_multiline() {
  assertEquals "$(printf 'foo_bar\nbaz_qux')" "$(printf 'fooBar\nBazQux\n' | ./casbab.sh snake)"
}

test_camel_space() { assertEquals "camelSnakeKebab"   "$(casbab_camel "$SPACE_STRING")"; }
test_arg_space()   { assertEquals "camel_snake_kebab" "$(./casbab.sh snake "$SPACE_STRING")"; }
test_stdin_space() { assertEquals "CamelSnakeKebab"   "$(echo "$SPACE_STRING" | ./casbab.sh pascal)"; }

test_camel_empty() { assertEquals "" "$(casbab_camel "$EMPTY_STRING")"; }
test_arg_empty()   { assertEquals "" "$(./casbab.sh snake "$EMPTY_STRING")"; }
test_stdin_empty() { assertEquals "" "$(echo "$EMPTY_STRING" | ./casbab.sh pascal)"; }

test_help() {
  ./casbab.sh --help | grep -q '^Usage:'
  assertTrue "--help prints usage and exits 0" $?
}

test_unknown_style() {
  ./casbab.sh nope foo >/dev/null 2>&1
  assertEquals "unknown style exits 2" 2 $?
}

. "${SHUNIT2:-./shunit2}"
