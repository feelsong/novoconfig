blocksfound=0
./novobitcoin-cli getwalletinfo
while true; do
        balance1=$(./novobitcoin-cli getwalletinfo | jq .immature_balance)
        unbalance1=$(./novobitcoin-cli getwalletinfo | jq .unconfirmed_balance)
        wbalance1=$(./novobitcoin-cli getwalletinfo | jq .balance)
        sleep 5
        balance2=$(./novobitcoin-cli getwalletinfo | jq .immature_balance)
        unbalance2=$(./novobitcoin-cli getwalletinfo | jq .unconfirmed_balance)
        wbalance2=$(./novobitcoin-cli getwalletinfo | jq .balance)
        if [[ "$balance1" != "$balance2" ]]; then
                blocksfound=$((blocksfound+1))
                echo $'\n'"YOU FOUND A BLOCK!!! $blocksfound OF THEM SO FAR!!!"$'\n'
                echo "        immature balance is now: $balance2         "
        fi
        if [[ "$unbalance1" != "$unbalance2" ]]; then
                echo $'\n'"**********unconfirmed balance has changed!!!*******"$'\n'
                echo "       unconfirmed balance is now: $unbalance2     "
        fi
        if [[ "$wbalance1" != "$wbalance2" ]]; then
                echo $'\n'"*********wallet balance has changed!!!*************"$'\n'
                echo "         wallet balance is now: $wbalance2         "
        fi
done