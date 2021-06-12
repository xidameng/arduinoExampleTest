/**************************************************************************
 Title: RULER_2077
 
 Items:
  * Ameba RTL8722DM               x1
  * SSD1306 OLED display          x1
  * Ultrasonic sensor             x1

 This example uses a 128x64 pixel display（Monochrome OLEDs based on SSD1306 drivers） 
 using SPI to communicate, 4 pins are required to interface. Ultrasonic sensor used 
 for distance measurement.

 Adafruit OLED library is used, thus credit to adafruit too. (library can be downloaded
 using Arduino IDE's library manager)

 Created by: Simon XI
 Date:       10/12/2020

 **************************************************************************/

#include <SPI.h>
#include <Wire.h>
#include <Adafruit_GFX.h>
#include <Adafruit_SSD1306.h>
#include <GTimer.h>


//SSD1306 OLED display setup
#define SCREEN_WIDTH 128 // OLED display width, in pixels
#define SCREEN_HEIGHT 64 // OLED display height, in pixels

// Only 4 pins are needed 
#define OLED_RESET 10  //(RES)
#define OLED_MOSI  11  //(SDA)
#define OLED_DC    12  //(DC)
#define OLED_CLK   13  //(SCL)
#define OLED_CS    17  //(Not Connected)

const int trigger_pin = 24;
const int echo_pin    = 25;

Adafruit_SSD1306 display(SCREEN_WIDTH, SCREEN_HEIGHT,
  OLED_MOSI, OLED_CLK, OLED_DC, OLED_RESET, OLED_CS);

char title[]    = "Dist:             ";


void setup() {
    Serial.begin(115200);
    pinMode(trigger_pin, OUTPUT);
    pinMode(echo_pin, INPUT);
    Wire.begin();

  // SSD1306_SWITCHCAPVCC = generate display voltage from 3.3V internally
  if(!display.begin(SSD1306_SWITCHCAPVCC)) {
    Serial.println(F("SSD1306 allocation failed"));
    for(;;); // Don't proceed, loop forever
  }
  
  delay(3000);
  
}

void loop() {
  
    float duration, distance;

    // trigger a 10us HIGH pulse at trigger pin
    digitalWrite(trigger_pin, HIGH);
    delayMicroseconds(10);
    digitalWrite(trigger_pin, LOW);

    // measure time cost of pulse HIGH at echo pin
    duration = pulseIn (echo_pin, HIGH);

    // calculate the distance from duration
    distance = duration / 58;

    Serial.print(distance);
    Serial.println(" cm");

    interface(distance);
    delay(1500);
}


void interface(float dist) {

  display.clearDisplay();
  display.setTextSize(1);             // Normal 1:1 pixel scale
  display.setTextColor(SSD1306_WHITE);        
  display.setCursor(0,0);             // Start at top-left corner
  display.println();
  display.println(title); 
 
  display.setTextSize(2);             // Normal 1:1 pixel scale
  display.setTextColor(SSD1306_WHITE);    
  display.println();
  display.println(dist);

  display.setTextSize(1); 
  display.println();
  display.println("         cm ");
   
  display.display();
}
