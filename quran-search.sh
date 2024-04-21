#!/usr/bin/env bash

######################################################################
# Quran Search and Display Shell Script
#
# Description:
#   This shell script allows users to search and display verses from
#   the Quran using command-line arguments or through an interactive
#   search prompt. It combines two versions of the Quran text into
#   a unified format and provides options for searching and displaying
#   verses based on chapter and verse numbers or through text search.
#
# Usage:
#   - To display usage information:
#     ./quran_search.sh h
#   - To open the Uthmani version of the Quran in gedit:
#     ./quran_search.sh g
#   - To display specific verses by chapter and verse number(s):
#     ./quran_search.sh [chapter] [verse_start] [verse_end]
#   - To search the Quran text interactively:
#     ./quran_search.sh
#
# Dependencies:
#   - The script relies on 'sed', 'awk', 'paste', 'zenity', 'xkb-switch',
#     and 'gedit' commands. Ensure these dependencies are installed.
#
# Notes:
#   - The Quran text files used by the script should be present in the
#     same directory as the script and named 'quran-simple-clean.txt',
#     'quran-uthmani.txt', and 'chapters-simple.txt'.
#   - The script supports color-coded output for better readability.
#
# Author:
#   RADOUAN MOSAID
#   https://mosaid.xyz
#
######################################################################


script_dir=$(dirname "$0")
file1="$script_dir/quran-simple-clean.txt"
file2="$script_dir/quran-uthmani.txt"
file3="$script_dir/chapters-simple.txt"
quran_text="$(paste -d'|' "$file1" "$file2" )"

# the command-line arguments
number1=$1
number2=$2
number3=$3

print_lines() {
chapter_name=$(sed -n "$2"p "$file3" )
echo "$1" | awk -F '|' -v num1="$2" -v num2="$3" -v num3="$4" -v chap="$chapter_name" \
    '{
        if ((num3 != "") && ($1 == num1) && ($2 >= num2) && ($2 <= num3)) {
	   printf("(\033[1;31m %d %s\033[1;0m) %s\n",$5,chap,$6);
        } else if ((num2 != "") && (num3 == "") && ($1 == num1) && ($2 == num2)) {
	   printf("(\033[1;31m %d %s\033[1;0m) %s\n",$5,chap,$6);
        } else if ((num2 == "") && (num3 == "") && ($1 == num1)) {
	   printf("(\033[1;31m %d %s\033[1;0m) %s\n",$5,chap,$6);
        }
    }'
}

if [[ $1 == h ]] ; then
	echo "Usage:
$(basename "$0")
$(basename "$0")	l	list chapters
$(basename "$0")	ll	list chapters with less
$(basename "$0")	g	open with uthmani Quran in gedit
$(basename "$0")	[sourah/chapter] [num1] [num2]"
	exit
fi

if [[ $1 == g ]] ; then
	nohup gedit "$file2" </dev/null >/dev/null 2>&1 &
	exit
fi

if [[ $1 == l ]] ; then
	awk '{printf("%3d-%10s",NR,$0)}; NR%5==0  {printf("\n")}' "$file3"
	exit
fi

if [[ $1 == ll ]] ; then
	cat -n "$file3" | less
	exit
fi



number='^[0-9]+$'
if [[ "$1" =~ $number ]] ; then
	if [ -z "$number2" ]; then
		text=$(print_lines "$quran_text" "$number1")
	elif [[ -z "$number3" ]]; then
		text=$(print_lines "$quran_text" "$number1" "$number2")
	else
		text=$(print_lines "$quran_text" "$number1" "$number2" "$number3")
	fi
	if [[ $@ == *g* ]]
	then
		echo "$text" > /tmp/quran_result
		nohup gedit "/tmp/quran_result" </dev/null >/dev/null 2>&1 &
	else
		echo "$text"
	fi
else
	xkb-switch -s ara
	pkill -RTMIN+12 i3blocks
	pattern=$( zenity --entry --text="Search Holy Quran:" \
		--title="search Holy Quran" --width=500 --timeout=30)
	xkb-switch -s fr
	pkill -RTMIN+12 i3blocks

	if [[ -n $pattern ]] ; then
	   results="$(echo "$quran_text" | grep --color=always "$pattern")"

	   if [[ -n $results ]]
		   then resuls_count=$(echo "$results" | wc -l)
		   else resuls_count=0
	   fi
	   echo "searching : $pattern"
	   echo "================================"
	   echo "$resuls_count found"
	   echo "================================"
	   echo "$results" > /tmp/quran_result
	   awk -F'|' '
	   	NR==FNR {chap[FNR]=$0; next}
	   	{printf("(\033[1;31m %d %s\033[1;0m) %s\n",$5,chap[$1],$6);}
	   ' "$file3"  /tmp/quran_result
	fi
fi
