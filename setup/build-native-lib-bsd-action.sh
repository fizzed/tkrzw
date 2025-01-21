#!/bin/sh
set -e

BASEDIR=$(dirname "$0")
cd "$BASEDIR/.."
PROJECT_DIR=$PWD

BUILDOS=$1
BUILDARCH=$2
BUILDTARGET=$3

mkdir -p target
rsync -avrt --delete ./native/ ./target/

export CFLAGS="$CFLAGS -Wa,--noexecstack"
export CXXFLAGS="$CXXFLAGS -Wa,--noexecstack"
export JAVA_TOOL_OPTIONS="-Dfile.encoding=UTF-8"

# tkrzw dependency
cd ./target/tkrzw
./configure --host $BUILDTARGET --enable-zlib
make -j4 libtkrzw.a libtkrzw.so

# force static lib to be included in libjtkrzw
rm -f ./*.so

# these flags will only help the ./configure succeed for tokyocabinet-java
export TZDIR="$PWD"
export CPATH="$CPATH:$TZDIR"
export CXXFLAGS="$CXXFLAGS -I$TZDIR"
export LDFLAGS="$LDFLAGS -L$TZDIR"
export LIBRARY_PATH="$LIBRARY_PATH:$TZDIR"
# this helps alpine linux build
export PKG_CONFIG_PATH="$PKG_CONFIG_PATH:$TZDIR"

# tkrzw-java
cd ../tkrzw-java
cp ../tkrzw/libtkrzw.a .
./configure --host $BUILDTARGET
make -j4

TARGET_LIB=libjtkrzw.so
${STRIP:-strip} ./$TARGET_LIB

OUTPUT_DIR="../../tkrzw-${BUILDOS}-${BUILDARCH}/src/main/resources/jne/${BUILDOS}/${BUILDARCH}"
cp ./$TARGET_LIB "$OUTPUT_DIR"