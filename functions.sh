#!/usr/bin/env bash
#
# General re-usable functions
#

#
# Fancy motd with system stats.
# ASCII art generator: https://patorjk.com/software/taag/#p=display&f=Bloody
#
function fancymotd() {
	tput bold
	tput setaf 1
	tee <<-EOF

		 █     █░▓█████  ██▓     ▄████▄   ▒█████   ███▄ ▄███▓▓█████ 
		▓█░ █ ░█░▓█   ▀ ▓██▒    ▒██▀ ▀█  ▒██▒  ██▒▓██▒▀█▀ ██▒▓█   ▀ 
		▒█░ █ ░█ ▒███   ▒██░    ▒▓█    ▄ ▒██░  ██▒▓██    ▓██░▒███   
		░█░ █ ░█ ▒▓█  ▄ ▒██░    ▒▓▓▄ ▄██▒▒██   ██░▒██    ▒██ ▒▓█  ▄ 
		░░██▒██▓ ░▒████▒░██████▒▒ ▓███▀ ░░ ████▓▒░▒██▒   ░██▒░▒████▒
		░ ▓░▒ ▒  ░░ ▒░ ░░ ▒░▓  ░░ ░▒ ▒  ░░ ▒░▒░▒░ ░ ▒░   ░  ░░░ ▒░ ░
		  ▒ ░ ░   ░ ░  ░░ ░ ▒  ░  ░  ▒     ░ ▒ ▒░ ░  ░      ░ ░ ░  ░
		  ░   ░     ░     ░ ░   ░        ░ ░ ░ ▒  ░      ░      ░   
		    ░       ░  ░    ░  ░░ ░          ░ ░         ░      ░  ░

		$(lsb_release -sd) | CPU Threads: $(lscpu | grep "CPU(s):" | tail +1 | head -1 | awk '{print $2}') | IP: $(hostname -I | awk '{print $1}') | RAM: $(free -m | grep Mem | awk 'NR=1 {print $2}') MB
	EOF
	tput sgr0
}
