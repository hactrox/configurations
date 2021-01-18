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
