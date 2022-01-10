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

# Set up the TUN Interface
os.system("ip addr add 192.168.53.99/24 dev {}".format(ifname))
os.system("ip link set dev {} up".format(ifname))

def reroute(addr, devname):
    check_cmd = "ip route show {}".format(addr)
    exists = os.popen(check_cmd).read()
    if exists:
        del_cmd = "ip route del {}".format(addr)
        os.system(del_cmd)
    route_cmd = ("ip route add {} dev {}".format(addr, devname))
    os.system(route_cmd)

def run(server_ip, server_port):
    # Create UDP socket
    sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    while True:
        # this will block until at least one interface is ready
        ready, _, _ = select.select([sock, tun], [], [])
        # Get a packet from the tun interface
        for fd in ready:
            if fd is tun:
                packet = os.read(tun, 2048)
                # Send the packet via the tunnel
                pkt = IP(packet)
                print("From tun: Tunneling {}".format(pkt.summary()))
                sock.sendto(packet, (server_ip, server_port))

            if fd is sock:
                # _ip, _port == SERVER_IP, SERVER_PORT
                res, (_ip, _port) = sock.recvfrom(2048)
                # print(res)
                pkt = IP(res)
                print("From socket: Tunneling back {}".format(pkt.summary()))
                os.write(tun, bytes(pkt))


if __name__ == '__main__':
    # cannot find ways to route dynamically when receiving packets since they first come from tun
    # it should have been routed to tun in advance, otherwise client cannot even receive them
    reroute('192.168.60.0/24', ifname)
    run('10.9.0.11', 9090)
