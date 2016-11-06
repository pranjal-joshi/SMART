#!/usr/bin/python

from ws4py.client.tornadoclient import TornadoWebSocketClient
from tornado import ioloop
from time import sleep
import time
import json

class MyClient(TornadoWebSocketClient):
	 def opened(self):
		time.sleep(1)
		a = {"name":"webapp","type":"toggle","data":{"room":2,"device":4,"value":1}}
		x = json.dumps(a)
		self.send(x)
		self.close()

	 def received_message(self, m):
		print m

	 def closed(self, code, reason=None):
		 ioloop.IOLoop.instance().stop()

ws = MyClient('ws://localhost:98/',0)
ws.connect()

ioloop.IOLoop.instance().start()

