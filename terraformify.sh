#!/usr/bin/env bash
#generates a EC2 module from template files
#to use this script effectivly:
# 1.  copy this hole folder to a directory (i.e ~/.tf_generator)
# 2.  add that directory to your path (i.e export PATH=$PATH:~/.tf_generator) 
# 3. update the template paths accordingly



__usage="
Usage: new_ec2 [OPTIONS]
  
Options: 
  -c <config file>    Specify the config file to use for the template. Can be either a file name or file path. If not specified will use ~/.terraformify/tf_default.conf
  -i                  Will initalize the terraform module that is created from the template. 
  -h                  Display this message
  -u                  Update the default config. Useful to edit default config before each use, rather then writing a whole config for each use 
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
  vi ${script_path}/tf_default.conf
  exit 0
}


while true;do   
  case "$1" in
    -c | --config)
      config_file=$2
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
  echo "no config file was specified using default..." 
  config_file=${script_path}/tf_default.conf 
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
