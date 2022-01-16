#!/system/bin/sh

#
# ui_print <msg>
#     print <msg> to console
#     Avoid using 'echo' as it will not display in custom recovery's console
#
# abort <msg>
#     print error message <msg> to console and terminate the installation
#     Avoid using 'exit' as it will skip the termination cleanup steps
#
# set_perm <target> <owner> <group> <permission> [context]
#     if [context] is not set, the default is "u:object_r:system_file:s0"
#     this function is a shorthand for the following commands:
#        chown owner.group target
#        chmod permission target
#        chcon context target
#
# set_perm_recursive <directory> <owner> <group> <dirpermission> <filepermission> [context]
#     if [context] is not set, the default is "u:object_r:system_file:s0"
#     for all files in <directory>, it will call:
#        set_perm file owner group filepermission context
#     for all directories in <directory> (including itself), it will call:
#        set_perm dir owner group dirpermission context
#

set_perm_recursive $MODPATH/system/bin 0 0 0755 0755
