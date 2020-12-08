# Disable selinux
sudo cp /etc/sysconfig/selinux /etc/sysconfig/selinux.bak
sudo sed -i --follow-symlinks 's/^SELINUX=.*/SELINUX=disabled/g' /etc/sysconfig/selinux

# Upgrade kernel
sudo rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org
sudo yum install -y https://www.elrepo.org/elrepo-release-8.el8.elrepo.noarch.rpm
sudo yum --enablerepo=elrepo-kernel install kernel-ml -y
sudo rpm -qa|grep kernel
sudo reboot
