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

@test "\`bash-simple-plus\` with no arguments exits with status 0." {
  run "$_COMMAND"
  [[ "$status" -eq 0 ]]
}

@test "\`bash-simple-plus\` with no arguments prints a string." {
  run "$_COMMAND"
  [[ "$output" == "Perform a simple operation." ]]
}

@test "\`bash-simple-plus -h\` with no arguments exits with status 0." {
  run "$_COMMAND" -h
  [[ "$status" -eq 0 ]]
}

@test "\`bash-simple-plus -h\` prints help." {
  run "$_COMMAND" -h
  _compare "$_HELP_HEADER" "$(IFS=$'\n'; echo "${lines[*]:0:6}")"
  [[ "$(IFS=$'\n'; echo "${lines[*]:0:6}")" == "$_HELP_HEADER" ]]
}

@test "\`bash-simple-plus --help\` with no arguments exits with status 0." {
  run "$_COMMAND" --help
  [[ "$status" -eq 0 ]]
}

@test "\`bash-simple-plus --help\` prints help." {
  run "$_COMMAND" --help
  _compare "$_HELP_HEADER" "$(IFS=$'\n'; echo "${lines[*]:0:6}")"
  [[ "$(IFS=$'\n'; echo "${lines[*]:0:6}")" == "$_HELP_HEADER" ]]
}

@test "\`bash-simple-plus -x\` with no arguments exits with status 0." {
  run "$_COMMAND" -x
  [[ "$status" -eq 0 ]]
}

@test "\`bash-simple-plus -x\` prints message for option 'x'." {
  run "$_COMMAND" -x
  [[ "$output" == "Perform a simple operation with --option-x." ]]
}

@test "\`bash-simple-plus --option-x\` with no arguments exits with status 0." {
  run "$_COMMAND" --option-x
  [[ "$status" -eq 0 ]]
}

@test "\`bash-simple-plus --option-x\` prints message for option 'x'." {
  run "$_COMMAND" --option-x
  [[ "$output" == "Perform a simple operation with --option-x." ]]
}

@test "\`bash-simple-plus -o\` with no value exits with status 1." {
  run "$_COMMAND" -o
  [[ "$status" -eq 1 ]]
}

@test "\`bash-simple-plus -o\` with no value prints message." {
  run "$_COMMAND" -o
  [[ "$output" == "❌  Option requires a argument: -o" ]]
}

@test "\`bash-simple-plus -o\` with value exits with status 0." {
  run "$_COMMAND" -o 'short option value'
  [[ "$status" -eq 0 ]]
}

@test "\`bash-simple-plus -o\` with value prints optional message." {
  run "$_COMMAND" -o 'short option value'
  [[ "${lines[0]}" == "Perform a simple operation." ]]
  [[ "${lines[1]}" == "Short option parameter: short option value" ]]
}

@test "\`bash-simple-plus\` with long opt and missing required value exits with status 1." {
  run "$_COMMAND" --long-option-with-argument
  [[ "$status" -eq 1 ]]
}

@test "\`bash-simple-plus\` with long option and missing required value prints message." {
  run "$_COMMAND" --long-option-with-argument
  [[ "$output" =~ "❌  Option requires a argument: --long-option-with-argument" ]]
}

@test "\`bash-simple-plus\` with option and required value exits with status 0." {
  run "$_COMMAND" --long-option-with-argument 'long option value'
  [[ "$status" -eq 0 ]]
}

@test "\`bash-simple-plus\` with option and required value prints optional message." {
  run "$_COMMAND" --long-option-with-argument 'long option value'
  [[ "${lines[0]}" == "Perform a simple operation." ]]
  [[ "${lines[1]}" == "Long option parameter: long option value" ]]
}
