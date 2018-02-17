#!/bin/sh

cd "$(dirname "$0")"
test -d ./lib || exit 20
prove -I./lib
