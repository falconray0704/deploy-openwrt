#!/bin/ash

source ./.env_target

opkg install ${IPK_CA_CERTTIFICATES}

opkg install ${IPK_LIBPCRE}
opkg install ${IPK_LIBPCRE2}
opkg install ${IPK_ZLIB}
opkg install ${IPK_LIBOPENSSL}
opkg install ${IPK_WGET}

#opkg install ${IPK_LIBUSTREAM_OPENSSL}

sed -i "s/http:/https:/" /etc/opkg/distfeeds.conf

uci set dhcp.lan.ignore='1'
uci commit dhcp

uci set network.lan.ipaddr=${TARGET_INIT_CONFIG_IP}
uci set network.lan.dns=${TARGET_INIT_GATEWAY_IP}
uci set network.lan.gateway=${TARGET_INIT_GATEWAY_IP}
uci commit network

uci del dropbear.@dropbear[0]
uci changes dropbear
uci commit dropbear

passwd

echo ""
echo ""
echo ""
echo "YOU MUST REBOOT BEFORE CONTINUE FOLLOWING INSTALLATIONS!!!"
echo ""
echo ""
echo ""

#reboot


