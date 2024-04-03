#!/usr/bin/env bash


# Shell Color Prompt Tool v2.0


# Title Colors / Format Vars
BOLD="$(tput bold)"
UNDERLINE="$(tput smul)"
NORMAL="$(tput sgr0)"
GREEN='\e[1;32m'
RED='\e[1;31m'
BLUE='\e[1;34m'
PURPLE='\e[1;35m'
CYAN='\e[1;36m'
BLACK='\e[0;30m'
RC='\e[0m'  # Reset Color


# Version flag
if [[ $* == *-v* ]]; then
  echo -e "\nShell-${GREEN}C${RED}o${BLUE}l${PURPLE}o${CYAN}r${RC}-Prompt-Tool v2.0${NORMAL}\n"
  exit 0
fi


# Help/Usage flag
if [[ $* == *-h* ]] || [[ $* == *-u* ]]; then
  echo -e "\nUsage: Run this program and use the interactive prompt to create your shell prompt\n\n"
  echo -e "Flags:\n"
  echo -e "--comment-out        Comment out older prompt lines in .zshrc/.bashrc e.g. PROMPT= / PS1="
  echo -e "                     to help prevent conflicting prompt definitions"
  echo -e "--light-mode         Better color contrast for the color picker menu on white/light-colored"
  echo -e "                     terminal backgrounds"
  echo -e "--omz                Disables your 'Oh My Zsh' theme if you have one, which could get in the"
  echo -e "                     way of applying your new prompt"
  echo -e "--no-extras          Don't add automatic newline to start of prompt and space to end of prompt\n\n"
  echo -e "Usage Notes:\n"
  echo -e "* No need to put a space at the end of your prompt, one will be added automatically."
  echo -e "  Same with a newline at the beginning for proper spacing between actual prompts,"
  echo -e "  one will automatically be added. Disable this feature w/ --no-extras\n"
  echo -e "* Use a text editor such as Vim to view the raw components of the prompt definition in"
  echo -e "  .zshrc/.bashrc, as some text editors have trouble displaying the ANSI escape sequences\n"
  echo -e "* Fullscreen terminals will be able to fit the spacing and styling"
  echo -e "  of the interactive prompt the best\n"
  echo -e "* Colors may vary from system to system\n\n"
  echo -e "github.com/kyletimmermans/shell-color-prompt-tool\n\n"
  exit 0
fi


# Welcome Message
if [[ $* != *--light-mode* ]]; then
  echo -e "${BOLD}\n                ~Welcome to the Shell ${GREEN}C${RED}o${BLUE}l${PURPLE}o${CYAN}r ${RC}${BOLD}Prompt Tool v2.0~${NORMAL}"
else
  echo -e "${BLACK}${BOLD}\n                ~Welcome to the Shell ${GREEN}C${RED}o${BLUE}l${PURPLE}o${CYAN}r ${RC}${BLACK}${BOLD}Prompt Tool v2.0~${NORMAL}"
fi
echo -e "                        @KyleTimmermans\n"


echo ""
read -p "Will this be a Zsh or a Bash prompt? Enter 'Z' for Zsh or 'B' for Bash: " TYPESHELL
echo ""

while :; do
  if [[ "$TYPESHELL" =~ ^[Zz]$ ]] || [[ "$TYPESHELL" =~ ^[Bb]$ ]]; then
    break
  else
    read -p "Please chose a valid shell type ('Z' or 'B'): " TYPESHELL
  fi
done
echo ""

if [[ "$TYPESHELL" =~ ^[Zz]$ ]]; then
  echo -e "Will this be a prompt for a standard user (PROMPT), or for when"
  echo -e "the user is root (RPROMPT)? Or do you want to do it for both?\n"
  read -p "Enter 'P' for normal user prompt, 'R' for root user prompt, or 'B' for both: " TYPEPROMPT

  while :; do
    if [[ "$TYPEPROMPT" =~ ^[Pp]$ ]] || [[ "$TYPEPROMPT" =~ ^[Rr]$ ]] || [[ "$TYPEPROMPT" =~ ^[Bb]$ ]] ; then
      break
    else
      read -p "Please chose a valid prompt type ('P' or 'R' or 'B'): " TYPEPROMPT
    fi
  done
  echo ""
fi

