#!/usr/bin/env zsh

# Zsh Color Prompt Tool v1.1

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

# Version flag
if [[ "$1" == "--version" ]] || [[ "$1" == "-v" ]]; then
  echo -e "\nZsh-${GREEN}C${RED}o${BLUE}l${PURPLE}o${CYAN}r${RC}-Prompt-Tool v1.1${NORMAL}\n"
  exit 1
fi


# Welcome Message
echo -e "${BOLD}\n                ~Welcome to the Zsh ${GREEN}C${RED}o${BLUE}l${PURPLE}o${CYAN}r ${RC}${BOLD}Prompt Tool v1.1~${NORMAL}"
echo "                        @KyleTimmermans\n"

# Parts Menu
echo "Enter the numbers in order of what you want your prompt to consist of:"
echo "1. Username     2. Hostname (Short)     3. Hostname (Full)  4. Shell's TTY\n
5. isPrivileged?   6. Return Status of Last Command    7. Current Working Directory\n
8. Current Working Directory from "$"HOME    9. Current History Event Number\n
10. yy-mm-dd   11. mm-dd-yy   12. day-dd  13. 12-Hour, AM/PM  14. 24-Hour w/ Seconds\n
15. @  16. #  17. !  18. $  19. %  20. *  21. &  22. -  23. _  24. :  25. ~  26. |  \n
27. /  28. ""\  29. .  30. Space  31. Custom Text\n"

