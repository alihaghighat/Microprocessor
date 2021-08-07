#include <io.h>
#include <delay.h>
#include <mlcd_portc.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>

int i;
char light_voltage[8];

void main(void) {
    // SPI initialization
    SPCR |= (1<<SPE); // SPI Enable
    SPCR |= (0<<CPOL); // SPI Clock Polarity: Low
    SPCR |= (0<<CPHA); // SPI Clock Phase: Leading edge sample / Trailing Edge setup
    SPCR |= (1<<SPR1) | (1<<SPR0); // SPI Clock Rate: f/128 = 62.5 KHz
    SPSR |= (0<<SPI2X);
    SPCR |= (0<<DORD); // SPI Data Order: MSB First
    SPCR |= (0<<MSTR); // SPI Type: Slave  
    
    
    DDRB.3 = 1;
    
    // Timer/Counter 0 initialization
    // Clock source: System Clock
    // Clock value: 31.250 kHz
    // Mode: Fast PWM top=0xFF
    // OC0 output: Non-Inverted PWM
    // Timer Period: 8.192 ms
    // Output Pulse(s):
    // OC0 Period: 8.192 ms Width: 0 us
    TCCR0=(1<<WGM00) | (1<<COM01) | (0<<COM00) | (1<<WGM01) | (1<<CS02) | (0<<CS01) | (0<<CS00);
    TCNT0=0x00;
   // OCR0=220;    
    // Timer(s)/Counter(s) Interrupt(s) initialization
    TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<OCIE0) | (0<<TOIE0);
    // LCD initialization
    DDRC = 0XFF;
    LCD_Init();

    while(1) {
        LCD_Clear();
        SPDR = '0'; // Slave data doesn't matter for master
        while (((SPSR >> SPIF) & 1) == 0); // Wait till get data from master
        // sprintf(light_voltage,"T=%d", SPDR);
        itoa(SPDR, light_voltage); // We need ascii code to show them on LCD
         
        if(SPDR==0)
        {
         OCR0 = 0;              
        }
        else if(SPDR==1)
        {
          OCR0 = 100;          
        }
        else if(SPDR==2)
        {
          OCR0 = 200;          
        }
        else if(SPDR==3)
        {
          OCR0 = 245;         
        }                
        
        
        
        
        for(i = 0; i < strlen(light_voltage); i++) {
            LCD_Char(light_voltage[i]);
        }
        delay_ms(500); // Some wait too see data, before LCD_Clear()
    }
}
