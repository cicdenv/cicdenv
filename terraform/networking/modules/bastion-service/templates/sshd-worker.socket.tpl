[Unit]
Description=SSH Socket for Per-Connection docker ssh container

[Socket]
ListenStream=${ssh_port}
Accept=true

[Install]
WantedBy=sockets.target
