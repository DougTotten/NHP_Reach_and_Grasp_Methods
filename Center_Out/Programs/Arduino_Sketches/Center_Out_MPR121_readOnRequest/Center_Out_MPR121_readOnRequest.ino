/*********************************************************
 * 
  MODIFIED FUNCTIONALITY -- DJT
  this sketch controls all the LEDs and sends a digital output to the TDT rig. 
  It only does anything when receiving serial-inputs

  SIn1 = 1 ... Control lights. Then SIn2 tells you how to set the state of each light

  SIn1 = 2 ... Return cap sensor value to Serial out

  Sin1 = 3 ... Indicate trial start
  
  the digital out pulses three times when the red trial indicator light turns on, 
  and then again right after it turns off. 
  Besides that the digital out goes hi/low depending on cap-sensor state

  
  FROM ORIGINAL ARDUINO FILE -------------------
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
**********************************************************/

/*******************************************************
   DJT Mods
   To get the capacitive sensor readings here the Arduino needs to receive an odd-valued serial input
 ******************************************************/

#include <Wire.h>
#include "Adafruit_MPR121.h"

// You can have up to 4 on one i2c bus but one is enough for testing!
Adafruit_MPR121 cap = Adafruit_MPR121();

// Keeps track of the last pins touched
// so we know when buttons are 'released'
uint16_t lasttouched = 0;
uint16_t currtouched = 0;
int flipper = 0;
int s_in1;
int s_in2;

int capChan = 2;
float myThresh = 1.5; // 2 means that filtered data has to drop to 50% baseline data
// 1.5 means it has to drop to 66% of baseline

// window lights
int ledPin1 = 3; // top
int ledPin2 = 4; // right 
int ledPin3 = 5; // bottom
int ledPin4 = 6; // left

// trial coding lights
int ledGreen = 7; // green
int ledRed = 8; // red
int ledYellow = 9; // yellow

// These are useful for debugging, but not necessary for task
int ledPin9 = 11; // trial active light
int ledPin10 = 12; // pad touched light

// TDT pin goes out to a digital input in TDT
// It activates during trial indicator period and with cap-sense contact
int TDTpin = 10;


int ledState1 = 0;
int ledState2 = 0;
int ledState3 = 0;
int ledState4 = 0;
int ledState5 = 0;
int ledState6 = 0;
int ledState7 = 0;
int ledState8 = 0;
int ledState9 = 0;
int ledState10 = 0;

// Used to manually control sensitivity of touch sensor
float chan_fD = 0;
float chan_bD = 0;
float chan_ratio = 0;
int touched = 0;



void setup() {
  Serial.setTimeout(10); //this will make the Arduino wait a max of only 10ms per incoming set of serial data, before moving on

  while (!Serial);        // needed to keep leonardo/micro from starting too fast!

  Serial.begin(9600);

  // This will wait for the matlab connection before running the script

  pinMode(LED_BUILTIN, OUTPUT);
  pinMode(ledPin1, OUTPUT);
  pinMode(ledPin2, OUTPUT);
  pinMode(ledPin3, OUTPUT);
  pinMode(ledPin4, OUTPUT);
  pinMode(ledGreen, OUTPUT);
  pinMode(ledRed, OUTPUT);
  pinMode(ledYellow, OUTPUT);
  pinMode (TDTpin,OUTPUT);
  pinMode(ledPin9, OUTPUT);
  pinMode(ledPin10, OUTPUT);
  

  digitalWrite(LED_BUILTIN, LOW);
  establishContact();  // send a byte to establish contact until receiver responds
  Serial.println("Serial connection established");

  // Print name of sketch that is loaded
  Serial.println ("Center_Out_MPR121");

  Serial.println("Checking MPR121 Capacitive Touch sensor connection");

  // Default address is 0x5A, if tied to 3.3V its 0x5B
  // If tied to SDA its 0x5C and if SCL then 0x5D
  if (!cap.begin(0x5A)) {
    Serial.println("MPR121 not found, check wiring?");
    while (1);
  }
  Serial.println("MPR121 found!");

// Establish baseline if you want to hold it constant
  chan_bD=0;
  for (int i=0; i<100; i++){
    chan_bD=chan_bD+.01*cap.baselineData(capChan); 
    delay(10); // wait 10 ms
  }

}

/////////////////////////////////////////////
/////////////////////////////////////////////
/////////////////////////////////////////////


