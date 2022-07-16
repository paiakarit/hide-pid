#!/usr/bin/env bash


PID=
PROGNAME="$(basename $0)"
GETOPT_ARGS=$(getopt -o hc:w:g:de:nm: -l "help","pid:" -n "$PROGNAME" -- "$@")


function usage() {
  echo "Usage: "$PROGNAME" [Options] <Process-ID>"
  echo
  echo "Options: "
  echo "    -h, --help        Display this help and exit"
  echo "    --pid             Process ID"
}


function hidePid() {
   mount --bind /dev/shm/.pid /proc/$PID
}


function mkDir() {
  rm -rf /dev/shm/.pid
  mkdir /dev/shm/.pid

  if [[ $? -ne 0 ]]; then
    echo "[error] An error has ocurred" >&2
    exit 1
  fi
}


[[ $? -ne 0 ]] && exit 1
eval set -- "$GETOPT_ARGS"


while :; do
  case "$1" in
    -h|--help)
      usage
      exit 0
    ;;
    --pid)
      shift
      PID="$1"
      shift
    ;;
    --)
      shift
      break
    ;;
  esac
done


if [[ $(id -u) -ne "0" ]]; then
  echo "[error] You must run this script as root" >&2
  exit 1
fi


if [[ -n "$PID" ]]; then
  msg="You Process ID was successfully hidden!"

  mkDir && hidePid && \

  for i in $(seq 1 ${#msg}); do
    echo -ne "${msg:i-1:1}"
    sleep 0.06
  done

  exit 1
fi


if [[ $# -lt 1 ]]; then
    usage >&2
    exit 1
fi