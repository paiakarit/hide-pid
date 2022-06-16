#!/usr/bin/env bash

function hidePid() {
   mount --bind /dev/shm/.pid /proc/$pid
}

function mkDir() {
  rm -rf /dev/shm/.pid
  mkdir /dev/shm/.pid

  if [[ $? -ne 0 ]]; then
    echo "[error] An error has ocurred" >&2
    exit 1
  fi
}

if [[ $(id -u) -ne "0" ]]; then
  echo "[error] You must run this script as root" >&2
  exit 1
fi

echo -ne "\r"
read -p "Process ID: " pid

mesg="Your PID was successfully hidden!"

mkDir && hidePid && \

for i in $(seq 1 ${#mesg}); do
  echo -ne "${mesg:i-1:1}"
  sleep 0.07
done
echo -ne "\n"