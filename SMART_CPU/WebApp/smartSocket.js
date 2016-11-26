
//Author	:	Pranjal P. Joshi
//Date 		:	0/11/2016
//All rights reserved.

//var SERVER = "192.168.0.160";			// ---> Depricated method
//var SERVER = "localhost";

var SERVER= window.location.href;			// ----> USE THIS INSTEAD
SERVER = SERVER.split('/');
SERVER = SERVER[2];

var PORT = "98";
var ROOM = 1;
var ROOM_NAMES = ["Room 1","Room 2","Room 3","Room 4","Room 5","Room 6","Room 7","Room 8"];

var DEBUG = 1;
var updateTimer = 0;

var color_change_var;

var ws = new WebSocket("ws://" + SERVER + ":" + PORT + "/");

function startDictation() {
 
    if (window.hasOwnProperty('webkitSpeechRecognition')) {
 
      var recognition = new webkitSpeechRecognition();
 
      recognition.continuous = false;
      recognition.interimResults = false;
 
      recognition.lang = "en-US";
      recognition.start();
 
      recognition.onresult = function(e) {
        document.getElementById('transcript').value
                                 = e.results[0][0].transcript;
        recognition.stop();
        document.getElementById('labnol').submit();
      };
 
      recognition.onerror = function(e) {
        recognition.stop();
      }
 
    }
  }


    $(document).ready(function(){
      $('.modal-trigger').leanModal();
    });   
   
    $(document).ready(function() {
      $('select').material_select();
    });

    $('.button-collapse').sideNav({
      menuWidth: 220, // Default is 240
      edge: 'left', // Choose the horizontal origin
      closeOnClick: false // Closes side-nav on <a> clicks, useful for Angular/Meteor
    }
  );
 

    $('.dropdown-button').dropdown({
          inDuration: 300,
          outDuration: 225,
          constrain_width: false, // Does not change width of dropdown to that of the activator
          hover: false, // Activate on hover
          gutter: 0, // Spacing from edge
          belowOrigin: true, // Displays dropdown below the button
          alignment: 'right' // Displays dropdown with edge aligned to the left of button
        }
      );
 
$(document).ready(function(){
    $('.modal-trigger').leanModal();
});

function reloadWindow()
{
    location.reload(true);
}

function closeTab()
{
    location.href="index.html";
}

function goBack() {
    window.history.back();
}

function windowResize(){
	if($(document).width()<977)
		$('.button-collapse').sideNav('hide');
}

$("#loginBox").keyup(function(event){
    if(event.keyCode == 13){
        $("#loginButton").click();
    }
});

function disableTextbox(chk)
{
	var idNo = chk.id.split('');
	idNo = idNo[4];
	var txtId = "r" + idNo;
	if(chk.checked)
		document.getElementById(txtId).disabled = false;
	else
		document.getElementById(txtId).disabled = true;

}

// -------------------- SOCKET HANDLER ----------------
ws.onclose = function(evt){
	$('#errorModal').openModal();
};

ws.onopen = function(evt){
	// don't know what to do..
};

