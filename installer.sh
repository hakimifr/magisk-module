#!/data/data/com.termux/files/usr/bin/bash

available_module=(
	"G-VisualMod.zip"
	"SELinux-permissiver-magisk-module.zip"
	"ViPER4Android-FX.zip"
	"acp.zip"
	"adb_root-a11+.zip"
	"adb_root.zip"
	"aml.zip"
	"blur_support.zip"
	"thermal_control.zip"
	"useful_scripts.zip"
)

# Exclude nothing
exclude_combo1=()

# Exclude audio mods, adb, thermal
exclude_combo2=(
	"acp.zip"
	"aml.zip"
	"adb_root-a11+.zip"
	"adb_root.zip"
	"SElinux-permissiver-magisk-module.zip"
	"ViPER4Android-FX.zip"
	"thermal_control.zip"
)

# Exclude audio mods
exclude_combo3=(
	"acp.zip"
	"aml.zip"
	"ViPER4Android-FX.zip"
)

# Exclude adb
exclude_combo4=(
	"adb_root-a11+.zip"
	"adb_root.zip"
)

# Exclude adb, audio mods
exclude_combo5=(
	"adb_root-a11+.zip"
	"adb_root.zip"
	"acp.zip"
	"aml.zip"
	"ViPER4Android-FX.zip"
	"thermal_control.zip"
)

# Exclude thermal mod
exclude_combo6=(
	"thermal_control.zip"
)

#### Variables #######################
gh_zipurl="https://raw.githubusercontent.com/Hakimi0804/magisk-module/main/zipped"
preferred_excl_combo=1
# selected_excl_combo=1
######################################

echo "Hakimi's Magisk Module Installer"
echo "================================"
echo "1. Install all modules"
echo "2. Install all modules except audio mods, adb, thermal"
echo "3. Install all modules except audio mods"
echo "4. Install all modules except adb"
echo "5. Install all modules except audio mods, adb"
echo "6. Install all modules except thermal"
read -p "Select an option(default: 2): " selected_excl_combo

pick_excl() {
	case $selected_excl_combo in
		1)
			exclude_combo=${exclude_combo1[*]}
			;;
		2)
			exclude_combo=${exclude_combo2[*]}
			;;
		3)
			exclude_combo=${exclude_combo3[*]}
			;;
		4)
			exclude_combo=${exclude_combo4[*]}
			;;
		5)
			exclude_combo=${exclude_combo5[*]}
			;;
		6)
			exclude_combo=${exclude_combo6[*]}
			;;
		*)
			selected_excl_combo=$preferred_excl_combo
			pick_excl
			;;
	esac
}
pick_excl
echo "Selected option: $selected_excl_combo"
# echo "$exclude_combo"

# Download modules
echo "Downloading modules..."
mkdir mdls
for module in "${available_module[@]}"; do
	if [[ ! " ${exclude_combo[*]} " =~ " ${module} " ]]; then
		echo "  Downloading $module..."
		wget -q -O "mdls/$module" "$gh_zipurl/$module"
	fi
done

# Install modules
for module in mdls/*.zip; do
	echo "Installing $module..."
	su -c "magisk --install-module $module"
done

# Clean up
echo "Cleaning up..."
rm -rf mdls
