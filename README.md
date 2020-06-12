Reference: https://stackoverflow.com/questions/35281630/how-do-i-change-my-ps1-on-a-macbook-for-oh-my-zsh (maybe don't use this one)
           <div>https://scriptingosx.com/2019/07/moving-to-zsh-06-customizing-the-zsh-prompt/</div>
           <div>http://www.nparikh.org/unix/prompt.php (all zsh prompt symbols)</div>
           <div>https://github.com/mayankk2308/set-egpu/blob/master/set-eGPU.sh (eleveate privileges) (readline immediately)</div>
           <div>https://stackoverflow.com/questions/9268836/zsh-change-prompt-input-color (simple export prompt)
           <div>https://zsh-prompt-generator.site/ (gives more zsh prompt variables)</div>

Steps:
1. Print Welcome Message
2. Elevate privileges, if not given correct permissions, print error
3. Show list of parts of prompt
4. Let them chose which parts they want and hit done
5. Now Print list of colors for reference
6. Allow them to chose each piece of their PROMPT and color it (Foreground and Background)
7. Show them a preview of final prompt and if they want to start over
8. Place export PROMPT="their choices" into ~/.zshrc.   (prompt has to be wrapped in quotes I think)
9. source ~/.zshrc
10. echo "Changes Saved"
11. exit

<div>-For install: Make curl that auto runs, auto chmod +x, autodeletes itself</div>
<div>&ensp;</div>
<p> Esentially creating nice one line string with user preferences from pretty menu that will be exported to ./zshrc </p>

```bash
curl -q -s "https://api.github.com/repos/kyletimmermans/zsh-color-prompt-tool/releases/latest"
```

</br>

## Also check built in colors for zsh

<p align="center">
  <img src="https://github.com/kyletimmermans/zsh-color-prompt-tool/blob/master/resources/color-list.png?raw=true" alt="Color List"/>
</p>
