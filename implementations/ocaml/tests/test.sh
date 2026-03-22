#! /usr/bin/env bash

show_default_css(){
	../bin/nmm-ocaml show-default-css > css/default.css
}

check_xml_schemas(){
	local exit_code=0
	local curr_code=0
	local input_dir="../docs/specs"
	for file in $(ls $input_dir/*.dtd)
	do
		../bin/nmm-ocaml check-xml-schema $file > /dev/null
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
	for file in $(ls $input_dir/*.nmm)
	do
		../bin/nmm-ocaml test-with-nmm $@ $file
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
	local input_dir="xml_input"
	for file in $(ls $input_dir/*.xml)
	do
		../bin/nmm-ocaml test-with-xml $@ $file
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
	for file in $(ls $input_dir/*.nmm)
	do
		../bin/nmm-ocaml txt-of-nmm $@ $file > $output_dir/$(basename $file).txt
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
	for file in $(ls $input_dir/*.nmm)
	do
		../bin/nmm-ocaml html-of-nmm $@ $file > $output_dir/$(basename $file).html
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
	local output_dir="xml_output"
	mkdir -p $output_dir
	for file in $(ls $input_dir/*.nmm)
	do
		../bin/nmm-ocaml xml-of-nmm $@ $file > $output_dir/$(basename $file).xml
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
	local output_dir="html_output"
	local expected_output_dir="expected_html_output"
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
	local output_dir="xml_output"
	local expected_output_dir="expected_xml_output"
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

test_auto_date(){
	local DATE
	local LINE
	local curr_code
	DATE=$(date +'%Y-%m-%d %H:%M UTC%:::z')
	LINE=$(../bin/nmm-ocaml txt-of-nmm nmm_input/date_auto/date_auto.nmm | head -n 1)
	if [ "$LINE" = "$DATE" ]
	then
		return 0
	else
		echo "$DATE ≠ $LINE"
		return 2
	fi
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


	test_auto_date
	curr_code=$?
	if [ $curr_code -gt 0 ]
	then
	exit_code=$curr_code
	fi

	return $exit_code

}

make_test

curr_code=$?
if [ $curr_code -gt 0 ]
then
	echo "nmm-ocaml: some tests FAILED."
else
	echo "nmm-ocaml: all tests PASSED."
fi

exit $curr_code
