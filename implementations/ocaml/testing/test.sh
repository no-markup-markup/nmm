#! /usr/bin/env bash

show_default_css(){
	./bin/nmm-ocaml show-default-css > testing/css/default.css
}

check_xml_schemas(){
	local exit_code=0
	local curr_code=0
	local input_dir="testing/dtd"
	for file in $(ls $input_dir/*.dtd)
	do
		./bin/nmm-ocaml check-xml-schema $file > /dev/null
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
	local input_dir="testing/nmm_input"
	for file in $(ls $input_dir/*.nmm)
	do
		./bin/nmm-ocaml test-with-nmm $@ $file
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
	local input_dir="testing/xml_input"
	for file in $(ls $input_dir/*.xml)
	do
		./bin/nmm-ocaml test-with-xml $@ $file
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
	local input_dir="testing/nmm_input"
	local output_dir="testing/txt_output"
	mkdir -p $output_dir
	for file in $(ls $input_dir/*.nmm)
	do
		./bin/nmm-ocaml txt-of-nmm $@ $file > $output_dir/$(basename $file).txt
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
	local input_dir="testing/nmm_input"
	local output_dir="testing/html_output"
	mkdir -p $output_dir
	for file in $(ls $input_dir/*.nmm)
	do
		./bin/nmm-ocaml html-of-nmm $@ $file > $output_dir/$(basename $file).html
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
	local input_dir="testing/nmm_input"
	local output_dir="testing/xml_output"
	mkdir -p $output_dir
	for file in $(ls $input_dir/*.nmm)
	do
		./bin/nmm-ocaml xml-of-nmm $@ $file > $output_dir/$(basename $file).xml
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
	local output_dir="testing/txt_output"
	local expected_output_dir="testing/expected_txt_output"
	for file in $(ls $output_dir/*.txt)
	do
	diff $expected_output_dir/$(basename $file) $output_dir/$(basename $file) > /dev/null
		curr_code=$?
		if [ $curr_code -gt 0 ]
		then
			exit_code=$curr_code
			echo "output differs from expected output in $file"
		fi
	done
	return $exit_code
}


show_html_diff(){
	local exit_code=0
	local curr_code=0
	local output_dir="testing/html_output"
	local expected_output_dir="testing/expected_html_output"
	for file in $(ls $output_dir/*.html)
	do
	diff $expected_output_dir/$(basename $file) $output_dir/$(basename $file) > /dev/null
		curr_code=$?
		if [ $curr_code -gt 0 ]
		then
			exit_code=$curr_code
			echo "output differs from expected output in $file"
		fi
	done
	return $exit_code
}

show_xml_diff(){
	local exit_code=0
	local curr_code=0
	local output_dir="testing/xml_output"
	local expected_output_dir="testing/expected_xml_output"
	for file in $(ls $output_dir/*.xml)
	do
	diff $expected_output_dir/$(basename $file) $output_dir/$(basename $file) > /dev/null
		curr_code=$?
		if [ $curr_code -gt 0 ]
		then
			exit_code=$curr_code
			echo "output differs from expected output in $file"
		fi
	done
	return $exit_code
}


make_test(){
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

	test_with_nmm
	curr_code=$?
	if [ $curr_code -gt 0 ]
	then
	exit_code=$curr_code
	fi

	test_with_nmm --preserve-vertical-white-space
	curr_code=$?
	if [ $curr_code -gt 0 ]
	then
	exit_code=$curr_code
	fi


	test_with_xml
	curr_code=$?
	if [ $curr_code -gt 0 ]
	then
	exit_code=$curr_code
	fi

	make_txt_output
	curr_code=$?
	if [ $curr_code -gt 0 ]
	then
	exit_code=$curr_code
	fi

	make_html_output --lang en
	curr_code=$?
	if [ $curr_code -gt 0 ]
	then
	exit_code=$curr_code
	fi

	make_xml_output
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

	return $exit_code
}

make_test

