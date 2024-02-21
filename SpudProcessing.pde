import processing.net.*;

Client myClient;

int arduino_port = 5200;
String arduino_ip = "192.168.4.1";

int leftMotorSpeed = 0;
int rightMotorSpeed = 0;
int obstacleDistance = 0;

boolean prevState = false;

void setup() {
  fullScreen();
  setupClient();
}

void draw() {
  isButtonPressed();
  background(#FF6D00);
  updateSensorData();

  float textScale = min(width, height) / 500.0f; // Scale based on smaller dimension
  textSize(40 * textScale);

  textAlign(CENTER, CENTER);
  rectMode(CENTER);
  fill(#D84315);
  rect(width/2, 0, width, height/6);
  rect(width/2, height/6, width, height/150);
  rect(width/2, height/3.5, width, height/150);
  if (!isButtonPressed()) {
    rect(width/2, height * 0.8, width/2, height/8);
  } else {
    fill(#FF5722);
    rect(width/2, height * 0.8, width/2, height/8);
  }
  fill(255);
  text("Start / Stop",  width/2, height * 0.8);
  text("SpudArduino", width/2, height/25);
  textSize(30 * textScale);
  text("Left Motor Speed: " + leftMotorSpeed, width/2, height/5);
  text("Right Motor Speed: " + rightMotorSpeed, width/2, height/4);
  text("Obstacle Distance: " + obstacleDistance, width/2, height/8);
}

void setupClient() {
  myClient = new Client(this, arduino_ip, arduino_port);
}

void updateSensorData() {
  if (myClient.available() > 0) {
    String data = myClient.readString();
    String[] values = data.split(","); 
    if (values.length >= 3) {
      String[] ls = values[0].split(":");
      String[] rs = values[1].split(":");
      String[] d = values[2].split(":");
      leftMotorSpeed = int(ls[1]);
      rightMotorSpeed = int(rs[1]);
      obstacleDistance = int(d[1].trim());
    }
    
    // println("Left Motor Speed: " + leftMotorSpeed);
    // println("Right Motor Speed: " + rightMotorSpeed);
    // println("Obstacle Distance: " + obstacleDistance);
  }
}

boolean isButtonPressed() {
  if (mouseX > ((width/2) - (width/4)) && mouseX <  ((width/2) + (width/4)) && mouseY > ((height * 0.8) - (height/8)/2) && mouseY < ((height * 0.8) + (height/8)/2) && mousePressed) {
    if (prevState != true) {
      println("hehe button pressed");
      myClient.write("button");
      prevState = true;
    }
    return true;
  } else {
    if (prevState == true) {
      prevState = false;
    }
    return false;
  }
}
