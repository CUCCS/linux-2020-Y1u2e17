#! /usr/bin/env bash

set -e

#脚本文件

#帮助函数
function usehelp(){
  cat <<END_EOF
  Usage:bash task1.sh -f <filename|path> [arguments]
  
  Arguments:
  -q <maxSize> <maxWidth> <maxHeight> <quality>  Support for image quality compression of JPEG formatted pictures
  -r <resolution>  Supports compression resolution for JPEG/PNG/SVG format pictures while maintaining the original aspect ratio
  -w <watermarks>  Support forbulk Add custom text watermarks to pictures
  -a <-p|-s> <text>   Support for bulk renaming
  -j   Supports the uniform conversion of png/svg pictures to JPG formatted pictures
END_EOF

return 0
}

# 对jpeg格式图片进行图片质量压缩
# maxSize 图片尺寸允许值
# maxWidth 图片最大宽度
# maxHeight 图片最大高度
# quality 图片质量
function jpgQualityCompress(){
	path=${1}
	maxSize=${2}
        maxWidth=${3}
	maxHeight=${4}
	quality=${5}
	if [[ -d "${path}" ]];then
		files=$(find "${path}" \( -name "*.jpg" \) -type f -size +"${maxSize}" -exec ls {} \;);
		for file in ${files};do
			echo "${file}"
			identify "${file}"
		        convert -resize "${maxWidth}"x"${maxHeight}" "${file}" -quality "${quality}" "${file}"
			identify "${file}"
		done
	elif [[ -f "${path}" ]];then
		echo "${path}"
		identify "${path}"
		convert -resize "${maxWidth}"x"${maxHeight}" "${path}" -quality "${quality}" "${path}"
		identify "${path}"
	fi

	return 0
}

#对jpeg/png/svg格式图片在保持原始宽高比的前提下压缩分辨率
function ResolutionCompress(){
	path=${1}
	resolution=${2}
	if [[ -d "${path}" ]];then
		files=$(find "${path}" \( -name "*.jpg" -or -name "*.png" -or -name "*.svg" \) -type f -exec ls {} \;);
		for file in ${files};do
			echo "${file}"
			identify "${file}"
			convert -resize "${resolution}" "${file}" "${file}"
			identify "${file}"
		done
	elif [[ -f "${path}" ]];then
		echo "${path}"
		identify "${path}"
		convert -resize "${resolution}" "${path}" "${path}"
		identify "${path}"
	fi

	return 0
}

#对图片批量添加自定义文本水印
function addWatermark(){
	path=${1}
	watermark=${2}
	if [[ -d "${path}" ]];then
		files=$(find "${path}" \( -name "*.jpg" -or -name "*.png" -or -name "*.svg" -or -name ".bmp" -or -name ".svg" \) -type f -exec ls {} \;);
		for file in ${files};do
			echo "${file}"
			convert ${file} -gravity southeast -fill black -pointsize 32 -draw " text 5,5 ${watermark} " "${file}"
		 done
	elif [[ -f "${path}" ]];then
		 echo "${path}"
		 convert ${file} -gravity southeast -fill black -pointsize 32 -draw " text 5,5 ${watermark} " "${file}"
	fi

	return 0
}

#批量重命名-添加文件名后缀
function addSuffix(){
	path="${1}"
	replace="s/\./""${2}\./"
	if [[ -d "${path}" ]];then
		echo "${path}"
		cd "${path}" || return 1
		rename "${replace}" *
		cd .. 
	elif [[ -f "${path}" ]];then
		echo "${path}"
		cd "${path%/*}" || return 1
		rename "${replace}" ${path##*/}
		cd .. 
	fi

	return 0
}

#批量重命名-添加文件名前缀
function addPrefix(){
	path="${1}"
	replace="s/^/""${2}/"
	if [[ -d "${path}" ]];then
		echo "${path}" 
		cd "${path}" || return 1
		rename "${replace}" *
		cd .. 
	elif [[ -f "${path}" ]];then
		echo "${path}"
		cd "${path%/*}" || return 1
		rename "${replace}" ${path##*/}
		cd .. 
	fi

	return 0
}

#将png/svg图片统一转换为jpg格式图片
function png2jpg(){
	path="${1}"
	if [[ -d "${path}" ]];then
		files=$(find "${path}" \( -name "*.png" -or -name "*.svg" \) -type f -exec ls {} \;);
		for file in ${files};do
			file="${file##*/}"
			echo "${file}"
			cd "${path%/*}" || return 1
			convert "${file}" "${file%.*}"".jpg"
			cd ..
		done
	elif [[ -f "${path}" ]];then
		if [[ "${path##*.}" == "svg" ]] || [[ "${path##*.}" == "png" ]];then	
			file="${path##*/}"
			echo "${file}"
			cd "${path%/*}" || return 1
			convert "${file}" "${file%.*}"".jpg"
			cd ..
		fi
	fi

	return 0
}


#############################################
while [[ -n "${1}" ]];do
	case "${1}" in
		-h)
			usehelp
			;;
		-f)
			if [[ "${#}" == 1 ]];then
				echo "Error: You must choose a file or folder."
				exit 0
			elif [[ ! -d "${2}" ]] && [[ ! -f "${2}" ]];then
				echo "Error: The directory or file dose not exist."
				exit 0
			fi
			path="${2}"
			shift
			;;
		-q)
			maxSize=${2}
		        maxWidth=${3}
			maxHeight=${4}
			quality=${5}
			jpgQualityCompress "${path}" "${maxSize}" "${maxWidth}" "${maxHeight}" "${quality}"
			shift
			shift
			shift
			shift
			;;
		-r)
			resolution=${2}
			ResolutionCompress "${path}" "${resolution}"
			shift
			;;
		-w)
			watermark=${2}
			addWatermark "${path}" "${watermark}"
			shift
			;;
		-a)
			position=${2}
			replace=${3}
			if [[ "${position}" == "-p" ]];then
				addPrefix "${path}" "${replace}" 
			elif [[ "${position}" == "-s" ]];then
				addSuffix "${path}" "${replace}" 
			else
				echo "Error"
			fi
			shift
			shift
			;;
		-j)
			png2jpg "${path}"
			;;
		*)
			echo "Erro: Not an option."
			;;
	esac
	shift
done



