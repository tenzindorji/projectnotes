# components of systemd
- journald
  - event logging ... will show errors on startup
- logind
  - manager user login
- resolved
  - Name resolution
- timesyncd
  - NTP
- networkd
  - handles network interfaces, including DHCP
- tmpfiles
  - Garbage collection for temp files
- timedated
  - handles time/date settings, like time zone
- udevd
  - device manager
- systemd-boot
  - boot manager


# journalctl
- shows the log
  - `journalctl -b` since the last boot
  - `journalctl --since "1 hour ago"`
  - `journalctl -u core.service` for specific Unit file
  - `journalctl -u core.service  -f` shows in real time

# More on Unit files
- .service
  - How to manage a service(where is it? How to start/stop, etc)
- .socket
  - defines network socket, and what service(s) to spawn and handle the socket
- .device
  - for mounting devices using systemd
- .mount
  - defines a mount point(i.e, fstb)
- .target
  - indicates a collection of unit files to be started/stopped when transitioning to a new stage, i.e, when you initially start linux.

# Unit file for a service:
- The unit file contains "sections"
- each section contains key=value(uses .INI syntax)
- A service typically will have these three sections:
  - [Unit]
  	- Description=A description of your services
  	- After=network.target
  - [Service]
  	- EnvironmentFile=-/etc/sysconf/mysqld
  		- The ‘–‘ character at the start of the EnvironmentFile value is to let systemd ignore errors if the file does not exist.

  	- Type=simple
  		- simple: this is common.
  		- Forking: the binary will start another process
  		- Oneshot: The binary will do something than exit
  		- Notify: will send a notification when it has completed startup
  	- User=student
  	- WorkingDirectory=/home/student
  	- ExecStart=/usr/bin/binary
  	- ExecStop=
  	- Restart=on-abort
  		- always
  		- on-success
  		- on-failures
  		- on-abnormal
  		- on-abort
      - on-watchdogv

  - [Install]
  	- WantedBy=multi-user.target 	

# A Note on [Socket]:
- Common for socket activated services
- More efficient and secure than service binding
- you can define options here
- See
	- Documenations
	- Examples in your unit files
