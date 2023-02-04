#!/bin/bash

ClassPoint=0
age=0

echo "Example of if else sentence"
read -n1 -p "Put your points in class (1-9):" ClassPoint
echo -e "\n"
if (( $ClassPoint >= 7)); then
	echo "You aprobed the class"
else
	echo "You not aprobed the class"
fi

read -p "what year old do you have? " age
if [ $age -le 18 ]; then
	echo "The person cannot vote"
else
	echo "The person can be vote"
fi
