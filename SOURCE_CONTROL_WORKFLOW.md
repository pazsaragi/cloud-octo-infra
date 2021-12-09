# Trunk-based development (Continuous Integration)

"""
Merge small, frequent updates to "trunk" (master in this case).
"""

Trunk-based development is a practice where developers merge small, frequent updates to the main branch. Gitflow focuses on long-lived feature branches and multiple primary branches. Developers create a branch off of develop and merge back in when the feature is complete. This results in a greater chance of integration issues when merging back in. In trunk-based development it is far simpler, where fixes and releases are sourced from the main branch and that branch is assumed to be stable and in a deployable state. Trunk-based development is required for continuous integration. 

## Best Practice

* develop in small batches - short, succinct work with commits being notes
* feature flags - wrap code in feature flags so code paths can be activated later. This avoids the creation of a new feature branch allowing you to commit code to main with a feature flag.
* automated testing
* avoid asynchronous code reviews - code reviews should be performed immediately.
* have 3 or less active branches in the repo - once a branch merges, delete it. Having lots of active branches makes it harder to see what active work is being done.
* merge branches to trunk at least oncea day.
* 

## Continuous Integration

Continuous integration is the practice of automating the integration of code from multiple contributors. Without CI, developers must manually coordinate when merging code back into main. This then extends to operations teams and the rest of the organization. This synchronization causes slower code releases and higher rates of failure as it requires developers to be careful about integrations.

## How To

```
git checkout -b co-XXXX-short-description
```

* Make changes

```
git add ...
git commit -m "Some info"

git push origin co-XXXX-short-description
```

* Check tests pass
* Create PR and merge
* Pull and rebose remote master onto local master branch

```
git checkout master
git pull --rebase origin master
```

### Merge conflicts

```
git checkout master

git pull --rebase origin master

git checkout co-XXXX-some-branch

git pull --rebase origin co-XXXX-some-branch
```

* Frequent rebased is required to avoid merge conflicts since all developers are iterating on master. `git rebase` allows us to temporarly remove any commits on our branch, apply the missing commits from master onto our branch and reapply our commits on top of them. This ensures that we're keeping master's commit history consistent across all branch. Now our branch is up-to-date we can:
s
```
git push origin co-XXXX-some-branch -f
```

* We need to pass the `-f` flag to overwrite the history of the remote branch.

### Fixing off of master

```
git fetch

git rebase origin/master
```

### Branching

When we are on a branch, preparing for a change to be merged into master via a Pull Request, it’s often expected that we make things nice and clean. Maintainers of open source projects will ask you to “squash and rebase” your commits into a single commit to be merged.

This keeps the history of the master branch clean and rollback’s easy to perform.

People will debate on the merits of doing this vs. not doing so, but let’s put all those reasons aside for now, and just focus on how to do it.

If you specify the -i flag or --interactive when you run the rebase command, instead of a regular rebase, you will be performing an “interactive rebase”.

This allows you to reword commits in your little segment of history, or squash multiple commits into a single commit.

Doing so drops you into an editor in your Terminal called vim, and for this reason, knowing the basics of VIM are required in order to perform the interactive rebase. (Press A to enter edit mode, edit it, press Esc, then type :wq, and press Enter). If you aren't familiar with VIM, take some time to read up on the basics.


```
git rebase -i origin/master
```

In order to squash all of the commits, use VIM to edit the messages that say pick to say s or squash for the 2nd and 3rd commits. This will result in a single commit.

git push origin/<branch> --force
After a rebase, you’ve essentially modified the history of commits in the log. If you try to push these changes to origin you will get an error! This is expected.

You need to tell git that you have intended to change the history by using the --force flag. This will replace origin’s log of commits with your new rebased log of commits.

If you have uncommited changes use `git stash` to store them. You can restore those changes with `git stash pop` or `git stash apply`.

## Reading

* [Atlassian: Trunk-based development](https://www.atlassian.com/continuous-delivery/continuous-integration/trunk-based-development)
* [Atlassian: Continuous Integration](https://www.atlassian.com/continuous-delivery/continuous-integration)
* [Atlassian: DevOps](https://www.atlassian.com/devops/what-is-devops/devops-best-practices)
* [Trunk-based development](https://trunkbaseddevelopment.com/)
* [Guide](https://hackernoon.com/a-guide-to-git-with-trunk-based-development-93a350c)
* [How to](https://www.nebulaworks.com/insights/posts/trunk-based-development-for-beginners/)