# Scripts

These are helper scripts to interact with Unikraft.

## Build Scripts

## Nginx

Use the `do-unikraft-nginx` to set up, build and run [`app-nginx`](github.com/unikraft/app-nginx) with Unikraft.
Run the script anywhere.
It will create a conventional local file hierarchy for building the Unikraft image.

Pass required commands to script:

1. First, set up repositories:

   ```
   $ ./do-unikraft-nginx setup
   ```

   This results in creating the `unikraft-nginx/` folder with the local conventional file hierarchy:

   ```
   $ tree -L 2 unikraft-nginx/
   unikraft-nginx/
   |-- apps
   |   `-- app-nginx
   |-- archs
   |-- libs
   |   |-- lwip
   |   |-- newlib
   |   |-- nginx
   |   `-- pthread-embedded
   |-- plats
   `-- unikraft
   [...]
   ```

1. Build the Nginx Unikraft image:

   ```
   $ ./do-unikraft-nginx build

   [...]
   Successfully built unikernels:

     => build/nginx_kvm-x86_64
     => build/nginx_kvm-x86_64.dbg (with symbols)

   To instantiate, use: kraft run
   ```

1. Run the Nginx Unikraft image:

   ```
   $ ./do-unikraft-nginx run

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
                     Phoebe 0.10.0~9bf6e63
   ```

   The Nginx Unikraft instance now listens for HTTP connections on IP address `172.44.0.2`.

1. Test the running image:

   ```
   $ curl 172.44.0.2
   <!DOCTYPE html>
   <html>
   <head>
     <title>Hello, world!</title>
   </head>
   <body>
     <h1>Hello, world!</h1>
     <p>Powered by <a href="http://unikraft.org">Unikraft</a>.</p>
   </body>
   </html>
   ```

## Python3

Use the `do-unikraft-python3` to set up, build and run [`app-python3`](github.com/unikraft/app-python3) with Unikraft.
Run the script anywhere.
It will create a conventional local file hierarchy for building the Unikraft image.

Pass required commands to script:

1. First, set up repositories:

   ```
   $ ./do-unikraft-python3 setup
   ```

   This results in creating the `unikraft-python3/` folder with the local conventional file hierarchy:

   ```
   $ tree -L 2 unikraft-python3/
   unikraft-python3/
   |-- apps
   |   `-- app-python3
   |-- libs
   |   |-- libuuid
   |   |-- lwip
   |   |-- newlib
   |   |-- pthread-embedded
   |   |-- python3
   |   `-- zlib
   `-- unikraft
   [...]
   ```

1. Build the Python3 Unikraft image:

   ```
   $ ./do-unikraft-python3 build

   [...]
   Successfully built unikernels:

     => build/python3_kvm-x86_64
     => build/python3_kvm-x86_64.dbg (with symbols)

   To instantiate, use: kraft run
   ```

1. Run the Python3 Unikraft image:

   ```
   $ ./do-unikraft-python3 run

   [...]
   Booting from ROM...
   Powered by
   o.   .o       _ _               __ _
   Oo   Oo  ___ (_) | __ __  __ _ ' _) :_
   oO   oO ' _ `| | |/ /  _)' _` | |_|  _)
   oOo oOO| | | | |   (| | | (_) |  _) :_
    OoOoO ._, ._:_:_,\_._,  .__,_:_, \___)
                     Phoebe 0.10.0~9bf6e63
   Hello, world!
   ```

   The image runs the `helloworld.py` script located in the filesystem archive (`minrootfs.tgz`), resulting in the printing of the `Hello, world!` message.

## Redis

Use the `do-unikraft-redis` to set up, build and run [`app-redis`](github.com/unikraft/app-redis) with Unikraft.
Run the script anywhere.
It will create a conventional local file hierarchy for building the Unikraft image.

Pass required commands to script:

1. First, set up repositories:

   ```
   $ ./do-unikraft-redis setup
   ```

   This results in creating the `unikraft-redis/` folder with the local conventional file hierarchy:

   ```
   $ tree -L 2 unikraft-redis/
   unikraft-redis/
   |-- apps
   |   `-- app-redis
   |-- archs
   |-- libs
   |   |-- lwip
   |   |-- newlib
   |   |-- pthread-embedded
   |   `-- redis
   |-- plats
   `-- unikraft
   [...]
   ```

