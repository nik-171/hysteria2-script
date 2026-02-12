apt update -y
apt install -y ufw curl openssh-server


read -p "enter a new port for SSH: " NEW_PORT

if ! [[ "$NEW_PORT" =~ ^[0-9]+$ ]] || [ "$NEW_PORT" -lt 1 ] || [ "$NEW_PORT" -gt 65535 ]; then
    echo "invalid value"
    exit 1
fi

sed -i "s/^#Port .*/Port $NEW_PORT/" /etc/ssh/ssh_config
sed -i "s/^Port .*/Port $NEW_PORT/" /etc/ssh/ssh_config

echo "port changed: $NEW_PORT"

systemctl daemon-reload
systemctl restart ssh

ufw allow $NEW_PORT/tcp && ufw allow 443/tcp && ufw enable


sed -i '/# ok icmp codes for INPUT/,/^$/ s/ACCEPT/DROP/' /etc/ufw/before.rules
sed -i '/# ok icmp code for FORVARD/,/^$/ s/ACCEPT/DROP/' /etc/ufw/before.rules
sed -i '/# ok icmp codes for INPUT/a -A ufw-before-input -p icmp --icmp-type source-quench -j DROP' /etc/ufw/before.rules


ufw disable && ufw enable

bash <(curl -sL https://bit.ly/realityez) 
bash <(curl -sL https://bit.ly/realityez) --security selfsigned
bash <(curl -sL https://bit.ly/realityez) -t hysteria2
bash <(curl -sL https://bit.ly/realityez) --show-user RealityEZPZ
