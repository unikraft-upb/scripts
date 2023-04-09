#!/bin/bash

app_basename="elfloader"
app_libs="lwip zydis libelf"
use_networking=1
use_9p_rootfs=1
rootfs_9p="fs0"
use_kvm=1

# https://stackoverflow.com/a/246128/4804196
SOURCE=${BASH_SOURCE[0]}
while [ -L "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
    DIR=$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )
    SOURCE=$(readlink "$SOURCE")
    [[ $SOURCE != /* ]] && SOURCE=$DIR/$SOURCE # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
SCRIPT_DIR=$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )

source "$SCRIPT_DIR"/../include/base

app="$top"/apps/app-"$app_basename"

source "$SCRIPT_DIR"/../include/common_functions

setup_elfloader()
{
    git remote rm csvancea > /dev/null 2>&1
    git remote add csvancea https://github.com/csvancea/app-elfloader/
    git fetch csvancea
    git checkout staging
    git branch -D csvancea/fix/argv-parser > /dev/null 2>&1
    git branch -D csvancea/fix/unaligned-stack > /dev/null 2>&1
    git branch csvancea/fix/argv-parser csvancea/csvancea/fix/argv-parser
    git branch csvancea/fix/unaligned-stack csvancea/csvancea/fix/unaligned-stack
    git branch -D setup > /dev/null 2>&1
    git checkout -b setup
    git rebase csvancea/fix/argv-parser
    git rebase csvancea/fix/unaligned-stack

    if test ! -d ../run-app-elfloader; then
        git clone https://github.com/unikraft/run-app-elfloader ../run-app-elfloader
    fi

    if test ! -d ../static-pie-apps; then
        git clone https://github.com/unikraft/static-pie-apps ../static-pie-apps
    fi
}

setup_app()
{
    if ! test -d "$app"; then
        git clone https://github.com/unikraft/app-"$app_basename" "$app"
    fi

    pushd "$app" > /dev/null
    git reset --hard HEAD
    if test "$(type -t setup_"$app_basename")" = "function"; then
        setup_"$app_basename"
    fi
    popd > /dev/null

    # Copy configuration and build files to app folder.
    cp "$SCRIPT_DIR"/../app-"$app_basename"/files/Makefile{,.uk} "$app"
    cp "$SCRIPT_DIR"/../app-"$app_basename"/files/.config "$app"

    if test ! -z "$app_libs"; then
        for l in $app_libs; do
            install_lib "$l"
        done
    fi
}

setup_app_debug()
{
    if ! test -d "$app"; then
        git clone https://github.com/unikraft/app-"$app_basename" "$app"
    fi

    pushd "$app" > /dev/null
    git reset --hard HEAD
    if test "$(type -t setup_"$app_basename")" = "function"; then
        setup_"$app_basename"
    fi
    popd > /dev/null

    # Copy configuration and build files to app folder.
    cp "$SCRIPT_DIR"/../app-"$app_basename"/files/Makefile{,.uk} "$app"
    cp "$SCRIPT_DIR"/../app-"$app_basename"/files/.config_debug "$app"/.config

    if test ! -z "$app_libs"; then
        for l in $app_libs; do
            install_lib "$l"
        done
    fi
}

kvm_image=build/app-"$app_basename"_kvm-x86_64

run()
{
    if test ! -d "$app"; then
        echo "$app folder doesn't exist. Did you run '$0 setup'?" 1>&2
        exit 1
    fi
    if test ! -d "$apps"/run-app-elfloader; then
        echo "run-app-elfloader folder doesn't exist. Did you run '$0 setup'?" 1>&2
        exit 1
    fi

    target_app="$1"

    cp "$SCRIPT_DIR"/../app-"$app_basename"/files/defaults "$apps"/run-app-elfloader/
    pushd "$apps"/run-app-elfloader > /dev/null
    eval ./run_app.sh "$target_app"
    popd > /dev/null
}

target_apps=("helloworld_static" "server_static" "helloworld_go_static" "server_go_static" "helloworld_cpp_static" "helloworld_rust_static_musl" "helloworld_rust_static_gnu" "nginx_static" "redis_static" "sqlite3" "bc_static" "gzip_static")
target_apps+=("helloworld" "server" "helloworld_go" "server_go" "helloworld_cpp" "helloworld_rust" "nginx" "redis" "sqlite3" "bc" "gzip")

usage()
{

    echo "Usage: $0 <command> [<app>]" 1>&2
    echo "  command: setup setup_debug configure build docker_build clean docker_clean run remove" 1>&2
    echo "  app (for run): ${target_apps[@]}" 1>&2
}

if test $# -gt 2 -o $# -eq 0; then
    usage
    exit 1
fi

command="$1"

case "$command" in

    "setup")
        setup_base
        setup_app
        ;;

    "setup_debug")
        setup_base
        setup_app_debug
        ;;

    "configure")
        configure
        ;;

    "build")
        build
        ;;

    "docker_build")
        docker_build
        ;;

    "clean")
        clean
        ;;

    "docker_clean")
        docker_clean
        ;;

    "run")
        if test $# -ne 2; then
            echo "'run' command requires target application as argument" 1>&2
            echo "Target applications: ${target_apps[@]}" 1>&2
            exit 1
        fi
        run "$2"
        ;;

    "remove")
        remove
        ;;

    *)
        echo "Unknown command: $command"
        usage
        exit 1
esac
