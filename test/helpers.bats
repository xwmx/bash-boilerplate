#!/usr/bin/env bats

load test_helper
load ../helpers

###############################################################################
# _command_exists()
###############################################################################

@test "'_command_exists' with valid command name returns status 0." {
  run _command_exists 'cat'
  [[ "${status}" -eq 0 ]]
}

@test "'_command_exists' with invalid command name returns status 1." {
  run _command_exists 'not-a-valid-command-name'
  [[ "${status}" -eq 1 ]]
}

###############################################################################
# _contains()
###############################################################################

@test "'_contains' with valid first list element returns status 0." {
  _list=(one two three four)
  run _contains "one" "${_list[@]}"
  [[ "${status}" -eq 0 ]]
}

@test "'_contains' with valid list element returns status 0." {
  _list=(one two three four)
  run _contains "three" "${_list[@]}"
  [[ "${status}" -eq 0 ]]
}

@test "'_contains' with valid element and newlines returns status 0." {
  _list=(
one
two
three
four
)
  run _contains "three" "${_list[@]}"
  [[ "${status}" -eq 0 ]]
}

@test "'_contains' with invalid list element returns status 1." {
  _list=(one two three four)
  run _contains "five" "${_list[@]}"
  [[ "${status}" -eq 1 ]]
}

###############################################################################
# _interactive_input()
###############################################################################

@test "'_interactive_input' with argument input returns 0." {
  skip "TODO: determine how to test."
  [[ "${status}" -eq 0 ]]
}

@test "'_interactive_input' with invalid list element exits with status 1." {
  skip "TODO: determine how to test."
  [[ "${status}" -eq 1 ]]
}

###############################################################################
# _join()
###############################################################################

@test "'_join' with valid arguments returns 0." {
  run _join ',' one two three
  [[ "${status}" -eq 0 ]]
}

@test "'_join' with valid arguments joins the elements with a comma." {
  run _join ',' one two three
  [[ "${output}" == "one,two,three" ]]
}

@test "'_join' with valid arguments joins the elements with a '!'." {
  run _join "!" one two three
  _compare "one!two!three" "${output}"
  [[ "${output}" == "one!two!three" ]]
}

@test "'_join' with newline array joins the elements with a '•'." {
  _array=(
one
two
three
)
  run _join "•" "${_array[@]}"
  _compare "one•two•three" "${output}"
  [[ "${output}" == "one•two•three" ]]
}

@test "'_join' with one element returns that element." {
  run _join ',' one
  [[ "${output}" == "one" ]]
}

@test "'_join' succeeds with two elements." {
  run _join ',' one two
  [[ "${output}" == "one,two" ]]
}

###############################################################################
# _readlink()
###############################################################################

@test "'_readlink'." {
  skip "TODO: determine how to test."
}

###############################################################################
# _readlink()
###############################################################################

@test "'_spinner'." {
  skip "TODO: determine how to test."
}
