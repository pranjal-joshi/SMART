#!/usr/bin/python

'''
# Put this script on every node to accept connection from central database

Author	:	Pranjal P. Joshi
Date 	:	11/08/2016
All rights reserved.
'''

from SimpleHTTPServer import *
import SocketServer
import urllib2
import os
import RPi.GPIO as io
import time
import threading

### CONFIGURATION ###
DEBUG = True

SERVER_IP = "192.168.0.160"				#change later
SERVER_PORT = "98"
PORT = int(SERVER_PORT) - 1

SYNCPIN = 14

SWITCHPINS = [0,1,7,8,11,9,10,24]		# DON'T CHANGE SEQUENCE

CHARGE = 17
DISCHARGE = 27
ANALOG_VAL = 0.0

ROOM_NO = 1								#static-number
SW_VALUE = 0
RESPONSE = 0

SPEED = 0
OLD_SPEED = 0

class handler(SimpleHTTPRequestHandler):
	def do_GET(self):
		url = self.path

		if(url.find("appActivity") > 0):
			if DEBUG:
				print "App activity request received."
			self.send_response(200)
			self.end_headers()
			self.wfile.write("activityAccepted")
			### get data from main server database and apply to GPIO


### triggers on ZCD interrupt for triac sync
def syncMains():
	if DEBUG:
		print "Zero crossing interrupt triggered!"
	### to-do from here


### confifure interrupts for ZCD sync
def initSync():
	if DEBUG:
		print "ZCD synchronization interrupt enabled on BCM pin " + str(SYNCPIN)
	io.setmode(io.BCM)
	io.setup(SYNCPIN, io.IN, pull_up_down=io.PUD_UP)
	io.add_event_detect(SYNCPIN, io.FALLING, callback=syncMains, bouncetime=200)

def initSwitchPins(array):
	for i in range(0,len(array)):
		io.setup(array[i], io.IN, pull_up_down=io.PUD_UP)
	io.add_event_detect(array[0], io.BOTH, callback=swInt1, bouncetime=250)
	io.add_event_detect(array[1], io.BOTH, callback=swInt2, bouncetime=250)
	io.add_event_detect(array[2], io.BOTH, callback=swInt3, bouncetime=250)
	io.add_event_detect(array[3], io.BOTH, callback=swInt4, bouncetime=250)
	io.add_event_detect(array[4], io.BOTH, callback=swInt5, bouncetime=250)
	io.add_event_detect(array[5], io.BOTH, callback=swInt6, bouncetime=250)
	io.add_event_detect(array[6], io.BOTH, callback=swInt7, bouncetime=250)
	io.add_event_detect(array[7], io.BOTH, callback=swInt8, bouncetime=250)
	if DEBUG:
		print "Interrupts enabled on BCM pins: " + str(SWITCHPINS)
	return 0

### interrupt callback functions for every switch
def swInt1(self):
	global SW_VALUE
	global RESPONSE
	index = 1
	print "Switch state: " + str(io.input(SWITCHPINS[index-1]))
	if(io.input(SWITCHPINS[index-1]) == True):
		SW_VALUE = 1
	else:
		SW_VALUE = 0
	url = "http://" + str(SERVER_IP) + ":" + str(SERVER_PORT) + "/?toggle=&" + str(ROOM_NO) + "&" + str(index) + "&" + str(SW_VALUE)
	if DEBUG:
		print url
	RESPONSE = urllib2.urlopen(url).read()

def swInt2(self):
	global SW_VALUE
	global RESPONSE
	index = 2
	print "Switch state: " + str(io.input(SWITCHPINS[index-1]))
	if(io.input(SWITCHPINS[index-1]) == True):
		SW_VALUE = 1
	else:
		SW_VALUE = 0
	url = "http://" + str(SERVER_IP) + ":" + str(SERVER_PORT) + "/?toggle=&" + str(ROOM_NO) + "&" + str(index) + "&" + str(SW_VALUE)
	if DEBUG:
		print url
	RESPONSE = urllib2.urlopen(url).read()

def swInt3(self):
	global SW_VALUE
	global RESPONSE
	index = 3
	print "Switch state: " + str(io.input(SWITCHPINS[index-1]))
	if(io.input(SWITCHPINS[index-1]) == True):
		SW_VALUE = 1
	else:
		SW_VALUE = 0
	url = "http://" + str(SERVER_IP) + ":" + str(SERVER_PORT) + "/?toggle=&" + str(ROOM_NO) + "&" + str(index) + "&" + str(SW_VALUE)
	if DEBUG:
		print url
	RESPONSE = urllib2.urlopen(url).read()

