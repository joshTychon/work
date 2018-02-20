#!/bin/bash

function setupTomcat() {

	sudo apt-get update
	sudo apt-get install default-jdk


	#create tomcat user
	sudo groupadd tomcat
	sudo useradd -s /bin/false -g tomcat -d /opt/tomcat tomcat
	

	cd ~
	wget http://www.us.apache.org/dist/tomcat/tomcat-8/v8.5.23/bin/apache-tomcat-8.5.23.tar.gz
	sudo mkdir /opt/tomcat
	sudo tar xvf apache-tomcat-8*tar.gz -C /opt/tomcat --strip-components=1

	#update permissions
	cd /opt/tomcat
	sudo chmod 777 conf/
	sudo chgrp -R tomcat conf
	sudo chmod g+rwx conf
	sudo chmod g+r conf/*
	sudo chown -R tomcat work/ temp/ logs/
	 

	java=$(sudo update-alternatives --config java | head -1 | cut -f2 -d":" | sed "s/\/bin\/java//g")
	echo $java
	java=$(echo $java | cut -f2 -d" ")
	echo $java
	#sudo nano /etc/init/tomcat.conf
	cd /etc/
	sudo chmod 777 init/
	cd init/
	sudo echo -ne "l$java l" >> /home/josh/Desktop/test.txt
	sudo echo -ne "" > tomcat.conf	
	sudo echo -ne "description \"Tomcat Server\"
 start on runlevel [2345]
 stop on runlevel [!2345]
 respawn
 respawn limit 10 5

 setuid tomcat
 setgid tomcat

 env JAVA_HOME=$java
 env CATALINA_HOME=/opt/tomcat

 # Modify these options as needed
 env JAVA_OPTS=\"-Djava.awt.headless=true -Djava.security.egd=file:/dev/./urandom\"
 env CATALINA_OPTS=\"-Xms512M -Xmx1024M -server -XX:+UseParallelGC\"

 exec $CATALINA_HOME/bin/catalina.sh run

 # cleanup temp directory after stop
 post-stop script
  rm -rf $CATALINA_HOME/temp/*
 end script" >> tomcat.conf
	
	sudo initctl reload-configuration
	sudo initctl start tomcat
	
}

setupTomcat
