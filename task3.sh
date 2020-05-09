#! /usr/bin/env bash

set -e

#帮助函数
function usehelp(){
cat <<END_EOF
Usage: task3.sh <filename> [arguments]
Arguments:
-to	Statistics Access source host TOP 100 and the corresponding total number of occurrences,excluding IP and proxy
-ti	Statistics Access source host TOP 100 and the total number of occurrences corresponding,excluding hosts and prxy
-tu	Count the most frequently accessed URL TOP100
-re	Count the number of occurrences and corrseponding percentages of different response status codes
-rt	Statistics the TOP 10 corresponding to the different 4XX status codes and the total number of corresponding occurrences
-sh	 Given URL output TOP 100 access Source host
END_EOF
return 0
}

#统计访问来源主机TOP 100和分别对应出现的总次数
function top(){
	filename="${1}"
	printf "\n=====================Source Host TOP100=====================\n"
	result=$( awk 'BEGIN{FS="\t"} $1 ~ /^(\w+\.)+[a-zA-Z]/ {print $1}' "${filename}" | sort | uniq -c | sort -nr | head -n 100 | awk 'BEGIN{FS=" "} {printf("Source host: %-28s\t Number: %d\n",$2,$1)}')
	echo "${result}"
	return 0
}

#统计访问来源主机TOP 100 IP和分别对应出现的总次数
function topIP(){
	filename="${1}"
	printf "\n=====================Source Host TOP IP=====================\n"
	result=$(awk 'BEGIN{FS="\t"} $1 ~ /([0-9]{1,3}\.){3}[0-9]{1,3}/ {print $1}' "${filename}" | sort | uniq -c | sort -nr | head -n 100 | awk 'BEGIN{FS=" "} {printf("Source host: %-35s\t Number: %d\n",$2,$1)}')
	echo "${result}"
	return 0
}

#统计最频繁被访问的URL TOP 100
function topURL(){
	filename="${1}"
	printf "\n========================URLS TOP100========================\n"
	result=$(awk 'BEGIN{FS="\t"} $5 != "/" {print $5}' "${filename}" | sort | uniq -c | sort -nr | head -n 100 | awk 'BEGIN{FS=" "} {printf("Number: %-4d\t URL: %s\n",$1,$2)}')
	echo "${result}"
	return 0
}

#统计不同响应状态码的出现次数和对应百分比
function response(){
	filename="${1}"
	printf "\n====================Response StatusCode====================\n"
	sum=$(awk 'BEGIN{FS="\t";sum=0} $6 ~ /[0~9]/ {sum=sum+1} END {print sum}' "${filename}")
	result=$(awk 'BEGIN{FS="\t"} $6 ~ /[0~9]/{print $6}' "${filename}" | sort | uniq -c | sort -nr | awk 'BEGIN{FS=" "} {printf("Status Code: %-8s\t Number: %-8d\t Percentage:%-4.5f%%\n",$2,$1,100*$1/'"${sum}"')}')
	echo "${result}"
	return 0
}

#分别统计不同4XX状态码对应的TOP 10 URL和对应出现的总次数
function responseTOP(){
	filename="${1}"
	printf "\n==================4XXStatusCode URL TOP10==================\n"
	codes=$(awk 'BEGIN{FS="\t"} $6 ~ /[4][0-9][0-9]/ {print $6}' "${filename}" | sort -u )
	for key in $codes;do
		printf "Status code: %s\n" "${key}"	         
		result=$(awk 'BEGIN{FS="\t"} $6=='"${key}"' {print $5}' "${filename}" | sort | uniq -c | sort -nr | head -n 10 | awk 'BEGIN{FS=" "} {printf("Number: %-6d URL: %s\n",$1,$2)}')
		echo "${result}"
        done
	return 0
}

#给定URL输出TOP 100访问来源主机
function sourcehost(){
	filename="${1}"
	url="${2}"
	printf "Input URL: %-10s\n" "${url}"
	result=$(awk 'BEGIN{FS="\t"} $5==ur {print $1} ' ur="${url}" "${filename}" | sort | uniq -c | sort -nr | head -n 100 | awk 'BEGIN{FS=" "} {printf("Source host: %-20s\t Number: %d\n",$2,$1)}')
	echo "${result}"
	return 0
}

filename="${1}"
shift
while [[ -n "${1}" ]];do
	case "${1}" in
		-h)
			usehelp
			;;
		-to)
			top "${filename}"
			;;
		-ti)
			topIP "${filename}"
			;;
		-tu)
			topURL "${filename}"
			;;
		-re)
			response "${filename}"
			;;
		-rt)
			responseTOP "${filename}"
			;;
		-sh)
			url="${2}"
			sourcehost "${filename}" "${url}"
			shift
			;;
		*)
			echo "Error: Not a correct option"
			;;
	esac
	shift
done