1. Build the Redis Unikraft image:

   ```
   $ ./do-unikraft-redis build

   [...]
   Successfully built unikernels:

     => build/redis_kvm-x86_64
     => build/redis_kvm-x86_64.dbg (with symbols)

   To instantiate, use: kraft run
   ```

1. Run the Redis Unikraft image:

   ```
   $ ./do-unikraft-redis run

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
                     Phoebe 0.10.0~9bf6e63
   1:C 23 Sep 2022 21:09:59.024 # oO0OoO0OoO0Oo Redis is starting oO0OoO0OoO0Oo
   1:C 23 Sep 2022 21:09:59.027 # Redis version=5.0.6, bits=64, commit=c5ee3442, modified=1, pid=1, just started
   1:C 23 Sep 2022 21:09:59.032 # Configuration loaded
   [    0.171777] ERR:  [libposix_process] <process.c @  399> Ignore updating resource 7: cur = 10032, max = 10032
   1:M 23 Sep 2022 21:09:59.075 * Increased maximum number of open files to 10032 (it was originally set to 1024).
                   _._
              _.-``__ ''-._
         _.-``    `.  `_.  ''-._           Redis 5.0.6 (c5ee3442/1) 64 bit
     .-`` .-```.  ```\/    _.,_ ''-._
    (    '      ,       .-`  | `,    )     Running in standalone mode
    |`-._`-...-` __...-.``-._|'` _.-'|     Port: 6379
    |    `-._   `._    /     _.-'    |     PID: 1
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

   1:M 23 Sep 2022 21:09:59.128 # Server initialized
   1:M 23 Sep 2022 21:09:59.130 * Ready to accept connections
   1: Set IPv4 address 172.44.0.2 mask 255.255.255.0 gw 172.44.0.1
   ```

   The Redis Unikraft instance now listens for connections on IP address `172.44.0.2` (port `6379`).

1. Test the running image using `redis-cli`.
   On Ubuntu / Debian, install the `redis-tools` package to have access to `redis-cli`:

   ```
   sudo apt install redis-tools
   ```

   Then issue a `PING` command with `redis-cli`:

   ```
   $ redis-cli -h 172.44.0.2
   172.44.0.2:6379> PING
   PONG
   172.44.0.2:6379>
   ```

## Musl Build

Use the `do-unikraft-musl` to set up, build and run [`app-helloworld`](https://github.com/unikraft/app-helloworld) with Unikraft and [Musl](https://github.com/unikraft/lib-musl) as its libc.
Note that Musl is not actually used, since the internal [`nolibc` library](https://github.com/unikraft/unikraft/tree/staging/lib/nolibc) has all required features;
it is however built and integrated into the final image.
[lwip](https://github.com/unikraft/lib-lwip) is cloned and set up but not used to build `app-helloworld`.
Run the script anywhere.
It will create a conventional local file hierarchy for building the Unikraft image.

Pass required commands to script:

1. First, set up repositories:

   ```
   $ ./do-unikraft-musl setup
   ```

   This results in creating the `unikraft-musl/` folder with the local conventional file hierarchy:

   ```
   $ tree -L 2 unikraft-musl/
   unikraft-musl/
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
   $ ./do-unikraft-musl build

   [...]
   Successfully built unikernels:

     => build/helloworld-x86_64
     => build/helloworld_kvm-x86_64.dbg (with symbols)

   To instantiate, use: kraft run
   ```

1. Run the hellworld Unikraft image:

   ```
   $ ./do-unikraft-musl run

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

## Binary Compatibility

Use the `do-unikraft-bincompat` to set up, build and run [`app-elfloader`](github.com/unikraft/app-elfloader) and other support repositories with Unikraft.
Run the script anywhere.
It will create a conventional local file hierarchy for building the Unikraft image.
Repositories will be moved to the corresponding branch.

