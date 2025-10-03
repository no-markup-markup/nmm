src=example_input
dest=example_output

if [ -d $dest ]
then 
	rm -r $dest
fi
mkdir $dest


echo "txt-of-xml:"

./compilation/nmm-ocaml txt-of-xml $src/simple.xml > $dest/simple.txt
./compilation/nmm-ocaml txt-of-xml $src/blks.xml > $dest/blks.txt
./compilation/nmm-ocaml txt-of-xml $src/pars.xml > $dest/pars.txt
./compilation/nmm-ocaml txt-of-xml $src/secs.xml > $dest/secs.txt
./compilation/nmm-ocaml txt-of-xml $src/special_blks.xml > $dest/special_blks.txt
./compilation/nmm-ocaml txt-of-xml $src/optimal_partitioning.xml > $dest/optimal_partitioning.txt


#echo "html-of-xml:"

echo "html-of-xml:"

./compilation/nmm-ocaml html-of-xml "html.css" "en" $src/simple.xml > $dest/simple.html
./compilation/nmm-ocaml html-of-xml "html.css" "en" $src/blks.xml > $dest/blks.html
./compilation/nmm-ocaml html-of-xml "html.css" "en" $src/pars.xml > $dest/pars.html
./compilation/nmm-ocaml html-of-xml "html.css" "en" $src/secs.xml > $dest/secs.html
./compilation/nmm-ocaml html-of-xml "html.css" "en" $src/special_blks.xml > $dest/special_blks.html
./compilation/nmm-ocaml html-of-xml "html.css" "en" $src/optimal_partitioning.xml > $dest/optimal_partitioning.html
cp css/html.css $dest/html.css

echo "check-xml-schema:"

./compilation/nmm-ocaml check-xml-schema dtd/axml.dtd

echo "validate-xml:"

./compilation/nmm-ocaml validate-xml dtd/axml.dtd "cr_doc" $src/simple.xml
./compilation/nmm-ocaml validate-xml dtd/axml.dtd "cr_doc" $src/blks.xml
./compilation/nmm-ocaml validate-xml dtd/axml.dtd "cr_doc" $src/pars.xml
./compilation/nmm-ocaml validate-xml dtd/axml.dtd "cr_doc" $src/secs.xml
./compilation/nmm-ocaml validate-xml dtd/axml.dtd "cr_doc" $src/special_blks.xml
./compilation/nmm-ocaml validate-xml dtd/axml.dtd "cr_doc" $src/optimal_partitioning.xml


