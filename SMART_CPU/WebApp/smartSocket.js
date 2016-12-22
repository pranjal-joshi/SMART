
//Author  : Pranjal P. Joshi
//Date    : 0/11/2016
//All rights reserved.

//var SERVER = "192.168.0.160";     // ---> Depricated method
//var SERVER = "localhost";

var SERVER= window.location.href;     // ----> USE THIS INSTEAD
SERVER = SERVER.split('/');
SERVER = SERVER[2];

var PORT = "98";
var ROOM = 1;
var ROOM_NAMES = new Array(8);

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
  {
    document.getElementById(txtId).disabled = false;
    document.getElementById(txtId).value = ' ';
  }
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
      //if(ROOM_NAMES[i] === ("Room " + i.toString()))
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

  else if(msg.type === "respGetTimers"){
    if(msg.data.enabled.t1 == 1)
      document.getElementById("timerButton1").style.backgroundColor = "#ff1744";
    else
      document.getElementById("timerButton1").style.backgroundColor = "#009688";
    if(msg.data.enabled.t2 == 1)
      document.getElementById("timerButton2").style.backgroundColor = "#ff1744";
    else
      document.getElementById("timerButton2").style.backgroundColor = "#009688";
    if(msg.data.enabled.t3 == 1)
      document.getElementById("timerButton3").style.backgroundColor = "#ff1744";
    else
      document.getElementById("timerButton3").style.backgroundColor = "#009688";
    if(msg.data.enabled.t4 == 1)
      document.getElementById("timerButton4").style.backgroundColor = "#ff1744";
    else
      document.getElementById("timerButton4").style.backgroundColor = "#009688";
    if(msg.data.enabled.t5 == 1)
      document.getElementById("timerButton5").style.backgroundColor = "#ff1744";
    else
      document.getElementById("timerButton5").style.backgroundColor = "#009688";
    if(msg.data.enabled.t6 == 1)
      document.getElementById("timerButton6").style.backgroundColor = "#ff1744";
    else
      document.getElementById("timerButton6").style.backgroundColor = "#009688";
    if(msg.data.enabled.t7 == 1)
      document.getElementById("timerButton7").style.backgroundColor = "#ff1744";
    else
      document.getElementById("timerButton7").style.backgroundColor = "#009688";
    if(msg.data.enabled.t8 == 1)
      document.getElementById("timerButton8").style.backgroundColor = "#ff1744";
    else
      document.getElementById("timerButton8").style.backgroundColor = "#009688";

    if(msg.data.ontime.t1.indexOf("None") < 0){
      document.getElementById("onTime1").value = msg.data.ontime.t1;
      document.getElementById("offTime1").value = msg.data.offtime.t1;
      document.getElementById("dailySwitch1").checked = msg.data.repeate.t1 | 0;
    }
    else
    {
      document.getElementById("onTime1").value = "";
      document.getElementById("offTime1").value = "";
      document.getElementById("dailySwitch1").checked = false;
    }
    if(msg.data.ontime.t2.indexOf("None") < 0){
      document.getElementById("onTime2").value = msg.data.ontime.t2;
      document.getElementById("offTime2").value = msg.data.offtime.t2;
      document.getElementById("dailySwitch2").checked = msg.data.repeate.t2 | 0;
    }
    else
    {
      document.getElementById("onTime2").value = "";
      document.getElementById("offTime2").value = "";
      document.getElementById("dailySwitch2").checked = false;
    }
    if(msg.data.ontime.t3.indexOf("None") < 0){
      document.getElementById("onTime3").value = msg.data.ontime.t3;
      document.getElementById("offTime3").value = msg.data.offtime.t3;
      document.getElementById("dailySwitch3").checked = msg.data.repeate.t3 | 0;
    }
    else
    {
      document.getElementById("onTime3").value = "";
      document.getElementById("offTime3").value = "";
      document.getElementById("dailySwitch3").checked = false;
    }
    if(msg.data.ontime.t4.indexOf("None") < 0){
      document.getElementById("onTime4").value = msg.data.ontime.t4;
      document.getElementById("offTime4").value = msg.data.offtime.t4;
      document.getElementById("dailySwitch4").checked = msg.data.repeate.t4 | 0;
    }
    else
    {
      document.getElementById("onTime4").value = "";
      document.getElementById("offTime4").value = "";
      document.getElementById("dailySwitch4").checked = false;
    }
    if(msg.data.ontime.t5.indexOf("None") < 0){
      document.getElementById("onTime5").value = msg.data.ontime.t5;
      document.getElementById("offTime5").value = msg.data.offtime.t5;
      document.getElementById("dailySwitch5").checked = msg.data.repeate.t5 | 0;
    }
    else
    {
      document.getElementById("onTime5").value = "";
      document.getElementById("offTime5").value = "";
      document.getElementById("dailySwitch5").checked = false;
    }
    if(msg.data.ontime.t6.indexOf("None") < 0){
      document.getElementById("onTime6").value = msg.data.ontime.t6;
      document.getElementById("offTime6").value = msg.data.offtime.t6;
      document.getElementById("dailySwitch6").checked = msg.data.repeate.t6 | 0;
    }
    else
    {
      document.getElementById("onTime6").value = "";
      document.getElementById("offTime6").value = "";
      document.getElementById("dailySwitch6").checked = false;
    }
    if(msg.data.ontime.t7.indexOf("None") < 0){
      document.getElementById("onTime7").value = msg.data.ontime.t7;
      document.getElementById("offTime7").value = msg.data.offtime.t7;
      document.getElementById("dailySwitch7").checked = msg.data.repeate.t7 | 0;
    }
    else
    {
      document.getElementById("onTime7").value = "";
      document.getElementById("offTime7").value = "";
      document.getElementById("dailySwitch7").checked = false;
    }
    if(msg.data.ontime.t8.indexOf("None") < 0){
      document.getElementById("onTime8").value = msg.data.ontime.t8;
      document.getElementById("offTime8").value = msg.data.offtime.t8;
      document.getElementById("dailySwitch8").checked = msg.data.repeate.t8 | 0;
    }
    else
    {
      document.getElementById("onTime8").value = "";
      document.getElementById("offTime8").value = "";
      document.getElementById("dailySwitch1").checked = false;
    }
    
  }

  else if(msg.type === "respGetDeviceNames"){
    try
    {
    document.getElementById("d1").value = msg.data.deviceNames.d1;      // control page textboxes [device_names]
    document.getElementById("d2").value = msg.data.deviceNames.d2;
    document.getElementById("d3").value = msg.data.deviceNames.d3;
    document.getElementById("d4").value = msg.data.deviceNames.d4;
    document.getElementById("d5").value = msg.data.deviceNames.d5;
    document.getElementById("d6").value = msg.data.deviceNames.d6;
    document.getElementById("d7").value = msg.data.deviceNames.d7;
    document.getElementById("d8").value = msg.data.deviceNames.d8;
    }
    catch(err){
      document.getElementById("pdn1").innerHTML = msg.data.deviceNames.d1;  // for profile config page.
      document.getElementById("pdn2").innerHTML = msg.data.deviceNames.d2;
      document.getElementById("pdn3").innerHTML = msg.data.deviceNames.d3;
      document.getElementById("pdn4").innerHTML = msg.data.deviceNames.d4;
      document.getElementById("pdn5").innerHTML = msg.data.deviceNames.d5;
      document.getElementById("pdn6").innerHTML = msg.data.deviceNames.d6;
      document.getElementById("pdn7").innerHTML = msg.data.deviceNames.d7;
      document.getElementById("pdn8").innerHTML = msg.data.deviceNames.d8;

    }
  }

  else if(msg.type === "respGetProfileNames"){
    document.getElementById("showProf1").innerHTML = msg.data.p1;
    document.getElementById("showProf2").innerHTML = msg.data.p2;
    document.getElementById("showProf3").innerHTML = msg.data.p3;
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

  else if(msg.type === "respGetProfile"){
    document.getElementById("profileTxt").value = msg.data.name;
    document.getElementById("pds1").checked = msg.data.deviceValues.d1 | 0;
    document.getElementById("pds2").checked = msg.data.deviceValues.d2 | 0;
    document.getElementById("pds3").checked = msg.data.deviceValues.d3 | 0;
    document.getElementById("pds4").checked = msg.data.deviceValues.d4 | 0;
    document.getElementById("pds5").checked = msg.data.deviceValues.d5 | 0;;
    document.getElementById("pds6").checked = msg.data.deviceValues.d6 | 0;;
    document.getElementById("pds7").checked = msg.data.deviceValues.d7 | 0;;
    document.getElementById("pds8").checked = msg.data.deviceValues.d8 | 0;;
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
  try{
  document.getElementById("navbarTitle").innerHTML = ROOM_NAMES[ROOM - 1];
  }
  catch(err){

  }

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
  setTimeout(getProfileNames, 200, ROOM);
  setTimeout(getTimers, 300, ROOM);

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
      try{
      var id = "r" + i.toString();
      document.getElementById(id).value = ROOM_NAMES[i-1];
      var checkboxName = "room" + i.toString();
      document.getElementById(checkboxName).checked = true;
      var id2 = "pr" + i.toString();
      document.getElementById(id2).text = ROOM_NAMES[i-1];
      document.getElementById("profileRoom").options[i].disabled = false;
      $(document).ready(function() {
         $('select').material_select();
      });
    }
      catch(err){
        //var id = "pdn" + i.toString();
        //document.getElementById(id).innerHTML = ROOM_NAMES[i-1];
      }
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
      if(document.getElementById("dailySwitch" + device).checked)   // checked for daily/repeate
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

$(document).ready(function() {
    $('select').material_select();
  });


function setProfile(){
  var profRoom = document.getElementById("profileRoom").value;
  var profName = document.getElementById("profileName").value;
  var profNameString = document.getElementById("profileTxt").value;

  if(profRoom == 0 || profName == 0){
    $('#profileErrorModal').openModal();
  }
  if(profNameString == null){
    profNameString = ' ';
  }
  else{
    var jsonData = JSON.stringify({                               // TO-DO : implement profile set in python
      "name":"webapp",
      "type":"profile",
      "data":
      {
        "room":profRoom,
        "profile":profName,
        "profileTxt":profNameString,
        "deviceValues":
        {
          "d1":document.getElementById("pds1").checked | 0,
          "d2":document.getElementById("pds2").checked | 0,
          "d3":document.getElementById("pds3").checked | 0,
          "d4":document.getElementById("pds4").checked | 0,
          "d5":document.getElementById("pds5").checked | 0,
          "d6":document.getElementById("pds6").checked | 0,
          "d7":document.getElementById("pds7").checked | 0,
          "d8":document.getElementById("pds8").checked | 0
        }
      }
    });
    ws.send(jsonData);
    Materialize.toast('Profile updated!',2000);
  }
}

function getProfile(){
  var jsonData = JSON.stringify({
    "name":"webapp",
    "type":"getDeviceNames",
    "data":
    {
      "room":document.getElementById("profileRoom").value
    }
  });
  ws.send(jsonData); 
  setTimeout(getProfileFromDatabase, 200);
}

function getProfileFromDatabase(room_no){
  var jsonData = JSON.stringify({
      "name":"webapp",
      "type":"getProfile",
      "data":
        {
          "room":document.getElementById("profileRoom").value,
          "profileName":document.getElementById("profileName").value
        }
  });
  ws.send(jsonData);
}

function getProfileNames(room){
  var jsonData = JSON.stringify({
    "name":"webapp",
    "type":"getProfileNames",
    "data":
    {
      "room":room
    }
  });
  ws.send(jsonData);
}

function applyProfile(val){
  var jsonData = JSON.stringify({
    "name":"webapp",
    "type":"applyProfile",
    "data":
    {
      "room":ROOM,
      "profile":val
    }
  });
  ws.send(jsonData);
}

function getTimers(room){
  var jsonData = JSON.stringify(
    {
    "name":"webapp",
    "type":"getTimers",
    "data":
    {
      "room":room
    }
  });
  ws.send(jsonData);
}