def swInt4(self):
	global SW_VALUE
	global RESPONSE
	index = 4
	print "Switch state: " + str(io.input(SWITCHPINS[index-1]))
	if(io.input(SWITCHPINS[index-1]) == True):
		SW_VALUE = 1
	else:
		SW_VALUE = 0
	url = "http://" + str(SERVER_IP) + ":" + str(SERVER_PORT) + "/?toggle=&" + str(ROOM_NO) + "&" + str(index) + "&" + str(SW_VALUE)
	if DEBUG:
		print url
	RESPONSE = urllib2.urlopen(url).read()

def swInt5(self):
	global SW_VALUE
	global RESPONSE
	index = 5
	print "Switch state: " + str(io.input(SWITCHPINS[index-1]))
	if(io.input(SWITCHPINS[index-1]) == True):
		SW_VALUE = 1
	else:
		SW_VALUE = 0
	url = "http://" + str(SERVER_IP) + ":" + str(SERVER_PORT) + "/?toggle=&" + str(ROOM_NO) + "&" + str(index) + "&" + str(SW_VALUE)
	if DEBUG:
		print url
	RESPONSE = urllib2.urlopen(url).read()

def swInt6(self):
	global SW_VALUE
	global RESPONSE
	index = 6
	print "Switch state: " + str(io.input(SWITCHPINS[index-1]))
	if(io.input(SWITCHPINS[index-1]) == True):
		SW_VALUE = 1
	else:
		SW_VALUE = 0
	url = "http://" + str(SERVER_IP) + ":" + str(SERVER_PORT) + "/?toggle=&" + str(ROOM_NO) + "&" + str(index) + "&" + str(SW_VALUE)
	if DEBUG:
		print url
	RESPONSE = urllib2.urlopen(url).read()

def swInt7(self):
	global SW_VALUE
	global RESPONSE
	index = 7
	print "Switch state: " + str(io.input(SWITCHPINS[index-1]))
	if(io.input(SWITCHPINS[index-1]) == True):
		SW_VALUE = 1
	else:
		SW_VALUE = 0
	url = "http://" + str(SERVER_IP) + ":" + str(SERVER_PORT) + "/?toggle=&" + str(ROOM_NO) + "&" + str(index) + "&" + str(SW_VALUE)
	if DEBUG:
		print url
	RESPONSE = urllib2.urlopen(url).read()

def swInt8(self):
	global SW_VALUE
	global RESPONSE
	index = 8
	print "Switch state: " + str(io.input(SWITCHPINS[index-1]))
	if(io.input(SWITCHPINS[index-1]) == True):
		SW_VALUE = 1
	else:
		SW_VALUE = 0
	url = "http://" + str(SERVER_IP) + ":" + str(SERVER_PORT) + "/?toggle=&" + str(ROOM_NO) + "&" + str(index) + "&" + str(SW_VALUE)
	if DEBUG:
		print url
	RESPONSE = urllib2.urlopen(url).read()

def dischargeCap():
	io.setup(CHARGE, io.IN)
	io.setup(DISCHARGE, io.OUT)
	io.output(DISCHARGE, False)
	time.sleep(0.01)
	if DEBUG:
		print "Discharging Capacitor!"

def chargeCap():
	io.setup(DISCHARGE, io.IN)
	io.setup(CHARGE, io.OUT)
	io.output(CHARGE, True)
	start = time.time()
	while not (io.input(DISCHARGE)):
		if(time.time() - start > 1.0):
			break
	end = time.time()
	if DEBUG:
		z = (end-start)/1e-3
		print "Charging time (ms): " + str(z)
	return ((end-start)/1e-3)			# return chargin time of RC in millis


def analogRead():
	global ANALOG_VAL
	dischargeCap()
	ANALOG_VAL = chargeCap()
	fanSpeedController(ANALOG_VAL)
	threading.Timer(0.5, analogRead).start()

def fanSpeedController(value):
	global SPEED
	global OLD_SPEED
	if value in range(100,200):
		SPEED = 1
	elif value in  range(300,400):
		SPEED = 2
	elif value in  range(500,600):
		SPEED = 3
	elif value in  range(700,800):
		SPEED = 4
	else:
		SPEED = 5

	if(OLD_SPEED == SPEED):
		pass
	else:
		url = "http://" + str(SERVER_IP) + ":" + str(SERVER_PORT) + "/?slider=&" + str(ROOM_NO) + "&" + str(SPEED)
		sliderResp = urllib2.urlopen(url).read()
		OLD_SPEED = SPEED

### main program starts here
try:
	os.system("clear")
	print "\nS.M.A.R.T Room control node"
	print "Node server engine initialized."
	httpd = SocketServer.TCPServer(("",PORT),handler)
	initSync()
	initSwitchPins(SWITCHPINS)
	analogRead()
	httpd.serve_forever()
except(KeyboardInterrupt):
	print "\nKeyboardInterrupt -> cleaning up GPIO..."
	io.cleanup()