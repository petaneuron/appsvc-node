#!/bin/sh

# Enter the source directory to make sure the script runs where the user expects
cd "/home/site/wwwroot"

export NODE_PATH=$(npm root --quiet -g):$NODE_PATH
if [ -z "$PORT" ]; then
                export PORT=8080
fi

pm2 start --no-daemon /opt/startup/default-static-site.js
