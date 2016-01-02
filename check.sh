#!/bin/sh

#check if script is located in /home direcotry
pwd | grep "^/home/" > /dev/null
if [ $? -ne 0 ]; then
  echo script must be located in /home direcotry
  break
fi

#it is hightly recommended to place this directory in another direcotry
deep=$(pwd | sed "s/\//\n/g" | grep -v "^$" | wc -l)
if [ $deep -lt 4 ]; then
  echo please place this script in another directory
  break
fi

#check if email sender exists
if [ ! -f "../send-email.py" ]; then
  echo send-email.py not found. downloading now..
  wget https://gist.githubusercontent.com/superdaigo/3754055/raw/e28b4b65110b790e4c3e4891ea36b39cd8fcf8e0/zabbix-alert-smtp.sh -O ../send-email.py -q
fi

#check if email sender is configured
grep "your.account@gmail.com" ../send-email.py > /dev/null
if [ $? -eq 0 ]; then
  echo username is not configured in ../send-email.py please look at the line:
  grep -in "your.account@gmail.com" ../send-email.py
  echo sed -i \"s/your.account@gmail.com//\" ../send-email.py
  echo
fi

#check if email password is configured
grep "your mail password" ../send-email.py > /dev/null
if [ $? -eq 0 ]; then
  echo password is not configured in ../send-email.py please look at line:
  grep -in "your mail password" ../send-email.py
  echo sed -i \"s/your mail password//\" ../send-email.py
  break
fi


#set application name based on directory name
#this will be used for future temp direcotry, database name, google upload config, archiving
appname=$(pwd | sed "s/^.*\///g")

#set temp direcotry in varable based on applicaition name
tmp=$(echo ../tmp/$appname)

#create temp direcotry
if [ ! -d "$tmp" ]; then
  mkdir -p "$tmp"
fi

#check if database direcotry has prepared 
if [ ! -d "../db" ]; then
  mkdir -p "../db"
fi

#if database file do not exist then create one
if [ ! -f "../db/$appname.db" ]; then
  touch "../db/$appname.db"
fi

#check if google drive config directory has been made
#if the config file exists then use it to upload file in google drive
#if no config file is in the directory there no upload will happen
if [ ! -d "../gd" ]; then
  mkdir -p "../gd"
fi

#check if 7z command is installed
sudo dpkg -l | grep p7zip-full > /dev/null
if [ $? -ne 0 ]
then
  echo 7z support no installed. Please run:
  echo sudo apt-get install p7zip-full
fi


#clean and remove temp direcotry
rm $tmp -rf > /dev/null
