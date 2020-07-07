#!/usr/bin/env bats

load test_helper
# NOTE: Redirect output to /dev/null to avoid errors from the anonymous
# function pattern during `bats` runs.
load ../functions > /dev/null 2>&1

###############################################################################
# one()
###############################################################################

_ONE_HELP="$(
    cat <<HEREDOC
Usage:
  one
  one -h | --help

Options:
  -h --help  Display this usage information.

Description:
  Say 'hello'.
HEREDOC
)"

@test "\`one\` with no arguments returns status 0." {
  run one
  [[ "${status}" -eq 0 ]]
}

@test "\`one\` with no arguments prints a string." {
  run one
  [[ "${output}" == "Hello." ]]
}

@test "\`one -h\` returns status 0." {
  run one -h
  [[ "${status}" -eq 0 ]]
}

@test "\`one -h\` prints help." {
  run one -h
  _compare "${_ONE_HELP}" "${output}"
  [[ "${output}" == "${_ONE_HELP}" ]]
}

@test "\`one --help\` returns status 0." {
  run one
  [[ "${status}" -eq 0 ]]
}

@test "\`one --help\` prints help." {
  run one --help
  _compare "${_ONE_HELP}" "${output}"
  [[ "${output}" == "${_ONE_HELP}" ]]
}

###############################################################################
# two()
###############################################################################

_TWO_HELP="$(
    cat <<HEREDOC
Usage:
  two
  two --all
  two -h | --help

Options:
  --all      Say 'hello' to everyone.
  -h --help  Display this usage information.

Description:
  Say 'hello'.
HEREDOC
)"

@test "\`two\` with no arguments returns status 0." {
  run two
  [[ "${status}" -eq 0 ]]
}

@test "\`two\` with no arguments prints a string." {
  run two
  [[ "${output}" == "Hello!" ]]
}

@test "\`two -h\` returns status 0." {
  run two -h
  [[ "${status}" -eq 0 ]]
}

@test "\`two -h\` prints help." {
  run two -h
  _compare "${_TWO_HELP}" "${output}"
  [[ "${output}" == "${_TWO_HELP}" ]]
}

@test "\`two --help\` returns status 0." {
  run two --help
  [[ "${status}" -eq 0 ]]
}

@test "\`two --help\` prints help." {
  run two --help
  _compare "${_TWO_HELP}" "${output}"
  [[ "${output}" == "${_TWO_HELP}" ]]
}

@test "\`two --all\` returns status 0." {
  run two --all
  [[ "${status}" -eq 0 ]]
}

@test "\`two --all\` prints a string." {
  run two --all
  _compare "Hello, everyone!" "${output}"
  [[ "${output}" == "Hello, everyone!" ]]
}

###############################################################################
# three()
###############################################################################

_THREE_HELP="$(
    cat <<HEREDOC
Usage:
  three
  three --all
  three -h | --help

Options:
  --all      Say 'hello' to everyone.
  -h --help  Display this usage information.

Description:
  Say 'hello'.
HEREDOC
)"

@test "\`three\` with no arguments returns status 0." {
  run three
  [[ "${status}" -eq 0 ]]
}

@test "\`three\` with no arguments prints a string." {
  run three
  [[ "${output}" == "Hello!" ]]
}

@test "\`three -h\` returns status 0." {
  run three -h
  [[ "${status}" -eq 0 ]]
}

@test "\`three -h\` prints help." {
  run three -h
  _compare "${_THREE_HELP}" "${output}"
  [[ "${output}" == "${_THREE_HELP}" ]]
}

@test "\`three --help\` returns status 0." {
  run three --help
  [[ "${status}" -eq 0 ]]
}

@test "\`three --help\` prints help." {
  run three --help
  _compare "${_THREE_HELP}" "${output}"
  [[ "${output}" == "${_THREE_HELP}" ]]
}

@test "\`three --all\` returns status 0." {
  run three --all
  [[ "${status}" -eq 0 ]]
}

@test "\`three --all\` prints a string." {
  run three --all
  _compare "Hello, everyone!" "${output}"
  [[ "${output}" == "Hello, everyone!" ]]
}

###############################################################################
# four()
###############################################################################

_FOUR_HELP="$(
    cat <<HEREDOC
Usage:
  four
  four --all
  four -h | --help
  four (-t | --to) <name>

Options:
  --all                   Say 'hello' to everyone.
  -h --help               Display this usage information.
  -t <name> --to <name>   Say 'hello' to <name>.

Description:
  Say 'hello'.
HEREDOC
)"

@test "\`four\` with no arguments returns status 0." {
  run four
  [[ "${status}" -eq 0 ]]
}

@test "\`four\` with no arguments prints a string." {
  run four
  [[ "${output}" == "Hello!" ]]
}

@test "\`four -h\` returns status 0." {
  run four -h
  [[ "${status}" -eq 0 ]]
}

@test "\`four -h\` prints help." {
  run four -h
  _compare "${_FOUR_HELP}" "${output}"
  [[ "${output}" == "${_FOUR_HELP}" ]]
}

@test "\`four --help\` returns status 0." {
  run four --help
  [[ "${status}" -eq 0 ]]
}

@test "\`four --help\` prints help." {
  run four --help
  _compare "${_FOUR_HELP}" "${output}"
  [[ "${output}" == "${_FOUR_HELP}" ]]
}

@test "\`four --all\` returns status 0." {
  run four --all
  [[ "${status}" -eq 0 ]]
}

@test "\`four --all\` prints a string." {
  run four --all
  _compare "Hello, everyone!" "${output}"
  [[ "${output}" == "Hello, everyone!" ]]
}

@test "\`four --to Jack\` returns status 0." {
  run four --to Jack
  [[ "${status}" -eq 0 ]]
}

@test "\`four --to Jack\` prints a string." {
  run four --to Jack
  _compare "Hello, Jack!" "${output}"
  [[ "${output}" == "Hello, Jack!" ]]
}

@test "\`four --to\` without value returns status 1." {
  run four --to
  [[ "${status}" -eq 1 ]]
}

@test "\`four --to\` without value prints an error message." {
  run four --to
  printf "\${output}: %s" "${output}"
  [[ "${output}" =~ requires\ a\ valid\ argument ]]
}

@test "\`four -t Jack\` returns status 0." {
  run four -t Jack
  [[ "${status}" -eq 0 ]]
}

@test "\`four -t Jack\` prints a string." {
  run four -t Jack
  _compare "Hello, Jack!" "${output}"
  [[ "${output}" == "Hello, Jack!" ]]
}
