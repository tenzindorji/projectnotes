# Install ansible in AWS EC2 instance
1. https://github.com/ValaxyTech/DevOpsDemos/blob/master/Ansible/Ansible_installation_on_RHEL8.MD

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
su - ansadmin
  pip3 install ansible --user
  ansible --version
  ssh-keygen
  
