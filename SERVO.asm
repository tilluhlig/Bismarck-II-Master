Read2 6, temp7, temp5, temp6
Zwischen temp7, 1, 16, 27
subi temp7, 1

Read2 9, temp4, temp5, temp6
Zwischen temp4, 0, 50, 27

ldi     zl,low(SERVO);            
ldi     zh,high(SERVO);
add zl, temp7
adc zh, NULL
addi temp4, 50
st Z, temp4

// SLAVE
addi temp7, 22 
AnSlaveSenden temp7, temp4, temp5

Ausgeben 11
