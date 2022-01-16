# shellcheck shell=sh
ui_print "
**************************
* custom thermal control *
* profile: cool          *
**************************
"

ui_print "- verifying scripts"
curdir=$(pwd)
cd $MODPATH/common
if sha256sum -c scripts.sha256; then
  ui_print "- verification pass"
else
  abort "! tampered file detected"
fi
cd $curdir

ui_print "- system checks"

if [ "$(getprop ro.product.odm.model)" != "RMX2001" ]; then
  abort "! unsupported device"
fi

if ! [ -f /system/bin/perf_profile.sh ]; then
  ui_print "- perf_profile.sh isn't detected. you appear to"
  ui_print "  be on realme UI."
  ui_print "- copying perf_profile.sh"
  cp $MODPATH/common/perf_profile.sh $MODPATH/system/bin
fi

ui_print "- installing boot script"
ui_print "- removing old log"
rm /sdcard/thermal_control.log 2>/dev/null
install_script -l $MODPATH/common/thermal_control.sh

ui_print "- make sure to reboot."

ui_print "- to disable, open termux and enter \`disable_tcon\`"

