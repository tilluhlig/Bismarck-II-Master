Read 9, temp8
mov temp7, temp8
Zwischen temp8, 49, 51, 27
subi temp8, 49

mov temp5, NULL
mov temp6, NULL


cpi temp8, 0
brne no_temp02
// ausrechnen
ldi     zl,LOW(DREHZAHL0)  
ldi     zh,HIGH(DREHZAHL0)
mov temp2, NULL
mov temp3, NULL
mov temp4, NULL
ldi temp, 32
start18:
ld temp5, Z+
ld temp6, Z+
add temp2, temp5
adc temp3, temp6
adc temp4, NULL
sub temp5, temp6
cpi temp5, 0
brne no_aus
mov temp2, NULL
mov temp3, NULL
mov temp4, NULL
rjmp out_zaehl;
no_aus:

dec temp
brne start18
out_zaehl:

mov temp5, temp2
mov temp6, temp3
rjmp end_temp2
no_temp02:

cpi temp8, 1
brne no_temp12
ldi     zl,LOW(DREHZAHL1)  
ldi     zh,HIGH(DREHZAHL1)
mov temp2, NULL
mov temp3, NULL
mov temp4, NULL
ldi temp, 32
start19:
ld temp5, Z+
ld temp6, Z+
add temp2, temp5
adc temp3, temp6
adc temp4, NULL
dec temp
brne start19

mov temp5, temp2
mov temp6, temp3
rjmp end_temp2
no_temp12:

cpi temp8, 2
brne no_temp22
ldi     zl,LOW(DREHZAHL2)  
ldi     zh,HIGH(DREHZAHL2)
mov temp2, NULL
mov temp3, NULL
mov temp4, NULL
ldi temp, 32
start20:
ld temp5, Z+
ld temp6, Z+
add temp2, temp5
adc temp3, temp6
adc temp4, NULL
dec temp
brne start20

mov temp5, temp2
mov temp6, temp3
rjmp end_temp2
no_temp22:

end_temp2:

Ausgeben 16

lds temp8, SEND_MAX
subi temp8, 10
sts SEND_MAX,temp8

mov temp8, temp7
rcall add_send_char

mov temp3, temp5
rcall FUNKTION_HEX
mov temp8, temp3
rcall add_send_char
mov temp8, temp2
rcall add_send_char

mov temp3, temp6
rcall FUNKTION_HEX
mov temp8, temp3
rcall add_send_char
mov temp8, temp2
rcall add_send_char

mov temp3, temp4
rcall FUNKTION_HEX
mov temp8, temp3
rcall add_send_char
mov temp8, temp2
rcall add_send_char

ldi temp8, ' '
rcall add_send_char
rcall add_send_char
rcall add_send_char

rjmp end_order
over16_0:
// Fehler
Ausgeben 29
