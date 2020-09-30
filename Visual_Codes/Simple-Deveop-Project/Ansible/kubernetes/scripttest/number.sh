#!/bin/bash

number=0
n=5
read -p "enter the number > " number

echo "the number you entered is > $number"

if [[ $number > $n ]]; then
    echo "Number $number greater then $n "
else
    echo "Number $number smaller then $n"
fi
