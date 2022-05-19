#!/bin/ash

# refer to: https://openwrt.org/docs/guide-user/services/dns/dnscrypt_dnsmasq_dnscrypt-proxy2

source ./.env_target

# Install packages
opkg update
opkg install dnscrypt-proxy2

# Enable DNS encryption
/etc/init.d/dnsmasq stop
uci set dhcp.@dnsmasq[0].noresolv="1"
uci set dhcp.@dnsmasq[0].localuse="1"
uci -q delete dhcp.@dnsmasq[0].server
uci add_list dhcp.@dnsmasq[0].server="127.0.0.53"
sed -i "32 s/.*/server_names = ['google', 'cloudflare']/" /etc/dnscrypt-proxy2/*.toml
uci commit dhcp
/etc/init.d/dnsmasq start
/etc/init.d/dnscrypt-proxy restart

# Prevent DNS leaks outside of dnscrypt-proxy and disable dnsmasq cache
uci set dhcp.dnsmasq.noresolv='1'
uci set dhcp.dnsmasq.localuse='1'
uci set dhcp.dnsmasq.boguspriv='0'
uci set dhcp.dnsmasq.cachesize='0'

uci commit dhcp

/etc/init.d/dnsmasq restart
logread -l 100 | grep dnsmasq

# Completely disable ISP's DNS servers
uci set network.${USB_INTERFACE_WAN_NAME}.peerdns='0'
#uci set network.interface.wan6.peerdns='0'
uci changes network
uci commit network

# Force LAN clients to send DNS queries to dnscrypt-proxy
cat ./firewall_dnscrypt_proxy >> /etc/config/firewall
uci changes firewall
uci commit firewall

# Test
nslookup openwrt.org localhost

# Check that you are not using your ISP resolver any more:
dnscrypt-proxy -config /etc/dnscrypt-proxy2/dnscrypt-proxy.toml -resolve google.com

# Check that processes on the router use dnsmasq:
cat /etc/resolv.conf


echo ""
echo ""
echo ""
echo "YOU MUST REBOOT BEFORE CONTINUE FOLLOWING INSTALLATIONS!!!"
echo ""
echo ""
echo ""

#reboot

