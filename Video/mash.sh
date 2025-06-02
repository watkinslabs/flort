#!/bin/bash

# Loop through segments 1 to 7
for i in {1..7}; do
  video="seg_${i}.mp4"
  audio="audio/SEG${i}.mp3"
  temp_audio="temp/temp_audio_${i}.mp3"
  temp_video="temp/temp_video_${i}.mp4"
  output="temp/seg_${i}_with_audio.mp4"

  # Get durations of the video and audio
  video_duration=$(ffprobe -v error -show_entries format=duration -of csv=p=0 "$video")
  audio_duration=$(ffprobe -v error -show_entries format=duration -of csv=p=0 "$audio")

  # Check if the audio is longer than the video
  if (( $(echo "$audio_duration > $video_duration" | bc -l) )); then
    # Extend video duration by holding the last frame
    ffmpeg -i "$video" -vf "tpad=stop_mode=clone:stop_duration=$(echo "$audio_duration - $video_duration" | bc)" -c:v libx264 -preset fast "$temp_video" -y

    # Use the extended video
    video="$temp_video"
    video_duration="$audio_duration"
  fiy

  # Extend or trim the audio to match the video duration
  ffmpeg -i "$audio" -af "apad=pad_dur=$(echo "$video_duration - $audio_duration" | bc)" -t "$video_duration" "$temp_audio" -y

  # Combine video and audio
  ffmpeg -i "$video" -i "$temp_audio" -c:v copy -c:a aac -map 0:v:0 -map 1:a:0 "$output" -y

  # Cleanup temporary files
  rm -f "$temp_audio" "$temp_video"

  echo "Processed: $output"
done

ffmpeg -f concat -safe 0 -i files.txt -c copy video_1.mp4

ffmpeg -i video_1.mp4 -i audio/FLORT.mp3 -filter_complex "[0:a]volume=1.0[a1];[1:a]volume=0.5[a2];[a1][a2]amix=inputs=2:duration=longest" -c:v copy -c:a aac final_video.mp4

ffmpeg -i final_video.mp4 -i watermark.png -filter_complex "overlay=0:main_h-overlay_h" -c:v libx264 -preset fast -crf 23 -c:a copy final_video_with_watermark.mp4
