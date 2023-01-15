#!/usr/bin/env sh

owd="`pwd`"
cd "$(dirname "$0")"

abuild_ver="16"
alpine_ver="3.17.1"

# Setting File permissions
xattr -c .git
xattr -c .gitignore
xattr -c .dockerignore
xattr -c *
chmod 0755 *.sh

docker login
docker build -f Dockerfile \
  -t technoboggle/alpine-abuild:"$alpine_ver-$abuild_ver" \
  --build-arg BUILD_DATE=$(date -u +'%Y-%m-%dT%H:%M:%SZ') \
  --build-arg VCS_REF="`git rev-parse --verify HEAD`" \
  --build-arg BUILD_VERSION=0.05 \
  --force-rm \
  --progress=plain \
  --no-cache .

docker tag technoboggle/alpine-abuild:"$alpine_ver-$abuild_ver" technoboggle/alpine-abuild:latest

docker push technoboggle/alpine-abuild:"$alpine_ver-$abuild_ver"
docker push technoboggle/alpine-abuild:latest

cd edge
docker build -f Dockerfile \
  -t technoboggle/alpine-abuild:edge \
  --build-arg BUILD_DATE=$(date -u +'%Y-%m-%dT%H:%M:%SZ') \
  --build-arg VCS_REF="`git rev-parse --verify HEAD`" \
  --build-arg BUILD_VERSION=0.05 \
  --force-rm \
  --no-cache \
  --progress=plain .

docker push technoboggle/alpine-abuild:edge

cd "$owd"
