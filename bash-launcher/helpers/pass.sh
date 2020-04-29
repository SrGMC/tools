#! /bin/bash
#
# pass-helper
# Script to manage password-store from the terminal
#
# Author: Álvaro Galisteo (https://alvaro.ga)
# Copyright 2020 - GPLv3

NAME=""
function request {
	read -p "$(tput setaf 3)What item?: $(tput sgr 0)" NAME
}

clear && tput reset
echo "$(tput bold)Password Store$(tput sgr 0)"
echo "password-store manager"
echo ""

case $1 in
	otp) request ; pass otp "$NAME" ;;
	list) tree ~/.password-store ;;
	show) request ; pass "$NAME" ;;
	insert) request ; pass insert -m "$NAME" ;;
esac