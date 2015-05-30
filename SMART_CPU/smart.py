#/usr/bin/python

from SimpleHTTPServer import *
import SocketServer
from time import sleep
import wiringpi
import os
import MySQLdb as mdb
import base64 as security

PORT = 80

# hardware configuration pins
clkPin = 1
latchPin = 4
dataPin = 5
enable = 6

io = wiringpi.GPIO(wiringpi.GPIO.WPI_MODE_PINS)
con = mdb.connect("localhost","root","linux")
cur = con.cursor()

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
	                else:
        	                self.send_response(200)
	                        self.end_headers()
	                        self.wfile.write("denied")
				print "LOGIN UNSUCCESSFUL."
		if(url.find("toggle") > 0):
			decode = url.split("&")
			room = decode[1]
			device = decode[2]
			setValue = decode[3]
			print room, " ", device, " ", setValue
			print "TOGGLE ACCEPTED."
			self.send_response(200)
			self.end_headers()
			self.wfile.write("toggle ok")
		if(url.find("slider") > 0):
			decode = url.split("&")
			room = decode[1]
			thumbValue = decode[2]
			print "SLIDER ACCEPTED."
			print room, " ", thumbValue
			self.send_response(200)
                        self.end_headers()
                        self.wfile.write("slider ok")

	        else:
	                print "Invalid URL."

		return


def initGPIO(dataPin, clkPin, latchPin, enable):
	print "Initializing wiringpi..."
	io.pinMode(dataPin,1)
	io.pinMode(clkPin,1)
	io.pinMode(latchPin,1)
	io.pinMode(enable,1)
	
def initDB():
	print "Initializing MySQL database."
	cur.execute("show databases")
	a = cur.fetchall()
	a = str(a)
	if(a.find("smart") > 0):
		print "database found."
	else:
		print "database not found. creating..."
		cur.execute("create database smart")

def loginKey():
	f = open("smart.key","r")
	key = f.read()
	f.close()
	key = str(key)
	index  = key.find('\n')
	key = key[:index]
	key = security.b16decode(key)
	return key

httpd = SocketServer.TCPServer(("",PORT),handler)
print "\n\r[ Self Monitoring Analysing & Reporting Technology ] (S.M.A.R.T)"
print "Initializing with SU access..."
initGPIO(dataPin, clkPin, latchPin, enable)
initDB()
print "Attempting to start localhost HTTP server on port ", PORT,"..."
print "Started listening to S.M.A.R.T app  with security key: " + loginKey()
httpd.serve_forever()