ws.onmessage = function(evt){
	// callbacks here	

	msg = JSON.parse(evt.data);

	// handle socket broadcast
	if(msg.name === "webapp" && msg.type === "broadcast"){
		if(msg.data.room === ROOM){
			document.getElementById("1").checked = Boolean(msg.data.deviceValues.d1);
			document.getElementById("2").checked = Boolean(msg.data.deviceValues.d2);
			document.getElementById("3").checked = Boolean(msg.data.deviceValues.d3);
			document.getElementById("4").checked = Boolean(msg.data.deviceValues.d4);
			document.getElementById("5").checked = Boolean(msg.data.deviceValues.d5);
			document.getElementById("6").checked = Boolean(msg.data.deviceValues.d6);
			document.getElementById("7").checked = Boolean(msg.data.deviceValues.d7);
			document.getElementById("8").checked = Boolean(msg.data.deviceValues.d8);
			document.getElementById("fan_slider").value = msg.data.speed;
			document.getElementById("motionSwitch").checked = Boolean(msg.data.motionStatus);
		}
	}

	// handle responses
	if(msg.type === "login"){
		switch(msg.resp){
			case "grant":
				$.cookie('smartLogin','grant',{expires:1, path:'/'});
				location.href = "control.html";
				break;
			case "locked":
				$.cookie('smartLogin','locked',{expires:1, path:'/'});
				Materialize.toast('Locked due to security reasons. Try again after few minutes.', 3000);
				break;
			case "denied":
				$.cookie('smartLogin','denied',{expires:1, path:'/'});
				Materialize.toast('Wronge password!', 2000);
				break;
			default:
				$('#errorModal').openModal();
		}
	}

	else if(msg.type === "respGetRoomNames"){
		ROOM_NAMES[0] = msg.data.r1;
		ROOM_NAMES[1] = msg.data.r2;
		ROOM_NAMES[2] = msg.data.r3;
		ROOM_NAMES[3] = msg.data.r4;
		ROOM_NAMES[4] = msg.data.r5;
		ROOM_NAMES[5] = msg.data.r6;
		ROOM_NAMES[6] = msg.data.r7;
		ROOM_NAMES[7] = msg.data.r8;
		for(i=0;i<8;i++){
			var tmp = "r"+ (i+1).toString();
			document.getElementById(tmp).innerHTML = ROOM_NAMES[i];
		}
		try{
			document.getElementById("navbarTitle").innerHTML = ROOM_NAMES[0];
		}
		catch(err){}
		try{
			for(i=1;i<9;i++)
			{
				if((ROOM_NAMES[i-1] == null) || (ROOM_NAMES[i-1] == 0) || (ROOM_NAMES[i-1] == undefined))
				{
					var checkboxName = "room" + i.toString();
					document.getElementById(checkboxName).checked = false;

					var txtId = "r" + i.toString();
					document.getElementById(txtId).disabled = true;
				}
			}
		}
		catch(err){}
	}

	else if(msg.type === "respGetDeviceNames"){
		document.getElementById("d1").value = msg.data.deviceNames.d1;
		document.getElementById("d2").value = msg.data.deviceNames.d2;
		document.getElementById("d3").value = msg.data.deviceNames.d3;
		document.getElementById("d4").value = msg.data.deviceNames.d4;
		document.getElementById("d5").value = msg.data.deviceNames.d5;
		document.getElementById("d6").value = msg.data.deviceNames.d6;
		document.getElementById("d7").value = msg.data.deviceNames.d7;
		document.getElementById("d8").value = msg.data.deviceNames.d8;
	}

	else if(msg.type === "respGetDeviceValues"){
		document.getElementById("1").checked = Boolean(msg.data.d1);
		document.getElementById("2").checked = Boolean(msg.data.d2);
		document.getElementById("3").checked = Boolean(msg.data.d3);
		document.getElementById("4").checked = Boolean(msg.data.d4);
		document.getElementById("5").checked = Boolean(msg.data.d5);
		document.getElementById("6").checked = Boolean(msg.data.d6);
		document.getElementById("7").checked = Boolean(msg.data.d7);
		document.getElementById("8").checked = Boolean(msg.data.d8);
		document.getElementById("fan_slider").value = msg.data.speed;
	}

	else if(msg.type === "ota_unavailable"){
		Materialize.toast("Your version is already up-to-date",2000);
	}

	else if(msg.type === "ota_available"){
		Materialize.toast("System is updated to latest version. New features will take effect after restart.",3000);
	}	

	else if(msg.type === "ota_error"){
		Materialize.toast("Error occured during system update!",2000);
	}

	else if(msg.resp === "ack_timer_on")
		document.getElementById("timerButton" + color_change_var.toString()).style.backgroundColor = "#ff1744"; // red-accent 4 color on timer enabled

	else if(msg.resp === "ack_timer_off")
		document.getElementById("timerButton" + color_change_var.toString()).style.backgroundColor = "#009688"; // teal color on timer disabled

	else if(msg.type === "err"){
		alert("Error:" + msg.error);
	}

};

function login(){
	Materialize.toast('Logging in..',1000);
	var jsonData = JSON.stringify({
						"name":"webapp",
						"type":"login",
						"data":
						{
							"key":document.getElementById("loginBox").value
						}
	});
	ws.send(jsonData);
}

function switchToggle(btn) {
	var jsonData = JSON.stringify({
			"name":"webapp",
			"type":"toggle",
			"data":
			{
				"room":ROOM,
				"device":btn.id,
				"value":btn.checked | 0
			}
		});
	ws.send(jsonData);
}

function getRoomNames(){
	var jsonData = JSON.stringify({
		"name":"webapp",
		"type":"getRoomNames"
	});
	ws.send(jsonData);
	getRoom(document.getElementById('r1'));
}

function getRoom(room){
	var roomNo = room.id.split('');
	ROOM = roomNo[1];
	document.getElementById("navbarTitle").innerHTML = ROOM_NAMES[ROOM - 1];

	var jsonData = JSON.stringify({
		"name":"webapp",
		"type":"getDeviceNames",
		"data":
		{
			"room":ROOM
		}
	});
	ws.send(jsonData);
	setTimeout(getSwitches,100,ROOM);
	// Close sideNav if window size < 977px i.e. mobile view
	if($(document).width()<977)
	{
		$('.button-collapse').sideNav('hide');
	}
}

function getSwitches(room){
	var jsonData = JSON.stringify({
			"name":"webapp",
			"type":"getDeviceValues",
			"data":
			{
				"room":room
			}
	});
	ws.send(jsonData)
}

function setDeviceName(roomBox){
	var name = document.getElementById(roomBox.id).value;
	if(name != "")
	{
		var deviceNo = roomBox.id.split('');
		deviceNo = deviceNo[1];
		var jsonData = JSON.stringify({
				"name":"webapp",
				"type":"setDeviceNames",
				"data":
				{
					"room":ROOM,
					"deviceNo":deviceNo,
					"deviceName":name
				}
		});
		ws.send(jsonData);
	}
}

