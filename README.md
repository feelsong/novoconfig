see https://github.com/novobitcoin/novobitcoin-release

requires libcurl4, libjansson4 for ubuntu miner

# novoconfig

in an isolated environment such as a machine just for this task or a virtual machine, and at your own risk running binaries without public source code-

and using a linux machine and bash with npm installed:

-----

wget https://raw.githubusercontent.com/bitsko/novoconfig/main/novoconfig.sh && chmod +x novoconfig.sh

./novoconfig.sh

cd ~/.novo-bitcoin

./nbsv.sh

-----or


wget https://raw.githubusercontent.com/bitsko/novoconfig/main/novoconfigv2.sh && chmod +x novoconfigv2.sh

./novoconfigv2.sh

cd ~/.novo-bitcoin

./nbsv.sh

-----




addresses generated with bsvjs can be imported into the novobitcoin wallet by running
./novobitcoin-cli importprivkey your_private_key_here
and the private key generated can be found in the ~/.novo-bitcoin/bin folder.
