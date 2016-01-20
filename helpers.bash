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
  local IFS="$1"
  shift
  printf "%s\n" "$*"
}
