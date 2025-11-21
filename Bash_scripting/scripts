#! /bin/bash

place="hyderabad"
echo "i am from $place"
echo "enter your name"
read myname
read -sp "enter your password" pass
echo -e "\n my name is $myname \n my password is $pass"

----------------------------------------------------------------------------------------------------------------------------------------------------
Arguments:

#! /bin/bash

echo "my name is $1"
echo "iam from $2"
echo "iam working in $3"
echo "all arguments are $@"
echo "file name is $0"

-> ./one.sh Thrinesh Hyderabad PWC
-----------------------------------------------------------------------------------------------------------------------------------------------------------

conditions:

#! /bin/bash

name=""
if [[ -z $name ]];   # if [[ -n $name]];
then
        echo "this is empty sting"
else
        echo " this is non-empty string"
fi

-----------------------------------------------------------------------------------------------------------------------------------------------------------
#! /bin/bash

name1="mustafa"
name2="devops"

if [[ $name1 == $name2 ]];  # if [[ $name1 !=$namee2]];
then    
        echo "equal"
else
        echo "not equal"
fi
-------------------------------------------------------------------------------------------------------------------------------------------------------------------
#! /bin/bash

x=99
y=121
if [[ $x -eq $y ]]; # -gt  -lt -ge -le
then    
        echo "equal"
else    
        echo "not equal"
fi      
------------------------------------------------------------------------------------------------------------------------------------------------------------------
#!/bin/bash

echo "enter your username"
read user
read -sp "enter your password: " pass

if [[ $user == "mustafa" && $pass == "admin@123" ]]; then
    echo -e "\nLogin success"
else
    echo -e "\nLogin failed"
fi

-------------------------------------------------------------------------------------------------------------------------------------------------------------
nested if

#!/bin/bash

echo "enter your username"
read user

if [[ $user == "mustafa" ]]; then
    read -sp "enter your password: " pass
    if [[ $pass == "admin@123" ]]; then
        echo -e "\nLogin success"
    else
        echo -e "\nEnter correct password"
    fi
else
    echo -e "\nEnter correct username"
fi

-----------------------------------------------------------------------------------------------------------------------------------------------------------------
for loop

#! /bin/bash

for value in {1..10}
do      
        echo " The Numbers are $value"
done   

while loop

#! /bin/bash

count=0
while [[ $count -lt 6 ]];
do
        echo "The value is $count"
        count=$((count+1))
done    
----------------------------------------------------------------------------------------------------------------------------------------------------------------
#! /bin/bash

if [[ $(whoami)=="root" ]];
then    
        echo "you are in root user"
else    
        echo "you are in non-root user"
fi    
---------------------------------------------------------------------------------------------------------------------------------------------------------
#! /bin/bash

name=$1
starts=$2
ends=$3
eval mkdir $name {$starts..$ends}









