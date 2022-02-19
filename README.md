[![Build Status](https://travis-ci.org/xwmx/bash-boilerplate.svg?branch=master)](https://travis-ci.org/xwmx/bash-boilerplate)

Bash Boilerplate
================

A collection of Bash starter scripts for easily creating safe and useful
command line programs.

Bash Boilerplate is great for making standalone, portable, single-file command line
programs as well as shell initialization functions. For a framework
approach that's useful for task and build files, try [Bask](https://github.com/xwmx/bask),
a pure Bash mini-framework for command-centric Bash scripts.

## Scripts

### [bash-simple](https://github.com/xwmx/bash-boilerplate/blob/master/bash-simple)

A simple bash script with some basic strictness checks and help features.
Useful for simple programs that don't have many features and don't take
options other than help.

###### Notable Features

- Strict Mode,
- Help template, printable with `-h` or `--help`.

### [bash-simple-plus](https://github.com/xwmx/bash-boilerplate/blob/master/bash-simple-plus)

A simple bash script with some basic strictness checks, option parsing,
help features, easy debug printing. Useful for regular scripts.

###### Notable Features

- Strict Mode,
- Help template, printable with `-h` or `--help`,
- `debug` printing with `--debug` flag,
- `_exit_1` and `_warn` functions for error messages,
- Option parsing.

### [bash-subcommands](https://github.com/xwmx/bash-boilerplate/blob/master/bash-subcommands)

An example of a bash program with subcommands. This contains lots of features
and should be usable for creating bash programs that do multiple related
tasks.

###### Notable Features

- Strict Mode,
- Help template, printable with `-h` or `--help`,
- `debug` printing with `--debug` flag,
- `_exit_1` and `_warn` functions for error messages,
- Option normalization and parsing,
- Automatic arbitrary subcommand loading,
- An nice, clean pattern for specifying per-subcommand help,
- Built-in subcommands for help, version, and subcommand listing,
- Conventions for distinguishing between functions and program subcommands,
- Useful utility functions.

### [functions.bash](https://github.com/xwmx/bash-boilerplate/blob/master/functions.bash)

Shell function examples and boilerplate. The functions in this file are
intended to be included in the interactive shell, which can be done by
defining them in a shell init file like `~/.bashrc`.

### [helpers.bash](https://github.com/xwmx/bash-boilerplate/blob/master/helpers.bash)

Helper functions. These functions are primarily intended to be used within
scripts, but can be adapted for use as shell functions.

## Notes

### ShellCheck

Use it. It's super useful.

> ShellCheck is a static analysis and linting tool for sh/bash scripts.
It's mainly focused on handling typical beginner and intermediate level
syntax errors and pitfalls where the shell just gives a cryptic error
message or strange behavior, but it also reports on a few more advanced
issues where corner cases can cause delayed failures.

#### Links

- http://www.shellcheck.net/
- http://www.shellcheck.net/about.html
- https://github.com/koalaman/shellcheck

It can be used with Vim via
[Syntastic](https://github.com/scrooloose/syntastic), Emacs via
[Flycheck](https://github.com/flycheck/flycheck), Sublime Text 3 via
[SublimeLinter](http://sublimelinter.readthedocs.org/en/latest/), VS Code via [vscode-shellcheck](https://github.com/timonwong/vscode-shellcheck), and Atom via
[linter](https://atom.io/packages/linter),
[atom-lint](https://atom.io/packages/atom-lint),
or [linter-shellcheck](https://atom.io/packages/linter-shellcheck).

---

### Bash "Strict Mode"

These boilerplate scripts use some common settings for enforcing strictness
in Bash scripts, thereby preventing some errors.

For some additional background, see Aaron Maxwell's
["Unofficial Bash Strict Mode" (redsymbol.net)
](http://redsymbol.net/articles/unofficial-bash-strict-mode/)
post.

---

#### Simple 'Strict Mode' TL;DR

Add this to the top of every script (note: an extended version of this is
already included in the boilerplate scripts):

```bash
# Bash 'Strict Mode'
# http://redsymbol.net/articles/unofficial-bash-strict-mode
# https://github.com/xwmx/bash-boilerplate#bash-strict-mode
set -o nounset
set -o errexit
set -o pipefail
IFS=$'\n\t'
```

---

#### `set -o nounset` / `set -u`

Treat unset variables and parameters other than the special parameters `@` or
`*` as an error when performing parameter expansion. An 'unbound variable'
error message will be written to the standard error, and a non-interactive
shell will exit.

##### Usage

Short form:

```bash
set -u
```

Long form:

```bash
set -o nounset
```

##### Parameter Expansion

Parameter expansion can be used to test for unset variables when using `set -o nounset`.

http://www.gnu.org/software/bash/manual/bashref.html#Shell-Parameter-Expansion

The two approaches that are probably the most appropriate are:

    ${parameter:-word}
      If parameter is unset or null, the expansion of word is substituted.
      Otherwise, the value of parameter is substituted. In other words, "word"
      acts as a default value when the value of "$parameter" is blank. If "word"
      is not present, then the default is blank (essentially an empty string).

    ${parameter:?word}
      If parameter is null or unset, the expansion of word (or a message to that
      effect if word is not present) is written to the standard error and the
      shell, if it is not interactive, exits. Otherwise, the value of parameter
      is substituted.

###### Parameter Expansion Examples

Arrays:

```bash
${some_array[@]:-}              # blank default value
${some_array[*]:-}              # blank default value
${some_array[0]:-}              # blank default value
${some_array[0]:-default_value} # default value: the string 'default_value'
```

Positional variables:

```bash
${1:-alternative} # default value: the string 'alternative'
${2:-}            # blank default value
```

With an error message:

```bash
${1:?'error message'}  # exit with 'error message' if variable is unbound
```

---

#### `set -o errexit` / `set -e`

Exit immediately if a pipeline returns non-zero.

##### Usage

Short form:

```bash
set -e
```

Long form:

```bash
set -o errexit
```

##### Using `set -o errexit` with `read -rd ''`

`set -o errexit` is super useful for avoiding scary errors, but there are some
things to watch out for. When using `read -rd ''` with a heredoc, the
exit status is non-zero, even though there isn't an error, and this
setting then causes the script to exit. `read -rd ''` is equivalent
to `read -d $'\0'`, which means read until it finds a NUL byte, but
it reaches the end of the heredoc without finding one and exits with
a `1` status. Therefore, when reading from heredocs with `set -e`,
there are three potential solutions:

Solution 1. `set +e` / `set -e` again:

```bash
set +e
read -rd '' variable <<HEREDOC
Example text.
HEREDOC
set -e
```

Solution 2. `<<HEREDOC || true`:

```bash
read -rd '' variable <<HEREDOC || true
Example text.
HEREDOC
```

Solution 3. Don't use `set -e` or `set -o errexit` at all.

More information:

['builtin "read -d" behaves differently after "set -e"' (lists.gnu.org)
](https://lists.gnu.org/archive/html/bug-bash/2013-02/msg00007.html)

---

#### `set -o pipefail`

Return value of a pipeline is the value of the last (rightmost) command to
exit with a non-zero status, or zero if all commands in the pipeline exit
successfully.

##### Usage

Long form (no short form available):

```bash
set -o pipefail
```

---

#### `$IFS`

Set IFS to just newline and tab.

```bash
IFS=$'\n\t'
```

For some background, see
[Filenames and Pathnames in Shell: How to do it Correctly (dwheeler.com)
](http://www.dwheeler.com/essays/filenames-in-shell.html)

---

### Misc Notes

Explicitness and clarity are generally preferable, especially since bash can
be difficult to read. This leads to noisier, longer code, but should be
easier to maintain. As a result, some general design preferences:

- Use leading underscores on internal variable and function names in order
  to avoid name collisions. For unintentionally global variables defined
  without `local`, such as those defined outside of a function or
  automatically through a `for` loop, prefix with double underscores.
- Always use braces when referencing variables, preferring `${NAME}` instead
  of `$NAME`. Braces are only required for variable references in some cases,
  but the cognitive overhead involved in keeping track of which cases require
  braces can be reduced by simply always using them.
- Prefer `printf` over `echo`. For more information, see:
  http://unix.stackexchange.com/a/65819
- Prefer `$_explicit_variable_name` over names like `$var`.
- Use the `#!/usr/bin/env bash` shebang in order to run the preferred
  Bash version rather than hard-coding a `bash` executable path.
- Prefer splitting statements across multiple lines rather than writing
  one-liners.
- Group related code into sections with large, easily scannable headers.
- Describe behavior in comments as much as possible, assuming the reader is
  a programmer familiar with the shell, but not necessarily experienced writing
  shell scripts.

### Resources

- [About ShellCheck (shellcheck.net)](http://www.shellcheck.net/about.html)
- [Bash Reference Manual (gnu.org)](http://www.gnu.org/software/bash/manual/bashref.html)
- [POSIX: Shell Command Language (pubs.opengroup.org)
](http://pubs.opengroup.org/onlinepubs/9699919799/utilities/V3_chap02.html)
- [The Art of Command Line (github.com)](https://github.com/jlevy/the-art-of-command-line)
- ["Unofficial Bash Strict Mode" (redsymbol.net)
](http://redsymbol.net/articles/unofficial-bash-strict-mode/)
- [Filenames and Pathnames in Shell: How to do it Correctly (dwheeler.com)
](http://www.dwheeler.com/essays/filenames-in-shell.html)
- [Understanding Exit Codes and how to use them in bash scripts (bencane.com)
](http://bencane.com/2014/09/02/understanding-exit-codes-and-how-to-use-them-in-bash-scripts/)
- ['builtin "read -d" behaves differently after "set -e"' (lists.gnu.org)
](https://lists.gnu.org/archive/html/bug-bash/2013-02/msg00007.html)
- [Bash Pitfalls (mywiki.wooledge.org)
](http://mywiki.wooledge.org/BashPitfalls)
- [Rich’s sh (POSIX shell) tricks (etalabs.net)](http://www.etalabs.net/sh_tricks.html)
- [Writing Robust Bash Shell Scripts (davidpashley.com)](http://www.davidpashley.com/articles/writing-robust-shell-scripts/)
- [Bash Strict Mode (github.com)](https://github.com/tests-always-included/wick/blob/master/doc/bash-strict-mode.md)
- [pure bash bible - A collection of pure bash alternatives to external processes (github.com)](https://github.com/dylanaraps/pure-bash-bible)

### Related Projects

- [oxyc/bash-boilerplate](https://github.com/oxyc/bash-boilerplate)
- [e36freak/templates](https://github.com/e36freak/templates)
- [connermcd/bash-boilerplate](https://github.com/connermcd/bash-boilerplate)
- [chrisopedia/bash-boilerplate](https://github.com/chrisopedia/bash-boilerplate)
- [ShaneKilkelly/manuel](https://github.com/ShaneKilkelly/manuel)
- [kvz/bash3boilerplate](https://github.com/kvz/bash3boilerplate)
- [ralish/bash-script-template](https://github.com/ralish/bash-script-template)

### Examples

Scripts based on this project.

- [airport](https://github.com/xwmx/airport) - A command line tool for Wi-Fi on macOS.
- [bask](https://github.com/xwmx/bask) - A pure Bash mini-framework for command-centric Bash scripts.
- [bindle](https://github.com/xwmx/bindle) - A configuration and dotfile management tool for your personal unix-like computer.
- [hosts](https://github.com/xwmx/hosts) - Command line hosts file editor in a single portable script.
- [❯ nb](https://github.com/xwmx/nb) - CLI note-taking, bookmarking, and archiving with encryption, advanced search, Git-backed versioning and syncing, Pandoc-backed conversion, and more in a single portable script.
- [notes-app-cli](https://github.com/xwmx/notes-app-cli) - A command line interface for Notes.app on macOS.
- [pb](https://github.com/xwmx/pb) - A tiny wrapper combining pbcopy & pbpaste in a single command.
- [search.sh](https://github.com/xwmx/search.sh) - A command line search multi-tool.
- [user](https://github.com/xwmx/user) - Command line interface for common macOS user account operations.
- [vbox](https://github.com/xwmx/vbox) - A streamlined interface for VBoxManage, the VirtualBox command line tool.

---

Copyright (c) 2015 William Melody • hi@williammelody.com
