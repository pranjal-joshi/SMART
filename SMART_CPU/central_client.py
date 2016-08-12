#!/usr/bin/python

# Client to be used on central server

import urllib2
import argparse

DEBUG = True
PORT = 98

ap = argparse.ArgumentParser()
ap.add_argument("-i","--IP",required=True,help="IP address of server")
args = vars(ap.parse_args())
addr = args["IP"]
urlToSend = "http://"+str(addr)+":"+str(PORT)+"/?appActivity"
resp = urllib2.urlopen(urlToSend).read()
if DEBUG:
	print "# Debug information =>"
	print urlToSend
	print resp
	print "======================"