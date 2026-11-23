- [**Practical Git Exercises (Two-Account Lab)**](#practical-git-exercises-two-account-lab)
  - [**Exercise 0: Setup**](#exercise-0-setup)
  - [**Exercise 1: The basic cycle**](#exercise-1-the-basic-cycle)
  - [**Exercise 2: Branches and fast-forward merges**](#exercise-2-branches-and-fast-forward-merges)
  - [**Exercise 3: Create and resolve a merge conflict**](#exercise-3-create-and-resolve-a-merge-conflict)
  - [**Exercise 4: Rebase instead of merge**](#exercise-4-rebase-instead-of-merge)
  - [**Exercise 5: Fix mistakes (amend, reset, revert)**](#exercise-5-fix-mistakes-amend-reset-revert)
  - [**Exercise 6: Stash your work in progress**](#exercise-6-stash-your-work-in-progress)
  - [**Exercise 7: Cherry-pick a single commit**](#exercise-7-cherry-pick-a-single-commit)
  - [**Exercise 8: Recover "lost" work with the reflog**](#exercise-8-recover-lost-work-with-the-reflog)
  - [**Exercise 9: Pull requests between two accounts**](#exercise-9-pull-requests-between-two-accounts)
  - [**Exercise 10: Protect main and require reviews**](#exercise-10-protect-main-and-require-reviews)
  - [**Exercise 11: Tags and releases**](#exercise-11-tags-and-releases)
  - [**Exercise 12: Find a bug with bisect**](#exercise-12-find-a-bug-with-bisect)
  - [**Exercise 13: Force-push and its consequences**](#exercise-13-force-push-and-its-consequences)
  - [**Cleanup and reset**](#cleanup-and-reset)
  - [**Quick reference**](#quick-reference)
# **Practical Git Exercises (Two-Account Lab)**

Thirteen hands-on exercises for one test repo, run across two computers, each signed in to a different GitHub account. No SSH keys and no second clone on one machine: the two computers are your two "people".

**How to read it:** **\[A\]** means do this on Computer A (signed in as Account A, the repo owner). **\[B\]** means do this on Computer B (signed in as Account B, the teammate). Steps marked **\[A \+ B\]** are done on both. Do the exercises in order, since each builds on the last. Replace `ALICE_USER` with Account A's username and `TEST_REPO` with your repo's name.

---

## **Exercise 0: Setup**

**Goal:** Account B can push to Account A's repo, and each computer commits under its own name.

1. **\[A\]** On GitHub, open the test repo, then Settings \> Collaborators \> Add people. Enter Account B's username.  
2. **\[B\]** Accept the invitation (check the email, or open `https://github.com/ALICE_USER/TEST_REPO/invitations` while signed in as Account B).  
3. **\[A \+ B\]** Confirm Git is installed:

```sh
git --version
```

4. **\[A \+ B\]** Let Git use the GitHub account already signed in on that computer. The simplest route is the GitHub CLI:

```sh
gh auth login
gh auth setup-git
gh auth status
```

Choose GitHub.com, HTTPS, and "Login with a web browser". `gh auth status` should show the right account on each computer. If you don't use the CLI, Git Credential Manager (bundled with Git for Windows, and available on macOS and Linux) opens a browser sign-in on your first push instead. If a computer already has another account's saved credentials (macOS Keychain, Windows Credential Manager), remove them first or Git will use the wrong account.

5. **\[A \+ B\]** Clone over HTTPS:

```sh
git clone https://github.com/ALICE_USER/TEST_REPO.git git-lab
cd git-lab
```

If the repo is brand new and empty, do Exercise 1 steps 1 to 3 on Computer A first, then clone on Computer B.

6. **\[A \+ B\]** Set the author for this repo. Use your own name, and the noreply address from GitHub Settings \> Emails:

```sh
git config user.name "Alice (Computer A)"       # use "Bob (Computer B)" on B
git config user.email "ID+USERNAME@users.noreply.github.com"
git branch --show-current                       # should print main
```

7. **\[B\]** Prove Account B has write access:

```sh
git switch -c b-auth-test
git commit --allow-empty -m "Auth test from B"
git push -u origin b-auth-test
```

A 403 or "permission denied" error means the invitation is not accepted yet, or the wrong account's credentials are cached. Once it works, clean up:

```sh
git push origin --delete b-auth-test
git switch main
git branch -D b-auth-test
```

**Check:** `git config user.name` differs on each computer, and Computer B's test push succeeded.

---

## **Exercise 1: The basic cycle**

**Goal:** Stage, commit, push, and see the change arrive on the other computer.

1. **\[A\]** Create a file and look at the status:

```sh
echo "# Git Lab" > README.md
git status
```

2. **\[A\]** Stage and commit:

```sh
git add README.md
git commit -m "Add README"
```

3. **\[A\]** Push:

```sh
git push -u origin main
```

4. **\[B\]** Fetch first and look before you merge:

```sh
git fetch
git log --oneline main..origin/main
```

5. **\[B\]** Then bring it in:

```sh
git pull
```

**Check:** `git log --oneline` on both computers shows the same commit hash.

**Stretch:** Run `git diff` (unstaged), `git diff --staged`, and `git show HEAD`, and explain the difference.

---

## **Exercise 2: Branches and fast-forward merges**

**Goal:** Work on a feature branch and merge it.

1. **\[A\]** Create and switch to a branch:

```sh
git switch -c feature/greeting
```

2. **\[A\]** Add a file and commit twice:

```sh
echo "Hello" > greeting.txt
git add greeting.txt && git commit -m "Add greeting"
echo "Hello, world" > greeting.txt
git commit -am "Expand greeting"
```

3. **\[A\]** View the branch graph:

```sh
git log --oneline --graph --all
```

4. **\[A\]** Merge into main and push:

```sh
git switch main
git merge feature/greeting
git push
```

5. **\[A\]** Clean up the branch:

```sh
git branch -d feature/greeting
```

6. **\[B\]** Pull the result:

```sh
git pull
git log --oneline --graph
```

**Check:** The history is a straight line (a fast-forward, no merge commit) and both computers match.

**Stretch:** Repeat, but make a commit on `main` while the feature branch is open. Merge and observe the merge commit. Then try `git merge --no-ff` on another branch to see the difference.

---

## **Exercise 3: Create and resolve a merge conflict**

**Goal:** Get comfortable reading conflict markers.

1. **\[A \+ B\]** Start from the same point:

```sh
git switch main && git pull
```

2. **\[A\]** Edit line 1 of `README.md` to `# Git Lab by Alice`, then:

```sh
git commit -am "Alice retitles README"
git push
```

3. **\[B\]** Without pulling, edit the same line to `# Git Lab by Bob`:

```sh
git commit -am "Bob retitles README"
git push
```

This push is rejected (non-fast-forward). That is expected.

4. **\[B\]** Pull and trigger the conflict:

```sh
git pull
```

5. **\[B\]** Open `README.md`. You will see:

```
<<<<<<< HEAD
# Git Lab by Bob
=======
# Git Lab by Alice
>>>>>>> origin/main
```

6. **\[B\]** Edit the file to the final text you want (for example `# Git Lab by Alice and Bob`) and delete all three marker lines.  
7. **\[B\]** Finish the merge:

```sh
git add README.md
git commit
git push
```

8. **\[A\]** Pull to get the resolved version:

```sh
git pull
```

**Check:** `git status` is clean and `git log --graph --oneline` shows a merge commit with two parents on both computers.

**Stretch:** Start another conflict and bail out with `git merge --abort`. Also try `git checkout --ours` and `--theirs` on a conflicted file.

---

## **Exercise 4: Rebase instead of merge**

**Goal:** Keep a linear history when your branch is behind.

1. **\[A\]** Create a branch with one commit:

```sh
git switch -c feature/footer
echo "Footer" > footer.txt
git add footer.txt && git commit -m "Add footer"
```

2. **\[B\]** Push a new commit to `main`:

```sh
git switch main && git pull
echo "Notes" > notes.txt
git add notes.txt && git commit -m "Add notes"
git push
```

3. **\[A\]** Rebase your branch onto the updated main:

```sh
git checkout 
git fetch origin
git rebase origin/main
```

4. **\[A\]** Inspect the result:

```sh
git log --oneline --graph
```

5. **\[A\]** Merge (it fast-forwards) and push:

```sh
git switch main && git pull
git merge feature/footer
git push
```

6. **\[B\]** Pull to stay in sync: `git pull`.

**Check:** The history is a single straight line, and "Add footer" now sits after "Add notes" with a new hash.

**Rule to remember:** Only rebase commits that you have not shared with others.

---

## **Exercise 5: Fix mistakes (amend, reset, revert)**

**Goal:** Know which undo tool to use. Parts A to C are on Computer A only.

**A. Amend the last commit** (not yet pushed):

```sh
echo "typo" >> notes.txt
git commit -am "Update notes"
# oops, wrong message and forgot a file
echo "extra" > extra.txt
git add extra.txt
git commit --amend -m "Update notes and add extra"
```

**B. Undo a local commit but keep the changes:**

```sh
git reset --soft HEAD~1    # changes stay staged
git reset HEAD~1           # (mixed) changes stay in working dir, unstaged
```

**C. Throw away a local commit and changes entirely:**

```sh
git reset --hard HEAD~1
```

Do this only on a scratch commit. Run `git status` and `git log` after each variant to see exactly what moved.

**D. Undo a commit that is already pushed.** Never rewrite shared history. Use revert instead:

1. **\[A\]** Make a commit, push it, then undo it safely:

```sh
echo "mistake" >> notes.txt
git commit -am "Add a mistake"
git push
git log --oneline            # find the bad commit hash
git revert <hash>
git push
```

2. **\[B\]** Pull and look:

```sh
git pull
git log --oneline
```

**Check:** The original commit is still in history on both computers, and a new "Revert ..." commit sits on top.

---

## **Exercise 6: Stash your work in progress**

**Goal:** Switch tasks without committing half-finished work. All on Computer A.

1. Edit `README.md` but don't commit.  
2. Try to switch to a branch whose `README.md` differs (create one first with a different line 1 if needed). Git refuses or carries your edit along, depending on overlap.  
3. Stash, do other work, restore:

```sh
git stash push -m "WIP readme edit"
git status                  # clean
git stash list
git stash pop               # changes come back
```

**Check:** After `pop`, your edit is back and `git stash list` is empty.

**Stretch:** `git stash push -u` to include untracked files, and `git stash apply` vs `pop`.

---

## **Exercise 7: Cherry-pick a single commit**

**Goal:** Copy one commit to another branch. All on Computer A.

1. Create two commits on a branch:

```sh
git switch -c experiment
echo "A" > a.txt && git add a.txt && git commit -m "Add a.txt"
echo "B" > b.txt && git add b.txt && git commit -m "Add b.txt"
```

2. Grab only the second commit onto main:

```sh
git log --oneline            # copy hash of "Add b.txt"
git switch main
git cherry-pick <hash>
```

**Check:** `main` has `b.txt` but not `a.txt`.

---

## **Exercise 8: Recover "lost" work with the reflog**

**Goal:** Learn that most mistakes are recoverable. All on Computer A.

1. Make a throwaway commit and destroy it:

```sh
echo "precious" > precious.txt
git add precious.txt && git commit -m "Precious work"
git reset --hard HEAD~1
```

The file and commit appear to be gone.

2. Find it:

```sh
git reflog
```

3. Restore it:

```sh
git reset --hard HEAD@{1}
```

(Or `git switch -c rescued <hash>` to put it on a new branch.)

**Check:** `precious.txt` is back.

---

## **Exercise 9: Pull requests between two accounts**

**Goal:** The review workflow end to end, with a real second reviewer.

**Part 1: Branch and PR (Account B is a collaborator)**

1. **\[A\]** Make sure main is pushed: `git switch main && git push`. Then **\[B\]** `git switch main && git pull`.  
2. **\[B\]** Branch, commit, push:

```sh
git switch -c fix/readme-note
echo "Contributed by Bob" >> README.md
git commit -am "Add contributor note"
git push -u origin fix/readme-note
```

3. **\[B\]** On GitHub, open the "Compare & pull request" banner and create the PR into `main`.  
4. **\[A\]** On GitHub, open the PR, go to Files changed, comment on a line, and choose Request changes.  
5. **\[B\]** Push a follow-up commit to the same branch. The PR updates automatically:

```sh
echo "Thanks reviewers" >> README.md
git commit -am "Address review"
git push
```

6. **\[A\]** Approve the PR and use **Squash and merge**.  
7. **\[A \+ B\]** Sync and clean up:

```sh
git switch main
git pull
git fetch --prune
```

8. **\[B\]** Delete the old local branch. After a squash merge Git doesn't see it as merged, so use `-D`:

```sh
git branch -D fix/readme-note
```

**Check:** The PR shows Merged, main has one new squashed commit, and both computers match.

**Part 2: Fork workflow (optional)**

1. **\[B\]** On GitHub, open Account A's repo and click Fork.  
2. **\[B\]** Clone the fork into a separate folder and add the original as `upstream`:

```sh
cd ..
git clone https://github.com/BOB_USER/TEST_REPO.git git-lab-fork
cd git-lab-fork
git remote add upstream https://github.com/ALICE_USER/TEST_REPO.git
git remote -v
```

3. **\[B\]** Branch, commit, push to your fork, then open a PR from the fork to Account A's `main`:

```sh
git switch -c fix/fork-change
echo "From a fork" >> README.md
git commit -am "Change from fork"
git push -u origin fix/fork-change
```

4. **\[A\]** Review and merge the PR.  
5. **\[B\]** Sync the fork:

```sh
git switch main
git fetch upstream
git merge upstream/main
git push origin main
```

**Check:** The fork's `main` matches upstream.

---

## **Exercise 10: Protect main and require reviews**

**Goal:** See how teams prevent bad pushes.

1. **\[A\]** On GitHub: repo Settings \> Branches (or Rules \> Rulesets) and add a rule for `main` that requires a pull request with 1 approval. Turn on the option that applies the rule to administrators, or Account A can bypass it. Branch protection on private repos may require a paid plan; a public test repo works on any plan.  
2. **\[A\]** Try a direct push:

```sh
git switch main
echo "direct" >> README.md
git commit -am "Direct push"
git push
```

The push should be rejected.

3. **\[A\]** Move the commit to a branch and open a PR properly:

```sh
git switch -c chore/direct-change
git push -u origin chore/direct-change
git switch main
git reset --hard origin/main
```

4. **\[A\]** Open the PR on GitHub. Notice Merge is blocked.  
5. **\[B\]** Review and approve the PR on GitHub.  
6. **\[A\]** Merge it, then `git pull` on main.

**Check:** The merge button was blocked until Account B approved. An author can't approve their own PR, which is why you need two accounts.

---

## **Exercise 11: Tags and releases**

1. **\[A\]** Create an annotated tag and push it (if main is protected, tags are still allowed):

```sh
git switch main && git pull
git tag -a v1.0.0 -m "First release"
git push origin v1.0.0
```

2. **\[A\]** On GitHub, go to Releases \> Draft a new release and select `v1.0.0`.  
3. **\[B\]** Fetch the tag and inspect it:

```sh
git fetch --tags
git tag
git checkout v1.0.0        # detached HEAD, read the warning
git switch main
```

**Check:** Computer B lists `v1.0.0` and can check it out.

---

## **Exercise 12: Find a bug with bisect**

**Goal:** Let Git binary-search history for you. All on Computer A, on a scratch branch.

1. Build a history with a hidden bug:

```sh
git switch -c bisect-demo
for i in 1 2 3 4 5 6 7 8; do
  echo "line $i" >> log.txt
  git add log.txt && git commit -m "Add line $i"
done
echo "BUG" >> log.txt && git commit -am "Introduce bug"
for i in 9 10 11 12; do
  echo "line $i" >> log.txt
  git commit -am "Add line $i"
done
```

2. Bisect:

```sh
git bisect start
git bisect bad HEAD
git bisect good HEAD~13
# git checks out a middle commit; test with:
grep BUG log.txt && git bisect bad || git bisect good
# repeat until it names the first bad commit
git bisect reset
```

**Check:** Git names "Introduce bug" as the first bad commit.

**Stretch:** Automate it: `git bisect run sh -c '! grep -q BUG log.txt'`. Then delete the scratch branch: `git switch main && git branch -D bisect-demo`.

---

## **Exercise 13: Force-push and its consequences**

**Goal:** Understand why shared history shouldn't be rewritten.

1. **\[A\]** Create and push a shared branch:

```sh
git switch main && git pull
git switch -c shared-demo
echo "one" > shared.txt
git add shared.txt && git commit -m "Shared work"
git push -u origin shared-demo
```

2. **\[B\]** Get the branch:

```sh
git fetch
git switch shared-demo
```

3. **\[A\]** Rewrite the commit and push safely:

```sh
git commit --amend -m "Rewritten message"
git push --force-with-lease
```

4. **\[B\]** Run `git pull` and observe the divergence message.  
5. **\[B\]** Recover:

```sh
git fetch
git reset --hard origin/shared-demo
```

**Takeaway:** `--force-with-lease` refuses to overwrite commits you haven't seen. Prefer it over `--force`, and tell teammates before rewriting a shared branch.

---

## **Cleanup and reset**

Delete leftover remote branches from either computer, for example `git push origin --delete shared-demo`, and delete the `v1.0.0` tag with `git push origin --delete v1.0.0`. Remove the branch protection rule if you set it, and delete the `git-lab` and `git-lab-fork` folders on each computer. When you're done with the lab, remove Account B from Settings \> Collaborators.

## **Quick reference**

| Task | Command |
| ----- | ----- |
| See state | `git status`, `git log --oneline --graph --all` |
| Compare | `git diff`, `git diff --staged` |
| Get remote changes safely | `git fetch`, then `git log main..origin/main` |
| Undo unpushed commit | `git reset --soft HEAD~1` |
| Undo pushed commit | `git revert <hash>` |
| Save WIP | `git stash push -m "msg"` |
| Recover lost commits | `git reflog` |
| Safer force-push | `git push --force-with-lease` |
| Check which account is signed in | `gh auth status` |

