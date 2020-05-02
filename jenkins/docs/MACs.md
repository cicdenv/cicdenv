## Overview
MacOS w/Docker for Mac requires several ugly workarounds to get 
websocket cli/agents and resource root url working locally.

There is NOT one address where a mac native web browser and
the agent (running in its on container) can reach the server.

The best workaround is to use your Macs host external IP address.
Web browsers will still make requests as 'localhost'.

## IP Address
```bash
make MAC_INTERFACE=<interface> ip-address
<prints ip address>
make IP_ADDRESS=<external-ip> tls

# Example
make MAC_INTERFACE=en9 ip-address
192.168.42.66
make IP_ADDRESS=192.168.42.66 tls
```
