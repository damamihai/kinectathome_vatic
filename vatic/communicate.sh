#!/bin/bash

RECORDINGS_FOLDER='/var/kinect-recordings'

folder_list=$(find $RECORDINGS_FOLDER -maxdepth 1 -type d) 


for folder in $folder_list
  do
    echo $folder
    if [ "$folder" != "$RECORDINGS_FOLDER" ]
    then
        if [ ! -f "$folder/done" ]
        then
           if [ "$(ls -A $folder/d-*)" ]; then
              cmd="cat `ls $folder/d-*` > $folder/depth_video.mkv"
              echo $cmd
              eval $cmd
              mkdir "$folder/depth_frames"
              eval "ffmpeg -i $folder/depth_video.mkv $folder/depth_frames/frame%d.png"
           fi
           if [ "$(ls -A $folder/r-*)" ]; then
              cmd="cat `ls $folder/r-*` > $folder/rgb_video.h264"
              echo $cmd
              eval $cmd
              cmd="ffmpeg -f h264 -i $folder/rgb_video.h264 -vcodec copy $folder/rgb_video.mp4"
              echo $cmd
              eval $cmd
              mkdir "$folder/rgb_frames"
              eval "turkic extract $folder/rgb_video.mp4 $folder/rgb_frames --width 640 --height 480"
              cmd="ffmpeg -i $folder/rgb_frames/0/0/0.jpg -qmax 1 -vf scale=160:120 $folder/thumbnail.jpg"
              eval $cmd
           fi
           touch "$folder/done"
#read -p "Press smth.." 
        fi
    fi
  done

