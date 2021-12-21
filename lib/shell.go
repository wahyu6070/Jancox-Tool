// Go Shell by wahyu6070


package shell

import (
	"fmt"
	"strings"
	"log"
	"os"
	"os/exec"
	"io"
	"io/ioutil"
	"path/filepath"
	"runtime"
	"archive/zip"
)
func CLEAR() error{
	if runtime.GOOS == "linux" {
		cmd := exec.Command("clear")
        cmd.Stdout = os.Stdout
        cmd.Run()
	} else if runtime.GOOS == "android" {
		cmd := exec.Command("clear")
        cmd.Stdout = os.Stdout
        cmd.Run()
	} else if runtime.GOOS == "windows" {
		cmd := exec.Command("cmd", "/c", "cls") 
        cmd.Stdout = os.Stdout
        cmd.Run()
        
	} else {
		fmt.Println("! Clear <your platform not support> <" + runtime.GOOS + ">")
		os.Exit(1)
	}
	return nil
	}
func SED(INPUT string, OUTPUT string, FILE string){
		input, err := ioutil.ReadFile(FILE)
        if err != nil {
                log.Fatalln(err)
        }

        lines := strings.Split(string(input), "\n")

        for i, line := range lines {
                if strings.Contains(line, INPUT,) {
                        lines[i] = OUTPUT
                }
        }
        output := strings.Join(lines, "\n")
        err = ioutil.WriteFile(FILE, []byte(output), 0644)
        if err != nil {
                log.Fatalln(err)
        }
	
	}
func GET_PROP(INPUT string, FILE string) string{
	input, err := ioutil.ReadFile(FILE)
        if err != nil {
                log.Fatalln(err)
        }

        lines := strings.Split(string(input), "\n")

        for _, line := range lines {
                if strings.Contains(line, INPUT,) {
                        SPLIT := strings.Split(line, "=")
                        //fmt.Println(SPLIT[1])
                        return SPLIT[1]
                }
        }
        return ``
	}
	
func IS_DIRNAME() string{
	ex, err := os.Executable()
    if err != nil {
        panic(err)
    }
    BASE := filepath.Dir(ex)
	//fmt.Println(BASE)
	return BASE
	}
func IsEmpty(name string) (error) {
    f, err := os.Open(name)
    if err != nil {
        return err
    }
    defer f.Close()

    _, err = f.Readdirnames(1) // Or f.Readdir(1)
    if err == io.EOF {
        return nil
    }
    return err // Either not empty or error, suits both cases
}
func UNZIP(src, dest string) error {
    r, err := zip.OpenReader(src)
    if err != nil {
        return err
    }
    defer func() {
        if err := r.Close(); err != nil {
            panic(err)
        }
    }()

    os.MkdirAll(dest, 0755)

    // Closure to address file descriptors issue with all the deferred .Close() methods
    extractAndWriteFile := func(f *zip.File) error {
        rc, err := f.Open()
        if err != nil {
            return err
        }
        defer func() {
            if err := rc.Close(); err != nil {
                panic(err)
            }
        }()

        path := filepath.Join(dest, f.Name)

        // Check for ZipSlip (Directory traversal)
        if !strings.HasPrefix(path, filepath.Clean(dest) + string(os.PathSeparator)) {
            return fmt.Errorf("illegal file path: %s", path)
        }

        if f.FileInfo().IsDir() {
            os.MkdirAll(path, f.Mode())
        } else {
            os.MkdirAll(filepath.Dir(path), f.Mode())
            f, err := os.OpenFile(path, os.O_WRONLY|os.O_CREATE|os.O_TRUNC, f.Mode())
            if err != nil {
                return err
            }
            defer func() {
                if err := f.Close(); err != nil {
                    panic(err)
                }
            }()

            _, err = io.Copy(f, rc)
            if err != nil {
                return err
            }
        }
        return nil
    }

    for _, f := range r.File {
        err := extractAndWriteFile(f)
        if err != nil {
            return err
        }
    }

    return nil
}

