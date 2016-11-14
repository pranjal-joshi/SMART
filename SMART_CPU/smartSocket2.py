#!/usr/bin/python
'''
# SMART Central server

Author	:	Pranjal P. Joshi
Date 	:	04/11/2016
All rights reserved.
'''

import tornado.httpserver
import tornado.websocket
import tornado.ioloop
import tornado.web
import socket
import os
import json
import time
import sys
import MySQLdb as mdb
import base64 as security
import threading

DEBUG = True

#### STATIC CONFIGURATION --> DON'T CHANGE ####
PORT = 98
NODE_PORT = PORT - 1
OTA_URL = "Enter valid OTA url here!"
###############################################

### GLOBAL VARIABLES ###
LOGIN_ATTEMPTS = 0
web_cli = []
node_cli = []
########################

### DATABASE CONNECTIONS ###
try:
	con = mdb.connect("localhost","root","linux")
	con2 = mdb.connect("localhost","root","linux")
	#con = mdb.connect("localhost","root","")				# Only for testing purpose
	#con2 = mdb.connect("localhost","root","")				# Only for testing purpose
	db = con.cursor()
except:
	sys.exit("\nError: Failed to connect to database.\nCheck whether the service is running and credentials are correct.")
############################

def loginKey():
	f = open("smart.key","r")
	key = f.read()
	f.close()
	key = str(key)
	index  = key.find('\n')
	key = key[:index]
	key = security.b16decode(key)
	return key

def loginControl():
	lc = open("lc.time","r")
	data = lc.readline()
	lc.close()
	currentTime = time.time()
	if(currentTime >= float(data)):
		return True
	else:
		return False

def downloadOTA():
	url = "Enter .tar.gz OTA url"
	os.system("wget " + url + " -P " + os.getcwd() + "/")
	os.system("tar -xvzf *.tar.gz")
	os.system("rm *.tar.gz")

def initDB():
	print "Initializing MySQL database."
	db.execute("show databases")
	a = db.fetchall()
	a = str(a)
	if(a.find("smart") > 0):
		print "---> Database found."
	else:
		print "---> Database not found. creating..."
		db.execute("create database smart")
		db.execute("use smart")
		db.execute("create table map(room_no INT, d1 INT not null default 0, d2 INT not null default 0, d3 INT not null default 0, d4 INT not null default 0, d5 INT not null default 0, d6 INT not null default 0, d7 INT not null default 0, d8 INT not null default 0, slider INT not null default 0, active INT not null default 0, address VARCHAR(25), d1name VARCHAR(25), d2name VARCHAR(25), d3name VARCHAR(25), d4name VARCHAR(25), d5name VARCHAR(25), d6name VARCHAR(25), d7name VARCHAR(25), d8name VARCHAR(25), room_name VARCHAR(25), motion_sensor INT not null default 0)")
		db.execute("insert into map (room_no,room_name) values (1,' ')")
		db.execute("insert into map (room_no,room_name) values (2,' ')")
		db.execute("insert into map (room_no,room_name) values (3,' ')")
		db.execute("insert into map (room_no,room_name) values (4,' ')")
		db.execute("insert into map (room_no,room_name) values (5,' ')")
		db.execute("insert into map (room_no,room_name) values (6,' ')")
		db.execute("insert into map (room_no,room_name) values (7,' ')")
		db.execute("insert into map (room_no,room_name) values (8,' ')")
		con.commit()

		# create 8 separate tables for each room timer
		for i in range(1,9):
			tableName = "r" + str(i)
			db.execute("create table %s(device VARCHAR(3), onHr INT, onMin INT, onampm VARCHAR(1), offHr INT, offMin INT, offampm VARCHAR(1), repeate INT, timer_active INT not null default 0)" % (tableName))
			db.execute("insert into %s (device) values ('d1')" % (tableName))
			db.execute("insert into %s (device) values ('d2')" % (tableName))
			db.execute("insert into %s (device) values ('d3')" % (tableName))
			db.execute("insert into %s (device) values ('d4')" % (tableName))
			db.execute("insert into %s (device) values ('d5')" % (tableName))
			db.execute("insert into %s (device) values ('d6')" % (tableName))
			db.execute("insert into %s (device) values ('d7')" % (tableName))
			db.execute("insert into %s (device) values ('d8')" % (tableName))
		con.commit()
		
		db.execute("show databases")
		a = db.fetchall()
		a = str(a)
		if(a.find("smart") > 0):
			print "---> Database created successfully."
		else:
			print "---> Error creating database!!"
			sys.exit("*** Aborting due to database failure! ***")

