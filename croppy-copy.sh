#!/bin/bash

# Public: Copy and crop images from a source directory by various dimensions into a
# destination directory.
#
# $1	- The source directory. If it starts with a slash, treated as absolute. Otherwise,
#				treated as relative. If empty, checks for a "source" directory in the current
#				location.
# $2	- The destination directory. If it starts with a slash, treated as absolute.
#				Otherwise, treated as relative. If empty, checks for a "destination" directory
#				in the current location. If source is successfully identified and destination is
#				not, then script will create "destination" directory in current location.
#
if [ $1 ]; then
	if [ ${1:0:1} == "/" ]; then
		src=$1
	else
		src="${PWD}/${1}"
	fi
else
	if [ -d "${PWD}/source" ]; then
		src="${PWD}/source"
	else
		src=0
	fi
fi

if [ $2 ]; then
	if [ ${2:0:1} == "/" ]; then
		dest=$2
	else
		dest="${PWD}/${2}"
	fi
else
	if [ $src != 0 ]; then
		if [ ! -d "${PWD}/destination" ]; then
			mkdir -p "${PWD}/destination"
		fi
		dest="${PWD}/destination"
	fi
fi

if [ $src == 0 ]; then
	echo "No arguments found. No directory 'source' in current location. No actions taken."
else

	for filepath in $src/*; do
		f=`echo $filepath|awk -F / '{ print $NF }'`
		ext=`echo $f|awk -F . '{ print $NF }'`
		base=${f:0:( ${#f} - ${#ext} - 1)}
		
		for dim in "728x90" "300x600" "300x250" "160x600"; do
			#echo "${dest}/${base}-${dim}.${ext}"
			/usr/local/bin/convert $filepath -crop "${dim}+0+0" "${dest}/${base}-${dim}.${ext}"
		done
		
	done
	
fi
