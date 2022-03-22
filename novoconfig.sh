#!/usr/bin/env bash
echo "installing and configuring novobitcoin..."
echo "use at your own risk in an isolated environment"
echo "press Ctrl+C to abort"
sleep 5

if [ ! -d ~/.novo-bitcoin ]; then mkdir ~/.novo-bitcoin; fi
if [ ! -d ~/.novo-bitcoin/downloads ]; then mkdir ~/.novo-bitcoin/downloads; fi
read -r -p "enter a username for novobitcoind"$'\n>' username
read -r -p "enter a rpc password for novobitcoind"$'\n>' rpcpassword
if [ ! -f ~/.novo-bitcoin/novo.conf ]; then
        echo "port=8666"$'\n'"rpcport=8665"$'\n'"rpcuser=$username"$'\n'"rpcpassword=$rpcpassword" > ~/.novo-bitcoin/novo.conf
fi
if [ ! -f ~/.novo-bitcoin/downloads/novo-bitcoin-0.1.0-x86_64-linux-gnu.tar.gz ]; then
        wget https://github.com/novobitcoin/novobitcoin-release/releases/download/v0.1.0/novo-bitcoin-0.1.0-x86_64-linux-gnu.tar.gz\
                -P ~/.novo-bitcoin/downloads
fi
if [ ! -f ~/.novo-bitcoin/downloads/novominer-0.1.0-x86_64-linux-gnu.tar.gz ]; then
        wget https://github.com/novobitcoin/novobitcoin-release/releases/download/v0.1.0/novominer-0.1.0-x86_64-linux-gnu.tar.gz\
                -P ~/.novo-bitcoin/downloads
fi
tar -xzf ~/.novo-bitcoin/downloads/novo-bitcoin-0.1.0-x86_64-linux-gnu.tar.gz -C ~/.novo-bitcoin/downloads
tar -xzf ~/.novo-bitcoin/downloads/novominer-0.1.0-x86_64-linux-gnu.tar.gz -C ~/.novo-bitcoin/downloads
if [ ! -d  ~/.novo-bitcoin/bin ]; then mkdir ~/.novo-bitcoin/bin; fi
cp ~/.novo-bitcoin/downloads/novo-bitcoin-0.1.0/bin/* ~/.novo-bitcoin/bin/
cp ~/.novo-bitcoin/downloads/novominer/bin/* ~/.novo-bitcoin/bin/

read -p "press s to send the mined tokens to a supplied address, j to generate a keypair with bsv-js (not a novo-bitcoin generated address! works if code for addresses remains the same I guess), or N to leave blank and edit cfg.json later"$'\n>' sjn
case $sjn in
    [Ss]* ) read -r -p "what address to send the mined tokens to?" miningAddress
            ;;
    [Jj]* ) if [ ! $(command -v npm) ]; then
                echo "install nodejs"; exit 0
            fi
            if [ ! -d node_modules/bsv/ ]; then
                npm i --prefix "$(pwd)" bsv --save
            fi
            if [ "$(npm list bsv | awk NR==2 | tr -dc '0-9' | cut -c 1)" == "2" ];then
                vkey=PrivKey && pkey=PubKey
            fi
            if [ "$(npm list bsv | awk NR==2 | tr -dc '0-9' | cut -c 1)" == "1" ];then
                vkey=PrivateKey && pkey=PublicKey
            fi
                echo "var bsv = require('bsv'); var privateKey = bsv.$vkey.fromRandom(); var publicKey = bsv.$pkey.from$vkey(privateKey); console.log(bsv.Address.from$pkey(publicKey).toString(),privateKey.toString())" | node | tee -a ~/.novo-bitcoin/bin/miningAddress.txt
                miningAddress=$(awk 'END{ print $1 }'<~/.novo-bitcoin/bin/miningAddress.txt)
            ;;
    [Nn]* ) ;;
    * ) echo "Please give an address after selecting s, or generate an address using j, or configure later in ~/.novo-bitcoin/bin/cfg.json by choosing n";;
esac

read -r -p "how many CPU threads to mine with?"$'\n>' threads
if [ ! -f ~/.novo-bitcoin/bin/cfg.json ]; then
        echo "{"$'\n'"  \"url\" : \"http://127.0.0.1:8665\","$'\n'"  \"user\" : \"$username\","$'\n'\
                " \"pass\" : \"$rpcpassword\","$'\n'"  \"algo\" : \"sha256dt\","$'\n'\
                " \"threads\" : \"$threads\","$'\n'"  \"coinbase-addr\": \"$miningAddress\""$'\n'"}" \
                > ~/.novo-bitcoin/bin/cfg.json
fi
echo "#!/usr/bin/env bash"$'\n'"~/.novo-bitcoin/bin/novobitcoind --printtoconsole &"$'\n'"nbsvid=\"\$!\""$'\n'\
"~/.novo-bitcoin/bin/novominer -c ~/.novo-bitcoin/bin/cfg.json"$'\n'\
"kill \"\$nbsvid\""$'\n'"echo \"shutting down\"" > ~/.novo-bitcoin/nbsv.sh
chmod +x ~/.novo-bitcoin/nbsv.sh
echo "to run novobitcoin and miner at the same time, go to ~/.novo-bitcoin and run nbsv.sh -- ie ./nbsv.sh"
