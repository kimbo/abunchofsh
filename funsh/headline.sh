#!/bin/bash
# yeah, I should've been doing something productive when I wrote this...
# oh well

random_color() {
	printf "\033[48;5;$(($RANDOM % 256))m \033[48;5;0m"
}

random_cell() {
	line=$(($RANDOM % $lines))
	col=$(($RANDOM % $cols))
	printf "\033[${line};${col}H"
}

random_emoji() {
	printf "\U$(printf '%x' $((RANDOM%79+128512)))"
}

fill_random_line() {
	line=$(($RANDOM % $lines))
	printf "\033[${line};0H"
	printf "\033[48;5;$(($RANDOM % 256))m "
	printf " %.0s" $(seq 1 $((cols-1)))
}

fill_random_line_colors() {
	line=$(($RANDOM % $lines))
	for ((i = 0; i < $cols; i++)); do
		printf "\033[${line};${i}H"
		printf "\033[48;5;$(($RANDOM % 256))m "
	done
}

fill_random_col() {
	col=$(($RANDOM % $cols))
	color=$(($RANDOM % 256))
	for ((i = 0; i < $lines; i++)); do
		printf "\033[${i};${col}H"
		printf "\033[48;5;${color}m "
	done
}

fill_random_col_colors() {
	col=$(($RANDOM % $cols))
	for ((i = 0; i < $lines; i++)); do
		printf "\033[${i};${col}H"
		printf "\033[48;5;$(($RANDOM % 256))m "
	done
}

slow_println() {
	sleep_time="${2-.05}"
	for ((i = 0; i <${#1}; i++)); do
		c="${1:$i:1}"
		printf '%s' "$c"
		sleep "$sleep_time"
	done
	sleep 1.5
	printf "\n"
}

cleanup() {
	printf "\033[${lines};${cols}H\033[48;5;0m"
	clear
	tput cnorm
	printf "I hope you have a blessed day.\n"
}

sigint_cnt=0
sigint_handle() {
	printf "\033[${lines};${cols}H\033[48;5;0m"
	clear
	if test "$sigint_cnt" -gt 5; then
		exit 0
	fi
	sigint_cnt=$(($sigint_cnt+1))
	clear
}

colors() {
	lines=$(tput lines)
	cols=$(tput cols)
	clear
	while test "1"; do
		if test "$sigint_cnt" -eq 0; then
			random_cell "$lines" "$cols"
			random_emoji
		elif test "$sigint_cnt" -eq 1; then
			random_cell "$lines" "$cols"
			random_color
		elif test "$sigint_cnt" -eq 2; then
			fill_random_col
		elif test "$sigint_cnt" -eq 3; then
			fill_random_line
		elif test "$sigint_cnt" -eq 4; then
			fill_random_col_colors
		elif test "$sigint_cnt" -eq 5; then
			fill_random_line_colors
		elif test "$sigint_cnt" -eq 6; then
			random_cell "$lines" "$cols"
			random_emoji
			random_emoji
			random_cell "$lines" "$cols"
			random_color
			random_color
			fill_random_line
			fill_random_col
		fi
	done
}

main() {
	clear
	slow_println "I wrote this for fun, I hope you enjoy it!"
	slow_println "Press any key to continue..."
	read cont
	tput civis
	colors
}

trap cleanup EXIT
trap sigint_handle SIGINT

main

