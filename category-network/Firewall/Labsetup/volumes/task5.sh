mode=$1
[[ -z $mode ]] && mode='nth'
if [[ $mode == 'nth' ]]; then
   arg='--every 3 --packet 0'
else
   arg='--probability 0.33'
fi

iptables -t nat -A PREROUTING -p udp --dport 8080 \
-m statistic --mode $mode $arg \
-j DNAT --to-destination 192.168.60.5:8080

iptables -t nat -A PREROUTING -p udp --dport 8080 \
-m statistic --mode $mode $arg \
-j DNAT --to-destination 192.168.60.6:8080

iptables -t nat -A PREROUTING -p udp --dport 8080 \
-m statistic --mode $mode $arg  \
-j DNAT --to-destination 192.168.60.7:8080
