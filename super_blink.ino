# Pedro Ferreira 1320981
# Lucas Pinheiro 1611079

#define KEY1 A1
#define KEY2 A2
#define KEY3 A3
#define LED_PIN 13


unsigned int led_delay = 1000;
unsigned int last_delay = 500;
unsigned int last_press = -500;
unsigned int last = 0;
int state = 1;

int buttonOnePressed = 10000;
int buttonTwoPressed = 20000;

void setup() {
  pinMode(LED_PIN, OUTPUT);
  pinMode(KEY1, INPUT_PULLUP);
  pinMode(KEY2, INPUT_PULLUP);
  pinMode(KEY3, INPUT_PULLUP);

  Serial.begin(9600);
}

void loop() {
  int start = millis();
  
  if(start - last >= led_delay)
  {
    state = !state;
    digitalWrite(LED_PIN, state); 
    last = start;
  }

   if(!digitalRead(KEY1))
    {
      buttonOnePressed = start;   
    }
    
    if(!digitalRead(KEY2))
    {
      buttonTwoPressed = start;   
    }
  

  if (abs(buttonOnePressed - buttonTwoPressed) < 500)
  {
    
    digitalWrite(LED_PIN, HIGH);
    while(1);
  }
  else if(start - last_press >= last_delay)
  {
    if(!digitalRead(KEY1))
    {
      led_delay *= 2;      
    }
    if(!digitalRead(KEY2))
    {
      led_delay /= 2; 
    }
    last_press = start;
  }
 

}
