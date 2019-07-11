#!/usr/bin/env bash


puma_service="
[Unit]
\nDescription=Puma Rails Server
\nAfter=network.target
\n
\n[Service]
\nType=simple
\nUser=appuser
\nWorkingDirectory=/home/appuser/reddit
\nExecStart=/bin/bash -lc 'puma'
\nTimeoutSec=300
\nRestart=always
\n
\n[Install]
\nWantedBy=multi-user.target"

echo -e $puma_service > puma 
sudo mv puma /etc/systemd/system/puma-server.service
systemctl enable puma-server
systemctl start puma-server

