#! /usr/bin/env bash

set -eo pipefail

_nmm_ocaml_make_txt () {
	local temp=$(mktemp)
	nmm-ocaml txt-of-nmm $@ > $temp
	local exit_code=$?

	case $exit_code in
		0)
			mv $temp $(basename -s .nmm ${@: -1}).txt
			;;
		*)
			rm $temp
			return $exit_code
			;;
	esac
}

_nmm_ocaml_make_txt $@

