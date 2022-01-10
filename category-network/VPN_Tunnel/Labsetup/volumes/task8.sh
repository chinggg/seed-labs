#!/bin/sh

# No need to execute if using server3

# Let server route packets back
ip route add 192.168.50.0/24 dev tun0
