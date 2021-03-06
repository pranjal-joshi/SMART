#!/usr/bin/python

'''
# Put this script on every node to accept connection from central database

Author	:	Pranjal P. Joshi
Date 	:	06/11/2016
All rights reserved.
'''

import websocket
import os
import sys
import json
import RPi.GPIO as io
import time
import threading
import datetime

############### STATIC DATA ###############
DEBUG = True

VERSION = 1.0

SERVER_IP = "localhost"				#change later
SERVER_PORT = "98"
PORT = int(SERVER_PORT) - 1
OTA_URL = "Enter valid OTA url here!"

ROOM_NO = 1								#static-number
PIR_TIMEOUT = 10						#seconds
RECONNECT_TIMEOUT = 10 					#seconds

############ PIN CONFIG ###################
SYNCPIN = 14
FANPIN = 5 
SWITCHPINS = [0,1,7,8,11,9,10,24]		# DON'T CHANGE SEQUENCE
RELAYPINS = [12,16,20,21,26,19,13,6]	# DON'T CHANGE SEQUENCE

PIR1_PIN = 2
PIR2_PIN = 3

CHARGE = 17
DISCHARGE = 27
ANALOG_VAL = 0.0
##########################################

APP_SPEED = None

SPEED = None
SPEED_OLD = None

POT_FAN_TIME = None
APP_FAN_TIME = None

CON_FLAG = 0

def dummy():
	pass

PIR_TIMEOUT_THREAD = threading.Timer(1,dummy)

def opened(self):
	identification = {
		"name":"node",
		"type":"id",
		"data":{"room":ROOM_NO}
	}
	self.send(json.dumps(identification))
	initGPIO()
	#self.analogRead()

def received_message(self, msg):
	global APP_SPEED
	global APP_FAN_TIME

	msg = json.loads(msg)
	printRequestInfoClient(msg)

	try:
		if(msg['name'] == "broadcast"):				# check if msg is broadcasted

			if(msg['type'] == "toggleNode"):		# check if toggled?

				if(int(msg['data']['room']) == ROOM_NO):	# check if its for me!
					for i in range(0,8):
						io.output(RELAYPINS[i], msg['data']['deviceValues']['d'+str(i+1)])

			elif(msg['type'] == "toggleSlider"):

				if(msg['data']['room'] == ROOM_NO):

					APP_SPEED = msg['data']['speed']
					APP_FAN_TIME = time.time()

			elif(msg['type']=="shutdown"):
				time.sleep(5)
				os.system("sudo shutdown -h now")

			elif(msg['type']=="reboot"):
				time.sleep(5)
				os.system("sudo reboot")

			elif(msg['type']=="otaDownload"):
				downloadOTA()

		elif(msg['type'] == "err"):
			printErrorResponse(msg)

	except Exception as e:
		raise e

def closed(self):
	global CON_FLAG
 	print "Connection closed by SMART Server!"
 	t = threading.Timer(5,restartCode)
 	t.daemon = True
 	t.start()
 	time.sleep(10)

def restartCode():
	os.system("sudo python nodeSocket2.py")
	sys.exit("Trying to reconnect...")

def printRequestInfoClient(msg):
	if DEBUG:
		try:
			print "Name: \t\t" + msg['name']
			print "Type: \t\t" + msg['type']
			print "JSON data:\t" + str(msg['data'])
		except:
			print "Unknown JSON data. Unable to print."

def printErrorResponse(msg):
	try:
		print "Name: \t\t" + msg['name']
		print "Type: \t\t" + msg['type']
		print "Error:\t\t" + str(msg['error'])
	except:
		print "Unknown JSON data. Unable to print."

def initGPIO():
	try:
		io.setmode(io.BCM)
		for i in range(0,8):
			io.setup(SWITCHPINS[i], io.IN, pull_up_down=io.PUD_UP)
			io.setup(RELAYPINS[i], io.OUT)
		io.add_event_detect(SWITCHPINS[0], io.BOTH, callback=switchIntr1, bouncetime=250)
		io.add_event_detect(SWITCHPINS[1], io.BOTH, callback=switchIntr2, bouncetime=250)
		io.add_event_detect(SWITCHPINS[2], io.BOTH, callback=switchIntr3, bouncetime=250)
		io.add_event_detect(SWITCHPINS[3], io.BOTH, callback=switchIntr4, bouncetime=250)
		io.add_event_detect(SWITCHPINS[4], io.BOTH, callback=switchIntr5, bouncetime=250)
		io.add_event_detect(SWITCHPINS[5], io.BOTH, callback=switchIntr6, bouncetime=250)
		io.add_event_detect(SWITCHPINS[6], io.BOTH, callback=switchIntr7, bouncetime=250)
		io.add_event_detect(SWITCHPINS[7], io.BOTH, callback=switchIntr8, bouncetime=250)
		io.setup(FANPIN, io.OUT)
		io.setup(PIR1_PIN, io.IN)
		io.setup(PIR2_PIN, io.IN)
		io.add_event_detect(PIR1_PIN, io.BOTH, callback=pir1Intr, bouncetime=250)
		io.add_event_detect(PIR2_PIN, io.BOTH, callback=pir2Intr, bouncetime=250)
		io.setup(SYNCPIN, io.IN, pull_up_down=io.PUD_UP)
		io.add_event_detect(SYNCPIN, io.FALLING, callback=syncMains, bouncetime=8)
		if DEBUG:
			print "ZCD synchronization interrupt enabled on BCM pin " + str(SYNCPIN)
			print "Setting FAN pin as output: pin no. " + str(FANPIN)
			print "Interrupts enabled on BCM pins: " + str(SWITCHPINS)
			print "Set as relay output (BCM Pins): " + str(RELAYPINS)
			print "Motion sensors pin initialized!"
	except Exception as e:
		raise e
		sys.exit("GPIO Exception occured during initGPIO! Exiting...")

