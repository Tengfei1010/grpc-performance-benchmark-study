package main

import (
	"go/build"
	"go/token"
	"golang.org/x/tools/go/loader"
	"golang.org/x/tools/go/ssa/ssautil"
	"golang.org/x/tools/go/ssa"
	"bytes"
	"io/ioutil"
	"fmt"
)

type members []ssa.Member

// toSSA converts go source to SSA
func toSSA(source string, fileName, packageName string, debug bool) ([]byte, error) {
	// adopted from saa package example
	conf := loader.Config{
		Build: &build.Default,
	}

	file, err := conf.ParseFile(fileName, source)
	if err != nil {
		return nil, err
	}

	conf.CreateFromFiles("main.go", file)

	prog, err := conf.Load()
	if err != nil {
		return nil, err
	}

	ssaProg := ssautil.CreateProgram(prog, ssa.NaiveForm|ssa.BuildSerially)
	ssaProg.Build()
	out := new(bytes.Buffer)

	packages := ssaProg.AllPackages()
	for p := range packages {
		packages[p].SetDebugMode(debug)
		packages[p].WriteTo(out)
		packages[p].Build()
		for _, obj := range packages[p].Members {
			funcs := members([]ssa.Member{})
			if obj.Token() == token.FUNC {
				funcs = append(funcs, obj)
			}
			for _, f := range funcs {
				packages[p].Func(f.Name()).WriteTo(out)
			}
		}
	}


	return out.Bytes(), nil
}

func main() {
	dat, err := ioutil.ReadFile("/home/kevin/GoStudy/src/bugs/deadlock/bolt341.go")
	if err != nil {
		panic(err)
	}
	source := string(dat)
	ssa_out, err := toSSA(source, "main.go", "main", false)
	fmt.Println(string(ssa_out))

}
