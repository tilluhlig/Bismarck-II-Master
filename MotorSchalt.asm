lds temp, MOTORSCHALT
cpi temp, 48
breq schalt
rjmp no_schalt
schalt:
ldi temp,0
sts MOTORSCHALT,temp

ldi temp,0
motor_a:
ldi     zl,LOW(MOTOR)         
ldi     zh,HIGH(MOTOR)
add zl,temp
ldi temp2, 0
adc zh, temp2
ld temp2, Z
cpi temp2, 1
breq aktiv
// inaktiv
ldi     zl,LOW(MOTORA)         
ldi     zh,HIGH(MOTORA)
add zl,temp
ldi temp3, 0
adc zh, temp3
ld temp3, Z
cpi temp3, 0
breq end_inaktiv
dec temp3
ldi     zl,LOW(MOTORA)         
ldi     zh,HIGH(MOTORA)
add zl,temp
ldi temp2, 0
adc zh, temp2
st Z, temp3 // runterschalten, falls motor noch in bewegung
end_inaktiv:
rjmp end_motor
aktiv:
// aktiv
ldi     zl,LOW(MOTORA)         
ldi     zh,HIGH(MOTORA)
add zl,temp
ldi temp3, 0
adc zh, temp3
ld temp3, Z
ldi     zl,LOW(MOTORG)         
ldi     zh,HIGH(MOTORG)
add zl,temp
ldi temp4, 0
adc zh, temp4
ld temp4, Z

cp temp3, temp4
breq end_motor
cp temp3, temp4
brlo motor_hoch
// hochschalten
dec temp3
ldi     zl,LOW(MOTORA)         
ldi     zh,HIGH(MOTORA)
add zl,temp
ldi temp2, 0
adc zh, temp2
st Z, temp3
rjmp end_motor
motor_hoch:
// runterschalten
inc temp3
ldi     zl,LOW(MOTORA)         
ldi     zh,HIGH(MOTORA)
add zl,temp
ldi temp2, 0
adc zh, temp2
st Z, temp3
end_motor:
inc temp
cpi temp, 3
brne motor_a
rjmp over_noschalt
no_schalt:
lds temp, MOTORSCHALT
inc temp
sts MOTORSCHALT, temp
over_noschalt:
