#!/bin/bash
mkdir -p processed

for file in $(ls rl-video-step-*.mp4 | sort -V); do
  # Extract the number (or any text) from the filename.
  # This example assumes the filename is of the form rl-vide-step-NUMBER.mp4.
  num=$(echo "$file" | sed -E 's/.*_([0-9]+)\.mp4/\1/')

  # Overlay the text in the top-left corner (10px from left and top)
  ffmpeg -i "$file" -vf "drawtext=text='${num}':x=10:y=10:fontsize=24:fontcolor=white:box=1:boxcolor=black@0.5" -codec:a copy "processed/$file"
done

rm -f videolist.txt
for file in $(ls processed/rl-video-step-*.mp4 | sort -V); do
  echo "file '$PWD/$file'" >> videolist.txt
done

ffmpeg -f concat -safe 0 -i videolist.txt -c copy final_training_video.mp4
