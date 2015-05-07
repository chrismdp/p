#!/usr/bin/env bash

set -e

LOG=$HOME/.p.log
DATE_FORMAT="%Y-%m-%d %T %z"
POMODORO_LENGTH_IN_SECONDS=1500
POMODORO_BREAK_IN_SECONDS=300
PREFIX="🍅 "
TMPFILE=/tmp/p-${RANDOM}
INTERNAL_INTERRUPTION_MARKER="'"
EXTERNAL_INTERRUPTION_MARKER="-"
DATE=date

function deleteLastLine
{
  if [ -s "$LOG" ]; then
    sed '$ d' "$LOG" > $TMPFILE
    mv $TMPFILE "$LOG"
  fi
}

function convertTimeFormat
{
  TIME_STRING="$1"
  OUPUT_FORMAT="$2"
  date --version | grep "GNU coreutils" > /dev/null
  if [ "$?" == "0" ]; then
    date -d "$TIME_STRING" "$OUPUT_FORMAT"
  else
    date -j -f "$DATE_FORMAT" "$TIME_STRING" "$OUPUT_FORMAT"
  fi
}

function checkLastPomodoro
{
  if [ -s "$LOG" ]; then
    RECENT=$(tail -1 ${LOG})
    TIME=$(echo $RECENT | cut -d ',' -f 1)
    THING=$(echo $RECENT | cut -d ',' -f 3-)
    INTERRUPTIONS=$(echo $RECENT | cut -d ',' -f 2)

    TIMESTAMP_RECENT=$(convertTimeFormat "$TIME" "+%s")
    TIMESTAMP_NOW=$($DATE "+%s")
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
    if [ -z $NO_RECORDS ]; then
      deleteLastLine
      echo $1
    fi
  fi
}

function interrupt
{
  type=$1
  checkLastPomodoro
  if [ -z $POMODORO_FINISHED ]; then
    deleteLastLine
    echo $TIME,$INTERRUPTIONS$type,$THING >> "$LOG"
    echo "Interrupt recorded"
  else
    echo "No pomodoro to interrupt"
    exit 1
  fi
}

function optionalDescription
{
  OPTIONAL_THING="$1"
  if [ ! -z "${OPTIONAL_THING}" ]; then
    ON_THING=" on \"${OPTIONAL_THING}\""
  fi
}


case "$1" in
  start | s)
    cancelRunningPomodoro "Last Pomodoro cancelled"
    NOW=$($DATE +"$DATE_FORMAT")
    echo $NOW,,${*:2} >> "$LOG"
    optionalDescription "${*:2}"
    echo "Pomodoro started$ON_THING"
    ;;
  cancel | c)
    cancelRunningPomodoro "Cancelled. The next Pomodoro will go better!"
    ;;
  internal | i)
    interrupt $INTERNAL_INTERRUPTION_MARKER
    ;;
  external | e)
    interrupt $EXTERNAL_INTERRUPTION_MARKER
    ;;
  wait | w)
    checkLastPomodoro
    if [ -z $POMODORO_FINISHED ]; then
      while [ -z $POMODORO_FINISHED ]; do
        MIN=$((SECONDS_ELAPSED / 60))
        SEC=$((SECONDS_ELAPSED % 60))
        optionalDescription "${THING}"
        printf "\r$PREFIX ${MIN}m ${SEC}s$ON_THING "
        sleep 1
        checkLastPomodoro
      done
      echo " completed. Well done!"
    fi
    ;;
  log | l)
    cat "$LOG"
    ;;
  help | h | -h)
    echo "usage: p [command]"
    echo
    echo "Available commands:"
    echo "   status (default)    Shows information about the current pomodoro"
    echo "   start [description] Starts a new pomodoro, cancelling any in progress"
    echo "   cancel              Cancels any pomodoro in progress"
    echo "   internal            Records an internal interruption on current pomodoro"
    echo "   external            Records an external interruption on current pomodoro"
    echo "   wait                Prints ticking counter and blocks until pomodoro completion"
    echo "   log                 Shows pomodoro log output in CSV format"
    echo "   help                Prints this help text"
    echo
    echo "Commands may be shortened to their first letter. For more information"
    echo "see http://github.com/chrismdp/p."
    echo
    ;;
  status | *)
    checkLastPomodoro
    if [ -z $NO_RECORDS ]; then
      if [ ! -z $POMODORO_FINISHED ]; then
        BREAK=$((SECONDS_ELAPSED - POMODORO_LENGTH_IN_SECONDS))
        if (( $BREAK < $POMODORO_BREAK_IN_SECONDS )); then
          MIN=$((BREAK / 60))
          SEC=$((BREAK % 60))
          optionalDescription "${THING}"
          echo "$PREFIX Completed ${MIN}m ${SEC}s ago$ON_THING"
        else
          LAST=$(convertTimeFormat "$TIME" "+%a, %d %b %Y %T")
          echo "Most recent pomodoro: $LAST"
        fi
      else
        MIN=$((SECONDS_ELAPSED / 60))
        SEC=$((SECONDS_ELAPSED % 60))
        optionalDescription "${THING}"
        echo "$PREFIX ${MIN}m ${SEC}s$ON_THING"
      fi
    fi
    ;;
esac
