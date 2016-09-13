// smart javascript file

var SERVER = "192.168.0.150";
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
    xmlHttp.send( null );
    xmlHttp.ontimeout = function(){
  		alert("Something went wrong. S.M.A.R.T is unreachable!");
	}
    return xmlHttp.responseText;
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
		alert("Something went wrong. S.M.A.R.T is unreachable!\nResponse: " + resp);

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