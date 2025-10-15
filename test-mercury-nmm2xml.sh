#! /usr/bin/env bash

cd "$(dirname "$0")"
exit_code=0
for nmm_file in ./test-data-nmm2xml/*.nmm; do
    nmm_mercury_output_file="$(mktemp)"
    expected_output_file="${nmm_file%.nmm}.xml"
    ./bin/nmm-mercury nmm2xml "$nmm_file" > "$nmm_mercury_output_file"
    xmldiff --check --ratio-mode faster "$nmm_mercury_output_file" "$expected_output_file" > /dev/null
    if [[ "$?" -ne 0 ]]; then
        echo "output from"
        echo "  nmm-mercury nmm2xml $nmm_file"
        echo "differs from expected output in"
        echo "  $expected_output_file"
        exit_code=1
    fi
done
exit $exit_code
