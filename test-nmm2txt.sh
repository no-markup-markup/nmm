#! /usr/bin/env bash

cd "$(dirname "$0")"
exit_code=0
for nmm_file in ./test-data/*.nmm; do

    # Mercury backend
    if ! [[ $nmm_file == ./test-data/exclude-mercury_* || $nmm_file == ./test-data/exclude-all_* ]]; then
      nmm_output_file="$(mktemp)"
      expected_output_file="${nmm_file%.nmm}.txt"
      ./bin/nmm nmm2txt --margin 0 "$nmm_file" > "$nmm_output_file"
      diff --brief "$nmm_output_file" "$expected_output_file" > /dev/null
      if [[ "$?" -ne 0 ]]; then
          >&2 echo "output from"
          >&2 echo "  nmm nmm2txt --margin 0 $nmm_file"
          >&2 echo "differs from expected output in"
          >&2 echo "  $expected_output_file"
          exit_code=1
      fi
      rm "$nmm_output_file"
    else
      >&2 echo "warning: nmm2txt $nmm_file not tested for the Mercury backend"
    fi

    # OCaml backend
    if ! [[ $nmm_file == ./test-data/exclude-ocaml_* || $nmm_file == ./test-data/exclude-all_* ]]; then
      nmm_output_file="$(mktemp)"
      expected_output_file="${nmm_file%.nmm}.txt"
      ./bin/nmm nmm2txt --parser-backend 'OCaml' --margin 0 "$nmm_file" > "$nmm_output_file"
      diff --brief "$nmm_output_file" "$expected_output_file" > /dev/null
      if [[ "$?" -ne 0 ]]; then
          >&2 echo "output from"
          >&2 echo "  nmm nmm2txt --margin 0 --parser-backend 'OCaml' $nmm_file"
          >&2 echo "differs from expected output in"
          >&2 echo "  $expected_output_file"
          exit_code=1
      fi
      rm "$nmm_output_file"
    else
      >&2 echo "warning: nmm2txt $nmm_file not tested for the OCaml backend"
    fi
done
exit $exit_code
