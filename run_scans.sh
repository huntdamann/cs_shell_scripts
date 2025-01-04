#!/bin/bash


#Check if an IP address is provided

if  [ $# -lt 2 ]; then 

	echo "Usage: $0 <IP_ADDRESS> <WORDLIST_PATH> [-d] [-n]"
	echo " -d: Run dirb"
	echo " -n: Run nikto"
	exit 1

fi 

IP_ADDRESS=$1
WORDLIST=$2
shift 2 #Removes the IP ADDRESS arg, leaving only flags

RUN_DIRB=false
RUN_NIKTO=false

# Parse flags

while getopts "dn" opt; do 
	case ${opt} in
		d)
			RUN_DIRB=true

			;;

		n)
			RUN_NIKTO=true

			;;

		*)
			echo "Usage: $0 <target-ip> [-d] [-n]"
			exit 1
			;;

	esac
done

#If neither -d nor -n is provided, print message and exit 
if [ "$RUN_DIRB" = false ] && [ "$RUN_NIKTO" = false ]; then
	echo "You must specify at least one of -d (dirb) or -n (nikto)"
	exit 1

fi


# Check if the wordlist file exists 
if [ ! -f "$WORDLIST" ]; then 
	echo "Error: Wordlist file '$WORDLIST' not found."
	exit 1
fi 
# Open dirb in a new terminal 

if [ "$RUN_DIRB" = true ]; then
	
	x-terminal-emulator -e bash -c "echo 'Running dirb on $IP_ADDRESS'; dirb $IP_ADDRESS $WORDLIST -v -N 400 -o dirb_results.txt; bash" &

fi


if [ "$RUN_NIKTO" = true ]; then

	x-terminal-emulator -e bash -c "echo 'Running Nikto scan on $IP_ADDRESS'; nikto -h $IP_ADDRESS -Tuning 0134789a -Display 3V -output nikto_results.txt; bash" &
 

fi
