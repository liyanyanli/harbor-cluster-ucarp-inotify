package main

import (
	"time"
	"os/exec"
)

const common  = "docker ps -a | grep Up | grep "

const nginx = "_proxy"
const jobservice = "_jobservice"
const registry = "_registry"
const ui = "_ui"
const mysql = "_mysql"
const log = "_log"

const clair  = "clair_clair"
const postgres  = "clair_postgres"

const Start = "docker start "

const FindUcarp  = "pgrep -l ucarp| awk -F ' ' '{ print $1 }'"
const StopUcarp = "kill -9 "

const FindHeal  = "pgrep -l healthCheck| awk -F ' ' '{ print $1 }'"

const DelVIP  = "sh /etc/uuarp/master-down.sh"

const StartUcarp  = "sh /etc/uuarp/master.sh"


func execCommand(param string) (string){
	f, err := exec.Command("/bin/sh", "-c", param).Output()
	if err != nil {

	}
	return string(f)
}

func mange(name string,flag int) (int){
	if name == "" {
		flag ++
		return flag
	}
	return flag
}

func main() {

	for {
		flag := 0

		time.Sleep(1 * time.Second)

		n := execCommand(common + nginx)
		flag = mange(n,flag)

		j := execCommand(common + jobservice)
		flag = mange(j,flag)

		//r := execCommand(common + registry)
		//flag = mange(r,flag)

		u := execCommand(common + ui)
		flag = mange(u,flag)

		m := execCommand(common + mysql)
		flag = mange(m,flag)

		l := execCommand(common + log)
		flag = mange(l,flag)

		c := execCommand(common + clair)
		flag = mange(c,flag)

		p := execCommand(common + postgres)
		flag = mange(p,flag)

		if flag >= 1 {
			execCommand(DelVIP)
			execCommand(DelVIP)

			pid := execCommand(FindUcarp)
			execCommand(StopUcarp + pid)
			execCommand(StopUcarp + pid)

			time.Sleep(5 * time.Second)
			pidh := execCommand(FindHeal)
			execCommand(StopUcarp + pidh)
			execCommand(StopUcarp + pidh)
			//execCommand(StartUcarp)
		}

	}
}





