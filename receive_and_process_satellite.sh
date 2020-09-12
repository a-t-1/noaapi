#!/bin/bash

# $1 = Satellite Name
# $2 = Frequency
# $3 = FileName base
# $4 = TLE File
# $5 = EPOC start time
# $6 = Time to capture

sudo timeout $6 rtl_fm -f ${2}M -s 60k -g 45 -p 55 -E wav -E deemp -F 9 - | sox -t wav - $3.wav rate 11025

PassStart=`expr $5 + 90`

if [ -e $3.wav ]
  then
#    sudo cp $3.wav /var/www/html/wav/

    /usr/local/bin/wxmap -T "${1}" -H $4 -p 0 -l 0 -o $PassStart ${3}-map.png
#   echo $PassStart > ${3}-PassStart

    /usr/local/bin/wxtoimg -o -m ${3}-map.png $3.wav $3.png
    sudo cp $3.png /var/www/html/

    /usr/local/bin/wxtoimg -o -m ${3}-map.png -e MSA $3.wav $3-MSA.png
    sudo cp $3-MSA.png /var/www/html/MSA/

    /usr/local/bin/wxtoimg -o -m ${3}-map.png -e HVCT $3.wav $3-HVCT.png
    sudo cp $3-HVCT.png /var/www/html/HVCT/

    /usr/local/bin/wxtoimg -o -m ${3}-map.png -e ZA $3.wav $3-ZA.png
    sudo cp $3-ZA.png /var/www/html/ZA/

    mID=`/home/pi/weather/predict/tweet.sh upload ${3}-MSA.png  | cut -d':' -f 2 | cut -d',' -f 1`


    YMD=`echo $3 | cut -d "/" -f5 | cut -d"_" -f1`
    HMS=`echo $3 | cut -d "/" -f5 | cut -d"_" -f2`
    NOAA=`echo $3 | cut -d "/" -f5 | cut -d"_" -f3`
    DATE=`date --date="$YMD" +'%-d %B %Y'`
    TIME=`echo ${HMS:0:2}:${HMS:2:2}`
    TWEET=`echo Satellite image received from NOAA-${NOAA:4:2} on $DATE starting at $TIME.`


    /home/pi/weather/predict/tweet.sh tw -m $mID  $TWEET




fi

