#!/bin/bash

# https://stackoverflow.com/a/246128/4804196
SOURCE=${BASH_SOURCE[0]}
while [ -L "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
    DIR=$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )
    SOURCE=$(readlink "$SOURCE")
    [[ $SOURCE != /* ]] && SOURCE=$DIR/$SOURCE # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
SCRIPT_DIR=$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )

top=$(pwd)/../workdir
libs=$(pwd)/../workdir/libs
uk=$(pwd)/../workdir/unikraft

arch=

source "$SCRIPT_DIR"/../include/common_functions

if test $# -lt 2 || ! { test "$1" = "x86_64" || test "$1" = "arm64"; }; then
    echo -e "Usage: $0 <x86_64 | arm64> <PR-number | branch> [deps]\n" 1>&2
    echo "The dependencies are PRs from the unikraft core or external libraries repositories." 1>&2
    echo -e "\ne.g. $0 123 musl/10 unikraft/20 lwip/15" 1>&2
    echo "will pull PRs 123 and 20 from the unikraft core, PR 10 from lib-musl and PR 20 form lwip."
    echo -e "\n$0 staging musl/10 unikraft/20 lwip/15" 1>&2
    echo "will pull PR 20 from the unikraft core, PR 10 from lib-musl and PR 20 form lwip."
    exit 1
fi

test "$1" = "arm64" && arch="_arm64"
shift 1

log_file=$(pwd)/logs/err.log
PR_number="$1"

unset UK_ROOT UK_WORKDIR UK_LIBS
mkdir "$(pwd)/logs" 2> /dev/null

setup

pushd "$uk" > /dev/null || exit 1

git checkout staging
git branch -D setup 2> /dev/null
if [[ "$1" =~ ^[0-9]+$ ]]; then
    git fetch origin "pull/$PR_number/head":setup || exit 1
    git checkout setup
    git rebase staging || exit 1
else
    git fetch origin "$1":setup || exit 1
    git checkout setup
fi

popd > /dev/null || exit 1

shift 1
for dep in "$@"; do
    lib=$(echo "$dep" | cut -d'/' -f1)
    pr=$(echo "$dep" | cut -d'/' -f2)

    if test "$lib" = "unikraft"; then
        pushd "$uk" > /dev/null || exit 1
    else
        pushd "$libs/$lib" > /dev/null || exit 1
    fi

    # PRs that are given in the list will be stashed on top of each other
    # beware of eventual conflicts that may appear
    git checkout setup > /dev/null 2>&1 || git checkout -b setup > /dev/null 2>&1
    git fetch origin "pull/$pr/head":"pr-$pr"
    git rebase "pr-$pr" || exit 1

    popd > /dev/null || exit 1
done

while read -r script; do
    pushd "$script" > /dev/null || exit 1

    app=$(echo "$script" | cut -d'-' -f2-)

    # FIXME: Change this after the PRs needed for binray compatibility
    # are all merged
    # Skip the elfloader since the custom setup will mess up our setup.
    if [[ "$app" = "elfloader" ]]; then
        popd > /dev/null || exit 1
        continue
    fi

    if test "$arch" != "_arm64"; then
        echo -n "Building $app using 'clang'... "
        /bin/bash "do.sh" clean > /dev/null 2>&1
        /bin/bash "do.sh" setup"$arch" > /dev/null 2>&1
        yes "" | /bin/bash "do.sh" build_clang 1> /dev/null 2> "$log_file.$app.clang" && echo "PASSED" || echo "FAILED"
    fi

    echo -n "Building $app using 'gcc'... "
    /bin/bash "do.sh" clean > /dev/null 2>&1
    /bin/bash "do.sh" setup"$arch" > /dev/null 2>&1
    yes "" | /bin/bash "do.sh" build"$arch" 1> /dev/null 2> "$log_file.$app.gcc" && echo "PASSED" || echo "FAILED"

    popd > /dev/null || exit 1
done <<< "$(find . -type d -name "app*")"
