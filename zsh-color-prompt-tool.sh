#!/bin/zsh

# Title Colors / Format Vars
BOLD="$(tput bold)"
NORMAL="$(tput sgr0)"
GREEN='\033[1;32m'
RED='\033[1;31m'
BLUE='\033[1;34m'
PURPLE='\033[1;35m'
CYAN='\033[1;36m'
RC='\033[0m'  # Reset Color
echo -e "${BOLD}\n                ~Welcome to the Zsh ${GREEN}C${RED}o${BLUE}l${PURPLE}o${CYAN}r ${RC}${BOLD}Prompt Tool~${NORMAL}"
echo "                     @KyleTimmermans\n"
echo "Enter the numbers in order of what you want your prompt to consist of:"
echo "1. Username     2. Hostname (Short)     3. Hostname (Full)  4. Shell's TTY\n
5. isPrivileged?   6. Return Status of Last Command    7. Current Working Directory\n
8. Current Working Directory from "$"HOME    9. Current History Event Number\n
10. yy-mm-dd   11. mm-dd-yy   12. day-dd  13. 12-Hour, AM/PM  14. 24-Hour w/ Seconds\n
15. @  16. #  17. !  18. $  19. %  20. *  21. &  22. -  23. _  24. :  25. ; 26. |  27. /  28. ""\ \n
29. Space  30. Custom Text\n"
echo "Type 'n' or 'N' when you're finished"
prompt_array=() # Append to this empty array
declare -i repeat=1
while [ "$repeat" -eq 1 ] ; do
  read "CHOICE?Enter number choice: " \n
  if [[ "$CHOICE" =~ ^[Nn]$ ]] ; then    # If choice is 'n' or 'N' (regex)
    declare -i repeat=0  # Break while-loop
  else
    prompt_array+=($CHOICE)  # Append to array
  fi
done
echo "$prompt_array\n"
