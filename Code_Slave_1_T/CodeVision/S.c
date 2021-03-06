#include <io.h>
#include <delay.h>
#include <mlcd_portc.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>

int i;
char temperature[8];

void main(void) {
    DDRB.3 = 1;
    DDRD.7 = 1;
    
    // SPI initialization
    SPCR |= (1<<SPE); // SPI Enable
    SPCR |= (0<<CPOL); // SPI Clock Polarity: Low
    SPCR |= (0<<CPHA); // SPI Clock Phase: Leading edge sample / Trailing Edge setup
    SPCR |= (1<<SPR1) | (1<<SPR0); // SPI Clock Rate: f/128 = 62.5 KHz
    SPSR |= (0<<SPI2X);
    SPCR |= (0<<DORD); // SPI Data Order: MSB First
    SPCR |= (0<<MSTR); // SPI Type: Slave  
    
    // Timer/Counter 0 initialization
    // Clock source: System Clock
    // Clock value: 125.000 kHz
    // Mode: Fast PWM top=0xFF
    // OC0 output: Non-Inverted PWM
    // Timer Period: 2.048 ms
    // Output Pulse(s):
    // OC0 Period: 2.048 ms Width: 0 us
    TCCR0=(1<<WGM00) | (1<<COM01) | (0<<COM00) | (1<<WGM01) | (0<<CS02) | (1<<CS01) | (1<<CS00);
    TCNT0=0x00;
    OCR0=0x00;  
    
    // Timer/Counter 2 initialization
    // Clock source: System Clock
    // Clock value: 125.000 kHz
    // Mode: Fast PWM top=0xFF
    // OC2 output: Non-Inverted PWM
    // Timer Period: 2.048 ms
    // Output Pulse(s):
    // OC2 Period: 2.048 ms Width: 0 us
    ASSR=0<<AS2;
    TCCR2=(1<<PWM2) | (1<<COM21) | (0<<COM20) | (1<<CTC2) | (1<<CS22) | (0<<CS21) | (0<<CS20);
    TCNT2=0x00;
    OCR2=0x00;    

    // LCD initialization
    DDRC = 0XFF;
    LCD_Init();

    while(1) {
        LCD_Clear();
        SPDR = '0'; // Slave data doesn't matter for master
        while (((SPSR >> SPIF) & 1) == 0); // Wait till get data from master
        // sprintf(temperature,"T=%d", SPDR);
        itoa(SPDR, temperature); // We need ascii code to show them on LCD
        
        for(i = 0; i < strlen(temperature); i++) {
            LCD_Char(temperature[i]);
        }
        
        if(SPDR > 25 )
        {
        OCR0 = 100;           // COOOLER
        if(SPDR>30)
        {
        OCR0 = 150;           
        }
        if(SPDR>35)
        {
        OCR0 = 200;           
        }
        if(SPDR>40)
        {
        OCR0 = 250;           
        }
        }else{OCR0 = 0;} 
        
                 //HEATER
        if(SPDR<20)
        {
        OCR2 = 100;           
        
        if(SPDR>15)
        {
        OCR2 = 150;           
        }
        if(SPDR<10)
        {
        OCR2 = 200;           
        }
                   
        if(SPDR<5)
        {
        OCR2 = 250;           
        }  
                  
        }else{OCR2 = 0;}

        
        
        
        
        
        delay_ms(1000); // Some wait too see data, before LCD_Clear()
    }
}
