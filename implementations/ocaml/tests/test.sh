#! /usr/bin/env bash

show_default_css(){
	mkdir -p css_output
	../bin/nmm-ocaml show-default-css > css_output/default.css
}


check_xml_schemas(){
	local exit_code=0
	local curr_code=0
	mkdir -p dtd_output
	../bin/nmm-ocaml show-exml-schema > dtd_output/exml.dtd
	../bin/nmm-ocaml show-axml-schema > dtd_output/axml.dtd
	for file in $(ls dtd_output/*.dtd)
	do
		../bin/nmm-ocaml check-xml-schema "$file" > /dev/null
		curr_code=$?
		if [ $curr_code -gt 0 ]
		then
			exit_code=$curr_code
		fi
	done
	return $exit_code
}

test_with_nmm(){
	local exit_code=0
	local curr_code=0
	local input_dir="nmm_input"
	for file in $(ls ${input_dir}/*.nmm)
	do
		../bin/nmm-ocaml test-with-nmm $@ "$file" > /dev/null
		curr_code=$?
		if [ $curr_code -gt 0 ]
		then
			exit_code=$curr_code
		fi
	done
	return $exit_code
}


test_with_xml(){
	local exit_code=0
	local curr_code=0
	local input_dir="axml_input"
	for file in $(ls ${input_dir}/*.xml)
	do
		../bin/nmm-ocaml test-with-axml $@ "$file" > /dev/null
		curr_code=$?
		if [ $curr_code -gt 0 ]
		then
			exit_code=$curr_code
		fi
	done
	return $exit_code
}

make_txt_output(){
	local exit_code=0
	local curr_code=0
	local input_dir="nmm_input"
	local output_dir="txt_output"
	mkdir -p $output_dir
	for file in $(ls ${input_dir}/*.nmm)
	do
		../bin/nmm-ocaml txt-of-nmm $@ "$file" > ${output_dir}/$(basename $file).txt
		curr_code=$?
		if [ $curr_code -gt 0 ]
		then
			exit_code=$curr_code
		fi
	done
	return $exit_code
}

make_html_output(){
	local exit_code=0
	local curr_code=0
	local input_dir="nmm_input"
	local output_dir="html_output"
	mkdir -p $output_dir
	for file in $(ls ${input_dir}/*.nmm)
	do
		../bin/nmm-ocaml html-of-nmm $@ "$file" > ${output_dir}/$(basename $file).html
		curr_code=$?
		if [ $curr_code -gt 0 ]
		then
			exit_code=$curr_code
		fi
	done
	return $exit_code
}


make_xml_output(){
	local exit_code=0
	local curr_code=0
	local input_dir="nmm_input"
	local output_dir="axml_output"
	mkdir -p $output_dir
	for file in $(ls ${input_dir}/*.nmm)
	do
		../bin/nmm-ocaml axml-of-nmm $@ "$file" > ${output_dir}/$(basename $file).xml
		curr_code=$?
		if [ $curr_code -gt 0 ]
		then
			exit_code=$curr_code
		fi
	done
	return $exit_code
}

show_txt_diff(){
	local exit_code=0
	local curr_code=0
	local output_dir="txt_output"
	local expected_output_dir="expected_txt_output"
	for file in $(ls ${output_dir}/*.txt)
	do
		local expected_output_file="${expected_output_dir}/$(basename $file)"
		local output_file="${output_dir}/$(basename $file)"
		diff "$expected_output_file" "$output_file" > /dev/null
		curr_code=$?
		if [ $curr_code -gt 0 ]
		then
			exit_code=$curr_code
			echo $expected_output_file differs from $output_file
		fi
	done
	return $exit_code
}


show_html_diff(){
	local exit_code=0
	local curr_code=0
	local output_dir="html_output"
	local expected_output_dir="expected_html_output"
	for file in $(ls ${output_dir}/*.html)
	do
		local expected_output_file="${expected_output_dir}/$(basename $file)"
		local output_file="${output_dir}/$(basename $file)"
		diff "$expected_output_file" "$output_file" > /dev/null
		curr_code=$?
		if [ $curr_code -gt 0 ]
		then
			exit_code=$curr_code
			echo $expected_output_file differs from $output_file
		fi
	done
	return $exit_code
}

show_xml_diff(){
	local exit_code=0
	local curr_code=0
	local output_dir="axml_output"
	local expected_output_dir="expected_axml_output"
	for file in $(ls ${output_dir}/*.xml)
	do
		local expected_output_file="${expected_output_dir}/$(basename $file)"
		local output_file="${output_dir}/$(basename $file)"
		diff "$expected_output_file" "$output_file" > /dev/null
		curr_code=$?
		if [ $curr_code -gt 0 ]
		then
			exit_code=$curr_code
			echo $expected_output_file differs from $output_file
		fi
	done
	return $exit_code
}

test_auto_date(){
	local SYS_DATE=$(date +'%Y-%m-%d %H:%M UTC%:::z')
	local DOC_DATE=$(../bin/nmm-ocaml txt-of-nmm nmm_input/date_auto/date_auto.nmm | head -n 1)
	if [ "$DOC_DATE" = "$SYS_DATE" ]
	then
		return 0
	else
		echo "test_auto_date FAILED: document date $DOC_DATE ≠ system date $SYS_DATE"
		return 2
	fi
}

test_normalize_axml(){
	local exit_code=0
	local curr_code=0
	local input_dir="nmm_input"
	TEMP_DIR_XML_OF_NMM=$(mktemp -d)
	TEMP_DIR_TXT_OF_XML=$(mktemp -d)
	TEMP_DIR_TXT_OF_NMM=$(mktemp -d)

	for file in $(ls ${input_dir}/*.nmm)
	do
		../bin/nmm-ocaml txt-of-nmm $@ "$file" > ${TEMP_DIR_TXT_OF_NMM}/$(basename -s .nmm $file).txt
		../bin/nmm-ocaml axml-of-nmm "$file" > ${TEMP_DIR_XML_OF_NMM}/$(basename -s .nmm $file).xml
	done


	for file in $(ls ${TEMP_DIR_XML_OF_NMM}/*.xml)
	do
		../bin/nmm-ocaml txt-of-axml $@ "$file" > ${TEMP_DIR_TXT_OF_XML}/$(basename -s .xml $file).txt
	done

	local exit_code=0
	local curr_code=0
	local output_dir=$TEMP_DIR_TXT_OF_XML
	local expected_output_dir=$TEMP_DIR_TXT_OF_NMM
	for file in $(ls ${output_dir}/*.txt)
	do
		diff ${expected_output_dir}/$(basename $file) ${output_dir}/$(basename $file) > /dev/null
		curr_code=$?
		if [ $curr_code -gt 0 ]
		then
			exit_code=$curr_code
			echo "differs from expected output: $file"
		fi
	done

	rm -rf $TEMP_DIR_TXT_OF_NMM
	rm -rf $TEMP_DIR_XML_OF_NMM
	rm -rf $TEMP_DIR_TXT_OF_XML

	return $exit_code

}


make_tests(){
	local exit_code=0
	local curr_code=0

	check_xml_schemas
	curr_code=$?
	if [ $curr_code -gt 0 ]
	then
	exit_code=$curr_code
	fi

	show_default_css
	curr_code=$?
	if [ $curr_code -gt 0 ]
	then
	exit_code=$curr_code
	fi

	test_with_nmm --quiet
	curr_code=$?
	if [ $curr_code -gt 0 ]
	then
	exit_code=$curr_code
	fi

	test_with_xml --quiet
	curr_code=$?
	if [ $curr_code -gt 0 ]
	then
	exit_code=$curr_code
	fi

	make_txt_output --quiet --allow-custom-numbering
	curr_code=$?
	if [ $curr_code -gt 0 ]
	then
	exit_code=$curr_code
	fi

	make_html_output --quiet --allow-custom-numbering
	curr_code=$?
	if [ $curr_code -gt 0 ]
	then
	exit_code=$curr_code
	fi

	make_xml_output --tags tags/tags.tsv
	curr_code=$?
	if [ $curr_code -gt 0 ]
	then
	exit_code=$curr_code
	fi

	show_txt_diff
	curr_code=$?
	if [ $curr_code -gt 0 ]
	then
	exit_code=$curr_code
	fi

	show_html_diff
	curr_code=$?
	if [ $curr_code -gt 0 ]
	then
	exit_code=$curr_code
	fi

	show_xml_diff
	curr_code=$?
	if [ $curr_code -gt 0 ]
	then
	exit_code=$curr_code
	fi


	test_auto_date
	curr_code=$?
	if [ $curr_code -gt 0 ]
	then
	exit_code=$curr_code
	fi

	test_normalize_axml --quiet
	curr_code=$?
	if [ $curr_code -gt 0 ]
	then
	exit_code=$curr_code
	fi

	return $exit_code

}

make_tests

curr_code=$?
if [ $curr_code -gt 0 ]
then
	printf '\e[1;31m%-6s\e[m\n' "*** nmm-ocaml: Some tests FAILED ***"
else
	printf '\e[1;32m%-6s\e[m\n' "*** nmm-ocaml: All tests PASSED ***"
fi

exit $curr_code
