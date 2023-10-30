#!/bin/bash -lex
# shell w/ login & interactive, exit if any command fails, log each command

BASEDIR=$(dirname "$0")
cd "$BASEDIR/.."
PROJECT_DIR=$PWD

BUILDOS=$1
BUILDARCH=$2
BUILDTARGET=$3

# Setup cross compile environment
#if [ -f /opt/setup-cross-build-environment.sh ]; then
#  source /opt/setup-cross-build-environment.sh $BUILDOS $BUILDARCH
#fi

mkdir -p target
rsync -avrt --delete ./native/ ./target/

# zlib dependency (only on containers though)
if [ -d /project ]; then
  cd target
  tar zxvf zlib-1.3.tar.gz
  cd zlib-1.3
  ./configure --prefix=$SYSROOT
  make

  export ZLIBDIR="$PWD"
  export CPATH="$CPATH:$ZLIBDIR"
  export CXXFLAGS="$CXXFLAGS -I$ZLIBDIR"
  export LDFLAGS="$LDFLAGS -L$ZLIBDIR"
  export PKG_CONFIG_PATH="$PKG_CONFIG_PATH:$ZLIBDIR"

  #make install
  cd ../../
fi

export CFLAGS="$CFLAGS -Wa,--noexecstack"
export CXXFLAGS="$CXXFLAGS -Wa,--noexecstack"

# tkrzw dependency
cd ./target/tkrzw
./configure --host $BUILDTARGET --enable-zlib
make -j4

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
cp ../zlib-1.3/libz.so .
cp ../tkrzw/libtkrzw.a .
./configure --host $BUILDTARGET
make -j4

TARGET_LIB=libjtkrzw.so
${STRIP:-strip} ./$TARGET_LIB

OUTPUT_DIR="../../tkrzw-${BUILDOS}-${BUILDARCH}/src/main/resources/jne/${BUILDOS}/${BUILDARCH}"
cp ./$TARGET_LIB "$OUTPUT_DIR"