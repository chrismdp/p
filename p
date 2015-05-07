#!/usr/bin/env bash

set -e

LOG=$HOME/.p.log
DATE_FORMAT="%Y-%m-%d %T %z"
POMODORO_LENGTH_IN_SECONDS=610
POMODORO_BREAK_IN_SECONDS=300
PREFIX="🍅 "
TMPFILE=/tmp/p-${RANDOM}
INTERNAL_INTERRUPTION_MARKER="'"
EXTERNAL_INTERRUPTION_MARKER="-"

function deleteLastLine
{
  if [ -s "$LOG" ]; then
    sed '$ d' "$LOG" > $TMPFILE
    mv $TMPFILE "$LOG"
  fi
}

function checkLastPomodoro
{
  if [ -s "$LOG" ]; then
    RECENT=$(tail -1 ${LOG})
    TIME=$(echo $RECENT | cut -d ',' -f 1)
    THING=$(echo $RECENT | cut -d ',' -f 3-)
    INTERRUPTIONS=$(echo $RECENT | cut -d ',' -f 2)

    TIMESTAMP_RECENT=$(date -j -f "$DATE_FORMAT" "$TIME" "+%s")
    TIMESTAMP_NOW=$(date "+%s")
    SECONDS_ELAPSED=$((TIMESTAMP_NOW - TIMESTAMP_RECENT))
    if (( $SECONDS_ELAPSED >= $POMODORO_LENGTH_IN_SECONDS )); then
      POMODORO_FINISHED=1
    fi
  else
    NO_RECORDS=1
  fi
}

function cancelRunningPomodoro
{
  checkLastPomodoro
  if [ -z $POMODORO_FINISHED ]; then
    deleteLastLine
  fi
}

function interrupt
{
  type=$1
  checkLastPomodoro
  if [ -z $POMODORO_FINISHED ]; then
    deleteLastLine
    echo $TIME,$INTERRUPTIONS$type,$THING >> "$LOG"
  else
    echo "No pomodoro to interrupt"
    exit 1
  fi
}

case "$1" in
  start)
    cancelRunningPomodoro
    NOW=$(date +"$DATE_FORMAT")
    echo $NOW,,${*:2} >> "$LOG"
    ;;
  cancel)
    cancelRunningPomodoro
    echo "Cancelled. Don't worry: the next Pomodoro will go better!"
    ;;
  i)
    interrupt $INTERNAL_INTERRUPTION_MARKER
    ;;
  e)
    interrupt $EXTERNAL_INTERRUPTION_MARKER
    ;;
  wait)
    checkLastPomodoro
    if [ -z $POMODORO_FINISHED ]; then
      while [ -z $POMODORO_FINISHED ]; do
        MIN=$((SECONDS_ELAPSED / 60))
        SEC=$((SECONDS_ELAPSED % 60))
        if [ ! -z "$THING" ]; then
          ON_THING=" on \"$THING\""
        fi
        printf "\r$PREFIX ${MIN}m ${SEC}s$ON_THING "
        sleep 1
        checkLastPomodoro
      done
      echo " completed. Well done!"
    fi
    ;;
  *)
    checkLastPomodoro
    if [ -z $NO_RECORDS ]; then
      if [ ! -z $POMODORO_FINISHED ]; then
        BREAK=$((SECONDS_ELAPSED - POMODORO_LENGTH_IN_SECONDS))
        if (( $BREAK < $POMODORO_BREAK_IN_SECONDS )); then
          MIN=$((BREAK / 60))
          SEC=$((BREAK % 60))
          BREAKTIME=". Break ${MIN}m ${SEC}s."
        fi
        echo "$PREFIX Done$BREAKTIME"
      else
        MIN=$((SECONDS_ELAPSED / 60))
        SEC=$((SECONDS_ELAPSED % 60))
        if [ ! -z "$THING" ]; then
          ON_THING=" on \"$THING\""
        fi
        echo "$PREFIX ${MIN}m ${SEC}s$ON_THING"
      fi
    fi
    ;;
esac
