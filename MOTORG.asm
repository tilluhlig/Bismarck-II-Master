Read 7, temp7
Zwischen temp7, 49, 51, 27
subi temp7, 49

Read3 9, temp4, temp8, temp5

ldi     zl,low(MOTORG);            
ldi     zh,high(MOTORG);
dec temp7
add zl, temp7
adc zh, NULL
st Z, temp4

lds temp3, ANTWORT
cpi temp3, 1
brne no_antwort1
ldi temp8, 6
rcall add_send

lds temp8, SEND_MAX
dec temp8
dec temp8
dec temp8
sts SEND_MAX,temp8


ldi temp3, 49
mov temp8, temp7
add temp8, temp3
rcall add_send_char

ldi     zl,low(MOTORG);            
ldi     zh,high(MOTORG);
add zl, temp7
ldi temp3, 0
adc zh, temp3
ld temp3, Z
rcall FUNKTION_HEX
mov temp8, temp3
rcall add_send_char
mov temp8, temp2
rcall add_send_char
no_antwort1:
