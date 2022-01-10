#!/usr/bin/env python3
import fcntl
import struct
import os
from scapy.all import *


TUNSETIFF = 0x400454ca
IFF_TUN   = 0x0001
IFF_TAP   = 0x0002
IFF_NO_PI = 0x1000

# Create the tun interface
tun = os.open("/dev/net/tun", os.O_RDWR)
ifr = struct.pack('16sH', b'tun%d', IFF_TUN | IFF_NO_PI)
ifname_bytes  = fcntl.ioctl(tun, TUNSETIFF, ifr)

# Get the interface name
ifname = ifname_bytes.decode('UTF-8')[:16].strip("\x00")
print("Interface Name: {}".format(ifname))

os.system("ip addr add 192.168.53.199/24 dev {}".format(ifname))
os.system("ip link set dev {} up".format(ifname))

def reroute(addr, devname):
    check_cmd = "ip route show {}".format(addr)
    exists = os.popen(check_cmd).read()
    if exists:
        del_cmd = "ip route del {}".format(addr)
        os.system(del_cmd)
    route_cmd = ("ip route add {} dev {}".format(addr, devname))
    os.system(route_cmd)

def serve(ip, port):
    sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    sock.bind((IP_A, PORT))

    while True:
        # this will block until at least one interface is ready
        ready, _, _ = select.select([sock, tun], [], [])
        for fd in ready:
            # packet from client
            if fd is sock:
                data, (ip, port) = sock.recvfrom(2048)
                pkt = IP(data) 
                # print(" From socket: {} --> {}".format(pkt.src, pkt.dst))
                print("From socket({}:{}): Tunneling {}".format(ip, port, pkt.summary()))
                # Tunnel back should route to pkt.src correctly
                reroute(pkt.src, ifname)
                os.write(tun, bytes(pkt))
            
            if fd is tun:
                packet = os.read(tun, 2048)
                pkt = IP(packet)
                # print(" From tun: {} --> {}".format(pkt.src, pkt.dst))
                print("From tun: Tunneling back {}".format(pkt.summary()))
                try:
                    sock.sendto(bytes(pkt), (ip, port))
                except OSError as e:
                    print(e, ip, port)


if __name__ == '__main__':
    IP_A = "0.0.0.0"
    PORT = 9090
    serve(IP_A, PORT)

