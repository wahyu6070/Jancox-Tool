package main

import (
"fmt"
"jancox/lib"
"os"
"os/exec"
"runtime"
"path/filepath"
"path"
"log"
)

func HEADER(){
	shell.CLEAR()
	fmt.Println("            Jancox Tool " + VERSION , "wahyu6070")
	fmt.Println(" ")
	}
func IMG_EXTRACT(INPUT string, OUTPUT string){
	if _, err := os.Stat(OUTPUT); err != nil { 
		os.MkdirAll(OUTPUT,0755)
	}
	cmd := exec.Command("mount", "-o", "loop", "-t", "auto", INPUT, OUTPUT)
	cmd.Stdout = os.Stdout
    cmd.Stderr = os.Stdout
	err := cmd.Run()
	if err != nil {
		log.Fatal(err)
		}
		
}
var PYTHON string
func PYTHON_TEST(){
	LIST_PY := map[string]string{
		"/data/data/com.termux/files/usr/bin/python" : "Python Termux",
		"/usr/bin/python" : "Python GNU",
		}
	for WR , _ := range LIST_PY {
		if _, err := os.Stat(WR); err == nil {
			PYTHON = WR
		}
	 }
	if _, err := os.Stat(PYTHON); err != nil {
  		fmt.Println("! Python is not found")
  		os.Exit(1)
		}
}
func UNPACK() {
	PYTHON_TEST()
	HEADER()
	LIST_DIR_INPUT := []string{
		filepath.Join(BASE, "input.zip"),
		"/sdcard/input.zip",
		"/sdcard/Downloads/input.zip",
		}
	var INPUT string
	for _, INPUT_LIST := range LIST_DIR_INPUT {
		if _, err := os.Stat(INPUT_LIST); err == nil { 
			fmt.Println("- Input <" + INPUT_LIST + ">")
			INPUT = INPUT_LIST
			break
		}
	 }
	 if _, err := os.Stat(INPUT); err != nil { 
	 	fmt.Println("! Input.zip is not found")
	 	os.Exit(1)
	 	}
	if _, err := os.Stat(FLASHABLE); err != nil {
				os.MkdirAll(FLASHABLE,0755)
					
			} else {
				os.RemoveAll(FLASHABLE)
				os.MkdirAll(FLASHABLE, 0755)
	}
	fmt.Println("- Extracting ZIP")
	shell.UNZIP(INPUT, FLASHABLE)
	
	LIST_BR := map[string]string{
		"system.new.dat.br" : "system.new.dat",
		"vendor.new.dat.br" : "vendor.new.dat",
		"product.new.dat.br" : "product.new.dat",
		"system_ext.new.dat.br" : "system_ext.new.dat",
		
		}
	for INBR, OUTBR := range LIST_BR {
		INPUT := filepath.Join(BASE, "bin/flashable", INBR)
		OUTPUT := filepath.Join(BASE, "bin/flashable", OUTBR)
		if _, err := os.Stat(INPUT); err == nil {
			fmt.Println("- Extracting", INBR)
			
			err := shell.UNBR(INPUT, OUTPUT)
			if err == nil {
				err := os.Remove(INPUT)
				if err != nil {
					fmt.Println(err)
				}
				
			}
		  }
		}
		LIST_DAT := []string{
			"system",
			"vendor",
			"product",
			"system_ext",
			}
	
		for _, LIST := range LIST_DAT {
			SDAT2IMG := filepath.Join(BASE, "bin/sdat2img/sdat2img.py")
			TRANSFER := filepath.Join(BASE, "bin/flashable/", LIST) + ".transfer.list"
			DAT := filepath.Join(BASE, "bin/flashable/", LIST) + ".new.dat"
			OUT := filepath.Join(TMP, LIST) + ".img"
			if _, err := os.Stat(DAT); err == nil {
				fmt.Println("- Extracting", path.Base(DAT))
				cmd := exec.Command(PYTHON, SDAT2IMG,TRANSFER, DAT, OUT)
        		err := cmd.Run()
        		if err != nil {
        			log.Fatal(err)
        		}
        		
         	} 
         	
        }
        LIST_IMG := map[string]string{
			"system.img" : "system_root",
			"product" : "product",
			"system_ext.img" : "system_ext",
			"vendor.img" : "vendor",
			}
		for IMGI, IMGL := range LIST_IMG {
			INPUT := filepath.Join(TMP, IMGI)
			OUTPUT := filepath.Join(EDITOR, IMGL)
			if _, err := os.Stat(INPUT); err == nil { 
			fmt.Println("- Extracting", IMGI)
			IMG_EXTRACT(INPUT, OUTPUT)
			}
		}
	}
func HELP() {
	fmt.Println("usage : jancox <options>")
	fmt.Println(" ")
	fmt.Println("options")
	fmt.Println("unpack         unpack rom")
	fmt.Println("repack         repack rom")
	fmt.Println("clear          clear tmp")
	fmt.Println("help           help")
	fmt.Println(" ")
	fmt.Println("jancox tool ", VERSION, " by wahyu6070, LICENSE MIT")
	
	}
	var BASE string
	var TMP string
	var BIN string
	var FLASHABLE string
	var VERSION string
	var EDITOR string
func main(){
	VERSION = "v2.4"
	BASE = shell.IS_DIRNAME()
	TMP = filepath.Join(BASE, "bin/tmp")
	FLASHABLE = filepath.Join(BASE, "bin/flashable")
	EDITOR = filepath.Join(BASE, "editor")
	
	//architecture detected
	if runtime.GOARCH == "arm64" {
		BIN = filepath.Join(BASE, "bin", "arm64")
		
		} else {
			fmt.Println("! Your Architecture Is Not Support •> ", runtime.GOARCH) 
			os.Exit(1)
			}
	fmt.Println("BIN is : ", BIN)
	var ARGS string
	if len(os.Args) > 1 {
    ARGS = os.Args[1]
	} else {
    fmt.Println("help")
	}
	if ARGS == "unpack" {
		UNPACK()
	} else if ARGS == "repack" {
		fmt.Println("repack")
		
	} else if ARGS == "clear" {
		fmt.Println("clear")
	} else if ARGS == "help" {
		HELP()
	} else {
		HELP()
		}
	
	}
	
	
	