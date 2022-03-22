# novoconfig

in an isolated environment such as a machine just for this task or a virtual machine, and at your own risk running binaries without public source code-

and using a linux machine and bash with npm installed:



wget https://raw.githubusercontent.com/bitsko/novoconfig/main/novoconfig.sh && chmod +x novoconfig.sh

./novoconfig.sh

cd .novo-bitcoin

./nbsv.sh



if you dont need a key generated and dont have npm, 
delete the second line of novoconfig.sh "if [ ! $(command -v npm) ]; then echo "install nodejs"; exit 0; fi".
