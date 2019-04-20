#!/bin/bash

## Settings
#Core count
if [ -n "$CORE_COUNT" ]; then
	corecount=$CORE_COUNT
else
	corecount=$(grep -c ^processor /proc/cpuinfo)
	((corecount-=1))
fi
echo "Core Count: $corecount"

## Script
echo "Building SkylarkOS Kernel..."
cd ubuntu-kernel

#Patching kernel
echo "Patching kernel"
echo " - Applying VFIO patches"
patch -p1 < ../patches/vfio/i915-vga-arbiter.patch
patch -p1 < ../patches/vfio/add-acs-overrides.patch

echo " - Applying version patch"
patch -p1 < ../patches/version.patch

#Building kernel
echo "Building kernel"
echo " - Cleaning"
fakeroot debian/rules clean

echo " - Building"
fakeroot debian/rules binary

# Build complete
echo "Build complete!"
