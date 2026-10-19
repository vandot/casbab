# Camel Snake Kebab

CLI tool and bash library for converting the representation style of compound words or phrases.
Inspired by and a bash port of [casbab](https://github.com/janos/casbab).

[![CI](https://github.com/vandot/casbab/actions/workflows/ci.yml/badge.svg)](https://github.com/vandot/casbab/actions/workflows/ci.yml)
[![Docker Pulls](https://img.shields.io/docker/pulls/vandot/casbab.svg)](https://hub.docker.com/r/vandot/casbab/)

Works with bash 3.2+ (including the stock macOS bash) and only needs `sed`, `awk` and `tr`.

## Word splitting

- If the input contains any of `_`, `-` or whitespace, those are the word boundaries, in any mix and any run length (`camel-_ snake kebab` is three words).
- Otherwise words are split on case changes, keeping acronyms together (`HTTPServer` → `http server`, `parseJSON2Yaml` → `parse json2 yaml`).
- Empty input returns empty output.

## Installation

```sh
curl -fsSLo ~/.local/bin/casbab https://raw.githubusercontent.com/vandot/casbab/master/casbab.sh
chmod +x ~/.local/bin/casbab
```

Or `git clone`, or `docker pull vandot/casbab`.

## CLI usage

Pass words as arguments, or pipe them in. Stdin is converted line by line.

```console
$ casbab pascal Camel Snake Kebab
CamelSnakeKebab

$ echo camel-Snake-Kebab | casbab camel
camelSnakeKebab

$ casbab snake HTTPServerError
http_server_error

$ echo Camel-Snake-keBaB | casbab camelsnake
Camel_Snake_Kebab

$ casbab screamingsnake camel____snake-kebab
CAMEL_SNAKE_KEBAB

$ echo camelSNAKEKebab | casbab kebab
camel-snake-kebab

$ casbab camelkebab camel---snake-kebab
Camel-Snake-Kebab

$ printf 'fooBar\nBazQux\n' | casbab screamingkebab
FOO-BAR
BAZ-QUX

$ casbab lower CAmEL-SNaKE-KEbAB
camel snake kebab

$ echo camel_snake_kebab | casbab title
Camel Snake Kebab

$ casbab screaming camel_Snake____kebab
CAMEL SNAKE KEBAB

$ docker run --rm vandot/casbab pascal CamelSNAKEKebab
CamelSnakeKebab
```

`casbab --help` lists all styles. Unknown styles or missing input exit with status 2.

## Library usage

Sourcing is side-effect free: it doesn't change your shell options or exit your script.
Every style is available as a `casbab_<style>` function, taking arguments or stdin.

```bash
source casbab.sh

casbab_snake "camelSnakeKebab"     # camel_snake_kebab
var=$(casbab_pascal "my-var-name") # MyVarName
ls | casbab_kebab                  # one converted line per file name
```

> **Upgrading from the old version:** library functions used to be unprefixed
> (`camel`, `snake`, `lower`, ...). They are now `casbab_camel`, `casbab_snake`, etc.
> to avoid clobbering commands and functions in the sourcing shell. CLI usage is unchanged.

## Tests

```sh
git clone --depth 1 --branch v2.1.8 https://github.com/kward/shunit2
bash casbab_test.sh
shellcheck casbab.sh casbab_test.sh
```
