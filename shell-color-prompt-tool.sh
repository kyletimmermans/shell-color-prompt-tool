#!/usr/bin/env bash



# Shell-Color-Prompt-Tool v5.0



# Handle SIGINT/SIGTERM before saving prompt
trap 'echo -e "\n\n\e[1;33mWARN\e[0m: SIGINT/SIGTERM signal receieved, prompt not saved!\n" >&2; exit 1' SIGINT SIGTERM


# Global Variables

version="5.0"

# Title Colors/Format Vars
BOLD="$(tput bold)"
UNDERLINE="$(tput smul)"
RS="$(tput sgr0)"  # Reset Style
RED='\e[1;31m'
GREEN='\e[1;32m'
YELLOW='\e[1;33m'
BLUE='\e[1;34m'
PURPLE='\e[1;35m'
CYAN='\e[1;36m'
RC='\e[0m'  # Reset Color



###################################
###          Functions          ###
###################################



# Version Flag
version() {
  echo -e "\nShell-${GREEN}C${RED}o${BLUE}l${PURPLE}o${CYAN}r${RC}-Prompt-Tool v${version}${RS}\n"

  local newest_version
  newest_version=$(curl -s https://api.github.com/repos/kyletimmermans/shell-color-prompt-tool/releases/latest | grep '"name": "v' | awk -F '"name": "v' '{print $2}' | awk -F '"' '{print $1}')

  # If not empty string - Not error
  if [[ $newest_version != "" ]]; then
    # If local version not the same as latest GitHub release, then notify
    if [[ "$version" != "$newest_version" ]]; then
      echo -e "\n${GREEN}INFO${RC}: Newer version available on GitHub - v${newest_version}!\n"
      echo -e "github.com/kyletimmermans/shell-color-prompt-tool\n"
    fi
  else
      echo -e "\n${RED}ERR${RC}: Could not connect to GitHub to check for updates\n" >&2
      exit 1
  fi

  exit 0
}


# Usage/Help Flag
usage() {
  echo -e "\n${LM}${BOLD}${UNDERLINE}Usage${RS}: Run this program and use the interactive prompt to create your custom Zsh/Bash prompt\n\n"
  echo -e "${LM}${BOLD}${UNDERLINE}Flags${RS}:\n"
  echo -e "${LM}${BOLD}--usage${RS}              Pulls up this menu\n"
  echo -e "${LM}${BOLD}--version${RS}            Get program version. Reveal if a newer version is available on GitHub\n"
  echo -e "${LM}${BOLD}--uninstall${RS}          Undoes the \"Install as a Command\" installation option. It will delete"
  echo -e "                     /usr/local/bin/scpt (program) and the associated man page\n"
  echo -e "${LM}${BOLD}--comment-out${RS}        Comment out older prompt lines in .zshrc / .bashrc e.g. PROMPT= / PS1="
  echo -e "                     to help prevent conflicting prompt definitions\n"
  echo -e "${LM}${BOLD}--omz${RS}                Disables your 'Oh My Zsh' theme if you have one, which could get in the"
  echo -e "                     way of applying your new prompt\n"
  echo -e "${LM}${BOLD}--light-mode${RS}         Better color contrast for the color picker menu and other various portions"
  echo -e "                     on white/light-colored terminal backgrounds. If you plan on using this flag,"
  echo -e "                     always put it first, before all other flags/args\n"
  echo -e "${LM}${BOLD}--no-extras${RS}          Don't automatically add a newline to the start of the prompt and a space"
  echo -e "                     to the end of the prompt\n"
  echo -e "${LM}${BOLD}--separate-file${RS}      Place the prompt string in a separate file instead of putting it in"
  echo -e "                     .zshrc / .bashrc E.g. --separate-file=\"~/test.txt\"\n"
  echo -e "${LM}${BOLD}--no-watermarks${RS}      Don't add the \"# Added by Shell-Color-Prompt-Tool\" comment to"
  echo -e "                     .zshrc / .bashrc when adding the prompt string and don't add the"
  echo -e "                     \"# Commented out by Shell-Color-Prompt-Tool\" comment when using"
  echo -e "                     --comment-out or --omz\n"
  echo -e "${LM}${BOLD}--char-table${RS}         Display a table of cool UTF-8 characters for copy-and-pasting into"
  echo -e "                     prompt part choices. If you can't see the characters or if they show"
  echo -e "                     up incorrectly, ensure that your terminal supports the UTF-8 charset\n\n"
  echo -e "${LM}${BOLD}${UNDERLINE}Usage Notes${RS}:\n"
  echo -e "* To add a number as a raw string and to not get it recognized as a menu-number choice, or"
  echo -e "  to add 'n'/'N' and not exit the parts selector, add a '!' before the number or 'n'/'N'"
  echo -e "  e.g. '!14' yields '14' and '!n' yields 'n' and won't exit the parts selector\n"
  echo -e "* No need to put a space at the end of your prompt, one will be added automatically."
  echo -e "  Same with a newline at the beginning for proper spacing between actual prompts,"
  echo -e "  one will automatically be added. Disable this feature w/ --no-extras\n"
  echo -e "* If you want to use the --comment-out or --omz flags, you must have 'gawk' and 'gsed'"
  echo -e "  installed. On Mac, you'll need to install both. On Linux, you just need gawk, as"
  echo -e "  gsed should already be your default sed version\n"
  echo -e "* --comment-out and --omz can break the config if the variables that are getting"
  echo -e "  commented out, are defined within things like if-statements or case-statements\n"
  echo -e "* Use a text editor such as Vim to view the raw components of the prompt definition in"
  echo -e "  .zshrc / .bashrc, as some text editors have trouble displaying the ANSI escape sequences\n"
  echo -e "* Fullscreen terminals will be able to fit the spacing and styling of the interactive"
  echo -e "  prompt the best\n"
  echo -e "* Colors may vary from system to system. When using the Custom RGB option, make sure your"
  echo -e "  terminal supports TRUECOLOR (See github.com/termstandard/colors)\n"
  echo -e "* Some terminals may not display the background color for the \"Tab\" part, either in the"
  echo -e "  preview or the actual prompt\n"
  echo -e "* If your command is too long, \$RPROMPT will visually be temporarily overwritten\n"
  echo -e "* \$RPROMPT cannot contain newlines (\\\n)\n"
  echo -e "* For part option \"Custom Datetime\", the datetime string is formatted using the 'strftime'"
  echo -e "  function. See strftime(3) for more details. E.g.'%Y-%m-%d %k:%M:%S' would become:"
  echo -e "  '2024-11-09 14:37:34'\n"
  echo -e "* For more prompt expansion variables not listed in this program:"
  echo -e "      Zsh: ${UNDERLINE}zsh.sourceforge.io/Doc/Release/Prompt-Expansion.html${RS}"
  echo -e "     Bash: ${UNDERLINE}www.gnu.org/software/bash/manual/html_node/Controlling-the-Prompt.html${RS}\n\n"
  echo -e "${LM}${BOLD}github.com/kyletimmermans/shell-color-prompt-tool${RS}\n"

  exit 0
}


# Remove scpt file and man page
uninstall() {
  trap 'echo -e "\n\n${RED}ERR${RC}: SIGINT/SIGTERM signal receieved, scpt not uninstalled!\n" >&2; exit 1' SIGINT SIGTERM

  echo ""
  read -r -p "Did you install this program with \"Install as a Command\"? (Y/n): " CONFIRM

  if [[ "$CONFIRM" =~ ^[Yy]$ ]]; then
    # Use && bc all lines need to be correct for the message to be true
    # and if one line fails, they all fail and then no success message
    sudo rm /usr/local/bin/scpt && \
    sudo rm /usr/local/share/man/man1/scpt.1 && \
    echo -e "\n${GREEN}INFO${RC}: Successfully Uninstalled - Deleted scpt and man page!\n" && \
    exit 0
  else
    echo -e "\n${RED}ERR${RC}: Nothing to uninstall - Simply delete the downloaded file\n" >&2
    exit 1
  fi
}


# Ensure gawk & gsed usage when using --comment-out or --omz flags
command_check() {
  local gawk_needed=false
  local gsed_needed=false

  if gawk --version 2>/dev/null | grep -q "GNU"; then
    : # Do nothing - All set
  elif awk --version 2>/dev/null | grep -q "GNU"; then
    gawk() { awk "$@"; }
  else
    echo -e "\n${RED}ERR${RC}: gawk is required for the --comment-out and --omz flags to work\n" >&2
    gawk_needed=true
  fi

  if gsed --version 2>/dev/null | grep -q "GNU"; then
    :
  elif sed --version 2>/dev/null | grep -q "GNU"; then
    gsed() { sed "$@"; }
  else
    echo -e "\n${RED}ERR${RC}: gsed is required for the --comment-out and --omz flags to work\n" >&2
    gsed_needed=true
  fi

  if [[ $gawk_needed == "true" ]] || [[ $gsed_needed == "true" ]]; then
    exit 1
  fi
}


# Input 'R' 'G' 'B' values for custom RGB
custom_rgb() {
  read -r -p $'\tChoose R value (0-255): ' R
  while :; do
    if [[ $R =~ ^[0-9]+$ ]] && (( R >= 0 && R <= 255 )); then
      break
    else
      read -r -p $'\tPlease choose a valid R number (0-255): ' R
    fi
  done

  read -r -p $'\tChoose G value (0-255): ' G
  while :; do
    if [[ $G =~ ^[0-9]+$ ]] && (( G >= 0 && G <= 255 )); then
      break
    else
      read -r -p $'\tPlease choose a valid G number (0-255): ' G
    fi
  done

  read -r -p $'\tChoose B value (0-255): ' B
  while :; do
    if [[ $B =~ ^[0-9]+$ ]] && (( B >= 0 && B <= 255 )); then
      break
    else
      read -r -p $'\tPlease choose a valid B number (0-255): ' B
    fi
  done

  if [[ $1 == "FG" ]]; then
    printf "\e[38;2;%d;%d;%dm" "$R" "$G" "$B"
  elif [[ $1 == "BG" ]]; then
    printf "\e[48;2;%d;%d;%dm" "$R" "$G" "$B"
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


omz_comment_out() {
  if [[ "$nowatermarks" == false ]]; then
    gawk -i inplace '/^([[:space:]]*)?(export[[:space:]])?ZSH_THEME=/{ if(prev !~ /^([[:space:]]*)?# Commented out by Shell-Color-Prompt-Tool/) { match($0,/^([[:space:]]*)/,parts);NR==FNR-1;print parts[1] "# Commented out by Shell-Color-Prompt-Tool"}} {prev=$0; print $0}' ~/.zshrc
  fi

  gsed -i '/^[[:space:]]*\(\(export \)\{0,1\}ZSH\_THEME=\)/s/^\([[:space:]]*\)/\1#/' ~/.zshrc
}


# Handle --separate-file flag and its args
separate_file() {
  # Get everything after '=' and then substitute '~' with $HOME, since it won't be expanded automatically
  filename="${1#*=}"; filename="${filename/#\~/$HOME}"

  if [[ -z "$filename" ]]; then  # If empty filename arg
    echo -e "\n${RED}ERR${RC}: A valid filename must be used when using --separate-file. Use the -h flag to see proper usage\n" >&2
    exit 1
  fi

  if [[ -e "$filename" ]]; then  # If file already exists

    echo ""
    read -r -p "File already exists, write in it anyway? (Y/n): " WRITEANYWAY

    if [[ "$WRITEANYWAY" =~ ^[Yy]$ ]]; then
      return
    else
      echo -e "\n${RED}ERR${RC}: Exiting, file will not be edited\n" >&2
      exit 1
    fi

  fi
}


# - Certain characters within Zsh & Bash have their own necessary escape logic
#   and when we user does custom, there is no array like part_dictionary that
#   has the pre-escaped characters ready, so we need to do it here
# - Note: This is for final_prompt only, not review_prompt
escape_chars() {
  local input_string="$1"
  local result_string=""

  # Loop through each character in the input string
  for (( i=0; i < ${#input_string}; i++ )); do

      char="${input_string:i:1}"  # Get the current character

      # Either Zsh or Bash
      case "$char" in
        '$') result_string+='\$' ; continue ;;
        "'") result_string+="\'" ; continue ;;
        '"') result_string+='\\"' ; continue ;;
        '`') result_string+='\\\`' ; continue ;;
      esac

      # Necessary Zsh replacements
      if [[ "$TYPESHELL" =~ ^[Zz]$ ]]; then
        case "$char" in
          '%') result_string+='%%' ; continue ;;
          '{') result_string+='\{' ; continue ;;
          '}') result_string+='\}' ; continue ;;
          '[') result_string+='\[' ; continue ;;
          ']') result_string+='\]' ; continue ;;
          '(') result_string+='\(' ; continue ;;
          ')') result_string+='\)' ; continue ;;
          '^') result_string+='\^' ; continue ;;
          '\') result_string+='\\\\' ; continue ;;
        esac
      fi

      # Necessary Bash replacements
      if [[ "$TYPESHELL" =~ ^[Bb]$ ]]; then
        case "$char" in
            '\') result_string+='\\\\\\\\' ; continue ;;
        esac
      fi

      result_string+="${char}"  # If unhandled above, add without escape

  done

  echo "$result_string"
}


