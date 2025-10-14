#! /usr/bin/env bash
set -e

cd "$(dirname "$0")"
exit_code=0
for nmm_file_path in ./nmm-sources/*; do
    nmm_file_name="${nmm_file_path##*/}"
    txt_file_name="${nmm_file_name%.nmm}.txt"
    txt_file_path="./raw-text-semantics/${nmm_file_name%.nmm}.txt"
    ../bin/nmm nmm2txt "$nmm_file_path" > "$txt_file_path"
done
