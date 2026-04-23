#! /usr/bin/env bash

make_links() {
	sed 's/\(\&lt;\)\(https\?:\/\/\)\([^ ]\+\)\(\&gt;\)/<a href="\2\3">\3<\/a>/g' $1
}

nmm-ocaml html-of-nmm $@ | make_links > $(basename -s .nmm ${@: -1}).html
