#!/bin/bash
sudo pacman -S libevent boost-libs sqlite qrencode \
	binutils arm-none-eabi-binutils arm-none-eabi-gcc boost \
	autoconf automake binutils bison fakeroot file \
	findutils flex gawk gcc gettext grep groff gzip libtool \
	m4 make patch pkgconf sed texinfo which miniupnpc
./autogen.sh
CONFIG_SITE=$PWD/depends/arm-linux-gnueabihf/share/config.site ./configure --without-gui --enable-reduce-exports LDFLAGS=-static-libstdc++
make 
