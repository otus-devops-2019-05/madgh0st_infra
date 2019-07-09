#!/usr/bin/env bash

echo 'Connect to '$1' via 35.207.131.137'
ssh -A -J root@35.207.131.137 root@$1
