#!/usr/bin/env bats

load test_helper

setup() {
  export _COMMAND="${BATS_TEST_DIRNAME}/../bash-commands"

  export _HELP_HEADER
  _HELP_HEADER="\
                                                .___
  ____  ____   _____   _____ _____    ____    __| _/______
_/ ___\\/  _ \\ /     \\ /     \\\\__  \\  /    \\  / __ |/  ___/
\\  \\__(  <_> )  Y Y  \\  Y Y  \\/ __ \\|   |  \\/ /_/ |\\___ \\
 \\___  >____/|__|_|  /__|_|  (____  /___|  /\\____ /____  >
     \\/            \\/      \\/     \\/     \\/      \\/    \\/"
}

@test "\`bash-commands\` with no arguments exits with status 0." {
  run "${_COMMAND}"
  [[ "${status}" -eq 0 ]]
}

# commands ######################################################### commands #

@test "\`bash-commands commands\` returns with 0 status." {
  run "${_COMMAND}" commands
  [[ "${status}" -eq 0 ]]
}

@test "\`bash-commands commands\` prints list of commands with header." {
  run "${_COMMAND}" commands
  _expected="$(
    cat <<HEREDOC
Available commands:
  commands
  example
  help
  version
HEREDOC
  )"
  _compare "${_expected}" "${output}"
  [[ "${output}" == "${_expected}" ]]
}

@test "\`bash-commands commands --raw\` returns with 0 status." {
  run "${_COMMAND}" commands --raw
  [[ "${status}" -eq 0 ]]
}

@test "\`bash-commands commands --raw\` prints list of commands." {
  run "${_COMMAND}" commands --raw
  _expected="$(
    cat <<HEREDOC
commands
example
help
version
HEREDOC
  )"
  _compare "${_expected}" "${output}"
  [[ "${output}" == "${_expected}" ]]
}

# example ########################################################### example #

@test "\`bash-commands example\` returns with a 0 status." {
  run "${_COMMAND}" example
  [[ "${status}" -eq 0 ]]
}

@test "\`bash-commands example\` prints a string." {
  run "${_COMMAND}" example
  printf "'%s'" "${output}"
  [[ "${output}" == "Hello, World!" ]]
}

@test "\`bash-commands example <name>\` returns with a 0 status." {
  run "${_COMMAND}" example Name
  [[ "${status}" -eq 0 ]]
}

@test "\`bash-commands example <name>\` prints a string modified by <name>." {
  run "${_COMMAND}" example Name
  printf "'%s'" "${output}"
  [[ "${output}" == "Hello, Name!" ]]
}

@test "\`bash-commands example --farewell\` returns with a 0 status." {
  run "${_COMMAND}" example --farewell
  [[ "${status}" -eq 0 ]]
}

@test "\`bash-commands example --farewell\` prints a string modified by --farewell." {
  run "${_COMMAND}" example --farewell
  printf "'%s'" "${output}"
  [[ "${output}" == "Goodbye, World!" ]]
}


@test "\`bash-commands example <name> --farewell\` returns with a 0 status." {
  run "${_COMMAND}" example Name --farewell
  [[ "${status}" -eq 0 ]]
}

@test "\`bash-commands example <name> --farewell\` prints a string modified by both arguments." {
  run "${_COMMAND}" example Name --farewell
  printf "'%s'" "${output}"
  [[ "${output}" == "Goodbye, Name!" ]]
}

# help ################################################################# help #

@test "\`bash-commands\` with no arguments prints help." {
  run "${_COMMAND}"
  _compare "${_HELP_HEADER}" "$(IFS=$'\n'; echo "${lines[*]:0:6}")"
  [[ "$(IFS=$'\n'; echo "${lines[*]:0:6}")" == "${_HELP_HEADER}" ]]
}

@test "\`bash-commands -h\` prints help." {
  run "${_COMMAND}" -h
  _compare "${_HELP_HEADER}" "$(IFS=$'\n'; echo "${lines[*]:0:6}")"
  [[ "$(IFS=$'\n'; echo "${lines[*]:0:6}")" == "${_HELP_HEADER}" ]]
}

@test "\`bash-commands --help\` prints help." {
  run "${_COMMAND}" --help
  _compare "${_HELP_HEADER}" "$(IFS=$'\n'; echo "${lines[*]:0:6}")"
  [[ "$(IFS=$'\n'; echo "${lines[*]:0:6}")" == "${_HELP_HEADER}" ]]
}

@test "\`bash-commands help\` prints help." {
  run "${_COMMAND}" help
  _compare "${_HELP_HEADER}" "$(IFS=$'\n'; echo "${lines[*]:0:6}")"
  [[ "$(IFS=$'\n'; echo "${lines[*]:0:6}")" == "${_HELP_HEADER}" ]]
}

@test "\`bash-commands help help\` prints \`help\` subcommand usage." {
  run "${_COMMAND}" help help
  _expected="$(
    cat <<HEREDOC
Usage:
  bash-commands help [<command>]

Description:
  Display help information for bash-commands or a specified command.
HEREDOC
  )"
  _compare "${_expected}" "${output}"
  [[ "${output}" == "${_expected}" ]]
}

# version ########################################################### version #

@test "\`bash-commands version\` returns with 0 status." {
  run "${_COMMAND}" version
  [[ "${status}" -eq 0 ]]
}

@test "\`bash-commands version\` prints a version number." {
  run "${_COMMAND}" version
  printf "'%s'" "${output}"
  echo "${output}" | grep -q '[0-9]\+\.[0-9]\+\.[0-9]\+'
}

@test "\`bash-commands --version\` returns with 0 status." {
  run "${_COMMAND}" --version
  [[ "${status}" -eq 0 ]]
}

@test "\`bash-commands --version\` prints a version number." {
  run "${_COMMAND}" --version
  printf "'%s'" "${output}"
  echo "${output}" | grep -q '[0-9]\+\.[0-9]\+\.[0-9]\+'
}
