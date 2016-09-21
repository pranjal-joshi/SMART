// smart javascript file

var SERVER = "192.168.0.160";
var PORT = "80";
var ROOM = 1;
var ROOM_NAMES = ["Room 1","Room 2","Room 3","Room 4","Room 5","Room 6","Room 7","Room 8"];

var DEBUG = 1;
var updateTimer;

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

  function checkAddress(roomName1)
    {
      var x = "id: " + roomName1.id + "\nValue: " + roomName1.checked;
      console.log(x);
    }

    function lostFocus()
    {
      console.log("focus lost");
    }

    function range123()
    {
     var x = document.getElementById("fan_slider").value;
    document.getElementById("demo").innerHTML = x;
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
    location.href="welcome.html";
}

function httpGet(theUrl, callback)
{
    var xmlHttp = new XMLHttpRequest();
    xmlHttp.onreadystatechange = processRequest;
    function processRequest(e)
    {
    	if(xmlHttp.readyState == 4)
    	{
    		callback(decodeURI(xmlHttp.responseText));
    	}
    }
    xmlHttp.timeout = 3000;
    xmlHttp.ontimeout = function(e)
    {
    	$('#errorModal').openModal();
    }
    xmlHttp.open( "GET", theUrl, true ); // false for synchronous request
    xmlHttp.send(null);
}

function switchToggle(btn)
{
	var state;
	if(btn.checked)
		state = "1";
	else
		state = "0";

	var url = "http://" + SERVER + ":" + PORT + "/?toggle=&" + ROOM.toString() + "&" + btn.id + "&" + state;
	httpGet(url,function(resp){
		if(!(resp.indexOf("toggle ok")>=0))
		{
			$('#errorModal').openModal();
		}
	});

}

function getRoom(room)
{
	var roomNo = room.id.split('');
	ROOM = roomNo[1];
	document.getElementById("navbarTitle").innerHTML = ROOM_NAMES[ROOM - 1];

	// get device names
	url = "http://" + SERVER + ":" + PORT + "/?getDeviceNames=&" + ROOM.toString();
	console.log("getDeviceURL: " + url);
	httpGet(url,function(deviceList){
		if(deviceList[0] != "&")
		{
			deviceList = deviceList.split("&");
			console.log("splitted deviceList = " + deviceList);
			var loopId;
			for(i=1;i<9;i++)
			{
				loopId = "d" + i.toString();
				if(!(deviceList[i-1] == "None"))
					document.getElementById(loopId).value = decodeURI(deviceList[i-1]);
				else
					document.getElementById(loopId).value = "";
			}
		}
	});

	// get switch states
	getSwitches(ROOM);
	updateTimer = setInterval(getSwitches,1500,ROOM);
}

function getSwitches(r)
{
	url = "http://" + SERVER + ":" + PORT + "/?requestUpdate=&" + r.toString();
	console.log(url);
	httpGet(url,function(resp){
		resp = resp.split('');
		console.log(resp);
		for(i=1;i<9;i++)
		{
			if(resp[i-1] == '1')
				document.getElementById(i.toString()).checked = true;
			else
				document.getElementById(i.toString()).checked = false;
		}
	});
}

function getRoomNames()											// call this onLoad
{
	url = "http://" + SERVER + ":" + PORT + "/?getRoomNames";
	httpGet(url,function(list){
		if(DEBUG)
			console.log(list);
		if(list[0] != "&")
		{
			list = list.split("&");
			var loopId;
			for(i=1;i<9;i++)
			{
				loopId = "r" + i.toString();
				document.getElementById(loopId).innerHTML = decodeURI(list[i-1]);
				ROOM_NAMES[i-1] = list[i-1];
			}
			document.getElementById("navbarTitle").innerHTML = ROOM_NAMES[ROOM - 1];
		}
		else if((list[0] == undefined) || (list[0] == 0))
		{
			document.getElementById("navbarTitle").innerHTML = ROOM_NAMES[ROOM - 1];
		}

	});
}

function setDeviceName(roomBox)
{
	var name = document.getElementById(roomBox.id).value;
	var deviceNo = roomBox.id.split('');
	deviceNo = deviceNo[1];
	url = "http://" + SERVER + ":" + PORT + "/?setDeviceName=&" + ROOM.toString() + "&" + deviceNo + "&" + name;
	if(DEBUG)
		console.log(url);
	httpGet(url, function(resp){
		if(!(resp.indexOf("ok")>=0))
			$('#errorModal').openModal();
	});
}

function setRoomNames()
{
	var activeRoomUrl = "http://" + SERVER + ":" + PORT + "/?activeRooms=";
	var url = "http://" + SERVER + ":" + PORT + "/?setRoomNames=";
	for(i=1;i<9;i++)
	{
		var boxId = "room" + i.toString();
		if(document.getElementById(boxId).checked)
		{
			activeRoomUrl = activeRoomUrl + "&" + i.toString();
		}
	}
	for(i=1;i<9;i++)
	{
		var textId = "roomName" + i.toString();
		url = url + "&" + document.getElementById(textId).value;
	}
	httpGet(activeRoomUrl,function (updateRes){
		if(!(updateRes.indexOf("OK")>=0))
			$('#errorModal').openModal();
		url = "";
		activeRoomUrl = "";
		location.href = "control.html";
	});
	httpGet(url,function(nothing){});
}

function login()
{
	Materialize.toast('Logging in..', 1000);
	url = "http://" + SERVER + ":" + PORT + "/?loginPass=" + (document.getElementById("loginBox").value);
	httpGet(url,function (response){
		if(DEBUG)
			console.log(url + "\n" + response);
		if(response.indexOf("grant")>=0)
			location.href = "control.html";
		if(response.indexOf("denied")>=0)
			Materialize.toast('Wronge password!', 2000);
		if(response.indexOf("locked")>=0)
			Materialize.toast('Locked due to security reasons. Try again after few minutes.', 3000);
		if(response == 0)
			$('#errorModal').openModal();
	});
}

// login on pressing enter on welcome page
$("#loginBox").keyup(function(event){
    if(event.keyCode == 13){
        $("#loginButton").click();
    }
});

function disableTextbox(chk)
{
	var idNo = chk.id.split('');
	idNo = idNo[4];
	var txtId = "roomName" + idNo;
	if(chk.checked)
		document.getElementById(txtId).disabled = false;
	else
		document.getElementById(txtId).disabled = true;

}

function shutdown()
{
	url = "http://" + SERVER + ":" + PORT + "/?shutDown";
	httpGet(url,function(doNothing){});
	clearInterval(updateTimer);
}

function reboot()
{
	url = "http://" + SERVER + ":" + PORT + "/?reboot";
    httpGet(url,function(doNothing){});
    clearInterval(updateTimer);
}

function checkUpdate()
{
	url = "http://" + SERVER + ":" + PORT + "/?otaUpdate";
    httpGet(url,function(otaResp){
		if(otaResp.indexOf("ota complete") >= 0)
		{
			$('#otaModal').closeModal();
			Materialize.Toast("System update successful. New features will take effect after restart.", 6000);
		}
		if(otaResp.indexOf("ota unavailable") >= 0)
                { 
                        $('#otaModal').closeModal();
                        Materialize.Toast("Your software is up to date.", 3000);
                }	
	});
	clearInterval(updateTimer);
}
