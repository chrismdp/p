#!/usr/bin/env bash

set -ex

LOGFILE=p-test-log
OUTPUT=p-test-output

rm -f $LOGFILE

function teardown
{
  rm -f $LOGFILE $OUTPUT
}

function fail
{
  echo "FAIL: $0: $1"
  teardown
  exit 1
}

function run
{
  LOGFILE=$LOGFILE ./$1 > $OUTPUT 2>&1
}

function checkLog
{
  grep "$1" $LOGFILE >/dev/null || fail "Cannot find "$1" in log"
}

run 'p start'

diff -u $OUTPUT - <<!
Pomodoro started 
!

[ $? -eq 0 ] || fail

[ $(cat $LOGFILE | wc -l) -eq 1 ] || fail

run 'p start some stuff'
diff -u $OUTPUT - <<!
Last Pomodoro cancelled
Pomodoro started on "some stuff"
!

[ $? -eq 0 ] || fail
checkLog ",some stuff"

[ $(cat $LOGFILE | wc -l) -eq 1 ] || fail

run 'p i'
diff -u $OUTPUT - <<!
Interrupt recorded
!

[ $? -eq 0 ] || fail

checkLog ",',"

run 'p i'
diff -u $OUTPUT - <<!
Interrupt recorded
!

[ $? -eq 0 ] || fail

checkLog ",'',"

run 'p e'
diff -u $OUTPUT - <<!
Interrupt recorded
!

[ $? -eq 0 ] || fail

checkLog ",''-,"

run 'p log'

diff -u $OUTPUT $LOGFILE
[ $? -eq 0 ] || fail

teardown
