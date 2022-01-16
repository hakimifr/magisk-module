#!/system/bin/sh
# this script will run in late-start service mode
MODDIR=${0%/*}

# Restore permission set by customize.sh during install
# in case someone decides to fuck with the permissions
chmod 755 $MODDIR/system/bin/*
