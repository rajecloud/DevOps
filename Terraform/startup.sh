#!/bin/bash

version="$(terraform -v)"

if $version | grep -q '14.7'; then 
    echo "Current version is 14.7 already..!"
    exit 1
else
    sudo rm -rf /usr/local/bin/terraform
    wget https://releases.hashicorp.com/terraform/0.14.7/terraform_0.14.7_linux_amd64.zip
    sudo unzip terraform_0.14.7_linux_amd64.zip -d /usr/local/bin
    sudo rm -rf terraform_0.14.7_linux_amd64.zip
    terraform -v
fi

