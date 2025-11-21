#!/bin/bash

services=("httpd" "jenkins" "docker")
for service in "${services[@]}"; 
do
    if systemctl is-active --quiet "$service"; 
    then
        echo "The $service service is running"
    else
        echo "The $service service is not running"
    fi
done
