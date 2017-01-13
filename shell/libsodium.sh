#!/bin/bash

cur_dir=$( pwd )
cd ${cur_dir}

if [ ! -d libsodium.zip ]; then
    wget https://github.com/jedisct1/libsodium/releases/download/1.0.11/libsodium-1.0.11.tar.gz -O ${cur_dir}/libsodium.tar.gz || exit 1
fi

tar zxf ${cur_dir}/libsodium.tar.gz
cd ${cur_dir}/libsodium-1.0.11
./configure && make && make install || exit 1

if [ $? -ne 0 ]; then
    echo "libsodium install failed."
    exit 1
fi

echo "/usr/local/lib" > /etc/ld.so.conf.d/local.conf

ldconfig
cd ${cur_dir}
rm -rf ${cur_dir}/libsodium-1.0.11  ${cur_dir}/libsodium.tar.gz