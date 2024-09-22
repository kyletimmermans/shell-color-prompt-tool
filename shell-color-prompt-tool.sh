#!/usr/bin/env bash



# Shell-Color-Prompt-Tool v4.0



### Global Variables ###



version="4.0"

# Title Colors / Format Vars
BOLD="$(tput bold)"
UNDERLINE="$(tput smul)"
NORMAL="$(tput sgr0)"
GREEN='\e[1;32m'
RED='\e[1;31m'
BLUE='\e[1;34m'
PURPLE='\e[1;35m'
CYAN='\e[1;36m'
YELLOW='\e[1;33m'
BLACK='\e[0;30m'
RC='\e[0m'  # Reset Color



### Functions ###



# Version Flag
version() {
  echo -e "\nShell-${GREEN}C${RED}o${BLUE}l${PURPLE}o${CYAN}r${RC}-Prompt-Tool v${version}${NORMAL}\n"

  newest_version=$(curl -s https://api.github.com/repos/kyletimmermans/shell-color-prompt-tool/releases/latest | grep '"name": "v' | awk -F '"name": "v' '{print $2}' | awk -F '"' '{print $1}')

  # If not empty string - Not error
  if [[ $newest_version != "" ]]; then
    # If local version not the same as latest GitHub release, then notify
    if [[ "$version" != "$newest_version" ]]; then
      echo -e "\nNewer version available on GitHub - v${newest_version}!\n"
      echo -e "github.com/kyletimmermans/shell-color-prompt-tool\n"
    fi
  else
      echo -e "\n${RED}ERR${RC}: Could not connect to GitHub to check for updates\n" > /dev/stderr
  fi

  exit 0
}


# Usage/Help Flag
usage() {
  echo -e "\n${UNDERLINE}Usage${NORMAL}: Run this program and use the interactive prompt to create your Zsh/Bash prompt\n\n"
  echo -e "${UNDERLINE}Flags${NORMAL}:\n"
  echo -e "${BOLD}--usage${NORMAL}              Pulls up this menu\n"
  echo -e "${BOLD}--version${NORMAL}            Get program version. Reveal if a newer version is available on GitHub\n"
  echo -e "${BOLD}--comment-out${NORMAL}        Comment out older prompt lines in .zshrc/.bashrc e.g. PROMPT= / PS1="
  echo -e "                     to help prevent conflicting prompt definitions\n"
  echo -e "${BOLD}--omz${NORMAL}                Disables your 'Oh My Zsh' theme if you have one, which could get in the"
  echo -e "                     way of applying your new prompt\n"
  echo -e "${BOLD}--light-mode${NORMAL}         Better color contrast for the color picker menu on white/light-colored"
  echo -e "                     terminal backgrounds\n"
  echo -e "${BOLD}--no-extras${NORMAL}          Don't automatically add a newline to the start of the prompt and a space"
  echo -e "                     to the end of the prompt\n"
  echo -e "${BOLD}--separate-file${NORMAL}      Place the prompt string in a separate file instead of putting it in"
  echo -e "                     .zshrc/.bashrc for any reason E.g. --separate-file \"test.txt\"\n"
  echo -e "${BOLD}--no-watermarks${NORMAL}      Don't add the \"# Added by Shell-Color-Prompt-Tool\" comment to"
  echo -e "                     .zshrc/.bashrc when adding the prompt string and don't add the"
  echo -e "                     \"# Commented out by Shell-Color-Prompt-Tool\" comment when using"
  echo -e "                     --comment-out or --omz\n\n"
  echo -e "${UNDERLINE}Usage Notes${NORMAL}:\n"
  echo -e "* No need to put a space at the end of your prompt, one will be added automatically."
  echo -e "  Same with a newline at the beginning for proper spacing between actual prompts,"
  echo -e "  one will automatically be added. Disable this feature w/ --no-extras\n"
  echo -e "* If you want to use the --comment-out or --omz flags, you must have 'gawk' and 'gsed'"
  echo -e "  installed. On Mac, you'll need to install both. On Linux, you just need gawk, as"
  echo -e "  gsed should already be your default sed version\n"
  echo -e "* --comment-out and --omz can break the config if the variables that are getting"
  echo -e "  commented out, are defined within things like if-statements\n"
  echo -e "* Use a text editor such as Vim to view the raw components of the prompt definition in"
  echo -e "  .zshrc/.bashrc, as some text editors have trouble displaying the ANSI escape sequences\n"
  echo -e "* Fullscreen terminals will be able to fit the spacing and styling"
  echo -e "  of the interactive prompt the best\n"
  echo -e "* Colors may vary from system to system. When using the Custom RGB option, make sure your"
  echo -e "  terminal supports TRUECOLOR (See github.com/termstandard/colors)\n"
  echo -e "* If your command is too long, \$RPROMPT will visually be temporarily overwritten\n"
  echo -e "* \$RPROMPT cannot contain newlines (\\\n)\n"
  echo -e "* For more prompt expansion variables not listed in this program:"
  echo -e "     Zsh: zsh.sourceforge.io/Doc/Release/Prompt-Expansion.html"
  echo -e "     Bash: www.gnu.org/software/bash/manual/html_node/Controlling-the-Prompt.html\n\n"
  echo -e "${BOLD}github.com/kyletimmermans/shell-color-prompt-tool${NORMAL}\n"

  exit 0
}


# Ensure gawk & gsed usage when using --comment-out or --omz flags
command_check() {
  gawk_needed=false
  gsed_needed=false

  if gawk --version 2>/dev/null | grep -q "GNU"; then
    : # Do nothing - All set
  elif awk --version 2>/dev/null | grep -q "GNU"; then
    gawk() { awk "$@"; }
  else
    echo -e "\n${RED}ERR${RC}: gawk is required for the --comment-out and --omz flags to work\n" > /dev/stderr
    gawk_needed=true
  fi

  if gsed --version 2>/dev/null | grep -q "GNU"; then
    :
  elif sed --version 2>/dev/null | grep -q "GNU"; then
    gsed() { sed "$@"; }
  else
    echo -e "\n${RED}ERR${RC}: gsed is required for the --comment-out and --omz flags to work\n" > /dev/stderr
    gsed_needed=true
  fi

  if [[ $gawk_needed == "true" ]] || [[ $gsed_needed == "true" ]]; then
    exit 1
  fi
}


# Input 'R' 'G' 'B' values for custom RGB
custom_rgb() {
  read -p $'\tChoose R value (0-255): ' R
  while :; do
    if [[ -n "$R" && $R =~ ^[0-9]+$ ]] && (( R >= 0 && R <= 255 )); then
      break
    else
      read -p $'\tPlease choose a valid R number (0-255): ' R
    fi
  done

  read -p $'\tChoose G value (0-255): ' G
  while :; do
    if [[ -n "$G" && $G =~ ^[0-9]+$ ]] && (( G >= 0 && G <= 255 )); then
      break
    else
      read -p $'\tPlease choose a valid G number (0-255): ' G
    fi
  done

  read -p $'\tChoose B value (0-255): ' B
  while :; do
    if [[ -n "$B" && $B =~ ^[0-9]+$ ]] && (( B >= 0 && B <= 255 )); then
      break
    else
      read -p $'\tPlease choose a valid B number (0-255): ' B
    fi
  done

  if [[ $1 == "FG" ]]; then
    echo "\e[38;2;${R};${G};${B}m"
  elif [[ $1 == "BG" ]]; then
    echo "\e[48;2;${R};${G};${B}m"
  fi
}


# Comment out old prompt definitions to avoid conflicts
comment_out() {
  if [[ "$TYPEPROMPT" =~ ^[Ll]$ ]]; then
    if [[ "$nowatermarks" == false ]]; then
      gawk -i inplace '/^([[:space:]]*)?(export[[:space:]])?PROMPT=/{ if(prev !~ /^([[:space:]]*)?# Commented out by Shell-Color-Prompt-Tool/) { match($0,/^([[:space:]]*)/,parts);NR==FNR-1;print parts[1] "# Commented out by Shell-Color-Prompt-Tool"}} {prev=$0; print $0}' ~/.zshrc
      gawk -i inplace '/^([[:space:]]*)?(export[[:space:]])?PS1=/{ if(prev !~ /^([[:space:]]*)?# Commented out by Shell-Color-Prompt-Tool/) { match($0,/^([[:space:]]*)/,parts);NR==FNR-1;print parts[1] "# Commented out by Shell-Color-Prompt-Tool"}} {prev=$0; print $0}' ~/.zshrc
    fi

    gsed -i '/^[[:space:]]*\(\(export \)\{0,1\}PROMPT=\)/s/^\([[:space:]]*\)/\1#/' ~/.zshrc
    gsed -i '/^[[:space:]]*\(\(export \)\{0,1\}PS1=\)/s/^\([[:space:]]*\)/\1#/' ~/.zshrc
  elif [[ "$TYPEPROMPT" =~ ^[Rr]$ ]]; then
    if [[ "$nowatermarks" == false ]]; then
      gawk -i inplace '/^([[:space:]]*)?(export[[:space:]])?RPROMPT=/{ if(prev !~ /^([[:space:]]*)?# Commented out by Shell-Color-Prompt-Tool/) { match($0,/^([[:space:]]*)/,parts);NR==FNR-1;print parts[1] "# Commented out by Shell-Color-Prompt-Tool"}} {prev=$0; print $0}' ~/.zshrc
    fi

    gsed -i '/^[[:space:]]*\(\(export \)\{0,1\}RPROMPT=\)/s/^\([[:space:]]*\)/\1#/' ~/.zshrc
  elif [[ "$TYPEPROMPT" =~ ^[Bb]$ ]]; then
    if [[ "$nowatermarks" == false ]]; then
      gawk -i inplace '/^([[:space:]]*)?(export[[:space:]])?PROMPT=/{ if(prev !~ /^([[:space:]]*)?# Commented out by Shell-Color-Prompt-Tool/) { match($0,/^([[:space:]]*)/,parts);NR==FNR-1;print parts[1] "# Commented out by Shell-Color-Prompt-Tool"}} {prev=$0; print $0}' ~/.zshrc
      gawk -i inplace '/^([[:space:]]*)?(export[[:space:]])?PS1=/{ if(prev !~ /^([[:space:]]*)?# Commented out by Shell-Color-Prompt-Tool/) { match($0,/^([[:space:]]*)/,parts);NR==FNR-1;print parts[1] "# Commented out by Shell-Color-Prompt-Tool"}} {prev=$0; print $0}' ~/.zshrc
      gawk -i inplace '/^([[:space:]]*)?(export[[:space:]])?RPROMPT=/{ if(prev !~ /^([[:space:]]*)?# Commented out by Shell-Color-Prompt-Tool/) { match($0,/^([[:space:]]*)/,parts);NR==FNR-1;print parts[1] "# Commented out by Shell-Color-Prompt-Tool"}} {prev=$0; print $0}' ~/.zshrc
    fi

    gsed -i '/^[[:space:]]*\(\(export \)\{0,1\}PROMPT=\)/s/^\([[:space:]]*\)/\1#/' ~/.zshrc
    gsed -i '/^[[:space:]]*\(\(export \)\{0,1\}PS1=\)/s/^\([[:space:]]*\)/\1#/' ~/.zshrc
    gsed -i '/^[[:space:]]*\(\(export \)\{0,1\}RPROMPT=\)/s/^\([[:space:]]*\)/\1#/' ~/.zshrc
  elif [[ "$TYPEPROMPT" == "" ]]; then
    if [[ "$nowatermarks" == false ]]; then
      gawk -i inplace '/^([[:space:]]*)?(export[[:space:]])?PS1=/{ if(prev !~ /^([[:space:]]*)?# Commented out by Shell-Color-Prompt-Tool/) { match($0,/^([[:space:]]*)/,parts);NR==FNR-1;print parts[1] "# Commented out by Shell-Color-Prompt-Tool"}} {prev=$0; print $0}' ~/.bashrc
    fi

    gsed -i '/^[[:space:]]*\(\(export \)\{0,1\}PS1=\)/s/^\([[:space:]]*\)/\1#/' ~/.bashrc
  fi
}


# Needed for when RPROMPT must be printed to the right side of the terminal
preview_print() {

  echo -e "\nThis is a preview of how your prompt will look:\n"

  # Both
  if [[ "$TYPEPROMPT" =~ ^[Bb]$ ]]; then
    readarray -t lprompt_parts <<< "$(echo -e "$1")"
    rprompt_string="$2"

    COLUMNS=$(tput cols)

    for i in "${!lprompt_parts[@]}"; do

      # If not the last element
      if [[ $i -ne $((${#lprompt_parts[@]} - 1)) ]]; then
        echo -e "${lprompt_parts[$i]}\e[0m"
      else
        clean_part_l=$(echo -e "${lprompt_parts[$i]}" | tr -d '\033' | sed -E 's/\[[0-9]{1,3}(;[0-9]{1,3})?(;[0-9]{1,3})?m//g')
        clean_part_r=$(echo -e "${rprompt_string}" | tr -d '\033' | sed -E 's/\[[0-9]{1,3}(;[0-9]{1,3})?(;[0-9]{1,3})?m//g')
        buffer=$(printf "%*s" $((COLUMNS - ${#clean_part_l} - ${#clean_part_r})))
        echo -e "${lprompt_parts[$i]}${buffer}${rprompt_string}\e[0m"
      fi
    done

  # RPROMPT
  elif [[ "$TYPEPROMPT" =~ ^[Rr]$ ]]; then
    rprompt_string="$1"

    COLUMNS=$(tput cols)

    clean_part_r=$(echo -e "${rprompt_string}" | tr -d '\033' | sed -E 's/\[[0-9]{1,3}(;[0-9]{1,3})?(;[0-9]{1,3})?m//g')
    buffer=$(printf "%*s" $((COLUMNS  - ${#clean_part_r})))
    echo -e "${buffer}${rprompt_string}\e[0m"

  elif [[ "$TYPEPROMPT" =~ ^[Ll]$ ]] || [[ "$TYPESHELL" =~ ^[Bb]$ ]]; then
    echo -e "${1}\e[0m"
  fi

  echo ""  # Extra newline before accepting prompt
}


# Picking parts, colors, creating $review_prompt, and $final_prompt
parts_menu() {
  # Parts Menu
  if [[ "$TYPESHELL" =~ ^[Zz]$ ]]; then
    echo -e "Enter the numbers in order of what you want your prompt to consist of:"
    echo -e "----------------------------------------------------------------------\n"
    echo -e "${UNDERLINE}Prompt Expansion Variables${NORMAL}:\n
    1. Username     2. Hostname (Short)     3. Hostname (Full)     4. Shell's TTY\n
    5. isRoot (% == Not Root, # == Root)   6. Return Status of Last Command   7. Current Working Directory\n
    8. Current Working Directory from \$HOME      9. Current History Event Number\n
    10. Date (yy-mm-dd)    11. Date (mm/dd/yy)    12. Date (day dd)    13. Time (12-Hour H:MM AM/PM)\n
    14. Time (24-Hour H:MM:SS)    15. Number of Jobs    16. Current Value of \$SHLVL\n
    17. Name of the script, sourced file, or shell function that Zsh is currently executing\n
    18. Other Zsh Prompt Expansion Variable (E.g. %! or %^)\n
${UNDERLINE}Symbols${NORMAL}:\n
    19. @   20. #   21. !   22. $   23. %   24. *   25. &   26. -   27. _   28. :   29. ~\n
    30. |   31. .   32. ?   33. ,   34. ;   35. ^   36. +   37. =   38. /   39. ""\   40. \"\n
    41. '   42. (   43. )   44. [   45. ]   46. {   47. }   48. <   49. >\n
${UNDERLINE}Arrows${NORMAL}:\n
    50. ←   51. ↑   52. →   53. ↓   54. ↖   55. ↗   56. ↘   57. ↙   58. ↔   59. ↕\n
${UNDERLINE}Box Drawing${NORMAL}:\n
    60. ─   61. │   62. ├   63. ┤   64. ┌   65. ┐   66. └   67. ┘   68. ╭   69. ╮   70. ╰   71. ╯\n
${UNDERLINE}Special / Custom${NORMAL}:\n"

  if [[ ! "$TYPEPROMPT" =~ ^[Rr]$ ]]; then
    echo -e "    72. Space   73. Newline (\\\n)   74. Emoji   75. Custom Text\n"
  else
    echo -e "    72. Space   74. Emoji   75. Custom Text\n"
  fi
    # Parts Dicionary - Each Index has each respective value from menu
    parts_dictionary=('%n' '%m' '%M' '%l' '%#' '%?' '%d'
    '%~' '%h' '%D' '%W' '%w' '%t' '%*' '%j' '%L' '%N' 'CV'
    '@' '#' '!' '$' '%%' '*' '&' '-' '_' ':' '~' '|' '.'
    '?' ',' ';' '^' '+' '=' '/' '\\\' '"' "\'" '(' ')'
    '[' ']' '{' '}' '<' '>' '←' '↑' '→' '↓' '↖' '↗' '↘'
    '↙' '↔' '↕' '─' '│' '├' '┤' '┌' '┐' '└' '┘' '╭' '╮'
    '╰' '╯' ' ' '\\n')

    # For User to know what they're coloring
    # Doesn't need custom text choice
    parts_choices=('Username' 'Hostname (Short)' 'Hostname (Full)' "Shell's TTY"
    'isRoot' 'Return Status of Last Command' 'Current Working Directory'
    'Current Working Directory from $HOME' 'Current History Event Number'
    'Date (yy-mm-dd)' 'Date (mm/dd/yy)' 'Date (day dd)' 'Time (12-Hour H:MM AM/PM)' 'Time (24-Hour H:MM:SS)'
    'Number of Jobs' 'Current Value of $SHLVL' 'Name of currently executed by Zsh' 'Custom Variable'
    '@' '#' '!' '$' '%' '*' '&' '-' '_' ':' '~' '|' '.' '?' ',' ';'
    '^' '+' '=' '/' '\\' '"' "'" '(' ')' '[' ']' '{' '}' '<' '>' '←'
    '↑' '→' '↓' '↖' '↗' '↘' '↙' '↔' '↕' '─' '│' '├' '┤' '┌' '┐' '└'
    '┘' '╭' '╮' '╰' '╯' ' ' '\n')
  elif [[ "$TYPESHELL" =~ ^[Bb]$ ]] ; then
    echo -e "Enter the numbers in order of what you want your prompt to consist of:"
    echo -e "----------------------------------------------------------------------\n"
    echo -e "${UNDERLINE}Prompt Expansion Variables${NORMAL}:\n
    1. Username     2. Hostname (Short)    3. Hostname (Full)    4. Shell's TTY\n
    5. Return Status of Last Command      6. Current Working Directory\n
    7. Current Working Directory from \$HOME      8. Current History Event Number\n
    9. Date (day mm dd)     10. Time (24-Hour HH:MM:SS)     11. Time (12-Hour HH:MM:SS)\n
    12. Time (12-Hour HH:MM AM/PM)     13. Time (12-Hour HH:MM)     14. Bash Version (Short)\n
    15. Bash Version (Full)    16. Number of Jobs    17. isRoot ($ == Not Root, # == Root)\n
    18. Other Bash Prompt Expansion Variable (E.g. \\s or \\#)\n
${UNDERLINE}Symbols${NORMAL}:\n
    19. @   20. #   21. !   22. $   23. %   24. *   25. &   26. -   27. _   28. :   29. ~\n
    30. |   31. .   32. ?   33. ,   34. ;   35. ^   36. +   37. =   38. /   39. ""\   40. \"\n
    41. '   42. (   43. )   44. [   45. ]   46. {   47. }   48. <   49. >\n
${UNDERLINE}Arrows${NORMAL}:\n
    50. ←   51. ↑   52. →   53. ↓   54. ↖   55. ↗   56. ↘   57. ↙   58. ↔   59. ↕\n
${UNDERLINE}Box Drawing${NORMAL}:\n
    60. ─   61. │   62. ├   63. ┤   64. ┌   65. ┐   66. └   67. ┘   68. ╭   69. ╮   70. ╰   71. ╯\n
${UNDERLINE}Special / Custom${NORMAL}:\n
    72. Space   73. Newline (\\\n)   74. Emoji   75. Custom Text\n"

    parts_dictionary=('\u' '\h' '\H' '\l' '\?' '\w'
    '\W' '\!' '\d' '\\\\t' '\T' '\@' '\A' '\\\\v' '\V' '\j'
    '\$' 'CV' '@' '#' '!' '$' '%' '*' '&' '-' '_' ':' '~'
    '|' '.' '?' ',' ';' '^' '+' '=' '/' '\\\\\\\\' '"' "\'"
    '(' ')' '[' ']' '{' '}' '<' '>' '←' '↑' '→' '↓' '↖' '↗'
    '↘' '↙' '↔' '↕' '─' '│' '├' '┤' '┌' '┐' '└' '┘' '╭' '╮'
    '╰' '╯' ' ' '\\n')

    parts_choices=('Username' 'Hostname (Short)' 'Hostname (Full)' "Shell's TTY" 'Return Status of Last Command'
    'Current Working Directory' 'Current Working Directory from $HOME' 'Current History Event Number'
    'Date (day mm dd)' 'Time (24-Hour HH:MM:SS)' 'Time (12-Hour HH:MM:SS)' 'Time (12-Hour HH:MM AM/PM)'
    'Time (12-Hour HH:MM)' 'Bash Version (Short)' 'Bash Version (Full)' 'Number of Jobs'
    'isRoot' 'Custom Variable' '@' '#' '!' '$' '%' '*' '&' '-' '_' ':' '~' '|' '.' '?' ',' ';' '^' '+' '=' '/'
    '\\' '"' "'" '(' ')' '[' ']' '{' '}' '<' '>' '←' '↑' '→' '↓' '↖' '↗' '↘' '↙' '↔' '↕' '─' '│' '├' '┤' '┌' '┐'
    '└' '┘' '╭' '╮' '╰' '╯' ' ' '\n')
  fi
}


# Handle part choices
parts_picker() {
  # Choose Parts
  echo -e "\nType 'n' or 'N' when you're finished\n"
  part_array=() # Append to this empty array
  custom_array=() # Use if custom text is
  declare -i repeat=1

  # Keep entering options until 'n' or 'N' also has error handling
  while :; do  # No argument for break, keep going until a break is found in the body
    read -p "Enter a number choice: " CHOICE
    if [[ "$CHOICE" =~ ^[Nn]$ ]]; then    # If choice is 'n' or 'N' (regex)
      break  # Break while-loop
    elif [[ "$CHOICE" == '18' ]]; then  # If custom variable
      read -r -p $'\tEnter Custom Variable: ' CUSTVAR  # -r flag so we keep '\' for Bash prompt vars
      part_array+=($CHOICE)
      custom_array+=("$CUSTVAR")
    # If newline chosen during $RPROMPT
    elif [[ "$CHOICE" == '73' ]] && ([[ "$TYPEPROMPT" =~ ^[Rr]$ ]] || [[ "$rprompt_turn" ]]); then
      echo "RPROMPT cannot contain newlines!"
    elif [[ "$CHOICE" == '74' ]]; then  # If emoji
      read -p $'\tEnter Emoji: ' EMOJI
      part_array+=($CHOICE)
      custom_array+=("$EMOJI")
    elif [[ "$CHOICE" == '75' ]]; then  # If custom text
      read -p $'\tEnter Custom Text: ' CUSTEXT
      part_array+=($CHOICE)
      # Escape quotes & backslashes
      custom_array+=($(printf "%q" "$CUSTEXT")) # Needed for printing custom text
    elif [[ $CHOICE =~ ^[0-9]+$ ]]; then  # If it's a number
      if ((CHOICE >= 1 && CHOICE <= 73)); then  # And it's in range (74, 75 already handled)
        part_array+=($CHOICE)  # Append to array
      else
        echo "Enter a valid number! (1-75)"
      fi
    else
      echo "Enter a valid number! (1-75)"
    fi
  done


  if [ ${#part_array[@]} -eq 0 ]; then  # Check if part_array is empty (if size is zero)

    # 3 - Cases: LPROMPT !empty, but RPROMPT empty
    # LPROMPT empty, but RPROMPT !empty
    # Both !empty
    if [[ "$TYPEPROMPT" =~ ^[Bb]$ ]]; then
      # If lprompt has nothing, warn and move on to rprompt
      if [[ "$lprompt_turn" == true ]]; then
        echo -e "\n\n${YELLOW}WARN${RC}: Nothing added to LPROMPT!" > /dev/stderr
        return  # Don't move onto color picking
      # If rprompt has nothing but lprompt does, warn and move on
      elif [[ "$rprompt_turn" == true ]] && [[ "$l_parts" != "" ]]; then
        echo -e "\n\n${YELLOW}WARN${RC}: Nothing added to RPROMPT!" > /dev/stderr
        return
      # If nothing added to lprompt or rprompt, exit
      elif [[ "$rprompt_turn" == true ]] && [[ "$l_parts" == "" ]]; then
         echo -e "\n${RED}ERR${RC}: Nothing added to either prompt, exiting!\n" > /dev/stderr
         exit 1
      fi
    # If only one type of prompt, nothing means program over
    else
      echo -e "\n${RED}ERR${RC}: Nothing added to prompt, exiting!\n" > /dev/stderr # If empty, exit.
      exit 1
    fi
  fi
}


# Show color menu
colors_menu() {
  echo -e "\n\nEnter the number of the color you want, in order with each part of the prompt you chose:"
  echo -e  "----------------------------------------------------------------------------------------\n"
  if [[ "$lightmode" == false ]]; then
    # Dark mode contrast
    echo -e "Foregrounds:  1. \e[38;5;15mWhite\e[0m     14. \e[1m\e[38;5;15mBold White\e[0m             Backgrounds:  29. \e[0;30m\e[48;5;15mWhite\e[0m         42. \e[0;30m\e[48;5;255mBright White\e[0m\n"
    echo -e "              2. \e[0;30m\e[48;5;15mBlack\e[0m     15. \e[1;30m\e[48;5;15mBold Black\e[0m                           30. \e[38;5;15m\e[40mBlack\e[0m         43. \e[100mBright Black\e[0m\n"
    echo -e "              3. \e[0;31mRed\e[0m       16. \e[1;31mBold Red\e[0m                             31. \e[41mRed\e[0m           44. \e[0;30m\e[101mBright Red\e[0m\n"
    echo -e "              4. \e[0;32mGreen\e[0m     17. \e[1;32mBold Green\e[0m                           32. \e[42mGreen\e[0m         45. \e[0;30m\e[102mBright Green\e[0m\n"
    echo -e "              5. \e[38;5;22mForest\e[0m    18. \e[1m\e[38;5;22mBold Forest\e[0m                          33. \e[48;5;22mForest\e[0m        46. \e[0;30m\e[48;5;28mBright Forest\e[0m\n"
    echo -e "              6. \e[0;33mYellow\e[0m    19. \e[1;33mBold Yellow\e[0m                          34. \e[43mYellow\e[0m        47. \e[0;30m\e[103mBright Yellow\e[0m\n"
    echo -e "              7. \e[38;5;202mOrange\e[0m    20. \e[1m\e[38;5;202mBold Orange\e[0m                          35. \e[48;5;202mOrange\e[0m        48. \e[0;30m\e[48;5;214mBright Orange\e[0m\n"
    echo -e "              8. \e[38;5;27mBlue\e[0m      21. \e[1m\e[38;5;27mBold Blue\e[0m                            36. \e[44mBlue\e[0m          49. \e[0;30m\e[104mBright Blue\e[0m\n"
    echo -e "              9. \e[0;36mCyan\e[0m      22. \e[1;36mBold Cyan\e[0m                            37. \e[46mCyan\e[0m          50. \e[0;30m\e[106mBright Cyan\e[0m\n"
    echo -e "             10. \e[0;35mPurple\e[0m    23. \e[1;35mBold Purple\e[0m                          38. \e[45mPurple\e[0m        51. \e[0;30m\e[105mBright Purple\e[0m\n"
    echo -e "             11. \e[38;5;93mViolet\e[0m    24. \e[1m\e[38;5;93mBold Violet\e[0m                          39. \e[48;5;93mViolet\e[0m        52. \e[0;30m\e[48;5;99mBright Violet\e[0m\n"
    echo -e "             12. \e[38;5;201mPink\e[0m      25. \e[1m\e[38;5;201mBold Pink\e[0m                            40. \e[48;5;201mPink\e[0m          53. \e[0;30m\e[48;5;207mBright Pink\e[0m\n"
    echo -e "             13. \e[0;37mGray\e[0m      26. \e[1;37mBold Gray\e[0m                            41. \e[0;30m\e[47mGray\e[0m          54. \e[0;30m\e[107mBright Gray\e[0m\n"
    echo -e "             27. No Foreground Color / No Change                    55. No Background Color / No Change\e[0m\n"
    echo -e "             28. Custom RGB Foreground                              56. Custom RGB Background\e[0m\n\n"
  else
    # Light mode contrast
    echo -e "Foregrounds:  1. \e[38;5;15m\e[40mWhite\e[0m     14. \e[1m\e[38;5;15m\e[40mBold White\e[0m             Backgrounds:  29. \e[0;30m\e[48;5;15mWhite\e[0m         42. \e[0;30m\e[48;5;255mBright White\e[0m\n"
    echo -e "              2. \e[0;30mBlack\e[0m     15. \e[1;30mBold Black\e[0m                           30. \e[38;5;15m\e[40mBlack\e[0m         43. \e[38;5;15m\e[100mBright Black\e[0m\n"
    echo -e "              3. \e[0;31mRed\e[0m       16. \e[1;31mBold Red\e[0m                             31. \e[38;5;15m\e[41mRed\e[0m           44. \e[0;30m\e[101mBright Red\e[0m\n"
    echo -e "              4. \e[0;32mGreen\e[0m     17. \e[1;32mBold Green\e[0m                           32. \e[38;5;15m\e[42mGreen\e[0m         45. \e[0;30m\e[102mBright Green\e[0m\n"
    echo -e "              5. \e[38;5;22mForest\e[0m    18. \e[1m\e[38;5;22mBold Forest\e[0m                          33. \e[38;5;15m\e[48;5;22mForest\e[0m        46. \e[38;5;15m\e[48;5;28mBright Forest\e[0m\n"
    echo -e "              6. \e[0;33mYellow\e[0m    19. \e[1;33mBold Yellow\e[0m                          34. \e[38;5;15m\e[43mYellow\e[0m        47. \e[0;30m\e[103mBright Yellow\e[0m\n"
    echo -e "              7. \e[38;5;202mOrange\e[0m    20. \e[1m\e[38;5;202mBold Orange\e[0m                          35. \e[38;5;15m\e[48;5;202mOrange\e[0m        48. \e[0;30m\e[48;5;214mBright Orange\e[0m\n"
    echo -e "              8. \e[38;5;27mBlue\e[0m      21. \e[1m\e[38;5;27mBold Blue\e[0m                            36. \e[38;5;15m\e[44mBlue\e[0m          49. \e[38;5;15m\e[104mBright Blue\e[0m\n"
    echo -e "              9. \e[0;36mCyan\e[0m      22. \e[1;36mBold Cyan\e[0m                            37. \e[38;5;15m\e[46mCyan\e[0m          50. \e[0;30m\e[106mBright Cyan\e[0m\n"
    echo -e "             10. \e[0;35mPurple\e[0m    23. \e[1;35mBold Purple\e[0m                          38. \e[38;5;15m\e[45mPurple\e[0m        51. \e[0;30m\e[105mBright Purple\e[0m\n"
    echo -e "             11. \e[38;5;93mViolet\e[0m    24. \e[1m\e[38;5;93mBold Violet\e[0m                          39. \e[38;5;15m\e[48;5;93mViolet\e[0m        52. \e[0;30m\e[48;5;99mBright Violet\e[0m\n"
    echo -e "             12. \e[38;5;201mPink\e[0m      25. \e[1m\e[38;5;201mBold Pink\e[0m                            40. \e[38;5;15m\e[48;5;201mPink\e[0m          53. \e[0;30m\e[48;5;207mBright Pink\e[0m\n"
    echo -e "             13. \e[0;37mGray\e[0m      26. \e[1;37mBold Gray\e[0m                            41. \e[0;30m\e[47mGray\e[0m          54. \e[0;30m\e[107mBright Gray\e[0m\n"
    echo -e "             27. No Foreground Color / No Change                    55. No Background Color / No Change\e[0m\n"
    echo -e "             28. Custom RGB Foreground                              56. Custom RGB Background\e[0m\n\n"
  fi


  # Parts Dicionary - Each Index has each respective value from menu (Foregrounds and backgrounds)
  color_dictionary=('\e[38;5;15m' '\e[0;30m' '\e[0;31m' '\e[0;32m'
  '\e[38;5;22m' '\e[0;33m' '\e[38;5;202m' '\e[38;5;27m'
  '\e[0;36m' '\e[0;35m' '\e[38;5;93m' '\e[38;5;201m'
  '\e[0;37m' '\e[1m\e[38;5;15m' '\e[1;30m' '\e[1;31m'
  '\e[1;32m' '\e[1m\e[38;5;22m' '\e[1;33m' '\e[1m\e[38;5;202m'
  '\e[1m\e[38;5;27m' '\e[1;36m' '\e[1;35m' '\e[1m\e[38;5;93m'
  '\e[1m\e[38;5;201m' '\e[1;37m' '' '' '\e[48;5;15m'
  '\e[40m' '\e[41m' '\e[42m' '\e[48;5;22m'
  '\e[43m' '\e[48;5;202m' '\e[44m' '\e[46m'
  '\e[45m' '\e[48;5;93m' '\e[48;5;201m' '\e[47m'
  '\e[48;5;255m' '\e[100m' '\e[101m' '\e[102m'
  '\e[48;5;28m' '\e[103m' '\e[48;5;214m' '\e[104m'
  '\e[106m' '\e[105m' '\e[48;5;99m' '\e[48;5;207m' '\e[107m' '' '')
}


# Handle color choices
colors_picker() {
  local local_part_array=("${!1}")
  local local_custom_array=("${!2}")

  # Choose Colors
  color_array=() # Append to this empty array
  declare -i counter=0   # Required for array indexing - "declare" makes it a local var
  for i in "${local_part_array[@]}"; do

    # Arrays start from 0
    i=$((i - 1))

    # Do FG and BG adding in parts, so if there's an error,
    # so we don't have to redo both, just the culprit
    while :; do  # Let it do input prompts, then do check at the end

      # Keep in mind, this is just the selection menu number choices - 1 bc arrays start from 0
      if [[ "$i" == '73' || "$i" == '74' ]]; then   # If its the custom text, just print it from part_array
        read -p "Enter ${UNDERLINE}Foreground${NORMAL} Color Number for ${local_custom_array[counter]}: " FG  # Holds the actual values of menu, Bash/Zsh arrays start at 1
      elif [[ "$i" == '71' ]] || [[ "$i" == '72' ]]; then  # No FG for space char or newline
        break
      elif [[ "$i" == '38' ]]; then  # Prevent double \\ - Don't change parts dictionary, need the double for preview print
        read -p "Enter ${UNDERLINE}Foreground${NORMAL} Color Number for \\: " FG
      elif [[ "$i" == '27' ]]; then  # double ":" issue
        read -p "Enter ${UNDERLINE}Foreground${NORMAL} Color Number for : : " FG
      elif [[ "$i" == '17' ]]; then  # Custom Variable
        read -p "Enter ${UNDERLINE}Foreground${NORMAL} Color Number for Custom Variable (${local_custom_array[counter]}): " FG
      else
        read -p "Enter ${UNDERLINE}Foreground${NORMAL} Color Number for ${parts_choices[i]}: " FG
      fi

      # Filtering each part's color inputs
      if [[ -n "$FG" && $FG =~ ^[0-9]+$ ]]; then  # Check if fg is a number and used (sometimes not used, like with spaces)
        if ((FG >= 1 && FG <= 28)); then  # Check if it's between 1-27
          if (( FG == 28 )); then
            # Append to end of color dictionary and use that new index as the color
            color_dictionary+=($(custom_rgb "FG"))
            FG=${#color_dictionary[@]}
          fi
          break  # On correct, move onto background
        else  # Never need to break on foreground, still need to check background
          echo "The Foreground number you entered was invalid. Make sure to use a valid Foreground number this time! (1-28)"
        fi     # ^^Go back to top of while loop and ask for input again
      else
        echo "The Foreground number you entered was invalid. Make sure to use a valid Foreground number this time! (1-28)"
      fi
    done

    # Add BG for item after having done FG
    while :; do
      if [[ "$i" == '73' || "$i" == '74' ]]; then   # If its the custom text, just print it from part_array
        read -p "Enter ${UNDERLINE}Background${NORMAL} Color Number for ${local_custom_array[counter]}: " BG
      elif [[ "$i" == '72' ]]; then  # If it's a newline, no need for background color either
        break
      elif [[ "$i" == '71' ]]; then  # 'Space' for color picker but ' ' later for prompt preview
        read -p "Enter ${UNDERLINE}Background${NORMAL} Color Number for Space: " BG
      elif [[ "$i" == '38' ]]; then  # Prevent double \\
        read -p "Enter ${UNDERLINE}Background${NORMAL} Color Number for \\: " BG
      elif [[ "$i" == '27' ]]; then  # double ":" issue
        read -p "Enter ${UNDERLINE}Background${NORMAL} Color Number for : : " BG
      elif [[ "$i" == '17' ]]; then  # Custom Variable
        read -p "Enter ${UNDERLINE}Background${NORMAL} Color Number for Custom Variable (${local_custom_array[counter]}): " BG
      else
        read -p "Enter ${UNDERLINE}Background${NORMAL} Color Number for ${parts_choices[i]}: " BG
      fi

      if [[ $BG =~ ^[0-9]+$ ]]; then  # Always need bg, no need to check if its used
        if ((BG >= 29 && BG <= 56)); then  # Check if it's between 28-54
          if (( BG == 56 )) ; then
            color_dictionary+=($(custom_rgb "BG"))
            BG=${#color_dictionary[@]}
          fi
          break  # End this loop, the color input is fine for this part, go to the next for-loop iteration
        else
          echo "The Background number you entered was invalid. Make sure to use a valid Background number this time! (29-56)"
        fi  # ^^Go back to top of while loop and ask for input again
      else  # If its not even a number
        echo "The Background number you entered was invalid. Make sure to use a valid Background number this time! (29-56)"
      fi  # ^^Go back to top of while loop and ask for input again
    done

    # Results of tests - Both must be good before adding, or it messes up color_array
    if [[ "$i" == '17' || "$i" == '73' || "$i" == '74' ]]; then  # Custom Variable, Emoji, Custom Text cases
      counter+=1
      color_array+=($((FG - 1)) $((BG - 1)))
    elif [[ "$i" == '71' ]]; then  # Spaces case
      color_array+=($((BG - 1)))
    elif [[ "$i" == '72' ]]; then  # Newline case - No colors
      continue  # Do nothing
    else # Normal case
      color_array+=($((FG - 1)) $((BG - 1)))
    fi
  done
}


# Merge all part and color choices into $final_prompt and $review_prompt
merge() {
  local local_part_array=("${!1}")
  local local_custom_array=("${!2}")
  local local_color_array=("${!3}")

  review_prompt=""
  final_prompt=""
  declare -i counter=0   # Required for array indexing
  declare -i counter2=0  # Required for array indexing of custom text
  for i in "${local_part_array[@]}"; do

    # Arrays start from 0
    i=$((i - 1))

    # Add colors to review_prompt & final_prompt
    if [[ "$i" == '71' ]]; then  # If it's a space, no fg needed, first number will act as background
      review_prompt+=${color_dictionary[local_color_array[counter]]}  # Just print a space char, don't actually print "Space"
      # Add proper escapes '%{ %}' for Zsh and \[ \] for Bash
      if [[ "$TYPESHELL" =~ ^[Zz]$ ]]; then
        final_prompt+="%{${color_dictionary[local_color_array[counter]]}%}"
      else
        final_prompt+="\\[${color_dictionary[local_color_array[counter]]}\\]"
      fi
      counter+=1  # Only need to go up 1, not trying to skip a second number in a pair this time
    elif [[ "$i" == '72' ]]; then # Newline just skip colors altogether
      counter+=0  # Do nothing, don't use 'continue' as it skips the rest of the for-loop
    else
      next=$(($counter+1))  # +1 to print both fg and bg pair
      review_prompt+=${color_dictionary[local_color_array[counter]]}
      review_prompt+=${color_dictionary[local_color_array[next]]}
      if [[ "$TYPESHELL" =~ ^[Zz]$ ]]; then
        final_prompt+="%{${color_dictionary[local_color_array[counter]]}%}"
        final_prompt+="%{${color_dictionary[local_color_array[next]]}%}"
      else
        final_prompt+="\\[${color_dictionary[local_color_array[counter]]}\\]"
        final_prompt+="\\[${color_dictionary[local_color_array[next]]}\\]"
      fi
      counter+=2  # Colors come in two's, don't add bg color twice everytime
    fi

    # Add parts to review_prompt & final_prompt
    if [[ "$i" == '73' || "$i" == '74' ]]; then  # If it's emoji or custom text, use $custom_array array
      review_prompt+="${local_custom_array[counter2]}"  # Has its own counter that goes up by 1's
      final_prompt+=${local_custom_array[counter2]}
      counter2+=1 # Only go up if more custom text found
    elif [[ "$i" == '17' ]]; then
      review_prompt+="Custom Variable (${local_custom_array[counter2]})"
      final_prompt+=${local_custom_array[counter2]}
      counter2+=1
    else   # If normal
      review_prompt+="${parts_choices[i]}"
      final_prompt+=${parts_dictionary[i]}
    fi

    review_prompt+="\e[0m"

    # Separate each of the parts with this escape sequence to prevent
    # prompt from deleting itself or causing other bugs
    if [[ "$TYPESHELL" =~ ^[Zz]$ ]]; then
      final_prompt+="%{\e[0m%}"
    elif [[ "$TYPESHELL" =~ ^[Bb]$ ]]; then
      final_prompt+="\\[\e[0m\\]"
    fi

  done
}



### Main ###



# Flag Vars
filename=""
omz=false
commentout=false
lightmode=false
noextras=false
separatefile=false
nowatermarks=false

# Parse Flags
while [[ "$#" -gt 0 ]]; do
    case $1 in
        -v|--version)
            version
            shift
            ;;
        -u|--usage|-h|--help)
            usage
            shift
            ;;
        --comment-out)
            command_check
            commentout=true
            shift
            ;;
        --omz)
            command_check
            omz=true
            shift
            ;;
        --light-mode)
            lightmode=true
            shift
            ;;
        --no-extras)
            noextras=true
            shift
            ;;
        --no-watermarks)
            nowatermarks=true
            shift
            ;;
        --separate-file)
            filename="$2"
            separatefile=true
            # Substitute "~" with $HOME, since it won't be expanded automatically
            filename="${filename/#\~/$HOME}"
            if [[ "$filename" == "" ]] ; then
              echo -e "\n${RED}ERR${RC}: A valid filename must be used when using --separate-file\n"
              exit 1
            fi
            shift 2
            ;;
        *)
            shift
            ;;
    esac
done


# Welcome Message
if [[ "$lightmode" == false ]]; then
  echo -e "${BOLD}\n                ~Welcome to the Shell ${GREEN}C${RED}o${BLUE}l${PURPLE}o${CYAN}r ${RC}${BOLD}Prompt Tool v${version}~${NORMAL}"
else
  echo -e "${BLACK}${BOLD}\n                ~Welcome to the Shell ${GREEN}C${RED}o${BLUE}l${PURPLE}o${CYAN}r ${RC}${BLACK}${BOLD}Prompt Tool v${version}~${NORMAL}"
fi
echo -e "                        @KyleTimmermans\n\n"


read -p "Will this be a Zsh or a Bash prompt? Enter 'Z' for Zsh or 'B' for Bash: " TYPESHELL
echo ""

# For choosing the prompt / prompttype, if error, 2 new line buffers. If no error, only need 1 line buffer
isError=false
while :; do
  if [[ "$TYPESHELL" =~ ^[Zz]$ ]] || [[ "$TYPESHELL" =~ ^[Bb]$ ]]; then
    break
  else
    isError=true
    read -p "Please choose a valid shell type ('Z' or 'B'): " TYPESHELL
  fi
done

if [[ "$TYPESHELL" =~ ^[Zz]$ ]]; then
  if [[ "$isError" == true  ]]; then
    echo ""
  fi

  isError=false
  echo -e "Will this be a left-sided prompt (\$PROMPT), a right-sided prompt (\$RPROMPT), or both?\n"
  read -p "Enter 'L' for left-sided prompt, 'R' for right-sided prompt, or 'B' for both: " TYPEPROMPT
  echo ""

  while :; do
    if [[ "$TYPEPROMPT" =~ ^[Ll]$ ]] || [[ "$TYPEPROMPT" =~ ^[Rr]$ ]] || [[ "$TYPEPROMPT" =~ ^[Bb]$ ]]; then
      break
    else
      isError=true
      read -p "Please choose a valid prompt type ('L' or 'R' or 'B'): " TYPEPROMPT
    fi
  done
fi

if [[ "$isError" == true  ]]; then
  echo -e "\n"
else
  echo ""
fi


# Give menu
if [[ "$TYPEPROMPT" =~ ^[Bb]$ ]]; then
  # "Both" workflow
  parts_menu

  echo -e "\nLPROMPT:\n--------"
  lprompt_turn=true
  parts_picker
  l_parts=("${part_array[@]}")
  l_custom_parts=("${custom_array[@]}")
  lprompt_turn=false  # Don't want to check lprompt again in menu()

  echo -e "\n\nRPROMPT:\n--------"
  rprompt_turn=true
  parts_picker
  r_parts=("${part_array[@]}")
  r_custom_parts=("${custom_array[@]}")
  rprompt_turn=false

  colors_menu

  if [[ ${#l_parts[@]} -gt 0 ]]; then
    echo -e "LPROMPT:\n--------\n"
  fi
  colors_picker "l_parts[@]" "l_custom_parts[@]"
  l_colors=("${color_array[@]}")

  if [[ ${#r_parts[@]} -gt 0 ]]; then
    echo -e "\n\nRPROMPT:\n--------\n"
  fi
  colors_picker "r_parts[@]" "r_custom_parts[@]"
  r_colors=("${color_array[@]}")

  merge "l_parts[@]" "l_custom_parts[@]" "l_colors[@]"
  l_review_prompt="$review_prompt"
  l_final_prompt="$final_prompt"

  merge "r_parts[@]" "r_custom_parts[@]" "r_colors[@]"
  r_review_prompt="$review_prompt"
  r_final_prompt="$final_prompt"

  # If user skips one section, don't write out the prompt they didn't create
  if [[ "$l_final_prompt" != "" ]] && [[ "$r_final_prompt" != "" ]]; then
    preview_print "$l_review_prompt" "$r_review_prompt"
  elif [[ "$l_final_prompt" == "" ]] && [[ "$r_final_prompt" != "" ]]; then
    # Change prompt type for later checks since the type changed from 'Both' to something else
    TYPEPROMPT='R'
    final_prompt="$r_final_prompt"
    preview_print "$r_review_prompt"
  elif [[ "$l_final_prompt" != "" ]] && [[ "$r_final_prompt" == "" ]]; then
    TYPEPROMPT='L'
    final_prompt="$l_final_prompt"
    preview_print "$l_review_prompt"
  fi
else
  parts_menu
  parts_picker
  parts=("${part_array[@]}")
  custom_parts=("${custom_array[@]}")

  colors_menu
  colors_picker "parts[@]" "custom_parts[@]"
  colors=("${color_array[@]}")

  merge "parts[@]" "custom_parts[@]" "colors[@]"

  preview_print "$review_prompt"
fi


read -p "Would you like to make this your prompt? (Y/n): " CHOICE


# After accepting prompt
if [[ "$CHOICE" =~ ^[Yy]$ ]]; then

  if [[ "$commentout" == true ]]; then
    comment_out
  fi

  # Disable Oh My Zsh theme which could prevent our prompt from applying
  if [[ "$omz" == true ]]; then
    if [[ "$nowatermarks" == false ]]; then
      gawk -i inplace '/^([[:space:]]*)?(export[[:space:]])?ZSH_THEME=/{ if(prev !~ /^([[:space:]]*)?# Commented out by Shell-Color-Prompt-Tool/) { match($0,/^([[:space:]]*)/,parts);NR==FNR-1;print parts[1] "# Commented out by Shell-Color-Prompt-Tool"}} {prev=$0; print $0}' ~/.zshrc
    fi

    gsed -i '/^[[:space:]]*\(\(export \)\{0,1\}ZSH\_THEME=\)/s/^\([[:space:]]*\)/\1#/' ~/.zshrc
  fi

  # If its not a custom file name, then we can use the normal ones
  # Do this check to prevent overwriting of custom filename created w/ --separate-file
  if [[ "$separatefile" == false ]]; then
    if [[ "$TYPESHELL" =~ ^[Zz]$ ]]; then
      filename=~/.zshrc
    elif [[ "$TYPESHELL" =~ ^[Bb]$ ]]; then
      filename=~/.bashrc
    fi
  fi

  if [[ "$nowatermarks" == false ]]; then
    echo -e "\n# Added by Shell-Color-Prompt-Tool" >> "$filename"
  else
    echo -e "\n" >> "$filename"
  fi

  # Add newline literal and space-ending unless told otherwise
  if [[ "$noextras" == false ]]; then
    if [[ "$TYPEPROMPT" =~ ^[Bb]$ ]]; then
      l_final_prompt="\\\n$l_final_prompt "
    elif [[ "$TYPEPROMPT" =~ ^[Ll]$ ]] || [[ "$TYPEPROMPT" == "" ]]; then
      final_prompt="\\\n$final_prompt "
    fi
  fi

  if [[ "$TYPEPROMPT" =~ ^[Ll]$ ]]; then
    echo -e "export PROMPT=$'$final_prompt'" >> "$filename"
  elif [[ "$TYPEPROMPT" =~ ^[Rr]$ ]]; then
    echo -e "export RPROMPT=$'$final_prompt'" >> "$filename"
  elif [[ "$TYPEPROMPT" =~ ^[Bb]$ ]]; then
    echo -e "export PROMPT=$'$l_final_prompt'" >> "$filename"
    echo -e "export RPROMPT=$'$r_final_prompt'" >> "$filename"
  elif [[ "$TYPEPROMPT" == "" ]]; then
    echo -e "export PS1=$'$final_prompt'" >> "$filename"
  fi

  # Dont print this if we are using the --separate-file flag
  if [[ "$separatefile" == true ]]; then
    echo -e "\n${GREEN}INFO${RC}: Prompt Placed in Separate File!\n"
  else
    echo -e "\n${GREEN}INFO${RC}: Prompt Saved Successfully! Restart your Terminal now!\n"
  fi

else
  echo -e "\n${YELLOW}WARN${RC}: Prompt not saved, exiting!\n" > /dev/stderr
fi
