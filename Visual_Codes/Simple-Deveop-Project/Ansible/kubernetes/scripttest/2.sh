#!/bin/bash

TEST=$(cat 1.txt | grep -i -m 1 "v" | tail -c 5)

echo $TEST


sed -i "s|$TEST|v1.10|g" /opt/kubernetes/1.txt
