# Changelog

## 1.11.1
Documented the BASH_ALIASES_LOADED guard in the README.

Explains why a machine's own `~/.bash_aliases` should set `export BASH_ALIASES_LOADED=1` as its first line when the OS default `~/.bashrc` also sources it, so `~/.bash_profile` doesn't load it a second time on a login shell.

_Release date: 08.12.2026_

**Improvements**

- README.md :: documented the `BASH_ALIASES_LOADED` guard and when a machine-specific `~/.bash_aliases` needs to set it

***

## 1.11.0
Submodule status tracking and changelog-driven commits, plus a corrected README

This release adds two new git helpers: one that reports whether each submodule is ahead, behind, or uninitialized relative to its origin, and one that creates a commit straight from the top entry of this changelog. The `s`/`repo_status` command now also runs the submodule check automatically, and correctly picks the highest version tag rather than the most recently created one. The README's setup instructions were corrected to match how `~/.bash_profile` and `~/.vimrc` actually need to be set up.

_Release date: 08.11.2026_

**New**

- .bash_profile :: `submodulestats`/`submodule-status` reports ahead/behind/uninitialized status for each submodule against its origin
- .bash_profile :: `gccr`/`git-commit-from-changelog-release` creates a commit from the top entry of CHANGELOG.md
- .bash_profile :: `gaccrd`/`git-add-commit-changelog-release-deploy` stages, commits from the changelog, and runs `.bin/deploy.sh`
- CLAUDE.md :: added to document the repo for Claude Code

**Improvements**

- .bash_profile :: `repo_status` now guards against running outside a git repository, selects the latest tag by version instead of creation date, and calls `submodule-status`
- .bash_aliases :: `ll` now groups directories first

**Fixes**

- README.md :: corrected the `~/.bash_profile` line to `. /home/maus/.dotfiles/.bash_profile`
- README.md :: corrected `~/.vimrc` setup to be a symlink instead of a sourced file
- .bash_profile :: added the missing trailing newline at end of file

***
