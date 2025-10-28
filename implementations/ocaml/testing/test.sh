#! /usr/bin/env bash

#set -e

color(){
	printf "\e[36m%s\e[0m\n" "$1"
}

../bin/nmm-ocaml show-default-css > css/default.css

if [ -d output ]
then
		rm -r output
fi

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

color "# nmm-ocaml check-xml-schema ../dtd/axml.dtd > /dev/null:"
../bin/nmm-ocaml check-xml-schema dtd/axml.dtd > /dev/null
color "# nmm-ocaml check-xml-schema ../dtd/exml.dtd > /dev/null:"
../bin/nmm-ocaml check-xml-schema dtd/exml.dtd > /dev/null

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


for file in $(ls output)
do
	color "# diff expected_output/$file output/$file:"
	diff --color expected_output/$file output/$file 
done

if [ -d weasyprint_output ]
then
	rm -r weasyprint_output
fi

mkdir weasyprint_output

weasyprint output/cv_eric_johannesson.nmm.html weasyprint_output/cv_eric_johannesson.nmm.html.pdf
weasyprint output/talk.xml.html weasyprint_output/talk.xml.html.pdf
