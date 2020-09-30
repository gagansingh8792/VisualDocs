#!/bin/bash


# information of the cuttent version

#VERSION=$( grep -i  -m 1  ":v" /opt/kubernetes/test.yml | awk '{print $5}'| tail -c 5 )
#echo "Current Version --> $VERSION"

IMAGE=$(cat /opt/kubernetes/finalplay.yml | grep -i -m 1 "gagansingh92/webtest" | awk '{print $5}' )
VERSION=$(echo $IMAGE | grep -o ":.*")
echo -e "\nCurrent Version --> $VERSION \n"

# getting new version
read -p "Enter the New Version Tag starting with colen ---> " new

# taking backup of the playbook 

now=$(date +"%Y-%m-%d_%I-%M")

cp /opt/kubernetes/finalplay.yml /opt/kubernetes/backPlayBook/finalplay-$now.yml
echo -e "\n--------------------\nPlayBook Backup has been Taken"

echo -e "\n--------------------\nUpdateing Version"

#sed command to change the version 
sed -i "s|$VERSION|$new|g" /opt/kubernetes/finalplay.yml

echo -e "\n--------------------\nVersion Updated"


UPDATED_IMAGE=$(cat /opt/kubernetes/finalplay.yml | grep -i -m 1 "gagansingh92/webtest" | awk '{print $5}' )
UPDATED_VERSION=$(echo $UPDATED_IMAGE | grep -o ":.*")
echo -e "\nUpdatd image and Version \n--------------------\nImage: $UPDATED_IMAGE\nVersion $UPDATED_VERSION\n\n"





