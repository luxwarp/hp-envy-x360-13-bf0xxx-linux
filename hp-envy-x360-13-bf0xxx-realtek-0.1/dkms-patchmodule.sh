#!/bin/bash

# see https://www.collabora.com/news-and-blog/blog/2021/05/05/quick-hack-patching-kernel-module-using-dkms/


set -e

#kernelver=$(uname -r | cut -d '-' -f 1)
vers=(${kernelver//./ })   # split kernel version into individual elements
major="${vers[0]}"
minor="${vers[1]}"
version="$major.$minor"    # recombine as needed

subver=$(echo $kernelver | cut -d '.' -f 3 | cut -d '-' -f 1)


[ "${subver}" = '0' ] && unset subver
SOURCE_VERSION_STRING="${major}.${minor}$( [ -n "${subver}" ] && echo ".${subver}" )"

echo "Downloading kernel source $version.$subver for $kernelver"
wget https://mirrors.edge.kernel.org/pub/linux/kernel/v$major.x/linux-$SOURCE_VERSION_STRING.tar.xz

echo "Extracting original source of the kernel module"
tar -xf linux-$SOURCE_VERSION_STRING.tar.* linux-$SOURCE_VERSION_STRING/$1 --xform=s,linux-$SOURCE_VERSION_STRING/$1,.,

for i in `ls *.patch`
do
  echo "Applying $i"
  patch < $i
done
