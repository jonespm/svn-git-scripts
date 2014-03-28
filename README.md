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
