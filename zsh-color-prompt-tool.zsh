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

# Welcome Message
echo -e "${BOLD}\n                ~Welcome to the Zsh ${GREEN}C${RED}o${BLUE}l${PURPLE}o${CYAN}r ${RC}${BOLD}Prompt Tool~${NORMAL}"
echo "                     @KyleTimmermans\n"

# Parts Menu
echo "Enter the numbers in order of what you want your prompt to consist of:"
echo "1. Username     2. Hostname (Short)     3. Hostname (Full)  4. Shell's TTY\n
5. isPrivileged?   6. Return Status of Last Command    7. Current Working Directory\n
8. Current Working Directory from "$"HOME    9. Current History Event Number\n
10. yy-mm-dd   11. mm-dd-yy   12. day-dd  13. 12-Hour, AM/PM  14. 24-Hour w/ Seconds\n
15. @  16. #  17. !  18. $  19. %  20. *  21. &  22. -  23. _  24. :  25. ; 26. |  27. /  28. ""\ \n
29. Space  30. Custom Text\n"

# Parts Dicionary - Each Index has each respective value from menu
parts_dictionary=('%n' '%m' '%M' '%l' '%#' '%?' '%d'
'%~' '%h' '%D' '%W' '%w' '%t' '%*'
'@' '.' '#' '!' '$' '%' '*'
'&' '-' '_' ':' ';' '|' '/' '\' ' ')

# For User to know what they're coloring
# Doesn't need custom text choice
parts_choices=('Username' 'Hostname (Short)' 'Hostname (Full)' 'Shells TTY'
'isPrivileged?' 'Return Status of Last Command' 'Current Working Directory'
'Current Working Directory from "$"HOME' 'Current History Event Number'
'yy-mm-dd' 'mm-dd-yy' 'day-dd' '12-Hour, AM/PM' '24-Hour w/ Seconds'
'@' '#' '!' '$' '%' '*' '&' '-' '_' ':' ';' '|' '/' '\' ' ')

# Chose parts
echo "Type 'n' or 'N' when you're finished"
part_array=() # Append to this empty array
declare -i repeat=1
# Keep entering options until 'n' or 'N'
while [ "$repeat" -eq 1 ] ; do
  read "CHOICE?Enter number choice: " \n
  if [[ "$CHOICE" =~ ^[Nn]$ ]] ; then    # If choice is 'n' or 'N' (regex)
    declare -i repeat=0  # Break while-loop
  elif [[ "$CHOICE" == '30' ]] ; then  # If custom text
    read "CUSTEXT?Enter Custom Text: " \n
    part_array+=($CUSTEXT)
  else
    part_array+=($CHOICE)  # Append to array
  fi
done

# Color Menu
echo "\nEnter the color of the number you want, in order of each part of the prompt you chose:"
echo -e "1. Black  9. Dark Grey\n"
echo -e "2. Red  10. Light Red\n"
echo -e "3. Green  11. Light Green\n"
echo -e "4. Brown/Orange  12. Yellow\n"
echo -e "5. Blue  13. Light Blue\n"
echo -e "6. Purple  14. Light Purple\n"
echo -e "7. Cyan  15. Light Cyan\n"
echo -e "8. Light Grey  16. White\n"
echo "17. No Color / No Change\n"

# Parts Dicionary - Each Index has each respective value from menu
color_dictionary=('\033[0;30m' '\033[0;31m' '\033[0;32m' '\033[0;33m'
'\033[0;34m' '\033[0;35m' '\033[0;36m' '\033[0;37m'
'\033[1;30m' '\033[1;31m' '\033[1;32m' '\033[1;33m'
'\033[1;34m' '\033[1;35m' '\033[1;36m' '\033[1;37m'
'\033[0m')

# Chose Colors
color_array=() # Append to this empty array
for i in $part_array;
  # if part  array is not 30
  do echo $parts_choices[$part_array[i]-1];  # Holds the actual values of menu
done

# Preview
# Setup test show cases
# echo $final_promp


# Logic to actual build $final_prompt
# final_prompt='"options"'    # Needs double quote logic


# Finally save it and source it
# echo export PROMPT=$final_prompt >> ~/.zshrc
# source ~/.zshrc
