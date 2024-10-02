#!/bin/bash

lines_audio_old=0
lines_video_old=0
echo "Starting video devices monitoring"
while :
do
  sleep 1
  lines_audio=$(lsmod | pcregrep -o1 "^snd_usb_audio\s+[0-9]+\s+([0-9]+)")
  lines_video=$(lsmod | pcregrep -o1 "^videodev\s+[0-9]+\s+([0-9]+)")
  # example : snd_usb_audio         466944  2
  # example : videodev              389120  6 videobuf2_v4l2,v4l2loopback,uvcvideo
  #lines_video=$(lsof -e /run/user/1000/doc -f -n -b -l -L -- /dev/video0 | wc -l)
    # -n -b -l -L recommended to speed up lsof but lsmod is faster
  if [[ $lines_audio != $lines_audio_old ]];
    then
      if [[ $lines_audio > $lines_audio_old ]];
        then
          echo "New audio device detected, resetting"
          camid=$(lsusb | pcregrep -o1 "ID ([0-9a-e:]+) Logitech, Inc\. Webcam")
          sudo usbreset $camid
      fi
      lines_audio_old=$lines_audio
  fi

  if [[ $lines_video != $lines_video_old ]];
    then
      if [[ $lines_video > $lines_video_old ]];
        then
          echo "New video device detected, applying settings"
          /usr/bin/v4l2-ctl -c auto_exposure=3
          sleep 0.5
          /usr/bin/v4l2-ctl -c auto_exposure=1
          /usr/bin/v4l2-ctl -c gain=119
      fi
      lines_video_old=$lines_video
  fi
done
