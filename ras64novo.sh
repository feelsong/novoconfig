#!/bin/bash

#there is no source code for this script to work with
#untested 
#missing something, doesnt work
#consult ur lawyer

#need to fill these in
username=
rpcpassword=

echo "raspi 64 bit debian novobitcoin compile script"

#sourceDir=novobitcoin
#source=https://github.com/wszhang/"$sourceDir"
#git clone "$source"
#cd "$sourceDir"

sudo apt-get install \
	build-essential libtool autotools-dev automake pkg-config \
	bsdmainutils python3 libevent-dev libboost-system-dev libboost-filesystem-dev \
	libboost-chrono-dev libboost-program-options-dev libboost-test-dev \
	libboost-thread-dev libsqlite3-dev libqrencode-dev g++-arm-linux-gnueabihf \
	curl libdb-dev libdb++-dev libssl-dev

./autogen.sh

CONFIG_SITE=$PWD/depends/arm-linux-gnueabihf/share/config.site \
	./configure --without-gui --enable-reduce-exports LDFLAGS=-static-libstdc++

make 

echo "nwal(){ \$HOME/.novo-bitcoin/bin/novobitcoin-cli getwalletinfo; }" >> ~/.bash_aliases
echo "ninfo(){ \$HOME/.novo-bitcoin/bin/novobitcoin-cli getinfo; }" >> ~/.bash_aliases
echo "nhelp(){ \$HOME/.novo-bitcoin/bin/novobitcoin-cli help; }" >> ~/.bash_aliases
echo "nstart(){ \$HOME/.novo-bitcoin/bin/nbsv.sh; }" >> ~/.bash_aliases
echo "ncli(){ \$HOME/.novo-bitcoin/bin/novobitcoin-cli \$1 \$2 \$3 \$4 \$5 \$6 \$7 \$8 \$9; }" >> ~/.bash_aliases
#echo "update() { sudo apt update && sudo apt upgrade -y; }" >> ~/.bash_aliases
echo "source ~/.bash_aliases or restart to use aliases such as nstart nwal and ncli"

if [[ ! -d "$HOME/.novo-bitcoin" ]]; then
	mkdir "$HOME/.novo-bitcoin"
fi

novoConf="$HOME/.novo-bitcoin/novo.conf"
echo "port=8666"$'\n'"rpcport=8665"$'\n'"rpcuser=$username"$'\n'\
	"rpcpassword=$rpcpassword"$'\n'"gen=1" > "$novoConf"
