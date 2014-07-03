Read 2, temp3, temp, temp2
subi temp3, 48
Zwischen temp3, 1, 6, 27
subi temp3, 1
; l 1 255255255
Read3 4, temp4, temp7, temp8
Read3 7, temp5, temp7, temp8
Read3 10, temp6, temp7, temp8

ldi     zl,low(LICHTF);            
ldi     zh,high(LICHTF);
ldi temp2, 3
mul temp3, temp2
add zl, r0
adc zh, r1
st Z+, temp4
st Z+, temp5
st Z, temp6

// SLAVE
mov temp2, temp3
ldi temp, 3
mul temp2, temp
mov temp2, r0
add temp2, EINS

ldi     zl,low(LICHT)           
ldi     zh,high(LICHT)
add zl, temp3
adc zh, NULL
ld temp3, Z
cpi temp3, 0
breq no_l_on
mov temp8, temp2 
inc temp2
/*rcall add_send_char_slave
mov temp8, temp4
rcall add_send_char_slave
mov temp8, temp2 
inc temp2
rcall add_send_char_slave
mov temp8, temp5
rcall add_send_char_slave
mov temp8, temp2 
rcall add_send_char_slave
mov temp8, temp6
rcall add_send_char_slave*/
no_l_on:

Ausgeben 8
