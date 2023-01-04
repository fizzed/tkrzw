Java distribution of Tkrzw & JNI libs by Fizzed
------------------------------------------------------

[![Maven Central](https://img.shields.io/maven-central/v/com.fizzed/tkrzw?color=blue&style=flat-square)](https://mvnrepository.com/artifact/com.fizzed/tkrzw)

[![Java 8](https://img.shields.io/github/actions/workflow/status/fizzed/tkrzw/java8.yaml?branch=master&label=Java%208&style=flat-square)](https://github.com/fizzed/tkrzw/actions/workflows/java8.yaml)
[![Java 11](https://img.shields.io/github/actions/workflow/status/fizzed/tkrzw/java11.yaml?branch=master&label=Java%2011&style=flat-square)](https://github.com/fizzed/tkrzw/actions/workflows/java11.yaml)
[![Java 17](https://img.shields.io/github/actions/workflow/status/fizzed/tkrzw/java17.yaml?branch=master&label=Java%2017&style=flat-square)](https://github.com/fizzed/tkrzw/actions/workflows/java17.yaml)

[![Linux x64](https://img.shields.io/github/actions/workflow/status/fizzed/tkrzw/java11.yaml?branch=master&label=Linux%20x64&style=flat-square)](https://github.com/fizzed/tkrzw/actions/workflows/java11.yaml)
[![Linux arm64](https://img.shields.io/github/actions/workflow/status/fizzed/tkrzw/linux-arm64.yaml?branch=master&label=Linux%20arm64&style=flat-square)](https://github.com/fizzed/tkrzw/actions/workflows/linux-arm64.yaml)
[![Linux riscv64](https://img.shields.io/github/actions/workflow/status/fizzed/tkrzw/linux-riscv64.yaml?branch=master&label=Linux%20riscv64&style=flat-square)](https://github.com/fizzed/tkrzw/actions/workflows/linux-riscv64.yaml)
[![Linux MUSL x64](https://img.shields.io/github/actions/workflow/status/fizzed/tkrzw/linux-musl-x64.yaml?branch=master&label=Linux%20MUSL%20x64&style=flat-square)](https://github.com/fizzed/tkrzw/actions/workflows/linux-musl-x64.yaml)
[![Linux MUSL arm64](https://img.shields.io/github/actions/workflow/status/fizzed/tkrzw/linux-musl-arm64.yaml?branch=master&label=Linux%20MUSL%20arm64&style=flat-square)](https://github.com/fizzed/tkrzw/actions/workflows/linux-musl-arm64.yaml)
[![MacOS x64](https://img.shields.io/github/actions/workflow/status/fizzed/tkrzw/macos-x64.yaml?branch=master&label=MacOS%20x64&style=flat-square)](https://github.com/fizzed/tkrzw/actions/workflows/macos-x64.yaml)
![MacOS arm64](https://img.shields.io/badge/MacOS%20arm64-available-blue)

This is a published version of the Tkrzw library for Java 8+, along with native libs that are automatically extracted at runtime.

The Java library is as unmodified as possible from the original Tkrzw, but a few changes were made to automatically
extract the library at runtime, along with much improved double locking to prevent the library from being loaded multiple
times.

Linux x64 native libs are compiled on Ubuntu 18.04, so you can be assured they'll work well on various flavors of linux
going back several years in time.

## Compression

zlib is enabled, zstd/lzma/lz4 are not enabled since those dependencies are not very common in many environments and
would prevent the library from loading in Java.

## Usage

Add the following to your maven POM file for Linux x64

```xml
<dependency>
  <groupId>com.fizzed</groupId>
  <artifactId>tkrzw-linux-x64</artifactId>
  <version>VERSION-HERE</version>
</dependency>
```

Or MacOS arm64 (Apple silicon)

```xml
<dependency>
  <groupId>com.fizzed</groupId>
  <artifactId>tkrzw-macos-arm64</artifactId>
  <version>VERSION-HERE</version>
</dependency>
```

Or for all operating system & arches

```xml
<dependency>
  <groupId>com.fizzed</groupId>
  <artifactId>tkrzw-all-natives</artifactId>
  <version>VERSION-HERE</version>
</dependency>
```

To simplify versions, you may optionally want to import our BOM (bill of materials)

```xml
<dependencyManagement>
    <dependencies>
        <dependency>
            <groupId>com.fizzed</groupId>
            <artifactId>tkrzw-bom</artifactId>
            <version>VERSION-HERE</version>
            <scope>import</scope>
            <type>pom</type>
        </dependency>
    </dependencies>
</dependencyManagement>
```

## Native Libs

Zip libraries must be installed for this version to run.

     sudo apt install zlib1g          # e.g. on ubuntu/debian
     sudo apk add zlib                # e.g. on alpine

| OS Arch          | Artifact                 | Info                              |
|------------------|--------------------------|-----------------------------------|
| Linux x64        | tkrzw-linux-x64          | built on ubuntu 18.04, glibc 2.27 |
| Linux arm64      | tkrzw-linux-arm64        | built on ubuntu 18.04, glibc 2.27 |
| Linux armhf      | tkrzw-linux-armhf        | built on ubuntu 18.04, glibc 2.27 |
| Linux MUSL x64   | tkrzw-linux_musl-x64     | built on alpine 3.11              |
| Linux MUSL arm64 | tkrzw-linux_musl-arm64   | built on alpine 3.11              |
| Linux riscv64    | tkrzw-linux-riscv64      | built on ubuntu 20.04, glibc 2.31 |
| MacOS x64        | tkrzw-macos-x64          | built on macos 10.13 high sierra  |
| MacOS arm64      | tkrzw-macos-arm64        | built on macos 12 monterey        |

## Development

We use a simple, yet quite sophisticated build system for fast, local builds across operating system and architectures.

For linux targets, we leverage docker containers either running locally on an x86_64 host, or remotely on dedicated
build machines running on arm64, macos x64, and macos arm64.

To build containers, you'll want to edit setup/blaze.java and comment out/edit which platforms you'd like to build for,
or potentially change them running on a remote machine via SSH.  Once you're happy with what you want to build for:

     java -jar setup/blaze.jar setup/blaze.java build_containers

     java -jar setup/blaze.jar setup/blaze.java build_native_libs

For information on registering your x86_64 host to run other architectures (e.g. riscv64 or aarch64), please see
the readme for https://github.com/fizzed/jne#development