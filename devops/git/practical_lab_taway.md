# shows commits that exist in origin/main that are not in main
`git log --oneline main..origin/main`

# shows file level changes that exist in origin/main that are not in main
`git diff --name-status origin/master..master`

# Low Priority
1. Line level changes unstaged / before git add
   1. `git diff`
2. Line level changes after staging / after git add
   1. `git diff --staged`
3. Show most recent commit
   1. `git show HEAD`