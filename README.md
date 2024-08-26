![Version 3.1](http://img.shields.io/badge/version-v3.1-orange.svg)
![Zsh 5.8](https://img.shields.io/badge/Zsh-5.8-red.svg)
![Bash 5.1.16](https://img.shields.io/badge/Bash-5.1.16-red.svg)
![Latest commit](https://img.shields.io/github/last-commit/kyletimmermans/shell-color-prompt-tool?color=lightblue)
![Latest Release Date](https://img.shields.io/github/release-date/kyletimmermans/shell-color-prompt-tool?color=darkgreen)
[![kyletimmermans Twitter](http://img.shields.io/twitter/url/http/shields.io.svg?style=social&label=Follow)](https://twitter.com/kyletimmermans)

# <div align="center">Shell-Color-Prompt-Tool</div>

Customize your Zsh/Bash terminal prompt, from what info you want it to display (Username, Hostname, Symbols, etc), to its Foreground and Background Colors! All from the command line. Use brighter colors for extra pop!

</br>

### Install as a Command - "scpt":
```bash
curl -q -s -LJO "https://github.com/kyletimmermans/shell-color-prompt-tool/releases/download/latest/shell-color-prompt-tool.sh" && chmod +x shell-color-prompt-tool.sh && sudo mv shell-color-prompt-tool.sh /usr/local/bin/scpt
```

</br>

### Temporary Use in Current Directory:
```bash
curl -q -s -LJO "https://github.com/kyletimmermans/shell-color-prompt-tool/releases/download/latest/shell-color-prompt-tool.sh" && chmod +x shell-color-prompt-tool.sh
```

<br>

#### Dependencies (For the --comment-out and --omz flags to work, if you choose to use them):

###### Linux (Debian-based)
```bash
sudo apt install -y gawk
```

###### MacOS (Homebrew)
```bash
brew install gawk gnu-sed
```

###### MacOS (MacPorts)
```bash
sudo port install gawk gsed
```

</br>

### Sample Program Walkthrough
<p align="center">
  <img src="https://github.com/kyletimmermans/shell-color-prompt-tool/blob/master/media/prompt_walkthrough_v3.1.png?raw=true" alt="Sample Program Walkthrough"/>
</p>

### Resulting Prompt
<p align="center">
  <img src="https://github.com/kyletimmermans/shell-color-prompt-tool/blob/master/media/final_prompt_example.png?raw=true" alt="Resulting Prompt"/>
</p>

</br>

### Program Flags

| Flag | Explanation |
| ---- | ----------- |
| --comment-out | Comment out older prompt lines in .zshrc/.bashrc e.g. PROMPT= / PS1= to help prevent conflicting prompt definitions |
| --light-mode | Better color contrast for the color picker menu on white/light-colored terminal backgrounds |
| --omz | Disables your 'Oh My Zsh' theme if you have one, which could get in the way of applying your new prompt |
| --no-extras | Don't automatically add a newline to the start of the prompt and a space to the end of the prompt |
| -h/--help/-u/--usage | Show usage/help menu |
| -v/--version | Get program version. Reveal if a newer version is available on GitHub |

</br>

### Usage Notes
> [!NOTE]
> * #### You don't need to add a newline character at the beginning of your prompt for spacing between actual prompts, one will be added for you. Same with a space after the prompt so there's space between the prompt and inputted commands, one will automatically be added for you. This feature can be disabled with the --no-extras flag
> * #### If you want to use the --comment-out or --omz flags, you must have 'gawk' and 'gsed' installed. On Mac, you'll need to install both. On Linux, you just need gawk, as gsed should already be your default sed version
> * #### For the actual prompt string in the .zshrc/.bashrc file, some text editors like Sublime Text will show the ANSI escape characters like "\e[0;30m" as "<0x1b>". Use a text editor like Vim to show the raw text
> * #### Fullscreen terminals will be able to fit the spacing and styling of the interactive prompt the best  
> * #### Colors may vary from system to system. When using the Custom RGB option, make sure your terminal supports TRUECOLOR (See [here](https://github.com/termstandard/colors))

</br>

### Reset Prompt Back to Default
| Don't like the prompt that got saved and want to change it back to its default? |
|---------------------------------------------------------------------------------|
|1. In your Terminal type: ```vi ~/.zshrc``` or ```vi ~/.bashrc```|
|2. Hit 'i' on your keyboard to start editing the file and remove the line(s) at the bottom of the file, "export PROMPT=etc" (Zsh) or "export PS1=etc" (Bash), that has the comment above it "Added by Shell-Color-Prompt-Tool"|
|3. If you used --comment-out or --omz, uncomment your old prompt lines where the line above it says "Commented out by Shell-Color-Prompt-Tool" |
|4. Hit 'escape (esc)' on your keyboard and then type ```:wq``` and hit enter|
|5. Back in your Terminal now, type ```source ~/.zshrc``` or ```source ~/.bashrc``` and hit enter|
|6. Restart your Terminal|
|Good as new!|

</br>

### Changelog
<div>v1.0: Initial-Relase</div>
<div>v1.1:</div>
<div>&ensp;&ensp;-Fixed issue where symbol choices misaligned with actual symbol output, found by @christiankuhtz</div>
<div>&ensp;&ensp;-Added period symbol to list of part choices</div>
<div>&ensp;&ensp;-Added --version and -v command line flag</div>
<div>&ensp;&ensp;-Fixed prompt spacing and wording</div>
<div>v2.0:</div>
<div>&ensp;&ensp;-Support for Bash added so its been changed from "Zsh-Color-Prompt-Tool" to "Shell-Color-Prompt-Tool"</div>
<div>&ensp;&ensp;-Added option to edit either a standard user prompt (PROMPT) or root prompt (RPROMPT), or both for Zsh</div>
<div>&ensp;&ensp;-Any added line(s) will have the comment above it, "Added by Zsh Color Prompt Tool" so the user knows which prompts were generated by the program</div>
<div>&ensp;&ensp;-Added --omz, --light-mode, --comment-out, and --no-extras flags</div>
<div>&ensp;&ensp;-Added more symbols and colors to chose from in the menus</div>
<div>&ensp;&ensp;-Added automatic newline to front of generated prompt and extra space to the end for cleaner prompt and terminal UX</div>
<div>&ensp;&ensp;-Messing up a color no longer makes you redo the foreground and background color, just the one that was incorrect</div>
<div>&ensp;&ensp;-Fixed issue where colors weren't properly escaped and could cause visual bugs</div>
<div>&ensp;&ensp;-Added: -h/--help & -u/--usage flags</div>
<div>v2.5:</div>
<div>&ensp;&ensp;-Added Custom RGB color option</div>
<div>&ensp;&ensp;-Fixed error messsages showing incorrect range of color options</div>
<div>&ensp;&ensp;-Updated and cleaned up help/usage flag output</div>
<div>v2.7:</div>
<div>&ensp;&ensp;-Force gawk usage, even on Linux, as there could be multiple awk types installed</div>
<div>&ensp;&ensp;-Removed OS-specific commands in --comment-out and --omz functionality</div>
<div>&ensp;&ensp;&ensp;&ensp;-Everything is using gawk and gsed now</div>
<div>&ensp;&ensp;-Fixed some wording in the --help menu</div>
<div>v3.0:</div>
<div>&ensp;&ensp;-Better logic for ensuring gawk & gsed usage when using --comment-out or --omz flags</div>
<div>&ensp;&ensp;-The version flag will show reveal whether an updated version of the tool is available</div>
<div>v3.1:</div>
<div>&ensp;&ensp;-Added error handling for version update check</div>
