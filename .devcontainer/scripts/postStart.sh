#!/bin/bash

# Condifure and start octant
mkdir ./.devcontainer/logs/ -p
nohup bash -c 'octant --disable-origin-check --disable-open-browser &' > ./.devcontainer/logs/octant.log

# Configure path for linkerd
# echo 'export PATH=$PATH:/home/vscode/.linkerd2/bin' >> ~/.bashrc