function setRoomNames(){
	var jsonData = JSON.stringify({
		"name":"webapp",
		"type":"setRoomNames",
		"data":
		{
			"r1":document.getElementById("r1").value,
			"r2":document.getElementById("r2").value,
			"r3":document.getElementById("r3").value,
			"r4":document.getElementById("r4").value,
			"r5":document.getElementById("r5").value,
			"r6":document.getElementById("r6").value,
			"r7":document.getElementById("r7").value,
			"r8":document.getElementById("r8").value
		}
	});
	ws.send(jsonData);

	// bool | 0 == Integer
	var jsonData2 = JSON.stringify({
		"name":"webapp",
		"type":"activeRooms",
		"data":
		{
			"r1":document.getElementById("room1").checked | 0,
			"r2":document.getElementById("room2").checked | 0,
			"r3":document.getElementById("room3").checked | 0,
			"r4":document.getElementById("room4").checked | 0,
			"r5":document.getElementById("room5").checked | 0,
			"r6":document.getElementById("room6").checked | 0,
			"r7":document.getElementById("room7").checked | 0,
			"r8":document.getElementById("room8").checked | 0
		}
	});
	ws.send(jsonData2);
	Materialize.toast("Configuration updated.",1500);
}

function shutdown(){
	var jsonData = JSON.stringify({
				"name":"webapp",
				"type":"shutdown"
			});
	ws.send(jsonData);
}

function reboot(){
	var jsonData = JSON.stringify({
				"name":"webapp",
				"type":"reboot"
			});
	ws.send(jsonData);
}

function checkUpdate(){
	var jsonData = JSON.stringify({
				"name":"webapp",
				"type":"ota"
			});
	ws.send(jsonData);
}

function getRoomNamesForConfigPage(){
	//getRoomNames();
	for(i=1;i<9;i++)
	{
		if((ROOM_NAMES[i-1] == null) || (ROOM_NAMES[i-1] == 0) || (ROOM_NAMES[i-1] == undefined))
		{
			var checkboxName = "room" + i.toString();
			document.getElementById(checkboxName).checked = false;

			var txtId = "r" + i.toString();
			document.getElementById(txtId).disabled = true;
		}
		else
		{
			var id = "r" + i.toString();
			document.getElementById(id).value = ROOM_NAMES[i-1];
			var checkboxName = "room" + i.toString();
			document.getElementById(checkboxName).checked = true;
		}
	}
}

function sliderChange(val)
{
	var jsonData = JSON.stringify({
		"name":"webapp",
		"type":"slider",
		"data":
		{
			"room":ROOM,
			"speed":val
		}
	});
	ws.send(jsonData);
}

function setTimer(id)
{

	var device = id.toString().split("");
	device = device[2];
	color_change_var = device;

	var onTimeBox = document.getElementById("onTime" + device).value;
	var offTimeBox = document.getElementById("offTime" + device).value;

	if(onTimeBox == offTimeBox)
	{
		$('#sameTimeErrorModal').openModal();
	}
	else
	{
		if((offTimeBox != '') && (onTimeBox != ''))
		{
			var onHr = onTimeBox.toString().split(":");
			var onMin = onHr[1];
			onHr = onHr[0];
			onMin = onMin.toString().split(" ");
			var onampm = onMin[1];
			onMin = onMin[0];
			onampm = onampm.split("");
			onampm = onampm[0];

			var offHr = offTimeBox.toString().split(":");
			var offMin = offHr[1];
			offHr = offHr[0];
			offMin = offMin.toString().split(" ");
			var offampm = offMin[1];
			offMin = offMin[0];
			offampm = offampm.split("");
			offampm = offampm[0];

			var repeate;
			if(document.getElementById("dailySwitch" + device).checked)		// checked for daily/repeate
				repeate = "1";
			else
				repeate = "0";

			var jsonData = JSON.stringify({
				"name":"webapp",
				"type":"setTimer",
				"data":
				{
					"room":ROOM,
					"device":device,
					"onHr":onHr,
					"onMin":onMin,
					"onampm":onampm,
					"offHr":offHr,
					"offMin":offMin,
					"offampm":offampm,
					"repeate":repeate
				}
			});
			ws.send(jsonData);
		}
		else
		{
			$('#timerErrorModal').openModal();
		}
	}
}

function disableTimer(id)
{
	var device = id.toString().split("");
	device = device[2];
	color_change_var = device;

	var jsonData = JSON.stringify({
			"name":"webapp",
			"type":"disableTimer",
			"data":
			{
				"room":ROOM,
				"device":device
			}
		});
	ws.send(jsonData);
}

function motionSensorToggleButton()
{
	var jsonData = JSON.stringify({
			"name":"node",
			"type":"motionEnable",
			"data":
			{
				"room":ROOM,
				"motionEnable":document.getElementById("motionSwitch").checked | 0
			}
		});
	ws.send(jsonData);
}

function addClient(){
	var jsonData = JSON.stringify({
		"name":"webapp",
		"type":"id"
	});
	ws.send(jsonData);
}

function logout() {
	$.removeCookie('smartLogin', { path: '/' });
	location.href = "index.html";
}