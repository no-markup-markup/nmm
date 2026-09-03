# bash completion for nmm-ocaml (and for wrapper scripts txt-of-nmm, html-of-nmm, and pdf-of-nmm)

# to enable bash completion for nmm-ocaml, you can either
# 1) copy this file to /usr/share/bash-completion/completions/nmm-ocaml, or
# 2) append the line 'source <path-to-this-file>' to ~/.bash_completion

_nmm_ocaml_get_options () {

  local subcommands='html-of-nmm txt-of-nmm exml-of-nmm axml-of-nmm html-of-axml txt-of-axml exml-of-axml show-exml-schema show-axml-schema show-default-css validate-xml check-xml-schema normalize-axml version help'
  local axml_options='--tags'
  local exml_options="$axml_options --quiet --numbering --allow-custom-numbering"
  local txt_options="$exml_options --margin --indent --width"
  local html_options="$exml_options --margin --indent --internal-css --external-css --lang"
  local numbering_options='a1i ai1 1ai 1ia ia1 i1a'
  local lang_options='ab aa af ak sq am ar an hy as av ae ay az bm ba eu be bn bh bi bs br bg my ca ch ce ny zh zh-Hans zh-Hant cv kw co cr hr cs da dv nl dz en eo et ee fo fj fi fr ff gl gd gv ka de el kl gn gu ht ha he hz hi ho hu is io ig id in ia ie iu ik ga it ja jv kl kn kr ks kk km ki rw rn ky kv kg ko ku kj lo la lv li ln lt lu lg lb gv mk mg ms ml mt mi mr mh mo mn na nv ng nd ne no nb nn ii oc oj cu or om os pi ps fa pl pt pa qu rm ro ru se sm sg sa sr sh st tn sn ii sd si ss sk sl so nr es su sw ss sv tl ty tg ta tt te th bo ti to ts tr tk tw ug uk ur uz ve vi vo wa cy wo fy xh yi ji yo za zu'

  case $1 in
   nmm-ocaml )
      echo $subcommands
      ;;
    axml-of-nmm )
      echo $axml_options
      ;;
    exml-of-nmm | exml-of-axml )
      echo $exml_options
      ;;
    txt-of-nmm | txt-of-axml )
      echo $txt_options
      ;;
    html-of-nmm | html-of-axml | pdf-of-nmm )
      echo $html_options
      ;;
    --numbering )
      echo $numbering_options
      ;;
    --lang )
      echo $lang_options
      ;;
    --margin | --indent | --width )
      echo $(seq 0 9)  #etc
      ;;
    *)
      echo ''
      ;;
  esac

}

_nmm_ocaml_chosen_subcommand=''

_nmm_ocaml () {

  local cur prev options
  COMPREPLY=()
  cur=${COMP_WORDS[COMP_CWORD]}
  prev=${COMP_WORDS[COMP_CWORD-1]}
  options=$(_nmm_ocaml_get_options $prev)

  case $prev in
    nmm-ocaml )
      COMPREPLY=( $(compgen -W "${options}" -- ${cur}) )
      ;;
    *-of-* )
      _nmm_ocaml_chosen_subcommand=$prev
      COMPREPLY=( $(compgen -W "${options}" -- ${cur}) $(compgen -f -- ${cur}) )
      ;;
    --lang )
      COMPREPLY=( $(compgen -W "${options}" -- ${cur}) )
      ;;
    --numbering | --margin | --indent | --width )
      COMPREPLY=( $(compgen -W "${options}") )
      ;;
    --tags | --internal-css | --external-css | validate-xml | check-xml-schema )
      COMPREPLY=( $(compgen -f -- ${cur}) )
      ;;
    - | show-* | version | help )
      COMPREPLY=()
      ;;
    * )
      options=$(_nmm_ocaml_get_options $_nmm_ocaml_chosen_subcommand)
      COMPREPLY=( $(compgen -W "${options}" -- ${cur}) $(compgen -f -- ${cur}) )
      ;;
  esac

  return 0
}

complete -o nospace -F _nmm_ocaml nmm-ocaml html-of-nmm txt-of-nmm pdf-of-nmm


