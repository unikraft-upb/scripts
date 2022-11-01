# Building with Musl

These are scripts for building applications with [Musl](http://musl.libc.org/) support.
They use the [Unikraft-ported `lib-musl`](https://github.com/unikraft/lib-musl) together with [ongoing PRs](https://github.com/unikraft/lib-musl/pulls).

The top-level scripts (with the `do-` prefix) are the wrapper scripts to setup, build and run Unikraft applications (built with Musl support).
They include common-part scripts in the `include/` directory.

Applications, libraries and Unikraft are set up and built in the `workdir/` directory.

## app-helloworld

Use the `do-helloworld` script to build and run [`app-helloworld`](https://github.com/unikraft/app-helloworld) with Unikraft and [Musl](https://github.com/unikraft/lib-musl) as its libc.
Note that Musl is not actually used, since the internal [`nolibc` library](https://github.com/unikraft/unikraft/tree/staging/lib/nolibc) has all required features;
it is however built and integrated into the final image.
[lwip](https://github.com/unikraft/lib-lwip) is also included in the build, although, again, is not really required;
you can disable the inclusion of `lwip` by switchin the `USE_LWIP` variable in the `do-helloworld` script to value `0`.

Pass required commands to script:

1. First, set up repositories:

   ```
   $ ./do-helloworld setup
   ```

   This results in creating the `workdir/` folder with the local conventional file hierarchy:

   ```
   $ tree -L 2 workdir/
   workdir/
   |-- apps
   |   `-- app-helloworld
   |-- archs
   |-- libs
   |   |-- lwip
   |   `-- musl
   |-- plats
   `-- unikraft
   [...]
   ```

1. Build the hellworld Unikraft image:

   ```
   $ ./do-helloworld build

   [...]
   Successfully built unikernels:

     => build/helloworld-x86_64
     => build/helloworld_kvm-x86_64.dbg (with symbols)

   To instantiate, use: kraft run
   ```

1. Run the hellworld Unikraft image:

   ```
   $ ./do-helloworld run

   [...]
   Booting from ROM...
   Powered by
   o.   .o       _ _               __ _
   Oo   Oo  ___ (_) | __ __  __ _ ' _) :_
   oO   oO ' _ `| | |/ /  _)' _` | |_|  _)
   oOo oOO| | | | |   (| | | (_) |  _) :_
    OoOoO ._, ._:_:_,\_._,  .__,_:_, \___)
                    Phoebe 0.10.0~43989277
   Hello, world!
   ```

   The image prints the `Hello, world!` message.

## app-helloworld-cpp

Use the `do-helloworld-cpp` script to build and run [`app-helloworld-cpp`](https://github.com/unikraft/app-helloworld-cpp) with Unikraft and [Musl](https://github.com/unikraft/lib-musl) as its libc.
Follow the exact same steps as above, but replace `helloworld` with `helloworld-cpp` throughout commands to use.
This includes the possible exclusion of the `lwip` library from the build by toggling the value of the `USE_LWIP` variable in the `do-helloworld-cpp` script.

## app-httpreply

Use the `do-httpreply` script to build and run [`app-httpreply`](https://github.com/unikraft/app-httpreply) with Unikraft and [Musl](https://github.com/unikraft/lib-musl) as its libc.
Follow the exact same steps as above, but replace `helloworld` with `httpreply` throughout commands to use.

The `run` command creates a web server waiting for connections:

```
$ ./do-httpreply run

[...]
Booting from ROM...
1: Set IPv4 address 172.44.0.2 mask 255.255.255.0 gw 172.44.0.1
en1: Added
en1: Interface is up
Powered by
o.   .o       _ _               __ _
Oo   Oo  ___ (_) | __ __  __ _ ' _) :_
oO   oO ' _ `| | |/ /  _)' _` | |_|  _)
oOo oOO| | | | |   (| | | (_) |  _) :_
 OoOoO ._, ._:_:_,\_._,  .__,_:_, \___)
                 Phoebe 0.10.0~43989277
Listening on port 8123...
```

The server waits for connection on IP address `172.44.0.2` on port `8123`.
Test it by running `ping` and then `wget` on another console:

```
$ ping 172.44.0.2
PING 172.44.0.2 (172.44.0.2) 56(84) bytes of data.
64 bytes from 172.44.0.2: icmp_seq=1 ttl=255 time=0.917 ms
^C
--- 172.44.0.2 ping statistics ---
1 packets transmitted, 1 received, 0% packet loss, time 0ms
rtt min/avg/max/mdev = 0.917/0.917/0.917/0.000 ms

$ wget 172.44.0.2:8123
--2022-11-01 22:17:37--  http://172.44.0.2:8123/
Connecting to 172.44.0.2:8123... connected.
HTTP request sent, awaiting response... 200 OK
Length: unspecified [text/html]
Saving to: ‘index.html’

index.html                                        [ <=>                                                                                             ]     160  --.-KB/s    in 0s      

2022-11-01 22:17:37 (33.9 MB/s) - ‘index.html’ saved [160]
```

The `index.html` page is provided by the server.
A confirmation message is also shown by the Unikraft server in its console:

```
[...]
Sent a reply
```
