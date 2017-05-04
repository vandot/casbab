# Camel Snake Kebab

CLI "tool" and a bash "library" for converting representation style of compound words or phrases.
Inspired by and bash port of [casbab](https://github.com/janos/casbab).

[![Build Status](https://travis-ci.org/vandot/casbab.svg?branch=master)](https://travis-ci.org/vandot/casbab)

Supports '_', '-' or ' ' as a delimiter and case change inside string. Mixed usage of delimiters and case change is not supported. First delimiter that could be found is going to be used as a delimiter, case change is used only when there are no delimiters. Empty string input will return empty string.

## Installation

```sh
Git clone or copy paste casbab.sh
```

## Example usage

You can use casbab as a library and source it inside your script, send string as a argument or read it from stdin.

```sh
$ ./casbab.sh pascal Camel Snake Kebab
$ CamelSnakeKebab

$ echo camel-Snake-Kebab | ./casbab.sh camel
$ camelSnakeKebab

$ ./casbab.sh snake CamelSnakeKebab
$ camel_snake_kebab

$ echo Camel-Snake-keBaB | ./casbab.sh camelsnake
$ Camel_Snake_Kebab

$ ./casbab.sh screamingsnake camel____snake_kebab 
$ CAMEL_SNAKE_KEBAB

$ echo camelSNAKEKebab | ./casbab.sh kebab
$ camel-snake-kebab
  
$ ./casbab.sh camelkebab camel---snake-kebab
$ Camel-Snake-Kebab
  
$ echo "camel--SNAKE---Kebab" | ./casbab.sh screamingkebab 
$ CAMEL-SNAKE-KEBAB
  
$ ./casbab.sh lower CAmEL-SNaKE-KEbAB
$ camel snake kebab

$ echo camel_snake_kebab | ./casbab.sh title
$ Camel Snake Kebab

$ ./casbab.sh screaming camel_Snake____kebab
$ CAMEL SNAKE KEBAB
```