# See here for image contents: https://github.com/microsoft/vscode-dev-containers/tree/v0.236.0/containers/ubuntu/.devcontainer/base.Dockerfile

# [Choice] Ubuntu version (use ubuntu-22.04 or ubuntu-18.04 on local arm64/Apple Silicon): ubuntu-22.04, ubuntu-20.04, ubuntu-18.04
ARG VARIANT="jammy"
FROM mcr.microsoft.com/vscode/devcontainers/base:0-${VARIANT}

# [Optional] Uncomment this section to install additional OS packages.
# RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
#     && apt-get -y install --no-install-recommends <your-package-list-here>

USER root

RUN RELEASE=$(curl https://api.github.com/repos/k3d-io/k3d/releases/latest | jq -r .tag_name) \
  && curl -L "https://github.com/k3d-io/k3d/releases/download/${RELEASE}/k3d-linux-amd64" -o /usr/local/bin/k3d \
  && chmod +x /usr/local/bin/k3d

RUN RELEASE=$(curl https://api.github.com/repos/vmware-tanzu/octant/releases/latest | jq -r .tag_name[1:]) \
  && curl -LO "https://github.com/vmware-tanzu/octant/releases/download/v${RELEASE}/octant_${RELEASE}_Linux-64bit.tar.gz" \
  && tar xvf "octant_${RELEASE}_Linux-64bit.tar.gz" \
  && mv "./octant_${RELEASE}_Linux-64bit/octant" /usr/local/bin/octant

RUN curl --proto '=https' --tlsv1.2 -sSfL https://run.linkerd.io/install | sh

USER vscode

