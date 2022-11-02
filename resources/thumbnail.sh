#!/bin/bash

INPUT_FILE="$1"
OUTPUT_FILE="$2"
OUTPUT_SIZE="$3"

if [ "${OUTPUT_SIZE}x" = "x" ]; then
    OUTPUT_SIZE="512x384"
fi

#ffmpeg -ss 00:00:02.000 -i "$1" -f png "$2" -s 512
#ffmpeg -ss 00:00:02.000 -i "$1" -vf "thumbnail" -frames:v 1 "$2.png" -s 512
#ffmpeg -i "$1" -vf "thumbnail" -frames:v 1 "$2.png" -s 512
#ffmpeg -ss 00:00:01.000 -i "$1" -vf "thumbnail" -frames:v 1 "$2.png" -s 512x512
ffmpeg -y -i "${INPUT_FILE}" -vframes 1 -an -s ${OUTPUT_SIZE} -ss 4 "${OUTPUT_FILE}"
