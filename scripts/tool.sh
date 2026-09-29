#!/bin/bash

#==========================================================
#Objective:
#	Build a script that behaves like a real Unix tool. 
#	It needs to: 
#		- handle different "subcommands"
#		- process the arguments that follow them.
#==========================================================

#The first argument will specify the subcommand to run:

cmd="$1"
shift

greet () {

	for name in "$@"; do

		echo "Hello, '$name'!"
	done
}

sum_up(){
	local total=0
	local n

	for n in "$@" ; do 
		((total += n))
	done

	echo "The total is : $total"
}

reverse_words() {

	arr=("$@")
	local i
for (( i = -1; i>= -"${#arr[@]}"; i-- )); do

	echo "'${arr[$i]}'"

done

}

tool_usage(){
	cat << 'EOF'

tool.sh is a small toolbox with three handy commands.

WHAT IT DOES:
	Type a command, then whatever you wnat it to work on.
	For example, you can greet people, add up numbers, or reverse a list of words.

COMMANDS:

greet
	Says Hello to each name you give it.
	Example: ./tool.sh greet Ali Betty Alex
------------------------------------------------------------
sum
	Adds up the numbers you give it and tells you the total. 
	Example: ./tool.sh 3 5 7
	Result: The total is: 15
------------------------------------------------------------
reverse
	Lists your word backwards, one per line.
	Example: .tool.sh reverse orange apple banana

	Result: banana 
		apple
		orange
------------------------------------------------------------help
	shows this message.

------------------------------------------------------------TIPS: 
 + If a name or phrase has a SPACE in it, wrap it in QUOTES "" 
	Example: .tool.sh greet Ali "Bob John"
 
 +If you're not sure, just run ./tools.sh help

EOF

}

case "$cmd" in
	greet) greet "$@"
		exit 0
		;;
	

	sum) sum_up "$@"
		exit 0
		;;

	reverse) reverse_words "$@"
		exit 0
		;;

	Q|q|exit) exit 1 ;;
	
	""|Help|help) tool_usage
		exit 2 ;;

esac	


