/*********************************************************
  This is a library for the MPR121 12-channel Capacitive touch sensor

  Designed specifically to work with the MPR121 Breakout in the Adafruit shop
  ----> https://www.adafruit.com/products/

  These sensors use I2C communicate, at least 2 pins are required
  to interface

  Adafruit invests time and resources providing this open source code,
  please support Adafruit and open-source hardware by purchasing
  products from Adafruit!

  Written by Limor Fried/Ladyada for Adafruit Industries.
  BSD license, all text above must be included in any redistribution

  NOTE This arduino is COM5
**********************************************************/

#include <Wire.h>
#include "Adafruit_MPR121.h"

// You can have up to 4 on one i2c bus but one is enough for testing!
Adafruit_MPR121 cap = Adafruit_MPR121();

// Keeps track of the last pins touched
// so we know when buttons are 'released'
uint16_t lasttouched = 0;
uint16_t currtouched = 0;
int flipper = 0;

int s_in1 = 0;
int s_in2 = 0;

int ledPin1 = 4;
int ledPin2 = 5;
int ledPin3 = 6;
int ledPin4 = 7;
int ledPin5 = 8;
int ledPin6 = 9;

///////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////

void setup() {
  
  Serial.setTimeout(5); //this will make the Arduino wait a max of only 5ms per incoming set of serial data, before moving on

  while (!Serial);        // needed to keep leonardo/micro from starting too fast!

  Serial.begin(9600);

  pinMode (ledPin1,OUTPUT);
  pinMode (ledPin2,OUTPUT);
  pinMode (ledPin3,OUTPUT);
  pinMode (ledPin4,OUTPUT);
  pinMode (ledPin5,OUTPUT);
  pinMode (ledPin6,OUTPUT);

  // This will wait for the matlab connection before running the script

  pinMode(LED_BUILTIN, OUTPUT);
  digitalWrite(LED_BUILTIN, LOW);
  establishContact();  // send a byte to establish contact until receiver responds

  Serial.println("Checking MPR121 Capacitive Touch sensor connection");

  // Default address is 0x5A, if tied to 3.3V its 0x5B
  // If tied to SDA its 0x5C and if SCL then 0x5D
  if (!cap.begin(0x5A)) {
    Serial.println("MPR121 not found, check wiring?");
    while (1);
  }
  Serial.println("MPR121 found!");
}

///////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////

void loop() {

  if (Serial.available() != 0) {

    // Read the input and then clear it
    s_in1 = Serial.parseInt();
    s_in2 = Serial.parseInt();
    while (Serial.available() != 0) {
      Serial.read();
    }

// Control LEDs
    if (s_in1 == 1) {
      Serial.print ("LED Control:  ");
      
      int ledState1 = bitRead(s_in2, 0);
      int ledState2 = bitRead(s_in2, 1);
      int ledState3 = bitRead(s_in2, 2);
      int ledState4 = bitRead(s_in2, 3);
      int ledState5 = bitRead(s_in2, 4);
      int ledState6 = bitRead(s_in2, 5);
      Serial.println(ledState6);
      
      digitalWrite (ledPin1,ledState1);
      digitalWrite (ledPin2,ledState2);
      digitalWrite (ledPin3,ledState3);
      digitalWrite (ledPin4,ledState4);
      digitalWrite (ledPin5,ledState5);
      digitalWrite (ledPin6,ledState6);

      Serial.println(" finished");
      
    }

    else if (s_in1 == 2) { // read from touch pads
    // Get the currently touched pads
    currtouched = cap.touched();
    Serial.println(currtouched);
    }

  }

}

void establishContact() {
  int flipper = 0;

  Serial.println ("Waiting for serial input");

  while (Serial.available() <= 0) {

    delay(300);

    if (flipper == 1) {
      digitalWrite(LED_BUILTIN, HIGH);
      flipper = 0;
    }
    else {
      digitalWrite(LED_BUILTIN, LOW);
      flipper = 1;
    }
  }

  // This will read until the buffer is clear
  while (Serial.available() != 0) {
    Serial.read();
  }

}

