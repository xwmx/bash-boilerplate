#!/usr/bin/env bats

load test_helper

setup() {
  export _COMMAND="${BATS_TEST_DIRNAME}/../bash-simple"

  export _HELP_HEADER
  _HELP_HEADER="\
      _                 _
  ___(_)_ __ ___  _ __ | | ___
 / __| | '_ \` _ \| '_ \| |/ _ \\
 \__ \ | | | | | | |_) | |  __/
 |___/_|_| |_| |_| .__/|_|\___|
                 |_|"
}

@test "\`bash-simple\` with no arguments exits with status 0." {
  run "${_COMMAND}"
  [[ "${status}" -eq 0 ]]
}

@test "\`bash-simple\` with no arguments prints a string." {
  run "${_COMMAND}"
  [[ "${output}" == "Perform a simple operation." ]]
}

@test "\`bash-simple -h\` prints help." {
  run "${_COMMAND}" -h
  _compare "${_HELP_HEADER}" "$(IFS=$'\n'; echo "${lines[*]:0:6}")"
  [[ "$(IFS=$'\n'; echo "${lines[*]:0:6}")" == "${_HELP_HEADER}" ]]
}

@test "\`bash-simple --help\` prints help." {
  run "${_COMMAND}" --help
  _compare "${_HELP_HEADER}" "$(IFS=$'\n'; echo "${lines[*]:0:6}")"
  [[ "$(IFS=$'\n'; echo "${lines[*]:0:6}")" == "${_HELP_HEADER}" ]]
}