Pass required commands to script:

1. First, set up repositories:

   ```
   $ ./do-unikraft-bincompat setup
   ```

   This results in creating the `unikraft-bincompat/` folder with the file hierarchy:

   ```
   $ tree -L 2 unikraft-bincompat/
   unikraft-bincompat/
   |-- apps
   |   |-- app-elfloader
   |   |-- run-app-elfloader
   |   `-- static-pie-apps
   |-- libs
   |   |-- libelf
   |   |-- lwip
   |   `-- zydis
   `-- unikraft
       |-- arch
       |-- CODING_STYLE.md
       |-- Config.uk
       |-- CONTRIBUTING.md
       |-- COPYING.md
       |-- doc
       |-- include
       |-- lib
       |-- Makefile
       |-- Makefile.uk
       |-- plat
       |-- README.md
       |-- support
       `-- version.mk
   ```

1. Run the `helloworld` static PIE in Unikraft using the prebuilt `app-elfloader` Unikraft image:

   ```
   $ ./do-unikraft-bincompat run
   Powered by
   o.   .o       _ _               __ _
   Oo   Oo  ___ (_) | __ __  __ _ ' _) :_
   oO   oO ' _ `| | |/ /  _)' _` | |_|  _)
   oOo oOO| | | | |   (| | | (_) |  _) :_
    OoOoO ._, ._:_:_,\_._,  .__,_:_, \___)
               Mimas 0.7.0~1e17a9c8-custom
   Hello, World!
   ```

1. Build the `app-elfloader` Unikraft image:

   ```
   $ ./do-unikraft-bincompat build
     [...]
     LD      app-elfloader_kvm-x86_64.ld.o
     OBJCOPY app-elfloader_kvm-x86_64.o
     LD      app-elfloader_kvm-x86_64.dbg
     SCSTRIP app-elfloader_kvm-x86_64
     GZ      app-elfloader_kvm-x86_64.gz
   ```

1. Run the `helloworld` static PIE in Unikraft using the newly built `app-elfloader` Unikraft image:

   ```
   $ ./do-unikraft-bincompat run_build
   Powered by
   o.   .o       _ _               __ _
   Oo   Oo  ___ (_) | __ __  __ _ ' _) :_
   oO   oO ' _ `| | |/ /  _)' _` | |_|  _)
   oOo oOO| | | | |   (| | | (_) |  _) :_
    OoOoO ._, ._:_:_,\_._,  .__,_:_, \___)
                       Mimas 0.7.0~bbb00c7
   Hello, World!
   ```

1. Clean the built image:

   ```
   $ ./do-unikraft-bincompat clean
     [...]
     RM      build/
     RM      config
     [...]
   ```

1. Build the `app-elfloader` Unikraft debug image:

   ```
   $ ./do-unikraft-bincompat build_debug
     [...]

     LD      app-elfloader_kvm-x86_64.ld.o
     OBJCOPY app-elfloader_kvm-x86_64.o
     LD      app-elfloader_kvm-x86_64.dbg
     SCSTRIP app-elfloader_kvm-x86_64
     GZ      app-elfloader_kvm-x86_64.gz
     LN      app-elfloader_kvm-x86_64.dbg.gdb.py
     [...]
   ```

1. Run the `helloworld` static PIE in Unikraft using the newly built `app-elfloader` Unikraft debug image:

   ```
   $ ./do-unikraft-bincompat run_build_debug
   [...]
   [    0.410842] dbg:  [libvfscore] <main.c @  703> (ssize_t) uk_syscall_r_writev((int) 0x1, (const struct iovec *) 0x3ff8f8d8, (int) 0x1)
   Hello, World!
   [    0.413533] dbg:  [libsyscall_shim] <uk_syscall_binary.c @   76> Binary system call request "exit_group" (231) at ip:0x3fe51156 (arg0=0x0, arg1=0x3c, ...)
   [...]
   ```
