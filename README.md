# dockerized-whistler
A Docker Container and helper scripts that provide the full functionality of NCPI Whistler in an easy to install and use form. 

[Whistle](https://github.com/GoogleCloudPlatform/healthcare-data-harmonization) is google's Data Transformation Language which can be used to transform arbitrary JSON objects into FHIR compliant JSON objects. This repository contains a single docker image which includes a fully functioning version of 'whistle' as well as our [NCPI Whistler](https://github.com/NIH-NCPI/ncpi-whistler) application which can be used to transform CSVs into FHIR resources and load those resources into a FHIR server using FHIR's REST API. 

In addition to the docker image itself, an install script, 'install.sh', is provided to build the docker image and copies some helper scripts to a bin directory to all the user to interact with the dockerized applications as if they were installed as normal executables on the system. 

## Requirements
To use this repository, you should have docker installed as well as a full bash environment to run it in (I will look into Powershell options if there is interest) for those interested in using the install script. 

## Installation 
For those who don't care to directly deal with Docker, there is a bash script, simply clone this repository, cd into the root directory and run the install script: 

> ./install.sh

It will copy a number of scripts into $HOME/bin. If that directory isn't in your PATH, you can simply add the following line to the file $HOME/.bash_profile and reload it either by logging in again, or sourcing the file: 

(add the following line to the end of your .bash_profile file)
> export PATH=$PATH:$HOME/bin

(source the .bash_profile to effect the changes you made)
> source ~/.bash_profile

Once the whistle and the NCPI Whistler scripts are in your path, they should run just like any other command on your system: 
> whistle --help

> play --help

It should be noted that these scripts require that all files required by the tools to run can be found within the current working directory and that the arguments passed to those scripts and applications be relative to "." (the current working directory), not full paths. 