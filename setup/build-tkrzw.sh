#!/bin/sh

#VERSION=0.0.0
#JAVA_VERSION=0.0.0

wget https://dbmx.net/tkrzw/pkg/tkrzw-$VERSION.tar.gz
tar zxvf tkrzw-$VERSION.tar.gz
cd tkrzw-$VERSION
./configure --prefix=/usr
make -j4
make install

wget https://dbmx.net/tkrzw/pkg-java/tkrzw-java-$JAVA_VERSION.tar.gz
tar zxvf tkrzw-java-$JAVA_VERSION.tar.gz
cd tkrzw-java-$JAVA_VERSION
./configure --prefix=/usr
make -j4
make install

mkdir -p /target/libs
cp /usr/lib/libtkrzw.so /target/libs/
cp /usr/lib/libjtkrzw.so /target/libs/
chown 777 /target/libs/*

ls -la /target/libs