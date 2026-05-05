# bash completion for nmm-ocaml (and for wrapper scripts txt-of-nmm, html-of-nmm, and pdf-of-nmm)

# either source this file in ~/.bash_completion by appending the line 'source <path-to-this-file>',
# or copy it to /usr/share/bash-completion/completions/nmm-ocaml

subcommands='html-of-nmm txt-of-nmm exml-of-nmm axml-of-nmm html-of-axml txt-of-axml exml-of-axml'
axml_options='--tags'
exml_options="$axml_options --quiet --numbering --allow-custom-numbering"
txt_options="$exml_options --margin --width"
html_options="$exml_options --margin --css"
numbering_options='a1i ai1 1ai 1ia ia1 i1a'
margin_options=$(echo $(seq 0 100))
width_options=$(echo $(seq 1 100))

get_options () {
	case $1 in
		nmm-ocaml )
			echo $subcommands ;;
		axml-of-* )
			echo $axml_options ;;
		exml-of-* )
			echo $exml_options ;;
		txt-of-* )
			echo $txt_options ;;
		html-of-* | pdf-of-* )
			echo $html_options ;;
		--numbering )
			echo $numbering_options ;;
		--margin )
			echo $margin_options ;;
		--width )
			echo $width_options ;;
		*)
			echo '' ;;
	esac

}

actual_subcommand=''

_nmm_ocaml () {

	local cur prev options
	COMPREPLY=()
	cur=${COMP_WORDS[COMP_CWORD]}
	prev=${COMP_WORDS[COMP_CWORD-1]}
	options=$(get_options $prev)

	case $prev in
		nmm-ocaml )
			COMPREPLY=( $(compgen -W "${options}" -- ${cur}) ) ;;
		*-of-* )
			actual_subcommand=$prev
			COMPREPLY=( $(compgen -W "${options}" -- ${cur}) $(compgen -f -- ${cur}) ) ;;
		--numbering )
			COMPREPLY=( $(compgen -W "${options}" -- ${cur}) ) ;;
		--margin )
			COMPREPLY=( $(compgen -W "${options}" -- ${cur}) ) ;;
		--tags | --css )
			COMPREPLY=( $(compgen -f -- ${cur}) ) ;;
		- )
			COMPREPLY=() ;;
		* )
			options=$(get_options $actual_subcommand)
			COMPREPLY=( $(compgen -W "${options}" -- ${cur}) $(compgen -f -- ${cur}) ) ;;
	esac

	return 0
}

complete -o nospace -F _nmm_ocaml nmm-ocaml html-of-nmm txt-of-nmm pdf-of-nmm



