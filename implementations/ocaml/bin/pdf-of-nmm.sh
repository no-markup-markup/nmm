#! /usr/bin/env bash

insert_images() {
  sed 's/\&lt;\([^ ]\+\).\(jpg\|png\|svg\|webp\|gif\)\&gt;/<img class="inserted_image" alt="Image source is \1.\2" src="\1.\2">/g' $1
}

insert_links() {
  sed 's/\&lt;\(https\?:\/\/\)\([^ ]\+\)\&gt;/<a class="inserted_link" href="\1\2">\2<\/a>/g' $1
}

nmm-ocaml html-of-nmm $@ | insert_images | insert_links | weasyprint - $(basename -s .nmm ${@: -1}).pdf
