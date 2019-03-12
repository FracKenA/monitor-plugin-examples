package main

//===============================================================================
//
//         FILE: file_check-local-stateless.go
//
//        USAGE: go run file_check-local-stateless
//
//  DESCRIPTION: An exmple of a local, stateless plugin in go. Checks a file
//               to see if it exists, and checks the contents.
//
//      OPTIONS: ---
// REQUIREMENTS: ---
//         BUGS: ---
//        NOTES: ---
//       AUTHOR: Ryan Quinn (RQ)
// ORGANIZATION: OP5
//      VERSION: 0.0.1
//      CREATED: 03/12/2019
//      LICENSE: MIT
//===============================================================================

import "fmt"
import "flag"

var verbose bool
var delay int
var warning string
var critical string
var filepath string
var timeout int

func init() {
	flag.BoolVar(&verbose, "v", false, "Sets how chatty the program is.")
	flag.BoolVar(&verbose, "verbose", false, "Sets how chatty the program is. (long form)")

	flag.IntVar(&delay, "d", 0, "Delays the execution of the check by X seconds.")
	flag.IntVar(&delay, "delay", 0, "Delays the execution of the check by X seconds. (long form)")

	flag.StringVar(&warning, "w", "", "Warning thresholds.")
	flag.StringVar(&warning, "warning", "", "Warning thresholds. (long form)")

	flag.StringVar(&critical, "c", "", "Critical thresholds.")
	flag.StringVar(&critical, "critical", "", "Critical thresholds. (long form)")

	flag.StringVar(&filepath, "f", "", "Path to the file.")
	flag.StringVar(&filepath, "file", "", "Path to the file. (long form)")

	flag.IntVar(&timeout, "t", 10, "Sets the maximum execution time in seconds.")
	flag.IntVar(&timeout, "timeout", 10, "Sets the maximum execution time in seconds. (long form)")
}

func main() {
	flag.Parse()

	if filepath == "" {
		fmt.Println("File path needs to be specified.")
	} else if verbose {
		fmt.Printf("File path: %s\n", filepath)
	}

	if warning == "" && critical == "" {
		fmt.Println("Warning or Critical threshold needs to be defined.")
	} else if verbose {
		if warning != "" {
			fmt.Printf("Warning threshold: %s\n", warning)
		}

		if critical != "" {
			fmt.Printf("Critical threshold: %s\n", critical)
		}
	}
}
