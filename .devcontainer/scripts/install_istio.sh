#!/bin/sh

set -eu

curl -L https://istio.io/downloadIstio | sh -

export PATH="$PATH:/workspaces/k3d/istio-1.14.1/bin"