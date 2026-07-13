1. Finding commit
   1. `git log --oneline`
2. Start rebase
   1. `git rebase -i HEAD~5`
   2. may need to increase the number
3. Edit "pick" to "edit" and then :wq
4. Edit files
5. git add .
6. git commit --amend --no-edit
7. git rebase --continue
8. git push origin master