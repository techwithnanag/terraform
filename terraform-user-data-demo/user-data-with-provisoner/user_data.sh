#!/bin/bash
sudo apt update
sudo apt install -y git wget unzip curl
sudo apt install apache2 -y
sudo systemctl start apache2
sudo systemctl enable apache2
echo '<!DOCTYPE html>
<html>
<head>
    <title>techwithso4</title>
</head>
<body>
    <h1>Hello, welcome to techwithso4!</h1>
    <p>This is a nomore#####, World!" webpage hosted on server with IP '"$(hostname -i)"'</p>
</body>
</html>' | sudo tee /var/www/html/index.html

