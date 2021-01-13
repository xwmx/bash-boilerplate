#!/usr/bin/env bats

load test_helper

setup() {
  export _COMMAND="${BATS_TEST_DIRNAME}/../bash-simple-plus"

  export _HELP_HEADER
  _HELP_HEADER="\
     _                 _
 ___(_)_ __ ___  _ __ | | ___   _
/ __| | '_ \` _ \| '_ \| |/ _ \_| |_
\__ \ | | | | | | |_) | |  __/_   _|
|___/_|_| |_| |_| .__/|_|\___| |_|
                |_|"
}

@test "'bash-simple-plus' with no arguments exits with status 0." {
  run "${_COMMAND}"
  [[ "${status}" -eq 0 ]]
}

@test "'bash-simple-plus' with no arguments prints a string." {
  run "${_COMMAND}"
  [[ "${output}" == "Perform a simple operation." ]]
}

@test "'bash-simple-plus -h' with no arguments exits with status 0." {
  run "${_COMMAND}" -h
  [[ "${status}" -eq 0 ]]
}

@test "'bash-simple-plus -h' prints help." {
  run "${_COMMAND}" -h
  _compare "${_HELP_HEADER}" "$(IFS=$'\n'; echo "${lines[*]:0:6}")"
  [[ "$(IFS=$'\n'; echo "${lines[*]:0:6}")" == "${_HELP_HEADER}" ]]
}

@test "'bash-simple-plus --help' with no arguments exits with status 0." {
  run "${_COMMAND}" --help
  [[ "${status}" -eq 0 ]]
}

@test "'bash-simple-plus --help' prints help." {
  run "${_COMMAND}" --help
  _compare "${_HELP_HEADER}" "$(IFS=$'\n'; echo "${lines[*]:0:6}")"
  [[ "$(IFS=$'\n'; echo "${lines[*]:0:6}")" == "${_HELP_HEADER}" ]]
}

@test "'bash-simple-plus -x' with no arguments exits with status 0." {
  run "${_COMMAND}" -x
  [[ "${status}" -eq 0 ]]
}

@test "'bash-simple-plus -x' prints message for option 'x'." {
  run "${_COMMAND}" -x
  [[ "${output}" == "Perform a simple operation with --option-x." ]]
}

@test "'bash-simple-plus --option-x' with no arguments exits with status 0." {
  run "${_COMMAND}" --option-x
  [[ "${status}" -eq 0 ]]
}

@test "'bash-simple-plus --option-x' prints message for option 'x'." {
  run "${_COMMAND}" --option-x
  [[ "${output}" == "Perform a simple operation with --option-x." ]]
}

@test "'bash-simple-plus -o' with no value exits with status 1." {
  run "${_COMMAND}" -o
  [[ "${status}" -eq 1 ]]
}

@test "'bash-simple-plus -o' with no value prints message." {
  run "${_COMMAND}" -o
  printf "\${output}: '%s'\\n" "${output}"
  [[ "${output}" == "$(tput setaf 1)!$(tput sgr0) -o requires a valid argument." ]]
}

@test "'bash-simple-plus -o' with value exits with status 0." {
  run "${_COMMAND}" -o 'short option value'
  [[ "${status}" -eq 0 ]]
}

@test "'bash-simple-plus -o' with value prints optional message." {
  run "${_COMMAND}" -o 'short option value'
  [[ "${lines[0]}" == "Perform a simple operation." ]]
  [[ "${lines[1]}" == "Short option value: short option value" ]]
}

@test "'bash-simple-plus --long-option' with missing value exits with status 1." {
  run "${_COMMAND}" --long-option
  [[ "${status}" -eq 1 ]]
}

@test "'bash-simple-plus --long-option' with missing value prints message." {
  run "${_COMMAND}" --long-option
  printf "\${output}: '%s'\\n" "${output}"
  [[ "${output}" == "$(tput setaf 1)!$(tput sgr0) --long-option requires a valid argument." ]]
}

@test "'bash-simple-plus --long-option' with required value exits with status 0." {
  run "${_COMMAND}" --long-option 'long option value'
  [[ "${status}" -eq 0 ]]
}

@test "'bash-simple-plus --long-option' with required value prints optional message." {
  run "${_COMMAND}" --long-option 'long option value'
  [[ "${lines[0]}" == "Perform a simple operation." ]]
  [[ "${lines[1]}" == "Long option value: long option value" ]]
}
