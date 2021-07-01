# Terraformify

Bash script to dynamically generate a TF module for an EC2 instance 


## **Overview**

The bash script uses a configuration file and populates `main.tf` and `variables.tf` with the necessary values. It also copies the files that are standard across all INF EC2 TF Modules. 

To make the most out of this script, it's written in such a way that it uses templates/config files all located at `$HOME\.terraformify\` this makes it easy to manage template files/updates to the script. 


## **Installation**
It's recommened to run the script `install.sh` to configure/install the script on your machine. 

This script does a few things: 

1. Creates the script directory as explained above. 
2. Copies or updates (if a new version is relased) the necessary files for the script
3. Adds `new_ec2` as an alias for easy use

> _**Note:** The `new_ec2` alias is added to your [`~/.bash_profile`](ttps://scriptingosx.com/2017/04/about-bash_profile-and-bashrc-on-macos/) (will be created if it doesn't excist) during the install. The alias allows the script `terraformify.sh` to be ran from anywhere._


## **Usage**
``` bash
Usage: new_ec2 [OPTIONS]
  
Options: 
  -r <ue1/uw1>        Specify region config to use [required]
  -i                  Will initalize the terraform module that is created from the template. 
  -h                  Display this message
  -u                  Update the config to be used. Uses region from -r flag.
```

### **The Config File**

The config file is used to generate the EC2 TF Module. It has a handful of variables that need to be changed they are self explanatory. The script provides an option to specifiy a specific config file to use, if none is specified it will use a the default config `tf_default.conf`. It's easiest to use the default config file and update/change as needed before you generate a new EC2 TF module. 

### **Config File Switches**

#### **`-r`** 

Specify the region you want to create the instance in. Will use a config file setup for that region. 

Currently UW1 and UE1 are supported. Use lowercase in value. 

``` bash
# UE1
$ new_ec2 -r ue1
# UW1
$ new_ec2 -r uw1
```
Config files are stored at `~/.terraformify/configs/`

#### **`-u`**

This is by far probably the most usefull part of this script. You can directly edit the default config by using this switch. It will open the default region config in vi and you can make the necessary changes and then save your changes. To edit in `vi` press the `i` key and make your changes. To exit and save your changes press `esc` and type `:wq`. For more info `vi` [this](tutorialspoint.com/unix/unix-vi-editor.htm) is a great guide. 

Note: you still need to specify the region using `-r`

``` bash
$ new_ec2 -r ue1 -u
```
### **Other Coool Things:**


#### **`-i`** 

Will intialize the newly generate module immediately following the module's creation. Handy when no other changes need to be made. 


### Version History 

2021-05-20 - v0.1.0 - inital relase 

2021-07-01 - v0.2.0 - add support for multiple regions
 
### ToDo

1. Create switch to specify a config that will dynamically change the necessary variables according to region. (i.e private key, region short code, VPC remote state, ect. )
2. Create switch that would use user input instead of a config file, could leverage a region config file to populate necessary values based on region code from user. 
3. Add additional error handaling and logging 
4. Pre-checks to make sure that module/instance doesn't already excist.
