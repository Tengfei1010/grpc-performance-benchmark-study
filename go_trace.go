package main

import "fmt"
import "time"
import "log"
import "os"
import "runtime/trace"

func fu(from string) {
	for i := 0; i < 100000000000; i ++ {
		//fmt.Println(from, ":", i)
	}
}

func main() {

	f, err := os.Create("trace.out")

	if err != nil {
		log.Fatalf("failed to create trace output file: %v", err)
	}
	defer func() {
		if err := f.Close(); err != nil {
			log.Fatalf("failed to close trace file: %v", err)
		}
	}()

	if err := trace.Start(f); err != nil {
		log.Fatalf("failed to start trace: %v", err)
	}
	defer trace.Stop()

	fu("direct")

	go fu("goroutine")

	go func(msg string) {
		fmt.Println(msg)
	} ("going")

	time.Sleep(2 * time.Second)
	fmt.Println("Done")
}
