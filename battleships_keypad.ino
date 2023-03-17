#include <Keypad.h>

int temp_x;
int temp_y;
int sent_x;
int sent_y;

int numbers_count = 0;
bool done = false;

const uint8_t ROWS = 4;
const uint8_t COLS = 4;
char keys[ROWS][COLS] = {
  { '1', '2', '3', 'A' },
  { '4', '5', '6', 'B' },
  { '7', '8', '9', 'C' },
  { '*', '0', '#', 'D' }
};

uint8_t colPins[COLS] = { 5, 4, 3, 2 }; // Pins connected to C1, C2, C3, C4
uint8_t rowPins[ROWS] = { 9, 8, 7, 6 }; // Pins connected to R1, R2, R3, R4

Keypad keypad = Keypad(makeKeymap(keys), rowPins, colPins, ROWS, COLS);

void setup() {
  Serial.begin(9600);
}

String concat(int x, int y){
    char str1[20];
    char str2[20];

    sprintf(str1,"%d",x);
    sprintf(str2,"%d",y);

    strcat(str1,",");
    strcat(str1, str2);

    return str1;
}

int decode(char c) {
    switch(c) {
      case '1' : return 1;
      case '2' : return 2;
      case '3' : return 3;
      case '4' : return 4;
      case '5' : return 5;
      case '6' : return 6;
      case '7' : return 7;
      case '8' : return 8;
      case '9' : return 9;
      case '*' : return 0;
    }
}


void loop() {
  
    char key = keypad.getKey();

    if(key != NO_KEY) {
      //Serial.println(key);

      if(key == '1' || key == '2' || key == '3' || key == '4' || key == '5' || key == '6' || key == '7' || key == '8' || key == '9' || key == '*') { //daca sunt numerele sau * care e 0

        if(key=='1' || key=='2' || key=='3' || key=='4' || key=='*'){
          if(numbers_count == 0) {
            temp_x = decode(key);
            //Serial.println(temp_x);
            numbers_count++;
          }
          else {
            if (numbers_count == 1) {
            temp_y = decode(key);
            //Serial.println(temp_y);
            numbers_count++;
            }   
          }   
        }
        else {
          Serial.println('B');
        }

        
      }
      else {   //caracterele
        if(key == 'D') {
          if(numbers_count == 2) {
            Serial.println(concat(temp_x, temp_y));
            numbers_count = 0;
            //done = true;
          }
          else {
            if(numbers_count==0) {
              Serial.println('X');
            }
            else {
              if (numbers_count==1) {
                Serial.println('X');
              }
            }
          }
        }
        else {
          if(key=='0') {
              Serial.println('R');
              temp_x = 0;
              temp_y = 0;
              numbers_count = 0;
          }
          else {
            if(key=='#'){
              Serial.println('E');
            }
            else{
              //if((numbers_count==0 || numbers_count==1) && (key=='A' || key=='B' || key=='C'){
                Serial.println('C');
              //}
            }
            

          }
        }  
      
        
    }
  }    
}
  
