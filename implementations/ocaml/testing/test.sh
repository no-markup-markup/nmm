
mkdir -p output

for file in $(ls input/*.nmm)
do
	echo $file:
	../bin/nmm-ocaml txt-of-nmm $file > output/$(basename $file).txt
	../bin/nmm-ocaml html-of-nmm "../../css/html.css" "en" $file > output/$(basename $file).html
	../bin/nmm-ocaml exml-of-nmm "../../css/exml.css" $file > output/$(basename $file).e.xml
	../bin/nmm-ocaml axml-of-nmm $file > output/$(basename $file).a.xml

	../bin/nmm-ocaml test $file
done

for file in $(ls input/*.a.xml)
do
	echo $file:
	../bin/nmm-ocaml txt-of-axml $file > output/$(basename $file).txt
	../bin/nmm-ocaml html-of-axml "../../css/html.css" "en" $file > output/$(basename $file).html
	../bin/nmm-ocaml exml-of-axml "../../css/exml.css" $file > output/$(basename $file).e.xml
done

echo "diff expected_output output:"
diff --color expected_output output
