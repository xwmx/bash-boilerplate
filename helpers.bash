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
# Bash Boilerplate: https://github.com/xwmx/bash-boilerplate
#
# Copyright (c) 2016 William Melody • hi@williammelody.com
###############################################################################

###############################################################################
# _command_exists()
#
# Usage:
#   _command_exists <name>
#
# Exit / Error Status:
#   0 (success, true) If a command with <name> is defined in the current
#                     environment.
#   1 (error,  false) If not.
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
#   _contains <query> <list-item>...
#
# Exit / Error Status:
#   0 (success, true)  If the item is included in the list.
#   1 (error,  false)  If not.
#
# Examples:
#   _contains "${_query}" "${_list[@]}"
_contains() {
  local _query="${1:-}"
  shift

  if [[ -z "${_query}"  ]] ||
     [[ -z "${*:-}"     ]]
  then
    return 1
  fi

  for __element in "${@}"
  do
    [[ "${__element}" == "${_query}" ]] && return 0
  done

  return 1
}

###############################################################################
# _download_from()
#
# Usage:
#   _download_from <url> [<outfile>]
#
# Description:
#   Download the file at <url> and print to standard output or <outfile>, if
#   present. Uses `curl` if available, falling back to `wget`. Messages from
#   `curl` and `wget` are suppressed.
#
# Exit / Error Status:
#   0 (success, true)  If the download is successful.
#   1 (error,  false)  If there was an error.
#
# Examples:
#   # Download and stream to standard output.
#   _download_from "https://example.com" | less
#
#   # Download to outfile with error handling.
#   if ! _download_from "https://example.com/example.pdf" /path/to/example.pdf
#   then
#     printf "Download error.\\n"
#     exit 1
#   fi
_download_from() {
  local _downloaded=0
  local _target_path="${2:-}"
  local _timeout=15
  local _url="${1:-}"

  if [[ -z "${_url}" ]] ||
     [[ ! "${_url}" =~ ^https\:|^http\:|^file\:|^ftp\:|^sftp\: ]]
  then
    return 1
  fi

  if [[ -n "${_target_path}" ]]
  then
    if hash "curl" 2>/dev/null
    then
      curl                              \
        --silent                        \
        --location                      \
        --connect-timeout "${_timeout}" \
        "${_url}"                       \
        --output "${_target_path}"      \
        && _downloaded=1
    elif hash "wget" 2>/dev/null
    then
      wget                              \
        --quiet                         \
        --connect-timeout="${_timeout}" \
        --dns-timeout="${_timeout}"     \
        -O "${_target_path}"            \
        "${_url}"                       \
        2>/dev/null                     \
        && _downloaded=1
    fi
  else
    if hash "curl" 2>/dev/null
    then
      curl                              \
        --silent                        \
        --location                      \
        --connect-timeout "${_timeout}" \
        "${_url}"                       \
        && _downloaded=1
    elif hash "wget" 2>/dev/null
    then
      wget                              \
        --quiet                         \
        --connect-timeout="${_timeout}" \
        --dns-timeout="${_timeout}"     \
        -O -                            \
        "${_url}"                       \
        2>/dev/null                     \
        && _downloaded=1
    fi
  fi

  if ! ((_downloaded))
  then
    return 1
  fi
}

###############################################################################
# _interactive_input()
#
# Usage:
#   _interactive_input
#
# Exit / Error Status:
#   0 (success, true)  If the current input is interactive (eg, a shell).
#   1 (error,  false)  If the current input is stdin / piped input.
_interactive_input() {
  [[ -t 0 ]]
}

###############################################################################
# _join()
#
# Usage:
#   _join <delimiter> <list-item>...
#
# Description:
#   Print a string containing all <list-item> arguments separated by
#   <delimeter>.
#
# Example:
#   _join "${_delimeter}" "${_list[@]}"
#
# More Information:
#   https://stackoverflow.com/a/17841619
_join() {
  local _delimiter="${1:-}"

  shift

  local _joined_string="${1:-}"

  shift

  local __element

  for __element in "${@:-}"
  do
    [[ -n "${__element:-}" ]] || continue

    _joined_string+="${_delimiter:-}${__element:-}"
  done

  printf "%s\\n" "${_joined_string}"
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
# Description:
#   Wrapper for `readlink` that provides portable versions of GNU `readlink -f`
#   and `readlink -e`, which canonicalize by following every symlink in every
#   component of the given name recursively.
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
      -*)
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
      printf "_readlink: missing operand\\n"
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
      printf "%s\\n" "${_final_path}"
      return 0
    elif [[ "${_option}" == "-e" ]]
    then
      if [[ -e "${_final_path}" ]]
      then
        printf "%s\\n" "${_final_path}"
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
    printf "Usage: _spinner <pid>\\n"
    return 1
  fi

  while ps a | awk '{print $1}' | grep -q "${_pid}"
  do
    local _temp="${_spin_string#?}"
    printf " [%c]  " "${_spin_string}"
    _spin_string="${_temp}${_spin_string%${_temp}}"
    sleep ${_delay}
    printf "\\b\\b\\b\\b\\b\\b"
  done
  printf "    \\b\\b\\b\\b"
}
