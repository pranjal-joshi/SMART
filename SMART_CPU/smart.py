#!/usr/bin/python

from SimpleHTTPServer import *
import collections
import SocketServer
import time
import os
import sys
import MySQLdb as mdb
import base64 as security
import threading
import wikipedia as wiki
import urllib2

############### Script versions ################
VERSION = 1.0
VERSION_NODE = 1.0
VERSION_WEB = 1.0
################################################

PORT = 98
NODE_PORT = PORT-1

loginAttempt = 0

REQUEST_ROOM = 0
APP_ACTIVITY = False

####### Server load files ###########
CSSFILE = ""
JSFILE = ""
JQUERY = ""
SMARTJS = ""
welcomeIco = 0
configIco = 0
controlIco = 0
htmlConfig = ""
htmlControl = ""
htmlWelcome = ""
#####################################

con = mdb.connect("localhost","root","linux")
db = con.cursor()
dbThread = con.cursor()

# HTTP handler for GET request
class handler(SimpleHTTPRequestHandler):

	def end_headers(self):
		self.send_cors_headers()
		SimpleHTTPRequestHandler.end_headers(self)

	def send_cors_headers(self):
		self.send_header("Access-Control-Allow-Origin","*")

	def do_GET(self):
		global APP_ACTIVITY
		global REQUEST_ROOM
		url = self.path
		if(url.find("Pass") > 0):
			offset = url.find("Pass")
			offset = offset + 5
			substr = url[offset:offset+5]
			global loginAttempt
			if(substr == str(loginKey()) and loginControl()):
				self.send_response(200)
				self.end_headers()
				self.wfile.write("grant")
				print "LOGIN SUCCESSFUL."
				print "Logged in at : " +  time.strftime("%d/%m/%y  %I:%M:%S %p")
				sysLog("LOGGED IN.\t")
				loginAttempt = 0
				return
			else:
				loginAttempt = loginAttempt + 1
				self.send_response(200)
				self.end_headers()

				if(loginAttempt < 5):
					self.wfile.write("denied")
					print "LOGIN UNSUCCESSFUL."
					sysLog("LOGIN DENIED.\t")
					return
				else:
					lc = open("lc.time","w")
					timeout = time.time() + 60
					lc.write(str(timeout))
					lc.close()
					self.wfile.write("locked")
					print "*** LOGIN LOCKED FOR SECURITY REASONS. ENTER CORRECT KEY TO UNLOCK!!!"
					sysLog("LOGIN LOCKED!\t")
					return

		elif(url.find("toggle") > 0):
			decode = url.split("&")
			room = decode[1]
			device = decode[2]
			device = "d" + str(device)
			setValue = decode[3]
			db.execute("use smart")
			db.execute("update map set %s=%s where room_no=%s" % (device, setValue, room))
			db.execute("update map set active=1 where room_no=%s" % (room))
			con.commit()
			print room, " ", device, " ", setValue
			print "TOGGLE ACCEPTED."
			self.send_response(200)
			self.end_headers()
			self.wfile.write("toggle ok")
			sysLog("TOGGLE - R:%s D:%s V:%s" % (room, device, setValue))
			REQUEST_ROOM = room
			APP_ACTIVITY = True
			return

		elif(url.find("slider") > 0):
			decode = url.split("&")
			room = decode[1]
			thumbValue = decode[2]
			print "SLIDER ACCEPTED."
			print room, " ", thumbValue
			db.execute("use smart")
			db.execute("update map set slider=%s where room_no=%s" % (thumbValue, room))
			db.execute("update map set active=1 where room_no=%s" % (room))
			con.commit()
			self.send_response(200)
			self.end_headers()
			self.wfile.write("slider ok")
			REQUEST_ROOM = room
			APP_ACTIVITY = True
			return

		elif(url.find("requestUpdate") > 0):
			room = url.split("&")
			room = room[1]
			db.execute("use smart")
			db.execute("select d1,d2,d3,d4,d5,d6,d7,d8,slider from map where room_no=%s" % (room))
			result = db.fetchone()
			result = str(result[0]) + str(result[1]) + str(result[2]) + str(result[3]) + str(result[4]) + str(result[5]) + str(result[6]) + str(result[7]) + str(result[8])
			self.send_response(200)
			self.end_headers()
			self.wfile.write(str(result) + "updateResponse")
			print "requestUpdate executed."
			return

		elif(url.find("setRoomNames") > 0):
			urlSplit = url.split("&")
			db.execute("use smart")
			for i in range(1,9):
				if(urlSplit[i] == None):
					break
				db.execute("update map set room_name='%s' where room_no=%s" % (urlSplit[i],str(i)))
			con.commit()
			self.send_response(200)
			self.end_headers()
			self.wfile.write("OK")

		elif(url.find("activeRooms") > 0):
			rooms = url.split("&")
			rooms = rooms[1:]
			db.execute("use smart")
			for i in range(1,9):
				db.execute("update map set active=0 where room_no=%s" % (i))
			con.commit()
			for i in range(0,len(rooms)):
				db.execute("update map set active=1 where room_no=%s" % (rooms[i]))
			con.commit()
			print "Room configuration updated."
			self.send_response(200)
			self.end_headers()
			self.wfile.write("OK")

		elif(url.find("voiceQuery") > 0):
			query = url.split("=");
			query = query[1]
			query = urllib2.unquote(query.encode("utf8"))
			query = query.replace('+',' ')
			ans = wiki.summary(query, sentences=3)
			print "QUERY = ", query
			print "ANSWER= ",ans
			self.send_response(200)
			self.end_headers()
			self.wfile.write(ans + "tts_ok")
			sysLog("QUERY: %s" % query)
			return

		elif(url.find("shutDown") > 0):
			self.send_response(200)
			self.end_headers()
			self.wfile.write("SMART SHUTDOWN commencing.")
			sysLog("SHUT_DOWN\t")
			nodeBroadcast("nodeShutdown")
			shutDown()
			return

		elif(url.find("updateNode") > 0):
			z = url.split("&")
			room = str(z[1])
			ip = str(z[2]) + "." + str(z[3]) + "." + str(z[4]) + "." + str(z[5])
			strIP = '"' + ip + '"'
			db.execute("use smart")
			db.execute("update map set address=%s where room_no=%s" % (strIP,str(room)))
			print "update map set address=%s where room_no=%s" % (strIP,str(room))
			self.send_response(200)
			self.end_headers()
			self.wfile.write("IP updated.")
			return

		elif(url.find("reboot") > 0):
			print "Rebooting S.M.A.R.T in 5 seconds."
			sysLog("REBOOT\t")
			self.send_response(200)
			self.end_headers()
			self.wfile.write("rebooting")
			nodeBroadcast("nodeReboot")
			time.sleep(5)
			os.system("reboot")

		elif(url.find("otaUpdate") > 0):
			print "OTA update checking.."
			otaVersionURL = "Enter valid ota url here!!"
			os.system("wget " + otaVersionURL + " -P " + os.getcwd() + "/")
			otaVers = open("version.txt","r")
			versionCheck = otaVers.read()
			otaVers.close()
			versionCheck = versionCheck.split("\n")
			versionCheck = float(versionCheck[0])
			if(VERSION < versionCheck):
				nodeBroadcast("downloadOTA")
				downloadOTA()
				sysLog("OTA complete\t")
				print "System Update complete. New features will take effect after restart!"
				self.send_response(200)
				self.end_headers()
				self.wfile.write("ota complete")
			else:
				print "Your software is up-to-date!"
				self.send_response(200)
				self.end_headers()
				self.wfile.write("ota unavailable")

		elif(url.find("getRoomNames") > 0):
			db.execute("use smart")
			db.execute("select room_name from map")
			names = db.fetchall()
			names = str(names[0][0]) + "&" + str(names[1][0]) + "&" + str(names[2][0]) + "&" + str(names[3][0]) + "&" + str(names[4][0]) + "&" + str(names[5][0]) + "&" + str(names[6][0]) + "&" + str(names[7][0])
			self.send_response(200)
			self.end_headers()
			self.wfile.write(names)
			self.wfile.close()
			return

		elif(url.find("getDeviceNames") > 0):
			room = url.split("&")
			room = room[1]
			db.execute("use smart")
			db.execute("select d1name,d2name,d3name,d4name,d5name,d6name,d7name,d8name from map where room_no=%s" % (str(room)))
			names = db.fetchall()
			names = str(names[0][0]) + "&" + str(names[0][1]) + "&" + str(names[0][2]) + "&" + str(names[0][3]) + "&" + str(names[0][4]) + "&" + str(names[0][5]) + "&" + str(names[0][6]) + "&" + str(names[0][7])
			self.send_response(200)
			self.end_headers()
			self.wfile.write(names)
			return

		elif(url.find("setDeviceName") > 0):
			urlSplit = url.split('&')
			print url.split('&')
			room = urlSplit[1]
			deviceNo = urlSplit[2]
			deviceNo = "d" + str(deviceNo) + "name"
			deviceName = urlSplit[3]
			db.execute("use smart")
			db.execute("update map set %s='%s' where room_no=%s" % (deviceNo, deviceName, room))
			con.commit()
			self.send_response(200)
			self.end_headers()
			self.wfile.write("ok")
			return

		elif((url.find("materialize.min.css") > 0) or (url.find("materialize.css") > 0)):
			self.send_response(200)
			self.end_headers()
			self.wfile.write(CSSFILE)

		elif((url.find("materialize.min.js") > 0) or (url.find("materialize.js") > 0)):
			self.send_response(200)
			self.end_headers()
			self.wfile.write(JSFILE)

		elif((url.find("jquery.min.js") > 0) or (url.find("jquery.js") > 0)):
			self.send_response(200)
			self.end_headers()
			self.wfile.write(JQUERY)

		elif(url.find("smart.js") > 0):
			self.send_response(200)
			self.end_headers()
			self.wfile.write(SMARTJS)

		elif(url.find("welcome.ico") > 0):
			self.send_response(200)
			self.end_headers()
			self.wfile.write(welcomeIco)

		elif(url.find("config.ico") > 0):
			self.send_response(200)
			self.end_headers()
			self.wfile.write(configIco)

		elif(url.find("control.ico") > 0):
			self.send_response(200)
			self.end_headers()
			self.wfile.write(controlIco)

		elif(url.find("welcome.html") > 0):
			self.send_response(200)
			self.end_headers()
			self.wfile.write(htmlWelcome)

		elif(url.find("config.html") > 0):
			self.send_response(200)
			self.end_headers()
			self.wfile.write(htmlConfig)

		elif(url.find("control.html") > 0):
			self.send_response(200)
			self.end_headers()
			self.wfile.write(htmlControl)

		else:
			f = open("welcome.html",'r')
			resp = f.read()
			f.close()
			self.send_response(200)
			self.end_headers()
			self.wfile.write(resp)
			sysLog("INVALID URL\t")

		return


