import controlP5.*;
import processing.net.*;

ControlP5 cp5;
Toggle startStopToggle;
Slider speedslider;
Client myClient;
Button Switch;
Button confirm;

int leftMotorSpeed = 0;
int rightMotorSpeed = 0;
int distanceTravelled = 0;
int obstacleDistance = 0;
float sspeed=0.0;
int manualspeed=0;

float currentSpeed = 0.0;
float referenceSpeed = (leftMotorSpeed+rightMotorSpeed)/2;
float distanceOfObject = 0.0;
int arduino_port = 5200;
String arduino_ip = "192.168.4.1";
String send = "0";  // Initial value
String check= "0";
String mode= "0";

boolean manualControl = true;

void setup() {
  size(1500, 750);
  background(#B8E6FA);
  cp5 = new ControlP5(this);
   //setupClient();

  // Start/Stop Button
  startStopToggle = cp5.addToggle("")
    .setPosition(width - 500, 150)
    .setSize(400, 200)
    .setLabel("Start")
    .setColorBackground(color(150));


  // Manual Control
  cp5.addTextlabel("ManualLabel")
    .setPosition(80, height / 2 + 30)
    .setColorValue(0);

  speedslider= cp5.addSlider("SliderValue")
    .setPosition(100, height / 2 + 170)
    .setSize(500, 20)
    .setRange(0, 100)
    .setValue(0);

  // Confirm Button
  cp5.addButton("ConfirmButton")
    .setPosition(300, height / 2 + 255)
    .setSize(100, 40)
    .setLabel("Confirm")
    .setColorBackground(color(0, 255, 0))
    .setValue(0);


  // Switch Button
  Switch= cp5.addButton("SwitchButton")
    .setPosition(width/2-75, height / 2 + 150)
    .setSize(150, 80)
    .setLabel("Switch Mode")
    .setColorBackground(color(0, 0, 255))
    .setValue(0);
}

void controlEvent(ControlEvent theEvent) {
  if (theEvent.isFrom(startStopToggle)) {
    send = startStopToggle.getValue() == 1 ? "1" : "0";
    int stringSpeed = (int) sspeed;
    String sentence = answers(send, stringSpeed);
    //myClient.write(sentence);
    println(sentence);
    if (send == "1")
      startStopToggle.setLabel("Start");
    else
      startStopToggle.setLabel("Stop");
  }

  //if (send=="1"){
  if (theEvent.isFrom(Switch)) {
    if (mode.equals("0")) {
      mode = "4"; // Switch to reference mode
      lockManualControls(true);// Lock manual controls
      manualspeed= (int)sspeed;
    } else {
      mode = "0"; // Switch to manual mode
      lockManualControls(false);
      sspeed= manualspeed;// Unlock manual controls
    }
    send = startStopToggle.getValue() == 1 ? "1" : "0";
    int stringSpeed = (int) sspeed;
    String sentence = answers(send, stringSpeed);
    // myClient.write(sentence);
    println(sentence);
  }


  if (theEvent.isFrom(speedslider)) {
    // Speed slider value changed
    currentSpeed = speedslider.getValue();
  }
  if (theEvent.isFrom("ConfirmButton")) {
    // Confirm button pressed, update sspeed
    sspeed = currentSpeed;
    currentSpeed = speedslider.getValue();
    send = startStopToggle.getValue() == 1 ? "1" : "0";
    int stringSpeed = (int) sspeed;
    String sentence = answers(send, stringSpeed);
  //  myClient.write(sentence);
    println(sentence);
  }
}
// }
//else
//{
//  send = startStopToggle.getValue() == 1 ? "1" : "0";
//  String stringSpeed = "0.0";
//  String sentence = answers(send, stringSpeed);
//  println(sentence);
//}






void setupClient() {
  myClient = new Client(this, arduino_ip, arduino_port);
}

void draw() {
  background(#B8E6FA);
  //updateSensorData();
  //String stringSpeed = Float.toString(sspeed);
  //String sentence= answers(send, stringSpeed);
  //println(sentence);
  //myClient.write(sentence);
  //myClient.clear();

  fill(0);
  textSize(80);
  textAlign(CENTER, CENTER);
  text("Spud Control Panel", width / 2, 30);

  textSize(48);
  text("SPEED CONTROL", width/2, height/2+30);

  textSize(40);
  text("Start/Stop", width-305, 120);
  text("Manual Control", 350, height/2+90);
  text("Reference Object Control", width-350, height/2+90);

  textSize(36);
  text("Left Motor Speed:  " + leftMotorSpeed, 300, 120);
  text("Right Motor Speed:  " + rightMotorSpeed, 310, 160);
  text("Distance travelled: " +distanceTravelled, 300, 200);
  text("Obstacle Distance(in cm):  " + obstacleDistance, 300, 280);
  if (obstacleDistance<15)
  {
    text("Obstacles detected!", 310, 320);
  } else
  {
    text("Path clear!", 310, 320);
  }


  if (mouseX>100&& mouseX< 500 && mouseY> height/2+30 && mouseY<height/2 +330)
  {
    noFill();  // Disable filling
    stroke(0); // Set outline color to black
    rect(100, 430, 500, 250);
  }

  if (mouseX>900 && mouseX< width-100 && mouseY >height/2+30 && mouseY <height/2+300)
  {
    noFill();  // Disable filling
    stroke(0); // Set outline color to black
    rect(900, 430, 500, 250);
  }


  textSize(32);
  currentSpeed= speedslider.getValue();
  text("CURRENT SPEED (in cm/s): " +  (int)currentSpeed, 350, height/2+ 220);
  text("CURRENT REFERENCE SPEED:  " + (int)referenceSpeed, width- 350, height/2+200);
  text("DISTANCE OF OBJECT: "+ obstacleDistance + " cm", width-350, height/2+240);

  textSize(20);
  text("MIN", 60, height/2 +170);
  text("MAX", 630, height/2 +170);
  text("0", 60, height/2+190);
  text("100 ", 630, height/2+190);

  // Draw line in the middle
  stroke(5);
  line(0, height / 2, width, height / 2);
  line(width/2, height/2+60, width/2, height);
}

void lockManualControls(boolean lock) {
  speedslider.setLock(lock);
 // confirm.setLock(lock);
  sspeed= 0.0;
}

void updateSensorData() {
  if (myClient.available() > 0) {
    String data = myClient.readString();
    String[] values = data.split(",");
    if (values.length >= 4) {
      String[] ls = values[0].split(":");
      String[] rs = values[1].split(":");
      String[] d = values[2].split(":");
      String[] t = values[3].split(":");
      leftMotorSpeed = int(ls[1]);
      rightMotorSpeed = int(rs[1]);
      obstacleDistance = int(d[1]);
      distanceTravelled = int(t[1].trim());
    }
  }
}

String answers(String send, int sspeed)
{
  String sentence= "B:" + send + ",M:"+ mode + ",S:" + sspeed ;
  return sentence;
}




void ConfirmButton(int theValue) {
  // Confirm button logic here
  sspeed = currentSpeed;
  //println("Confirm Button Pressed");
}

//void SwitchButton(int theValue) {
//  // Switch button logic here
// // println("Switch Button Pressed");
//}

void SliderValue(float theValue) {
  // Slider value logic here
  currentSpeed = theValue;
}
