Reference: https://stackoverflow.com/questions/35281630/how-do-i-change-my-ps1-on-a-macbook-for-oh-my-zsh (maybe don't use this one)
           <div>https://scriptingosx.com/2019/07/moving-to-zsh-06-customizing-the-zsh-prompt/</div>
           <div>http://www.nparikh.org/unix/prompt.php (all zsh prompt symbols)</div>
           <div>https://github.com/mayankk2308/set-egpu/blob/master/set-eGPU.sh (elevate privileges)</div>
           <div>https://stackoverflow.com/questions/9268836/zsh-change-prompt-input-color (simple export prompt)
           <div>https://zsh-prompt-generator.site/ (gives more zsh prompt variables)</div>
           <div>https://stackoverflow.com/questions/16843382/colored-shell-script-output-library (Background Colors)</div>

# <div align="center">Zsh-Color-Prompt-Tool</div>

_Customize your Zsh Prompt, from what info you want it to display (Username, Hostname, Symbols, etc), to its Foreground and Background Colors!_

</br>

<div>Fix: /Users/kyletimmermans/.zshrc:2: bad pattern: 31m^[[102m%n^[[0m^[[103m</div>
<div>Test program a lot more</div>
<div>Add to release and make sure curl install line works</div>
<div>Add screenshot of output and cleanup readme</div>

</br>

### Install:
```bash
curl -q -s "https://api.github.com/repos/kyletimmermans/zsh-color-prompt-tool/releases/latest" && chmod +x zsh-color-prompt-tool.zsh && ./zsh-color-prompt-tool.zsh
```

</br>

### Sample Output
centered screenshot from resources here

</br>

### Reset Prompt Back to Default
| Don't like the prompt that got saved and want to change it back to its default? |
|---------------------------------------------------------------------------------|
|1. In your Terminal type: ```vi ~/.zshrc```|
|2. Hit 'i' on your keyboard to start editing the file and remove the "export PROMPT=etc" line|
|3. Hit 'escape (esc)' on your keyboard and then type ```:wq``` and hit enter|
|4. Restart your Terminal|
|Good as new!|
