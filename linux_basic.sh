# Delete all rules in iptables
sudo iptables -F

# Disable selinux
sudo cp /etc/sysconfig/selinux /etc/sysconfig/selinux.bak
sudo sed -i --follow-symlinks 's/^SELINUX=.*/SELINUX=disabled/g' /etc/sysconfig/selinux

# Upgrade kernel
sudo rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org
sudo yum -y install https://www.elrepo.org/elrepo-release-7.el7.elrepo.noarch.rpm
sudo yum --enablerepo=elrepo-kernel install kernel-ml -y
sudo rpm -qa|grep kernel
sudo egrep ^menuentry /etc/grub2.cfg | cut -f 2 -d \'
sudo grub2-set-default 0
sudo reboot
