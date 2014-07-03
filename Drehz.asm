lds temp7, DREHZAHL_LAST

// Kanal 0
sbis PINB, 0
rjmp no_rotation0
sbrc temp7, 0
rjmp no_rotation0
// Gedreht
lds temp4, DREHZAHL_POS0 
ldi     zl,LOW(DREHZAHL_MESS0)         
ldi     zh,HIGH(DREHZAHL_MESS0)
ld temp, Z+
ld temp2, Z
ldi     zl,LOW(DREHZAHL0)         
ldi     zh,HIGH(DREHZAHL0)
add zl, temp4
adc zh, NULL
add zl, temp4
adc zh, NULL
st Z+, temp
st Z, temp2
ldi     zl,LOW(DREHZAHL_MESS0)         
ldi     zh,HIGH(DREHZAHL_MESS0)
st Z+, NULL
st Z, NULL

add temp4, EINS
cpi temp4, 32
brne no_down0
ldi temp4, 0
no_down0:
sts DREHZAHL_POS0, temp4


rjmp rotate0
no_rotation0:

ldi     zl,LOW(DREHZAHL_MESS0)         
ldi     zh,HIGH(DREHZAHL_MESS0)
ld temp, Z+
ld temp2, Z
add temp, EINS
adc temp2, NULL
cpi temp, 160
brlo no_out0
cpi temp2, 15
brlo no_out0

ldi     zl,LOW(DREHZAHL0)         
ldi     zh,HIGH(DREHZAHL0)
lds temp4, DREHZAHL_POS0
add zl, temp4
adc zh, NULL
add zl, temp4
adc zh, NULL
st Z+, NULL
st Z, NULL
mov temp, NULL
mov temp2, NULL

lds temp4, DREHZAHL_POS0
add temp4, EINS
cpi temp4, 32
brne no_down7
ldi temp4, 0
no_down7:
sts DREHZAHL_POS0, temp4

no_out0:

ldi     zl,LOW(DREHZAHL_MESS0)         
ldi     zh,HIGH(DREHZAHL_MESS0)
st Z+, temp
st Z, temp2
rotate0:


// Kanal 1
sbis PINB, 1
rjmp no_rotation1
sbrc temp7, 1
rjmp no_rotation1
// Gedreht
lds temp4, DREHZAHL_POS1
ldi     zl,LOW(DREHZAHL_MESS1)         
ldi     zh,HIGH(DREHZAHL_MESS1)
ld temp, Z+
ld temp2, Z
ldi     zl,LOW(DREHZAHL1)         
ldi     zh,HIGH(DREHZAHL1)
add zl, temp4
adc zh, NULL
add zl, temp4
adc zh, NULL
st Z+, temp
st Z, temp2
ldi     zl,LOW(DREHZAHL_MESS1)         
ldi     zh,HIGH(DREHZAHL_MESS1)
st Z+, NULL
st Z, NULL

add temp4, EINS
cpi temp4, 32
brne no_down1
ldi temp4, 0
no_down1:
sts DREHZAHL_POS1, temp4
rjmp rotate1
no_rotation1:
ldi     zl,LOW(DREHZAHL_MESS1)         
ldi     zh,HIGH(DREHZAHL_MESS1)
ld temp, Z+
ld temp2, Z
add temp, EINS
adc temp2, NULL
cpi temp, 160
brlo no_out1
cpi temp2, 15
brlo no_out1
ldi     zl,LOW(DREHZAHL1)         
ldi     zh,HIGH(DREHZAHL1)
ldi temp, 160
ldi temp2, 15
st Z+, temp
st Z, temp2
mov temp, NULL
mov temp2, NULL
no_out1:

ldi     zl,LOW(DREHZAHL_MESS1)         
ldi     zh,HIGH(DREHZAHL_MESS1)
st Z+, temp
st Z, temp2
rotate1:

// Kanal 2
sbis PINB, 4
rjmp no_rotation2
sbrc temp7, 4
rjmp no_rotation2
// Gedreht
lds temp4, DREHZAHL_POS2
ldi     zl,LOW(DREHZAHL_MESS2)         
ldi     zh,HIGH(DREHZAHL_MESS2)
ld temp, Z+
ld temp2, Z
ldi     zl,LOW(DREHZAHL2)         
ldi     zh,HIGH(DREHZAHL2)
add zl, temp4
adc zh, NULL
add zl, temp4
adc zh, NULL
st Z+, temp
st Z, temp2
ldi     zl,LOW(DREHZAHL_MESS2)         
ldi     zh,HIGH(DREHZAHL_MESS2)
st Z+, NULL
st Z, NULL

add temp4, EINS
cpi temp4, 32
brne no_down2
ldi temp4, 0
no_down2:
sts DREHZAHL_POS2, temp4
rjmp rotate2
no_rotation2:
ldi     zl,LOW(DREHZAHL_MESS2)         
ldi     zh,HIGH(DREHZAHL_MESS2)
ld temp, Z+
ld temp2, Z
add temp, EINS
adc temp2, NULL
cpi temp, 160
brlo no_out2
cpi temp2, 15
brlo no_out2
ldi     zl,LOW(DREHZAHL2)         
ldi     zh,HIGH(DREHZAHL2)
ldi temp, 160
ldi temp2, 15
st Z+, temp
st Z, temp2
mov temp, NULL
mov temp2, NULL
no_out2:

ldi     zl,LOW(DREHZAHL_MESS2)         
ldi     zh,HIGH(DREHZAHL_MESS2)
st Z+, temp
st Z, temp2
rotate2:

in temp, PINB
sts DREHZAHL_LAST, temp
