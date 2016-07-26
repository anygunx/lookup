#!/usr/bin/env python
import os
import sys
import commands
import string
import datetime
import time
import sched  
import threading
import platform

servers = [
	("gateway",True,5,30),
	("world",True,1,30),
	("scene",True,2,1),
	("login",True,3,1),
	("db",True,4,1),
	("mall",False,6,1),
	("gmtool",False,7,1),
	("logser",False,8,1)
]

runpath = os.getcwd()

def mkdir(dirname):
	checkpath = runpath + "/" + dirname
	if not os.path.exists(checkpath):
		os.makedirs(checkpath)
	return checkpath


dumppath = "chkproc/dumps/"
logpath = "chkproc/logs/"

mkdir(dumppath)
mkdir(logpath)

def now():
	return datetime.datetime.now().strftime("%Y-%m-%d[%H:%M:%S]")

#(PNAME,PID,TIME)
def getprocinfos(pname):
	psline = commands.getoutput("ps -A|grep " + pname)
	pinfos = string.split(psline)
	if len(pinfos) != 0:
		return (pinfos[3],pinfos[0],pinfos[2])
	else:
		return (pname,0,"00:00:00")	

def getpid(pname):
	return getprocinfos(pname)[1]

def getprocstatus(pid):
	if pid != 0:
		return commands.getoutput("more /proc/" + pid + "/status")
	else:
		return ""

def getprocio(pid):
	if pid != 0:
		return commands.getoutput("more /proc/" + pid + "/io")
	else:
		return ""

def getprocenv(pid):
	if pid != 0:
		return commands.getoutput("more /proc/" + pid + "/environ")
	else:
		return ""

def getproclimits(pid):
	if pid != 0:
		return commands.getoutput("more /proc/" + pid + "/limits")
	else:
		return ""

def getproccwd(pid):
	if pid != 0:
		return commands.getoutput("ls -l /proc/" + pid + "/cwd")
	else:
		return ""

def getprocexe(pid):
	if pid != 0:
		return commands.getoutput("ls -l /proc/" + pid + "/exe")
	else:
		return ""

def proclog():
	log = open(logpath + now(),"w")		
	for serv in servers:
		log.write("\n###################################################################################################################################\n")
		infos = getprocinfos(serv[0])
		log.write(str(infos))
		log.write("\n-------------------------------------------------------------->file<---------------------------------------------------------------\n")
		log.write(getproccwd(infos[1]))
		log.write(getprocexe(infos[1]))
		log.write("\n--------------------------------------------------------------->env<---------------------------------------------------------------\n")
		log.write(getprocenv(infos[1]))
		log.write("\n-------------------------------------------------------------->status<-------------------------------------------------------------\n")
		log.write(getprocstatus(infos[1]))
		log.write("\n--------------------------------------------------------------->io<----------------------------------------------------------------\n")
		log.write(getprocio(infos[1]))
		log.write("\n------------------------------------------------------------->limits<--------------------------------------------------------------\n")
		log.write(getproclimits(infos[1]))
	log.close()

def copycoredump():
	path = mkdir(dumppath + now())
	commands.getoutput( "mv " + runpath + "/core.* " + path)


def restartserver():
	print 'restart server'
	copycoredump()
	for serv in servers:
		pid = getpid(serv[0])
		if pid != 0:
			os.system("kill -9 " + pid)
			time.sleep(serv[3])	
		else:
			log = open(logpath + "log" , "a")
			log.write(now() + "  server " + serv[0] + " not start !!!")
			log.close()
	for i in range(1,10):
		for serv in servers:
			if serv[2] == i:
				os.system(runpath + "/" + serv[0] + " -d")
				time.sleep(serv[3])	


from threading import Timer 

def chkservers():
	for serv in servers:
		if getpid(serv[0]) == 0 and serv[1]:
			restartserver();
	print 'chk servers'
	Timer(2,chkservers).start()


def logservers():
	proclog()
	print 'log servers'
	Timer(1800,chkservers).start()



def createdaemon():
   
    try:
        if os.fork() > 0: os._exit(0)
    except OSError, error:
        print 'fork #1 failed: %d (%s)' % (error.errno, error.strerror)
        os._exit(1)    
    os.chdir('/')
    os.setsid()
    os.umask(0)
    try:
        pid = os.fork()
        if pid > 0:
            print 'daemon pid %d' % pid
            os._exit(0)
    except OSError, error:
        print 'fork #2 failed: %d (%s)' % (error.errno, error.strerror)
        os._exit(1)

    sys.stdout.flush()
    sys.stderr.flush()
    si = file("/dev/null", 'r')
    so = file("/dev/null", 'a+')
    se = file("/dev/null", 'a+', 0)
    os.dup2(si.fileno(), sys.stdin.fileno())
    os.dup2(so.fileno(), sys.stdout.fileno())
    os.dup2(se.fileno(), sys.stderr.fileno())

    chkservers();
    logservers();

if __name__ == '__main__': 
    if platform.system() == "Linux":
        createdaemon()
    else:
        os._exit(0)