# --char-table table for copy-and-pasting into prompt part choices
char_table() {
  echo -e "\n${LM}${BOLD}${UNDERLINE}Cool UTF-8 Characters${RS}\n
  ${UNDERLINE}Arrows${RS}:\n
    ←    ↑    →    ↓    ↔    ↕    ↖    ↗    ↘    ↙\n
    «    »    ❮    ❯    ⇦    ⇨    ➠    ➤    ➳    ⮂\n
    ⮃    ⮐     ⮑\n
  ${UNDERLINE}Geometric Shapes${RS}:\n
    ◆    ◇    ■    □    ▲    △    ▼    ▽    ★    ☆\n
    ⬢    ⬡    ▬    ▭    ▮    ▯    ▰    ▱    ⬟    ⬠\n
    ⬬    ⬭    ⬮    ⬯\n
  ${UNDERLINE}Playing Card Suites${RS}:\n
    ♠    ♤    ♣    ♧    ♥    ♡    ♦    ♢\n
  ${UNDERLINE}Chess Pieces${RS}:\n
    ♚    ♛    ♜    ♝    ♞    ♟\n
    ♔    ♕    ♖    ♗    ♘    ♙\n
  ${UNDERLINE}Circled Numbers${RS}:\n
    ➊    ➋    ➌    ➍    ➎    ➏    ➐    ➑    ➒    ➓\n
    ➀    ➁    ➂    ➃    ➄    ➅    ➆    ➇    ➈    ➉\n
  ${UNDERLINE}Miscellaneous${RS}:\n
    ✖    ✚    ✢    ✹    ❖    ∞    Ω    ✦    ✧    ◉\n
    ⚑    ⚐    ✓    ❄    ✈    ✏    ✉    ✇    ☂    ☻\n
    ☺    ☹    ⚙    ⚛    ⚠    ♪    ☀    ⏾    ⎈    ⌖\n"

  exit 0
}


