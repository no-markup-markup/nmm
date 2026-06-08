#! /usr/bin/env bash

make_subset_font_css_main () {
	local input_ttf_file=$1
	local input_nmm_file=$2
	local temp_txt_file=$(mktemp)
	local temp_ttf_file=$(mktemp)
	nmm-ocaml txt-of-nmm ${input_nmm_file} > ${temp_txt_file}
	local unicodes=$(iconv -f utf8 -t ucs2 ${temp_txt_file} | hexdump -v -e '/2 "%04x "' | sort -u -t ' ')
	pyftsubset ${input_ttf_file} --unicodes="${unicodes}" --output-file="${temp_ttf_file}"
	local output_font_base64=$(base64 --wrap=0 ${temp_ttf_file})
	rm ${temp_txt_file} ${temp_ttf_file}
	echo "
@font-face {
  font-family: custom-subset;
  src: url(data:font/ttf;base64,${output_font_base64}) format('truetype');
}

html {
  font-family : custom-subset;
}
"
}


if [ $# -ne 2 ]
then
	echo "USAGE:"
	echo "  make-subset-font-css <path-to-ttf-file> <path-to-nmm-file>"
	exit 1
else
	make_subset_font_css_main $1 $2
fi
