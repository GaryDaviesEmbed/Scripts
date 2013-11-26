#!/bin/bash

project="${1}"
if [ "${project}" == "" ]; then
	echo "Usage PROJECT NEWBRANCH FROMBRANCH"
	echo "    eg. EmGuest test-branch \"origin master\""
	exit 0
fi

echo "Project: ${project}"

branch="${2}"
if [ "${branch}" == "" ]; then
	echo "Specify new branch name"
	exit 0
fi

echo "New branch ${branch}"

from="${3}"
if [ "${from}" == "" ]; then
	echo -n "Would you like to branch from origin master y/n[n]? "
	read response
	if [ "${response}" == "y" ]; then
		from="origin master"
	else
		echo "Specify where to branch from eg. origin master"
		exit 0
	fi
fi

echo "Branch from: ${from}"


rm -rf newBranch
mkdir newBranch
if [ ! -d newBranch ]; then
	echo "mkdir newBranch failed"
	exit 0
fi
cd newBranch
if [ $? -ne 0 ]; then echo "Failed to make temp dir"; exit 0; fi

if [ "${project}" == "EmGuest" ]; then
	git clone https://github.com/GaryDaviesEmbed/EmGuest.git
	if [ $? -ne 0 ]; then echo "git clone project failed"; exit 0; fi
fi

if [ ! -d ${project} ]; then
	echo "git clone failed"
	exit 0
fi

cd ${project}

config=.git/config

echo "" >> ${config}
echo "[remote \"upstream\"]" >> ${config}
echo -e "\turl = https://github.com/embedcard/${project}.git" >> ${config}

echo "Pulling from upstream master"
echo ""

git pull upstream master
if [ $? -ne 0 ]; then echo "git pull upstream master failed"; exit 0; fi

echo "Pushing to origin master"
echo ""

git push origin master
if [ $? -ne 0 ]; then echo "git push origin master failed"; exit 0; fi

git checkout -b "${branch}"
if [ $? -ne 0 ]; then echo "git checkout -b ${branch} failed"; exit 0; fi

git push origin test-branch
if [ $? -ne 0 ]; then echo "git push branch to origin master failed"; exit 0; fi

