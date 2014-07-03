Read 10, temp8
Read2 7, temp7, temp, temp2
Zwischen temp7, 1, 10, 27
subi temp7, 1

ldi     zl,low(SERVOC);            
ldi     zh,high(SERVOC);

cpi temp8, '1'
brne over111
// 1 AN
add zl, temp7
adc zh, NULL
ldi temp, 1
st Z, temp

Ausgeben 9
rjmp end_order
over111:
cpi temp8, '0'
brne over111_0
// 1 AUS
add zl, temp7
adc zh, NULL
st Z, NULL

Ausgeben 9
rjmp end_order
over111_0:

// Fehler
Ausgeben 29
