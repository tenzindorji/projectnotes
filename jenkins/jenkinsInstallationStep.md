#Jenkins installation steps:

##user data:

yum update -y \
yum install wget\
sudo yum install java-1.8.0-openjdk\
wget https://archive.apache.org/dist/tomcat/tomcat-9/v9.0.0.M10/bin/apache-tomcat-9.0.0.M10.tar.gz \
#jar xvf jenkins.war \
tar -xvf apache-tomcat-9.0.0.M10.tar.gz\
mv apache-tomcat-9.0.0.M10 tomcat9\
vi tomcat9/conf/tomcat-users.xml
  ```
  <?xml version='1.0' encoding='utf-8'?>
<tomcat-users>
    <role rolename="manager-gui"/>
    <role rolename="manager-script"/>
    <role rolename="manager-jmx"/>
    <role rolename="manager-jmx"/>
    <role rolename="admin-gui"/>
    <role rolename="admin-script"/>
    <user username="admin" password="admin" roles="manager-gui,manager-script,manager-jmx,manager-status,admin-gui,admin-script"/>
</tomcat-users>
  ```

tomcat9/webapps/manager/META-INF/context.xml
  - comment out Valve as below

```
<Context antiResourceLocking="false" privileged="true" >
<!--
  <Valve className="org.apache.catalina.valves.RemoteAddrValve"
         allow="127\.\d+\.\d+\.\d+|::1|0:0:0:0:0:0:0:1" />
-->
</Context>
```

./bin/startup.sh \

cd \
wget http://updates.jenkins-ci.org/download/war/2.7.3/jenkins.war

From tomcat UI, deploy the jenkins war file\
Context Path: /jenkins
WAR or Directory URL: /root/jenkins.war


#Install Jenkins on mac local
1. brew install jenkins-lts
2. sudo vi /usr/local/opt/jenkins-lts/homebrew.mxcl.jenkins-lts.plist
    - change 171.0.0.1 to 0.0.0.0 to be accessible from anywhere
3. brew services start jenkins-lts
