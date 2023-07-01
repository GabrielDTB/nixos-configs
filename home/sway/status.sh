# The Sway configuration file in ~/.config/sway/config calls this script.
# You should see changes to the status bar after saving this script.
# If not, do "killall swaybar" and $mod+Shift+c to reload the configuration.

zett_id=$(~/.config/sway/zett_id.sh)

# Produces "21 days", for example
uptime_formatted=$(uptime | cut -d ',' -f1  | cut -d ' ' -f4,5)

# The abbreviated weekday (e.g., "Sat"), followed by the ISO-formatted date
# like 2018-10-06 and the time (e.g., 14:01)
date_formatted=$(date "+%a %F %H:%M")

# Get the Linux version but remove the "-1-ARCH" part
linux_version=$(uname -r | cut -d '-' -f1)

volume=$(amixer get Master | grep "Right:" | cut -f 7,8 -d " ")

# Returns the battery status: "Full", "Discharging", or "Charging".
charging=$(cat /sys/class/power_supply/BAT0/status)

battery_status=$(upower -i $(upower -e | grep 'BAT') | grep -E "percentage" | awk '{print $2}')

# Emojis and characters for the status bar
# 💎 💻 💡 🔌 ⚡ 📁 \|
#echo "up $uptime_formatted | ↑ $linux_version 🐧 $battery_status 🔋 $date_formatted"
echo "$zett_id || Uptime $uptime_formatted | Kernel $linux_version |$([ !-z "$charging" ] && echo " $charging $battery_status |") $date_formatted"
