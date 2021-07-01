#!/bin/bash

#installs and configures terraformify 

script_path="$HOME/.terraformify" 
script_file="$HOME/.terraformify/terraformify.sh"


# check/create bash_profile 
if ! [ -L ~/.bash_profile ] || ! [ -f ~/.bash_profile ]  
then
  echo "no bash profile found....creating..."
  touch ~/.bash_profile 
else
  echo "bash profile found...continuing..."
fi

#create directorys for script
if ! [ -d "$script_path" ]
then 
  echo "creating directories for script...."
  mkdir ${script_path}
  mkdir ${script_path}/templates
elif ! [ -d ${script_path}/templates ]
then 
  mkdir ${script_path}/templates
else
  echo "all script directories found...continuing..."
fi

#copy folder, will copy/update with latest files  
echo "copying/updating  script folder.."
cp -r . ${script_path}/
#create executable script 
chmod 755 ${script_file} 

#create neccessary aliases

#add script alias
if grep -q "new_ec2" ~/.bash_profile
then
  echo "command alias already exists...skipping..." 
else
  echo 'adding alias to bash profile...'
  echo 'alias new_ec2="sh "~/.terraformify/terraformify.sh "' >> ~/.bash_profile
  # update bash profile interactively
  source ~/.bash_profile
fi

echo "Succefully installed Terraformify. You can now use 'new_ec2' to generate EC2 TF configs! :)" 
 
