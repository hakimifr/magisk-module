#!/system/bin/sh
MODDIR=${0%/*}

restart() {
        stop $1
        start $1
}
