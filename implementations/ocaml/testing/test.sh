#! /usr/bin/env bash

mkdir -p output

for file in $(ls input/*.nmm)
do
	echo "# nmm-ocaml txt-of-nmm $file > output/$(basename $file).txt:"
	../bin/nmm-ocaml txt-of-nmm $file > output/$(basename $file).txt
	echo "# nmm-ocaml html-of-nmm none en $file > output/$(basename $file).html:"
	../bin/nmm-ocaml html-of-nmm none en $file > output/$(basename $file).html
	echo "# nmm-ocaml xml-of-nmm $file > output/$(basename $file).xml:"
	../bin/nmm-ocaml xml-of-nmm $file > output/$(basename $file).xml
	echo "# nmm-ocaml test-with-nmm $file:"
	../bin/nmm-ocaml test-with-nmm $file
done

for file in $(ls input/*.xml)
do
	echo "# nmm-ocaml txt-of-xml $file > output/$(basename $file).txt:"
	../bin/nmm-ocaml txt-of-xml $file > output/$(basename $file).txt
	echo "# nmm-ocaml html-of-xml none en $file > output/$(basename $file).html:"
	../bin/nmm-ocaml html-of-xml none en $file > output/$(basename $file).html
	echo "# nmm-ocaml html-of-xml ../css/external.css en $file > output/$(basename $file).color.html:"
	../bin/nmm-ocaml html-of-xml ../css/external.css en $file > output/$(basename $file).w_external_css.html
	echo "# nmm-ocaml test-with-xml $file:"
	../bin/nmm-ocaml test-with-xml $file

done

echo "# nmm-ocaml check-xml-schema ../dtd/axml.dtd:"
../bin/nmm-ocaml check-xml-schema dtd/axml.dtd

for file in $(ls output/*.xml)
do
	echo "# nmm-ocaml validate-xml ../dtd/axml.dtd cr_doc $file:"
	../bin/nmm-ocaml validate-xml dtd/axml.dtd cr_doc $file
done

for file in $(ls input/*.xml)
do
	echo "# nmm-ocaml validate-xml ../dtd/axml.dtd cr_doc $file:"
	../bin/nmm-ocaml validate-xml dtd/axml.dtd cr_doc $file
done


for file in $(ls output)
do
	echo "# diff expected_output/$file output/$file:"
	diff --color expected_output/$file output/$file 
done
