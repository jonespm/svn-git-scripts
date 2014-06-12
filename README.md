Sakai SVN -> git scripts
========================

These are a couple of scripts that allow the conversion of a set of git
repositories into one large one through merges. This allows us to keep
the history so that `git blame` still works. However you can't easily
checkout the repository at an earlier point in time as the full repository
only exists after the merges.

It might be possible to rebase all the branches into one ordered by time.
This would allow checkouts from previous points in time.

If we aren't wanting to have checkouts working from the past then we can
probably shrink the git repository size substantially by removing any file
from history that doesn't exist in the current checkout.

We may also want to improve the author names used in commit messages as at
the moment we just use the subversion username with no nice username.

There's currently an example of the conversion in https://github.com/buckett/sakai

The read-tree has an issue in that I think it does a move under the hood, so
prior to the merge of a module there is the pom.xml in master and the pom.xml
to be merged in (both with the same path), but only after the merge does the
path for the module get updated. This means a git blame on the pom.xml inside
the module doesn't work as git can't work out where all the commits came from
and just shows them as coming from the merge commit. The fix for this is to
filter the branch before merging in:


http://stackoverflow.com/questions/4042816/how-can-i-rewrite-history-so-that-all-files-are-in-a-subdirectory

== Flattening history ==

Didn't work off the bat. A commit failed to apply. 

git checkout --orphan rewrite
git reset --hard
git commit --allow-empty -m "Empty start"
git log --reverse --format=%H master | while read sha; do git cherry-pick --allow-empty $sha || break; done

== Remove Files ==

git log --pretty=format: --name-status | cut -f2- | sort -u
git ls-tree -r master --name-only | sort -u

== Merging branches ==

git branch | grep -v master | while read branch; do git merge $branch; done
