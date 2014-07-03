Read 8, temp8
Read 6, temp7
Zwischen temp7, 49, 51, 27
subi temp7, 48

cpi temp8, '1'
brne over5
// 1 AN
dec temp7
ldi     zl,low(MOTOR);            
ldi     zh,high(MOTOR);
add zl, temp7
ldi temp8, 0
adc zh, temp8
ldi temp8, 1
st Z, temp8

Ausgeben 5
rjmp end_order
over5:
cpi temp8, '0'
brne over5_0
// 1 AUS
dec temp7
ldi     zl,low(MOTOR);            
ldi     zh,high(MOTOR);
add zl, temp7
ldi temp8, 0
adc zh, temp8
ldi temp8, 0
st Z, temp8

Ausgeben 5
rjmp end_order
over5_0:

// Fehler
Ausgeben 29