def initDB():
	print "Initializing MySQL database."
	db.execute("show databases")
	a = db.fetchall()
	a = str(a)
	if(a.find("smart") > 0):
		print "---> Database found."
		sysLog("DB OK\t\t")
	else:
		print "---> Database not found. creating..."
		db.execute("create database smart")
		db.execute("use smart")
		db.execute("create table map(room_no INT, d1 INT not null default 0, d2 INT not null default 0, d3 INT not null default 0, d4 INT not null default 0, d5 INT not null default 0, d6 INT not null default 0, d7 INT not null default 0, d8 INT not null default 0, slider INT not null default 0, timer_active INT not null default 0, active INT not null default 0, address VARCHAR(25), is_server INT not null default 0, d1name VARCHAR(25), d2name VARCHAR(25), d3name VARCHAR(25), d4name VARCHAR(25), d5name VARCHAR(25), d6name VARCHAR(25), d7name VARCHAR(25), d8name VARCHAR(25), room_name VARCHAR(25))")
		db.execute("insert into map (room_no) values (1)")
		db.execute("insert into map (room_no) values (2)")
		db.execute("insert into map (room_no) values (3)")
		db.execute("insert into map (room_no) values (4)")
		db.execute("insert into map (room_no) values (5)")
		db.execute("insert into map (room_no) values (6)")
		db.execute("insert into map (room_no) values (7)")
		db.execute("insert into map (room_no) values (8)")
		con.commit()
		db.execute("show databases")
		a = db.fetchall()
		a = str(a)
		if(a.find("smart") > 0):
			print "---> Database created successfully."
			sysLog("DB CREATED\t")
		else:
			print "---> Error creating database!!"
			sysLog("DB ERROR\t")
			sys.exit("*** Aborting due to database failure! ***")

