import processing.net.*;

Client myClient;

int arduino_port = 5200;
String arduino_ip = "192.168.43.124";

void setup() {
  size(500,500);
  // setupClient();
}

void draw() {
  background(255);
  delay(1000);
}

void setupClient() {
  myClient = new Client(this, arduino_ip, arduino_port);
}

String readClient() {
  String data = myClient.readString();
  return data;
}
