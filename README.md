Bash Boilerplate
================

A collection of example bash scripts that can be used as starting points.

I also use these scripts to record and document various common approaches
and conventions that I've learned and encountered while working with bash.
To this end, each script contains a lot of comments attempting to describe
the functionality and syntax as much as possible.

In many cases there are debug statements or example code that demonstrate
functionality or reveal the state of the program at a certain point. These
should generally be removed when customizing the scripts, while retaining
the parts that still apply. Especially in the case of the
`bash-commands` script, it's probably a good idea to play around with
the different features before diving into customization.

## Scripts

There are multiple boilerplate scripts included, each with different
amounts of complexity. Since these are boilerplate scripts, it's easiest
just to start with the simplest structure for the task rather than using
a more complex one and removing a bunch of things that aren't needed.

### [bash-simple](https://github.com/alphabetum/bash-boilerplate/blob/master/bash-simple)

A simple bash script with some basic strictness checks and help features.
Useful for simple programs that don't have many features and don't take
options other than help.

###### Notable Features

- Strict Mode,
- Help template, printable with `-h` or `--help`.

### [bash-simple-plus](https://github.com/alphabetum/bash-boilerplate/blob/master/bash-simple-plus)

A simple bash script with some basic strictness checks, option parsing,
help features, easy debug printing. Useful for regular scripts.

###### Notable Features

- Strict Mode,
- Help template, printable with `-h` or `--help`,
- `debug` printing with `--debug` flag,
- `die` command with error message printing and exiting,
- Option normalization (eg, `-ab -c` -> `-a -b -c`) and option parsing.

### [bash-commands](https://github.com/alphabetum/bash-boilerplate/blob/master/bash-commands)

An example of a bash program with commands. This contains lots of features
and should be usable for creating bash programs that do multiple related
tasks.

###### Notable Features

- Strict Mode,
- Help template, printable with `-h` or `--help`,
- `debug` printing with `--debug` flag,
- `die` command with error message printing and exiting,
- Option normalization (eg, `-ab -c` -> `-a -b -c`) and option parsing,
- Automatic arbitrary command loading,
- An nice, clean pattern for specifying per-command help,
- Built-in commands for help, version, and command listing,
- Conventions for distinguishing between functions and program commands,
- Useful utility functions.

### [functions.bash](https://github.com/alphabetum/bash-boilerplate/blob/master/functions.bash)

Shell function examples and boilerplate. The functions in this file are
intended to be included in the interactive shell, which can be done by
defining them in a shell init file like `~/.bashrc`.

### [helpers.bash](https://github.com/alphabetum/bash-boilerplate/blob/master/helpers.bash)

Helper functions. These functions are primarily intended to be used within
scripts, but can be adapted for use as shell functions.

## Notes

Most of these tips are included in the boilerplate scripts, but I'm also
adding them here for easy reference.

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
[SublimeLinter](http://sublimelinter.readthedocs.org/en/latest/), and Atom via
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
# https://github.com/alphabetum/bash-boilerplate#bash-strict-mode
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

##### Parameter Expansion

This requires using parameter expansion to test for unset variables.

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

##### Usage

Short form:

```bash
set -u
```

Long form:

```bash
set -o nounset
```

---

#### `set -o errexit` / `set -e`

Exit immediately if a pipeline returns non-zero.

NOTE: this has issues. When using `read -rd ''` with a heredoc, the exit
status is non-zero, even though there isn't an error, and this setting
then causes the script to exit. `read -rd ''` is synonymous to `read -d $'\0'`,
which means read until it finds a NUL byte, but it reaches the end of the
heredoc without finding one and exits with a `1` status. Therefore, when
reading from heredocs with `set -e`, there are three potential solutions:

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

##### Usage

Short form:

```bash
set -e
```

Long form:

```bash
set -o errexit
```

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

##### `$DEFAULT_IFS` and `$SAFER_IFS`

`$DEFAULT_IFS` contains the default `$IFS` value in case it's needed, such as
when expanding an array and you want to separate elements by spaces.
`$SAFER_IFS` contains the preferred settings for the program, and setting it
separately makes it easier to switch between the two if needed.

##### Usage

```bash
DEFAULT_IFS="$IFS"
SAFER_IFS=$'\n\t'
IFS="$SAFER_IFS"
```

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
- [Rich’s sh (POSIX shell) tricks (etalabs.net)](http://www.etalabs.net/sh_tricks.htm)
- [Writing Robust Bash Shell Scripts (davidpashley.com)](http://www.davidpashley.com/articles/writing-robust-shell-scripts/)

### Related Projects

- [oxyc/bash-boilerplate](https://github.com/oxyc/bash-boilerplate)
- [e36freak/templates](https://github.com/e36freak/templates)
- [connermcd/bash-boilerplate](https://github.com/connermcd/bash-boilerplate)
- [chrisopedia/bash-boilerplate](https://github.com/chrisopedia/bash-boilerplate)
- [ShaneKilkelly/manuel](https://github.com/ShaneKilkelly/manuel)
- [alphabetum/starters](https://github.com/alphabetum/starters)

### Examples

Scripts based on this project.

- [accounts](https://github.com/alphabetum/accounts)
- [airport](https://github.com/alphabetum/airport)
- [bask](https://github.com/alphabetum/bask)
- [bindle](https://github.com/alphabetum/bindle)
- [hosts](https://github.com/alphabetum/hosts)
- [pb](https://github.com/alphabetum/pb)
- [search.sh](https://github.com/alphabetum/search.sh)
- [vbox](https://github.com/alphabetum/vbox)

---

Copyright (c) 2015 William Melody • hi@williammelody.com
