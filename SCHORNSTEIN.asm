Read 12, temp8
ld temp7, Z+
ld temp6, Z
subi temp8, 48
subi temp7, 48
subi temp6, 48

ldi     ZL,low(SCHORNSTEIN);            
ldi     ZH,high(SCHORNSTEIN);
st Z+,temp8
st Z+,temp7
st Z+,temp6

Ausgeben 7
rjmp end_order
over15_0:

// Fehler
Ausgeben 29
