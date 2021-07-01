#!/usr/bin/env bash
#generates a EC2 module from template files
#to use this script effectivly:
# 1.  copy this hole folder to a directory (i.e ~/.tf_generator)
# 2.  add that directory to your path (i.e export PATH=$PATH:~/.tf_generator) 
# 3. update the template paths accordingly



__usage="
Usage: new_ec2 [OPTIONS]
  
Options: 
  -r <ue1/uw1>        Specify region config to use [required]
  -i                  Will initalize the terraform module that is created from the template. 
  -h                  Display this message
  -u                  Update the config to be used. Uses region from -r flag.
  
" 
script_path="$HOME/.terraformify" 

#exit if not configured 
if ! [ -d ${script_path} ] 
then
  echo "ERROR: you have not ran the install script, please do so before continuing"
  exit 1;
fi


#update config file function
function update_config () {
  vi ${config_file}
  exit 0
}
while true;do   
  case "$1" in
    -r | --region)
      if [[ -z $2 ]]
      then
        echo "Region value was blank. Please specify (ue1/uw1)"
        exit 1;
      elif [[ $2 = "ue1" ]]
      then
        config_file=${script_path}/configs/ue1_default.conf
      elif [[ $2 = "uw1" ]]
      then
        config_file=${script_path}/configs/uw1_default.conf
      fi
      shift 2;;
    -u | --update) 
      update_config
      ;;
    -i | --init )
      tf_init=true
      shift ;;
   -h | --help) 
      echo "$__usage"
      exit 0
      ;;
    -* ) 
      echo "invalid option: $1"
      echo "$__usage" 
      exit 1
      ;;  
    * )
      break;;
  esac
done

if [ -z "$config_file" ] 
then
  echo "No region was specified. Please specify with -r <ue1/uw1>" 
  exit 1; 
fi
#template paths

main_template=${script_path}/templates/main.tpl
variables_template=${script_path}/templates/variables.tpl

#tf files that don't need to be editied
fixed_templates_directory=${script_path}/templates/fixed/*

#source the config file 
. ${config_file}

#create directory/directory name from instance name and strip quotes
directory_name=$(echo ${instance_name} | sed 's/\"//g')
mkdir ${directory_name}

#copy fixed tf files 
cp -r ${fixed_templates_directory} ${directory_name}

#generate dynamic TF files 
eval "echo \"$(cat "${main_template}")\"" > ${directory_name}/main.tf
eval "echo \"$(cat "${variables_template}")\"" > ${directory_name}/variables.tf

if [ "$tf_init" = true ]; then 
  cd ${directory_name}
  terraform init
fi
