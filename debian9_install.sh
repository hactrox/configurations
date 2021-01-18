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
