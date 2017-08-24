#!/bin/sh

production_base_bridge="prod-base"
production_serv_bridge="prod-srv"

iptables -I FORWARD -i "$production_base_bridge" -o "$production_serv_bridge" -j ACCEPT
iptables -I FORWARD -i "$production_serv_bridge" -o "$production_base_bridge" -j ACCEPT