# Needed for when RPROMPT must be printed to the right side of the terminal
preview_print() {

  echo -e "\n\nThis is a preview of how your prompt will look:"
  echo -e "-----------------------------------------------\n"

  # Both
  if [[ "$TYPEPROMPT" =~ ^[Bb]$ ]]; then
    readarray -t lprompt_parts <<< "$(echo -e "$1")"
    rprompt_string="$2"

    COLUMNS=$(tput cols)

    for i in "${!lprompt_parts[@]}"; do

      # If not the last element
      if [[ $i -ne $((${#lprompt_parts[@]} - 1)) ]]; then
        echo -e "${lprompt_parts[${i}]}\e[0m"
      else
        clean_part_l=$(echo -e "${lprompt_parts[${i}]}" | tr -d '\033' | sed -E 's/\[[0-9]{1,3}(;[0-9]{1,3})?(;[0-9]{1,3})?m//g')
        # Added space at end of RPROMPT to simulate actual $RPROMPT behavior
        #                                        v
        clean_part_r=$(echo -e "${rprompt_string} " | tr -d '\033' | sed -E 's/\[[0-9]{1,3}(;[0-9]{1,3})?(;[0-9]{1,3})?m//g')
        buffer=$(printf "%*s" $((COLUMNS - ${#clean_part_l} - ${#clean_part_r})) "")
        echo -e "${lprompt_parts[${i}]}${buffer}${rprompt_string}\e[0m"
      fi
    done

  # RPROMPT only
  elif [[ "$TYPEPROMPT" =~ ^[Rr]$ ]]; then
    rprompt_string="$1"

    COLUMNS=$(tput cols)

    # Added space at end of RPROMPT to simulate actual $RPROMPT behavior
    clean_part_r=$(echo -e "${rprompt_string} " | tr -d '\033' | sed -E 's/\[[0-9]{1,3}(;[0-9]{1,3})?(;[0-9]{1,3})?m//g')
    buffer=$(printf "%*s" $((COLUMNS  - ${#clean_part_r})) "")
    echo -e "${buffer}${rprompt_string}\e[0m"

  elif [[ "$TYPEPROMPT" =~ ^[Ll]$ ]] || [[ "$TYPESHELL" =~ ^[Bb]$ ]]; then
    echo -e "${1}\e[0m"
  fi

  echo ""  # Extra newline before accepting prompt
}


# Show parts menu and create: parts_dictionary() & part_preview_strings()
parts_menu() {
  echo -e "Enter the part numbers and any custom text in the order you want them to appear in your prompt:"
  echo -e "-----------------------------------------------------------------------------------------------\n"

  # Parts Menu
  if [[ "$TYPESHELL" =~ ^[Zz]$ ]]; then
    echo -e "${LM}${BOLD}${UNDERLINE}Prompt Expansion Variables${RS}:\n
    1. Username     2. Hostname (Short)     3. Hostname (Full)     4. Shell's TTY\n
    5. Full-Path Current Working Directory      6. Current Working Directory from \$HOME\n
    7. isRoot (% == Not Root, # == Root)    8. Return Status of Last Command    9. Current History Event Number\n
    10. Date (yy-mm-dd)    11. Date (mm/dd/yy)    12. Date (day dd)    13. Time (24-Hour H:MM:SS)\n
    14. Time (12-Hour H:MM AM/PM)    15. Number of Jobs    16. Current Value of \$SHLVL\n
    17. Name of the script, sourced file, or shell function that Zsh is currently executing\n
    18. Custom Datetime    19. Other Zsh Prompt Expansion Variable (E.g. %e)\n
${LM}${BOLD}${UNDERLINE}Environment Variables${RS}:\n
    20. Arch Type   21. OS Type   22. Terminal Type   23. Parent Shell PID   24. Zsh Version   25. Subshell Level\n
    26. Other Environment Variable\n
${LM}${BOLD}${UNDERLINE}Box Drawing${RS}:\n
    27. ─   28. │   29. ├   30. ┤   31. ┌   32. ┐   33. └   34. ┘   35. ╭   36. ╮   37. ╰   38. ╯\n
${LM}${BOLD}${UNDERLINE}Special${RS}:\n"

  # Print Newline option only for non-RPROMPT walkthrough
  if [[ "$TYPEPROMPT" =~ ^[Rr]$ ]]; then
    echo -e "    39. Space    40. Tab (\\\t)\n"
  else
    echo -e "    39. Space    40. Tab (\\\t)    41. Newline (\\\n)\n"
  fi

    # Parts Dicionary - Each Index has each respective value from menu
    part_dictionary=(
    '%n' '%m' '%M' '%l' '%d' '%~' '%#' '%?' '%h' '%D' '%W' '%w' '%*' '%t' '%j' '%L' '%N' 'CDT' 'CPEV'
    '$MACHTYPE' '$OSTYPE' '$TERM' '$$' '$ZSH_VERSION' '$ZSH_SUBSHELL' 'CEV'
    '─' '│' '├' '┤' '┌' '┐' '└' '┘' '╭' '╮' '╰' '╯'
    ' ' '\\t' '\\n')

    # For User to know what they're coloring
    # Doesn't need custom text choice
    part_preview_strings=('Username' 'Hostname (Short)' 'Hostname (Full)' "Shell's TTY"
    'Full-Path Current Working Directory' 'Current Working Directory from $HOME' 'isRoot'
    'Return Status of Last Command' 'Current History Event Number' 'Date (yy-mm-dd)'
    'Date (mm/dd/yy)' 'Date (day dd)' 'Time (24-Hour H:MM:SS)' 'Time (12-Hour H:MM AM/PM)'
    'Number of Jobs' 'Current Value of $SHLVL' 'Name of currently executed by Zsh' 'Custom Datetime'
    'Custom Variable' 'Arch Type' 'OS Type' 'Terminal Type' 'Parent Shell PID' 'Zsh Version' 'Subshell Level'
    'Custom Env Variable' '─' '│' '├' '┤' '┌' '┐' '└' '┘' '╭' '╮' '╰' '╯' ' ' '\t' '\n')
  elif [[ "$TYPESHELL" =~ ^[Bb]$ ]]; then
    echo -e "${LM}${BOLD}${UNDERLINE}Prompt Expansion Variables${RS}:\n
    1. Username     2. Hostname (Short)    3. Hostname (Full)    4. Shell's TTY\n
    5. Current Working Directory      6. Current Working Directory from \$HOME \n
    7. Current Shell Command Number      8. Current History Event Number\n
    9. Date (day month dd)     10. Time (24-Hour HH:MM:SS)     11. Time (12-Hour HH:MM:SS)\n
    12. Time (12-Hour HH:MM AM/PM)     13. Time (12-Hour HH:MM)     14. Bash Version (Short)\n
    15. Bash Version (Full)    16. Number of Jobs    17. isRoot ($ == Not Root, # == Root)\n
    18. Custom Datetime    19. Other Bash Prompt Expansion Variable (E.g. \\s)\n
${LM}${BOLD}${UNDERLINE}Environment Variables${RS}:\n
    20. Arch Type   21. OS Type   22. Terminal Type   23. Parent Shell PID   24. Return Status of Last Command\n
    25. Shell Level   26. Other Environment Variable\n
${LM}${BOLD}${UNDERLINE}Box Drawing${RS}:\n
    27. ─   28. │   29. ├   30. ┤   31. ┌   32. ┐   33. └   34. ┘   35. ╭   36. ╮   37. ╰   38. ╯\n
${LM}${BOLD}${UNDERLINE}Special${RS}:\n
    39. Space    40. Tab    41. Newline (\\\n)\n"

    part_dictionary=(
    '\u' '\h' '\H' '\l' '\W' '\w' '\#' '\!' '\d' '\\\\t' '\T' '\@' '\A' '\\\\v' '\V' '\j' '\$' 'CDT' 'CPEV'
    '$HOSTTYPE' '$OSTYPE' '$TERM' '$$' '$?' '$SHLVL' 'CEV'
    '─' '│' '├' '┤' '┌' '┐' '└' '┘' '╭' '╮' '╰' '╯'
    ' ' '\\011' '\\n')

    part_preview_strings=('Username' 'Hostname (Short)' 'Hostname (Full)' "Shell's TTY" 'Current Working Directory'
    'Current Working Directory from $HOME' 'Current Shell Command Number' 'Current History Event Number'
    'Date (day month dd)' 'Time (24-Hour HH:MM:SS)' 'Time (12-Hour HH:MM:SS)' 'Time (12-Hour HH:MM AM/PM)'
    'Time (12-Hour HH:MM)' 'Bash Version (Short)' 'Bash Version (Full)' 'Number of Jobs'
    'isRoot' 'Custom Datetime' 'Custom Variable' 'Arch Type' 'OS Type' 'Terminal Type' 'Parent Shell PID'
    'Return Status of Last Command' 'Shell Level' 'Custom Env Variable'
    '─' '│' '├' '┤' '┌' '┐' '└' '┘' '╭' '╮' '╰' '╯' ' ' '\011' '\n')
  fi

  MAX_PART_CHOICE_NUM=$(( "${#part_dictionary[@]}" ))
}


# Handle part choices
parts_picker() {
  # Choose Parts
  echo -e "\nType 'n' or 'N' when you're finished\n"
  # Store choices - Each element 'MENU/CDT/CPEV/CEV/CUSTOM,$PART'
  part_choices=()

  # Keep entering options until 'n' or 'N' also has error handling
  while :; do
    read -r -p "Enter a number choice or custom text: " CHOICE

    # If finished
    if [[ "$CHOICE" == "n" ]] || [[ "$CHOICE" == "N" ]]; then
      break

    # If empty choice answer
    elif [[ -z "$CHOICE" ]]; then
      echo "Can't add nothing!"
      continue

    # If menu part choice
    elif [[ $CHOICE =~ ^[0-9]+$ ]]; then

      # Part numbers in the menu start at 1, part_dictionary starts at 1
      # Move part number choices down 1 to be level w/ part_dictionary
      CHOICE=$((CHOICE - 1))

      # When extra prompt is needed for Custom
      case "${part_dictionary[$CHOICE]}" in
          "CDT")
              read -r -p $'\tEnter Datetime Format: ' DATETIME
              part_choices+=("CDT,$DATETIME")
              continue  # Don't continue down to other if-statements below which could also be true
              ;;
          "CPEV")
              read -r -p $'\tEnter Prompt Expansion Variable: ' CUSTPEVAR
              part_choices+=("CPEV,$CUSTPEVAR")
              continue
              ;;
          "CEV")
              read -r -p $'\tEnter Environment Variable: ' CUSTENVVAR
              part_choices+=("CEV,$CUSTENVVAR")
              continue
              ;;
      esac

      # Newline chosen during $RPROMPT
      if [[ "${part_dictionary[$CHOICE]}" == "\\\n" ]] && { [[ "$TYPEPROMPT" =~ ^[Rr]$ ]] || [[ "$rprompt_turn" == true ]]; }; then
        echo "RPROMPT cannot contain newlines!"
        continue
      fi

      # In range
      # Bring +1 back bc we're checking against the menu selection now, not parts_dictionary
      if (( CHOICE+1 >= 1 && CHOICE+1 <= MAX_PART_CHOICE_NUM )); then
        part_choices+=("MENU,$CHOICE")
      # Out of range
      else
        echo "Part choice out of range (1-${MAX_PART_CHOICE_NUM})! If you want a raw number use '!' beforehand e.g. !1337"
      fi

    # If user wants raw number or raw 'n'/'N' e.g. !1337 or !n
    elif [[ $CHOICE =~ ^![0-9]+$ ]] || [[ $CHOICE =~ ^![Nn]$ ]]; then
      part_choices+=("CUSTOM,${CHOICE:1}")

    # If custom/non-menu
    else
      part_choices+=("CUSTOM,$CHOICE")
    fi

  done


  if [ ${#part_choices[@]} -eq 0 ]; then  # Check if part_choices is empty (if size is zero)

    # 3 - Cases: LPROMPT !empty, but RPROMPT empty
    # LPROMPT empty, but RPROMPT !empty
    # Both !empty
    if [[ "$TYPEPROMPT" =~ ^[Bb]$ ]]; then
      # If lprompt has nothing, warn and move on to rprompt
      if [[ "$lprompt_turn" == true ]]; then
        echo -e "\n\n${YELLOW}WARN${RC}: Nothing added to LPROMPT!" >&2
        return  # Don't move onto color picking
      # If rprompt has nothing but lprompt does, warn and move on
      elif [[ "$rprompt_turn" == true ]] && [[ "$l_parts" != "" ]]; then
        echo -e "\n\n${YELLOW}WARN${RC}: Nothing added to RPROMPT!" >&2
        return
      # If nothing added to lprompt or rprompt, exit
      elif [[ "$rprompt_turn" == true ]] && [[ "$l_parts" == "" ]]; then
        echo -e "\n${RED}ERR${RC}: Nothing added to either prompt, exiting!\n" >&2
        exit 1
      fi
    # If only one type of prompt, nothing means program over
    else
      echo -e "\n${RED}ERR${RC}: Nothing added to prompt, exiting!\n" >&2  # If empty, exit.
      exit 1
    fi
  fi
}


# Show color menu
colors_menu() {
  echo -e "\n\nEnter the numbers of the colors you want for each part of the prompt that you chose:"
  echo -e  "------------------------------------------------------------------------------------\n"
  if [[ "$lightmode" == false ]]; then
    # Dark mode contrast
    echo -e "${BOLD}Foregrounds:${RS}  1. \e[38;5;15mWhite\e[0m     14. \e[1m\e[38;5;15mBold White\e[0m             ${BOLD}Backgrounds:${RS}  29. \e[0;30m\e[48;5;15mWhite\e[0m         42. \e[0;30m\e[48;5;255mBright White\e[0m\n"
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
    echo -e "${LM}${BOLD}Foregrounds:${RS}  1. \e[38;5;15m\e[40mWhite\e[0m     14. \e[1m\e[38;5;15m\e[40mBold White\e[0m             ${LM}${BOLD}Backgrounds:${RS}  29. \e[0;30m\e[48;5;15mWhite\e[0m         42. \e[0;30m\e[48;5;255mBright White\e[0m\n"
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
  '\e[1m\e[38;5;201m' '\e[1;37m' '' 'RGB' '\e[48;5;15m'
  '\e[40m' '\e[41m' '\e[42m' '\e[48;5;22m'
  '\e[43m' '\e[48;5;202m' '\e[44m' '\e[46m'
  '\e[45m' '\e[48;5;93m' '\e[48;5;201m' '\e[47m'
  '\e[48;5;255m' '\e[100m' '\e[101m' '\e[102m'
  '\e[48;5;28m' '\e[103m' '\e[48;5;214m' '\e[104m'
  '\e[106m' '\e[105m' '\e[48;5;99m' '\e[48;5;207m' '\e[107m' '' 'RGB')

  MAX_FG_COLOR_CHOICE_NUM=$(( "${#color_dictionary[@]}" / 2 ))
  MAX_BG_COLOR_CHOICE_NUM=$(( "${#color_dictionary[@]}" ))
}


# Handle color choices
colors_picker() {
  local local_part_choices=("${!1}")

  # Choose Colors
  color_choices=() # Each element "$FG,$BG"

  for i in "${local_part_choices[@]}"; do

    local CHECK="${i%%,*}"  # Everything before the 1st comma
    local VALUE="${i#*,}"   # Everything after the 1st comma

    # Do FG and BG adding in parts, so if there's an error, so we don't have to redo both, just the culprit

    local FG

    while :; do

      # - Double ':' issue - Looks weird if the string ends in ':' and then we have the ':' here right next to it "::"
      # - If not ASCII, could be a wide character, need an extra space on the right to not overwrite ':'
      if [[ ${VALUE: -1} == ":" ]] || (( $(printf "%d" "'$VALUE") > 127 )); then
        read -r -p "Enter ${UNDERLINE}Foreground${RS} color number for ${VALUE} : " FG

      # Custom Datetime
      elif [[ "$CHECK" == "CDT" ]]; then
        read -r -p "Enter ${UNDERLINE}Foreground${RS} color number for Custom Datetime (${VALUE}): " FG

      # Custom Prompt Expansion Variable
      elif [[ "$CHECK" == "CPEV" ]]; then
        read -r -p "Enter ${UNDERLINE}Foreground${RS} color number for Custom Prompt Variable (${VALUE}): " FG

      # Custom Environment Variable
      elif [[ "$CHECK" == "CEV" ]]; then
        read -r -p "Enter ${UNDERLINE}Foreground${RS} color number for Custom Environment Variable (${VALUE}): " FG

      # Menu selection
      elif [[ "$CHECK" == "MENU" ]]; then

        # Further check for space, tab, and newline since they don't get an FG color
        # Need to check if menu value first bc index here needs a number
        if [[ "${part_dictionary[${VALUE}]}" =~ ^([[:space:]]|\\\\t|\\\\011|\\\\n)$ ]]; then
          FG=$((MAX_FG_COLOR_CHOICE_NUM - 1))
        else
          read -r -p "Enter ${UNDERLINE}Foreground${RS} color number for ${part_preview_strings[${VALUE}]}: " FG
        fi

      # Custom
      elif [[ "$CHECK" == "CUSTOM" ]]; then
        read -r -p "Enter ${UNDERLINE}Foreground${RS} color number for ${VALUE}: " FG
      fi

      # After handling the color choosing messages for each part type, validate the colors chosen
      if [[ $FG =~ ^[0-9]+$ ]] && (( FG >= 1 && FG <= MAX_FG_COLOR_CHOICE_NUM )); then
        if [[ "${color_dictionary[$((FG - 1))]}" == "RGB" ]]; then
          FG=$(custom_rgb 'FG')
        fi

        break  # On correct, move onto background
      else  # Never need to break on foreground, still need to check background
        echo "The foreground number you entered was invalid. Make sure to use a valid foreground number this time! (1-${MAX_FG_COLOR_CHOICE_NUM})"
      fi  # Go back to top of while loop and ask for input again

    done


    # Add BG for item after having done FG
    local BG

    while :; do

      # - Double ':' issue - Looks weird if the string ends in ':' and then we have the ':' here right next to it "::"
      # - If not ASCII, could be a wide character, need an extra space on the right to not overwrite ':'
      if [[ ${VALUE: -1} == ":" ]] || (( $(printf "%d" "'$VALUE") > 127 )); then
        read -r -p "Enter ${UNDERLINE}Background${RS} color number for ${VALUE} : " BG

      # Custom Datetime
      elif [[ "$CHECK" == "CDT" ]]; then
        read -r -p "Enter ${UNDERLINE}Background${RS} color number for Custom Datetime (${VALUE}): " BG

      # Custom Prompt Expansion Variable
      elif [[ "$CHECK" == "CPEV" ]]; then
        read -r -p "Enter ${UNDERLINE}Background${RS} color number for Custom Prompt Variable (${VALUE}): " BG

      # Custom Environment Variable
      elif [[ "$CHECK" == "CEV" ]]; then
        read -r -p "Enter ${UNDERLINE}Background${RS} color number for Custom Environment Variable (${VALUE}): " BG

      # Menu selection
      elif [[ "$CHECK" == "MENU" ]]; then

        # No background for newline (Need to check if menu value first bc index here needs a number)
        if [[ "${part_dictionary[${VALUE}]}" == "\\\n" ]]; then
          BG=$((MAX_BG_COLOR_CHOICE_NUM - 1))
        elif [[ "${part_dictionary[${VALUE}]}" == "\\\t" || "${part_dictionary[${VALUE}]}" == "\\\011" ]]; then
          read -r -p "Enter ${UNDERLINE}Background${RS} color number for Tab: " BG
        elif [[ "${part_dictionary[${VALUE}]}" == " " ]]; then
          read -r -p "Enter ${UNDERLINE}Background${RS} color number for Space: " BG
        else
          read -r -p "Enter ${UNDERLINE}Background${RS} color number for ${part_preview_strings[${VALUE}]}: " BG
        fi

      # Custom
      elif [[ "$CHECK" == "CUSTOM" ]]; then
        read -r -p "Enter ${UNDERLINE}Background${RS} color number for ${VALUE}: " BG
      fi

      if [[ $BG =~ ^[0-9]+$ ]] && (( BG >= MAX_FG_COLOR_CHOICE_NUM+1 && BG <= MAX_BG_COLOR_CHOICE_NUM )); then
        if [[ "${color_dictionary[$((BG - 1))]}" == "RGB" ]]; then
          BG=$(custom_rgb 'BG')
        fi

        break  # End this loop, the color input is fine for this part, go to the next for-loop iteration
      else
        echo "The background number you entered was invalid. Make sure to use a valid background number this time! (${MAX_FG_COLOR_CHOICE_NUM+1}-${MAX_BG_COLOR_CHOICE_NUM})"
      fi  # Go back to top of while loop and ask for input again

    done

    # - Color numbers in the menu start at 1, color_dictionary starts at 0
    #   Move part number choices down 1 to be level w/ part_dictionary
    # - Non-number selections that already have their color code, like Custom RGB,
    #   don't need to be brought down 1 bc they already got their color code
    if [[ $FG =~ ^[0-9]+$ ]]; then
      FG=${color_dictionary[$((FG - 1))]}  #  Go grab the color code from color_dictionary
    fi

    if [[ $BG =~ ^[0-9]+$ ]]; then
      BG=${color_dictionary[$((BG - 1))]}
    fi

    color_choices+=("${FG},${BG}")

  done
}


# Merge all part and color choices into $final_prompt and $review_prompt
merge() {
  local local_part_choices=("${!1}")
  local local_color_choices=("${!2}")

  review_prompt=""
  final_prompt=""

  # part_choices and color_choices are the same length, every part has a color pair (FG,BG)
  # So if we iterate through one array, we can also go through the other at the same time
  for i in "${!local_part_choices[@]}"; do

    # Parts
    local CHECK="${local_part_choices[${i}]%%,*}"
    local VALUE="${local_part_choices[${i}]#*,}"

    # Colors
    local FG="${local_color_choices[${i}]%%,*}"
    local BG="${local_color_choices[${i}]#*,}"

    review_prompt+="${FG}${BG}"

    # Create review prompt
    case "$CHECK" in
        "MENU")
            review_prompt+="${part_preview_strings[${VALUE}]}" ;;
        "CDT")
            review_prompt+="Datetime (${VALUE})" ;;
        "CPEV")
            review_prompt+="Prompt Var (${VALUE})" ;;
        "CEV")
            review_prompt+="Environment Var (${VALUE})" ;;
        "CUSTOM")
            VALUE="${VALUE//\\/\\\\}"  # Replace \ with \\ for preview_print
            review_prompt+="${VALUE}" ;;
    esac

    review_prompt+="${RC}"  # Don't want to affect next item

    # Create final prompt - Needs color escape for actual terminal prompt
    if [[ "$TYPESHELL" =~ ^[Zz]$ ]]; then  # Zsh color escape %{XYZ%}
      final_prompt+="%{${FG}%}%{${BG}%}"  # Add color before part

      case "$CHECK" in
          "MENU")
              final_prompt+="${part_dictionary[${VALUE}]}" ;;
          "CDT")
              final_prompt+="%D{${VALUE}}" ;;  # %D{string}
          "CPEV"|"CEV")
              final_prompt+="${VALUE}" ;;  # Don't escape - these are variables
          "CUSTOM")
              # Escape all non-variables so we get raw/uninterpreted strings for "CUSTOM"
              local ESCAPED
              ESCAPED=$(escape_chars "${VALUE}")
              final_prompt+="${ESCAPED}" ;;
      esac

      final_prompt+="%{${RC}%}"  # Add reset color after part
    elif [[ "$TYPESHELL" =~ ^[Bb]$ ]]; then  # Bash color escape \\[XYZ\\]
      final_prompt+="\\[${FG}\\]\\[${BG}\\]"

      case "$CHECK" in
          "MENU")
              final_prompt+="${part_dictionary[${VALUE}]}" ;;
          "CDT")
              final_prompt+="\D{${VALUE}}" ;;  # \D{string}
          "CPEV"|"CEV")
              final_prompt+="${VALUE}" ;;
          "CUSTOM")
              local ESCAPED
              ESCAPED=$(escape_chars "${VALUE}")
              final_prompt+="${ESCAPED}" ;;
      esac

      final_prompt+="\\[${RC}\\]"
    fi

  done
}



