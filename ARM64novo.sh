#!/bin/bash


#there is no source code for this script to work with
#untested 
#missing something, doesnt work, mining also not working
#consult ur lawyer

#need to fill these in
username=
rpcpassword=
threads=
miningAddress=

echo "raspi 64 bit debian ubuntu manjaro novobitcoin compile script"

novoDir="$HOME/.novo-bitcoin"
novoBin="$HOME/.novo-bitcoin/bin"
minerConf="$novoBin/cfg.json"
novoConf="$HOME/.novo-bitcoin/novo.conf"

#sourceDir=novobitcoin
#source=https://github.com/wszhang/"$sourceDir"
#git clone "$source"
#cd "$sourceDir"

os_release_ID=$(source /etc/os-release; echo $ID)

if [[ "$os_release_ID" == "debian" ]] || [[ "$os_release_ID" == "ubuntu" ]]; then
sudo apt update
sudo apt upgrade -y
sudo apt-get install \
	build-essential libtool autotools-dev automake pkg-config \
	bsdmainutils python3 libevent-dev libboost-system-dev libboost-filesystem-dev \
	libboost-chrono-dev libboost-program-options-dev libboost-test-dev \
	libboost-thread-dev libsqlite3-dev libqrencode-dev g++-arm-linux-gnueabihf \
	curl libdb-dev libdb++-dev libssl-dev miniupnpc screen

elif [[ "$os_release_ID" == "manjaro-arm" ]]; then
sudo pacman -Syu
sudo pacman -S libevent boost-libs sqlite qrencode \
	binutils arm-none-eabi-binutils arm-none-eabi-gcc boost \
	autoconf automake binutils bison fakeroot file \
	findutils flex gawk gcc gettext grep groff gzip libtool \
	m4 make patch pkgconf sed texinfo which miniupnpc screen
fi

./autogen.sh

CONFIG_SITE=$PWD/depends/arm-linux-gnueabihf/share/config.site \
	./configure --without-gui --enable-reduce-exports LDFLAGS=-static-libstdc++

if [[ "$os_release_ID" == "debian" ]] || [[ "$os_release_ID" == "ubuntu" ]]; then
	make 
	echo "update() { sudo apt update && sudo apt upgrade -y; }" >> ~/.bashrc
elif [[ "$os_release_ID" == "manjaro" ]]; then
	make -j 3
	echo "update() { sudo pacman -Syu ; }" >> ~/.bashrc
fi

echo "nwal(){ \$HOME/.novo-bitcoin/bin/novobitcoin-cli getwalletinfo; }" >> ~/.bashrc
echo "ninfo(){ \$HOME/.novo-bitcoin/bin/novobitcoin-cli getinfo; }" >> ~/.bashrc
echo "nhelp(){ \$HOME/.novo-bitcoin/bin/novobitcoin-cli help; }" >> ~/.bashrc
#echo "nstart(){ \$HOME/.novo-bitcoin/bin/nbsv.sh ; }" >> ~/.bashrc
echo "ncli(){ \$HOME/.novo-bitcoin/bin/novobitcoin-cli \$1 \$2 \$3 \$4 \$5 \$6 \$7 \$8 \$9; }" >> ~/.bashrc
echo "source ~/.bashrc or restart to use aliases such as nwal and ncli"

if [[ ! -d "$HOME/.novo-bitcoin" ]]; then
	mkdir "$HOME/.novo-bitcoin"
fi
if [[ ! -d "$HOME/.novo-bitcoin/bin" ]]; then 
	mkdir "$HOME/.novo-bitcoin/bin"
	cp novobitcoind "$novoBin"/novobitcoind
	cp novobitcoin-cli "$novoBin"/novobitcoin-cli
	strip "$novoBin"/novobitcoind
	strip "$novoBin"/novobitcoin-cli
fi	

echo "port=8666"$'\n'"rpcport=8665"$'\n'"rpcuser=$username"$'\n'\
	"rpcpassword=$rpcpassword"$'\n'"gen=1" > "$novoConf"

echo "{"$'\n'"  \"url\" : \"http://127.0.0.1:8665\","$'\n'"  \"user\" : \"$username\","$'\n'\
                " \"pass\" : \"$rpcpassword\","$'\n'"  \"algo\" : \"sha256dt\","$'\n'\
                " \"threads\" : \"$threads\","$'\n'"  \"coinbase-addr\": \"$miningAddress\""$'\n'"}" \
                > "$minerConf"
