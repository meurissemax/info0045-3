##############################
# Rules for Firewall 3 (FW3) #
##############################

##### IP adresses

Z_U3=192.168.3.0/24
Z_NFS=10.10.2.0/24
Z_SSH_BOTTOM=10.10.1.0/24

U3=192.168.3.2

NFS=10.10.2.2

SSH=10.10.1.3
RSYNC=10.10.1.4

##### Firewall rules

# Default policy
iptables -P INPUT DROP
iptables -P OUTPUT DROP
iptables -P FORWARD DROP

# Stateful firewall
iptables -A FORWARD -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT

# Incoming traffic z-u3
iptables -A FORWARD -s $SSH -d $U3 -p tcp --dport 22 -j ACCEPT
iptables -A FORWARD -d $Z_U3 -j DROP

# Outgoing traffic z-u3
iptables -A FORWARD -s $U3 -d $NFS -p tcp --dport 111 -j ACCEPT
iptables -A FORWARD -s $U3 -d $NFS -p udp --dport 111 -j ACCEPT
iptables -A FORWARD -s $U3 -d $NFS -p tcp --dport 2046 -j ACCEPT
iptables -A FORWARD -s $U3 -d $NFS -p udp --dport 2046 -j ACCEPT
iptables -A FORWARD -s $U3 -d $NFS -p tcp --dport 2047 -j ACCEPT
iptables -A FORWARD -s $U3 -d $NFS -p udp --dport 2047 -j ACCEPT
iptables -A FORWARD -s $U3 -d $NFS -p tcp --dport 2048 -j ACCEPT
iptables -A FORWARD -s $U3 -d $NFS -p udp --dport 2048 -j ACCEPT
iptables -A FORWARD -s $U3 -d $NFS -p tcp --dport 2049 -j ACCEPT
iptables -A FORWARD -s $U3 -d $NFS -p udp --dport 2049 -j ACCEPT
iptables -A FORWARD -s $U3 -d $SSH -p tcp --dport 22 -j ACCEPT
iptables -A FORWARD -s $U3 -d $RSYNC -p tcp --dport 873 -j ACCEPT
iptables -A FORWARD -s $Z_U3 -j DROP

# Incoming traffic z-nfs
iptables -A FORWARD -d $Z_NFS -j DROP

# Outgoing traffic z-nfs
iptables -A FORWARD -s $Z_NFS -j DROP

# Incoming traffic z-ssh-bottom
iptables -A FORWARD -d $Z_SSH_BOTTOM -j DROP

# Outgoing traffic z-ssh-bottom
iptables -A FORWARD -s $Z_SSH_BOTTOM -j DROP

# Other
iptables -A FORWARD -j LOG
iptables -A FORWARD -j DROP
