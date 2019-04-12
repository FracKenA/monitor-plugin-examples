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

import (
	"bytes"
	"flag"
	"fmt"
	"io/ioutil"
	"os"
	"strconv"
	"strings"
	"time"
)

//Options
var verbose bool
var delay time.Duration
var warning string
var critical string
var filepath string
var timeout int

//Vars
type ThresholdData struct {
	Check          bool
	Inclusive      bool
	RangeStartOpen bool
	RangeStart     int
	RangeEnd       int
}

func init() {
	flag.BoolVar(&verbose, "v", false, "Sets how chatty the program is.")
	flag.BoolVar(&verbose, "verbose", false, "Sets how chatty the program is. (long form)")

	flag.DurationVar(&delay, "d", 0, "Delays the execution of the check by X seconds.")
	flag.DurationVar(&delay, "delay", 0, "Delays the execution of the check by X seconds. (long form)")

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

	var warnData ThresholdData
	var critData ThresholdData

	if filepath == "" {
		fmt.Println("UNKNOWN - File path needs to be specified.")
		os.Exit(3)
	} else if verbose {
		fmt.Printf("File path: %s\n", filepath)
	}

	if warning == "" && critical == "" {
		fmt.Println("UNKNOWN - Warning or Critical threshold needs to be defined.")
		os.Exit(3)
	} else {
		//Parseing Warning threshold.
		if warning != "" {
			if verbose {
				fmt.Printf("Warning threshold: %s\n", warning)
			}
			//Parsing logic here.
		} else {
			warnData.Check = false
		}

		//Parsing Critical threshold.
		if critical != "" {
			if verbose {
				fmt.Printf("Critical threshold: %s\n", critical)
			}
			//Parsing logic here.
		} else {
			critData.Check = false
		}
	}

	if verbose {
		fmt.Printf("Exec delay: %d\n", delay)
		fmt.Printf("Timeout: %d\n", timeout)
	}

	// Reading the file contents into memory.
	dataRaw, err := ioutil.ReadFile(filepath)
	if err != nil {
		fmt.Printf("UNKNOWN - %s\n", err)
		os.Exit(3)
	}

	// Removing whitespace and converting the []byte slice to a string.
	//data := string(bytes.TrimSpace(dataRaw))

	data, err := strconv.Atoi(string(bytes.TrimSpace(dataRaw)))
	if err != nil {
		fmt.Printf("UNKNOW - %s\n", err)
		os.Exit(3)
	}

	if verbose {
		fmt.Printf("Data from file: %d\n", data)
	}

	if delay != 0 {
		if verbose {
			fmt.Printf("Delaying execution for %d seconds...", delay)
		}
		time.Sleep(delay * time.Second)
		if verbose {
			fmt.Printf("\tDone\n")
		}
	}

	//retVal, serviceStatus, serviceDescription := getStatus(data)

}

func parseThreshold(dataStruct ThresholdData, dataRaw string) {
	dataStruct.Check = true
	symbolAt := false
	symbolTilde := false

	if strings.Contains(dataRaw, ":") {
		dataSplit := strings.Split(dataRaw, ":")
	} else {
		//Add regex to check for any characters besides numbers.
		dataStruct.Inclusive = false
		dataStruct.RangeStartOpen = false
		dataStruct.RangeStart = 0
		dataStruct.RangeEnd, err = strconv.Atoi(dataRaw)

		if err != nil {
			fmt.Printf("UNKNOW - %s\n", err)
			os.Exit(3)
		}

	}

	//if strings.ContainsAny(dataRaw, "@~") {
	//	if strings.Contains(dataRaw, "@") {
	//		dataStruct.Inclusive = true
	//		symbolAt = true
	//	}

	//	if strings.Contains(dataRaw, "~") {
	//		dataStruct.RangeStartOpen = true
	//		dataStruct.RangeStart = 0
	//		symbolTilde = true
	//	}

	//	if symbolAt && symbolTilde {
	//	}
	//}
}
