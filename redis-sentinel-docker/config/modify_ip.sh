function current_networkservice() {
    network=''
    if [ "$(networksetup -getnetworkserviceenabled CalDigit-TS3-Plus)" = 'Enabled' ]; then
       network='CalDigit-TS3-Plus'
    elif [ "$(networksetup -getnetworkserviceenabled Ethernet)" = 'Enabled' ]; then
       network='Ethernet'
    elif [ "$(networksetup -getnetworkserviceenabled Wi-Fi)" = 'Enabled' ]; then
       network='Wi-Fi'
    else
       network=''
    fi
    echo $network
}


# 获取当前 IP 
function ip() {
    network=`current_networkservice`
    networksetup -getinfo $network | grep '^IP address' | awk -F: '{print $2}' | sed 's/ //g'
}

newip=`ip`
echo $newip
gsed -i "s/cluster-announce-ip [0-9.]*/cluster-announce-ip ${newip}/g" *.conf
gsed -i "s/requirepass/#requirepass/g" *.conf
grep "cluster-announce-ip [0-9.]*" *.conf
grep "requirepass" *.conf
