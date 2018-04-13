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
