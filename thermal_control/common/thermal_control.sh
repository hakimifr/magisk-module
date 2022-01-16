# shellcheck shell=sh
while [ "$(getprop sys.boot_completed | tr -d '\r')" != "1" ]; do sleep 1; done # stolen from YouTube Vanced script
sleep 1

logger() {
  date +"[%H:%M:%S] $1" >> /sdcard/thermal_control.log
}
logger "script is running"

ckdis() {
  if [ "$(getprop thermal_control)" = "disable" ]; then
    logger "disabled"
    exit 0
  fi
}

# perf_profile.sh
# ----------------
# 0 - balanced
# 1 - power saving
# 2 - performance
# ----------------

rm /sdcard/thermal_control.log
logger "removed old log file"

readonly nodepath="/sys/class/power_supply/battery"
readonly temp="$nodepath/temp"
readonly status="$nodepath/status"
readonly cool_down="$nodepath/cool_down"

while true; do

  ckdis
  while [ "$(cat $status)" = "Charging" ]; do

    if [ "$(cat $temp)" -ge 378 ]; then
      echo 1 > $nodepath/cool_down
      logger "cool 1"
    fi
    if [ "$(cat $temp)" -le 374 ]; then
      echo 0 > $cool_down
      logger "cool 0"
    fi

    if [ "$(cat $status)" = "Not charging" ]; then
      echo 0 > $cool_down
      logger "cool 0"
      break
    fi
    ckdis
    sleep 1.2

  done


  while [ "$(cat $status)" = "Not charging" ]; do

    if [ "$(cat $temp)" -ge 370 ]; then
      perf_profile.sh 1
      setprop persist.perf_profile 1
    fi
    if [ "$(cat $temp)" -ge 362 ]; then
      perf_profile.sh 0
      setprop persist.perf_profile 0
      logger "perf 0"
    fi
    if [ "$(cat $temp)" -le 354 ]; then
      perf_profile.sh 2
      setprop persist.perf_profile 2
      logger "perf 2"
    fi

    if [ "$(cat $status)" = "Charging" ]; then
      perf_profile.sh 0
      setprop persist.perf_profile 0
      logger "perf 0"
      break
    fi
    ckdis
    sleep 1.2

  done

done