def switchIntr1(self):
	index = 1
	if(io.input(SWITCHPINS[index-1]) == True):
		val = 1
	else:
		val = 0
	resp = {
					"name":"node",
					"type":"toggle",
					"data":
					{
						"room":str(ROOM_NO),
						"device":index,
						"value":val
					}
				}
	resp = json.dumps(resp)
	ws.send(resp)

def switchIntr2(self):
	index = 2
	if(io.input(SWITCHPINS[index-1]) == True):
		val = 1
	else:
		val = 0
	resp = {
					"name":"node",
					"type":"toggle",
					"data":
					{
						"room":ROOM_NO,
						"device":index,
						"value":val
					}
				}
	resp = json.dumps(resp)
	ws.send(resp)

def switchIntr3(self):
	index = 3
	if(io.input(SWITCHPINS[index-1]) == True):
		val = 1
	else:
		val = 0
	resp = {
					"name":"node",
					"type":"toggle",
					"data":
					{
						"room":ROOM_NO,
						"device":index,
						"value":val
					}
				}
	resp = json.dumps(resp)
	ws.send(resp)

def switchIntr4(self):
	index = 4
	if(io.input(SWITCHPINS[index-1]) == True):
		val = 1
	else:
		val = 0
	resp = {
					"name":"node",
					"type":"toggle",
					"data":
					{
						"room":ROOM_NO,
						"device":index,
						"value":val
					}
				}
	resp = json.dumps(resp)
	ws.send(resp)

def switchIntr5(self):
	index = 5
	if(io.input(SWITCHPINS[index-1]) == True):
		val = 1
	else:
		val = 0
	resp = {
					"name":"node",
					"type":"toggle",
					"data":
					{
						"room":ROOM_NO,
						"device":index,
						"value":val
					}
				}
	resp = json.dumps(resp)
	ws.send(resp)

def switchIntr6(self):
	index = 6
	if(io.input(SWITCHPINS[index-1]) == True):
		val = 1
	else:
		val = 0
	resp = {
					"name":"node",
					"type":"toggle",
					"data":
					{
						"room":ROOM_NO,
						"device":index,
						"value":val
					}
				}
	resp = json.dumps(resp)
	ws.send(resp)

def switchIntr7(self):
	index = 7
	if(io.input(SWITCHPINS[index-1]) == True):
		val = 1
	else:
		val = 0
	resp = {
					"name":"node",
					"type":"toggle",
					"data":
					{
						"room":ROOM_NO,
						"device":index,
						"value":val
					}
				}
	resp = json.dumps(resp)
	ws.send(resp)

def switchIntr8(self):
	index = 8
	if(io.input(SWITCHPINS[index-1]) == True):
		val = 1
	else:
		val = 0
	resp = {
					"name":"node",
					"type":"toggle",
					"data":
					{
						"room":ROOM_NO,
						"device":index,
						"value":val
					}
				}
	resp = json.dumps(resp)
	ws.send(resp)

def stopPWM():			### PWM inverted logic ### MOC LED is in common anode configuration.
	io.output(FANPIN, True)
	pass

def startPWM():			### PWM inverted logic ### MOC LED is in common anode configuration. 
	io.output(FANPIN, False)
	pass

def pir1Intr(self):
	global PIR_TIMEOUT_THREAD
	print "PIR state: " + str(io.input(PIR1_PIN))
	if(io.input(PIR1_PIN) == True):				# Logical OR PIR1 & 2s OUTPUTS. <------------
		try:
			if(PIR_TIMEOUT_THREAD.isAlive()):
				PIR_TIMEOUT_THREAD.cancel()
			presenceReq(1)
		except Exception as e:
			presenceReq(1)
			raise e
		print "Turning on..."
	else:
		PIR_TIMEOUT_THREAD = threading.Timer(PIR_TIMEOUT, presenceReq, '0')
		PIR_TIMEOUT_THREAD.daemon = True
		PIR_TIMEOUT_THREAD.start()
		print "Turning off..."

