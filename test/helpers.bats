#!/usr/bin/env bats

load test_helper
load ../helpers

###############################################################################
# _command_exists()
###############################################################################

@test "\`_command_exists\` with valid command name returns status 0." {
  run _command_exists 'cat'
  [[ "${status}" -eq 0 ]]
}

@test "\`_command_exists\` with invalid command name returns status 1." {
  run _command_exists 'not-a-valid-command-name'
  [[ "${status}" -eq 1 ]]
}

###############################################################################
# _contains()
###############################################################################

@test "\`_contains\` with valid list element returns status 0." {
  _list=(one two three)
  run _contains "one" "${_list[@]}"
  [[ "${status}" -eq 0 ]]
}

@test "\`_contains\` with invalid list element returns status 1." {
  _list=(one two three)
  run _contains "four" "${_list[@]}"
  [[ "${status}" -eq 1 ]]
}

###############################################################################
# _interactive_input()
###############################################################################

@test "\`_interactive_input\` with argument input returns 0." {
  skip "TODO: determine how to test."
  [[ "${status}" -eq 0 ]]
}

@test "\`_interactive_input\` with invalid list element exits with status 1." {
  skip "TODO: determine how to test."
  [[ "${status}" -eq 1 ]]
}

###############################################################################
# _join()
###############################################################################

@test "\`_join\` with valid arguments returns 0." {
  run _join ',' one two three
  [[ "${status}" -eq 0 ]]
}

@test "\`_join\` with valid arguments joins the elements." {
  run _join ',' one two three
  [[ "${output}" == "one,two,three" ]]
}

###############################################################################
# _readlink()
###############################################################################

@test "\`_readlink\`." {
  skip "TODO: determine how to test."
}

###############################################################################
# _readlink()
###############################################################################

@test "\`_spinner\`." {
  skip "TODO: determine how to test."
}
