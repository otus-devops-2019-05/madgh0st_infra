#!/usr/bin/env bash

echo "Settings for GIT"
git config --global user.name "madgh0st"
git config --global user.email anatoly.bryksin@gmail.com


echo " Fetching Ruby APP"

cd ~
git clone -b monolith https://github.com/express42/reddit.git

echo "Install Ruby Depends"
cd reddit && bundle install

echo "Puma Starting"

puma -d

