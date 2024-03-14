
import processing.net.*;
import controlP5.*;

Client myClient;
ControlP5 cp5;
Toggle startStopToggle;


int arduino_port = 5200;
String arduino_ip = "192.168.4.1";
String send = "0";  // Initial value

int leftMotorSpeed = 0;
int rightMotorSpeed = 0;
int obstacleDistance = 0;
int distancetravelled= 0;

void setup() {
  size(1000, 1000);
  cp5 = new ControlP5(this);
  //setupClient();

  startStopToggle = cp5.addToggle("")
                       .setPosition(350, 650)
                       .setSize(300, 300)
                       .setColorActive(color(255, 0, 0))
                       .setColorBackground(color(150))
                       .setValue(0);

 
}

void controlEvent(ControlEvent theEvent) {
  if (theEvent.isFrom(startStopToggle)) {
    send = startStopToggle.getValue() == 1 ? "1" : "0";
    //myClient.write(send);
    if (send == "1")
      startStopToggle.setLabel("Start");
    else
      startStopToggle.setLabel("Stop");
  }
}

void draw() {
  background(#FF6D00);
  //updateSensorData();
  println(send);

  float textScale = min(width, height) / 500.0;
  textSize(40 * textScale);

  textAlign(CENTER, CENTER);
  rectMode(CENTER);
  fill(#D84315);
  rect(width/2, 100, width/2, 100);
  rect(width/2, height/6, width, height/150);
  rect(width/2, height/3.5, width, height/150);

  fill(255);
  text("SpudArduino", width/2, 100);
  textSize(30 * textScale);
  text("Left Motor Speed(in m/s): " + leftMotorSpeed, width/2, height/5);
  text("Right Motor Speed(in m/s): " + rightMotorSpeed, width/2, height/4);
  text("Obstacle Distance(in cm): " + obstacleDistance, width/2, 350);
  if (obstacleDistance<15)
{ text("Obstacles detected!", width/2, 400);}
 else
 {text("Path clear!", width/2, 400);}
 text("Distance travelled (in m):" +distancetravelled, width/2, 500); 
 text("The start and stop toggle", width/2, 580);
 textSize(15*textScale);
 text("Red means start while grey means stop.", width/2,625);

}

void setupClient() {
  myClient = new Client(this, arduino_ip, arduino_port);
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
      distancetravelled = int(t[1].trim());
    }
  }
}
