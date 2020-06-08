Reference: https://stackoverflow.com/questions/35281630/how-do-i-change-my-ps1-on-a-macbook-for-oh-my-zsh
           <div>https://scriptingosx.com/2019/07/moving-to-zsh-06-customizing-the-zsh-prompt/</div>
           <div>http://www.nparikh.org/unix/prompt.php</div>
           <div>https://github.com/mayankk2308/set-egpu/blob/master/set-eGPU.sh (eleveate privileges)</div>

Steps:
1. Print Welcome Message
2. Elevate privileges, if not possible, print error
3. Grab their current PROMPT
4. Decode what each piece of their PROMPT is (large case statement, check each possible '%{symbol}')
5. Print list of colors for reference
6. Allow them to chose each piece of their PROMPT and color it
7. source ~/.zshrc
8. echo "Changes Saved"
9. exit
10 . Make curl that auto runs, auto chmod +x, autodeletes itself

<p align="center">
  <img src="https://github.com/kyletimmermans/zsh-color-prompt-tool/blob/master/resources/color-list.png?raw=true" alt="Color List"/>
</p>