##############################
###          Main          ###
##############################



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
            ;;
        -u|--usage|-h|--help)
            usage
            ;;
        --uninstall)
            uninstall
            ;;
        --char-table)
            char_table
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
            # If light-mode enabled, use black where necessary
            # If not-enabled, $LM will be empty/blank
            LM='\e[0;30m'
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
            # Handle --separate-file used with no filename arg
            echo -e "\n${RED}ERR${RC}: A valid filename must be used when using --separate-file. Use the -h flag to see proper usage\n" >&2
            exit 1
            ;;
        --separate-file=*)
            separate_file "$1"
            separatefile=true
            shift
            ;;
        *)
            echo -e "\n${RED}ERR${RC}: Unknown flag/option: $1\n" >&2
            exit 1
            ;;
    esac
done


# Welcome Message
echo -e "${LM}${BOLD}\n                ~Welcome to the Shell-${GREEN}C${RED}o${BLUE}l${PURPLE}o${CYAN}r${RC}${LM}${BOLD}-Prompt-Tool v${version}~${RS}"
echo -e "                        @KyleTimmermans\n\n"


read -r -p "Will this be a Zsh or a Bash prompt? Enter 'Z' for Zsh or 'B' for Bash: " TYPESHELL
echo ""

# For choosing the prompt/prompttype, if error, 2 new line buffers. If no error, only need 1 line buffer
isError=false
while :; do
  if [[ "$TYPESHELL" =~ ^[Zz]$ ]] || [[ "$TYPESHELL" =~ ^[Bb]$ ]]; then
    break
  else
    isError=true
    read -r -p "Please choose a valid shell type ('Z' or 'B'): " TYPESHELL
  fi
