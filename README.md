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
