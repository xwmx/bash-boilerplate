//usr/bin/env go run "$0" "$@"; exit "$?"
//
// An example of a working go shebang, even though it technically isn't one.
// Via:
//   http://stackoverflow.com/a/17900932
package main

import "fmt"

func main() {
	fmt.Println("//usr/bin/env go run \"$0\" \"$@\"; exit \"$?\"")
}
