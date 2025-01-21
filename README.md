Java distribution of Tkrzw & JNI libs by Fizzed
------------------------------------------------------

[![Maven Central](https://img.shields.io/maven-central/v/com.fizzed/tkrzw?color=blue&style=flat-square)](https://mvnrepository.com/artifact/com.fizzed/tkrzw)

The following Java versions and platforms are tested using GitHub workflows:

[![Java 8](https://img.shields.io/github/actions/workflow/status/fizzed/tkrzw/java8.yaml?branch=master&label=Java%208&style=flat-square)](https://github.com/fizzed/tkrzw/actions/workflows/java8.yaml)
[![Java 11](https://img.shields.io/github/actions/workflow/status/fizzed/tkrzw/java11.yaml?branch=master&label=Java%2011&style=flat-square)](https://github.com/fizzed/tkrzw/actions/workflows/java11.yaml)
[![Java 17](https://img.shields.io/github/actions/workflow/status/fizzed/tkrzw/java17.yaml?branch=master&label=Java%2017&style=flat-square)](https://github.com/fizzed/tkrzw/actions/workflows/java17.yaml)
[![Java 21](https://img.shields.io/github/actions/workflow/status/fizzed/tkrzw/java21.yaml?branch=master&label=Java%2021&style=flat-square)](https://github.com/fizzed/tkrzw/actions/workflows/java21.yaml)

[![Linux x64](https://img.shields.io/github/actions/workflow/status/fizzed/tkrzw/java11.yaml?branch=master&label=Linux%20x64&style=flat-square)](https://github.com/fizzed/tkrzw/actions/workflows/java11.yaml)
[![MacOS arm64](https://img.shields.io/github/actions/workflow/status/fizzed/tkrzw/macos-arm64.yaml?branch=master&label=MacOS%20arm64&style=flat-square)](https://github.com/fizzed/tkrzw/actions/workflows/macos-arm64.yaml)
[![Windows x64](https://img.shields.io/github/actions/workflow/status/fizzed/tkrzw/windows-x64.yaml?branch=master&label=Windows%20x64&style=flat-square)](https://github.com/fizzed/tkrzw/actions/workflows/windows-x64.yaml)

The following platforms are tested using the [Fizzed, Inc.](http://fizzed.com) build system:

[![Linux arm64](https://img.shields.io/badge/Linux%20arm64-passing-green)](buildx-results.txt)
[![Linux armhf](https://img.shields.io/badge/Linux%20armhf-passing-green)](buildx-results.txt)
[![Linux riscv64](https://img.shields.io/badge/Linux%20riscv64-passing-green)](buildx-results.txt)
[![Linux MUSL x64](https://img.shields.io/badge/Linux%20MUSL%20x64-passing-green)](buildx-results.txt)
[![MacOS x64](https://img.shields.io/badge/MacOS%20x64-passing-green)](buildx-results.txt)
[![Windows arm64](https://img.shields.io/badge/Windows%20arm64-passing-green)](buildx-results.txt)
[![FreeBSD x64](https://img.shields.io/badge/FreeBSD%20x64-passing-green)](buildx-results.txt)
[![OpenBSD x64](https://img.shields.io/badge/OpenBSD%20x64-passing-green)](buildx-results.txt)

## Overview

This is a published version of the [Tkrzw library](https://dbmx.net/tkrzw/) for Java 8+, along with native libs that are
automatically extracted at runtime.

The Java library is as unmodified as possible from the original Tkrzw, but a few changes were made to automatically
extract the library at runtime, along with much improved double locking to prevent the library from being loaded multiple
times.

Linux x64 native libs are compiled on Ubuntu 18.04, so you can be assured they'll work well on various flavors of linux
going back several years in time.

## Sponsorship & Support

![](https://cdn.fizzed.com/github/fizzed-logo-100.png)

Project by [Fizzed, Inc.](http://fizzed.com) (Follow on Twitter: [@fizzed_inc](http://twitter.com/fizzed_inc))

**Developing and maintaining opensource projects requires significant time.** If you find this project useful or need
commercial support, we'd love to chat. Drop us an email at [ping@fizzed.com](mailto:ping@fizzed.com)

Project sponsors may include the following benefits:

- Priority support (outside of Github)
- Feature development & roadmap
- Priority bug fixes
- Privately hosted continuous integration tests for their unique edge or use cases

## Usage

Add the following to your maven POM file for Linux x64

```xml
<dependency>
  <groupId>com.fizzed</groupId>
  <artifactId>tkrzw-linux-x64</artifactId>
  <version>0.0.9</version>
</dependency>
```

Or MacOS arm64 (Apple silicon)

```xml
<dependency>
  <groupId>com.fizzed</groupId>
  <artifactId>tkrzw-macos-arm64</artifactId>
  <version>0.0.9</version>
</dependency>
```

Or for all operating system & arches

```xml
<dependency>
  <groupId>com.fizzed</groupId>
  <artifactId>tkrzw-all-natives</artifactId>
  <version>0.0.9</version>
</dependency>
```

To simplify versions, you may optionally want to import our BOM (bill of materials)

```xml
<dependencyManagement>
    <dependencies>
        <dependency>
            <groupId>com.fizzed</groupId>
            <artifactId>tkrzw-bom</artifactId>
            <version>0.0.9</version>
            <scope>import</scope>
            <type>pom</type>
        </dependency>
    </dependencies>
</dependencyManagement>
```

In your java code you can use the Tkrzw api as documented [here](https://dbmx.net/tkrzw/api-java/)

## Native Libs

zlib is enabled, zstd/lzma/lz4 are not enabled since those dependencies are not very common in many environments and
would prevent the library from loading in Java.

Zip libraries must be installed for this version to run. You must also install libstdc++.

     sudo apt install zlib1g          # e.g. on ubuntu/debian
     sudo apk add zlib                # e.g. on alpine

| OS Arch          | Artifact               | Info                              |
|------------------|------------------------|-----------------------------------|
| Linux x64        | tkrzw-linux-x64        | built on ubuntu 18.04, glibc 2.27 |
| Linux arm64      | tkrzw-linux-arm64      | built on ubuntu 18.04, glibc 2.27 |
| Linux armhf      | tkrzw-linux-armhf      | built on ubuntu 18.04, glibc 2.27 |
| Linux armel      | tkrzw-linux-armel      | built on ubuntu 18.04, glibc 2.27 |
| Linux MUSL x64   | tkrzw-linux_musl-x64   | built on alpine 3.11              |
| Linux MUSL arm64 | tkrzw-linux_musl-arm64 | built on alpine 3.11              |
| Linux riscv64    | tkrzw-linux-riscv64    | built on ubuntu 20.04, glibc 2.31 |
| MacOS x64        | tkrzw-macos-x64        | built on macos 10.13 high sierra  |
| MacOS arm64      | tkrzw-macos-arm64      | built on macos 12 monterey        |
| Windows x64      | tkrzw-windows-x64      | targets win 7+                    |
| Windows arm64    | tkrzw-windows-arm64    | tested on win 10+                 |
| FreeBSD x64      | tkrzw-freebsd-x64      | targets freebsd 12+               |
| OpenBSD x64      | tkrzw-openbsd-x64      | targets openbsd 7.6+              |

## Development

We use a simple, yet quite sophisticated build system for fast, local builds across operating system and architectures.
To build and test locally, you can leverage our [Blaze](https://github.com/fizzed/blaze) build system

     java -jar blaze.jar build_natives
     java -jar blaze.jar test

For cross compiling and testing, we leverage [Buildx](https://github.com/fizzed/buildx) as a plugin to our Blaze script.
For linux targets, we leverage docker containers either running locally on an x86_64 host, or remotely on dedicated
build machines running on arm64, macos x64, and macos arm64.  To build containers, you'll want to edit .blaze/blaze.java
and comment out/edit which platforms you'd like to build for, or potentially change them running on a remote machine
via SSH.  Once you're happy with what you want to build for:

    java -jar blaze.jar cross_build_containers

Or

    java -jar blaze.jar cross_build_containers --targets linux-x64

Then

    java -jar blaze.jar cross_build_natives --targets linux-x64
    java -jar blaze.jar cross_tests --targets linux-x64

For information on registering your x86_64 host to run other architectures (e.g. riscv64 or aarch64), please see
the readme for https://github.com/fizzed/buildx

## License

Copyright (C) 2020+ Fizzed, Inc.

This work is licensed under the Apache License, Version 2.0. See LICENSE for details.
