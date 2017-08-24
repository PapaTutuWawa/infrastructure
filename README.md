infrastructure
===
This is my docker compose file that sets up all the containers I need for my daily "work".

## Scripts
- ```link_interfaces.sh``` is for allowing traffic to go between my two docker networks
  - ```production-base```: For things my services require
  - ```production-services```: For the actual services
- ```deploy.sh``` is for stopping the old containers, building a new version and starting the new version

## Networks > production-base
The *production-base* network is for hosting all the basic functionality that the other services
require, e.g. a Key-Value storage and a DNS-Server.

The IP range of the network is ```240.1.0.0/16```.

The interface's name is ```prod-base```.

## Networks > production-services
THe *production-services* network hosts the actual services, e.g. Cups.

The IP range of the network is ```240.2.0.0/16```.

The interface's name is ```prod-srv```.

## Cups
Cups requires the folder ```/srv/internal/cupsd``` to exist. Cups will be attached to production-services.

Upon starting, Cups will pull the admin hash (The hashed password) from the etcd server (http://kv.docker.local:2379/v2/keys/cupsd_hash).

## Bind
Bind requires the file ```/srv/internal/bind/config``` and the folder ```/srv/internal/bind/zones``` to exist. The rootfs of the container
is read-only.

Bind will be attached to production-base.

The nameserver has the IP 240.1.0.2.

The domain that is should be used is ```docker.local```. The following subdomains should exist:
- ```cups.docker.local``` -> Cups
- ```kv.docker.local``` -> Etcd

## Etcd
Etcd requires the folder ```/srv/internal/etcd``` to exist.

Etcd will be attached to production-base.
