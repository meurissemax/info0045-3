##############################
# Rules for Firewall 2 (FW2) #
##############################

##### IP adresses

Z_LWEB=10.10.4.0/24
Z_U2=192.168.2.0/24
Z_MAIL_BOTTOM=10.10.3.0/24

LWEB=10.10.4.2

DHCP_R2=192.168.2.2

HTTP=10.10.3.2
DHCP=10.10.3.3
LDNS=10.10.3.4
MAIL=10.10.3.5

##### Firewall rules

# Default policy
iptables -P INPUT DROP
iptables -P OUTPUT DROP
iptables -P FORWARD DROP

# Stateful firewall
iptables -A FORWARD -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT

# Incoming traffic z-lweb
iptables -A FORWARD -s $HTTP -d $LWEB -p tcp --dport 80 -j ACCEPT
iptables -A FORWARD -s $Z_U2 -d $LWEB -p tcp --dport 80 -j ACCEPT
iptables -A FORWARD -s $Z_U2 -d $LWEB -p tcp --dport 21 -j ACCEPT
iptables -A FORWARD -d $Z_LWEB -j DROP

# Outgoing traffic z-lweb
iptables -A FORWARD -s $Z_LWEB -j DROP

# Incoming traffic z-u2
iptables -A FORWARD -d $Z_U2 -j DROP

# Outgoing traffic z-u2
iptables -A FORWARD -s $Z_U2 -d $HTTP -p tcp --dport 3128 -j ACCEPT
iptables -A FORWARD -s $DHCP_R2 -d $DHCP -p udp --dport 67 -j ACCEPT
iptables -A FORWARD -s $Z_U2 -d $LDNS -p udp --dport 53 -j ACCEPT
iptables -A FORWARD -s $Z_U2 -d $LDNS -p tcp --dport 53 -j ACCEPT
iptables -A FORWARD -s $Z_U2 -d $MAIL -p tcp --dport 25 -j ACCEPT
iptables -A FORWARD -s $Z_U2 -d $MAIL -p tcp --dport 143 -j ACCEPT
iptables -A FORWARD -s $Z_U2 -d $MAIL -p tcp --dport 993 -j ACCEPT
iptables -A FORWARD -s $Z_U2 -j DROP

# Incoming traffic z-mail-bottom
iptables -A FORWARD -d $Z_MAIL_BOTTOM -j DROP

# Outgoing traffic z-mail-bottom
iptables -A FORWARD -s $Z_MAIL_BOTTOM -j DROP

# Other
iptables -A FORWARD -j LOG
iptables -A FORWARD -j DROP
