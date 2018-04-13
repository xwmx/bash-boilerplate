#!/usr/bin/env bash
# _          _
# | |__   ___| |_ __   ___ _ __ ___
# | '_ \ / _ \ | '_ \ / _ \ '__/ __|
# | | | |  __/ | |_) |  __/ |  \__ \
# |_| |_|\___|_| .__/ \___|_|  |___/
#             |_|
#
# Helper functions.
#
# These functions are primarily intended to be used within scripts. Each name
# starts with a leading underscore to indicate that it is an internal
# function and avoid collisions with gloablly defined names.
#
# Bash Boilerplate: https://github.com/alphabetum/bash-boilerplate
#
# Copyright (c) 2016 William Melody • hi@williammelody.com
###############################################################################

###############################################################################
# _command_exists()
#
# Usage:
#   _command_exists <command-name>
#
# Returns:
#   0  If a command with the given name is defined in the current environment.
#   1  If not.
#
# Information on why `hash` is used here:
# http://stackoverflow.com/a/677212
_command_exists() {
  hash "${1}" 2>/dev/null
}

###############################################################################
# _contains()
#
# Usage:
#   _contains <item> <list>
#
# Example:
#   _contains "$item" "${list[*]}"
#
# Returns:
#   0  If the item is included in the list.
#   1  If not.
_contains() {
  local _test_list
  IFS=" " read -r -a _test_list <<< "${*:2}"
  for __test_element in "${_test_list[@]:-}"
  do
    if [[ "${__test_element}" == "${1}" ]]
    then
      return 0
    fi
  done
  return 1
}

###############################################################################
# _interactive_input()
#
# Usage:
#   _interactive_input
#
# Returns:
#   0  If the current input is interactive (eg, a shell).
#   1  If the current input is stdin / piped input.
_interactive_input() {
  [[ -t 0 ]]
}

###############################################################################
# _join()
#
# Usage:
#   _join <separator> <array>
#
# Examples:
#   _join , a "b c" d     => a,b c,d
#   _join / var local tmp => var/local/tmp
#   _join , "${FOO[@]}"   => a,b,c
#
# More Information:
#   http://stackoverflow.com/a/17841619
_join() {
  local IFS="${1}"
  shift
  printf "%s\n" "${*}"
}

###############################################################################
# _readlink()
#
# Usage:
#   _readlink [-e|-f|<options>] <path/to/symlink>
#
# Options:
#   -f  All but the last component must exist.
#   -e  All components must exist.
#
# Wrapper for `readlink` that provides portable versions of GNU `readlink -f`
# and `readlink -e`, which canonicalize by following every symlink in every
# component of the given name recursively.
#
# More Information:
#   http://stackoverflow.com/a/1116890
_readlink() {
  local _target_path
  local _target_file
  local _final_directory
  local _final_path
  local _option

  for __arg in "${@:-}"
  do
    case "${__arg}" in
      -e|-f)
        _option="${__arg}"
        ;;
      -*|--*)
        # do nothing
        # ':' is bash no-op
        :
        ;;
      *)
        if [[ -z "${_target_path:-}" ]]
        then
          _target_path="${__arg}"
        fi
        ;;
    esac
  done

  if [[ -z "${_option}" ]]
  then
    readlink "${@}"
  else
    if [[ -z "${_target_path:-}" ]]
    then
      printf "_readlink: missing operand\n"
      return 1
    fi

    cd "$(dirname "${_target_path}")" || return 1
    _target_file="$(basename "${_target_path}")"

    # Iterate down a (possible) chain of symlinks
    while [[ -L "${_target_file}" ]]
    do
      _target_file="$(readlink "${_target_file}")"
      cd "$(dirname "${_target_file}")" || return 1
      _target_file="$(basename "${_target_file}")"
    done

    # Compute the canonicalized name by finding the physical path
    # for the directory we're in and appending the target file.
    _final_directory="$(pwd -P)"
    _final_path="${_final_directory}/${_target_file}"

    if [[ "${_option}" == "-f" ]]
    then
      printf "%s\n" "${_final_path}"
      return 0
    elif [[ "${_option}" == "-e" ]]
    then
      if [[ -e "${_final_path}" ]]
      then
        printf "%s\n" "${_final_path}"
        return 0
      else
        return 1
      fi
    else
      return 1
    fi
  fi
}

###############################################################################
# _spinner()
#
# Usage:
#   _spinner <pid>
#
# Description:
#   Display an ascii spinner while <pid> is running.
#
# Example Usage:
#   ```
#   _spinner_example() {
#     printf "Working..."
#     (sleep 1) &
#     _spinner $!
#     printf "Done!\n"
#   }
#   (_spinner_example)
#   ```
#
# More Information:
#   http://fitnr.com/showing-a-bash-spinner.html
_spinner() {
  local _pid="${1:-}"
  local _delay=0.75
  local _spin_string="|/-\\"

  if [[ -z "${_pid}" ]]
  then
    printf "Usage: _spinner <pid>\n"
    return 1
  fi

  while ps a | awk '{print $1}' | grep -q "${_pid}"
  do
    local _temp="${_spin_string#?}"
    printf " [%c]  " "${_spin_string}"
    _spin_string="${_temp}${_spin_string%${_temp}}"
    sleep ${_delay}
    printf "\b\b\b\b\b\b"
  done
  printf "    \b\b\b\b"
}
