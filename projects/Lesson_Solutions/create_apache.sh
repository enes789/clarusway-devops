#! /bin/bash
sudo su
yum -y install httpd
echo "<html>
<head>
    <title>Terraform</title>
</head>
<body>
    <center><h1>Clarusway Terraform Project 1</h1></center>
    <br><br><br><br><br>
    <center><h3>This instance is created by Terraform</h3></center>
</body>
</html>" > /var/www/html/index.html
sudo systemctl enable httpd
sudo systemctl start httpd