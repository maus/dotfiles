# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

Personal dotfiles for `maus`, cloned to `~/.dotfiles` and wired into the shell via symlink/source (not a build/install script). There is no build, lint, or test tooling — changes are validated by sourcing the affected file and checking shell behavior manually (e.g. `source ~/.bash_profile` or opening a new shell).

## Setup (from README.md)

- `~/.bash_profile` is expected to just contain `. /home/maus/.dotfiles/.bash_profile`
- `~/.vimrc` is a symlink: `cd ~ && ln -s .dotfiles/.vimrc .vimrc`
- Anything machine-specific belongs outside these dotfiles (e.g. in the real `~/.bash_profile`), not inside this repo — this repo is meant to be portable across machines.

## File map and load order

- `.bash_profile` — entry point sourced by `~/.bash_profile`. Sets history behavior (`HISTCONTROL`, `histappend`, `HISTTIMEFORMAT`), then sources `.bash_aliases` and `.bash_prompt`, then defines a set of functions/aliases (see below), then sources `wp-completion.bash` if present.
- `.bash_aliases` — simple one-line aliases (ls, git log formats, `vhosts`/`www` shortcuts, etc.).
- `.bash_prompt` — Solarized-Dark-based `PS1`/`PS2` prompt, including a `prompt_git()` helper that shows branch name and dirty/staged/untracked/stash status (`+`/`!`/`?`/`$`) in the prompt.
- `.bashrc` — trivial, just sources `~/.bash_profile`.
- `.vimrc` — vim config (no plugin manager); tabs/indent set to width 4 (despite the "2 spaces please" comment being stale), wildignore for build artifacts.
- `wp-completion.bash` — bash completion for the WP-CLI (`wp`) command, sourced conditionally at the end of `.bash_profile`.
- `.vscode-extensions.sh` — one-off script (not sourced) listing `code --install-extension` commands to replicate VS Code extensions on a new machine.

## Functions/aliases defined in `.bash_profile`

These are the non-trivial, custom pieces of logic in the repo — read them directly when modifying:

- `s` / `repo_status` — prints `git status` plus latest tag / latest release tag, then calls `submodule-status`.
- `upd` / `edit_and_source_file` — opens a file in vim, then sources it (used for quickly editing and reloading dotfiles).
- `ts` / `convert_date_to_utc_timestamp` — converts a `"YYYY-MM-DD HH:MM"`-style string (UTC) to a Unix timestamp.
- `fetch` / `fetch_origin_and_checkout_tag` — `git fetch origin` then checks out tag `v$1`.
- `gccr` / `git-commit-from-changelog-release` — parses the first release entry out of a `CHANGELOG.md` (see "CHANGELOG.md format" below) and creates a git commit from it after confirmation.
- `gaccrd` / `git-add-commit-changelog-release-deploy` — `git add .` + `gccr` + runs `.bin/deploy.sh` in the current (target) repo, not this dotfiles repo.
- `submodulestats` / `submodule-status` — iterates `.gitmodules` in the current repo, fetches each submodule's origin, and reports ahead/behind status color-coded (green=up to date, yellow=out of sync, red=uninitialized/unreachable).

Note: several of these functions (`gccr`, `gaccrd`, `submodule-status`) operate on *whatever git repo the shell's cwd is in*, not on this dotfiles repo — they're general-purpose git helpers installed globally via `.bash_profile`.

## CHANGELOG.md format

Every release entry in a `CHANGELOG.md` targeted by `gccr`/`gaccrd` follows this shape, top entry first:

```
## X.Y.Z
One-sentence summary of the release.

Optional 2-3 paragraph explanation of the release, written for non-engineers.

_Release date: MM.DD.YYYY_

**New**

- ...

**Improvements**

- ...

**Fixes**

- ...

***
```

- Version is full semver (`X.Y.Z`), directly under the release, no leading `[`/`]`.
- The one-sentence summary sits on the line immediately after the header, no blank line between them.
- `gccr` treats everything from the header up to the first line starting with `**` as the commit message body — so the summary and optional explanation paragraphs become the commit message; the `**New**`/`**Improvements**`/`**Fixes**` sections and everything after are not included.
- Releases are separated by a `***` line.
- Only fill in a real version and release date at the moment a release actually happens — never invent or backdate one.
