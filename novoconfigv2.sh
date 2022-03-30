#!/usr/bin/env bash
# in testing
echo "downloading and configuring novobitcoin..."
echo "use at your own risk in an isolated environment"
echo "press Ctrl+C to abort"
sleep 5
IFS= read -r -p "enter a username for novobitcoind"$'\n>' username
IFS= read -r -p "enter a rpc password for novobitcoind"$'\n>' rpcpassword
IFS= read -r -p "how many CPU threads to mine with?"$'\n>' threads
#turn tx indexing on with index as pos. param. 1 or 2
index=0
if [[ "$1" == "index" ]] || [[ "$2" == "index" ]]; then index=1; fi
#version of binary
vrs="0.1.0"
novoDir="$HOME/.novo-bitcoin"
novoBin="$HOME/.novo-bitcoin/bin"
novoDL="$novoBin/dl"
runScript="$novoBin/nbsv.sh"
quietScript="$novoBin/nbsvq.sh"
minerConf="$novoBin/cfg.json"
novoConf="$HOME/.novo-bitcoin/novo.conf"
bsvAddy="miningAddress.txt"
minerDL="novominer-$vrs-x86_64-linux-gnu.tar.gz"
nodeDL="novo-bitcoin-$vrs-x86_64-linux-gnu.tar.gz"
gitUrl="https://github.com/novobitcoin/novobitcoin-release/releases/download"
if [[ ! -d "$novoDir" ]]; then mkdir -p "$novoDir"; fi
if [[ ! -d "$novoBin" ]]; then mkdir -p "$novoBin"; fi
if [[ ! -d "$novoDL" ]]; then mkdir -p "$novoDL"; fi
read -p "press s to give an address to mine to, j to generate a keypair with bsv-js (not a novo-bitcoin generated address! works if code for addresses remains the same I guess), or N to leave blank and edit $novoBin/cfg.json later"$'\n>' sjn
case $sjn in
    [Ss]* ) read -r -p "what address to send the mined tokens to?" whataddress
            miningAddress=$whataddress
            ;;
    [Jj]* ) if [ ! $(command -v npm) ]; then echo "install npm"; exit 0; fi
            if [ ! -d node_modules/bsv/ ]; then
                npm i --prefix "$(pwd)" bsv --save; fi
            if [ "$(npm list bsv | awk NR==2 | tr -dc '0-9' | cut -c 1)" == "2" ];then
                vkey=PrivKey && pkey=PubKey; fi
            if [ "$(npm list bsv | awk NR==2 | tr -dc '0-9' | cut -c 1)" == "1" ];then
                vkey=PrivateKey && pkey=PublicKey; fi
                node<<<"var bsv = require('bsv'); var privateKey = bsv.$vkey.fromRandom(); var publicKey = bsv.$pkey.from$vkey(privateKey); console.log(bsv.Address.from$pkey(publicKey).toString(),privateKey.toString())" | tee -a "$novoBin"/"$bsvAddy"
                miningAddress=$(awk 'END{ print $1 }'<"$novoBin"/"$bsvAddy")
            ;;
    [Nn]* ) miningAddress=Your_Address_Here;;
    * ) echo "Please give an address after selecting s, or generate an address using j, or configure later in ~/.novo-bitcoin/bin/cfg.json by choosing n";;
esac
if [ ! -f "$novoConf" ]; then
        echo "port=8666"$'\n'"rpcport=8665"$'\n'"rpcuser=$username"$'\n'"rpcpassword=$rpcpassword" > "$novoConf"
        if [[ "$index" == 1 ]]; then echo "txindex=1" >> "$novoConf"; fi; fi
if [ ! -f "$minerConf" ]; then
        echo "{"$'\n'"  \"url\" : \"http://127.0.0.1:8665\","$'\n'"  \"user\" : \"$username\","$'\n'\
                " \"pass\" : \"$rpcpassword\","$'\n'"  \"algo\" : \"sha256dt\","$'\n'\
                " \"threads\" : \"$threads\","$'\n'"  \"coinbase-addr\": \"$miningAddress\""$'\n'"}" \
                > "$minerConf"; fi
if [ ! -f "$runScript" ]; then
        echo "#!/usr/bin/env bash"$'\n'"$novoBin/novobitcoind --printtoconsole &"$'\n'"nbsvid=\"\$!\""$'\n'\
        "$novoBin/novominer -c $novoBin/cfg.json"$'\n'\
        "kill \"\$nbsvid\""$'\n'"echo \"shutting down\"" > "$runScript"
        chmod +x "$runScript"; fi
if [ ! -f "$quietScript" ]; then
        echo "#!/usr/bin/env bash"$'\n'"$novoBin/novobitcoind &"$'\n'"nbsvid=\"\$!\""$'\n'\
        "$novoBin/novominer -c $novoBin/cfg.json"$'\n'"nminrid=\"\$!\""$'\n' > "$quietScript"
        chmod +x "$quietScript"; fi
if [ ! -f "$novoDL"/"$nodeDL" ]; then wget "$gitUrl"/v"$vrs"/"$nodeDL" -P "$novoDL"; fi
if [ ! -f "$novoDL"/"$minerDL" ]; then wget "$gitUrl"/v"$vrs"/"$minerDL" -P "$novoDL"; fi
tar -xzf "$novoDL"/"$nodeDL" -C "$novoDL"
tar -xzf "$novoDL"/"$minerDL" -C "$novoDL"
cp "$novoDL"/novo-bitcoin-"$vrs"/bin/* "$novoBin"/
cp "$novoDL"/novominer/bin/* "$novoBin"/
rm -r "$novoDL"
echo "to run novobitcoin and miner at the same time"
echo "use $runScript"
echo "or $quietScript"
