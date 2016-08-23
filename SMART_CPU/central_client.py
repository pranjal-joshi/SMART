#!/usr/bin/python

# Client to be used on central server

import urllib2
import argparse

DEBUG = True
NODE_SERVER_PORT = 97

ap = argparse.ArgumentParser()
ap.add_argument("-i","--IP",required=True,help="IP address of server")
args = vars(ap.parse_args())
addr = args["IP"]
urlToSend = "http://"+str(addr)+":"+str(NODE_SERVER_PORT)+"/?appActivity"
resp = urllib2.urlopen(urlToSend).read()
if DEBUG:
	print "# Debug information =>"
	print urlToSend
	print resp
	print "======================"