done

if [[ "$TYPESHELL" =~ ^[Bb]$ ]] && [[ "$omz" == true ]]; then
  if [[ "$isError" == true  ]]; then
    echo ""
  fi

  echo -e "${YELLOW}WARN${RC}: The --omz flag is not applicable to Bash, only Zsh" >&2

  if [[ "$isError" != true  ]]; then
    echo ""
  fi
fi

if [[ "$TYPESHELL" =~ ^[Zz]$ ]]; then
  if [[ "$isError" == true  ]]; then
    echo ""
  fi

  isError=false
  echo -e "Will this be a left-sided prompt (\$PROMPT), a right-sided prompt (\$RPROMPT), or both?\n"
  read -r -p "Enter 'L' for left-sided prompt, 'R' for right-sided prompt, or 'B' for both: " TYPEPROMPT
  echo ""

  while :; do
    if [[ "$TYPEPROMPT" =~ ^[Ll]$ ]] || [[ "$TYPEPROMPT" =~ ^[Rr]$ ]] || [[ "$TYPEPROMPT" =~ ^[Bb]$ ]]; then
      break
    else
      isError=true
      read -r -p "Please choose a valid prompt type ('L' or 'R' or 'B'): " TYPEPROMPT
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
  # We need the l_xyz and r_xyz variables since the pass from PROMPTTYPE
  # to another will overwrite the global vars and we need a persistent vcopy
  parts_menu

  # Choose parts for both
  echo -e "\nLPROMPT:\n--------"
  lprompt_turn=true
  parts_picker
  l_parts=("${part_choices[@]}")
  lprompt_turn=false  # Don't want to check lprompt again in menu()

  echo -e "\n\nRPROMPT:\n--------"
  rprompt_turn=true
  parts_picker
  r_parts=("${part_choices[@]}")
  rprompt_turn=false

  colors_menu

  if [[ ${#l_parts[@]} -gt 0 ]]; then
    echo -e "LPROMPT:\n--------\n"
  fi
  colors_picker "l_parts[@]"
  l_colors=("${color_choices[@]}")

  if [[ ${#r_parts[@]} -gt 0 ]]; then
    echo -e "\n\nRPROMPT:\n--------\n"
  fi
  colors_picker "r_parts[@]"
  r_colors=("${color_choices[@]}")

  merge "l_parts[@]" "l_colors[@]"
  l_review_prompt="$review_prompt"
  l_final_prompt="$final_prompt"

  merge "r_parts[@]" "r_colors[@]"
  r_review_prompt="$review_prompt"
  r_final_prompt="$final_prompt"

  # If user skips one section, don't write out the prompt they didn't create

  # If content in LPROMPT and RPROMPT
  if [[ "$l_final_prompt" != "" ]] && [[ "$r_final_prompt" != "" ]]; then
    preview_print "$l_review_prompt" "$r_review_prompt"

  # If content in LPROMPT, but RPROMPT empty
  elif [[ "$l_final_prompt" != "" ]] && [[ "$r_final_prompt" == "" ]]; then
    # Change prompt type for later checks since the type changed from 'Both' to something else
    TYPEPROMPT='L'
    final_prompt="$l_final_prompt"
    preview_print "$l_review_prompt"

  # If LPROMPT empty, but there is content in RPROMPT
  elif [[ "$l_final_prompt" == "" ]] && [[ "$r_final_prompt" != "" ]]; then
    TYPEPROMPT='R'
    final_prompt="$r_final_prompt"
    preview_print "$r_review_prompt"
  fi

else
  # Single prompt workflow
  parts_menu
  parts_picker

  colors_menu
  colors_picker "part_choices[@]"

  merge "part_choices[@]" "color_choices[@]"

  preview_print "$review_prompt"
fi


read -r -p "Would you like to make this your prompt? (Y/n): " CHOICE


# After accepting prompt
if [[ "$CHOICE" =~ ^[Yy]$ ]]; then

  if [[ "$commentout" == true ]]; then
    comment_out
  fi

  # Disable Oh My Zsh theme which could prevent our prompt from applying
  if [[ "$omz" == true ]]; then
    omz_comment_out
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
    echo -e "\n\n# Added by Shell-Color-Prompt-Tool" >> "$filename"
  else
    echo -e "\n\n" >> "$filename"
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

  # Handle SIGINT/SIGTERM after saving prompt
  trap 'echo -e "\n\n${RED}ERR${RC}: SIGINT/SIGTERM signal receieved, but prompt was already saved!\n" >&2; exit 1' SIGINT SIGTERM

  # Dont print this if we are using the --separate-file flag
  if [[ "$separatefile" == true ]]; then
    echo -e "\n${GREEN}INFO${RC}: Prompt placed in separate file!\n"
  else
    echo -e "\n${GREEN}INFO${RC}: Prompt saved successfully! Restart your terminal now!\n"
  fi

else
  echo -e "\n${YELLOW}WARN${RC}: Prompt not saved, exiting!\n" >&2
fi
