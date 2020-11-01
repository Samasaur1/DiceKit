If you are merging to `master`, please follow these instructions:
1. Your PR title should be "Version $VERSION: $DESCRIPTION", where $VERSION is the next version, and $DESCRIPTION is a description of your changes, in command form (i.e., "add", not "added").
  1. Given version X.Y.Z
    1. If your change is internal/a bug fix, the next version should increment Z
    1. If your change adds a small/related new feature, the next version should increment Y and set Z to 0
    1. If your change is breaking/major/adds a large/unrelated new feature, increment X and set Y and Z to 0.
1. Fill in the list below with your changes, referring to issues when appropriate (https://docs.github.com/articles/closing-issues-using-keywords).
1. Fill in any information you want to share, if you have any. Otherwise, remove that line.
1. Replace the first four checkboxes with any tasks that need to be completed before merging. Leave the changelog and bump version tasks in place, checking them off once you have completed them.
1. Ensure you leave the last three items alone, and at the bottom of your PR body.
1. You can now delete these instructions, so that "Here's what's new" is the first line of your PR body.

Here's what's new:
- A
- List
- Of
- Items

Any other information you want to share here

Here's what has to happen:
- [ ] Anything
- [ ] Specific
- [ ] This
- [ ] PR
- [ ] Ensure the changelog has everything new that is being added
- [ ] Bump version (run `updateVersion.sh`)
1. Wait for CI
1. Merge
1. Run `release.sh`
