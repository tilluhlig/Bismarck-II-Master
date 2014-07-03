ldi     ZL,low(MOTORR);            
ldi     ZH,high(MOTORR);
ld temp, Z+
cpi temp, 1
brne no000
sbic PORTC, 0x04
cbi PORTC, 0x04
sbis PORTB, 0x03
sbi PORTB, 0x03
rjmp over000
no000:
sbis PORTC, 0x04
sbi PORTC, 0x04
sbic PORTB, 0x03
cbi PORTB, 0x03
over000:

ld temp, Z+
cpi temp, 1
brne no111
sbic PORTC, 0x05
cbi PORTC, 0x05
sbis PORTB, 0x04
sbi PORTB, 0x04
rjmp over111
no111:
sbis PORTC, 0x05
sbi PORTC, 0x05
sbic PORTB, 0x04
cbi PORTB, 0x04
over111:

ld temp, Z
cpi temp, 1
brne no222
sbic PORTC, 0x06
cbi PORTC, 0x06
sbis PORTB, 0x05
sbi PORTB, 0x05
rjmp over222
no222:
sbis PORTC, 0x06
sbi PORTC, 0x06
sbic PORTB, 0x05
cbi PORTB, 0x05
over222:
