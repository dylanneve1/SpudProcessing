import processing.net.*;

Client myClient;
String data;

int arduino_port = 5200;
String arduino_ip = "192.168.43.124";

void setup() {
  size(500,500);
  myClient = new Client(this, arduino_ip, arduino_port);
}

void draw() {
  data = myClient.readString();
  if (data != null) {
    println(data);
  }
  delay(1000);
}
