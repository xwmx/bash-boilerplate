#!/usr/bin/env bats

load test_helper
# NOTE: Redirect output to /dev/null to avoid errors from the anonymous
# function pattern during `bats` runs.
load ../functions > /dev/null 2>&1

###############################################################################
# hello()
###############################################################################

_HELLO_HELP="$(
    cat <<HEREDOC
Usage:
  hello
  hello -h | --help

Options:
  -h --help  Display this usage information.

Description:
  Say 'hello'.
HEREDOC
)"

@test "\`hello\` with no arguments returns status 0." {
  run hello
  [[ "${status}" -eq 0 ]]
}

@test "\`hello\` with no arguments prints a string." {
  run hello
  [[ "${output}" == "Hello." ]]
}

@test "\`hello -h\` returns status 0." {
  run hello -h
  [[ "${status}" -eq 0 ]]
}

@test "\`hello -h\` prints help." {
  run hello -h
  _compare "${_HELLO_HELP}" "${output}"
  [[ "${output}" == "${_HELLO_HELP}" ]]
}

@test "\`hello --help\` returns status 0." {
  run hello
  [[ "${status}" -eq 0 ]]
}

@test "\`hello --help\` prints help." {
  run hello --help
  _compare "${_HELLO_HELP}" "${output}"
  [[ "${output}" == "${_HELLO_HELP}" ]]
}

###############################################################################
# hi()
###############################################################################

_HI_HELP="$(
    cat <<HEREDOC
Usage:
  hi
  hi --all
  hi -h | --help

Options:
  --all      Say 'hi' to everyone.
  -h --help  Display this usage information.

Description:
  Say 'hi'.
HEREDOC
)"

@test "\`hi\` with no arguments returns status 0." {
  run hi
  [[ "${status}" -eq 0 ]]
}

@test "\`hi\` with no arguments prints a string." {
  run hi
  [[ "${output}" == "Hi!" ]]
}

@test "\`hi -h\` returns status 0." {
  run hi -h
  [[ "${status}" -eq 0 ]]
}

@test "\`hi -h\` prints help." {
  run hi -h
  _compare "${_HI_HELP}" "${output}"
  [[ "${output}" == "${_HI_HELP}" ]]
}

@test "\`hi --help\` returns status 0." {
  run hi --help
  [[ "${status}" -eq 0 ]]
}

@test "\`hi --help\` prints help." {
  run hi --help
  _compare "${_HI_HELP}" "${output}"
  [[ "${output}" == "${_HI_HELP}" ]]
}

@test "\`hi --all\` returns status 0." {
  run hi --all
  [[ "${status}" -eq 0 ]]
}

@test "\`hi --all\` prints a string." {
  run hi --all
  _compare "Hi, everyone!" "${output}"
  [[ "${output}" == "Hi, everyone!" ]]
}

###############################################################################
# hey()
###############################################################################

_HEY_HELP="$(
    cat <<HEREDOC
Usage:
  hey
  hey --all
  hey -h | --help

Options:
  --all      Say 'hey' to everyone.
  -h --help  Display this usage information.

Description:
  Say 'hey'.
HEREDOC
)"

@test "\`hey\` with no arguments returns status 0." {
  run hey
  [[ "${status}" -eq 0 ]]
}

@test "\`hey\` with no arguments prints a string." {
  run hey
  [[ "${output}" == "Hey!" ]]
}

@test "\`hey -h\` returns status 0." {
  run hey -h
  [[ "${status}" -eq 0 ]]
}

@test "\`hey -h\` prints help." {
  run hey -h
  _compare "${_HEY_HELP}" "${output}"
  [[ "${output}" == "${_HEY_HELP}" ]]
}

@test "\`hey --help\` returns status 0." {
  run hey --help
  [[ "${status}" -eq 0 ]]
}

@test "\`hey --help\` prints help." {
  run hey --help
  _compare "${_HEY_HELP}" "${output}"
  [[ "${output}" == "${_HEY_HELP}" ]]
}

@test "\`hey --all\` returns status 0." {
  run hey --all
  [[ "${status}" -eq 0 ]]
}

@test "\`hey --all\` prints a string." {
  run hey --all
  _compare "Hey, everyone!" "${output}"
  [[ "${output}" == "Hey, everyone!" ]]
}

###############################################################################
# sup()
###############################################################################

_SUP_HELP="$(
    cat <<HEREDOC
Usage:
  sup
  sup --all
  sup -h | --help
  sup (-t | --to) <name>

Options:
  --all                   Say 'sup' to everyone.
  -h --help               Display this usage information.
  -t <name> --to <name>   Say 'sup' to <name>.

Description:
  Say 'sup'.
HEREDOC
)"

@test "\`sup\` with no arguments returns status 0." {
  run sup
  [[ "${status}" -eq 0 ]]
}

@test "\`sup\` with no arguments prints a string." {
  run sup
  [[ "${output}" == "Sup!" ]]
}

@test "\`sup -h\` returns status 0." {
  run sup -h
  [[ "${status}" -eq 0 ]]
}

@test "\`sup -h\` prints help." {
  run sup -h
  _compare "${_SUP_HELP}" "${output}"
  [[ "${output}" == "${_SUP_HELP}" ]]
}

@test "\`sup --help\` returns status 0." {
  run sup --help
  [[ "${status}" -eq 0 ]]
}

@test "\`sup --help\` prints help." {
  run sup --help
  _compare "${_SUP_HELP}" "${output}"
  [[ "${output}" == "${_SUP_HELP}" ]]
}

@test "\`sup --all\` returns status 0." {
  run sup --all
  [[ "${status}" -eq 0 ]]
}

@test "\`sup --all\` prints a string." {
  run sup --all
  _compare "Sup, everyone!" "${output}"
  [[ "${output}" == "Sup, everyone!" ]]
}

@test "\`sup --to Jack\` returns status 0." {
  run sup --to Jack
  [[ "${status}" -eq 0 ]]
}

@test "\`sup --to Jack\` prints a string." {
  run sup --to Jack
  _compare "Sup, Jack!" "${output}"
  [[ "${output}" == "Sup, Jack!" ]]
}

@test "\`sup --to\` without value returns status 1." {
  run sup --to
  [[ "${status}" -eq 1 ]]
}

@test "\`sup --to\` without value prints an error message." {
  run sup --to
  printf "\${output}: %s" "${output}"
  [[ "${output}" =~ requires\ a\ valid\ argument ]]
}

@test "\`sup -t Jack\` returns status 0." {
  run sup -t Jack
  [[ "${status}" -eq 0 ]]
}

@test "\`sup -t Jack\` prints a string." {
  run sup -t Jack
  _compare "Sup, Jack!" "${output}"
  [[ "${output}" == "Sup, Jack!" ]]
}
