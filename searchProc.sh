#!/bin/bash

if [ "$1" == "" ]; then
	echo -e "[!] The name of the process is required"
	exit 1
fi

ps aux | grep "$1" | grep -v -E "grep|$0" > /dev/null 2>&1

if [ "$(echo $?)" == "0" ]; then
	echo -e "[*] Process Found!\n"
	pid=()
	pid+=$(ps aux | grep "$1" | grep -v -E "grep|$0" | awk '{print $2}')
	pid_show=$(echo $pid | sed 's/ /, /g')

	user=$(ps aux | grep "$1" | grep -v -E "grep|$0" | awk '{print $1}' | tr '\n' ' ')
	user_show=$(echo $user | sed 's/ /, /g')

	echo -e "\tPID: $pid_show"
	echo -e "\tOwner: $user_show"
	echo -e "\n[*] Processes:\n"

	ps aux | grep "$1" | grep -v -E "grep|$0"
	echo -n -e "\nDo you want to kill the processes? [Y/n] "
	read kill_proc
	kill_proc=$(echo $kill_proc | tr '[:upper:]' '[:lower:]')
	if [[ $kill_proc == y* ]]; then # Doble corchete para el globbing (*.py)
		echo ""
		for i in $pid; do
			echo "[*] Killing Process $i"
			kill -9 $i > /dev/null 2>&1
			if [ "$(echo $?)" != "0" ]; then
				echo "   [!] The $i process could not be killed"
				if [ "$(id -u)" != "0" ]; then
					echo -e "\t[*] Possible reason, you're nor root.\n"
				fi
			fi
		done
	else
		exit 1
	fi
else
	echo -e "[*] Process Not Found!\n"
	exit 1
fi