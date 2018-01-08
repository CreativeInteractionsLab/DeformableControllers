import processing.serial.*;
import cc.arduino.*;
import org.firmata.*;

Arduino arduino;
int analogPinA0 = 0;
int a0 = 0;
int Vin = 5; //input voltage
float Vout = 0; //converted analog inpt to Arduino
float R1 = 0; //resistance of the flex/bend sensor
float R2 = 10000; //resistance of the known resistor

void setup()
{
  println(Arduino.list());
  //grab the first available Arduino board
  //when using the standard Firmata library, the baud rate is set to 57600
  arduino = new Arduino(this, Arduino.list()[1], 57600);

  size(512, 512);
  background(100);
}

void draw()
{
  background(100);
  //draw the bar
  stroke(255);
  noFill();//fill(100);
  rect(10, 240, 492, 24);
  
  a0 = arduino.analogRead(analogPinA0);
  if(a0 != 0) {
    Vout = AnalogInputToVotage(a0, Vin);
    R1 = AnalogInputToResistance(a0, Vin, R2);
    //draw the progress
    fill(255);
    rect(10, 240, 492*Vout/Vin, 24);
    println("Vout: "+Vout+" R1 (sensor): "+R1);
  }
}

float AnalogInputToVotage(int raw, int vin) {
  //the range of analog read is 0 and 1024, so scale it to 0 to Vin
  return raw * vin / 1024.0;
}

//connected like this: Vin -- R1(bend sensor) -- Vout(from analog input to Arduino) -- R2 -- GND
float AnalogInputToResistance(int raw, int vin, float r2) {
  return r2 * ( (vin / AnalogInputToVotage(raw, vin)) - 1);  
}