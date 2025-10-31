#! /usr/bin/env bash

#set -e


color(){
	printf "\e[35m%s\e[0m\n" "$1"
}

show_default_css(){
	../bin/nmm-ocaml show-default-css > css/default.css
}

test_w_nmm(){
	mkdir -p output
	for file in $(ls input/*.nmm)
	do
		color "# nmm-ocaml txt-of-nmm $file > output/$(basename $file).txt:"
		../bin/nmm-ocaml txt-of-nmm $file > output/$(basename $file).txt
		color "# nmm-ocaml html-of-nmm none en $file > output/$(basename $file).html:"
		../bin/nmm-ocaml html-of-nmm none en $file > output/$(basename $file).html
		color "# nmm-ocaml xml-of-nmm $file > output/$(basename $file).xml:"
		../bin/nmm-ocaml xml-of-nmm $file > output/$(basename $file).xml
		color "# nmm-ocaml test-with-nmm $file:"
		../bin/nmm-ocaml test-with-nmm $file
	done
}

test_w_xml(){
	mkdir -p output
	for file in $(ls input/*.xml)
	do
		color "# nmm-ocaml txt-of-xml $file > output/$(basename $file).txt:"
		../bin/nmm-ocaml txt-of-xml $file > output/$(basename $file).txt
		color "# nmm-ocaml html-of-xml none en $file 1 output/$(basename $file).html:"
		../bin/nmm-ocaml html-of-xml none en $file > output/$(basename $file).html
		color "# nmm-ocaml html-of-xml ../css/external.css en $file > output/$(basename $file).color.html:"
		../bin/nmm-ocaml html-of-xml ../css/external.css en $file > output/$(basename $file).w_external_css.html
		color "# nmm-ocaml test-with-xml $file:"
		../bin/nmm-ocaml test-with-xml $file
	done
}

check_xml_schema(){
	color "# nmm-ocaml check-xml-schema ../dtd/axml.dtd > /dev/null:"
	../bin/nmm-ocaml check-xml-schema dtd/axml.dtd > /dev/null
	color "# nmm-ocaml check-xml-schema ../dtd/exml.dtd > /dev/null:"
	../bin/nmm-ocaml check-xml-schema dtd/exml.dtd > /dev/null
}

validate_xml(){
	for file in $(ls output/*.xml)
	do
		color "# nmm-ocaml validate-xml ../dtd/axml.dtd $file > /dev/null:"
		../bin/nmm-ocaml validate-xml dtd/axml.dtd $file > /dev/null
	done

	for file in $(ls input/*.xml)
	do
		color "# nmm-ocaml validate-xml ../dtd/axml.dtd $file > /dev/null:"
		../bin/nmm-ocaml validate-xml dtd/axml.dtd $file > /dev/null
	done
}

show_diff(){
	for file in $(ls output)
	do
		color "# diff expected_output/$file output/$file:"
		diff --color expected_output/$file output/$file 
	done
}

make_pdf(){
	mkdir -p weasyprint_output

	weasyprint output/cv_eric_johannesson.nmm.html weasyprint_output/cv_eric_johannesson.nmm.html.pdf
	weasyprint output/talk.xml.html weasyprint_output/talk.xml.html.pdf
}


test_w_nmm

test_w_xml

check_xml_schema

validate_xml

show_diff

make_pdf
