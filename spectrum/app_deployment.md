## Jenkins Job app deployment

This project is parameterized
  - Active Choices Parameter
    Name: ACTION
    script: Grovy Script (select this)
      Script:
        Grovy Script: return["DEPLOY", "ROLLBACK"]
        Check "Use Grovy Sandbox"
    Description:
      <p>
      Click <b style='color:blue;'> DEPLOY</b> to Deploy to UAT servers<br>
      Click <b style='color:orange;'> ROLLBACK</b> to revert to previous version
      </p>
    Choice Type: Radio Buttons
    Filter Start at: 1

  - Active Choices Reactive Reference Parameter
    Name: VERSION
    script: Grovy Script (select this)
      Script:
        Grovy Script:
          ```
          if  ( ACTION == "DEPLOY" ) {
          deployHtml = '''
          <input type="text" class="setting-input" name="value">
          Fetch VERSION Number from Artifactory under SNAPSHOT folder:
          <a href="https://jfrog.example.com/ui/repos/tree/General/ext-snapshot-local%2Fcom%2Ftenzin%2Fcore">Artifactory Link</a> <br>
          Provide the VERSION input, Example: <b style='color:red;'> core-2.02.0-20220201.202643-7.jar</b>
          '''

          return deployHtml

          }
          ```


        Check "Use Grovy Sandbox"
    Choice Type: Formatted HTML
    Referenced parameters: ACTION


  - Bindings
    Username and Password(Separated):
      Username Variable: JENKINS_USER
      Password Variable: JENKINS_PASSWORD
    Credentials:
      Specific credentials
        Bit Bucket and Artifactory


  - Build
    Execute Shell

```
#!/bin/bash

set -e

HOME_FOLDER="/data/apps/css-core/corerec"
SERVERS=("server1.example.com" "server2.example.com")

if [[ $VERSION ==  *"core"* ]];then

VERSION=`echo $VERSION|tr -d [:blank:]`
VERSION=`echo $VERSION|sed s/.$//`
REPOSITORY="ext-snapshot-local/com/tenzin/core"
ARTIFACT="${ARTIFACTORY_URL}/${REPOSITORY}/`echo ${VERSION}|awk -F"-" '{print $2}'`-SNAPSHOT/${VERSION}" &> /dev/null

echo "List available Versions:"
curl  -u ${JENKINS_USER}:${JENKINS_PASSWORD} ${ARTIFACTORY_URL}/api/search/artifact\?name\=core\&repos\=ext-snapshot-local\&type\=artifacts -#| grep .jar|awk -F"/" '{print $NF}'| sed 's/.$//'|sort -r



echo $ARTIFACT

for SERVER in "${SERVERS[@]}"
do
SSH_OPTION="ssh -q jenkins_worker@${SERVER} -o StrictHostKeyChecking=no"


echo ""
echo "################# Deploying on $SERVER #######################"

$SSH_OPTION << END_CONNECTION
	sudo su -
    cp -fp $HOME_FOLDER/webapps/core.jar /data/backups/
    rm -rf /tmp/core*.jar &> /dev/null
    #curl --output /tmp/core.jar -u ${JENKINS_USER}:${JENKINS_PASSWORD} $ARTIFACT

    wget --no-check-certificate --progress=bar:force --user ${JENKINS_USER} --password ${JENKINS_PASSWORD} ${ARTIFACT} -P /tmp/ 2>&1 | tail -f -n +6
    mv -f /tmp/core*.jar $HOME_FOLDER/webapps/core.jar
    chmod 755 $HOME_FOLDER/webapps/core.jar
    chown my-service-account:my-service-account-group $HOME_FOLDER/webapps/core.jar

    systemctl stop corerec.service
    systemctl start corerec.service
    #systemctl status corerec.service
    /data/apps/css-core/corerec/bin/app-status.sh  

END_CONNECTION

done

elif [[ $ACTION == "ROLLBACK" ]]; then
for SERVER in "${SERVERS[@]}"
do
SSH_OPTION="ssh -q jenkins_worker@${SERVER} -o StrictHostKeyChecking=no"
echo ""
echo "################## Rollback on $SERVER #######################"
$SSH_OPTION << END_CONNECTION
    sudo su -
    cp -fp /data/backups/core.jar $HOME_FOLDER/webapps/
    chmod 755 $HOME_FOLDER/webapps/core.jar
    systemctl stop corerec.service
    systemctl start corerec.service
    #systemctl status corerec.service
    /data/apps/css-core/corerec/bin/app-status.sh

END_CONNECTION
done
fi

echo ""
```