# Parts Menu
parts_dictionary=()
parts_choices=()
if [[ "$TYPESHELL" =~ ^[Zz]$ ]] ; then
  echo -e "\nEnter the numbers in order of what you want your prompt to consist of:"
  echo -e "----------------------------------------------------------------------\n"
  echo -e "Variables:\n
  1. Username     2. Hostname (Short)     3. Hostname (Full)    4. Shell's TTY\n
  5. isRoot (\$ == Not Root, # == Root)   6. Return Status of Last Command    7. Current Working Directory\n
  8. Current Working Directory from \$HOME      9. Current History Event Number\n
  10. Date (yy-mm-dd)   11. Date (mm-dd-yy)     12. Date (day-dd)  13. Time (12-Hour, AM/PM)\n 
  14. Time (24-Hour w/ Seconds)    15. Number of Jobs    16. Current Value of \$SHLVL\n
  17. Name of the script, sourced file, or shell function that Zsh is currently executing\n\n
Symbols/Custom Text/Emoji:\n
  18. @  19. #  20. !  21. $  22. %  23. *  24. &  25. -  26. _  27. :  28. ~\n
  29. |  30. .  31. ?  32. ,  33. ;  34. ^  35. +  36. =  37. /  38. ""\  39. \"\n
  40. '  41. (  42. )  43. [  44. ]  45. {  46. }  47. <  48. >\n
  49. Space  50. Custom Text  51. Emoji\n"

  # Parts Dicionary - Each Index has each respective value from menu
  parts_dictionary=('%n' '%m' '%M' '%l' '%#' '%?' '%d'
  '%~' '%h' '%D' '%W' '%w' '%t' '%*' '%j' '%L' '%N'
  '@' '#' '!' '$' '%' '*' '&' '-' '_' ':'
  '~' '|' '.' '?' ',' ';' '^' '+' '=' '/'
  '\' '"' "'" '(' ')' '[' ']' '{' '}' '<' '>')

  # For User to know what they're coloring
  # Doesn't need custom text choice
  parts_choices=('Username' 'Hostname (Short)' 'Hostname (Full)' "Shell's TTY"
  'isRoot' 'Return Status of Last Command' 'Current Working Directory'
  'Current Working Directory from $HOME' 'Current History Event Number'
  'Date (yy-mm-dd)' 'Date (mm-dd-yy)' 'Date (day-dd)' 'Time (12-Hour, AM/PM)' 'Time (24-Hour w/ Seconds)'
  'Number of Jobs' 'Current Value of $SHLVL' 'Name of currently executed by Zsh'
  '@' '#' '!' '$' '%' '*' '&' '-' '_' ':' '~' '|' '.' '?' ',' ';'
  '^' '+' '=' '/' '\' '"' "'" '(' ')' '[' ']' '{' '}' '<' '>' 'Space')
elif [[ "$TYPESHELL" =~ ^[Bb]$ ]] ; then
  echo -e "\nEnter the numbers in order of what you want your prompt to consist of:"
  echo -e "----------------------------------------------------------------------\n"
  echo -e "Variables:\n
  1. Username     2. Hostname (Short)    3. Hostname (Full)    4. Shell's TTY\n
  5. Return Status of Last Command      6. Current Working Directory\n
  7. Current Working Directory from \$HOME      8. Current History Event Number\n
  9. Date (Weekday, Month, Date)     10. Time (24-Hour HH:MM:SS)     11. Time (12-Hour HH:MM:SS)\n 
  12. Time (AM/PM)     13. Time (Without Seconds)    14. Bash Version (Short)   1 5. Bash Version (Full)\n
  16. Number of Jobs    17. isRoot ($ == Not Root, # == Root)\n\n
Symbols/Custom Text/Emoji:\n
  18. @  19. #  20. !  21. $  22. %  23. *  24. &  25. -  26. _  27. :  28. ~\n
  29. |  30. .  31. ?  32. ,  33. ;  34. ^  35. +  36. =  37. /  38. ""\  39. \"\n
  40. '  41. (  42. )  43. [  44. ]  45. {  46. }  47. <  48. >\n
  49. Space  50. Custom Text  51. Emoji\n"

  parts_dictionary=('\u' '\h' '\H' '\l' '\?' '\w'
  '\W' '\!' '\d' '\t' '\T' '\@' '\A' '\v' '\V' '\j' '\$'
  '@' '#' '!' '$' '%' '*' '&' '-' '_' ':'
  '~' '|' '.' '?' ',' ';' '^' '+' '=' '/'
  '\' '"' "'" '(' ')' '[' ']' '{' '}' '<' '>')

  parts_choices=('Username' 'Hostname (Short)' 'Hostname (Full)' "Shell's TTY" 'Return Status of Last Command'
  'Current Working Directory' 'Current Working Directory from $HOME' 'Current History Event Number'
  'Date (Weekday, Month, Date)' 'Time (24-Hour HH:MM:SS)' 'Time (12-Hour HH:MM:SS)' 'Time (AM/PM)'
  'Time (Without Seconds)' 'Bash Version (Short)' 'Bash Version (Full)' 'Number of Jobs'
  'isRoot' '@' '#' '!' '$' '%' '*' '&' '-' '_' ':'
  '~' '|' '.' '?' ',' ';' '^' '+' '=' '/'
  '\' '"' "'" '(' ')' '[' ']' '{' '}' '<' '>' 'Space')
fi

# Chose Parts
echo -e "Type 'n' or 'N' when you're finished\n"
part_array=() # Append to this empty array
custom_text=() # Use if custom text is
declare -i repeat=1

# Keep entering options until 'n' or 'N' also has error handling
while :; do  # No argument for break, keep going until a break is found in the body
  read -p "Enter a number choice: " CHOICE
  if [[ "$CHOICE" =~ ^[Nn]$ ]] ; then    # If choice is 'n' or 'N' (regex)
    break  # Break while-loop
  elif [[ "$CHOICE" == '51' ]] ; then  # If emoji
    read -p "Enter Emoji: " CUSTEXT
    part_array+=($CHOICE)
    custom_text+=("$CUSTEXT")
  elif [[ "$CHOICE" == '50' ]] ; then  # If custom text
    read -p "Enter Custom Text: " CUSTEXT
    part_array+=($CHOICE)
    # Escape quotes & backslashes
    custom_text+=$(printf "%q" "$CUSTEXT") # Needed for printing custom text
  elif [[ $CHOICE =~ ^[0-9]+$ ]] ; then  # If it's a number
    if ((CHOICE >= 1 && CHOICE <= 49)); then  # And it's in range (50 & 51 already handled)
      part_array+=($CHOICE)  # Append to array
    else
      echo "Enter a valid number! (1-51)"
    fi
  else
    echo "Enter a valid number! (1-51)"  
  fi
done


if [ ${#part_array[@]} -eq 0 ]; then  # Check if part_array is empty (if size is zero)
    echo -e "\nNothing added to prompt, exiting!"  # If empty, exit.
    exit 1
fi


echo -e "\n\nEnter the number of the color you want, in order with each part of the prompt you chose:"
echo -e  "----------------------------------------------------------------------------------------\n"
if [[ $* != *--light-mode* ]]; then
  # Dark mode contrast
  echo -e "Foregrounds:  1. \e[38;5;15mWhite\e[0m     14. \e[1;30m\e[38;5;15mBold White\e[0m             Backgrounds:  28. \e[0;30m\e[48;5;15mWhite\e[0m         41. \e[0;30m\e[48;5;255mBright White\e[0m\n"
  echo -e "              2. \e[0;30m\e[48;5;15mBlack\e[0m     15. \e[1;30m\e[48;5;15mBold Black\e[0m                           29. \e[38;5;15m\e[40mBlack\e[0m         42. \e[100mBright Black\e[0m\n"
  echo -e "              3. \e[0;31mRed\e[0m       16. \e[1;31mBold Red\e[0m                             30. \e[41mRed\e[0m           43. \e[0;30m\e[101mBright Red\e[0m\n"
  echo -e "              4. \e[0;32mGreen\e[0m     17. \e[1;32mBold Green\e[0m                           31. \e[42mGreen\e[0m         44. \e[0;30m\e[102mBright Green\e[0m\n"
  echo -e "              5. \e[38;5;22mForest\e[0m    18. \e[1;30m\e[38;5;22mBold Forest\e[0m                          32. \e[48;5;22mForest\e[0m        45. \e[0;30m\e[48;5;28mBright Forest\e[0m\n"
  echo -e "              6. \e[0;33mYellow\e[0m    19. \e[1;33mBold Yellow\e[0m                          33. \e[43mYellow\e[0m        46. \e[0;30m\e[103mBright Yellow\e[0m\n"
  echo -e "              7. \e[38;5;202mOrange\e[0m    20. \e[1;30m\e[38;5;202mBold Orange\e[0m                          34. \e[48;5;202mOrange\e[0m        47. \e[0;30m\e[48;5;214mBright Orange\e[0m\n"
  echo -e "              8. \e[38;5;27mBlue\e[0m      21. \e[1;30m\e[38;5;27mBold Blue\e[0m                            35. \e[44mBlue\e[0m          48. \e[0;30m\e[104mBright Blue\e[0m\n"
  echo -e "              9. \e[0;36mCyan\e[0m      22. \e[1;36mBold Cyan\e[0m                            36. \e[46mCyan\e[0m          49. \e[0;30m\e[106mBright Cyan\e[0m\n"
  echo -e "             10. \e[0;35mPurple\e[0m    23. \e[1;35mBold Purple\e[0m                          37. \e[45mPurple\e[0m        50. \e[0;30m\e[105mBright Purple\e[0m\n"
  echo -e "             11. \e[38;5;93mViolet\e[0m    24. \e[1;30m\e[38;5;93mBold Violet\e[0m                          38. \e[48;5;93mViolet\e[0m        51. \e[0;30m\e[48;5;99mBright Violet\e[0m\n"
  echo -e "             12. \e[38;5;201mPink\e[0m      25. \e[1;30m\e[38;5;201mBold Pink\e[0m                            39. \e[48;5;201mPink\e[0m          52. \e[0;30m\e[48;5;207mBright Pink\e[0m\n"
  echo -e "             13. \e[0;37mGray\e[0m      26. \e[1;37mBold Gray\e[0m                            40. \e[0;30m\e[47mGray\e[0m          53. \e[0;30m\e[107mBright Gray\e[0m\n"
  echo -e "             27. No Foreground Color / No Change                    54. No Background Color / No Change\e[0m\n\n"
else
  # Light mode contrast
  echo -e "Foregrounds:  1. \e[38;5;15m\e[40mWhite\e[0m     14. \e[1;30m\e[38;5;15m\e[40mBold White\e[0m             Backgrounds:  28. \e[0;30m\e[48;5;15mWhite\e[0m         41. \e[0;30m\e[48;5;255mBright White\e[0m\n"
  echo -e "              2. \e[0;30mBlack\e[0m     15. \e[1;30mBold Black\e[0m                           29. \e[38;5;15m\e[40mBlack\e[0m         42. \e[38;5;15m\e[100mBright Black\e[0m\n"
  echo -e "              3. \e[0;31mRed\e[0m       16. \e[1;31mBold Red\e[0m                             30. \e[38;5;15m\e[41mRed\e[0m           43. \e[0;30m\e[101mBright Red\e[0m\n"
  echo -e "              4. \e[0;32mGreen\e[0m     17. \e[1;32mBold Green\e[0m                           31. \e[38;5;15m\e[42mGreen\e[0m         44. \e[0;30m\e[102mBright Green\e[0m\n"
  echo -e "              5. \e[38;5;22mForest\e[0m    18. \e[1;30m\e[38;5;22mBold Forest\e[0m                          32. \e[38;5;15m\e[48;5;22mForest\e[0m        45. \e[38;5;15m\e[48;5;28mBright Forest\e[0m\n"
  echo -e "              6. \e[0;33mYellow\e[0m    19. \e[1;33mBold Yellow\e[0m                          33. \e[38;5;15m\e[43mYellow\e[0m        46. \e[0;30m\e[103mBright Yellow\e[0m\n"
  echo -e "              7. \e[38;5;202mOrange\e[0m    20. \e[1;30m\e[38;5;202mBold Orange\e[0m                          34. \e[38;5;15m\e[48;5;202mOrange\e[0m        47. \e[0;30m\e[48;5;214mBright Orange\e[0m\n"
  echo -e "              8. \e[38;5;27mBlue\e[0m      21. \e[1;30m\e[38;5;27mBold Blue\e[0m                            35. \e[38;5;15m\e[44mBlue\e[0m          48. \e[38;5;15m\e[104mBright Blue\e[0m\n"
  echo -e "              9. \e[0;36mCyan\e[0m      22. \e[1;36mBold Cyan\e[0m                            36. \e[38;5;15m\e[46mCyan\e[0m          49. \e[0;30m\e[106mBright Cyan\e[0m\n"
  echo -e "             10. \e[0;35mPurple\e[0m    23. \e[1;35mBold Purple\e[0m                          37. \e[38;5;15m\e[45mPurple\e[0m        50. \e[0;30m\e[105mBright Purple\e[0m\n"
  echo -e "             11. \e[38;5;93mViolet\e[0m    24. \e[1;30m\e[38;5;93mBold Violet\e[0m                          38. \e[38;5;15m\e[48;5;93mViolet\e[0m        51. \e[0;30m\e[48;5;99mBright Violet\e[0m\n"
  echo -e "             12. \e[38;5;201mPink\e[0m      25. \e[1;30m\e[38;5;201mBold Pink\e[0m                            39. \e[38;5;15m\e[48;5;201mPink\e[0m          52. \e[0;30m\e[48;5;207mBright Pink\e[0m\n"
  echo -e "             13. \e[0;37mGray\e[0m      26. \e[1;37mBold Gray\e[0m                            40. \e[0;30m\e[47mGray\e[0m          53. \e[0;30m\e[107mBright Gray\e[0m\n"
  echo -e "             27. No Foreground Color / No Change                    54. No Background Color / No Change\e[0m\n\n"
fi


# Parts Dicionary - Each Index has each respective value from menu (Foregrounds and backgrounds)
color_dictionary=('\e[38;5;15m' '\e[0;30m' '\e[0;31m' '\e[0;32m'
'\e[38;5;22m' '\e[0;33m' '\e[38;5;202m' '\e[38;5;27m'
'\e[0;36m' '\e[0;35m' '\e[38;5;93m' '\e[38;5;201m'
'\e[0;37m' '\e[1;30m\e[38;5;15m' '\e[1;30m' '\e[1;31m'
'\e[1;32m' '\e[1;30m\e[38;5;22m' '\e[1;33m' '\e[1;30m\e[38;5;202m'
'\e[1;30m\e[38;5;27m' '\e[1;36m' '\e[1;35m' '\e[1;30m\e[38;5;93m'
'\e[1;30m\e[38;5;201m' '\e[1;37m' '' '\e[48;5;15m'
'\e[40m' '\e[41m' '\e[42m' '\e[48;5;22m'
'\e[43m' '\e[48;5;202m' '\e[44m' '\e[46m'
'\e[45m' '\e[48;5;93m' '\e[48;5;201m' '\e[47m'
'\e[48;5;255m' '\e[100m' '\e[101m' '\e[102m'
'\e[48;5;28m' '\e[103m' '\e[48;5;214m' '\e[104m'
'\e[106m' '\e[105m' '\e[48;5;99m' '\e[48;5;207m' '\e[107m' '')

# Chose Colors
color_array=() # Append to this empty array
declare -i counter=0   # Required for array indexing
for i in "${part_array[@]}"; do

  # Arrays start from 0
  i=$((i - 1))

  # Do FG and BG adding in parts, so if there's an error,
  # so we don't have to redo both, just the culprit
  while :; do  # Let it do input prompts, then do check at the end

    if [[ "$i" == '49' || "$i" == '50' ]]; then   # If its the custom text, just print it from part_array
      read -p "Enter ${UNDERLINE}Foreground${NORMAL} Color Number for ${custom_text[counter]}: " FG  # Holds the actual values of menu, Bash/Zsh arrays start at 1
    elif [[ "$i" == '48' ]] ; then  # No FG for space char
      break
    elif [[ "$i" == '26' ]] ; then  # double ":" issue
      read -p "Enter ${UNDERLINE}Foreground${NORMAL} Color Number for : : " FG
    else
      read -p "Enter ${UNDERLINE}Foreground${NORMAL} Color Number for ${parts_choices[i]}: " FG
    fi

    # Filtering each part's color inputs
    declare -i FG_allow=0  # False by default
    if [[ -n "$FG" && $FG =~ ^[0-9]+$ ]] ; then  # Check if fg is a number and used (sometimes not used, like with spaces)
      if ((FG >= 1 && FG <= 27)); then  # Check if it's between 1-27
        FG_allow=1  # Passes FG check
        break  # On correct, move onto background
      else  # Never need to break on foreground, still need to check background
        echo "The Foreground number you entered was invalid. Make sure to use a valid Foreground number this time! (1-17)"
      fi     # ^^Go back to top of while loop and ask for input again
    else
      echo "The Foreground number you entered was invalid. Make sure to use a valid Foreground number this time! (1-17)"
    fi
  done

  # Add BG for item after having done FG
  while :; do
    if [[ "$i" == '49' || "$i" == '50' ]] ; then   # If its the custom text, just print it from part_array
      read -p "Enter ${UNDERLINE}Background${NORMAL} Color Number for ${custom_text[counter]}: " BG
    elif [[ "$i" == '48' ]] ; then  # If it's a space, no need for a forgeground choice, just a background
      read -p "Enter ${UNDERLINE}Background${NORMAL} Color Number for ${parts_choices[i]}: " BG  # Iterate differently for space choice for final prompt logic
    elif [[ "$i" == '26' ]] ; then  # double ":" issue
      read -p "Enter ${UNDERLINE}Background${NORMAL} Color Number for : : " BG
    else
      read -p "Enter ${UNDERLINE}Background${NORMAL} Color Number for ${parts_choices[i]}: " BG
    fi

    declare -i BG_allow=0 # False by default
    if [[ $BG =~ ^[0-9]+$ ]] ; then  # Always need bg, no need to check if its used
      if ((BG >= 28 && BG <= 54)); then  # Check if it's between 28-54
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
  if [[ "$i" == '49' || "$i" == '50' ]] && [[ "$FG_allow" == '1' ]] && [[ "$BG_allow" == '1' ]]; then  # Custom_text case
    counter+=1
    color_array+=($((FG - 1)) $((BG - 1)))
  elif [[ "$i" == '48' ]] && [[ "$BG_allow" == '1' ]]; then  # Spaces case
    color_array+=($((BG - 1)))
  elif [[ "$i" != '48' ]] && [[ "$i" != '49' && "$i" != '50' ]] && [[ "$FG_allow" == '1' ]] && [[ "$BG_allow" == '1' ]]; then  # Normal case, any choice that's not 47 or 48
    color_array+=($((FG - 1)) $((BG - 1)))
  fi
done

# Create Final Prompt and Review Prompt
echo -e "\nThis is a preview of how your prompt will look:\n"
review_prompt=""
final_prompt=""
declare -i counter=0   # Required for array indexing
declare -i counter2=0   # Required for array indexing of custom text
for i in "${part_array[@]}"; do

  # Arrays start from 0
  i=$((i - 1))

  if [[ "$i" == '48' ]] ; then  # If it's a space, no fg needed, first number will act as background
    review_prompt+=${color_dictionary[color_array[counter]]}  # Just print a space char, don't actually print "Space"
    # Add proper escapes '%{ %}' for Zsh and \[ \] for Bash
    if [[ "$TYPESHELL" =~ ^[Zz]$ ]] ; then
      final_prompt+="%{${color_dictionary[color_array[counter]]}%}"
    else
      final_prompt+="\\[${color_dictionary[color_array[counter]]}\\]"
    fi
    counter+=1  # Only need to go up 1, not trying to skip a second number in a pair this time
  else
    next=$(($counter+1))  # +1 to print both fg and bg pair
    review_prompt+=${color_dictionary[color_array[counter]]}
    review_prompt+=${color_dictionary[color_array[next]]}
    if [[ "$TYPESHELL" =~ ^[Zz]$ ]] ; then
      final_prompt+="%{${color_dictionary[color_array[counter]]}%}"
      final_prompt+="%{${color_dictionary[color_array[next]]}%}"
    else
      final_prompt+="\\[${color_dictionary[color_array[counter]]}\\]"
      final_prompt+="\\[${color_dictionary[color_array[next]]}\\]"
    fi
    counter+=2  # Colors come in two's, don't add bg color twice everytime
  fi
  if [[ "$i" == '49' || "$i" == '50' ]] ; then  # If it's custom text, use $custom_text array
    review_prompt+=${custom_text[counter2]}  # Has its own counter that goes up by 1's
    review_prompt+="\e[0m" # Don't let anything bleed over
    final_prompt+=${custom_text[counter2]}
    if [[ "$TYPESHELL" =~ ^[Zz]$ ]] ; then
      final_prompt+="%{\e[0m%}"
    else
      final_prompt+="\\[\e[0m\\]"
    fi
    counter2+=1 # Only go up if more custom text found
  elif [[ "$i" == '48' ]] ; then  # Special case, Add space
    review_prompt+=' '
    review_prompt+="\e[0m" # Don't let anything bleed over
    final_prompt+=' '
    if [[ "$TYPESHELL" =~ ^[Zz]$ ]] ; then
      final_prompt+="%{\e[0m%}"
    else
      final_prompt+="\\[\e[0m\\]"
    fi
  elif [[ "$i" == '39' ]] ; then  # Special case for '
    review_prompt+="'"
    review_prompt+="\e[0m"
    final_prompt+="\'"
    if [[ "$TYPESHELL" =~ ^[Zz]$ ]] ; then
      final_prompt+="%{\e[0m%}"
    else
      final_prompt+="\\[\e[0m\\]"
    fi
  elif [[ "$i" == '37' ]] ; then  # Special case, Add backslash (escape sequence logic)
    review_prompt+='\\'
    review_prompt+="\e[0m"
    final_prompt+='\\\\'  # Two escape \\'s for two \\ to create literal '\\'
    if [[ "$TYPESHELL" =~ ^[Zz]$ ]] ; then
      final_prompt+="%{\e[0m%}"
    else
      final_prompt+="\\[\e[0m\\]"
    fi
  elif [[ "$i" == '21' ]] ; then  # Special case for percent, dont make it a zsh variable
    review_prompt+='%'
    review_prompt+="\e[0m"
    if [[ "$TYPESHELL" =~ ^[Zz]$ ]] ; then
      final_prompt+='%%'  # Double percent creates single % in Zsh since It's a special char there
      final_prompt+="%{\e[0m%}"
    else
      final_prompt+='%'
      final_prompt+="\\[\e[0m\\]"
    fi
  else   # If normal
    review_prompt+=${parts_choices[i]}
    review_prompt+="\e[0m"
    final_prompt+=${parts_dictionary[i]}
    if [[ "$TYPESHELL" =~ ^[Zz]$ ]] ; then
      final_prompt+="%{\e[0m%}"
    else
      final_prompt+="\\[\e[0m\\]"
    fi
  fi
done


echo -e "$review_prompt\e[0m\n"


# Comment out old prompt definitions to avoid conflicts
comment_out() {
  # sed on Mac requires extra '' parameter
  if [[ $(uname) == *"Darwin"* ]]; then
    if [[ "$TYPESHELL" =~ ^[Zz]$ ]]; then
      if [[ "$TYPEPROMPT" =~ ^[Pp]$ ]]; then
        # Add comments above line
        gawk -i inplace '/^([[:space:]].*)?(export[[:space:]])?PROMPT=/{ if(prev !~ /^([[:space:]].*)?# Commented out by Shell-Color-Prompt-Tool/) { split($0,parts,"(export[[:space:]])?PROMPT=");NR==FNR-1;print parts[1] "# Commented out by Shell-Color-Prompt-Tool"}} {prev=$0; print $0}' ~/.zshrc
        gawk -i inplace '/^([[:space:]].*)?(export[[:space:]])?PS1=/{ if(prev !~ /^([[:space:]].*)?# Commented out by Shell-Color-Prompt-Tool/) { split($0,parts,"(export[[:space:]])?PS1=");NR==FNR-1;print parts[1] "# Commented out by Shell-Color-Prompt-Tool"}} {prev=$0; print $0}' ~/.zshrc
        
        # Comment out actual line
        sed -i '' '/^[[:space:]]*\(\(export \)\{0,1\}PROMPT=\)/s/^\([[:space:]]*\)/\1#/' ~/.zshrc
        sed -i '' '/^[[:space:]]*\(\(export \)\{0,1\}PS1=\)/s/^\([[:space:]]*\)/\1#/' ~/.zshrc
      elif [[ "$TYPEPROMPT" =~ ^[Rr]$ ]] ; then
        gawk -i inplace '/^([[:space:]].*)?(export[[:space:]])?RPROMPT=/{ if(prev !~ /^([[:space:]].*)?# Commented out by Shell-Color-Prompt-Tool/) { split($0,parts,"(export[[:space:]])?RPROMPT=");NR==FNR-1;print parts[1] "# Commented out by Shell-Color-Prompt-Tool"}} {prev=$0; print $0}' ~/.zshrc

        sed -i '' '/^[[:space:]]*\(\(export \)\{0,1\}RPROMPT=\)/s/^\([[:space:]]*\)/\1#/' ~/.zshrc
      elif [[ "$TYPEPROMPT" =~ ^[Bb]$ ]] ; then
        gawk -i inplace '/^([[:space:]].*)?(export[[:space:]])?PROMPT=/{ if(prev !~ /^([[:space:]].*)?# Commented out by Shell-Color-Prompt-Tool/) { split($0,parts,"(export[[:space:]])?PROMPT=");NR==FNR-1;print parts[1] "# Commented out by Shell-Color-Prompt-Tool"}} {prev=$0; print $0}' ~/.zshrc
        gawk -i inplace '/^([[:space:]].*)?(export[[:space:]])?PS1=/{ if(prev !~ /^([[:space:]].*)?# Commented out by Shell-Color-Prompt-Tool/) { split($0,parts,"(export[[:space:]])?PS1=");NR==FNR-1;print parts[1] "# Commented out by Shell-Color-Prompt-Tool"}} {prev=$0; print $0}' ~/.zshrc
        gawk -i inplace '/^([[:space:]].*)?(export[[:space:]])?RPROMPT=/{ if(prev !~ /^([[:space:]].*)?# Commented out by Shell-Color-Prompt-Tool/) { split($0,parts,"(export[[:space:]])?RPROMPT=");NR==FNR-1;print parts[1] "# Commented out by Shell-Color-Prompt-Tool"}} {prev=$0; print $0}' ~/.zshrc        

        sed -i '' '/^[[:space:]]*\(\(export \)\{0,1\}PROMPT=\)/s/^\([[:space:]]*\)/\1#/' ~/.zshrc
        sed -i '' '/^[[:space:]]*\(\(export \)\{0,1\}PS1=\)/s/^\([[:space:]]*\)/\1#/' ~/.zshrc
        sed -i '' '/^[[:space:]]*\(\(export \)\{0,1\}RPROMPT=\)/s/^\([[:space:]]*\)/\1#/' ~/.zshrc
      fi
    elif [[ "$TYPESHELL" =~ ^[Bb]$ ]] ; then
        gawk -i inplace '/^([[:space:]].*)?(export[[:space:]])?PS1=/{ if(prev !~ /^([[:space:]].*)?# Commented out by Shell-Color-Prompt-Tool/) { split($0,parts,"(export[[:space:]])?PS1=");NR==FNR-1;print parts[1] "# Commented out by Shell-Color-Prompt-Tool"}} {prev=$0; print $0}' ~/.bashrc

        sed -i '' '/^[[:space:]]*\(\(export \)\{0,1\}PS1=\)/s/^\([[:space:]]*\)/\1#/' ~/.bashrc
    fi
  # Linux - Not Mac
  else
    if [[ "$TYPESHELL" =~ ^[Zz]$ ]]; then
      if [[ "$TYPEPROMPT" =~ ^[Pp]$ ]] ; then
        awk -i inplace '/^([[:space:]].*)?(export[[:space:]])?PROMPT=/{ if(prev !~ /^([[:space:]].*)?# Commented out by Shell-Color-Prompt-Tool/) { split($0,parts,"(export[[:space:]])?PROMPT=");NR==FNR-1;print parts[1] "# Commented out by Shell-Color-Prompt-Tool"}} {prev=$0; print $0}' ~/.zshrc
        awk -i inplace '/^([[:space:]].*)?(export[[:space:]])?PS1=/{ if(prev !~ /^([[:space:]].*)?# Commented out by Shell-Color-Prompt-Tool/) { split($0,parts,"(export[[:space:]])?PS1=");NR==FNR-1;print parts[1] "# Commented out by Shell-Color-Prompt-Tool"}} {prev=$0; print $0}' ~/.zshrc

        sed -i '/^[[:space:]]*\(\(export \)\{0,1\}PROMPT=\)/s/^\([[:space:]]*\)/\1#/' ~/.zshrc
        sed -i '/^[[:space:]]*\(\(export \)\{0,1\}PS1=\)/s/^\([[:space:]]*\)/\1#/' ~/.zshrc
      elif [[ "$TYPEPROMPT" =~ ^[Rr]$ ]] ; then
        awk -i inplace '/^([[:space:]].*)?(export[[:space:]])?RPROMPT=/{ if(prev !~ /^([[:space:]].*)?# Commented out by Shell-Color-Prompt-Tool/) { split($0,parts,"(export[[:space:]])?RPROMPT=");NR==FNR-1;print parts[1] "# Commented out by Shell-Color-Prompt-Tool"}} {prev=$0; print $0}' ~/.zshrc

        sed -i '/^[[:space:]]*\(\(export \)\{0,1\}RPROMPT=\)/s/^\([[:space:]]*\)/\1#/' ~/.zshrc
      elif [[ "$TYPEPROMPT" =~ ^[Bb]$ ]] ; then
        awk -i inplace '/^([[:space:]].*)?(export[[:space:]])?PROMPT=/{ if(prev !~ /^([[:space:]].*)?# Commented out by Shell-Color-Prompt-Tool/) { split($0,parts,"(export[[:space:]])?PROMPT=");NR==FNR-1;print parts[1] "# Commented out by Shell-Color-Prompt-Tool"}} {prev=$0; print $0}' ~/.zshrc
        awk -i inplace '/^([[:space:]].*)?(export[[:space:]])?PS1=/{ if(prev !~ /^([[:space:]].*)?# Commented out by Shell-Color-Prompt-Tool/) { split($0,parts,"(export[[:space:]])?PS1=");NR==FNR-1;print parts[1] "# Commented out by Shell-Color-Prompt-Tool"}} {prev=$0; print $0}' ~/.zshrc
        awk -i inplace '/^([[:space:]].*)?(export[[:space:]])?RPROMPT=/{ if(prev !~ /^([[:space:]].*)?# Commented out by Shell-Color-Prompt-Tool/) { split($0,parts,"(export[[:space:]])?RPROMPT=");NR==FNR-1;print parts[1] "# Commented out by Shell-Color-Prompt-Tool"}} {prev=$0; print $0}' ~/.zshrc        

        sed -i '/^[[:space:]]*\(\(export \)\{0,1\}PROMPT=\)/s/^\([[:space:]]*\)/\1#/' ~/.zshrc
        sed -i '/^[[:space:]]*\(\(export \)\{0,1\}PS1=\)/s/^\([[:space:]]*\)/\1#/' ~/.zshrc
        sed -i '/^[[:space:]]*\(\(export \)\{0,1\}RPROMPT=\)/s/^\([[:space:]]*\)/\1#/' ~/.zshrc
      fi
    elif [[ "$TYPESHELL" =~ ^[Bb]$ ]] ; then
        awk -i inplace '/^([[:space:]].*)?(export[[:space:]])?PS1=/{ if(prev !~ /^([[:space:]].*)?# Commented out by Shell-Color-Prompt-Tool/) { split($0,parts,"(export[[:space:]])?PS1=");NR==FNR-1;print parts[1] "# Commented out by Shell-Color-Prompt-Tool"}} {prev=$0; print $0}' ~/.bashrc

        sed -i '/^[[:space:]]*\(\(export \)\{0,1\}PS1=\)/s/^\([[:space:]]*\)/\1#/' ~/.bashrc
    fi
  fi
}

read -p "Would you like to make this your prompt? (Y/n): " CHOICE

if [[ "$CHOICE" =~ ^[Yy]$ ]] ; then    # If choice is 'y' or 'Y' (regex)
  
  if [[ $* == *--comment-out* ]]; then
    comment_out
  fi

  if [[ $* == *--no-extras* ]]; then
    if [[ "$TYPESHELL" =~ ^[Zz]$ ]] ; then
      echo -e "\n\n# Added by Shell-Color-Prompt-Tool" >> ~/.zshrc

      if [[ "$TYPEPROMPT" =~ ^[Pp]$ ]] ; then
        # We need an newline here so each new prompt has spacing from the last one
        # And then a space at the end as a buffer between the prompt and the commands
        echo -e "export PROMPT=$'$final_prompt'" >> ~/.zshrc
      elif [[ "$TYPEPROMPT" =~ ^[Rr]$ ]] ; then
        echo -e "export RPROMPT=$'$final_prompt'" >> ~/.zshrc
      elif [[ "$TYPEPROMPT" =~ ^[Bb]$ ]] ; then
        echo -e "export PROMPT=$'$final_prompt'" >> ~/.zshrc
        echo -e "export RPROMPT=$'$final_prompt'" >> ~/.zshrc
      fi
    elif [[ "$TYPESHELL" =~ ^[Bb]$ ]] ; then
      echo -e "\n\n# Added by Shell-Color-Prompt-Tool" >> ~/.bashrc

      echo -e "export PS1=$'$final_prompt'" >> ~/.bashrc
    fi
  else
    if [[ "$TYPESHELL" =~ ^[Zz]$ ]] ; then
      echo -e "\n\n# Added by Shell-Color-Prompt-Tool" >> ~/.zshrc

      if [[ "$TYPEPROMPT" =~ ^[Pp]$ ]] ; then
        # We need an newline here so each new prompt has spacing from the last one
        # And then a space at the end as a buffer between the prompt and the commands
        echo -e "export PROMPT=$'\\\n$final_prompt '" >> ~/.zshrc
      elif [[ "$TYPEPROMPT" =~ ^[Rr]$ ]] ; then
        echo -e "export RPROMPT=$'\\\n$final_prompt '" >> ~/.zshrc
      elif [[ "$TYPEPROMPT" =~ ^[Bb]$ ]] ; then
        echo -e "export PROMPT=$'\\\n$final_prompt '" >> ~/.zshrc
        echo -e "export RPROMPT=$'\\\n$final_prompt '" >> ~/.zshrc
      fi
    elif [[ "$TYPESHELL" =~ ^[Bb]$ ]] ; then
      echo -e "\n\n# Added by Shell-Color-Prompt-Tool" >> ~/.bashrc

      echo -e "export PS1=$'\\\n$final_prompt '" >> ~/.bashrc
    fi
  fi

  # Disable Oh My Zsh theme which could prevent our prompt from applying
  if [[ $* == *--omz* ]] ; then
    if [[ $(uname) == *"Darwin"* ]] ; then
      awk -i inplace '/^([[:space:]].*)?(export[[:space:]])?ZSH_THEME=/{ if(prev !~ /^([[:space:]].*)?# Commented out by Shell-Color-Prompt-Tool/) { split($0,parts,"(export[[:space:]])?ZSH_THEME=");NR==FNR-1;print parts[1] "# Commented out by Shell-Color-Prompt-Tool"}} {prev=$0; print $0}' ~/.zshrc

      sed -i '' '/^[[:space:]]*\(\(export \)\{0,1\}ZSH\_THEME=\)/s/^\([[:space:]]*\)/\1#/' ~/.zshrc
    else
      awk -i inplace '/^([[:space:]].*)?(export[[:space:]])?ZSH_THEME=/{ if(prev !~ /^([[:space:]].*)?# Commented out by Shell-Color-Prompt-Tool/) { split($0,parts,"(export[[:space:]])?ZSH_THEME=");NR==FNR-1;print parts[1] "# Commented out by Shell-Color-Prompt-Tool"}} {prev=$0; print $0}' ~/.zshrc

      sed -i '/^[[:space:]]*\(\(export \)\{0,1\}ZSH\_THEME=\)/s/^\([[:space:]]*\)/\1#/' ~/.zshrc
    fi
  fi

  echo -e "\nPrompt Saved Successfully! Restart your Terminal now!"
else
  echo -e "\nPrompt not saved, exiting!"
fi
