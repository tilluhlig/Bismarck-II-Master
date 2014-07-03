Read 11, temp8
Zwischen temp8, 49, 57, 27
mov temp7, temp8
subi temp8, 49

mov temp5, NULL
mov temp6, NULL
mov temp, NULL
mov temp2, NULL

cpi temp8, 0
brne no_temp0
rcall MESSEN_0
rjmp end_temp
no_temp0:

cpi temp8, 1
brne no_temp1
rcall MESSEN_1
rjmp end_temp
no_temp1:

cpi temp8, 2
brne no_temp2
rcall MESSEN_2
rjmp end_temp
no_temp2:

cpi temp8, 3
brne no_temp3
rcall MESSEN_3
rjmp end_temp
no_temp3:

cpi temp8, 4
brne no_temp4
rcall MESSEN_4
rjmp end_temp
no_temp4:

cpi temp8, 5
brne no_temp5
rcall MESSEN_5
rjmp end_temp
no_temp5:

cpi temp8, 6
brne no_temp6
rcall MESSEN_6
rjmp end_temp
no_temp6:

cpi temp8, 7
brne no_temp7
rcall MESSEN_7
rjmp end_temp
no_temp7:

end_temp:

rcall FUNKTION_KTY81_122_1400OHM
mov temp5, temp
mov temp6, temp2

Ausgeben 14

// werte sind in temp5 und temp6
lds temp8, SEND_MAX
subi temp8, 10
sts SEND_MAX,temp8

// Vorzeichen prüfen
ldi temp8, 	0x2B // +
sbrs temp6, 0x07
rjmp no_neg
subi temp5, 1
sbc temp6, NULL
com temp5
com temp6
ldi temp8, 0x2D // -
no_neg:

rcall add_send_char // Vorzeichen hinzufügen 

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
ldi temp8, ' '
rcall add_send_char
rcall add_send_char
rcall add_send_char
rcall add_send_char
//rcall add_send_char
rjmp end_order
over14_0:

// Fehler
Ausgeben 29
