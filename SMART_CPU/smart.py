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

PORT = 80
BAUD = 9600

# hardware configuration pins
clkPin = 1
latchPin = 4
dataPin = 5
enable = 6

NoOfRooms = []

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
	                if(substr == str(loginKey())):
	                        self.send_response(200)
	                        self.end_headers()
	                        self.wfile.write("grant")
				print "LOGIN SUCCESSFUL."
				print "Logged in at : " +  time.strftime("%d/%m/%y  %I:%M:%S %p")
				sysLog("LOGGED IN.\t")
				return
	                else:
        	                self.send_response(200)
	                        self.end_headers()
	                        self.wfile.write("denied")
				print "LOGIN UNSUCCESSFUL."
				sysLog("LOGIN DENIED.\t")
				return
		if(url.find("toggle") > 0):
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
		if(url.find("slider") > 0):
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
		if(url.find("requestUpdate") > 0):
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
		if(url.find("shutDown") > 0):
			key = url.split("&")
			key = key[1]
			if(key == str(loginKey())):
				self.send_response(200)
				self.end_headers()
				self.wfile.write("SMART SHUTDOWN commencing.")
				sysLog("SHUT_DOWN")
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
			sysLog("INVALID URL")

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
		print "database found."
		sysLog("DB OK\t\t")
	else:
		print "database not found. creating..."
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
			print "Database created successfully."
			sysLog("DB CREATED\t")
		else:
			print "Error creating database!!"
			sysLog("DB ERROR\t")
			sys.exit("Aborting due to database failure!")

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
	io.digitalWrite(enable,0)
	io.digitalWrite(latchPin,0)
	for i in range(0,regNo):
		print "For Room No. = ", roomsAvail[i]
		db.execute("select d1,d2,d3,d4,d5,d6,d7,d8 from map where room_no=%s" %(roomsAvail[i]))
		result = db.fetchone()
		result = str(result[0]) + str(result[1]) + str(result[2]) + str(result[3]) + str(result[4]) + str(result[5]) + str(result[6]) + str(result[7])
		data = int(result, 2)
		print "result = " ,result
		print "data = ", data
		io.shiftOut(dataPin, clkPin, 1, data)
	io.digitalWrite(latchPin,1)

def readRegisters():
	regNo = len(NoOfRooms)
	io.digitalWrite(enable, 1)
	ioRead = []
	for i in range(0,regNo):
		io.digitalWrite(latchPin, 1)
		io.delayMicroseconds(30)
		io.digitalWrite(latchPin, 0)
		data =  io.shiftIn(dataPin, clkPin, 1)
		ioRead.append(data)
	io.digitalWrite(enable, 0)
	threading.Timer(0.05, readRegisters).start()
	
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
	data = str(string + "\t" + time.strftime("%d/%m/%y %I:%M:%S %p") + "\n")
	f.write(data)
	f.close()

httpd = SocketServer.TCPServer(("",PORT),handler)
print "\n\r[ Self Monitoring Analysing & Reporting Technology ] (S.M.A.R.T)"
print "Started at: " +  time.strftime("%d/%m/%y  %I:%M:%S %p")
sysLog("SMART INITIALIZED.")
print "Initializing with SU access..."
initGPIO(dataPin, clkPin, latchPin, enable)
initDB()
print "Attempting to start localhost HTTP server on port ", PORT,"..."
print "Started listening to S.M.A.R.T app  with security key: " + loginKey()
NumOfRooms()
readRegisters()
httpd.serve_forever()
