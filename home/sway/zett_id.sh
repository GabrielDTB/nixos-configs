#!/bin/bash 

minute=$(date +%M)
hour=$(printf $(printf '\%o' $(($(date +%H)+96))))
day=$(date +%d)
month=$(printf $(printf '\%o' $(($(date +%m)+96))))
year=$(echo $(date +%Y) | cut -c 3-)
echo $year$month$day$hour$minute
