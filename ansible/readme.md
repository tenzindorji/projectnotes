# Ansible basic
It is a push type of configuration management tool

# Install ansible in AWS EC2 instance
1. https://github.com/ValaxyTech/DevOpsDemos/blob/master/Ansible/Ansible_installation_on_RHEL8.MD
```
yum update -y
yum install python3
yum repolist
alternatives --set python /usr/bin/python3
python
yum -y install python3-pip
useradd ansadmin
passwd ansadmin
useradd ansadmin
passwd ansadmin
echo "ansadmin ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
sed -ie 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
sudo service sshd reload
```

#install ansible under ansadmin
```
su - ansadmin
  pip3 install ansible --user
  ansible --version
  ssh-keygen
```

#Setup ansible:
1. after ansible is installed, update hosts file with client(webservers) or remote machine IPs
  ```
  vi /etc/ansible/hosts
  [kubernetes-master] #create host group
  x.x.x.x # add list of ip addresses for kubernetes master or domain
  ```
2. Create a play book in yaml
```
---
- name: deploy to kubernetes  
  hosts: kubernetes-master
  remote_user: root
  become: true
  tasks:
    - name: install httpd
    - yum:
        name: httpd
        state: latest
    - name: run httpd
      service:
        - name: httpd
          state: started
    - name: create content
      copy:
          content: "Congrats on installing ansible"
          dest: /var/www/html/index.html
```

- check the syntax of the play-book \
  `ansible-playbook simple.yml --syntax-check`
- execute the play-book
  `ansible-playbook simple.yml`


## why ansible ?
## What is ansible ?
  - IT automation
  - Configuration management
  - automate deployment
# Pull configuration and push configuration(no client install on remote server)
  - Adv, no need to install client on remove server

# inventory management
- hosts file

# Ansible Tower is GUI version of ansible


Ansible is installed under /usr/local/bin so add the path to bashr file in each users.

PATH=/usr/local/bin:$PATH

- Create a file call sudo vi /etc/ansible/hosts
```
[kubernetes-master] #kubernetes master server and its ip, user name is admin. User name was created during kops kubernetes setup
18.236.86.11 ansible_user=admin
```

- Validate the ansible
`ansible all -m ping`

```
18.236.86.11 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python"
    },
    "changed": false,
    "ping": "pong"
}
```
#
