# shellcheck disable=SC2148
# shellcheck disable=SC1091

. ./casbab.sh

TEST_STRING=( "camelSnakeKebab" "CamelSnakeKebab" "camel_snake_kebab" "Camel_Snake_Kebab" "CAMEL_SNAKE_KEBAB" "camel-snake-kebab" "Camel-Snake-Kebab" "CAMEL-SNAKE-KEBAB" "camel__snake_kebab" "camel___snake_kebab" "camel____snake_kebab" "camel--snake-kebab" "camel---snake-kebab" "camel----snake-kebab" )

EMPTY_STRING=""

SPACE_STRING=" caMel   Snake keBab"

test_camel() {
  for string in "${TEST_STRING[@]}"; do
    actual=$(camel "$string")
    expected="camelSnakeKebab"
    assertEquals "string: $string" "$expected" "$actual"
  done
}

test_pascal() {
  for string in "${TEST_STRING[@]}"; do
    actual=$(pascal "$string")
    expected="CamelSnakeKebab"
    assertEquals "string: $string" "$expected" "$actual"
  done
}

test_snake() {
  for string in "${TEST_STRING[@]}"; do
    actual=$(snake "$string")
    expected="camel_snake_kebab"
    assertEquals "string: $string" "$expected" "$actual"
  done
}

test_camelsnake() {
  for string in "${TEST_STRING[@]}"; do
    actual=$(camelsnake "$string")
    expected="Camel_Snake_Kebab"
    assertEquals "string: $string" "$expected" "$actual"
  done
}

test_screamingsnake() {
  for string in "${TEST_STRING[@]}"; do
    actual=$(screamingsnake "$string")
    expected="CAMEL_SNAKE_KEBAB"
    assertEquals "string: $string" "$expected" "$actual"
  done
}

test_kebab() {
  for string in "${TEST_STRING[@]}"; do
    actual=$(kebab "$string")
    expected="camel-snake-kebab"
    assertEquals "string: $string" "$expected" "$actual"
  done
}

test_camelkebab() {
  for string in "${TEST_STRING[@]}"; do
    actual=$(camelkebab "$string")
    expected="Camel-Snake-Kebab"
    assertEquals "string: $string" "$expected" "$actual"
  done
}

test_screamingkebab() {
  for string in "${TEST_STRING[@]}"; do
    actual=$(screamingkebab "$string")
    expected="CAMEL-SNAKE-KEBAB"
    assertEquals "string: $string" "$expected" "$actual"
  done
}

test_lower() {
  for string in "${TEST_STRING[@]}"; do
    actual=$(lower "$string")
    expected="camel snake kebab"
    assertEquals "string: $string" "$expected" "$actual"
  done
}

test_title() {
  for string in "${TEST_STRING[@]}"; do
    actual=$(title "$string")
    expected="Camel Snake Kebab"
    assertEquals "string: $string" "$expected" "$actual"
  done
}

test_screaming() {
  for string in "${TEST_STRING[@]}"; do
    actual=$(screaming "$string")
    expected="CAMEL SNAKE KEBAB"
    assertEquals "string: $string" "$expected" "$actual"
  done
}

test_arg() {
  for string in "${TEST_STRING[@]}"; do
    actual=$(./casbab.sh snake "$string")
    expected="camel_snake_kebab"
    assertEquals "string: $string" "$expected" "$actual"
  done
}

test_stdin() {
  for string in "${TEST_STRING[@]}"; do
    actual=$(echo "$string" | ./casbab.sh camel)
    expected="camelSnakeKebab"
    assertEquals "string: $string" "$expected" "$actual"
  done
}

test_camel_space() {
  actual=$(camel "$SPACE_STRING")
  expected="camelSnakeKebab"
  assertEquals "$expected" "$actual"
}

test_arg_space() {
  actual=$(./casbab.sh snake "$SPACE_STRING")
  expected="camel_snake_kebab"
  assertEquals "$expected" "$actual"
}

test_stdin_space() {
  actual=$(echo "$SPACE_STRING" | ./casbab.sh pascal)
  expected="CamelSnakeKebab"
  assertEquals "$expected" "$actual"
}

test_camel_empty() {
  actual=$(camel "$EMPTY_STRING")
  expected=""
  assertEquals "$expected" "$actual"
}

test_arg_empty() {
  actual=$(./casbab.sh snake "$EMPTY_STRING")
  expected=""
  assertEquals "$expected" "$actual"
}

test_stdin_empty() {
  actual=$(echo "$EMPTY_STRING" | ./casbab.sh pascal)
  expected=""
  assertEquals "$expected" "$actual"
}

test_docker_camel() {
  for string in "${TEST_STRING[@]}"; do
    actual=$(docker run --rm vandot/casbab camel "$string")
    expected="camelSnakeKebab"
    assertEquals "string: $string" "$expected" "$actual"
  done
}

. shunit2-2.1.6/src/shunit2