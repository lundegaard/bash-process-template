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

