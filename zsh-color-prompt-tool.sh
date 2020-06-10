#!/bin/zsh

BOLD="$(tput bold)"
NORMAL="$(tput sgr0)"
GREEN='\033[1;32m'
RED='\033[1;31m'
BLUE='\033[1;34m'
PURPLE='\033[1;35m'
CYAN='\033[1;36m'
RC='\033[0m'  # Reset Color
echo -e "${BOLD}\n~Welcome to the Zsh ${GREEN}C${RED}o${BLUE}l${PURPLE}o${CYAN}r ${RC}${BOLD}Prompt Tool~${NORMAL}~"
echo "@KyleTimmermans\n"
echo "Enter the numbers in order of what you want your prompt to consist of:"
echo "01. Username     02. Hostname (Short)     03. Hostname (Full)\n
04. Return Status of Last Command    05. Current Working Directory\n
06. Current Working Directory from "$"HOME    07. Current History Event Number\n
08. yy-mm-dd   09. mm-dd-yy   10. day-dd  11. 12-Hour, AM/PM  12. 24-Hour w/ Seconds\n
13. @  14. #  15. !  16. $  17. %  18. *  19. &  20. -  21. _  22. :  23. ; 24. |  25. /  26. ""\ \n
27. Custom Text\n"
echo "Type 'n' or 'N' when you're finished"
prompt_array = () # Append to this empty array
repeat = 1
while [repeat == 1]
do
  read -n2 -p "Please enter number choice: " CHOICE
  if [$CHOICE == 'n' || $CHOICE == 'N']
    repeat = 0
  else
    prompt_array+=($CHOICE)  # Append to array
  fi
done
