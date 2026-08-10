#! /usr/bin/env bash

set -eo pipefail

html_of_nmm_insert_images () {
	sed 's/\&lt;\([^ ]\+\).\(jpg\|png\|svg\|webp\|gif\)\&gt;/<img class="inserted_image" alt="Image source is \1.\2" src="\1.\2">/g' $1
}

html_of_nmm_insert_url_links () {
	sed 's/\&lt;\(https\?:\/\/\)\([^ ]\+\)\&gt;/<a class="inserted_url_link" href="\1\2">\2<\/a>/g' $1
}

html_of_nmm_insert_mailto_links () {
	sed 's/\&lt;\(mailto:\)\([^ ]\+@[^ ]\+\)\&gt;/<a class="inserted_mailto_link" href="\1\2">\2<\/a>/g' $1
}

pdf_of_nmm_main () {
	local temp=$(mktemp)
	nmm-ocaml html-of-nmm $@ | html_of_nmm_insert_images | html_of_nmm_insert_url_links | html_of_nmm_insert_mailto_links | weasyprint - $temp
	local exit_code=$?

	case $exit_code in
		0)
			local filename="$(basename -s .nmm ${@: -1}).pdf"
			mv $temp $filename
			chmod 664 $filename
			;;
		*)
			rm $temp
			return $exit_code
			;;
	esac
}

pdf_of_nmm_main $@

