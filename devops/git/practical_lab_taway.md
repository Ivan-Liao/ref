# Exercise 1 Commits and Pulls
## shows commits that exist in origin/main that are not in main
`git log --oneline main..origin/main`

## shows file level changes that exist in origin/main that are not in main
`git diff --name-status origin/master..master`

# Exercise 2 Commits and Pulls with branches
## shows commits on current branch, with graph, with all commits
`git log --oneline --graph --all`

## merge into main and push
```
git switch main
git merge feature/greeting
git push
```

## delete branch
git branch -d feature/greeting

## pull results
git pull
git log --oneline --graph

# Exercise 3

# Low Priority
1. Line level changes unstaged / before git add
   1. `git diff`
2. Line level changes after staging / after git add
   1. `git diff --staged`
3. Show most recent commit
   1. `git show HEAD`