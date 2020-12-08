# Disable selinux
sudo cp /etc/sysconfig/selinux /etc/sysconfig/selinux.bak
sudo sed -i --follow-symlinks 's/^SELINUX=.*/SELINUX=disabled/g' /etc/sysconfig/selinux

# Upgrade kernel
sudo rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org
sudo yum install -y https://www.elrepo.org/elrepo-release-8.el8.elrepo.noarch.rpm
sudo yum --enablerepo=elrepo-kernel install kernel-ml -y
sudo rpm -qa|grep kernel
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
sudo yum install -y make curl curl-devel expat-devel gettext-devel openssl-devel perl-devel zlib-devel asciidoc xmlto autoconf gcc wget
v=2.29.2;wget https://www.kernel.org/pub/software/scm/git/git-$v.tar.gz -O git-$v.tar.gz && tar -zxf git-$v.tar.gz && cd git-$v; unset v
make configure && ./configure --prefix=/usr && make && sudo make install

# Install python3
sudo yum -y install python3 python3-devel

# Install latest vim
sudo yum -y install perl perl-devel perl-ExtUtils-CBuilder perl-ExtUtils-Embed tcl-devel ncurses-devel vim-X11
# cd /bin && sudo ln -s python3.6 python3
mkdir -p ~/downloads
cd ~/downloads
git clone https://github.com/vim/vim.git && cd vim

sudo CFLAGS=-fPIC ./configure --with-features=huge \
            --enable-multibyte \
            --enable-python3interp=yes \
            --enable-perlinterp \
            --enable-gui=auto \
            --enable-cscope \
            --prefix=/usr\
            --enable-fail-if-missing\
            --with-tlib=ncurses

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

# Install golang
mkdir -p ~/downloads
cd ~/downloads
v=1.15.2;wget https://golang.org/dl/go$v.linux-amd64.tar.gz && \
sudo rm -rf /usr/local/go && \
sudo tar -C /usr/local -xzf go$v.linux-amd64.tar.gz
echo 'PATH=$PATH:/usr/local/go/bin' | sudo tee -a /etc/profile
source /etc/profile
go version

# Set custom hostname
sudo hostnamectl set-hostname XXX
sudo sh -c 'echo "preserve_hostname: true" >> /etc/cloud/cloud.cfg'

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
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -s -c file:~/downloads/config.json
systemctl status amazon-cloudwatch-agent
