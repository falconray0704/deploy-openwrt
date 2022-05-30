#!/bin/ash

SS_PORTS='8000 9000 9001 5222 5223 5228 8080 8801 8802 8410 14000 16285'
first_port=8000
last_port=16285

current_port=$(uci get shadowsocks-libev.@server[0].server_port)
isBingo=0

if [ -z ${current_port} ] || [ ${current_port} -le 0 ] || [ ${current_port} -ge 65535 ] || [ ${current_port} -eq ${last_port} ]
then
	next_port=${first_port}
	isBingo=1
else
	for port in ${SS_PORTS}
	do
		if [ ${isBingo} -eq 1 ]
		then
			next_port=${port}
			break
		elif [ ${current_port} -eq ${port} ]
		then
			isBingo=1
		fi
	done
fi


if [ ${isBingo} -eq 0 ]
then
	next_port=${first_port}
fi

echo "first: ${first_port}, last: ${last_port}, current: ${current_port}, next: ${next_port}"
uci set shadowsocks-libev.@server[0].server_port=${next_port}
uci commit



TBONE=""
while [ -z ${TBONE} ]
do
#echo "TBONE is empty, looping..."
TBONE="$(nslookup tbone.synology.me | grep 'Address 1:' | awk '{print substr($0, 12)}')"
sleep 1
done

set +e
uci get shadowsocks-libev.ss_rules.dst_ips_bypass
if [ $? -eq 0 ]
then
uci delete shadowsocks-libev.ss_rules.dst_ips_bypass
uci delete shadowsocks-libev.ss_rules.src_ips_bypass
uci commit
fi
set -e

uci add_list shadowsocks-libev.ss_rules.dst_ips_bypass=${TBONE}
uci add_list shadowsocks-libev.ss_rules.src_ips_bypass=${TBONE}
uci set shadowsocks-libev.ss_rules.dst_default='forward'
uci set shadowsocks-libev.ss_rules.src_default='checkdst'
uci commit
echo "TBONE:${TBONE}"
exit 0

