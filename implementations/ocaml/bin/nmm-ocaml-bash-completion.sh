# bash completion for nmm-ocaml (and for wrapper scripts txt-of-nmm, html-of-nmm, and pdf-of-nmm)

# to enable bash completion for nmm-ocaml, you can either
# 1) copy this file to /usr/share/bash-completion/completions/nmm-ocaml, or
# 2) append the line 'source <path-to-this-file>' to ~/.bash_completion

_nmm_ocaml_get_options () {

	local subcommands='html-of-nmm txt-of-nmm exml-of-nmm axml-of-nmm html-of-axml txt-of-axml exml-of-axml'
	local axml_options='--tags'
	local exml_options="$axml_options --quiet --numbering --allow-custom-numbering"
	local txt_options="$exml_options --margin --width"
	local html_options="$exml_options --margin --css --lang"
	local numbering_options='a1i ai1 1ai 1ia ia1 i1a'
	local lang_options='en sv fr de es' #etc

	case $1 in
		nmm-ocaml )
			echo $subcommands
			;;
		axml-of-* )
			echo $axml_options
			;;
		exml-of-* )
			echo $exml_options
			;;
		txt-of-* )
			echo $txt_options
			;;
		html-of-* | pdf-of-* )
			echo $html_options
			;;
		--numbering )
			echo $numbering_options
			;;
		--lang )
			echo $lang_options
			;;
		--margin )
			echo $(seq 0 100) #etc
			;;
		--width )
			echo $(seq 1 100) #etc
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
		--numbering | --margin | --width | --lang )
			COMPREPLY=( $(compgen -W "${options}" -- ${cur}) )
			;;
		--tags | --css )
			COMPREPLY=( $(compgen -f -- ${cur}) )
			;;
		- )
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


