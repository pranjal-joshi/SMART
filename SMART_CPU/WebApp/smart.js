// smart javascript file

var SERVER = "192.168.0.160";
var PORT = "98";
var ROOM = 1;
var ROOM_NAMES = ["Room 1","Room 2","Room 3","Room 4","Room 5","Room 6","Room 7","Room 8"];

var DEBUG = 1;

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
      alert(x);
    }

    function lostFocus()
    {
      alert("focus lost");
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

function httpGet(theUrl)
{
    var xmlHttp = new XMLHttpRequest();
    xmlHttp.open( "GET", theUrl, true ); // false for synchronous request
    xmlHttp.send(null);
    xmlHttp.onreadystatechange = processRequest;
    function processRequest(e)
    {
    	if(xmlHttp.readyState == 4)
    	{
    		return xmlHttp.responseText;
    	}
    }
}

function switchToggle(btn)
{
	var state;
	if(btn.checked)
		state = "1";
	else
		state = "0";

	var url = "http://" + SERVER + ":" + PORT + "/?toggle=&" + ROOM.toString() + "&" + btn.id + "&" + state;
	var resp = httpGet(url);
	if(!(resp.includes("toggle ok")))
	{
		$('#errorModal').openModal();
	}

}

function getRoom(room)
{
	var roomNo = room.id.split('');
	ROOM = roomNo[1];
	document.getElementById("navbarTitle").innerHTML = ROOM_NAMES[ROOM - 1];

	// get device names
	url = "http://" + SERVER + ":" + PORT + "/?getDeviceNames=&" + ROOM.toString();
	var deviceList = httpGet(url);
	if(deviceList != null)
	{
		deviceList = deviceList.split("&");
		var loopId;
		for(i=1;i<9;i++)
		{
			loopId = "device" + i.toString();
			document.getElementById(loopId).innerHTML = deviceList[i-1];
		}
	}

	// get switch states
	getSwitches();


}

function getSwitches()
{
	url = "http://" + SERVER + ":" + PORT + "/?updateResponse=&" + ROOM.toString();
	var resp = httpGet(url);
	resp = resp.split('');
	for(i=1;i<9;i++)
	{
		if(resp[i-1] == '1')
			document.getElementById(i.toString()).checked = true;
		else
			document.getElementById(i.toString()).checked = false;
	}
}

function getRoomNames()											// call this onLoad
{
	url = "http://" + SERVER + ":" + PORT + "/?getRoomNames";
	var list = httpGet(url);
	alert(list);
	if(!(list.includes(NULL)))
	{
		list = list.split("&");
		var loopId;
		for(i=1;i<9;i++)
		{
			loopId = "r" + i.toString();
			document.getElementById(loopId).innerHTML = list[i-1];
			ROOM_NAMES[i-1] = list[i-1];
		}
	}
	document.getElementById("navbarTitle").innerHTML = ROOM_NAMES[ROOM - 1];
}

function setDeviceName(roomBox)
{
	var name = document.getElementById(roomBox.id).value;
	var deviceNo = roomBox.id.split('');
	deviceNo = deviceNo[1];
	url = "http://" + SERVER + ":" + PORT + "/?setDeviceName=&" + ROOM.toString() + "&" + deviceNo + "&" + name;
	var resp = httpGet(url);
	if(DEBUG)
		alert(url);
	if(!(resp.includes("ok")))
		$('#errorModal').openModal();
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
	var resp = httpGet(activeRoomUrl);
	setTimeout(function () {}, 200);
	var updateRes = httpGet(url);
	if(DEBUG)
		alert(url + "\n" + activeRoomUrl);
	if(!(updateRes.includes("OK")))
		$('#errorModal').openModal();
	url = "";
	activeRoomUrl = "";
	location.href = "mat3.html";
}

function login()
{
	Materialize.toast('Logging in..', 1000);
	url = "http://" + SERVER + ":" + PORT + "/?loginPass=" + (document.getElementById("loginBox").value);
	var resp = httpGet(url);
	if(DEBUG)
		alert(url + "\n" + resp);
	if(resp.includes("grant"))
		location.href = "mat3.html";
	if(resp.includes("denied"))
		Materialize.toast('Wronge password!', 2000);
	if(resp.includes("locked"))
		Materialize.toast('Locked due to security reasons. Try again after few minutes.', 3000);
	//if(resp == 0)
	//	$('#errorModal').openModal();
}

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
