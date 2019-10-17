#!/bin/bash

case "$1" in
	"rush")
		sudo cpufreqctl turbo 0
		sudo cpufreqctl max 100
		sudo cpufreqctl gov performance
		;;
	"save")
		sudo cpufreqctl turbo 1
		sudo cpufreqctl max 50
		sudo cpufreqctl gov powersave
		;;
	*)
		echo -e "Usage:\n  power.sh (rush|save)"
esac


