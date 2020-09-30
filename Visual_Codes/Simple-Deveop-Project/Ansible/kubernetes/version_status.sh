#!/bin/bash

#get the version forn the file

#IMAGE=$(grep -i  -m 1  ":v" /opt/kubernetes/test.yml | awk '{print $5}')

IMAGE=$(cat /opt/kubernetes/finalplay.yml | grep -i -m 1 "gagansingh92/webtest" | awk '{print $5}' )

#VERSION=$( grep -i  -m 1  ":v" /opt/kubernetes/test.yml | awk '{print $5}'| tail -c 5 )
 
#VERSION=$(cat /opt/kubernetes/test.yml | grep -i -m 1 "gagansingh92/webtest" | awk '{print $5}' |tail -c 5)

VERSION=$(echo $IMAGE | grep -o ":.*")

echo -e "\nImage: $IMAGE\nVersion $VERSION\n"
