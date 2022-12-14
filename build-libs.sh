mkdir -p ./target/libs
docker run -it -v $PWD/target:/target -e "VERSION=1.0.24" -e "JAVA_VERSION=0.1.28" tkrzw-buildbox /root/build-tkrzw.sh
cp ./target/libs/* tkrzw-linux-x64/src/main/resources/jne/linux/x64/