def loginKey():
	f = open("smart.key","r")
	key = f.read()
	f.close()
	key = str(key)
	index  = key.find('\n')
	key = key[:index]
	key = security.b16decode(key)
	return key

def shutDown():
	db.close()
	con.close()	
	print "*** System is going to SHUTDOWN in 5 seconds!!!"
	time.sleep(5)
	os.system("sudo shutdown -h now")

def sysLog(string):
	f = open("sys.log","a")
	data = str(time.strftime("%d/%m/%y %I:%M:%S %p") + "\t" + string + "\n")
	f.write(data)
	f.close()

def loginControl():
	lc = open("lc.time","r")
	data = lc.readline()
	lc.close()
	currentTime = time.time()
	if(currentTime >= float(data)):
		return True
	else:
		return False

def timerScheduler():
	return 0

def getNodeIP(roomNo):							# New connection cursor for diffrent thread
	dbThread.execute("use smart")
	query = "select address from map where room_no=" + str(roomNo)
	dbThread.execute(query)
	result = dbThread.fetchone()
	return str(result[0])

def appActivity():
	global APP_ACTIVITY
	global REQUEST_ROOM
	if APP_ACTIVITY:
		APP_ACTIVITY = False
		urlToSend = "http://"+str(getNodeIP(REQUEST_ROOM))+":"+str(PORT-1)+"/?appActivity"
		print urlToSend
		resp = urllib2.urlopen(urlToSend).read()
		sysLog("APP ACTIVITY: R=%s" % (REQUEST_ROOM))
	AppActivityThread = threading.Timer(0.1, appActivity)
	AppActivityThread.daemon = True
	AppActivityThread.start()

