#! /usr/bin/env bash

cd "$(dirname "$0")"
exit_code=0
for nmm_file in ./test-data-nmm2xml/*.nmm; do
    expected_output_file="${nmm_file%.nmm}.xml"
    ./bin/nmm-ocaml validate-xml ./specification/AST.dtd "$expected_output_file" > /dev/null 2>&1
    if [[ "$?" -ne 0 ]]; then
        >&2 echo "$expected_output_file does not conform to schema"
        >&2 echo "  ./specification/AST.dtd"
        >&2 echo "run"
        >&2 echo "  ./bin/nmm-ocaml validate-xml ./specification/AST.dtd $expected_output_file"
        >&2 echo "for further debugging"
        exit_code=1
        continue
    fi
    nmm_mercury_output_file="$(mktemp)"
    ./bin/nmm-mercury nmm2xml "$nmm_file" > "$nmm_mercury_output_file"
    ./bin/nmm-ocaml validate-xml ./specification/AST.dtd "$nmm_mercury_output_file" > /dev/null 2>&1
    if [[ "$?" -ne 0 ]]; then
        >&2 echo "output from"
        >&2 echo "  nmm-mercury nmm2xml $nmm_file"
        >&2 echo "does not conform to schema"
        >&2 echo "  ./specification/AST.dtd"
        >&2 echo "run"
        >&2 echo "  ./bin/nmm-ocaml validate-xml ./specification/AST.dtd $nmm_mercury_output_file"
        >&2 echo "for further debugging"
        exit_code=1
        continue
    fi
    xmldiff --check --ratio-mode faster "$nmm_mercury_output_file" "$expected_output_file" > /dev/null
    if [[ "$?" -ne 0 ]]; then
        >&2 echo "output from"
        >&2 echo "  nmm-mercury nmm2xml $nmm_file"
        >&2 echo "differs from expected output in"
        >&2 echo "  $expected_output_file"
        if [[ "$exit_code" -eq 0 ]]; then
            rm "$nmm_mercury_output_file"
        fi
        exit_code=1
    else
        if [[ "$exit_code" -eq 0 ]]; then
            rm "$nmm_mercury_output_file"
        fi
    fi
    nmm_ocaml_output_file="$(mktemp)"
    ./bin/nmm-ocaml axml-of-nmm "$nmm_file" > "$nmm_ocaml_output_file"
    ./bin/nmm-ocaml validate-xml ./specification/AST.dtd "$nmm_ocaml_output_file" > /dev/null 2>&1
    if [[ "$?" -ne 0 ]]; then
        >&2 echo "output from"
        >&2 echo "  nmm-ocaml axml-of-nmm $nmm_file"
        >&2 echo "does not conform to schema"
        >&2 echo "  ./specification/AST.dtd"
        >&2 echo "run"
        >&2 echo "  ./bin/nmm-ocaml validate-xml ./specification/AST.dtd $nmm_ocaml_output_file"
        >&2 echo "for further debugging"
        exit_code=1
    else
        rm "$nmm_ocaml_output_file"
    fi
done
exit $exit_code
