echo "txt-of-xml:"

./compilation/nmm-ocaml txt-of-xml example_input/simple.xml > example_output/simple.txt
./compilation/nmm-ocaml txt-of-xml example_input/blks.xml > example_output/blks.txt
./compilation/nmm-ocaml txt-of-xml example_input/pars.xml > example_output/pars.txt
./compilation/nmm-ocaml txt-of-xml example_input/secs.xml > example_output/secs.txt
./compilation/nmm-ocaml txt-of-xml example_input/special_blks.xml > example_output/special_blks.txt
./compilation/nmm-ocaml txt-of-xml example_input/optimal_partitioning.xml > example_output/optimal_partitioning.txt


#echo "html-of-xml:"

echo "html-of-xml:"

./compilation/nmm-ocaml html-of-xml "html.css" "en" example_input/simple.xml > example_output/simple.html
./compilation/nmm-ocaml html-of-xml "html.css" "en" example_input/blks.xml > example_output/blks.html
./compilation/nmm-ocaml html-of-xml "html.css" "en" example_input/pars.xml > example_output/pars.html
./compilation/nmm-ocaml html-of-xml "html.css" "en" example_input/secs.xml > example_output/secs.html
./compilation/nmm-ocaml html-of-xml "html.css" "en" example_input/special_blks.xml > example_output/special_blks.html
./compilation/nmm-ocaml html-of-xml "html.css" "en" example_input/optimal_partitioning.xml > example_output/optimal_partitioning.html
cp css/html.css example_output/html.css

echo "check-xml-schema:"

./compilation/nmm-ocaml check-xml-schema dtd/axml.dtd

echo "validate-xml:"

./compilation/nmm-ocaml validate-xml dtd/axml.dtd "cr_doc" example_input/simple.xml
./compilation/nmm-ocaml validate-xml dtd/axml.dtd "cr_doc" example_input/blks.xml
./compilation/nmm-ocaml validate-xml dtd/axml.dtd "cr_doc" example_input/pars.xml
./compilation/nmm-ocaml validate-xml dtd/axml.dtd "cr_doc" example_input/secs.xml
./compilation/nmm-ocaml validate-xml dtd/axml.dtd "cr_doc" example_input/special_blks.xml
./compilation/nmm-ocaml validate-xml dtd/axml.dtd "cr_doc" example_input/optimal_partitioning.xml


