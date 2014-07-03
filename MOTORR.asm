Read 7, temp7
Zwischen temp7, 49, 51, 27
subi temp7, 49

ldi     temp5,low(INPUT);            
ldi     temp6,high(INPUT);
ldi temp3, 9
add temp5, temp3
adc temp6,NULL
mov zl, temp5
mov zh, temp6
ld temp8, Z

ldi     zl,low(MOTORR);            
ldi     zh,high(MOTORR);
add zl, temp7
adc zh, NULL
st Z, temp8

Ausgeben 12
