#!/usr/bin/env bash

battery_status() {
	case "$(uname -s)" in
		Linux)
			_bat=$(find /sys/class/power_supply -type l -name "BAT*")
            _status="$(cat "${_bat}/status")%"
			;;
		Darwin)
            _status="$(pmset -g batt | sed -n 2p | cut -d ';' -f 2 | tr -d ' ')"
			;;
		*)
			;;
	esac

	case $_status in
		discharging|Discharging)
			echo '<'
			;;
		high|Full)
			echo '♥ '
			;;
		charging|Charging)
			echo '>'
			;;
		*)
			echo ''
			;;
	esac
}

battery_percent() {
	case "$(uname -s)" in
		Linux)
			_bat=$(find /sys/class/power_supply -type l -name "BAT*")
            echo "$(cat "${_bat}/capacity")%"
			;;
		Darwin)
			pmset -g batt | grep -Eo '[0-9]?[0-9]?[0-9]%'
			;;
		*)
			;;
	esac
}

main() {
	status="$(battery_status)"
	percent="$(battery_percent)"
	
	echo "${status}${percent}"
}

main
