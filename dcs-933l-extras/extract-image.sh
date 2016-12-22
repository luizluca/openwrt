#!/bin/bash

die() {
	local err=$1; shift
	echo "$@" >&2
	exit $err
}

which binwalk >/dev/null || die 1 "binwalk not found"
which dd >/dev/null || die 1 "dd not found"

: ${1:?Pass the factory firmware as first arg}

echo "Processing '$1'..."
out="$(binwalk -y uimage "$1")" || die 1 "binwalk failed on '$1'"
uimages=$(grep "uImage header" <<<"$out") || die 1 "uImage not found on file '$1' by binwalk"
os_uimage=$(grep "OS Kernel Image" <<<"$out") || die 1 "uImage with type 'OS Kernel Image' not found"

tempfile1=$(mktemp -t extract-image.XXXXXXXXXX) || die 1 "Failed to create temp file"
tempfile2=$(mktemp -t extract-image.XXXXXXXXXX) || die 1 "Failed to create temp file"
trap "rm -f '$tempfile1' '$tempfile2' " EXIT

pos=$(awk '{print $1}' <<<"$os_uimage")
echo "Found uImage OS Kernel Image at ${pos}b of '$1'"
echo "Extracting uImage from '$1' to '$tempfile1' ..."
dd if="$1" of="$tempfile1" bs="$pos" skip=1

echo "Rechecking '$tempfile1' ..."
set -- "$tempfile1"
out="$(binwalk -y lzma "$1")" || die 1 "binwalk failed on '$1'" 
lzma1=$(grep "LZMA" <<<"$out") || die 1 "LZMA not found on '$1' by binwalk"
pos=$(awk '{print $1}' <<<"$lzma1")
echo "Found LZMA at ${pos}b of '$1'"
echo "Extracting LZMA from '$1' and expanding to '$tempfile2' ..."
dd if="$1" bs="$pos" skip=1 | unlzma > "$tempfile2"

echo "Rechecking '$tempfile2' ..."
set -- "$tempfile2"
out="$(binwalk -y lzma "$1")" || die 1 "binwalk failed on '$1'" 
lzma1=$(grep "LZMA" <<<"$out") || die 1 "LZMA not found on '$1' by binwalk"
pos=$(awk '{print $1}' <<<"$lzma1")
echo "Found LZMA at ${pos}b of '$1'"
echo "Extracting LZMA from '$1' and extracting files to current directory..."
dd if="$1" bs="$pos" skip=1 | unlzma | cpio -i --no-absolute-filenames --quiet
