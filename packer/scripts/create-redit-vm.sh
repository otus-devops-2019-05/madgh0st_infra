#!/usr/bin/env bash

gcloud compute instances create reddit-app \
    --boot-disk-size=10GB \
    --machine-type=g1-small \
    --tags puma-server \
    --image-family=reddit-base \
    --restart-on-failure


