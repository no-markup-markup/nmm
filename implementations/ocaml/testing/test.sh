
mkdir -p output

for file in $(ls input/*.nmm)
do
	echo $file:
	../bin/nmm-ocaml txt-of-nmm $file > output/$(basename $file).txt
	../bin/nmm-ocaml html-of-nmm none en $file > output/$(basename $file).html
	../bin/nmm-ocaml xml-of-nmm $file > output/$(basename $file).xml

	../bin/nmm-ocaml test $file
done

for file in $(ls input/*.xml)
do
	echo $file:
	../bin/nmm-ocaml txt-of-xml $file > output/$(basename $file).txt
	../bin/nmm-ocaml html-of-xml none en $file > output/$(basename $file).html
done

echo "diff output expected_output:"
diff --color output expected_output
