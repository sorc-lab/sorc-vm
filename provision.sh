#!/bin/bash

apt-get update -y && apt-get upgrade -y

# install PHP 7
sudo apt-get -y install php7.0 php7.0-curl php7.0-intl php7.0-gd php7.0-mcrypt php7.0-iconv php7.0-xsl php7.0-mbstring php7.0-zip php7.0-pdo php7.0-xml php7.0-json php7.0-mysqli php7.0-mysql php7.0-xmlwriter php7.0-xmlreader php7.0-soap php7.0-mysql libapache2-mod-php7.0
php -v

# install Java 9 (with silent install)
apt-get install -y python-software-properties debconf-utils
add-apt-repository -y ppa:webupd8team/java
apt-get update
echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 select true" | sudo debconf-set-selections
apt-get install -y oracle-java9-installer
