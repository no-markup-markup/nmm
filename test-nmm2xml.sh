#! /usr/bin/env bash

cd "$(dirname "$0")"
exit_code=0
for nmm_file in ./test-data/*.nmm; do
    expected_output_file="${nmm_file%.nmm}.xml"

    # tmp files
    nmm_ocaml_output_file="$(mktemp)"
    nmm_mercury_output_file="$(mktemp)"
    nmm_mercury_normalized_output_file="$(mktemp)"
    nmm_ocaml_normalized_output_file="$(mktemp)"

    # check that expected output conforms to schema
    ./bin/nmm validate-xml "$expected_output_file" > /dev/null 2>&1
    if [[ "$?" -ne 0 ]]; then
        >&2 echo "$expected_output_file does not conform to schema"
        exit_code=1
        # remove created tmp files
        rm "$nmm_mercury_output_file"
        rm "$nmm_ocaml_output_file"
        rm "$nmm_mercury_normalized_output_file"
        rm "$nmm_ocaml_normalized_output_file"
        continue
    fi

    # check that output from mercury backend is as expected
    ./bin/nmm nmm2xml --parser-backend Mercury "$nmm_file" > "$nmm_mercury_output_file"
    ./bin/nmm validate-xml "$nmm_mercury_output_file" > /dev/null 2>&1
    if [[ "$?" -ne 0 ]]; then
        >&2 echo "output from"
        >&2 echo "  nmm nmm2xml --parser-backend Mercury $nmm_file"
        >&2 echo "does not conform to schema"
        exit_code=1
    else
      xmldiff --check --ratio-mode faster "$nmm_mercury_output_file" "$expected_output_file" > /dev/null 2>&1
      if [[ "$?" -ne 0 ]]; then
          >&2 echo "output from"
          >&2 echo "  nmm nmm2xml --parser-backend Mercury $nmm_file"
          >&2 echo "differs from expected output in"
          >&2 echo "  $expected_output_file"
          exit_code=1
      fi
    fi

    # check that output from ocaml backend is as expected
    ./bin/nmm nmm2xml --parser-backend OCaml "$nmm_file" > "$nmm_ocaml_output_file"
    ./bin/nmm validate-xml "$nmm_ocaml_output_file" > /dev/null 2>&1
    if [[ "$?" -ne 0 ]]; then
        >&2 echo "output from"
        >&2 echo "  nmm nmm2xml --parser-backend OCaml $nmm_file"
        >&2 echo "does not conform to schema"
        exit_code=1
    else
      xmldiff --check --ratio-mode faster "$nmm_ocaml_output_file" "$expected_output_file" > /dev/null 2>&1
      if [[ "$?" -ne 0 ]]; then
          >&2 echo "output from"
          >&2 echo "  nmm nmm2xml --parser-backend OCaml $nmm_file"
          >&2 echo "differs from expected output in"
          >&2 echo "  $expected_output_file"
          exit_code=1
      fi
    fi

    # check that mercury and ocaml output normalizes to the same XML
    if [[ "$exit_code" -eq 0 ]]; then
      ./bin/nmm normalize-xml "$nmm_mercury_output_file" > "$nmm_mercury_normalized_output_file"
      ./bin/nmm normalize-xml "$nmm_ocaml_output_file"   > "$nmm_ocaml_normalized_output_file"
      xmldiff --check --ratio-mode faster "$nmm_mercury_normalized_output_file" "$nmm_ocaml_normalized_output_file" > /dev/null 2>&1
      if [[ "$?" -ne 0 ]]; then
          >&2 echo "output from"
          >&2 echo "  nmm nmm2xml --parser-backend Mercury $nmm_file"
          >&2 echo "does not normalize to the same XML as output from"
          >&2 echo "  nmm nmm2xml --parser-backend OCaml   $nmm_file"
          exit_code=1
      fi
    fi

    # remove created tmp files
    rm "$nmm_mercury_output_file"
    rm "$nmm_ocaml_output_file"
    rm "$nmm_mercury_normalized_output_file"
    rm "$nmm_ocaml_normalized_output_file"
done

# verify that nmm normalize-xml does not test OK for trivial reasons
tmp_normalized_xml_1="$(mktemp)"
tmp_normalized_xml_2="$(mktemp)"
./bin/nmm normalize-xml ./test-data/simple.xml     > "$tmp_normalized_xml_1"
./bin/nmm normalize-xml ./test-data/tagged_itm.xml > "$tmp_normalized_xml_2"
diff -q "$tmp_normalized_xml_1" "$tmp_normalized_xml_2" > /dev/null
if [[ "$?" -eq 0 ]]; then
  >&2 echo "  ./bin/nmm normalize-xml ./test-data/simple.xml"
  >&2 echo "and"
  >&2 echo "  ./bin/nmm normalize-xml ./test-data/tagged_itm.xml"
  >&2 echo "gives the same output"
  exit_code=1
fi
rm "$tmp_normalized_xml_1"
rm "$tmp_normalized_xml_2"

exit $exit_code
