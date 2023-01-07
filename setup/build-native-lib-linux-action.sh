#!/bin/sh -l
# Use a shell as though we logged in

BASEDIR=$(dirname "$0")
cd "$BASEDIR/.." || exit 1
PROJECT_DIR=$PWD

BUILDOS=$1
BUILDARCH=$2

if [ -z "${BUILDOS}" ] || [ -z "${BUILDOS}" ]; then
  echo "Usage: script [os] [arch]"
  exit 1
fi

echo ""
echo "Building for"
echo " projectDir: $PROJECT_DIR"
echo " os: $BUILDOS"
echo " arch: $BUILDARCH"

mkdir -p target
rsync -avrt --delete ./native/ ./target/ || exit 1

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

TARGET_LIB=libjtkrzw.so
if [ "$BUILDOS" = "macos" ]; then
  TARGET_LIB=libjtkrzw.dylib
  strip -u -r ./$TARGET_LIB || exit 1
else
  strip ./$TARGET_LIB || exit 1
fi

OUTPUT_DIR="../../tkrzw-${BUILDOS}-${BUILDARCH}/src/main/resources/jne/${BUILDOS}/${BUILDARCH}"
cp ./$TARGET_LIB "$OUTPUT_DIR"

echo "Copied ./$TARGET_LIB to $OUTPUT_DIR"
echo "Done!"