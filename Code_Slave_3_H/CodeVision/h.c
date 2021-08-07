#include <io.h>
#include <delay.h>
#include <mlcd_portc.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>

int i;
char temperature[8];

void main(void) {

    
    // SPI initialization
    SPCR |= (1<<SPE); // SPI Enable
    SPCR |= (0<<CPOL); // SPI Clock Polarity: Low
    SPCR |= (0<<CPHA); // SPI Clock Phase: Leading edge sample / Trailing Edge setup
    SPCR |= (1<<SPR1) | (1<<SPR0); // SPI Clock Rate: f/128 = 62.5 KHz
    SPSR |= (0<<SPI2X);
    SPCR |= (0<<DORD); // SPI Data Order: MSB First
    SPCR |= (0<<MSTR); // SPI Type: Slave  
    
   

    // LCD initialization
    DDRC = 0XFF;
    LCD_Init(); 
    
    LCD_String("humidity");
    delay_ms(300);
    LCD_Clear();

    while(1) {
        LCD_Clear();
        SPDR = '0'; // Slave data doesn't matter for master
        while (((SPSR >> SPIF) & 1) == 0); // Wait till get data from master
        // sprintf(temperature,"T=%d", SPDR);
        itoa(SPDR, temperature); // We need ascii code to show them on LCD 
        
        if(SPDR>=30 && SPDR<=50)
        {
       
        LCD_String("'(:'"); 
                 
        }else{LCD_Clear(); LCD_String("'):'");}
        

        
        
        delay_ms(500); // Some wait too see data, before LCD_Clear()
    }
}
