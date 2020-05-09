#! /usr/bin/env bash

set -e

#帮助函数
function usehelp(){
  cat <<END_EOF
  Usage:bash task2.sh <filename> [arguments]

  Arguments:
  -a			Show age ,including maximum age and mimimum age
  -p			Show position status
  -n			Show the longest name and the shortest name
  -h			Show help information
END_EOF

return 0
}

#统计不同年龄区间范围（20岁以下、[20-30]、30岁以上）的球员数量、百分比,并显示年龄最大（小）球员
function ages(){
	filename="${1}"
	t1=$( awk ' BEGIN{FS="\t"} $6<20 && NR != 1 {print $6}' "${filename}" | wc -l )
	t2=$( awk ' BEGIN{FS="\t"} $6>=20 && $6 <= 30 && NR != 1 {print $6}' "${filename}" | wc -l )
	t3=$( awk ' BEGIN{FS="\t"} $6>30 && NR != 1 {print $6}' "${filename}" | wc -l ) 
	total=$( awk 'NR != 1' "${filename}" | wc -l )
	val1=$( echo "scale=2;100*$t1/$total"|bc )
	val2=$( echo "scale=2;100*$t2/$total"|bc )
	val3=$( echo "scale=2;100*$t3/$total"|bc )
	printf "\n=========================AGE GROUPS=========================\n"
	printf "Under age 20:              %4d people -->Pre: %4.2f%%\n" "${t1}" "${val1}"
	printf "Between age 20 and 30:     %4d people -->Pre: %4.2f%%\n" "${t2}" "${val2}"
	printf "Over age 30:               %4d people -->Pre: %4.2f%%\n" "${t3}" "${val3}"
	
	printf "\n======================The Oldest Player=====================\n"
	age=$(awk ' BEGIN {FS="\t";maxage=0} NR!=1 {if($6>maxage) {maxage=$6}} END {print maxage}' "${filename}")
	oldest=$(awk ' BEGIN {FS="\t"} NR!=1 {if($6=='"${age}"') {print $9}}' "${filename}")
	printf "Age:  %d\nName: %s\n" "${age}" "${oldest}"
	printf "\n=====================The Youngest Player====================\n"
	age=$(awk ' BEGIN {FS="\t";minage=100} NR!=1 {if($6<minage) {minage=$6}} END {print minage}' "${filename}")
	youngest=$(awk ' BEGIN {FS="\t"} NR!=1 {if($6=='"${age}"') {print $9}}' "${filename}")
	printf "Age:  %d\nName:\n" "${age}"
	echo "${youngest}"

	return 0
}

#统计不同场上位置的球员数量、百分比
function position(){
	filename="${1}"
	total=$( awk 'NR != 1' "${filename}" | wc -l )
	printf "\n==========================POSITION==========================\n"
	position=$(awk ' BEGIN {FS="\t"} NR!=1 {if ($5=="Défenseur") {print "Defender"} else {print $5} }' "${filename}" | sort -f | uniq -c )
	print_po=$(echo "${position}" | awk '{printf("Position:%-10s\tNumber:%d\tpercentage:%4.2f%%\n",$2,$1,100*$1/'"${total}"')}')
	echo "${print_po}"

	return 0
}

#显示名字最长（短）的球员
function names(){
	filename="${1}"
	printf "\n========================Longest Name========================\n"
	len=$(awk ' BEGIN {FS="\t";temp=0} NR!=1 {if(length($9)>temp) {temp=length($9)}} END {print temp}' "${filename}")
	longest=$(awk ' BEGIN {FS="\t"} NR!=1 {if(length($9)=='"${len}"') {print $9}}' "${filename}")
	printf "Name Length: %d\n" "${len}"
	echo "${longest}"
	
	printf "\n========================shortest Name========================\n"
	len=$(awk ' BEGIN {FS="\t";temp=100} NR!=1 {if(length($9)<temp) {temp=length($9)}} END {print temp}' "${filename}")
	shortest=$(awk ' BEGIN {FS="\t"} NR!=1 {if(length($9)=='"${len}"') {print $9}}' "${filename}")
	printf "Name Length: %d\n" "${len}"
	echo "${shortest}"

	return 0
}

###########################################
filename="${1}"
while [[ -n "${2}" ]];do
	case "${2}" in
		-h)
			usehelp
			;;
		-a)
			ages "${filename}"
			;;
		-p)
			position "${filename}"
			;;
		-n)
			names "${filename}"
			;;
		*)
			echo "Error: Not a correct option."
			;;
	esac
	shift
done
