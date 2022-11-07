# Building with Musl

These are scripts for building applications with [Musl](http://musl.libc.org/) support.
They use the [Unikraft-ported `lib-musl`](https://github.com/unikraft/lib-musl) together with [ongoing PRs](https://github.com/unikraft/lib-musl/pulls).

The top-level scripts (with the `do-` prefix) are the wrapper scripts to setup, build and run Unikraft applications (built with Musl support).
They include common-part scripts in the `../include/` directory.

Applications, libraries and Unikraft are set up and built in the `../workdir/` directory.

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

   This results in creating the `../workdir/` folder with the local conventional file hierarchy:

   ```
   $ tree -L 2 ../workdir/
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

## app-micropython

Use the `do-micropython` script to build and run [`app-micropython`](https://github.com/unikraft/app-micropython.git) with Unikraft and [Musl](https://github.com/unikraft/lib-musl) as its libc.
Follow the exact same steps as above, but replace `helloworld` with `micropython` throughout commands to use.

The `run` command runs the `helloworld.py` script in a MicroPython runtime.

```
./do-micropython run

[...]
SeaBIOS (version 1.10.2-1ubuntu1)
Booting from ROM...
Powered by
o.   .o       _ _               __ _
Oo   Oo  ___ (_) | __ __  __ _ ' _) :_
oO   oO ' _ `| | |/ /  _)' _` | |_|  _)
oOo oOO| | | | |   (| | | (_) |  _) :_
 OoOoO ._, ._:_:_,\_._,  .__,_:_, \___)
                 Phoebe 0.10.0~4eba7029
/home/razvan/Documents/Unikraft/test_musl/workdir/apps/app-micropython/build/micropython_kvm-x86_64: can't open file 'console=ttyS0': [Errno 20] Not a directory
Hello, world!
Console terminated, terminating guest (PID: 11461)...
```

## test

Use the `do-test` script to build and run the custom tests from [Dragoș's repository](https://github.com/dragosargint/test);
they test the clone system call and new thread support in Unikraft.

Follow the exact same steps as above, but replace `helloworld` with `test` throughout commands to use.

Using the `run` command prints out an extensive output (debugging is enable).
The relevant lines are red `ERR` lines.
As long as they mention `GOOD` in the message, everything is OK:

```
$ ./do-test run
[...]
[    9.997356] ERR:  <init> {r:0x10e9e1,f:0x7f968f0} [test] <test_pr_566_pthread_basic.c @   13> GOOD: Argument arrived correctly in thread_fun()
[...]
[   10.147727] ERR:  <init> {r:0x10ebd1,f:0x7fdff30} [test] <test_pr_566_pthread_basic.c @   34> GOOD: Self reference for pthread threads works
[   10.167965] ERR:  <init> {r:0x10ec43,f:0x7fdff30} [test] <test_pr_566_pthread_basic.c @   41> GOOD: The returned value from the thread_fun si correct
[...]
```

## libc-test

Use the `do-libc-test` script to build and run tests in the [`libc-test` repository](https://github.com/unikraft/lib-libc-test).
They test the interface of Musl (and, presumably, other standard C libraries).

Follow the exact same steps as above, but replace `helloworld` with `libc-test` throughout commands to use.

The `run` command triggers the execution of tests.

```
$ ./do-libc-test run
[...]
test: uk_libc_testsuite->string_memcpy_tests
    :   expected `test_align(i,j,k)` to be 0 and was 0 .................................. [ PASSED ]
    :   expected `test_align(i,j,k)` to be 0 and was 0 .................................. [ PASSED ]
    :   expected `test_align(i,j,k)` to be 0 and was 0 .................................. [ PASSED ]
[...]
```

## libsodium

Use the `do-libsodium` script to build and run tests in the [`lib-libsodium` repository](https://github.com/unikraft/lib-libsodium).
The script builds libsodium together with Musl.

Follow the exact same steps as above, but replace `helloworld` with `libsodium` throughout commands to use.

The `run` command triggers the execution of tests.

```
$ ./do-libc-test run
[...]
test: libsodium_minimal_testsuite->uktest_test_aead_aes256gcm
    :   expected `uk_sodium_cmptest(&aead_aes256gcm)` to be 0 and was 0 ................. [ PASSED ]
test: libsodium_minimal_testsuite->uktest_test_aead_aes256gcm2
    :   expected `uk_sodium_cmptest(&aead_aes256gcm2)` to be 0 and was 0 ................ [ PASSED ]
test: libsodium_minimal_testsuite->uktest_test_aead_chacha20poly1305
    :   expected `uk_sodium_cmptest(&aead_chacha20poly1305)` to be 0 and was 0 .......... [ PASSED ]
test: libsodium_minimal_testsuite->uktest_test_aead_chacha20poly13052
    :   expected `uk_sodium_cmptest(&aead_chacha20poly13052)` to be 0 and was 0 ......... [ PASSED ]
test: libsodium_minimal_testsuite->uktest_test_aead_xchacha20poly1305
    :   expected `uk_sodium_cmptest(&aead_xchacha20poly1305)` to be 0 and was 0 ......... [ PASSED ]
test: libsodium_minimal_testsuite->uktest_test_auth
    :   expected `uk_sodium_cmptest(&auth)` to be 0 and was 0 ........................... [ PASSED ]
[...]
```

## Python3

Use the `do-python3` script to build and run [`app-python3`](https://github.com/unikraft/app-python3) with Unikraft and [Musl](https://github.com/unikraft/lib-musl) as its libc.
Follow the exact same steps as above, but replace `helloworld` with `python3` throughout commands to use.

The `run` command starts a Python shell:

```
$ ./do-python3 run

[...]
>>> 2**32
4294967296
```

## SQLite

Use the `do-sqlite` script to build and run [`app-sqlite`](https://github.com/unikraft/app-sqlite) with Unikraft and [Musl](https://github.com/unikraft/lib-musl) as its libc.
Follow the exact same steps as above, but replace `helloworld` with `sqlite` throughout commands to use.

The `run` command starts a Python shell:

```
$ ./do-sqlite run

[...]
Booting from ROM...
Powered by
o.   .o       _ _               __ _
Oo   Oo  ___ (_) | __ __  __ _ ' _) :_
oO   oO ' _ `| | |/ /  _)' _` | |_|  _)
oOo oOO| | | | |   (| | | (_) |  _) :_
 OoOoO ._, ._:_:_,\_._,  .__,_:_, \___)
                 Phoebe 0.10.0~cb60cdcd
-- warning: cannot find home directory; cannot read ~/.sqliterc
SQLite version 3.30.1 2019-10-10 20:19:45
Enter ".help" for usage hints.
sqlite>
```

## Redis

Use the `do-redis` script to build and run [`app-redis`](https://github.com/unikraft/app-redis) with Unikraft and [Musl](https://github.com/unikraft/lib-musl) as its libc.
Follow the exact same steps as above, but replace `helloworld` with `redis` throughout commands to use.

The `run` command creates a Redis server waiting for connections:

```
$ ./do-redis run_qemu

[...]
1: Set IPv4 address 172.44.0.2 mask 255.255.255.0 gw 172.44.0.1
en1: Added
en1: Interface is up
Powered by
o.   .o       _ _               __ _
Oo   Oo  ___ (_) | __ __  __ _ ' _) :_
oO   oO ' _ `| | |/ /  _)' _` | |_|  _)
oOo oOO| | | | |   (| | | (_) |  _) :_
 OoOoO ._, ._:_:_,\_._,  .__,_:_, \___)
                 Phoebe 0.10.0~0bbbd142
0:M 09 Nov 2022 16:25:01.022 # oO0OoO0OoO0Oo Redis is starting oO0OoO0OoO0Oo
0:M 09 Nov 2022 16:25:01.026 # Redis version=5.0.6, bits=64, commit=c5ee3442, modified=1, pid=0, just started
0:M 09 Nov 2022 16:25:01.031 # Configuration loaded
0:M 09 Nov 2022 16:25:01.096 # You requested maxclients of 10000 requiring at least 10032 max file descriptors.
0:M 09 Nov 2022 16:25:01.102 # Server can't set maximum open files to 10032 because of OS error: No such file or directory.
0:M 09 Nov 2022 16:25:01.110 # Current maximum open files is 1024. maxclients has been reduced to 992 to compensate for low ulimit. If you need higher maxclients increase 'ulimit -n'.
0:M 09 Nov 2022 16:25:01.119 # Warning: can't mask SIGALRM in bio.c thread: No error information
0:M 09 Nov 2022 16:25:01.126 # Warning: can't mask SIGALRM in bio.c thread: No error information
0:M 09 Nov 2022 16:25:01.135 # Warning: can't mask SIGALRM in bio.c thread: No error information
                _._
           _.-``__ ''-._
      _.-``    `.  `_.  ''-._           Redis 5.0.6 (c5ee3442/1) 64 bit
  .-`` .-```.  ```\/    _.,_ ''-._
 (    '      ,       .-`  | `,    )     Running in standalone mode
 |`-._`-...-` __...-.``-._|'` _.-'|     Port: 6379
 |    `-._   `._    /     _.-'    |     PID: 0
  `-._    `-._  `-./  _.-'    _.-'
 |`-._`-._    `-.__.-'    _.-'_.-'|
 |    `-._`-._        _.-'_.-'    |           http://redis.io
  `-._    `-._`-.__.-'_.-'    _.-'
 |`-._`-._    `-.__.-'    _.-'_.-'|
 |    `-._`-._        _.-'_.-'    |
  `-._    `-._`-.__.-'_.-'    _.-'
      `-._    `-.__.-'    _.-'
          `-._        _.-'
              `-.__.-'

0:M 09 Nov 2022 16:25:01.262 # Server initialized
0:M 09 Nov 2022 16:25:01.267 * Ready to accept connections
```

The server waits for connection on IP address `172.44.0.2` on the default port (`6379`).
Test it by running `redis-cli` in another console:

```
$ redis-cli -h 172.44.0.2
172.44.0.2:6379> PING
PONG
172.44.0.2:6379>
```

## Nginx

Use the `do-httpreply` script to build and run [`app-nginx`](https://github.com/unikraft/app-nginx) with Unikraft and [Musl](https://github.com/unikraft/lib-musl) as its libc.
Follow the exact same steps as above, but replace `helloworld` with `nginx` throughout commands to use.

The `run` command aims to start an Nginx web server:

```
$ ./do-nginx run_qemu
1: Set IPv4 address 172.44.0.2 mask 255.255.255.0 gw 172.44.0.1
en1: Added
en1: Interface is up
Powered by
o.   .o       _ _               __ _
Oo   Oo  ___ (_) | __ __  __ _ ' _) :_
oO   oO ' _ `| | |/ /  _)' _` | |_|  _)
oOo oOO| | | | |   (| | | (_) |  _) :_
 OoOoO ._, ._:_:_,\_._,  .__,_:_, \___)
                 Phoebe 0.10.0~0bbbd142
nginx: [emerg] sigaction(SIGHUP) failed (38: Unknown error)
```

Given the current lack of signal support, the command fails.
