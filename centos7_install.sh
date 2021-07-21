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

# Update softwares
sudo yum -y update

# Add epel repo
sudo yum install epel-release -y

# Enable bbr
echo 'net.core.default_qdisc=fq' | sudo tee -a /etc/sysctl.conf
echo 'net.ipv4.tcp_congestion_control=bbr' | sudo tee -a /etc/sysctl.conf

# Prepare downloads dir
mkdir -p ~/downloads

# Install git
mkdir -p ~/downloads
cd ~/downloads
sudo yum install -y curl curl-devel expat-devel gettext-devel openssl-devel perl-devel zlib-devel asciidoc xmlto autoconf gcc wget
v=2.32.0;wget https://www.kernel.org/pub/software/scm/git/git-$v.tar.gz -O git-$v.tar.gz && tar -zxf git-$v.tar.gz && cd git-$v; unset v
make configure && ./configure --prefix=/usr && make && sudo make install
git --version

# Install python3
sudo yum -y update && sudo yum -y install yum-utils && sudo yum -y groupinstall development
sudo yum -y install https://repo.ius.io/ius-release-el7.rpm
sudo yum -y install python36u python36u-libs python36u-devel python36u-pip
sudo ln -s /usr/bin/python3.6 /usr/bin/python3; sudo ln -s /usr/bin/pip3.6 /usr/bin/pip3

# Install latest vim
sudo yum -y install perl perl-devel perl-ExtUtils-XSpp perl-ExtUtils-CBuilder perl-ExtUtils-Embed tcl-devel lua-devel ncurses-devel vim-X11
# cd /bin && sudo ln -s python3.6 python3
mkdir -p ~/downloads
cd ~/downloads
git clone https://github.com/vim/vim.git && cd vim

sudo ./configure --with-features=huge \
            --enable-multibyte \
	--enable-luainterp=yes \
            --enable-python3interp=yes \
            --enable-perlinterp \
            --enable-gui=auto \
            --enable-cscope \
            --prefix=/usr\
            --enable-fail-if-missing

make && sudo make install

# Install screen
sudo yum -y install screen

# Install tmux
sudo yum -y install libevent ncurses libevent-devel ncurses-devel gcc make bison pkg-config automake autoconf
mkdir -p ~/downloads
cd ~/downloads
git clone https://github.com/tmux/tmux.git
cd tmux
sh autogen.sh
./configure && make && sudo make install

# Install dotnet
sudo rpm -Uvh https://packages.microsoft.com/config/centos/7/packages-microsoft-prod.rpm
sudo yum -y install dotnet-sdk-2.2
sudo yum -y install dotnet-sdk-3.1
sudo yum -y install dotnet-sdk-5.0

# Install golang
mkdir -p ~/downloads
cd ~/downloads
v=1.16.6;wget https://golang.org/dl/go$v.linux-amd64.tar.gz && \
sudo rm -rf /usr/local/go && \
sudo tar -C /usr/local -xzf go$v.linux-amd64.tar.gz
echo 'PATH=$PATH:/usr/local/go/bin' | sudo tee -a /etc/profile
source /etc/profile
go version

# Install NodeJS 12.x
curl -sL https://rpm.nodesource.com/setup_12.x | sudo bash -
sudo yum install -y nodejs
curl --silent --location https://dl.yarnpkg.com/rpm/yarn.repo | sudo tee /etc/yum.repos.d/yarn.repo
sudo rpm --import https://dl.yarnpkg.com/rpm/pubkey.gpg
sudo yum -y install yarn

# Init new disk
fdisk -u /dev/vdb
mkfs -t ext4 /dev/vdb1
cp /etc/fstab /etc/fstab.bak
echo `blkid /dev/vdb1 | awk '{print $2}' | sed 's/\"//g'` /fullnode ext4 defaults 0 0 >> /etc/fstab
mkdir /fullnode
mount /dev/vdb1 /fullnode


# Install AWS SSM
# https://docs.aws.amazon.com/zh_cn/systems-manager/latest/userguide/sysman-manual-agent-install.html#agent-install-centos
sudo yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
sudo systemctl enable amazon-ssm-agent
sudo systemctl start amazon-ssm-agent
sudo systemctl status amazon-ssm-agent

# Install AWS CloudWatch
cd ~/downloads
wget https://s3.amazonaws.com/amazoncloudwatch-agent/centos/amd64/latest/amazon-cloudwatch-agent.rpm
sudo rpm -U ./amazon-cloudwatch-agent.rpm
# Copy cloud watch configuration from aws console to ~/downloads/config.json
sudo yum -y install collectd
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -s -c file:config.json
systemctl status amazon-cloudwatch-agent

# Install AWS CodeDeploy
sudo yum -y update
sudo yum -y install ruby
sudo yum -y install wget
mkdir -p ~/downloads && cd ~/downloads
wget https://aws-codedeploy-ap-northeast-1.s3.ap-northeast-1.amazonaws.com/latest/install
chmod +x ./install
sudo ./install auto
sudo service codedeploy-agent status

# Set custom hostname
sudo hostnamectl set-hostname XXX
sudo sh -c 'echo "preserve_hostname: true" >> /etc/cloud/cloud.cfg'

# Create ssh data for user www
su - www

mkdir ~/.ssh
chmod 700 ~/.ssh
touch ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys

exit
vim /home/www/.ssh/authorized_keys
sudo chattr +i /home/www/.ssh/authorized_keys
sudo chattr +i /home/www/.ssh
