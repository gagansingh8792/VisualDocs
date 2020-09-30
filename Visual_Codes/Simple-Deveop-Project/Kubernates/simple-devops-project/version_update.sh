#!/bin/bash


# information of the current version

#VERSION=$( grep -i  -m 1  ":v" /opt/kubernetes/test.yml | awk '{print $5}'| tail -c 5 )
#echo "Current Version --> $VERSION"

IMAGE=$(cat /tmp/simple-devops-project/deploy.yml | grep -i -m 1 "gagansingh92/webtest" | awk '{print $2}' )
VERSION=$(echo $IMAGE | grep -o ":.*")
echo -e "\nCurrent Version --> $VERSION \n"

# getting new version
read -p "Enter the New Version Tag starting with colen ---> " new

# taking backup of the playbook 

now=$(date +"%Y-%m-%d_%I-%M")

cp /tmp/simple-devops-project/deploy.yml  /tmp/simple-devops-project/backupManifist//deploy.yml-$now.yml
echo -e "\n--------------------\nManifist Backup has been Taken"

echo -e "\n--------------------\nUpdateing Version"

#sed command to change the version 
sed -i "s|$VERSION|$new|g" /tmp/simple-devops-project/deploy.yml

echo -e "\n--------------------\nVersion Updated"


UPDATED_IMAGE=$(cat /tmp/simple-devops-project/deploy.yml | grep -i -m 1 "gagansingh92/webtest" | awk '{print $2}' )
UPDATED_VERSION=$(echo $UPDATED_IMAGE | grep -o ":.*")
echo -e "\nUpdatd image and Version \n--------------------\nImage: $UPDATED_IMAGE\nVersion $UPDATED_VERSION\n\n"