# Parts Dicionary - Each Index has each respective value from menu
parts_dictionary=('%n' '%m' '%M' '%l' '%#' '%?' '%d'
'%~' '%h' '%D' '%W' '%w' '%t' '%*'
'@' '#' '!' '$' '%' '*' '&' '-' '_' 
':' '~' '|' '/' '\' '.')

# For User to know what they're coloring
# Doesn't need custom text choice
parts_choices=('Username' 'Hostname (Short)' 'Hostname (Full)' 'Shell"s" TTY'
'isPrivileged?' 'Return Status of Last Command' 'Current Working Directory'
'Current Working Directory from $HOME' 'Current History Event Number'
'yy-mm-dd' 'mm-dd-yy' 'day-dd' '12-Hour, AM/PM' '24-Hour w/ Seconds'
'@' '#' '!' '$' '%' '*' '&' '-' '_' ':' '~' '|' '/' '\' '.' 'Space')

# Chose Parts
echo "Type 'n' or 'N' when you're finished"
part_array=() # Append to this empty array
custom_text=() # Use if custom text is
declare -i repeat=1

# Keep entering options until 'n' or 'N' also has error handling
while :; do  # No argument for break, keep going until a break is found in the body
  read "CHOICE?Enter a number choice: " \n
  if [[ "$CHOICE" =~ ^[Nn]$ ]] ; then    # If choice is 'n' or 'N' (regex)
    break  # Break while-loop
  elif [[ "$CHOICE" == '31' ]] ; then  # If custom text
    read "CUSTEXT?Enter Custom Text: " \n
    part_array+=($CHOICE)
    custom_text+=($CUSTEXT) # Needed for printing custom text
  else [[ $CHOICE =~ ^[0-9]+$ ]]  # If it's a number
    if ((CHOICE >= 1 && CHOICE <= 30)); then  # And it's in range (31 already handled)
      part_array+=($CHOICE)  # Append to array
    else
      echo "Enter a valid number! (1-31)"
    fi
  fi
done

if [ ${#part_array[@]} -eq 0 ]; then  # Check if part_array is empty (if size is zero)
    echo "\nNothing added to prompt, exiting!"  # If empty, exit.
    exit 1
fi

# Color Menu (black text on white bg, white text on black bg)
echo "\nEnter the number of the color you want, in order with each part of the prompt you chose:\n"
echo -e "Foregrounds:  1. \033[0;30m\e[47mBlack\033[0m  9. \033[1;30m\e[47mDark Grey\033[0m           Backgrounds:  18. \e[40mBlack\033[0m         26. \e[0;100mBright Black\033[0m\n"
echo -e "              2. \033[0;31mRed\033[0m  10. \033[1;31mLight Red\033[0m                          19. \e[41mRed\033[0m           27. \e[0;101mBright Red\033[0m\n"
echo -e "              3. \033[0;32mGreen\033[0m  11. \033[1;32mLight Green\033[0m                      20. \e[42mGreen\033[0m         28. \e[0;102mBright Green\033[0m\n"
echo -e "              4. \033[0;33mBrown/Orange\033[0m  12. \033[1;33mYellow\033[0m                    21. \e[43mYellow\033[0m        29. \e[0;103mBright Yellow\033[0m\n"
echo -e "              5. \033[0;34mBlue\033[0m  13. \033[1;34mLight Blue\033[0m                        22. \e[44mBlue\033[0m          30. \e[0;104mBright Blue\033[0m\n"
echo -e "              6. \033[0;35mPurple\033[0m  14. \033[1;35mLight Purple\033[0m                    23. \e[45mPurple\033[0m        31. \e[0;105mBright Purple\033[0m\n"
echo -e "              7. \033[0;36mCyan\033[0m  15. \033[1;36mLight Cyan\033[0m                        24. \e[46mCyan\033[0m          32. \e[0;106mBright Cyan\033[0m\n"
echo -e "              8. \033[0;37mLight Grey\033[0m  16. \033[1;37mWhite\033[0m                       25. \033[0;30m\e[47mWhite\033[0m         33. \033[0;30m\e[0;107mBright White\033[0m\n"
echo "              17. No Foreground Color / No Change            34. No Background Color / No Change\033[0m\n"

# Parts Dicionary - Each Index has each respective value from menu (Foregrounds and backgrounds)
color_dictionary=('\033[0;30m' '\033[0;31m' '\033[0;32m' '\033[0;33m'   # Fixed the bright color backgrounds by removing the ";0"
'\033[0;34m' '\033[0;35m' '\033[0;36m' '\033[0;37m'
'\033[1;30m' '\033[1;31m' '\033[1;32m' '\033[1;33m'
'\033[1;34m' '\033[1;35m' '\033[1;36m' '\033[1;37m'
'' '\e[40m' '\e[41m' '\e[42m'
'\e[43m' '\e[44m' '\e[45m' '\e[46m'
'\e[47m' '\e[100m' '\e[101m' '\e[102m'
'\e[103m' '\e[104m' '\e[105m' '\e[106m'
'\e[107m' '')

# Chose Colors
color_array=() # Append to this empty array
declare -i counter=1   # Required for array indexing
for i in $part_array ; do
  while :; do  # Let it go input prompts, then do check at the end
    if [[ "$i" == '31' ]] ; then   # If its the custom text, just print it from part_array
      read "FG?Enter ${UNDERLINE}Foreground${NORMAL} Color Number for "$custom_text[$counter]": " \n  # Holds the actual values of menu, Bash/Zsh arrays start at 1
      read "BG?Enter ${UNDERLINE}Background${NORMAL} Color Number for "$custom_text[$counter]": " \n
    elif [[ "$i" == '30' ]] ; then  # If it's a space, no need for a forgeground choice, just a background
      read "BG?Enter ${UNDERLINE}Background${NORMAL} Color Number for "$parts_choices[$i]": " \n  # Iterate differently for space choice for final prompt logic
    elif [[ "$i" == '24' ]] ; then  # double ":" issue
      read "FG?Enter ${UNDERLINE}Foreground${NORMAL} Color Number for : : " \n
      read "BG?Enter ${UNDERLINE}Background${NORMAL} Color Number for : : " \n
    else
      read "FG?Enter ${UNDERLINE}Foreground${NORMAL} Color Number for "$parts_choices[$i]": " \n
      read "BG?Enter ${UNDERLINE}Background${NORMAL} Color Number for "$parts_choices[$i]": " \n
    fi
    # Filtering each part's color inputs
    declare -i FG_allow=0  # False by default
    if [[ -n "$FG" && $FG =~ ^[0-9]+$ ]] ; then  # Check if fg is a number and used (sometimes not used, like with spaces)
      if ((FG >= 1 && CHOICE <= 17)); then  # Check if it's between 1-17
        FG_allow=1  # Passes FG check
      else  # Never need to break on foreground, still need to check background
        echo "The Foreground number you entered was invalid. Make sure to use a valid Foreground number this time! (1-17)"
      fi     # ^^Go back to top of while loop and ask for input again
    else
      echo "The Foreground number you entered was invalid. Make sure to use a valid Foreground number this time! (1-17)"
    fi
    declare -i BG_allow=0 # False by default
    if [[ $BG =~ ^[0-9]+$ ]] ; then  # Always need bg, no need to check if its used
      if ((BG >= 18 && BG <= 34)); then  # Check if it's between 18-34
        BG_allow=1  # Passed BG check
        break  # End this loop, the color input is fine for this part, go to the next for-loop iteration
      else
        echo "The Background number you entered was invalid. Make sure to use a valid Background number this time! (18-34)"
      fi  # ^^Go back to top of while loop and ask for input again
    else  # If its not even a number
      echo "The Background number you entered was invalid. Make sure to use a valid Background number this time! (18-34)"
    fi  # ^^Go back to top of while loop and ask for input again
  done
  # Results of tests - Both must be good before adding, or it messes up color_array
  if [[ "$i" == '31' ]] && [[ "$FG_allow" == '1' ]] && [[ "$BG_allow" == '1' ]]; then  # Custom_text case
    counter+=1
    color_array+=($FG $BG)
  elif [[ "$i" == '30' ]] && [[ "$BG_allow" == '1' ]]; then  # Spaces case
    color_array+=($BG)
  elif [[ "$i" != '30' ]] && [[ "$i" != '31' ]] && [[ "$FG_allow" == '1' ]] && [[ "$BG_allow" == '1' ]]; then  # Normal case, any choice that's not 30 or 31
    color_array+=($FG $BG)
  fi
done

# Create Final Prompt and Review Prompt
echo "\nThis is a preview of how your prompt will look:\n"
review_prompt=""
final_prompt=""
declare -i counter=1   # Required for array indexing
declare -i counter2=1   # Required for array indexing of custom text
for i in $part_array ; do
  if [[ "$i" == '30' ]] ; then  # If it's a space, no fg needed, first number will act as background
    review_prompt+="$color_dictionary[$color_array[$counter]]"  # Just print a space char, don't actually print "Space"
    final_prompt+="$color_dictionary[$color_array[$counter]]"
    counter+=1  # Only need to go up 1, not trying to skip a second number in a pair this time
  else
    next=$(($counter+1))  # +1 to print both fg and bg pair
    review_prompt+="$color_dictionary[$color_array[$counter]]"
    review_prompt+="$color_dictionary[$color_array[$next]]"
    final_prompt+="$color_dictionary[$color_array[$counter]]"
    final_prompt+="$color_dictionary[$color_array[$next]]"
    counter+=2  # Colors come in two's, don't add bg color twice everytime
  fi
  if [[ "$i" == '31' ]] ; then  # If it's custom text, use $custom_text array
    review_prompt+="$custom_text[$counter2]"  # Has its own counter that goes up by 1's
    final_prompt+="$custom_text[$counter2]"
    review_prompt+="\033[0m" # Don't let anything bleed over
    final_prompt+="\033[0m"
    counter2+=1 # Only go up if more custom text found
  elif [[ "$i" == '30' ]] ; then  # Special case, Add space
    review_prompt+=' '
    final_prompt+=' '
    review_prompt+="\033[0m" # Don't let anything bleed over
    final_prompt+="\033[0m"
  elif [[ "$i" == '28' ]] ; then  # Special case, Add backslash (escape sequence logic)
    review_prompt+='\\'
    final_prompt+='\\'
    review_prompt+="\033[0m"
    final_prompt+="\033[0m"
  else   # If normal
    review_prompt+="$parts_choices[$i]"
    final_prompt+="$parts_dictionary[$i]"
    review_prompt+="\033[0m"
    final_prompt+="\033[0m"
  fi
done

echo -e "$review_prompt\033[0m"

read "CHOICE?Would you like to make this your prompt? (Y/n): " \n
if [[ "$CHOICE" =~ ^[Yy]$ ]] ; then    # If choice is 'y' or 'Y' (regex)
  echo "export PROMPT=$'$final_prompt'" >> ~/.zshrc   # Edit .zshrc file, needs to go into prompt as export PROMPT=$'#final_prompt' (>> is used to append)
  source ~/.zshrc  # Save file
  echo "Prompt Saved Successfully! Restart your Terminal now!"
else
  echo "Prompt not saved, exiting!"
fi