void loop() {

  ////////////// Touch Sensor Coding ///////////////////
  chan_fD = cap.filteredData(capChan);
  // chan_bD = cap.baselineData(capChan); // use this for updating baseline
  chan_ratio = chan_bD / chan_fD;

  //analogWrite(TDTpin,chan_ratio);
  
  /*
    Serial.println("");
    Serial.print("\t");
    Serial.print(chan_fD);
    Serial.print("\t");
    Serial.print(chan_bD);
    Serial.print("\t");
    Serial.print(chan_ratio);
  */

  if (chan_ratio > myThresh) {
    ledState10 = 1;
    touched = 4;
    digitalWrite(TDTpin,1);
  }
  else {
    ledState10 = 0;
    touched = 0;
    digitalWrite(TDTpin,0);
  }

/*
    // this would allow you to read the filtered capacitance values
    Serial.print("Filt: ");
    for (uint8_t i = 0; i < 12; i++) {
    Serial.print(cap.filteredData(i)); Serial.print("\t");
    }
    Serial.println();

    // this would allow you to read the baseline capacitance values
    Serial.print("Base: ");
    for (uint8_t i = 0; i < 12; i++) {
    Serial.print(cap.baselineData(i)); Serial.print("\t");
    }
    Serial.println();


    if (cap.touched() > 0) {
    Serial.println("Touched");

    }

    Serial.println();

    delay (250);
    */

    ////////////////////////////////////////////////////////////////
  

  /* Read using cap.touched values instead of my manually calculated values
    if (cap.touched() > 0) {
      ledState10=1;

    }
    else {
      ledState10=0;
    }
  */

  digitalWrite (ledPin10, ledState10);

  ////////// ////////////// ////////////////
  ////////// Respond to Inputs /////////////
  ////////// ////////////// ////////////////

  if (Serial.available() != 0) {
    s_in1 = Serial.parseInt();
    s_in2 = Serial.parseInt();

    // This will read until the buffer is clear
    while (Serial.available() != 0) {
      Serial.read();
    }

    //////////// Read Capacitive Touch Sensor
    if (s_in1 == 1) {

      //Serial.println(cap.touched(),DEC);
      Serial.println(touched, DEC);
    }

    /////////// Adjust Lights ///////////////
    else if (s_in1 == 2) { // if the first input is 2, adjust the lights
      Serial.println("Controlling lights");
      ledState1 = bitRead(s_in2, 0);
      ledState2 = bitRead(s_in2, 1);
      ledState3 = bitRead(s_in2, 2);
      ledState4 = bitRead(s_in2, 3);
      ledState5 = bitRead(s_in2, 4);
      ledState6 = bitRead(s_in2, 5);
      ledState7 = bitRead(s_in2, 6);
      ledState8 = bitRead(s_in2, 7);
      ledState9 = bitRead(s_in2, 8);

      digitalWrite (ledPin1, ledState1);
      digitalWrite (ledPin2, ledState2);
      digitalWrite (ledPin3, ledState3);
      digitalWrite (ledPin4, ledState4);
      digitalWrite (ledGreen, ledState5);
      digitalWrite (ledRed, ledState6);
      digitalWrite (ledYellow, ledState7);
      digitalWrite (ledPin9, ledState9);

    }

//////////// TRIAL INDICATOR LIGHTS /////////////////
    else if (s_in1 == 3) {
      Serial.println ("Controlling trial-indicator lights");
      digitalWrite (ledRed, 1);
      
      // indicate start trial coding block
      digitalWrite (TDTpin,0);
      delay (2);
      digitalWrite (TDTpin,1);
      delay (2);
      digitalWrite (TDTpin,0);
      delay (2);
      digitalWrite (TDTpin,1);
      delay (2);
      digitalWrite (TDTpin,0);
      delay (2);
      digitalWrite (TDTpin,1);
      delay (2);
      digitalWrite (TDTpin,0);
      delay (2);

      int i=0;
      while (i<8) {
        digitalWrite (ledGreen, 1);
        digitalWrite (ledYellow, bitRead(s_in2, i));
        digitalWrite (TDTpin,bitRead(s_in2,i));
        delay (20);
        digitalWrite (ledGreen, 0);
        digitalWrite (ledYellow, 0);
        digitalWrite (TDTpin,0);
        delay (40);

        i=i+1;

      }
      digitalWrite (ledRed,0);

      // indicate start trial coding block
      digitalWrite (TDTpin,0);
      delay (2);
      digitalWrite (TDTpin,1);
      delay (2);
      digitalWrite (TDTpin,0);
      delay (2);
      digitalWrite (TDTpin,1);
      delay (2);
      digitalWrite (TDTpin,0);
      delay (2);
      digitalWrite (TDTpin,1);
      delay (2);
      digitalWrite (TDTpin,0);
      delay (2);
    }

  }

}

/////////////////////////////////////////////
/////////////////////////////////////////////
/////////////////////////////////////////////

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

