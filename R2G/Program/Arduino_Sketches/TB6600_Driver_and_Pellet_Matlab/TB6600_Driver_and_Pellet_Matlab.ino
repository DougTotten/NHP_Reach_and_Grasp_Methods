//Arduino Sketch based on easy driver
//Added pin-out for activating pellet dispenser
//Responds to two-line serial input. 
//First line indicates whether to operate pellet dispenser, turn motor, or release motor
//Second line tells how far to spin motor


int enable = 5;
int dirpin = 7;
int steppin = 10;

int s_in1 = 0;
int s_in2 = 0;

int move_steps = 0;

int pelletPin1 = 3;

int i;

void setup()
{
  Serial.setTimeout(10); //this will make the Arduino wait a max of only 10ms per incoming set of serial data, before moving on

  pinMode(dirpin, OUTPUT);
  pinMode(steppin, OUTPUT);
  pinMode (enable, OUTPUT);
  pinMode (pelletPin1, OUTPUT);

  digitalWrite(enable, HIGH); // HIGH is actually released
  digitalWrite(dirpin, HIGH);

  while (!Serial);        // needed to keep leonardo/micro from starting too fast!

  Serial.begin(9600);
  establishContact();  // send a byte to establish contact until receiver responds
  Serial.println("Successfully connected");

}

void loop()
{

  if (Serial.available() != 0) {
    //delay (1000); // wait to make sure you get full command

    // Read the input and then clear it
    s_in1 = Serial.parseInt();
    s_in2 = Serial.parseInt();
    while (Serial.available() != 0) {
      Serial.read();
    }

    // Control Pellet Dispensor
    if (s_in1 == 1) {
      Serial.println ("Pellet control");

      digitalWrite (pelletPin1, HIGH);
      delay (10);
      digitalWrite (pelletPin1, LOW);


      Serial.println("finished");

    }

    else if (s_in1 == 2) { // Control motor
      Serial.print ("Control motor state: ");
      Serial.print ("Moving motor ");
      Serial.print (s_in2);
      Serial.println (" steps");

      move_steps = s_in2;
      digitalWrite (enable, LOW);
      //delay (100);

      for (i = 0; i < move_steps; i++)
      {
        digitalWrite(steppin, LOW); // This LOW to HIGH change is what creates the
        delayMicroseconds(950);
        digitalWrite(steppin, HIGH);
        delayMicroseconds(50); //
      }
      //digitalWrite (enable, HIGH);

      Serial.println("finished");

    }

    else if (s_in1 == 3) { // Disengage motor
      Serial.println ("Disengaging motor");
      digitalWrite(enable, HIGH);
    }

    else { // Invalid input
      Serial.println ("Invalid input");
      Serial.println ("Not 1 or 2");
    }
  }

}


void establishContact() {
  int flipper = 0;

  Serial.println("Stepper and Pellet Control: Waiting for serial port input");

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

