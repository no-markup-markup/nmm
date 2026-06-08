#! /usr/bin/env bash

cd "$(dirname "$0")"
exit_code=0
for nmm_file in ./test-data-nmm2txt/*.nmm; do
    nmm_output_file="$(mktemp)"
    expected_output_file="${nmm_file%.nmm}.txt"
    ./bin/nmm nmm2txt --margin 0 "$nmm_file" > "$nmm_output_file"
    diff --brief "$nmm_output_file" "$expected_output_file" > /dev/null
    if [[ "$?" -ne 0 ]]; then
        echo "output from"
        echo "  nmm nmm2txt $nmm_file"
        echo "differs from expected output in"
        echo "  $expected_output_file"
        exit_code=1
    fi
    nmm_output_file="$(mktemp)"
    expected_output_file="${nmm_file%.nmm}.txt"
    ./bin/nmm nmm2txt --parser-backend 'OCaml' --margin 0 "$nmm_file" > "$nmm_output_file"
    diff --brief "$nmm_output_file" "$expected_output_file" > /dev/null
    if [[ "$?" -ne 0 ]]; then
        echo "output from"
        echo "  nmm nmm2txt --parser-backend 'OCaml' $nmm_file"
        echo "differs from expected output in"
        echo "  $expected_output_file"
        exit_code=1
    fi
done
exit $exit_code
