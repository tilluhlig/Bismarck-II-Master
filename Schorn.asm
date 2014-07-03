ldi     ZL,low(SCHORNSTEIN);            
ldi     ZH,high(SCHORNSTEIN);

ld temp, Z+
cpi temp, 1
brne no_schornstein1
sbi PORTD, 4
rjmp end_schornstein1
no_schornstein1:
cbi PORTD, 4
end_schornstein1:

ld temp, Z+
cpi temp, 1
brne no_schornstein2
sbi PORTD, 5
rjmp end_schornstein2
no_schornstein2:
cbi PORTD, 5
end_schornstein2:

ld temp, Z+
cpi temp, 1
brne no_schornstein3
sbi PORTD, 6
rjmp end_schornstein3
no_schornstein3:
cbi PORTD, 6
end_schornstein3:
  
