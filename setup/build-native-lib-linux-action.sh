#!/bin/sh

BASEDIR=$(dirname "$0")
cd "$BASEDIR/.." || exit 1
PROJECT_DIR=$PWD

mkdir -p target
rsync -avrt --delete ./native/ ./target/ || exit 1
mkdir -p target/output

cd ./target/tkrzw
./configure --enable-zlib || exit 1
make -j4 || exit 1

# we want to force linking libjtokyocabinet against the static lib vs. the dynamic since some LD loading will look
# for the soname and versioned library, but we can only auto extract a single .so at a time
rm -f ./*.so
rm -f ./*.dylib

ls -la .

# these flags will only help the ./configure succeed for tokyocabinet-java
export TZDIR="$PWD"
export CPATH="$CPATH:$TZDIR"
export LIBRARY_PATH="$LIBRARY_PATH:$TZDIR"
# this helps alpine linux build
export PKG_CONFIG_PATH="$PKG_CONFIG_PATH:$TZDIR"

cd ../tkrzw-java
./configure || exit 1

make -j4 || exit 1

ls -la "$PROJECT_DIR/target/output/"

if [ $(uname -s) = "Darwin" ]; then
  cp ./libjtkrzw.dylib "$PROJECT_DIR/target/output/"
  strip -u -r "$PROJECT_DIR/target/output/libjtkrzw.dylib" || exit 1
else
  cp ./libjtkrzw.so "$PROJECT_DIR/target/output/"
  strip "$PROJECT_DIR/target/output/libjtkrzw.so" || exit 1
fi

ls -la "$PROJECT_DIR/target/output/"