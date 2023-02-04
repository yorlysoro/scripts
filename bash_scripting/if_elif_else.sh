#!/bin/bash

age=0
echo "Example of if elif else sentece"
read -p "years old?" age
if [ $age -le 18 ]; then
	echo "The person is a teen"
elif [ $age -ge 19 ] && [ $age -le 64 ]; then
	echo "The person is adult"
else
	echo "Ther person is old adult"
fi
