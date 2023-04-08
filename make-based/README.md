# Building with Make

These are scripts for setting up and building applications with the primal Make-based system for Unikraft.
QEMU is used for running the resulting Unikraft images.
They do not use [`pykraft`](https://github.com/unikraft/pykraft) or [`kraftkit`](https://github.com/unikraft/kraftkit).

Each application is using a specific directory.
Inside each directory you find:

* the `do.sh` wrapper script to set up, build and run Unikraft applications
* the `files/` directory consisting of configuration and build files required by `do.sh`;
  typically, this means the `.config` file (with the appropriate configuration) - used for configuration - and the `Makefile` and `Makefile.uk` files - used for building.

The `do.sh` wrapper script includes common-part scripts in the `include/` directory.

Applications, libraries and the Unikraft core are set up and built in the `../workdir/` directory.

## Setup, Build, Run

A common set of steps is highlighted below for `app-helloworld` (in the `app-helloworld/` directory).
Similar steps are required for other applications.
Do these steps for a quick run of the application:

```console
.../scripts/make-based/app-helloworld$ ./do.sh setup

.../scripts/make-based/app-helloworld$ ./do.sh build

.../scripts/make-based/app-helloworld$ ./do.sh run
qemu-system-x86_64: warning: TCG doesn't support requested feature: CPUID.01H:ECX.vmx [bit 5]
Powered by
o.   .o       _ _               __ _
Oo   Oo  ___ (_) | __ __  __ _ ' _) :_
oO   oO ' _ `| | |/ /  _)' _` | |_|  _)
oOo oOO| | | | |   (| | | (_) |  _) :_
 OoOoO ._, ._:_:_,\_._,  .__,_:_, \___)
             Epimetheus 0.12.0~fd188c0e
Hello world!
Arguments:  "build/helloworld_kvm-x86_64"
```

See below detailed explanations:

### Usage

Running `./do.sh` without arguments prints the possible commands:

```console
.../scripts/make-based/app-helloworld$ ./do.sh
Usage: ./do.sh <command>
  command: setup configure build docker_build clean docker_clean run run_debug remove
```

### Setting Up

You set up the application by passing the `setup` argument to `./do.sh`:

```console
.../scripts/make-based/app-helloworld$ ./do.sh setup
Cloning into '../../workdir/apps/app-helloworld'...
remote: Enumerating objects: 96, done.
remote: Counting objects: 100% (96/96), done.
remote: Compressing objects: 100% (50/50), done.
remote: Total 96 (delta 44), reused 89 (delta 44), pack-reused 0
Unpacking objects: 100% (96/96), done.
HEAD is now at 34077d4 Fix dependency for nanosleep()
```

This sets up the repository, integrates possible patches and pull requests and copies the required files (`.config`, `Makefile`, `Makefile.uk` etc.).

### Building

You build the application by passing the `build` argument to `./do.sh`:

```console
.../scripts/make-based/app-helloworld$ ./do.sh build
  [...]
  LD      helloworld_kvm-x86_64.o
  LD      helloworld_kvm-x86_64.dbg
  UKBI    helloworld_kvm-x86_64.dbg.bootinfo
  SCSTRIP helloworld_kvm-x86_64
  GZ      helloworld_kvm-x86_64.gz
```

This results in the creation of the `helloworld_kvm-x86_64` image.

### Running

You run the application by passing the `run` argument to `./do.sh`:

```console
.../scripts/make-based/app-helloworld$ ./do.sh run
qemu-system-x86_64: warning: TCG doesn't support requested feature: CPUID.01H:ECX.vmx [bit 5]
Powered by
o.   .o       _ _               __ _
Oo   Oo  ___ (_) | __ __  __ _ ' _) :_
oO   oO ' _ `| | |/ /  _)' _` | |_|  _)
oOo oOO| | | | |   (| | | (_) |  _) :_
 OoOoO ._, ._:_:_,\_._,  .__,_:_, \___)
             Epimetheus 0.12.0~fd188c0e
Hello world!
Arguments:  "build/helloworld_kvm-x86_64"
```

Behind the scenes, this invokes QEMU and passes it the image created above.
The warning above is to be ignored;
it's caused by running QEMU without enabling KVM (virtualization).

## Further Configuration

You can edit the `do.sh` and modify its variables for specialized builds.
For example, in the [`do.sh` script for `app-helloworld`](https://github.com/unikraft-upb/scripts/blob/main/make-based/app-helloworld/do.sh) you can update the `use_kvm` variable to `1` to use KVM (virtualization).
