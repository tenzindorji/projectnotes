## Steps to utilize systemd for java service auto start during patching/rebooting the server
1. Create dependency for micro services
- Example for a zookeeper.service and kafka service
- `vi /usr/lib/systemd/system/zookeeper.service`
- Put below content in the file
```
[Unit]
Description=zookeeper service
Requires=network.target
After=network.target # should start only after dependent service is started

[Service]
Environment=LOG_DIR=/data/apps/kafka/logs-0
User=oosuser
Group=oosuser
Type=forking
StandardOutput=journal+console
ExecStartPre=/bin/sleep 30 #wait after dependent service is started
ExecStart=/data/apps/kafka/bin/zookeeper-server-start.sh -daemon /data/apps/kafka/config/zookeeper-0.properties

[Install]
WantedBy=multi-user.target
 Create a kafka.service under /usr/lib/systemd/system/
 ```
 ```
[Unit]
Description=kafka service
After=zookeeper.service # should start only after zookeeper is started

[Service]
Environment=LOG_DIR=/data/apps/kafka/logs
User=oosuser
Group=oosuser
Type=forking
StandardOutput=journal+console
ExecStartPre=/bin/sleep 30 #wait after dependent service is started
ExecStart=/data/apps/kafka/bin/kafka-server-start.sh -daemon /data/apps/kafka/config/server-0.properties

[Install]
WantedBy=multi-user.target
```
- For other micro services, create app_name.service for each services under /usr/lib/systemd/system/
```
[Unit]
Description=<app_name> service
After=kafka.service # should start only after kafka service is started

[Service]
User=app_user
Group=app_group
Type=forking
StandardOutput=journal+console
ExecStartPre=/bin/sleep 60 #wait after dependent service is started
ExecStart=/bin/sh <app_folder>/bin/app-start.sh

[Install]
WantedBy=multi-user.target
```
2. reload daemon and enable the service
`systemctl daemon-reload`\
`systemctl enable <app_name>.service` Need to enable for all the services created above
3. Try out by running the systemctl command
`systemctl start/status/stop zookeeper.service`\
`systemctl start/status/stop kafka.service`\
`systemctl start/status/stop <app_name>.service`
4. To test auto start, need to reboot the server
5. Useful troubleshooting commands
`systemctl cat <app_name>.service` #view the config\
`systemctl list-dependencies <app_name>.service` list the dependency tree\
`systemctl show <app_name>.service` list all the default settings for systemd\
`systemctl disable <app_name>.service`disable auto start during reboot\
`journalctl -ex`view the logs for systemd\
`journalctl -u <app_name>.service` view the log only for service name
