Read 7, temp7, temp, temp2
subi temp7, 48
Zwischen temp7, 1, 6, 27
subi temp7, 1

Read3 9, temp4, temp8, temp5

ldi     zl,low(LICHTF);            
ldi     zh,high(LICHTF);
ldi temp5, 3
mul temp5, temp7
add zl, r0
adc zh, r1
st Z, temp4

// SLAVE
mov temp2, temp7
ldi temp, 3
mul temp2, temp
mov temp2, r0
add temp2, EINS

AnSlaveGenerieren LICHT, temp7, temp2, temp4

Ausgeben 2
