#!/bin/bash

action=$1
username=$2
case $action in
        "add")
                useradd "$username"
                ;;
        "modify")
                usermod -s /bin/bash "$username"
                ;;
        "delete")
                userdel -r "$username"
                ;;
        *)
                echo "usage:$0 {add|modify|delete} username"
                exit
esac
