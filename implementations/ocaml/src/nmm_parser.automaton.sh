automaton=$1


print_state(){
	sed -n "/^State $1:$/,/^$/p" $2
}

get_last_state(){
	grep 'State' $1 | tail -1 | cut -f 2 -d ' ' | cut -f 1 -d ':'
}

print_states(){
	for i in $(seq 0 $1)
	do
		echo '|' $i '->' 
		echo '"'"$(print_state $i $2)"'"'
	done
}

last_state="$(get_last_state $automaton)"

echo 'let state (n:int) : string ='
echo 'match n with' 
echo "$(print_states $last_state $automaton)"
echo '| _ -> ""'
