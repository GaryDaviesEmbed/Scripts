#!/bin/bash


project="${1}"

if [ "${project}" == "" ]; then
	echo "Specify a project"
	exit 0
fi

if [ ! -d "${project}" ]; then
	echo "Could not find the project in the current directory"
	exit 0
fi


tar -cvzf ${project}.tar.gz ${project}

rm -rf ${project}

git clone https://github.com/GaryDaviesEmbed/${project}.git
if [ $? -ne 0 ]; then echo "git clone failed, create the repo"; exit 0; fi

tar -xvzf ${project}.tar.gz 

cd ${project}

git add *
git commit -m "init"
git push


