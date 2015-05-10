#!/usr/bin/env bash
# basht macro, shellcheck fix
export T_fail

. lib/time_formatting

with_fake_date() {
  DATE="$1" "${@:2}"
}

T_gnu_date?_WhenDateUtilityIsGNU() {
  with_fake_date "echo 'GNU coreutils'" gnu_date? || \
    $T_fail "Expected date to be identified as GNU"
}

T_gnu_date?_WhenDateUtilityIsNotGNU() {
  ! with_fake_date "echo 'non-GNU date'" gnu_date? || \
    $T_fail "Expected date to be identified as non-GNU"
}
