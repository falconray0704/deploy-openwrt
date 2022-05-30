#!/bin/bash

set -e

source ./.env_target

wget -c https://downloads.openwrt.org/releases/${OPENWRT_RELEASE_VERSION}/targets/bcm27xx/bcm2710/openwrt-${OPENWRT_RELEASE_VERSION}-bcm27xx-bcm2710-rpi-3-ext4-factory.img.gz


mkdir -p download_${OPENWRT_RELEASE_VERSION}

pushd download_${OPENWRT_RELEASE_VERSION}

wget -c https://downloads.openwrt.org/releases/${OPENWRT_RELEASE_VERSION}/packages/aarch64_cortex-a53/base/${IPK_CA_CERTTIFICATES}
#wget -c https://downloads.openwrt.org/releases/${OPENWRT_RELEASE_VERSION}/packages/aarch64_cortex-a53/base/${IPK_LIBUSTREAM_OPENSSL}

wget -c https://downloads.openwrt.org/releases/${OPENWRT_RELEASE_VERSION}/packages/aarch64_cortex-a53/base/${IPK_ZLIB}
wget -c https://downloads.openwrt.org/releases/${OPENWRT_RELEASE_VERSION}/packages/aarch64_cortex-a53/base/${IPK_LIBOPENSSL}
wget -c https://downloads.openwrt.org/releases/${OPENWRT_RELEASE_VERSION}/packages/aarch64_cortex-a53/base/${IPK_LIBPCRE}

wget -c https://downloads.openwrt.org/releases/${OPENWRT_RELEASE_VERSION}/packages/aarch64_cortex-a53/packages/${IPK_LIBPCRE2}
wget -c https://downloads.openwrt.org/releases/${OPENWRT_RELEASE_VERSION}/packages/aarch64_cortex-a53/packages/${IPK_WGET}

popd

gzip -dk openwrt-${OPENWRT_RELEASE_VERSION}-bcm27xx-bcm2710-rpi-3-ext4-factory.img.gz

rm -rf piInit_${OPENWRT_RELEASE_VERSION}
cp -a download_${OPENWRT_RELEASE_VERSION} piInit_${OPENWRT_RELEASE_VERSION}

#cp ./target_00_device_init.sh piInit_${OPENWRT_RELEASE_VERSION}/
#cp ./target_01_enable_ssl_for_opkg.sh ${OPENWRT_RELEASE_VERSION}/

cp ./target_*.sh piInit_${OPENWRT_RELEASE_VERSION}/
cp ./.env_target piInit_${OPENWRT_RELEASE_VERSION}/
cp ./sys_start_ss.sh piInit_${OPENWRT_RELEASE_VERSION}/
cp ./shadowsocks-libev piInit_${OPENWRT_RELEASE_VERSION}/
cp ./firewall_dnscrypt_proxy piInit_${OPENWRT_RELEASE_VERSION}/


