import controlP5.*;
import processing.net.*;

Client myClient;
ControlP5 cp5;

int arduino_port = 5200;
String arduino_ip = "192.168.4.1";

int leftMotorSpeed = 0;
int rightMotorSpeed = 0;
int obstacleDistance = 0;

void setup() {
  size(500, 500);
  setupClient();
  cp5 = new ControlP5(this);

  cp5.addTextfield("Left Motor")
    .setPosition(20, 40)
    .setSize(100, 20)
    .setAutoClear(false);

  cp5.addTextfield("Right Motor")
    .setPosition(20, 80)
    .setSize(100, 20)
    .setAutoClear(false);

  cp5.addTextfield("Obstacle Distance")
    .setPosition(20, 120)
    .setSize(100, 20)
    .setAutoClear(false);

  cp5.addButton("startStopButton")
    .setPosition(300, 40)
    .setSize(150, 50)
    .setLabel("Start / Stop");
}

void draw() {
  background(100);

  updateSensorData();
  cp5.get(Textfield.class, "Left Motor").setValue(String.valueOf(leftMotorSpeed));
  cp5.get(Textfield.class, "Right Motor").setValue(String.valueOf(rightMotorSpeed));
  cp5.get(Textfield.class, "Obstacle Distance").setValue(String.valueOf(obstacleDistance));
  delay(1000);
}

void setupClient() {
  myClient = new Client(this, arduino_ip, arduino_port);
}

void updateSensorData() {
  if (myClient.available() > 0) {
    String data = readClient();
    String[] values = data.split(","); 
    String[] ls = values[0].split(":");
    String[] rs = values[1].split(":");
    String[] d = values[2].split(":");
    
    int left_speed = int(ls[1]);
    int right_speed = int(rs[1]);
    int distance = int(d[1]);
    
    leftMotorSpeed = left_speed;
    rightMotorSpeed = right_speed;
    obstacleDistance = distance;
  }
}

void startStopButton() {
  print("Start / Stop button pressed!");
}

String readClient() {
  String data = myClient.readString();
  return data;
}
