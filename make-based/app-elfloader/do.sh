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
    git reset --hard HEAD
    git checkout staging > /dev/null 2>&1

    git remote rm csvancea > /dev/null 2>&1
    git remote add csvancea https://github.com/csvancea/app-elfloader/
    git fetch csvancea
    git checkout staging
    git branch -D csvancea/fix/argv-parser > /dev/null 2>&1
    git branch -D csvancea/fix/unaligned-stack > /dev/null 2>&1
    git branch csvancea/fix/argv-parser csvancea/csvancea/fix/argv-parser
    git branch csvancea/fix/unaligned-stack csvancea/csvancea/fix/unaligned-stack

    git branch -D setup > /dev/null 2>&1
    git checkout -b setup staging
    git rebase csvancea/fix/argv-parser
    git rebase csvancea/fix/unaligned-stack

    if test ! -d ../run-app-elfloader; then
        git clone https://github.com/unikraft/run-app-elfloader ../run-app-elfloader
    fi

    if test ! -d ../static-pie-apps; then
        git clone https://github.com/unikraft/static-pie-apps ../static-pie-apps
    fi
    if test ! -d ../dynamic-apps; then
        git clone https://github.com/unikraft/dynamic-apps ../dynamic-apps
    fi
}

setup_unikraft()
{
    git reset --hard HEAD
    git checkout staging > /dev/null 2>&1

    git remote rm csvancea > /dev/null 2>&1
    git remote add csvancea https://github.com/csvancea/unikraft
    git fetch csvancea
    git branch -D csvancea/fix/stat-mode-type > /dev/null 2>&1
    git branch csvancea/fix/stat-mode-type csvancea/csvancea/fix/stat-mode-type
    git branch -D csvancea/feature/allow-non-writable-shared-file-mappings > /dev/null 2>&1
    git branch csvancea/feature/allow-non-writable-shared-file-mappings csvancea/csvancea/feature/allow-non-writable-shared-file-mappings

    git remote rm andraprs > /dev/null 2>&1
    git remote add andraprs https://github.com/andraprs/unikraft
    git fetch andraprs
    git branch -D 9pfs-symlink-fix > /dev/null 2>&1
    git branch 9pfs-symlink-fix andraprs/9pfs-symlink-fix

    git remote rm marcrittinghaus > /dev/null 2>&1
    git remote add marcrittinghaus https://github.com/marcrittinghaus/unikraft
    git fetch marcrittinghaus
    git branch -D mritting/pr_appcompat_fixes > /dev/null 2>&1
    git branch mritting/pr_appcompat_fixes marcrittinghaus/mritting/pr_appcompat_fixes
    git branch -D mritting/pr_prsyscall_struct > /dev/null 2>&1
    git branch mritting/pr_prsyscall_struct marcrittinghaus/mritting/pr_prsyscall_struct
    git branch -D mritting/pr_fix_accept_nonblock > /dev/null 2>&1
    git branch mritting/pr_fix_accept_nonblock marcrittinghaus/mritting/pr_fix_accept_nonblock
    git branch -D mritting/pr_fix_devfs > /dev/null 2>&1
    git branch mritting/pr_fix_devfs marcrittinghaus/mritting/pr_fix_devfs

    git remote rm unikraft-upb > /dev/null 2>&1
    git remote add unikraft-upb https://github.com/unikraft-upb/unikraft
    git fetch unikraft-upb
    git branch -D StefanJum/fix-symlink-error > /dev/null 2>&1
    git branch StefanJum/fix-symlink-error unikraft-upb/StefanJum/fix-symlink-error

    git remote rm John-Ted > /dev/null 2>&1
    git remote add John-Ted https://github.com/John-Ted/unikraft
    git fetch John-Ted
    git branch -D remove_clone3 > /dev/null 2>&1
    git branch remove_clone3 John-Ted/remove_clone3

    git branch -D setup > /dev/null 2>&1
    git checkout -b setup staging
    git rebase 9pfs-symlink-fix
    git rebase csvancea/fix/stat-mode-type
    git rebase csvancea/feature/allow-non-writable-shared-file-mappings
    git rebase mritting/pr_appcompat_fixes
    git rebase mritting/pr_prsyscall_struct
    git rebase StefanJum/fix-symlink-error
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

setup_app_plain()
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
    cp "$SCRIPT_DIR"/../app-"$app_basename"/files/.config_plain "$app"/.config

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
    git reset --hard HEAD
    git checkout master
    eval ./run_app.sh "$target_app"
    popd > /dev/null
}

run_built()
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
    echo "  command: setup setup_debug setup_plain configure build docker_build clean docker_clean run run_built remove" 1>&2
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

    "setup_plain")
        setup_base
        setup_app_plain
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

    "run_built")
        if test $# -ne 2; then
            echo "'run_built' command requires target application as argument" 1>&2
            echo "Target applications: ${target_apps[@]}" 1>&2
            exit 1
        fi
        run_built "$2"
        ;;

    "remove")
        remove
        ;;

    *)
        echo "Unknown command: $command"
        usage
        exit 1
esac
