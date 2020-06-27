# <div align="center">Zsh-Color-Prompt-Tool</div>

_Customize your Zsh Prompt, from what info you want it to display (Username, Hostname, Symbols, etc), to its Foreground and Background Colors! It's highly recommended you use brighter colors for extra pop! The install script will also remove the file for you after it's done running._

</br>

### Install:
```bash
curl -q -s -LJO "https://github.com/kyletimmermans/zsh-color-prompt-tool/releases/download/latest/zsh-color-prompt-tool.zsh" && chmod +x zsh-color-prompt-tool.zsh && ./zsh-color-prompt-tool.zsh && rm zsh-color-prompt-tool.zsh
```

</br>

### Sample Output and Resulting Prompt
<p align="center">
  <img src="https://github.com/kyletimmermans/zsh-color-prompt-tool/blob/master/resources/sample-run.png?raw=true" alt="Sample Program Output"/>
</p>
<p align="center">
  <img src="https://github.com/kyletimmermans/zsh-color-prompt-tool/blob/master/resources/result-prompt.png?raw=true" alt="Resulting Prompt"/>
</p>



</br>

### Reset Prompt Back to Default
| Don't like the prompt that got saved and want to change it back to its default? |
|---------------------------------------------------------------------------------|
|1. In your Terminal type: ```vi ~/.zshrc```|
|2. Hit 'i' on your keyboard to start editing the file and remove the "export PROMPT=etc" line|
|3. Hit 'escape (esc)' on your keyboard and then type ```:wq``` and hit enter|
|4. Restart your Terminal|
|Good as new!|
