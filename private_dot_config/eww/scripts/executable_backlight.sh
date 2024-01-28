max_value=$(cat /sys/class/backlight/intel_backlight/max_brightness)
curr_value=$(cat /sys/class/backlight/intel_backlight/brightness)
percentage=$(python -c "print(max(min(($curr_value / $max_value) * 100, 100), 0))")
echo "$percentage"
