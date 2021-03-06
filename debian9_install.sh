# Delete all rules in iptables
sudo iptables -F

# Update packages
sudo apt update && sudo apt -y upgrade

# Prepare downloads dir
mkdir -p ~/downloads

# Install git
mkdir -p ~/downloads
cd ~/downloads
sudo apt update
sudo apt -y install make libssl-dev libghc-zlib-dev libcurl4-gnutls-dev libexpat1-dev gettext unzip autoconf
v=2.29.2;wget https://www.kernel.org/pub/software/scm/git/git-$v.tar.gz -O git-$v.tar.gz && tar -zxf git-$v.tar.gz && cd git-$v; unset v
make configure && ./configure --prefix=/usr && make && sudo make install
git --version

# Install golang
mkdir -p ~/downloads
cd ~/downloads
v=1.15.6;wget https://golang.org/dl/go$v.linux-amd64.tar.gz && \
sudo rm -rf /usr/local/go && \
sudo tar -C /usr/local -xzf go$v.linux-amd64.tar.gz
echo 'PATH=$PATH:/usr/local/go/bin' | sudo tee -a /etc/profile
source /etc/profile
go version

# Install latest vim
sudo apt -y install libncurses5-dev libgnome2-dev libgnomeui-dev \
libgtk2.0-dev libatk1.0-dev libbonoboui2-dev \
libcairo2-dev libx11-dev libxpm-dev libxt-dev python-dev \
python3-dev ruby-dev lua5.1 liblua5.1-dev libperl-dev
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
vim --version |grep "VIM - Vi"

# Install screen
sudo apt -y install screen
screen -v

# Install tmux
sudo apt install -y gcc make pkg-config automake autoconf libevent-dev bison
mkdir -p ~/downloads
cd ~/downloads
git clone https://github.com/tmux/tmux.git
cd tmux
sh autogen.sh
./configure && make && sudo make install
tmux -V

# Install docker 
sudo apt-get -y remove docker docker-engine docker.io containerd runc
sudo apt-get -y update
sudo apt-get -y install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/debian \
   $(lsb_release -cs) \
   stable"
sudo apt-get -y update
sudo apt-get -y install docker-ce docker-ce-cli containerd.io

# Install AWS SSM
# https://docs.aws.amazon.com/zh_cn/systems-manager/latest/userguide/sysman-manual-agent-install.html#agent-install-centos
mkdir /tmp/ssm
cd /tmp/ssm
wget https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/debian_amd64/amazon-ssm-agent.deb
sudo dpkg -i amazon-ssm-agent.deb
sudo systemctl enable amazon-ssm-agent
sudo systemctl start amazon-ssm-agent
sudo systemctl status amazon-ssm-agent

# Install AWS CloudWatch
cd ~/downloads
wget https://s3.amazonaws.com/amazoncloudwatch-agent/debian/amd64/latest/amazon-cloudwatch-agent.deb
sudo dpkg -i -E ./amazon-cloudwatch-agent.deb
# Copy cloud watch configuration from aws console to ~/downloads/config.json
sudo apt -y install collectd
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -s -c file:config.json
systemctl status amazon-cloudwatch-agent

# Set custom hostname
newhostname=XXX
sudo hostnamectl set-hostname $newhostname
sudo sed -i 's/preserve_hostname: false/preserve_hostname: true' /etc/cloud/cloud.cfg
sudo sed -i 's/manage_etc_hosts: true/manage_etc_hosts: false/' /etc/cloud/cloud.cfg.d/01_debian_cloud.cfg
sudo sed -i "s/127.0.0.1 localhost/127.0.0.1 localhost $newhostname/" /etc/hosts
unset newhostname
