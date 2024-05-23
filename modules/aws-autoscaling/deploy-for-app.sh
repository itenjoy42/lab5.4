#!/bin/bash


yum update -y
yum upgrade -y
yum install -y nginx

# Nginx 서비스 활성화 및 시작
systemctl enable nginx
systemctl restart nginx

# Nginx 디폴트 페이지 수정
echo "I'm App" > /usr/share/nginx/html/index.html

yum install mysql-server -y
# MySQL 서비스 시작 및 활성화
systemctl start mysqld
systemctl enable mysqld

yum install amazon-cloudwatch-agent -y