def nodeBroadcast(string):
	db.execute("use smart")
	for i in range(1,9):
		db.execute("select active from map where room_no=%s" % str(i))
		active = db.fetchone()
		active = active[0]
		if(active):
			ip = getNodeIP(i)
			url = "http://" + ip + ":" + str(NODE_PORT) + "/?" + str(string)
			urllib2.urlopen(url).read()
		else:
			pass

def downloadOTA():
	url = "Enter .tar.gz OTA url"
	os.system("wget " + url + " -P " + os.getcwd() + "/")
	os.system("tar -xvzf *.tar.gz")
	os.system("rm *.tar.gz")

def loadServerFiles():
	global CSSFILE
	global JSFILE
	global SMARTJS
	global JQUERY
	global welcomeIco
	global configIco
	global controlIco
	global htmlControl
	global htmlConfig
	global htmlWelcome

	print "Loading server files..."
	f = open("materialize.min.css","r")		# read css file
	CSSFILE = f.read()
	f.close()
	f = open("materialize.min.js","r")		# read js file
	JSFILE = f.read()
	f.close()
	f = open("jquery.min.js","r")			# read jquery
	JQUERY = f.read()
	f.close()
	f = open("smart.js","r")				# read smart.js
	SMARTJS = f.read()
	f.close()
										# load title icons
	f = open("control.ico","r")
	controlIco = f.read()
	f.close()
	f = open("config.ico","r")
	configIco = f.read()
	f.close()
	f = open("welcome.ico","r")
	welcomeIco = f.read()
	f.close()
										# load HTML files

	f = open("control.html","r")
	htmlControl = f.read()
	f.close()
	f = open("config.html","r")
	htmlConfig = f.read()
	f.close()
	f = open("welcome.html","r")
	htmlWelcome = f.read()
	f.close()


# Main program begins here...
try:
	os.system("clear")
	httpd = SocketServer.TCPServer(("",PORT),handler)
	print "\n\r[ Self Monitoring Analysing & Reporting Technology ] (S.M.A.R.T)\n\r"
	print "Started at: " +  time.strftime("%d/%m/%y  %I:%M:%S %p")
	print "IP Address: " + str(os.system("hostname -I"))
	loadServerFiles()
	sysLog("SMART INITIALIZED.")
	print "Initializing with SU access..."
	initDB()
	print "Attempting to start localhost HTTP server on port ", PORT,"..."
	print "Started listening to S.M.A.R.T app  with security key: " + loginKey()
	appActivity()
	httpd.serve_forever()
except(KeyboardInterrupt):
	httpd.shutdown()
	print "exiting.."
	sys.exit()
