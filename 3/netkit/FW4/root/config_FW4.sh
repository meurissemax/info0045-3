##############################
# Rules for Firewall 4 (FW4) #
##############################

##### IP adresses

Z_SSH_TOP=172.16.31.0/24
Z_U1=192.168.1.0/24
Z_MAIL_TOP=172.16.32.0/24
Z_PWEB=172.15.30.0/24

SSH=172.16.31.3
RSYNC=172.16.31.4

DHCP_R1=192.168.1.2

HTTP=172.16.32.2
DHCP=172.16.32.3
LDNS=172.16.32.4
MAIL=172.16.32.5

PWEB=172.15.30.2

##### Firewall rules

# Default policy
iptables -P INPUT DROP
iptables -P OUTPUT DROP
iptables -P FORWARD DROP

# Stateful firewall
iptables -A FORWARD -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT

# Incoming traffic z-ssh-top
iptables -A FORWARD -s $Z_U1 -d $RSYNC -p tcp --dport 873 -j ACCEPT
iptables -A FORWARD -s $Z_U1 -d $SSH -p tcp --dport 22 -j ACCEPT
iptables -A FORWARD -d $Z_SSH_TOP -j DROP

# Outgoing traffic z-ssh-top
iptables -A FORWARD -s $Z_SSH_TOP -j DROP

# Incoming traffic z-u1
iptables -A FORWARD -d $Z_U1 -j DROP

# Outgoing traffic z-u1
iptables -A FORWARD -s $Z_U1 -d $HTTP -p tcp --dport 3128 -j ACCEPT
iptables -A FORWARD -s $DHCP_R1 -d $DHCP -p udp --dport 67 -j ACCEPT
iptables -A FORWARD -s $Z_U1 -d $LDNS -p udp --dport 53 -j ACCEPT
iptables -A FORWARD -s $Z_U1 -d $LDNS -p tcp --dport 53 -j ACCEPT
iptables -A FORWARD -s $Z_U1 -d $MAIL -p tcp --dport 25 -j ACCEPT
iptables -A FORWARD -s $Z_U1 -d $MAIL -p tcp --dport 143 -j ACCEPT
iptables -A FORWARD -s $Z_U1 -d $MAIL -p tcp --dport 993 -j ACCEPT
iptables -A FORWARD -s $Z_U1 -d $PWEB -p tcp --dport 80 -j ACCEPT
iptables -A FORWARD -s $Z_U1 -d $PWEB -p tcp --dport 443 -j ACCEPT
iptables -A FORWARD -s $Z_U1 -j DROP

# Incoming traffic z-mail-top
iptables -A FORWARD -d $Z_MAIL_TOP -j DROP

# Outgoing traffic z-mail-top
iptables -A FORWARD -s $Z_MAIL_TOP -j DROP

# Incoming traffic z-pweb
iptables -A FORWARD -d $Z_PWEB -j DROP

# Outgoing traffic z-pweb
iptables -A FORWARD -s $Z_PWEB -j DROP

# Other
iptables -A FORWARD -j LOG
iptables -A FORWARD -j DROP
