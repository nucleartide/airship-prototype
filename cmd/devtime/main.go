package main

import (
	"fmt"
	"math"
	"os"
	"time"
)

func main() {
	start := time.Unix(1544110319, 0)
	duration := time.Since(start)
	days := math.Floor(duration.Hours() / 24)
	hours := math.Floor(math.Mod(duration.Hours(), 24))
	fmt.Fprintf(os.Stdout, "Running dev time: %v days and %v hours.\n", days, hours)
}