class WSHandler(tornado.websocket.WebSocketHandler):

	def open(self):
		if DEBUG:
			print "New connection: " + self.request.remote_ip

	def on_message(self,message):

		msg = json.loads(message)
		self.printRequestInfo(msg)

		if(msg['type'] == "id"):
			if(msg['name'] == "node"):
				if self not in node_cli:
					node_cli.append(self)
					self.sendDataToNode(msg['data']['room'])
			else:
				if self not in web_cli:
					web_cli.append(self)


		elif(msg['type'] == "login"):
			global LOGIN_ATTEMPTS
			key = str(msg['data']['key'])
			if(key == str(loginKey()) and loginControl()):
				resp = {
							"name":"webapp",
							"type":"login",
							"resp":"grant"
				}
				resp = json.dumps(resp)
				self.write_message(resp)
				print "Logged in at : " +  time.strftime("%d/%m/%y  %I:%M:%S %p")
			else:
				LOGIN_ATTEMPTS = LOGIN_ATTEMPTS + 1
				if(LOGIN_ATTEMPTS < 5):
					resp = {
								"name":"webapp",
								"type":"login",
								"resp":"denied"
					}
					resp = json.dumps(resp)
					self.write_message(resp)
					print "Login denied at : " +  time.strftime("%d/%m/%y  %I:%M:%S %p")
				else:
					lc = open("lc.time","w")
					timeout = time.time() + 60
					lc.write(str(timeout))
					lc.close()
					resp = {
								"name":"webapp",
								"type":"login",
								"resp":"locked"
					}
					resp = json.dumps(resp)
					self.write_message(resp)
					print "Login locked at : " +  time.strftime("%d/%m/%y  %I:%M:%S %p")
			return


		elif(msg['type'] == "toggle"):
			device = 'd'+str(msg['data']['device'])
			room = msg['data']['room']
			value = msg['data']['value']	
			try:
				db.execute("use smart")
				db.execute("update map set %s=%s where room_no=%s" % (device, value, room))
				con.commit()
				db.execute("select d1,d2,d3,d4,d5,d6,d7,d8,slider from map where room_no=%s" % (room))
				result = db.fetchone()
				result = str(result[0]) + str(result[1]) + str(result[2]) + str(result[3]) + str(result[4]) + str(result[5]) + str(result[6]) + str(result[7]) + str(result[8])
				db.execute("select motion_sensor from map where room_no=%s" % (msg['data']['room']))
				motionStatus = db.fetchone()
				motionStatus = int(motionStatus[0])
				respNode = {
								"name":"broadcast",
								"type":"toggleNode",
								"data":
								{
									"room":room,
									"deviceValues":
									{
										"d1":int(result[0]),
										"d2":int(result[1]),
										"d3":int(result[2]),
										"d4":int(result[3]),
										"d5":int(result[4]),
										"d6":int(result[5]),
										"d7":int(result[6]),
										"d8":int(result[7])
									}
								}
							}
				respWeb = {
							"name":"webapp",
							"type":"broadcast",
							"data":
							{
								"room":room,
								"deviceValues":
								{
									"d1":int(result[0]),
									"d2":int(result[1]),
									"d3":int(result[2]),
									"d4":int(result[3]),
									"d5":int(result[4]),
									"d6":int(result[5]),
									"d7":int(result[6]),
									"d8":int(result[7])
								},
								"speed":int(result[8]),
								"motionStatus":motionStatus
							}
						}
				respNode = json.dumps(respNode)
				respWeb = json.dumps(respWeb)
				self.broadcastNode(respNode)
				self.broadcastWeb(respWeb)

			except:
				result = {
							"name":"server",
							"type":"err",
							"error":"db_error"
						}
				result = json.dumps(result)
				self.broadcastWeb(result)
				self.broadcastNode(result)


		elif(msg['type'] == "slider"):
			value = msg['data']['speed']
			room = msg['data']['room']
			try:
				db.execute("use smart")
				db.execute("update map set slider=%s where room_no=%s" % (value, room))
				con.commit()
				db.execute("select d1,d2,d3,d4,d5,d6,d7,d8,slider from map where room_no=%s" % (room))
				result = db.fetchone()
				result = str(result[0]) + str(result[1]) + str(result[2]) + str(result[3]) + str(result[4]) + str(result[5]) + str(result[6]) + str(result[7]) + str(result[8])
				db.execute("select motion_sensor from map where room_no=%s" % (msg['data']['room']))
				motionStatus = db.fetchone()
				motionStatus = int(motionStatus[0])
				respWeb = {
							"name":"webapp",
							"type":"broadcast",
							"data":
							{
								"room":room,
								"deviceValues":
								{
									"d1":int(result[0]),
									"d2":int(result[1]),
									"d3":int(result[2]),
									"d4":int(result[3]),
									"d5":int(result[4]),
									"d6":int(result[5]),
									"d7":int(result[6]),
									"d8":int(result[7])
								},
								"speed":int(result[8]),
								"motionStatus":motionStatus
							}
						}
				respNode = {
								"name":"broadcast",
								"type":"sliderNode",
								"data":
								{
									"room":room,
									"speed":value
								}
							}
				respWeb = json.dumps(respWeb)
				respNode = json.dumps(respNode)
				self.broadcastWeb(respWeb)
				self.broadcastNode(respNode)
			except:
				result = {
							"name":"server",
							"type":"err",
							"error":"db_error"
						}
				result = json.dumps(result)
				self.broadcastWeb(result)
				self.broadcastNode(result)


		elif(msg['type'] == "setRoomNames"):
			# check SMART.JSON for json format.
			try:
				db.execute("use smart")
				for i in range(1,9):
					if(msg['data']['r'+str(i)] == ''):
						break
					db.execute("update map set room_name='%s' where room_no=%s" % (msg['data']['r'+str(i)],str(i)))
				con.commit()
				resp = {
							"name":"server",
							"resp":"ok_setRoomNames"
						}
				resp = json.dumps(resp)
				self.write_message(resp)
			except Exception as e:
				raise e
				result = {
							"name":"server",
							"type":"err",
							"error":"setRoomNames_error"
						}
				result = json.dumps(result)
				self.write_message(result)


		elif(msg['type'] == "activeRooms"):
			# check SMART.JSON for json format.
			try:
				db.execute("use smart")
				for i in range(1,9):
					db.execute("update map set active=%d where room_no=%s" % (msg['data']['r'+str(i)],str(i)))
				con.commit()
				resp = {
							"name":"server",
							"resp":"ok_activeRooms"
						}
				resp = json.dumps(resp)
				self.write_message(resp)
				print "Room configuration updated."
			except:
				result = {
							"name":"server",
							"type":"err",
							"error":"activeRooms_error"
						}
				result = json.dumps(result)
				self.write_message(result)


		elif(msg['type'] == "shutdown"):
			resp = {
						"name":"broadcast",
						"type":"shutdown"
					}
			resp = json.dumps(resp)
			self.broadcastNode(resp)


		elif(msg['type'] == "reboot"):
			resp = {
						"name":"broadcast",
						"type":"reboot"
					}
			resp = json.dumps(resp)
			self.broadcastNode(resp)


		elif(msg['type'] == "ota"):
			try:
				print "OTA update checking.."
				os.system("wget " + OTA_URL + " -P " + os.getcwd() + "/")
				otaVers = open("version.txt","r")
				versionCheck = otaVers.read()
				otaVers.close()
				versionCheck = versionCheck.split("\n")
				versionCheck = float(versionCheck[0])
				if(VERSION < versionCheck):
					respNode = {
						"name":"broadcast",
						"type":"otaDownload"
					}
					respNode = json.dumps(respNode)
					self.broadcastNode(respNode)
					downloadOTA()
					print "System Update complete. New features will take effect after restart!"
					resp = {
						"name":"server",
						"type":"ota_complete"
					}
					resp = json.dumps(resp)
					self.broadcastWeb(resp)
				else:
					print "Your software is up-to-date!"
					resp = {
						"name":"server",
						"type":"ota_unavailable"
					}
					resp = json.dumps(resp)
					self.broadcastWeb(resp)
			except:
				print "OTA error."
				resp = {
							"name":"server",
							"type":"err",
							"error":"ota_error"
						}
				resp = json.dumps(resp)
				self.broadcastWeb(resp)


		elif(msg['type'] == "getRoomNames"):
			#try:
			db.execute("use smart")
			db.execute("select room_name from map")
			names = db.fetchall()
			respWeb = {
							"name":"webapp",
							"type":"respGetRoomNames",
							"data":
							{
								'r1':(names[0][0]),
								'r2':(names[1][0]),
								'r3':(names[2][0]),
								'r4':(names[3][0]),
								'r5':(names[4][0]),
								'r6':(names[5][0]),
								'r7':(names[6][0]),
								'r8':(names[7][0])
							}
						}
			print respWeb
			respWeb = json.dumps(respWeb)
			self.write_message(respWeb)
			'''except:
				resp = {
							"name":"server",
							"type":"err",
							"error":"getRoomNames_error"
						}
				resp = json.dumps(resp)
				self.write_message(result)'''


		elif(msg['type'] == "getDeviceNames"):
			try:
				db.execute("use smart")
				room_no = msg['data']['room']
				db.execute("select d1name,d2name,d3name,d4name,d5name,d6name,d7name,d8name from map where room_no=%s" % (str(room_no)))
				names = db.fetchall()
				db.execute("select motion_sensor from map where room_no=%s" % (msg['data']['room']))
				motionStatus = db.fetchone()
				motionStatus = int(motionStatus[0])
				respWeb = {
							"name":"webapp",
							"type":"respGetDeviceNames",
							"data":
							{
								"room":room_no,
								"deviceNames":
								{
									'd1':str(names[0][0]),
									'd2':str(names[0][1]),
									'd3':str(names[0][2]),
									'd4':str(names[0][3]),
									'd5':str(names[0][4]),
									'd6':str(names[0][5]),
									'd7':str(names[0][6]),
									'd8':str(names[0][7])
								},
								"motionStatus":motionStatus
							}
						}
				respWeb = json.dumps(respWeb)
				self.write_message(respWeb)
			except:
				resp = {
							"name":"server",
							"type":"err",
							"error":"getDeviceNames_error"
						}
				resp = json.dumps(resp)
				self.write_message(result)

		elif(msg['type'] == "getDeviceValues"):
			try:
				room = msg['data']['room']
				db.execute("select d1,d2,d3,d4,d5,d6,d7,d8,slider from map where room_no=%s" % (room))
				result = db.fetchone()
				db.execute("select motion_sensor from map where room_no=%s" % (msg['data']['room']))
				motionStatus = db.fetchone()
				motionStatus = int(motionStatus[0])
				result = str(result[0]) + str(result[1]) + str(result[2]) + str(result[3]) + str(result[4]) + str(result[5]) + str(result[6]) + str(result[7]) + str(result[8])
				respNode = {
										"name":"webapp",
										"type":"broadcast",
										"data":
										{
											"room":room,
											"deviceValues":
											{
												"d1":int(result[0]),
												"d2":int(result[1]),
												"d3":int(result[2]),
												"d4":int(result[3]),
												"d5":int(result[4]),
												"d6":int(result[5]),
												"d7":int(result[6]),
												"d8":int(result[7])
											},
											"speed":int(result[8]),
											"motionStatus":motionStatus
										}
							}
				respNode = json.dumps(respNode)
				print respNode
				self.write_message(respNode)
			except Exception as e:
				raise e
				resp = {
							"name":"server",
							"type":"err",
							"error":"getDeviceValues_error"
						}
				resp = json.dumps(resp)
				self.write_message(result)

		elif(msg['type'] == "setDeviceNames"):
			# check SMART.JSON for json format.
			try:
				deviceName = msg['data']['deviceName']
				room = msg['data']['room']
				deviceNo = "d" + str(msg['data']['deviceNo']) + "name"
				db.execute("use smart")
				db.execute("update map set %s='%s' where room_no=%s" % (deviceNo, deviceName, room))
				con.commit()
				resp = {
							"name":"server",
							"resp":"ok_setDeviceNames"
						}
				resp = json.dumps(resp)
				self.write_message(resp)
			except:
				resp = {
							"name":"server",
							"type":"err",
							"error":"setDeviceNames_error"
						}
				resp = json.dumps(resp)
				self.write_message(result)


		elif(msg['type'] == "setTimer"):
			try:
				room = "r" + str(msg['data']['room'])
				device = "d" + str(msg['data']['device'])
				db.execute("use smart")
				db.execute("update %s set onHr=%s where device='%s'" % (room, msg['data']['onHr'], device))
				db.execute("update %s set onMin=%s where device='%s'" % (room, msg['data']['onMin'], device))
				db.execute("update %s set onampm='%s' where device='%s'" % (room, msg['data']['onampm'], device))
				db.execute("update %s set offHr=%s where device='%s'" % (room, msg['data']['offHr'], device))
				db.execute("update %s set offMin=%s where device='%s'" % (room, msg['data']['offMin'], device))
				db.execute("update %s set offampm='%s' where device='%s'" % (room, msg['data']['offampm'], device))
				db.execute("update %s set repeate=%s where device='%s'" % (room, msg['data']['repeate'], device))
				db.execute("update %s set timer_active=1 where device='%s'" % (room, device))
				con.commit()
				resp = {
							"name":"server",
							"resp":"ack_timer_on"
						}
				resp = json.dumps(resp)
				self.write_message(resp)
			except:
				resp = {
							"name":"server",
							"type":"err",
							"error":"setTimer_error"
						}
				resp = json.dumps(resp)
				self.write_message(result)

		elif(msg['type'] == "disableTimer"):
			try:
				db.execute("use smart")
				db.execute("update %s set timer_active=0 where device='%s'" % ('r'+str(msg['data']['room']), msg['data']['device']))
				con.commit()
				resp = {
							"name":"server",
							"resp":"ack_timer_off"
						}
				resp = json.dumps(resp)
				self.write_message(resp)
			except:
				resp = {
							"name":"server",
							"type":"err",
							"error":"disableTimer_error"
						}
				resp = json.dumps(resp)
				self.write_message(result)


		elif(msg['type'] == "motionEnable"):
			try:
				db.execute("use smart")
				db.execute("update map set motion_sensor=%d where room_no=%d" % (int(msg['data']['motionEnable']), int(msg['data']['room'])))
				con.commit()
				resp = {
							"name":"server",
							"resp":"ack_motion"
						}
				resp = json.dumps(resp)
				self.write_message(resp)
			except:
				resp = {
							"name":"server",
							"type":"err",
							"error":"motionEnable_error"
						}
				resp = json.dumps(resp)
				self.write_message(result)


		elif(msg['type'] == "presence"):
			try:
				timeNow = str(datetime.datetime.now().time())
				timeNow = timeNow.split(':')
				hrNow = timeNow[0]
				minNow = timeNow[1]
				
				# auto lighting enabled from 6.30PM to 6.30AM --> TO-DO: make this programmable through webApp
				if((hrNow > 18 and minNow > 30) or (hrNow < 7 and minNow < 30)):
					db.execute("use smart")
					db.execute("select motion_sensor from map where room_no=%s" % (msg['data']['room']))
					isMotionEnable = db.fetchone()
					isMotionEnable = int(isMotionEnable[0])
					if(isMotionEnable):
						db.execute("update map set d1=%s where room_no=%s" % (msg['data']['presence'], msg['data']['room']))
						con.commit()

					# send updated response back to the node
					db.execute("select d1,d2,d3,d4,d5,d6,d7,d8,slider from map where room_no=%s" % (room))
					result = db.fetchone()
					result = str(result[0]) + str(result[1]) + str(result[2]) + str(result[3]) + str(result[4]) + str(result[5]) + str(result[6]) + str(result[7]) + str(result[8])
					respNode = {
									"name":"broadcast",
									"type":"toggleNode",
									"data":
									{
										"room":room_no,
										"deviceValues":
										{
											"d1":int(result[0]),
											"d2":int(result[1]),
											"d3":int(result[2]),
											"d4":int(result[3]),
											"d5":int(result[4]),
											"d6":int(result[5]),
											"d7":int(result[6]),
											"d8":int(result[7])
										}
									}
								}
			except:
				resp = {
							"name":"server",
							"type":"err",
							"error":"presence_error"
						}
				resp = json.dumps(resp)
				self.write_message(result)

		else:
			print "Request from bad source! Discarding.."
			self.write_message("bad source")

	def on_error(self,error):
		print "Websocket error: " + str(error)

	def on_close(self):
		print "Connection closed by " + self.request.remote_ip
		try:
			if self in web_cli:
				web_cli.remove(self)
			else:
				node_cli.remove(self)
		except:
			print "Error while closing connection!"

	def check_origin(self,origin):
		return True

	def broadcastWeb(self,msg1):
		for c1 in web_cli:
			c1.write_message(msg1)

	def broadcastNode(self,msg2):
		for c2 in node_cli:
			c2.write_message(msg2)

	def sendDataToNode(self,room):
		db.execute("use smart")
		db.execute("select d1,d2,d3,d4,d5,d6,d7,d8,slider from map where room_no=%s" % (room))
		result = db.fetchone()
		result = str(result[0]) + str(result[1]) + str(result[2]) + str(result[3]) + str(result[4]) + str(result[5]) + str(result[6]) + str(result[7]) + str(result[8])
		respNode = {
								"name":"broadcast",
								"type":"toggleNode",
								"data":
								{
									"room":room,
									"deviceValues":
									{
										"d1":int(result[0]),
										"d2":int(result[1]),
										"d3":int(result[2]),
										"d4":int(result[3]),
										"d5":int(result[4]),
										"d6":int(result[5]),
										"d7":int(result[6]),
										"d8":int(result[7])
									},
									"speed":int(result[8])
								}
					}
		respNode = json.dumps(respNode)
		self.write_message(respNode)

	def printRequestInfo(s,msg):
		if DEBUG:
			try:
				print "From: \t\t" + str(s.request.remote_ip)
				print "Name: \t\t" + msg['name']
				print "Type: \t\t" + msg['type']
				print "JSON data:\t" + str(msg['data'])
			except:
				print "Unknown JSON data. Unable to print."


#### Main program begins from here ####

app = tornado.web.Application([(r'/',WSHandler),])

if __name__ == "__main__":
	try:
		os.system("clear")
		print "\n\r[ Self Monitoring Analysing & Reporting Technology ] {S.M.A.R.T}\n\r"
		print "Started at: " +  time.strftime("%d/%m/%y  %I:%M:%S %p")
		print "IP Address: " + str(os.popen("hostname -I").read())
		try:
			initDB()
			http_server = tornado.httpserver.HTTPServer(app)
			http_server.listen(PORT)
			myIP = socket.gethostbyname(socket.gethostname())
			print "Tornado websocket started at %s:%s" % (myIP,PORT)
			tornado.ioloop.IOLoop.instance().start()
		except:
			sys.exit("\nWeird! Tornado Exception occured.Aborting...")
	except(KeyboardInterrupt):
		sys.exit("Keyboard Interrupt. Aborting...")
