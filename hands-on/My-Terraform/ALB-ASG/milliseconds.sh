#! /bin/bash

yum update -y
yum install python3 -y
pip3 install flask
cd /home/ec2-user
FOLDER='https://raw.githubusercontent.com/enes789/clarusway-aws/main/aws/projects/Project-002-Milliseconds-Converter'
wget $FOLDER/app.py
wget -P templates $FOLDER/templates/index.html
wget -P templates $FOLDER/templates/result.html
python3 app.py


