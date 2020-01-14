#!/usr/bin/env bats

source "$BATS_LIBS/bats-support/load.bash"
source "$BATS_LIBS/bats-assert/load.bash"

function assert_in_file() {
    grep -q $2 $1
    assert [ $? -eq 0 ]
}

@test "Should process simple template" {
    export DB_USER=test
    export DB_PASS=mySuperSecret

    run ./process-template -f test/resources/test_simple.tpl -t $BATS_TMPDIR/result.txt
    assert_success

    assert_in_file $BATS_TMPDIR/result.txt "db.user=test"
    assert_in_file $BATS_TMPDIR/result.txt "db.pass=mySuperSecret"
}

@test "Should process file in place" {
    cp test/resources/test_simple.tpl $BATS_TMPDIR/result.txt

    export DB_USER=test
    export DB_PASS=mySuperSecret

    run ./process-template -t $BATS_TMPDIR/result.txt
    assert_success

    assert_in_file $BATS_TMPDIR/result.txt "db.user=test"
    assert_in_file $BATS_TMPDIR/result.txt "db.pass=mySuperSecret"
}

@test "Should process multiple placeholder occurences" {
    export DB_USER=test
    export DB_PASS=mySuperSecret

    run ./process-template -f test/resources/test_multiple.tpl -t $BATS_TMPDIR/result.txt
    assert_success

    assert_in_file $BATS_TMPDIR/result.txt "db.user=test,test,test"
}

@test "Should process placeholder with colliding name" {
    export DB=db
    export DB_USER=test

    run ./process-template -f test/resources/test_name_colide.tpl -t $BATS_TMPDIR/result.txt
    assert_success

    assert_in_file $BATS_TMPDIR/result.txt "db=db"
    assert_in_file $BATS_TMPDIR/result.txt "user=test"
}

@test "Should fail if strict and placeholder still exists" {
    # no env set

    run ./process-template -s -f test/resources/test_strict.tpl -t $BATS_TMPDIR/result.txt
    assert_failure
    assert [ $status -eq 4 ]
}

@test "Strict should not apply if placeholder prefix is empty" {
    # no env set

    run ./process-template -s -p "" -f test/resources/test_strict.tpl -t $BATS_TMPDIR/result.txt
    assert_success
}
