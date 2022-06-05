#!/bin/sh

set -eu

LINKERD_BUOYANT_VERSION=${LINKERD_BUOYANT_VERSION:-v0.9.3}
INSTALLROOT=${INSTALLROOT:-"${HOME}/.linkerd2"}

happyexit() {
  echo ""
  echo "Add the linkerd-buoyant CLI to your path with:"
  echo ""
  echo "  export PATH=\$PATH:${INSTALLROOT}/bin"
  echo ""
  echo "Now run:"
  echo ""
  echo "  linkerd buoyant install | kubectl apply -f -  # install the linkerd-buoyant extension"
  echo "  linkerd buoyant check                         # validate everything worked!"
  echo ""
  echo "Visit https://buoyant.cloud to view cluster data."
  echo ""
  exit 0
}

OS=$(uname -s)
arch=$(uname -m)
cli_arch=""
case $OS in
  CYGWIN* | MINGW64*)
    OS=windows.exe
    ;;
  Darwin)
    case $arch in
      x86_64)
        cli_arch=amd64
        ;;
      arm64)
        cli_arch=arm64
        ;;
      *)
        echo "There is no linkerd-buoyant $OS support for $arch. Please open an issue with your platform details."
        exit 1
        ;;
    esac
    ;;
  Linux)
    case $arch in
      x86_64)
        cli_arch=amd64
        ;;
      armv8*)
        cli_arch=arm64
        ;;
      aarch64*)
        cli_arch=arm64
        ;;
      armv*)
        cli_arch=arm
        ;;
      amd64|arm64)
        cli_arch=$arch
        ;;
      *)
        echo "There is no linkerd-buoyant $OS support for $arch. Please open an issue with your platform details."
        exit 1
        ;;
    esac
    ;;
  *)
    echo "There is no linkerd-buoyant support for $OS/$arch. Please open an issue with your platform details."
    exit 1
    ;;
esac
OS=$(echo $OS | tr '[:upper:]' '[:lower:]')

tmpdir=$(mktemp -d /tmp/linkerd-buoyant.XXXXXX)
srcfile="linkerd-buoyant-${LINKERD_BUOYANT_VERSION}-${OS}"
if [ -n "${cli_arch}" ]; then
  srcfile="${srcfile}-${cli_arch}"
fi
dstfile="${INSTALLROOT}/bin/linkerd-buoyant-${LINKERD_BUOYANT_VERSION}"
url="https://github.com/buoyantio/linkerd-buoyant/releases/download/${LINKERD_BUOYANT_VERSION}/${srcfile}"

(
  cd "$tmpdir"

  echo "Downloading ${srcfile}..."
  curl -fLO "${url}"
  echo "Download complete!"
  echo ""
)

(
  mkdir -p "${INSTALLROOT}/bin"
  mv "${tmpdir}/${srcfile}" "${dstfile}"
  chmod +x "${dstfile}"
  rm -f "${INSTALLROOT}/bin/linkerd-buoyant"
  ln -s "${dstfile}" "${INSTALLROOT}/bin/linkerd-buoyant"
)

rm -r "$tmpdir"

echo "Linkerd Buoyant extension ${LINKERD_BUOYANT_VERSION} was successfully installed 🎉"
echo ""
happyexit
