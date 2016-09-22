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
import sys

### CONFIGURATION ###
DEBUG = True

VERSION = 1.0

SERVER_IP = "192.168.0.160"				#change later
SERVER_PORT = "80"
PORT = int(SERVER_PORT) - 1

SYNCPIN = 14

SWITCHPINS = [0,1,7,8,11,9,10,24]		# DON'T CHANGE SEQUENCE

RELAYPINS = [12,16,20,21,26,19,13,6]	# DON'T CHANGE SEQUENCE

CHARGE = 17
DISCHARGE = 27
ANALOG_VAL = 0.0

ROOM_NO = 1								#static-number
SW_VALUE = 0
RESPONSE = 0

SPEED = 0
OLD_SPEED = 0

PRESENT_STATE = [0,0,0,0,0,0,0,0,0]		# requestUpdate from server after appActivity
PRESENT_STATE_RESPONSE = 0

class handler(SimpleHTTPRequestHandler):
	def do_GET(self):
		url = self.path

		if(url.find("appActivity") > 0):
			if DEBUG:
				print "App activity request received."
			### get data from main server database and apply to GPIO
			url = "http://" + str(SERVER_IP) + ":" + str(SERVER_PORT) + "/?requestUpdate=&" + str(ROOM_NO)
			PRESENT_STATE_RESPONSE = urllib2.urlopen(url).read()
			PRESENT_STATE_RESPONSE = PRESENT_STATE_RESPONSE[0:8]
			PRESENT_STATE_RESPONSE = map(int, str(PRESENT_STATE_RESPONSE))
			if DEBUG:
				print str(PRESENT_STATE_RESPONSE)
			applyToRelay(PRESENT_STATE_RESPONSE)					# actually apply data to relay
			#########################################################
			self.send_response(200)
			self.end_headers()
			self.wfile.write("activityAccepted")
			return

		if(url.find("nodeReboot") > 0):
			self.send_response(200)
			self.end_headers()
			self.wfile.write("node rebooting")
			os.system("sudo reboot")
			return

		if(url.find("nodeShutdown") > 0):
			self.send_response(200)
			self.end_headers()
			self.wfile.write("node shutting down")
			os.system("sudo shutdown -h now")
			return

		if(url.find("downloadOTA") > 0):
			print "Node OTA updating.."
			downloadOTA()
			self.send_response(200)
			self.end_headers()
			self.wfile.write("node OTA downloaded")
			print "Update completed. New features will take effect after restart."
			return
			


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

def initSwitchPins(array,relArray):
	for i in range(0,len(array)):
		io.setup(array[i], io.IN, pull_up_down=io.PUD_UP)
	for i in range(0,len(relArray)):
		io.setup(relArray[i], io.OUT)
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
		print "Set as relay output (BCM Pins): " + str(relArray)
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
		try:
			if(time.time() - start > 1.0):
				break
		except(KeyboardInterrupt):
			io.cleanup()
			return
	end = time.time()
	if DEBUG:
		z = (end-start)/1e-3
		print "Charging time (ms): " + str(z)
	return ((end-start)/1e-3)			# return chargin time of RC in millis


def analogRead():
	try:
		global ANALOG_VAL
		dischargeCap()
		ANALOG_VAL = chargeCap()
		fanSpeedController(ANALOG_VAL)
		capThread = threading.Timer(0.5, analogRead)
		capThread.daemon = True
		capThread.start()
	except:
		io.cleanup()
		sys.exit()
		return

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
		if DEBUG:
			print "FanSpeedURL: " + url
		sliderResp = urllib2.urlopen(url).read()
		OLD_SPEED = SPEED

def applyToRelay(relayArray):
	global RELAYPINS
	for i in range(0,len(relayArray)):
		if(int(relayArray[i]) == 1):
			io.output(RELAYPINS[i], True)
		elif(int(relayArray[i]) == 0):
			io.output(RELAYPINS[i], False)
	return

def updateNodeIP():
	global ROOM_NO
	ip = os.popen("hostname -I")
	ip = ip.read()
	ip = ip.split(' ')
	ip = ip[0]
	ip = ip.replace(".","&")
	url = "http://" + str(SERVER_IP) + ":" + str(SERVER_PORT) + "/?updateNode=&" + str(ROOM_NO) + "&" + str(ip)
	urllib2.urlopen(url).read()
	if DEBUG:
		print "IP updated -> " + str(url)
	updateNodeThread = threading.Timer(15*60, updateNodeIP)
	updateNodeThread.daemon = True
	updateNodeThread.start()

def downloadOTA():
	url = "Enter .tar.gz OTA url"
	os.system("wget " + url + " -P " + os.getcwd() + "/")
	os.system("tar -xvzf *.tar.gz")
	os.system("rm *.tar.gz")


### main program starts here
try:
	os.system("clear")
	print "\nS.M.A.R.T Room control node"
	print "Node server engine initialized."
	httpd = SocketServer.TCPServer(("",PORT),handler)
	updateNodeIP()
	initSync()
	initSwitchPins(SWITCHPINS, RELAYPINS)
	analogRead()
	httpd.serve_forever()
except(KeyboardInterrupt):
	print "\nKeyboardInterrupt -> cleaning up GPIO..."
	io.cleanup()
	sys.exit(0)