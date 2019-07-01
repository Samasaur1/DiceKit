---
name: PR to master
about: Merging development into master
title: 'Version $VERSION: $DESCRIPTION'
labels: needs-labeling
assignees: ''

---

Here's what's new:
- A
- List
- Of
- Items

Here's what has to happen:
- [ ] Anything
- [ ] Specific
- [ ] This
- [ ] PR
- [ ] Ensure the changelog has everything new that is being added
- [ ] Bump version
1. Wait for CI
1. Merge
1. `git checkout master`
1. `git pull`
1. `git tag -s v$VERSION -m "Version $VERSION: $DESCRIPTION"`
1. `git push --tags`
1. `git checkout development`
1. `git pull`
1. `git rebase master`
1. `git push`
