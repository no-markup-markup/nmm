#! /usr/bin/env bash

set -eo pipefail

_nmm_ocaml_insert_images() {
	sed 's/\&lt;\([^ ]\+\).\(jpg\|png\|svg\|webp\|gif\)\&gt;/<img class="inserted_image" alt="Image source is \1.\2" src="\1.\2">/g' $1
}

_nmm_ocaml_insert_links() {
	sed 's/\&lt;\(https\?:\/\/\)\([^ ]\+\)\&gt;/<a class="inserted_link" href="\1\2">\2<\/a>/g' $1
}

_nmm_ocaml_make_html () {
	local temp=$(mktemp)
	nmm-ocaml html-of-nmm $@ | _nmm_ocaml_insert_images | _nmm_ocaml_insert_links > $temp
	local exit_code=$?

	case $exit_code in
		0)
			mv $temp $(basename -s .nmm ${@: -1}).html
			;;
		*)
			rm $temp
			return $exit_code
			;;
	esac
}

_nmm_ocaml_make_html $@

