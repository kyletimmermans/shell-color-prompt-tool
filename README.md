![Version 1.1](http://img.shields.io/badge/version-v1.1-orange.svg)
![zsh 5.8](https://img.shields.io/badge/zsh-5.8-red.svg)
![Latest commit](https://img.shields.io/github/last-commit/kyletimmermans/zsh-color-prompt-tool?color=lightblue)
![Latest Release Date](https://img.shields.io/github/release-date/kyletimmermans/zsh-color-prompt-tool?color=darkgreen)
[![kyletimmermans Twitter](http://img.shields.io/twitter/url/http/shields.io.svg?style=social&label=Follow)](https://twitter.com/kyletimmermans)

# <div align="center">Zsh-Color-Prompt-Tool</div>

_Customize your Zsh Terminal Prompt, from what info you want it to display (Username, Hostname, Symbols, etc), to its Foreground and Background Colors! It's highly recommended you use brighter colors for extra pop!_

</br>

### Install:
```bash
curl -q -s -LJO "https://github.com/kyletimmermans/zsh-color-prompt-tool/releases/download/latest/zsh-color-prompt-tool.zsh" && chmod +x zsh-color-prompt-tool.zsh && ./zsh-color-prompt-tool.zsh
```

</br>

### Sample Output and Resulting Prompt
<p align="center">
  <img src="https://github.com/kyletimmermans/zsh-color-prompt-tool/blob/master/resources/sample_run.png?raw=true" alt="Sample Program Output"/>
</p>
<p align="center">
  <img src="https://github.com/kyletimmermans/zsh-color-prompt-tool/blob/master/resources/resulting-prompt.png?raw=true" alt="Resulting Prompt"/>
</p>



</br>

### Reset Prompt Back to Default
| Don't like the prompt that got saved and want to change it back to its default? |
|---------------------------------------------------------------------------------|
|1. In your Terminal type: ```vi ~/.zshrc```|
|2. Hit 'i' on your keyboard to start editing the file and remove the "export PROMPT=etc" line|
|3. Hit 'escape (esc)' on your keyboard and then type ```:wq``` and hit enter|
|4. Back in your Terminal now, type ```source ~/.zshrc``` and hit enter|
|5. Restart your Terminal|
|Good as new!|

</br>

### Changelog
<div>v1.0: Initial-Relase</div>
<div>v1.1:</div>
<div>&ensp;&ensp;-Fixed issue where symbol choices misaligned with actual symbol output, found by @christiankuhtz</div>
<div>&ensp;&ensp;-Added period symbol to list of part choices</div>
<div>&ensp;&ensp;-Added --version and -v command line flag</div>
