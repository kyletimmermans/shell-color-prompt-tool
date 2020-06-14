Reference: https://stackoverflow.com/questions/35281630/how-do-i-change-my-ps1-on-a-macbook-for-oh-my-zsh (maybe don't use this one)
           <div>https://scriptingosx.com/2019/07/moving-to-zsh-06-customizing-the-zsh-prompt/</div>
           <div>http://www.nparikh.org/unix/prompt.php (all zsh prompt symbols)</div>
           <div>https://github.com/mayankk2308/set-egpu/blob/master/set-eGPU.sh (eleveate privileges) (readline immediately)</div>
           <div>https://stackoverflow.com/questions/9268836/zsh-change-prompt-input-color (simple export prompt)
           <div>https://zsh-prompt-generator.site/ (gives more zsh prompt variables)</div>
           <div>https://stackoverflow.com/questions/16843382/colored-shell-script-output-library (Background Colors)</div>

<div>-For install: Make curl that auto runs, auto chmod +x, autodeletes itself</div>
<div>&ensp;</div>
<p> Esentially creating nice one line string with user preferences from pretty menu that will be exported to ./zshrc </p>

```bash
curl -q -s "https://api.github.com/repos/kyletimmermans/zsh-color-prompt-tool/releases/latest" && chmod +x zsh-color-prompt-tool.zsh && ./zsh-color-prompt-tool.zsh && rm zsh-color-prompt-tool.zsh
```
