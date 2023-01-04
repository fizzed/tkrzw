Java distribution of Tkrzw & JNI libs by Fizzed
------------------------------------------------------

This is a published version of the Tkrzw library for Java 8+, along with native libs that are automatically extracted at runtime.

The Java library is as unmodified as possible from the original Tkrzw, but a few changes were made to automatically
extract the library at runtime, along with much improved double locking to prevent the library from being loaded multiple
times.

Linux x64 native libs are compiled on Ubuntu 18.04, so you can be assured they'll work well on various flavors of linux
going back several years in time.

## Compression

zlib is enabled, zstd/lzma/lz4 are not enabled since those dependencies are not very common in many environments and
would prevent the library from loading in Java.


```xml
<dependency>
  <groupId>com.fizzed</groupId>
  <artifactId>tkrzw-linux-x64</artifactId>
  <version>VERSION-HERE</version>
</dependency>
```

You can use an Ubuntu x86_64 host to test a wide variety of hardware architectures and operating systems. For more
information on how this works, please visit https://github.com/fizzed/blaze-buildx#multiple-architecture-containers