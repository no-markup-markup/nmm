#! /usr/bin/env bash

#set -e


color(){
	printf "\e[35m%s\e[0m\n" "$1"
}

show_default_css(){
	./bin/nmm-ocaml show-default-css > testing/css/default.css
}

test_w_nmm(){
	mkdir -p testing/output
	for file in $(ls testing/input/*.nmm)
	do
		./bin/nmm-ocaml test-with-nmm $(basename $file)
	done
}

test_w_xml(){
	mkdir -p testing/output
	for file in $(ls testing/input/*.xml)
	do
		./bin/nmm-ocaml test-with-xml $(basename $file)
	done
}

add_newlines(){
	for file in $(ls testing/output)
	do 
		echo "" >> testing/output/$file
	done
}

show_diff(){
	for file in $(ls testing/output)
	do
		diff --color testing/expected_output/$file testing/output/$file 
	done
}

make_pdf(){
	mkdir -p testing/weasyprint_output

	weasyprint testing/output/cv_eric_johannesson.nmm.html testing/weasyprint_output/cv_eric_johannesson.nmm.html.pdf
	weasyprint testing/output/talk_w_blk_vrb.xml.html testing/weasyprint_output/talk_w_blk_vrb.xml.html.pdf
}

show_default_css

test_w_nmm

test_w_xml

add_newlines

show_diff

make_pdf