def pir2Intr(self):
	global PIR_TIMEOUT_THREAD
    print "PIR state: " + str(io.input(PIR2_PIN))
    if(io.input(PIR2_PIN) == True):
        try:
            if(PIR_TIMEOUT_THREAD.isAlive()):
                PIR_TIMEOUT_THREAD.cancel()
            presenceReq(1)
        except Exception as e:
            presenceReq(1)
            raise e
            print "Turning on..."
    else:
        PIR_TIMEOUT_THREAD = threading.Timer(PIR_TIMEOUT, presenceReq, '0')
        PIR_TIMEOUT_THREAD.daemon = True
        PIR_TIMEOUT_THREAD.start()
        print "Turning off..."

def pirRise1(self):
	global PIR_TIMEOUT_THREAD
	try:
		if(PIR_TIMEOUT_THREAD.isAlive()):
			PIR_TIMEOUT_THREAD.cancel()
		presenceReq(1)
	except:
		presenceReq(1)

def pirFall1(self):
	global PIR_TIMEOUT_THREAD
	PIR_TIMEOUT_THREAD = threading.Timer(PIR_TIMEOUT, presenceReq, 0).start()

def pirRise2(self):
	global PIR_TIMEOUT_THREAD
	try:
		if(PIR_TIMEOUT_THREAD.isAlive()):
			PIR_TIMEOUT_THREAD.cancel()
		presenceReq(1)
	except:
		presenceReq(1)

def pirFall2(self):
	global PIR_TIMEOUT_THREAD
	PIR_TIMEOUT_THREAD = threading.Timer(PIR_TIMEOUT, presenceReq, 0).start()


def presenceReq(value):
	resp = {
					"name":"node",
					"type":"presence",
					"data":
					{
						"room":ROOM_NO,
						"presence":value
					}
				}
	resp = json.dumps(resp)
	ws.send(resp)

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
	'''while not (io.input(DISCHARGE)):
		try:
			if(time.time() - start > 1.0):
				break
		except(KeyboardInterrupt):
			io.cleanup()
			return'''
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
	except Exception as e:
		raise e
		io.cleanup()
		sys.exit()
		return

def fanSpeedController(self,value):
	global POT_FAN_TIME
	global SPEED
	global SPEED_OLD
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
		resp = {
						"name":"node",
						"type":"slider",
						"data":
						{
							"room":ROOM_NO,
							"speed":SPEED
						}
					}
		resp = json.dumps(resp)
		self.send(resp)
		POT_FAN_TIME = time.time()		# get time at which pot speed is updated.
		OLD_SPEED = SPEED


def syncMains(self):
	if DEBUG:
			print "Zero crossing interrupt triggered!"
	pwmDealy = 0
	if(POT_FAN_TIME >= APP_FAN_TIME):		# check last recent update is from App or Pot by checking update time stamp.
		if(SPEED > 0):
			startPWM()
			if SPEED == 1:
				pwmDealy = 0.002			# delay in ms. Time to keep HIGH pulse on triac gate.
			elif SPEED == 2:
				pwmDealy = 0.004
			elif SPEED == 3:
				pwmDealy = 0.006
			elif SPEED == 4:
				pwmDealy = 0.008
			else:
				pwmDealy = 0.01
			threading.Timer(pwmDealy, stopPWM).start()
		else:
			stopPWM()
	else:
		if(APP_SPEED > 0):
			startPWM()
			if APP_SPEED == 1:
				pwmDealy = 0.002			# delay in ms. Time to keep HIGH pulse on triac gate.
			elif APP_APP_SPEED == 2:
				pwmDealy = 0.004
			elif APP_SPEED == 3:
				pwmDealy = 0.006
			elif APP_SPEED == 4:
				pwmDealy = 0.008
			else:
				pwmDealy = 0.01
			threading.Timer(pwmDealy, stopPWM).start()
		else:
			stopPWM()

def downloadOTA():
	os.system("wget " + OTA_URL + " -P " + os.getcwd() + "/")
	os.system("tar -xvzf *.tar.gz")
	os.system("rm *.tar.gz")

def error(self,err):
	print err



############ MAIN PROGRAM BEGINS HERE #############
try:
	os.system("clear")
	initGPIO()
	wsAddr = "ws://" + SERVER_IP + ":" + SERVER_PORT + "/"
	ws = websocket.WebSocketApp(wsAddr,on_message = received_message,on_close = closed,on_error=error)
	ws.on_open = opened
	#analogRead()
	ws.run_forever()
except Exception as e:
	raise e
	print "Socket connection error. Exiting..."
	io.cleanup()
	sys.exit()
