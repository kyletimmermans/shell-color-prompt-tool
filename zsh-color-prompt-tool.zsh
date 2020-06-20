#!/bin/zsh

# In hindsight, this would have been a lot easier if I knew bash/zsh had dictionaries and C-like for loops
# Good challenge though

# Title Colors / Format Vars
BOLD="$(tput bold)"
UNDERLINE="$(tput smul)"
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
15. @  16. #  17. !  18. $  19. %  20. *  21. &  22. -  23. _  24. :  25. ~  26. |  27. /  28. ""\ \n
29. Space  30. Custom Text\n"

# Parts Dicionary - Each Index has each respective value from menu
parts_dictionary=('%n' '%m' '%M' '%l' '%#' '%?' '%d'
'%~' '%h' '%D' '%W' '%w' '%t' '%*'
'@' '.' '#' '!' '$' '%' '*'
'&' '-' '_' ':' '~' '|' '/' '\' ' ')

# For User to know what they're coloring
# Doesn't need custom text choice
parts_choices=('Username' 'Hostname (Short)' 'Hostname (Full)' 'Shell"s" TTY'
'isPrivileged?' 'Return Status of Last Command' 'Current Working Directory'
'Current Working Directory from $HOME' 'Current History Event Number'
'yy-mm-dd' 'mm-dd-yy' 'day-dd' '12-Hour, AM/PM' '24-Hour w/ Seconds'
'@' '#' '!' '$' '%' '*' '&' '-' '_' ':' '~' '|' '/' '\' 'Space')

# Chose parts
echo "Type 'n' or 'N' when you're finished"
part_array=() # Append to this empty array
custom_text=() # Use if custom text is
declare -i repeat=1
# Keep entering options until 'n' or 'N'
while [ "$repeat" -eq 1 ] ; do
  read "CHOICE?Enter number choice: " \n
  if [[ "$CHOICE" =~ ^[Nn]$ ]] ; then    # If choice is 'n' or 'N' (regex)
    declare -i repeat=0  # Break while-loop
  elif [[ "$CHOICE" == '30' ]] ; then  # If custom text
    read "CUSTEXT?Enter Custom Text: " \n
    part_array+=($CHOICE)
    custom_text+=($CUSTEXT) # Needed for printing custom text
  else
    part_array+=($CHOICE)  # Append to array
  fi
done

# Color Menu (black text on white bg, white text on black bg)
echo "\nEnter the color of the number you want, in order of each part of the prompt you chose:"
echo -e "1. \033[0;30m\e[47mBlack\033[0m  9. \033[1;30m\e[47mDark Grey\033[0m           Backgrounds:  18. \e[40mBlack\033[0m         26. \e[0;100mBright Black\033[0m\n"
echo -e "2. \033[0;31mRed\033[0m  10. \033[1;31mLight Red\033[0m                          19. \e[41mRed\033[0m           27. \e[0;101mBright Red\033[0m\n"
echo -e "3. \033[0;32mGreen\033[0m  11. \033[1;32mLight Green\033[0m                      20. \e[42mGreen\033[0m         28. \e[0;102mBright Green\033[0m\n"
echo -e "4. \033[0;33mBrown/Orange\033[0m  12. \033[1;33mYellow\033[0m                    21. \e[43mYellow\033[0m        29. \e[0;103mBright Yellow\033[0m\n"
echo -e "5. \033[0;34mBlue\033[0m  13. \033[1;34mLight Blue\033[0m                        22. \e[44mBlue\033[0m          30. \e[0;104mBright Blue\033[0m\n"
echo -e "6. \033[0;35mPurple\033[0m  14. \033[1;35mLight Purple\033[0m                    23. \e[45mPurple\033[0m        31. \e[0;105mBright Purple\033[0m\n"
echo -e "7. \033[0;36mCyan\033[0m  15. \033[1;36mLight Cyan\033[0m                        24. \e[46mCyan\033[0m          32. \e[0;106mBright Cyan\033[0m\n"
echo -e "8. \033[0;37mLight Grey\033[0m  16. \033[1;37mWhite\033[0m                       25. \033[0;30m\e[47mWhite\033[0m         33. \033[0;30m\e[0;107mBright White\033[0m\n"
echo "17. No Foreground Color / No Change            34. No Background Color / No Change\033[0m\n"

# Parts Dicionary - Each Index has each respective value from menu (Foregrounds and backgrounds)
color_dictionary=('\033[0;30m' '\033[0;31m' '\033[0;32m' '\033[0;33m'   # Fixed the bright color backgrounds by removing the ";0"
'\033[0;34m' '\033[0;35m' '\033[0;36m' '\033[0;37m'
'\033[1;30m' '\033[1;31m' '\033[1;32m' '\033[1;33m'
'\033[1;34m' '\033[1;35m' '\033[1;36m' '\033[1;37m'
'\033[0m' '\e[40m' '\e[41m' '\e[42m'
'\e[43m' '\e[44m' '\e[45m' '\e[46m'
'\e[47m' '\e[100m' '\e[101m' '\e[102m'
'\e[103m' '\e[104m' '\e[105m' '\e[106m'
'\e[107m' '\033[0m')

# Chose Colors
color_array=() # Append to this empty array
declare -i counter=1   # Required for array indexing
for i in $part_array ; do
  if [[ "$i" == '30' ]] ; then   # If its the custom text, just print it from part_array
    read "FG?Enter ${UNDERLINE}Foreground${NORMAL} Color Number for "$custom_text[$counter]": " \n  # Holds the actual values of menu, Bash/Zsh arrays start at 1
    color_array+=($FG)
    read "BG?Enter ${UNDERLINE}Background${NORMAL} Color Number for "$custom_text[$counter]": " \n
    color_array+=($BG)
    counter+=1 # Indexing the loop iterations and allow for printing of $custom_text, i++ if another custom text found
  else
    read "FG?Enter ${UNDERLINE}Foreground${NORMAL} Color Number for "$parts_choices[$i]": " \n  # Holds the actual values of menu, Bash/Zsh arrays start at 1
    color_array+=($FG)
    read "BG?Enter ${UNDERLINE}Background${NORMAL} Color Number for "$parts_choices[$i]": " \n
    color_array+=($BG)
  fi
done


# Create Final Prompt and Review Prompt
echo "\nThis is a preview of how your prompt will look:\n"
review_prompt=""
final_prompt=""
declare -i counter=1   # Required for array indexing
declare -i counter2=1   # Required for array indexing of custom text
for i in $part_array ; do
  review_prompt+="$color_dictionary[$color_array[$counter]]"
  review_prompt+="$color_dictionary[$color_array[$(($counter+1))]]" # +1 to print both fg and bg pair
  final_prompt+="$color_dictionary[$color_array[$counter]]"
  final_prompt+="$color_dictionary[$color_array[$(($counter+1))]]"
  counter+=2  # Colors come in two's, don't add bg color twice everytime
  if [[ "$i" == '30' ]] ; then  # If it's custom text, use $custom_text array
    review_prompt+="$custom_text[$counter2]"  # Has its own counter that goes up by 1's
    final_prompt+="$custom_text[$counter2]"
    counter2+=1 # Only go up if more custom text found
  else   # If notmal
    review_prompt+="$parts_choices[$i]"
    final_prompt+="$parts_dictionary[$i]"
  fi
done

echo -e "$review_prompt"
echo -e "$final_prompt"
# Use ${var} to fix single quotes in the array that will have options appended
# final_prompt='"options"'    # Needs double quote logic


#if [[ "$CHOICE" =~ ^[Yy]$ ]] ; then    # If choice is 'y' or 'Y' (regex)
  # save, echo "Prompt Saved!"
#else
  # echo "Prompt not saved, exiting!"
# Finally save it and source it
# echo export PROMPT="$final_prompt" >> ~/.zshrc
# source ~/.zshrc
# echo "Changes Saved!"
