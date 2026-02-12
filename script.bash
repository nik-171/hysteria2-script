apt update -y
apt install -y ufw curl


read -p "enter a new port for SSH: " NEW_PORT

if ! [[ "$NEW_PORT" =~ ^[0-9]+$ ]] || [ "$NEW_PORT" -lt 1 ] || [ "$NEW_PORT" -gt 65535 ]; then
    echo "invalid value"
    exit 1
fi

sed -i "s/^#Port .*/Port $NEW_PORT/" /etc/ssh/sshd_config
sed -i "s/^Port .*/Port $NEW_PORT/" /etc/ssh/sshd_config
systemctl restart sshd

echo "port changed: $NEW_PORT"

systemctl daemon-reload
systemctl restart sshd

ufw allow $NEW_PORT/tcp && ufw allow 443/tcp && ufw enable


sed -i '/# ok icmp codes for input/,/^$/ s/ACCEPT/DROP/' /etc/ufw/before.rules
sed -i '/# ok icmp codes for forward/,/^$/ s/ACCEPT/DROP/' /etc/ufw/before.rules
sed -i '/# ok icmp codes for input/a -A ufw-before-input -p icmp --icmp-type source-quench -j DROP' /etc/ufw/before.rules


ufw disable && ufw enable

bash <(curl -sL https://bit.ly/realityez) 
bash <(curl -sL https://bit.ly/realityez) --security selfsigned
bash <(curl -sL https://bit.ly/realityez) -t hysteria2
bash <(curl -sL https://bit.ly/realityez) --show-user RealityEZPZ
