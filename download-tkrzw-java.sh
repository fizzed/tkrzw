VERSION=0.1.28

rm -Rf tkrzw-java-*
wget https://dbmx.net/tkrzw/pkg-java/tkrzw-java-$VERSION.tar.gz
tar zxvf tkrzw-java-$VERSION.tar.gz
# remove the loader since we have our own special one
rm -f tkrzw-java-$VERSION/Loader.java
# remove ALL lines of code that loads the library
sed -i 's/System.loadLibrary("jtkrzw");/CustomLoader.loadLibrary();/g' tkrzw-java-$VERSION/*.java;
# copy everything over
cp tkrzw-java-$VERSION/*.java tkrzw-api/src/main/java/tkrzw/
# remove all tests
rm -Rf tkrzw-api/src/main/java/tkrzw/*Test.java
rm -Rf tkrzw-java-*
