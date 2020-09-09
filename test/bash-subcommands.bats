#!/usr/bin/env bats

load test_helper

setup() {
  export _COMMAND="${BATS_TEST_DIRNAME}/../bash-subcommands"

  export _HELP_HEADER
  _HELP_HEADER="\
           _                                                   _
 ___ _   _| |__   ___ ___  _ __ ___  _ __ ___   __ _ _ __   __| |___
/ __| | | | '_ \ / __/ _ \| '_ \` _ \\| '_ \` _ \ / _\` | '_ \\ / _\` / __|
\__ \ |_| | |_) | (_| (_) | | | | | | | | | | | (_| | | | | (_| \__ \\
|___/\__,_|_.__/ \___\___/|_| |_| |_|_| |_| |_|\__,_|_| |_|\__,_|___/"
}

@test "\`bash-subcommands\` with no arguments exits with status 0." {
  run "${_COMMAND}"
  [[ "${status}" -eq 0 ]]
}

# subcommands ################################################### subcommands #

@test "\`bash-subcommands subcommands\` returns with 0 status." {
  run "${_COMMAND}" subcommands
  [[ "${status}" -eq 0 ]]
}

@test "\`bash-subcommands subcommands\` prints list of subcommands with header." {
  run "${_COMMAND}" subcommands
  _expected="$(
    cat <<HEREDOC
Available subcommands:
  example
  help
  subcommands
  version
HEREDOC
  )"
  _compare "${_expected}" "${output}"
  [[ "${output}" == "${_expected}" ]]
}

@test "\`bash-subcommands subcommands --raw\` returns with 0 status." {
  run "${_COMMAND}" subcommands --raw
  [[ "${status}" -eq 0 ]]
}

@test "\`bash-subcommands subcommands --raw\` prints list of subcommands." {
  run "${_COMMAND}" subcommands --raw
  _expected="$(
    cat <<HEREDOC
example
help
subcommands
version
HEREDOC
  )"
  _compare "${_expected}" "${output}"
  [[ "${output}" == "${_expected}" ]]
}

# example ########################################################### example #

@test "\`bash-subcommands example\` returns with a 0 status." {
  run "${_COMMAND}" example
  [[ "${status}" -eq 0 ]]
}

@test "\`bash-subcommands example\` prints a string." {
  run "${_COMMAND}" example
  printf "'%s'" "${output}"
  [[ "${output}" == "Hello, World!" ]]
}

@test "\`bash-subcommands example <name>\` returns with a 0 status." {
  run "${_COMMAND}" example Name
  [[ "${status}" -eq 0 ]]
}

@test "\`bash-subcommands example <name>\` prints a string modified by <name>." {
  run "${_COMMAND}" example Name
  printf "'%s'" "${output}"
  [[ "${output}" == "Hello, Name!" ]]
}

@test "\`bash-subcommands example --farewell\` returns with a 0 status." {
  run "${_COMMAND}" example --farewell
  [[ "${status}" -eq 0 ]]
}

@test "\`bash-subcommands example --farewell\` prints a string modified by --farewell." {
  run "${_COMMAND}" example --farewell
  printf "'%s'" "${output}"
  [[ "${output}" == "Goodbye, World!" ]]
}


@test "\`bash-subcommands example <name> --farewell\` returns with a 0 status." {
  run "${_COMMAND}" example Name --farewell
  [[ "${status}" -eq 0 ]]
}

@test "\`bash-subcommands example <name> --farewell\` prints a string modified by both arguments." {
  run "${_COMMAND}" example Name --farewell
  printf "'%s'" "${output}"
  [[ "${output}" == "Goodbye, Name!" ]]
}

# help ################################################################# help #

@test "\`bash-subcommands\` with no arguments prints help." {
  run "${_COMMAND}"
  _compare "${_HELP_HEADER}" "$(IFS=$'\n'; echo "${lines[*]:0:5}")"
  [[ "$(IFS=$'\n'; echo "${lines[*]:0:5}")" == "${_HELP_HEADER}" ]]
}

@test "\`bash-subcommands -h\` prints help." {
  run "${_COMMAND}" -h
  _compare "${_HELP_HEADER}" "$(IFS=$'\n'; echo "${lines[*]:0:5}")"
  [[ "$(IFS=$'\n'; echo "${lines[*]:0:5}")" == "${_HELP_HEADER}" ]]
}

@test "\`bash-subcommands --help\` prints help." {
  run "${_COMMAND}" --help
  _compare "${_HELP_HEADER}" "$(IFS=$'\n'; echo "${lines[*]:0:5}")"
  [[ "$(IFS=$'\n'; echo "${lines[*]:0:5}")" == "${_HELP_HEADER}" ]]
}

@test "\`bash-subcommands help\` prints help." {
  run "${_COMMAND}" help
  _compare "${_HELP_HEADER}" "$(IFS=$'\n'; echo "${lines[*]:0:5}")"
  [[ "$(IFS=$'\n'; echo "${lines[*]:0:5}")" == "${_HELP_HEADER}" ]]
}

@test "\`bash-subcommands help help\` prints \`help\` subcommand usage." {
  run "${_COMMAND}" help help
  _expected="$(
    cat <<HEREDOC
Usage:
  bash-subcommands help [<subcommand>]

Description:
  Display help information for bash-subcommands or a specified subcommand.
HEREDOC
  )"
  _compare "${_expected}" "${output}"
  [[ "${output}" == "${_expected}" ]]
}

# version ########################################################### version #

@test "\`bash-subcommands version\` returns with 0 status." {
  run "${_COMMAND}" version
  [[ "${status}" -eq 0 ]]
}

@test "\`bash-subcommands version\` prints a version number." {
  run "${_COMMAND}" version
  printf "'%s'" "${output}"
  echo "${output}" | grep -q '[0-9]\+\.[0-9]\+\.[0-9]\+'
}

@test "\`bash-subcommands --version\` returns with 0 status." {
  run "${_COMMAND}" --version
  [[ "${status}" -eq 0 ]]
}

@test "\`bash-subcommands --version\` prints a version number." {
  run "${_COMMAND}" --version
  printf "'%s'" "${output}"
  echo "${output}" | grep -q '[0-9]\+\.[0-9]\+\.[0-9]\+'
}
