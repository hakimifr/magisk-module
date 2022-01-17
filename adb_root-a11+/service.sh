#!/system/bin/sh
MODDIR=${0%/*}

# bind to /apex/com.android.adbd/bin/adbd

. $MODDIR/files/functions.sh

chcon u:object_r:adbd_exec:s0 $MODDIR/files/adbd
chown root:shell $MODDIR/files/adbd
chmod 755 $MODDIR/files/adbd

mount -o bind $MODDIR/files/adbd /apex/com.android.adbd/bin/adbd
resetprop ro.debuggable 1

restart adbd
