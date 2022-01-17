until [ "$(getprop sys.boot_completed)" -eq 1 ]; do :; done

# for android 12
wm disable-blur 0
