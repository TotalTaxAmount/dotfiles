#!/bin/bash

cachedir=~/.cache/rbn
cachefile=${0##*/}-$1

if [ ! -d $cachedir ]; then
    mkdir -p $cachedir
fi

if [ ! -f $cachedir/$cachefile ]; then
    touch $cachedir/$cachefile
fi

# Save current IFS
SAVEIFS=$IFS
# Change IFS to new line.
IFS=$'\n'

cacheage=$(($(date +%s) - $(stat -c '%Y' "$cachedir/$cachefile")))
if [ $cacheage -gt 1740 ] || [ ! -s $cachedir/$cachefile ]; then
    data=($(curl -s https://en.wttr.in/$1\?0qnT 2>&1))
    echo ${data[0]} | cut -f1 -d, > $cachedir/$cachefile
    echo ${data[1]} | sed -E 's/^.{15}//' >> $cachedir/$cachefile
    echo ${data[2]} | sed -E 's/^.{15}//' >> $cachedir/$cachefile
fi

weather=($(cat $cachedir/$cachefile))

# Restore IFSClear
IFS=$SAVEIFS

temperature=$(echo ${weather[2]} | sed -E 's/([[:digit:]]+)\.\./\1 to /g')

#echo ${weather[1]##*,}

# https://fontawesome.com/icons?s=solid&c=weather
case $(echo ${weather[1]##*,} | tr '[:upper:]' '[:lower:]') in
"clear" | "sunny")
    condition="☀&#xFE0E;"
    ;;
"partly cloudy")
    condition="⛅&#xFE0E;"
    ;;
"cloudy")
    condition="🌥&#xFE0E;"
    ;;
"overcast")
    condition="☁&#xFE0E;"
    ;;
"mist" | "fog" | "freezing fog")
    condition="🌫&#xFE0E;"
    ;;
"patchy rain possible" | "patchy light drizzle" | "light drizzle" | "patchy light rain" | "light rain" | "light rain shower" | "rain")
    condition="🌦&#xFE0E;"
    ;;
"moderate rain at times" | "moderate rain" | "heavy rain at times" | "heavy rain" | "moderate or heavy rain shower" | "torrential rain shower" | "rain shower")
    condition="🌧&#xFE0E;"
    ;;
"patchy snow possible" | "patchy sleet possible" | "patchy freezing drizzle possible" | "freezing drizzle" | "heavy freezing drizzle" | "light freezing rain" | "moderate or heavy freezing rain" | "light sleet" | "ice pellets" | "light sleet showers" | "moderate or heavy sleet showers")
    condition="🌨&#xFE0E;"
    ;;
"blowing snow" | "moderate or heavy sleet" | "patchy light snow" | "light snow" | "light snow showers")
    condition="❆&#xFE0E;"
    ;;
"blizzard" | "patchy moderate snow" | "moderate snow" | "patchy heavy snow" | "heavy snow" | "moderate or heavy snow with thunder" | "moderate or heavy snow showers")
    condition="❅❅&#xFE0E;"
    ;;
"thundery outbreaks possible" | "patchy light rain with thunder" | "moderate or heavy rain with thunder" | "patchy light snow with thunder")
    condition="⛈&#xFE0E;"
    ;;
*)
    condition="⛈&#xFE0E;"
    echo -e "{\"text\":\""$condition"\", \"alt\":\""${weather[0]}"\", \"tooltip\":\""${weather[0]}: $temperature ${weather[1]}"\"}"
    ;;
esac

#echo $temp $condition

echo -e "{\"text\":\""$temperature $condition"\", \"alt\":\""${weather[0]}"\", \"tooltip\":\""${weather[0]}: $temperature ${weather[1]}"\"}"
