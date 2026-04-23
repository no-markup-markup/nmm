#! /usr/bin/env bash

nmm-ocaml txt-of-nmm $@ > $(basename -s .nmm ${@: -1}).txt
