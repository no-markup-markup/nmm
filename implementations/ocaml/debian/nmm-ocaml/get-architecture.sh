architecture=$(arch)
case "$architecture" in
  'x86_64' ) echo 'amd64';;
  'aarch64' ) echo 'arm64';;
  * ) echo "$architecture";;
esac
