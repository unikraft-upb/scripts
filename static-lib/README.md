# Using Unikraft as a Static Library

These are scripts for building applications with Unikraft built as a static library.
These scripts rely on the [default Unikraft build system](https://unikraft.org/docs/usage/advanced/) to create the required object files.
It then packs the object files into static libraries and links the application object file(s) to the static library.
Linking uses the linker scripts and commands adapted from the default build system.

The top-level scripts (with the `do-` prefix) are the wrapper scripts to setup, build and run Unikraft applications.
They include common-part scripts in the `../include/` directory.

Applications, libraries and Unikraft are set up and built in the `../workdir/` directory.

## app-helloworld-linuxu

Use the `do-helloworld-linuxu` script to build and run [`app-helloworld`](https://github.com/unikraft/app-helloworld) with Unikraft as a static library for the [`linuxu` platform](https://github.com/unikraft/unikraft/tree/staging/plat/linuxu).

Pass required commands to script:

1. First, set up repositories:

   ```
   $ ./do-helloworld-linuxu setup
   ```

   This results in creating the `../workdir/` folder (if not already created) with the local conventional file hierarchy:

   ```
   $ tree -L 2 ../workdir/
   workdir/
   |-- apps
   |   `-- app-helloworld
   |-- archs
   |-- libs
   |-- plats
   `-- unikraft
   [...]
   ```

   The `app-helloworld` repository is checked out to the required branch (`static-lib`).

1. Clean the previous environment, to ensure you have a fresh setup:

   ```
   $ ./do-helloworld-linuxu clean
   RM      build/
   RM      config
   rm -f libukstatic_linuxu.a
   rm -f helloworld_static_linuxu
   HEAD is now at a40ae59 Build as static library for kvm
   ```

1. Build the hellworld Unikraft image:

   ```
   $ ./do-helloworld-linuxu build
   LD      helloworld_linuxu-x86_64.dbg
   SCSTRIP helloworld_linuxu-x86_64

   Successfully built unikernels:

     => build/helloworld_linuxu-x86_64
     => build/helloworld_linuxu-x86_64.dbg (with symbols)

   To instantiate, use: kraft run

   ar rc libukstatic_linuxu.a $(find build/ -mindepth 1 -maxdepth 1 -type f -regex '.*/lib[^\.]+.o$')
   gcc -L. -nostdinc -nostdlib \
           -no-pie \
   ```

1. Run the hellworld Unikraft image:

   ```
   $ ./do-helloworld-linuxu run
   Powered by
   o.   .o       _ _               __ _
   Oo   Oo  ___ (_) | __ __  __ _ ' _) :_
   oO   oO ' _ `| | |/ /  _)' _` | |_|  _)
   oOo oOO| | | | |   (| | | (_) |  _) :_
    OoOoO ._, ._:_:_,\_._,  .__,_:_, \___)
             Phoebe 0.10.0~b01e0937-custom
   Hello world!
   Arguments:  "./helloworld_static_linuxu"
   ```

   The image prints the `Hello, world!` message.

## app-helloworld-kvm

Use the `do-helloworld-kvm` script to build and run [`app-helloworld`](https://github.com/unikraft/app-helloworld) with Unikraft as a static library for the [`kvm` platform](https://github.com/unikraft/unikraft/tree/staging/plat/kvm).

Pass required commands to script:

1. First, set up repositories:

   ```
   $ ./do-helloworld-kvm setup
   ```

   This results in creating the `../workdir/` folder (if not already created) with the local conventional file hierarchy:

   ```
   $ tree -L 2 ../workdir/
   workdir/
   |-- apps
   |   `-- app-helloworld
   |-- archs
   |-- libs
   |-- plats
   `-- unikraft
   [...]
   ```

   The `app-helloworld` repository is checked out to the required branch (`static-lib`).

1. Clean the previous environment, to ensure you have a fresh setup:

   ```
   $ ./do-helloworld-kvm clean
   RM      build/
   RM      config
   rm -f libukstatic_kvm.a
   rm -f helloworld_static_kvm helloworld_static_kvm.o helloworld_static_kvm.ld.o
   HEAD is now at a40ae59 Build as static library for kvm
   ```

1. Build the hellworld Unikraft image:

   ```
   $ ./do-helloworld-kvm build
   SCSTRIP helloworld_kvm-x86_64
   GZ      helloworld_kvm-x86_64.gz

   Successfully built unikernels:

     => build/helloworld_kvm-x86_64
     => build/helloworld_kvm-x86_64.dbg (with symbols)

   To instantiate, use: kraft run

   ar rc libukstatic_kvm.a $(find build/ -mindepth 1 -maxdepth 1 -type f -regex '.*/lib[^\.]+.o$')
   gcc -L. -nostdinc -nostdlib \
           -no-pie \
   ```

1. Run the hellworld Unikraft image:

   ```
   $ ./do-helloworld-kvm run
   Powered by
   o.   .o       _ _               __ _
   Oo   Oo  ___ (_) | __ __  __ _ ' _) :_
   oO   oO ' _ `| | |/ /  _)' _` | |_|  _)
   oOo oOO| | | | |   (| | | (_) |  _) :_
    OoOoO ._, ._:_:_,\_._,  .__,_:_, \___)
             Phoebe 0.10.0~b01e0937-custom
   Hello world!
   Arguments:  "helloworld_static_kvm"
   ```

   The image prints the `Hello, world!` message.
