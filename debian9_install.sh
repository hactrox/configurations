# Delete all rules in iptables
sudo iptables -F

# Update packages
sudo apt update && sudo apt -y upgrade

# Prepare downloads dir
mkdir -p ~/downloads
