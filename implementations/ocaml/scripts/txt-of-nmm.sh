#! /usr/bin/env bash

set -eo pipefail

txt_of_nmm_main () {
  local temp=$(mktemp)
  nmm-ocaml txt-of-nmm $@ > $temp
  local exit_code=$?

  case $exit_code in
    0)
      local filename="$(basename -s .nmm ${@: -1}).txt"
      mv $temp $filename
      chmod 664 $filename
      ;;
    *)
      rm $temp
      return $exit_code
      ;;
  esac
}

txt_of_nmm_main $@

