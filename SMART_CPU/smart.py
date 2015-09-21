#!/usr/bin/python

from SimpleHTTPServer import *
import SocketServer
import time
import wiringpi
import os
import sys
import MySQLdb as mdb
import base64 as security
import threading
import wikipedia as wiki
import urllib2

PORT = 80
BAUD = 9600

# hardware configuration pins
clkPin = 1
latchPin = 4
dataPin = 5
enable = 6

ioRead = []
NoOfRooms = []
loginAttempt = 0

io = wiringpi.GPIO(wiringpi.GPIO.WPI_MODE_PINS)
serial = wiringpi.Serial('/dev/ttyAMA0',BAUD)

con = mdb.connect("localhost","root","linux")
db = con.cursor()

# HTTP handler for GET request
class handler(SimpleHTTPRequestHandler):
	def do_GET(self):
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
			updateRegisters(dataPin, clkPin, latchPin, enable)
			NumOfRooms()
			self.send_response(200)
			self.end_headers()
			self.wfile.write("toggle ok")
			sysLog("TOGGLE - R:%s D:%s V:%s" % (room, device, setValue))
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
			NumOfRooms()
			self.send_response(200)
                        self.end_headers()
                        self.wfile.write("slider ok")
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
			return
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
			key = url.split("&")
			key = key[1]
			if(key == str(loginKey())):
				self.send_response(200)
				self.end_headers()
				self.wfile.write("SMART SHUTDOWN commencing.")
				sysLog("SHUT_DOWN\t")
				shutDown()
				return

	        else:
	                print "Invalid URL."
			f = open("index.html",'r')
			resp = f.read()
			f.close()
			self.send_response(200)
			self.end_headers()
			self.wfile.write(resp)
			sysLog("INVALID URL\t")

		return


def initGPIO(dataPin, clkPin, latchPin, enable):
	print "Initializing wiringpi..."
	io.pinMode(dataPin,1)
	io.pinMode(clkPin,1)
	io.pinMode(latchPin,1)
	io.pinMode(enable,1)
	
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
		db.execute("create table map(room_no INT, d1 INT not null default 0, d2 INT not null default 0, d3 INT not null default 0, d4 INT not null default 0, d5 INT not null default 0, d6 INT not null default 0, d7 INT not null default 0, d8 INT not null default 0, slider INT not null default 0, active INT not null default 0)")
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

def updateRegisters(dataPin, clkPin, latchPin, enable):
	db.execute("use smart")
	db.execute("select room_no from map where active=1")
	x = db.fetchall()
	x = str(x)
	roomsAvail = []
	for i in range(1,9):
		if (x.find(str(i)) > 0):
			roomsAvail.append(int(i))
	print "roomsAvail ", roomsAvail
	regNo = len(roomsAvail)
	print "regNo ", regNo
	print NoOfRooms
	print max(NoOfRooms)
	io.digitalWrite(enable,0)
	io.digitalWrite(latchPin,0)
	for i in range(0,regNo):		
		#print "For Room No. = ", roomsAvail[i]
		db.execute("select d1,d2,d3,d4,d5,d6,d7,d8 from map where room_no=%s" %(roomsAvail[i]))
		result = db.fetchone()
		result = str(result[0]) + str(result[1]) + str(result[2]) + str(result[3]) + str(result[4]) + str(result[5]) + str(result[6]) + str(result[7])
		data = int(result, 2)
		print "UPDATE REG: result = " ,result
		print "UPDATE REG: data = ", data
		io.shiftOut(dataPin, clkPin, 1, data)
	io.digitalWrite(latchPin,1)

def NumOfRooms():
	db.execute("use smart")
        db.execute("select room_no from map where active=1")
        x = db.fetchall()
        x = str(x)
	global NoOfRooms
        NoOfRooms = []
        for i in range(1,9):
                if (x.find(str(i)) > 0):
                        NoOfRooms.append(int(i))

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

# Main program begins here...

os.system("clear")
httpd = SocketServer.TCPServer(("",PORT),handler)
print "\n\r[ Self Monitoring Analysing & Reporting Technology ] (S.M.A.R.T)\n\r"
print "Started at: " +  time.strftime("%d/%m/%y  %I:%M:%S %p")
sysLog("SMART INITIALIZED.")
print "Initializing with SU access..."
initGPIO(dataPin, clkPin, latchPin, enable)
initDB()
print "Attempting to start localhost HTTP server on port ", PORT,"..."
print "Started listening to S.M.A.R.T app  with security key: " + loginKey()
NumOfRooms()
httpd.serve_forever()
