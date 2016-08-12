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

### CONFIGURATION ###
DEBUG = True
PORT = 98
SYNCPIN = 14

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


### main program starts here
try:
	os.system("clear")
	print "\nS.M.A.R.T Room control node"
	print "Node server engine initialized."
	httpd = SocketServer.TCPServer(("",PORT),handler)
	initSync()
	httpd.serve_forever()
except(KeyboardInterrupt):
	print "\nKeyboardInterrupt -> cleaning up GPIO..."
	io.cleanup()