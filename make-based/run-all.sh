#!/bin/bash

testing_dir="$(pwd)"
logging_dir="$testing_dir/logs"
log_file="$logging_dir/run.log"
tmp_file="$logging_dir/tmp.log"

test_common_errors()
{
    grep "Did you run 'do.sh setup'" < "$tmp_file" > /dev/null 2>&1
    if test $? -eq 0; then
        echo "could not find application. Did you run ./build-all.sh?"
        cat "$tmp_file" > "$log_file.$app"
        rm -f "$tmp_file"
        return 1
    fi

    grep "No such file or directory" < "$tmp_file" > /dev/null 2>&1
    if test $? -eq 0; then
        echo "could not find kernel image. Did you built the application?"
        cat "$tmp_file" > "$log_file.$app"
        rm -f "$tmp_file"
        return 1
    fi

    grep "CRIT" < "$tmp_file" > /dev/null 2>&1
    if test $? -eq 0; then
        echo "FAILED with CRIT errors. Find the log in $log_file.$app"
        cat "$tmp_file" > "$log_file.$app"
        rm -f "$tmp_file"
        return 1
    fi

}

test_booting()
{
    echo -n "Running $app... "

    /bin/bash "do.sh" run > "$tmp_file" 2>&1 &

    sleep 5
    sudo kill -KILL $(pgrep -f "qemu-system.*$app") > /dev/null 2>&1

    test_common_errors
    if test $? -eq 1; then
        return
    fi

    grep "Powered by" < "$tmp_file" > /dev/null 2>&1
    if test $? -ne 0; then
        echo "FAILED to boot. Find the log in $log_file.$app"
        cat "$tmp_file" > "$log_file.$app"
        rm -f "$tmp_file"
        return
    fi

    echo "PASSED"

    rm -f "$tmp_file"
}

test_elfloader()
{
    echo -n "Running $app... "

    # The elfloader should be tested separately from the automated tested
    # applications, since you need to run multiple apps with it.
    # Maybe we can find a way to automate testing the alfloader too, by
    # running some applications and checking the output.
    echo -n "SKIPPED"
    echo "  Test the app-elfloader using the 'make-based/app-elfloader/do.sh' script"
}

test_python3()
{
    echo -n "Running $app... "

    # HACK: Clearly not the best way to do this.
    # Find a way to capture the output of an application when ran using the
    # `./do.sh` files.
    (sleep 4; echo 'print("Hello World")') | /bin/bash "do.sh" run > "$tmp_file" 2>&1 &
    sleep 10

    test_common_errors
    if test $? -eq 1; then
        return
    fi

    sudo kill -KILL $(pgrep -f "qemu-system.*$app") > /dev/null 2>&1

    grep -E "^Hello World" < "$tmp_file" > /dev/null 2>&1 && echo "PASSED" || echo "FAILED"
    rm -f "$tmp_file"
}

test_nginx()
{
    echo -n "Running $app... "

    /bin/bash "do.sh" run < /dev/null > "$tmp_file" 2>&1 &
    sleep 2

    test_common_errors
    if test $? -eq 1; then
        return
    fi

    wget 172.44.0.2 > /dev/null 2>&1 && echo "PASSED" || echo "FAILED"
    rm -f index.html 2> /dev/null
    rm -f "$tmp_file"
}

test_httpreply()
{
    echo -n "Running $app... "

    /bin/bash "do.sh" run < /dev/null > "$tmp_file" 2>&1 &
    sleep 2

    test_common_errors
    if test $? -eq 1; then
        return
    fi

    curl -s 172.44.0.2:8123 | grep "It works!" > /dev/null 2>&1 && echo "PASSED" || echo "FAILED"
    rm -f "$tmp_file"
}

test_redis()
{
    echo -n "Running $app... "

    /bin/bash "do.sh" run < /dev/null > "$tmp_file" 2>&1 &
    sleep 2

    test_common_errors
    if test $? -eq 1; then
        return
    fi

    pushd "$testing_dir" > /dev/null || exit 1
    echo "PING" | timeout 10 ../utils/redis-cli -h 172.44.0.2 -p 6379 | grep "PONG" > /dev/null 2>&1 && echo "PASSED" || echo "FAILED"
    popd > /dev/null || exit 1
    rm -f "$tmp_file"
}

test_sqlite()
{
    # HACK: Clearly not the best way to do this.
    # Find a way to capture the output of an application when ran using the
    # `./do.sh` files.
    (sleep 4; echo -e '.open chinook.db\nselect * from Album;\n.read script.sql\nselect * from tab;\n.exit') | /bin/bash "do.sh" run > "$tmp_file" 2>&1 &

    sleep 10
    sudo kill -KILL $(pgrep -f "qemu-system.*$app") > /dev/null 2>&1

    test_common_errors
    if test $? -eq 1; then
        return
    fi

    echo -n "Running $app .open test ... "
    grep -E "^346\|Mozart: Chamber Music\|274" < "$tmp_file" > /dev/null 2>&1 && echo "PASSED" || echo "FAILED"

    echo -n "Running $app .read test ... "
    grep -E "^123456|abcdef" < "$tmp_file" > /dev/null 2>&1 && echo "PASSED" || echo "FAILED"

    rm -f "$tmp_file"
}

test_micropython()
{
    echo -n "Running $app... "

    # HACK: Clearly not the best way to do this.
    # Find a way to capture the output of an application when ran using the
    # `./do.sh` files.
    (sleep 4; echo 'print("Hello World")') | /bin/bash "do.sh" run > "$tmp_file" 2>&1 &
    sleep 10

    test_common_errors
    if test $? -eq 1; then
        return
    fi

    sudo kill -KILL $(pgrep -f "qemu-system.*$app") > /dev/null 2>&1

    grep -E "^Hello World" < "$tmp_file" > /dev/null 2>&1 && echo "PASSED" || echo "FAILED"
    rm -f "$tmp_file"
}


test_automated()
{
    mkdir "$logging_dir" 2> /dev/null
    while read -r script; do
        app=$(echo "$script" | cut -d'-' -f2-)
        pushd "$script" > /dev/null || exit 1

        if test "$(type -t "test_$app")" = "function"; then
            ( test_"$app" )
        else
            ( test_booting )
        fi
        sudo kill -KILL $(pgrep -f "qemu-system.*$app") > /dev/null 2>&1

        popd > /dev/null || exit 1
    done < <(find . -mindepth 1 -maxdepth 1 -type d -name "app*")
}

test_automated
