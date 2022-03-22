# novoconfig

using a linux machine and bash with npm installed:

./nbsv.sh
cd .novo-bitcoin
./novoconfig.sh
wget https://raw.githubusercontent.com/bitsko/novoconfig/main/novoconfig.sh && chmod +x novoconfig.sh


if you dont need a key generated and dont have npm, 
delete the second line of novoconfig.sh "if [ ! $(command -v npm) ]; then echo "install nodejs"; exit 0; fi".
