Read 8, temp8
Read 6, temp7, temp, temp2
subi temp7, 48
Zwischen temp7, 1, 18, 27
subi temp7, 1

cpi temp8, '1'
brne over1
// 1 AN
ldi     zl,low(LICHT);            
ldi     zh,high(LICHT);
add zl, temp7
adc zh, NULL
st Z, EINS

ldi temp, 3
mul temp7, temp
mov temp7, r0

ldi     zl,low(LICHTF);            
ldi     zh,high(LICHTF);
add zl, temp7
adc zh, NULL
ld temp4, Z+
ld temp5, Z+
ld temp6, Z+

inc temp7
AnSlaveSenden temp7, temp4, temp
inc temp7
AnSlaveSenden temp7, temp5, temp
inc temp7
AnSlaveSenden temp7, temp6, temp

Ausgeben 1
rjmp end_order
over1:
cpi temp8, '0'
brne over1_0
// 1 AUS
ldi     zl,low(LICHT);            
ldi     zh,high(LICHT);
add zl, temp7
adc zh, NULL
st Z, NULL

ldi temp, 3
mul temp7, temp
mov temp7, r0

inc temp7
AnSlaveSenden temp7, NULL, temp
inc temp7
AnSlaveSenden temp7, NULL, temp
inc temp7
AnSlaveSenden temp7, NULL, temp


Ausgeben 1
rjmp end_order
over1_0:

// Fehler
Ausgeben 29
