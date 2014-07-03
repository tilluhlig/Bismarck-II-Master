.include "m644Pdef.inc"
.include "Makros.asm"

.MACRO AnSlaveGenerieren ; Speicher, AktivAdresse, Adresse, Daten 
ldi     zl,low(@0)           
ldi     zh,high(@0)
add zl, @1
adc zh, NULL
ld @1, Z
cpi @1, 0
breq no_l2_on
AnSlaveSenden @2, @3, @1
no_l2_on:

.ENDMACRO

.MACRO AnSlaveSenden; Adresse, Daten, temp
no_send3:
lds @2,UCSR1A
sbrs    @2,UDRE1                ;
rjmp    no_send3
sts     UDR1, @0

no_send4:
lds @2,UCSR1A
sbrs    @2,UDRE1                ;
rjmp    no_send4
sts     UDR1, @1
.ENDMACRO

.MACRO inpu
  .if @1 < 0x40
    in    @0, @1
  .else
      lds    @0, @1
  .endif
.ENDMACRO

.MACRO output
    .if @0 < 0x40
        out    @0, @1
    .else
        sts    @0, @1
  .endif
.ENDMACRO

.def NULL     = R10
.def EINS     = R11
.def temp = r16
.def temp2 = r17
.def temp3 = r18
.def temp4 = r19
.def temp5 = r20
.def temp6 = r21
.def temp7 = r22
.def temp8 = r23
.def temp1 = r15
.def temp9 = r24

.equ XTAL = 20000000
.equ F_CPU = XTAL                       ; Systemtakt in Hz
.equ BAUD  =  50000;19200; XBEE
.equ BAUD2  =  50000; SLAVE

; SENSORBELEGUNG TSIC-206                        
.equ SENSOR_EINGANG_PORT    = PIND        ; SIGNAL-PORT        
.equ SENSOR_EINGANG_PIN        = 6            ; SIGNAL-SPANNUNG    
.equ SENSOR_V_PORT            = PORTB        ; SPANNUNG-PORT        
.equ SENSOR_V_PIN            = 5            ; SPANNUNG-PIN        
.equ SENSOR_OFFSET            = 0            ; OFFSETWERT

; Berechnungen
.equ UBRR_VAL   = ((F_CPU+BAUD*8)/(BAUD*16)-1)  ; clever runden
.equ BAUD_REAL  = (F_CPU/(16*(UBRR_VAL+1)))      ; Reale Baudrate
.equ BAUD_ERROR = ((BAUD_REAL*1000)/BAUD-1000)  ; Fehler in Promille

.if ((BAUD_ERROR>10) || (BAUD_ERROR<-10))       ; max. +/-10 Promille Fehler
  .error "Systematischer Fehler der Baudrate grösser 1 Prozent und damit zu hoch!"
.endif 

; Berechnungen2
.equ UBRR_VAL2   = ((F_CPU+BAUD2*8)/(BAUD2*16)-1)  ; clever runden
.equ BAUD_REAL2  = (F_CPU/(16*(UBRR_VAL2+1)))      ; Reale Baudrate
.equ BAUD_ERROR2 = ((BAUD_REAL2*1000)/BAUD2-1000)  ; Fehler in Promille

.if ((BAUD_ERROR2>10) || (BAUD_ERROR2<-10))       ; max. +/-10 Promille Fehler
  .error "Systematischer Fehler der Baudrate2 grösser 1 Prozent und damit zu hoch!"
.endif 

.org 0x0000
rjmp reset
.org OC1Aaddr  
rjmp loop


reset:
; NULL                
    clr NULL
; EINS                
    ldi temp,1
    mov EINS,temp

    sts Sensor_Cooldown, NULL
    ldi temp, 255
    sts SEND_COOLDOWN, temp

ldi temp, 0b11111000
out DDRB, temp
ldi temp, 0b00000111
out PORTB, temp

          ldi      temp, HIGH(RAMEND)     ; Stackpointer initialisieren
          out      SPH, temp
          ldi      temp, LOW(RAMEND)
          out      SPL, temp

 ; Baudrate einstellen
    ldi     temp, HIGH(UBRR_VAL)
    output     UBRR0H, temp
    ldi     temp, LOW(UBRR_VAL)
    output    UBRR0L, temp

ldi temp, 0xFF
out DDRC, temp
ldi temp, 0x00
out PORTC, temp

ldi temp, 0b11111111
out DDRD, temp
ldi temp, 0b00000000
out PORTD, temp

// Temperatur
 ;PORT A initialisieren                                
    ldi temp, 0b00111111    ; 
    out DDRA, temp
; PORT A setzen                                        
    ldi temp, 0xFF    ; 
    out PORTA, temp    

; ADC_INITIALISIERUNG                                
    rcall ADC_INITIALISIERUNG

      ;RS232 initialisieren
    ldi r16, LOW(UBRR_VAL)
    output UBRR0L,r16
    ldi r16, HIGH(UBRR_VAL)
    output UBRR0H,r16
    ldi r16, (3<<UCSZ00) ; Frame-Format: 8 Bit /// ??? (1<<UMSEL0)|
    output UCSR0C,r16

    inpu temp, UCSR0B
    ori temp, (1<<RXEN0) | (1<<TXEN0)
    output UCSR0B, temp

          ;RS232 initialisieren
    ldi r16, LOW(UBRR_VAL)
    output UBRR1L,r16
    ldi r16, HIGH(UBRR_VAL)
    output UBRR1H,r16
    ldi r16, (3<<UCSZ10) ; Frame-Format: 8 Bit /// ??? (1<<UMSEL0)|
    output UCSR1C,r16

    inpu temp, UCSR1B
    ori temp, (1<<RXEN1) | (1<<TXEN1)
    output UCSR1B, temp

sts NEU_MESS, NULL
sts ANTWORT, EINS
ldi     zl,LOW(INTERVAL)         
ldi     zh,HIGH(INTERVAL)
ldi temp2, 22
start22:
st Z+,NULL
dec temp2
brne start22
ldi     zl,LOW(INTERVAL_MESS)         
ldi     zh,HIGH(INTERVAL_MESS)
ldi temp2, 22
start23:
st Z+,NULL
dec temp2
brne start23

ldi temp2, 64
ldi     zl,LOW(DREHZAHL0)         
ldi     zh,HIGH(DREHZAHL0)
start13:
st Z+,NULL
dec temp2
brne start13

ldi temp2, 64
ldi     zl,LOW(DREHZAHL1)         
ldi     zh,HIGH(DREHZAHL1)
start14:
st Z+,NULL
dec temp2
brne start14

ldi temp2, 64
ldi     zl,LOW(DREHZAHL2)         
ldi     zh,HIGH(DREHZAHL2)
start16:
st Z+,NULL
dec temp2
brne start16

ldi temp, 0
ldi temp2, 18
ldi     zl,LOW(LICHTF)         
ldi     zh,HIGH(LICHTF)
start4:
ST Z+, temp
dec temp2
brne start4
ldi temp2, 6
ldi     zl,LOW(LICHT)         
ldi     zh,HIGH(LICHT)
start11:
ST Z+, temp
dec temp2
brne start11

sts DREHZAHL_LAST, NULL
ldi     zl,LOW(MOTORR)         
ldi     zh,HIGH(MOTORR)
st Z+, NULL
st Z+, NULL
st Z, NULL
ldi     zl,LOW(DREHZAHL_MESS0)         
ldi     zh,HIGH(DREHZAHL_MESS0)
st Z+, NULL
st Z, NULL
ldi     zl,LOW(DREHZAHL_MESS1)         
ldi     zh,HIGH(DREHZAHL_MESS1)
st Z+, NULL
st Z, NULL
ldi     zl,LOW(DREHZAHL_MESS2)         
ldi     zh,HIGH(DREHZAHL_MESS2)
st Z+, NULL
st Z, NULL

sts DREHZAHL_POS0, NULL
sts DREHZAHL_POS1, NULL
sts DREHZAHL_POS2, NULL

ldi temp2, 3
ldi     zl,LOW(MOTOR)         
ldi     zh,HIGH(MOTOR)
start12:
ST Z+, temp
dec temp2
brne start12
ldi temp2, 3
ldi     zl,LOW(MOTORG)         
ldi     zh,HIGH(MOTORG)
start17:
ST Z+, temp
dec temp2
brne start17
ldi temp2, 3
ldi     zl,LOW(MOTORA)         
ldi     zh,HIGH(MOTORA)
start15:
ST Z+, temp
dec temp2
brne start15
ldi temp2, 18
ldi     zl,LOW(SERVO)         
ldi     zh,HIGH(SERVO)
ldi     xl,LOW(SERVO)         
ldi     xh,HIGH(SERVO)
start21:
ST Z+, NULL
ST X+, NULL
dec temp2
brne start21

ldi     zl,LOW(SCHORNSTEIN)         
ldi     zh,HIGH(SCHORNSTEIN)
ldi temp, 0
st Z+, temp
st Z+, temp
st Z+, temp
sts TIMEOUT, temp
sts MOTORPOS,temp
sts MOTORSCHALT,temp
ldi temp, 6
STS SERVO_WAIT, temp
ldi temp, 1
STS LICHT_COUNTER, temp
STS GRUNDFARBE, NULL
ldi temp, 5
STS SCHALT_WAIT, temp
STS INPUT_POS, NULL
STS SEND_POS, NULL
STS SEND_MAX, NULL
STS SEND_POS2, NULL
STS SEND_MAX2, NULL
ldi temp, 255
ldi temp2, 15
ldi zl, low(INPUT)
ldi zh, high(INPUT)
start:
ST Z+, temp
dec temp2
brne start
ldi temp, 0

Ausgeben 30


// Timer 1
 ldi     temp, high( 4000 - 1 )
        sts     OCR1AH, temp
        ldi     temp, low( 4000 - 1 ) // 5 Khz
        sts     OCR1AL, temp
         ldi     temp, ( 1 << WGM12 ) | ( 1 << CS10 )
        sts     TCCR1B, temp

        lds temp, TIMSK1
        ldi     temp2, 1 << OCIE1A  
        or temp, temp2
        sts     TIMSK1, temp
sei

do: rjmp do


loop:  

; Drehzahl messen
.include "Drehz.asm"

; Schornstein schalten
.include "Schorn.asm"

; Servo Zustand prüfen
ldi     zl,low(SERVOC)           
ldi     zh,high(SERVOC)
ldi temp2, 0x00
ldi temp3, 1
again:
ld temp, Z+
cpi temp, 1
brne no_servoc0
or temp2, temp3
no_servoc0:
lsl temp3
brne again

out PORTC, temp2

in temp2, PORTB
andi temp2, 0b11100111

ld temp, Z+
cpi temp, 1
brne no_servoc1
ori temp2, 0b00001000
no_servoc1:

ld temp, Z+
cpi temp, 1
brne no_servoc2
ori temp2, 0b00010000
no_servoc2:

out PORTB, temp2

; Motorrichtung steuern
//.include "Motorrichtung.asm"

; Motor schalten
//.include "MotorSchalt.asm"

; Messinterval Prüfen


; Daten empfangen
lds temp, UCSR0A
sbrs     temp, RXC0                    
rjmp     no_char_receive
lds       temp, UDR0
lds temp2, INPUT_POS

ldi     zl,LOW(INPUT)  
ldi     zh,HIGH(INPUT)
add zl, temp2
adc zh, NULL
ST Z, temp
; gespeichert
lds temp2, INPUT_POS
inc temp2
sts INPUT_POS, temp2

ldi temp2, 20 // Timeout nach 5 ms
sts TIMEOUT, temp2
rjmp out_of_receive
no_char_receive:
lds temp2, TIMEOUT
lds temp, SEND_MAX
cpi temp2, 0
brne dec_timeout
cpi temp, 0
breq out_of_receive
sts SEND_MAX, NULL
sts SEND_POS, NULL
rjmp out_of_receive
dec_timeout:
lds temp2, TIMEOUT
cpi temp2, 0
breq out_of_receive
dec temp2
sts TIMEOUT,temp2

out_of_receive:


; Überprüfen ob Befehl empfangen
lds temp2, INPUT_POS
cpi temp2, 15
breq order
rjmp no_order
order:
; Befehl empfangen
ldi temp, 0 ; Counter für Befehle
start2:
ldi     temp3,low(BEFEHLE*2);            
ldi     temp4,high(BEFEHLE*2);
ldi temp7, 16
mul temp7, temp
add temp3, r0
adc temp4, r1

ldi     temp5,low(INPUT);            
ldi     temp6,high(INPUT);

ldi temp2,0 ; Counter für Zeichen in Befehl
start3:
// check zeichen
mov zl, temp3
mov zh, temp4
lpm temp7, Z+
mov temp3, zl
mov temp4, zh

mov zl, temp5
mov zh, temp6
ld temp8, Z+
mov temp5, zl
mov temp6, zh

cp temp8, temp7
breq next
; falscher Befehl
cpi temp,27
breq got

rjmp no_got
next:

cpi temp8, ' '
breq got

inc temp2
cpi temp2,27
breq got

rjmp start3
rjmp no_got
got:
// Befehl temp bearbeiten
cpi temp, 0
brne no_0
// Hallo
ldi temp8, 0
rcall add_antwort_send // OK
rjmp end_order
no_0:

cpi temp, 1
breq order1
rjmp no_1
order1:
.include "LICHT.asm" // OK
rjmp end_order
no_1:

cpi temp, 2
breq order2
rjmp no_2
order2:
.include "LICHTR.asm" // OK
rjmp end_order
no_2:

cpi temp, 3
breq order3
rjmp no_3
order3:
.include "LICHTG.asm" // OK
rjmp end_order
no_3:

cpi temp, 4
breq order4
rjmp no_4
order4:
.include "LICHTB.asm" // OK
rjmp end_order
no_4:

cpi temp, 5
breq order5
rjmp no_5
order5:
.include "MOTOR.asm"
rjmp end_order
no_5:

cpi temp, 6
breq order6
rjmp no_6
order6:
.include "MOTORG.asm"
rjmp end_order
no_6:

cpi temp, 7
breq order7
rjmp no_7
order7:
.include "SCHORNSTEIN.asm"
rjmp end_order
no_7:

cpi temp, 8
breq order8
rjmp no_8
order8:
.include "L.asm"
rjmp end_order
no_8:

cpi temp, 9
breq order9
rjmp no_9
order9:
.include "SERVOC.asm"
rjmp end_order
no_9:

cpi temp, 10
breq order10
rjmp no_10
order10:
// Frei
rjmp end_order
no_10:

cpi temp, 11
breq order11
rjmp no_11
order11:
.include "SERVO.asm" // OK
rjmp end_order
no_11:

cpi temp, 12
breq order12
rjmp no_12
order12:
.include "MOTORR.asm"
rjmp end_order
no_12:

cpi temp, 13
breq order13
rjmp no_13
order13:
// Frei
Ausgeben 13
rjmp end_order
no_13:

cpi temp, 14
breq order14
rjmp no_14
order14:
// Temperatur Befehl
.include "TEMPERATUR.asm"
rjmp end_order
no_14:

cpi temp, 15
breq order15
rjmp no_15
order15:
.include "TEMP.asm"
rjmp end_order
no_15:

cpi temp, 16
breq order16
rjmp no_16
order16:
.include "DREHZAHL.asm"
rjmp end_order
no_16:

cpi temp, 17
breq order17
rjmp no_17
order17:
// interval

rjmp end_order
no_17:

cpi temp, 18
breq order18
rjmp no_18
order18:
// neu_mess

rjmp end_order
no_18:

cpi temp, 19
breq order19
rjmp no_19
order19:
// antwort
.include "ANTWORT.asm"
rjmp end_order
no_19:

cpi temp, 27
brne no_27
// Kein Befehl gefunden
Ausgeben 28
rjmp end_order
no_27:


rjmp end_order
no_got:
inc temp
cpi temp, 28 // Anzahl der Befehle
breq end_order
rjmp start2
end_order:

sts INPUT_POS, NULL

no_order:

; XBEE Daten senden
lds temp, SEND_COOLDOWN
cpi temp, 0
breq xbeesenden
dec temp
sts SEND_COOLDOWN, temp
rjmp no_send
xbeesenden:
lds temp, SEND_MAX
lds temp2, SEND_POS
cp temp2, temp
breq no_send

ldi     zl,low(SEND_DATA)            
ldi     zh,high(SEND_DATA)
add zl, temp2
adc zh,NULL
ld temp3, Z
no_send2:
lds temp,UCSR0A
sbrs    temp,UDRE0                ;
rjmp    no_send2
sts     UDR0, temp3

inc temp2
cpi temp2, 150
brne no_down3
mov temp2, NULL
no_down3:
sts SEND_POS, temp2
no_send:

; Slave Daten senden
lds temp, SEND_MAX2
lds temp2, SEND_POS2
cp temp2, temp
breq no_send4

ldi     zl,low(SEND_DATA2)            
ldi     zh,high(SEND_DATA2)
add zl, temp2
adc zh,NULL
ld temp3, Z+
inc temp2
cpi temp2, 150
brne no_down9
mov temp2, NULL
no_down9:

ld temp4, Z
inc temp2
cpi temp2, 150
brne no_down8
mov temp2, NULL
no_down8:

AnSlaveSenden temp3, temp4, temp2

sts SEND_POS2, temp2
no_send4:


reti 



















add_antwort_send:
push temp
lds temp, ANTWORT
cpi temp, 1
breq no_add
ldi     zl,low(ANTWORTEN*2);            
ldi     zh,high(ANTWORTEN*2);
add zl, temp8
adc zh, NULL
lpm temp, Z
cpi temp, 1
breq no_add
pop temp
ret
no_add:
rcall add_send
pop temp
ret

add_send:
// BEFEHLE_ANTWORTEN ID in temp8
//Befehle_Antworten:
push temp7
push temp3
push temp4
push temp
push temp2
push temp5
push temp6
ldi     temp3,low(BEFEHLE_ANTWORTEN*2);            
ldi     temp4,high(BEFEHLE_ANTWORTEN*2);
ldi temp7, 16
mul temp8, temp7
add temp3, r0
adc temp4, r1

lds temp, SEND_MAX
cpi temp,150
brne no_down4
mov temp, NULL
no_down4:
ldi     temp5,low(SEND_DATA);            
ldi     temp6,high(SEND_DATA);
add temp5, temp
adc temp6, NULL

ldi temp2, 15
start7:
mov zl, temp3
mov zh, temp4
lpm temp7, Z+
mov temp3, zl
mov temp4, zh

mov zl, temp5
mov zh, temp6
st Z+, temp7
mov temp5, zl
mov temp6, zh

inc temp
cpi temp,150
brne no_down5
mov temp, NULL
add temp5, temp
adc temp6, NULL
no_down5:

dec temp2
brne start7
sts SEND_MAX,temp
pop temp6
pop temp5
pop temp2
pop temp
pop temp4
pop temp3
pop temp7
ret

add_send_char:
// Zeichen in temp8
lds temp, SEND_MAX
ldi     zl,low(SEND_DATA);            
ldi     zh,high(SEND_DATA);
add zl, temp
adc zh, NULL
st Z, temp8
inc temp
cpi temp,150
brne no_down6
mov temp, NULL
no_down6:
sts SEND_MAX,temp
ret

add_send_char_slave:
// Zeichen in temp8
lds temp, SEND_MAX2
ldi     zl,low(SEND_DATA2);            
ldi     zh,high(SEND_DATA2);
add zl, temp
adc zh, NULL
st Z, temp8
inc temp
cpi temp,150
brne no_down77
mov temp, NULL
no_down77:
sts SEND_MAX2,temp
ret

tsic206messen:
lds temp, Sensor_Cooldown
cpi temp, 0
breq messen2
dec temp
sts Sensor_Cooldown, temp
rjmp over_messen
messen2:
    rcall SENSOR_TSIC_ABFRAGEN
    ldi temp, 5
    sts Sensor_Cooldown, temp
    over_messen:
ret

.include "LED_KTY_ADC.asm"
.include "THERMO_TSIC206.asm"

Befehle: // pro Befehl 15 Byte
/* 0*/.db "hallo          ",0 // Abfrage ob Anwesend
/* 1*/.db "licht          ",0 // licht 1 1       ---Licht Ein/Aus
/* 2*/.db "lichtr         ",0 // lichtr 1 255    ---Licht Rot einstellen
/* 3*/.db "lichtg         ",0 // lichtg 1 255    ---Licht Grün einstellen
/* 4*/.db "lichtb         ",0 // lichtb 1 255    ---Licht Blau einstellen
/* 5*/.db "motor          ",0 // motor 1 1       ---Motor Ein/Aus
/* 6*/.db "motorg         ",0 // motorg 1 255    ---Motor Geschwindigkeit
/* 7*/.db "schornstein    ",0 // schornstein 1   ---Schornstein Ein/Aus
/* 8*/.db "l              ",0 // l 1 255255255   ---Licht RGB einstellen
/* 9*/.db "servoc         ",0 // 
/*10*/.db "FREI           ",0 // 
/*11*/.db "servo          ",0 // servo 1 090 160 ---Geschütz einstellen
/*12*/.db "motorr         ",0 // motorr 1 1      ---Motorrichtung
/*13*/.db "FREI           ",0 // 
/*14*/.db "temperatur     ",0 // temperatur 7    ---Temperatur messen
/*15*/.db "konf_temp      ",0 // konf_temp 1     ---Temperaturmessung aktivieren/deaktivieren, nach start 200ms pause machen
/*16*/.db "drehzahl       ",0 // drehzahl 1      ---Drehzahl abfragen
/*17*/.db "interval       ",0 // interval 99 255 ---Interval einstellen für Messwertübertragung - 0 = Aus, Einstellen in 16 = 1s (max. 15s)
/*18*/.db "neu_mess       ",0 // neu_mess 99 1   ---Einstellen, ob Messwerte im Interval nur, wenn wert verändert
/*19*/.db "antwort        ",0 // antwort 1       ---Einstellen, ob nur Antworten mit Messwerten übertragen werden
/*20*/.db "FREI           ",0
/*21*/.db "FREI           ",0
/*22*/.db "FREI           ",0
/*23*/.db "FREI           ",0
/*24*/.db "FREI           ",0
/*25*/.db "FREI           ",0
/*26*/.db "FREI           ",0
/*27*/.db "               ",0 // Fehlerhafte Eingabe

Antworten:
.db 1,0,0,0,0,0,0,0,0,1,1,0,0,1,1,0,1,0,0,0,0,0,0,0,0,0,0

Befehle_Antworten:
.db "Anwesend       ",0
.db "Scheinwerfer   ",0
.db "Scheinw. Rot   ",0
.db "Scheinw. Grün  ",0
.db "Scheinw. Blau  ",0
.db "Motor          ",0
.db "Motor Geschw.  ",0
.db "Schornstein    ",0
.db "Scheinw. RGB   ",0
.db "Einst. Servo   ",0
.db "               ",0
.db "Servo          ",0
.db "Motor Richtung ",0
.db "               ",0
.db "Temp.          ",0
.db "Einst. Temp.   ",0
.db "Dreh.          ",0
.db "Interval Einst.",0
.db "Nur neue Messw.",0
.db "Antwort konf.  ",0
.db "               ",0
.db "               ",0
.db "               ",0
.db "               ",0
.db "               ",0
.db "               ",0
.db "               ",0
.db "Fehler 359     ",0 // falsche ID 27
.db "Fehler 318     ",0 // falscher Befehl 28
.db "Fehler 412     ",0 // Fehlerhaftes 1|0 29
.db "...Neustart... ",0

 
.DSEG ; Arbeitsspeicher
SERVO_WAIT:   .BYTE  1 
LICHT_COUNTER: .BYTE 1
GRUNDFARBE: .BYTE 1
SCHALT_WAIT: .BYTE 1
INPUT: .BYTE 15
INPUT_POS: .BYTE 1

// XBEE Sendedaten
SEND_DATA: .BYTE 150
SEND_POS: .BYTE 1
SEND_MAX: .BYTE 1
SEND_COOLDOWN: .BYTE 1

// Slave Sendedaten
SEND_DATA2: .BYTE 150
SEND_POS2: .BYTE 1
SEND_MAX2: .BYTE 1


NEU_MESS: .BYTE 1
ANTWORT: .BYTE 1
INTERVAL: .BYTE 22
INTERVAL_MESS: .BYTE 22

LICHTF: .BYTE 18
LICHT: .BYTE 6
MOTOR: .BYTE 3 // Motor an oder aus
MOTORA: .BYTE 3 // Aktuelle Motorgeschw.
MOTORG:.BYTE 3 // Ziel Motorgeschw.
MOTORR: .BYTE 3 // Motor Richtung
MOTORPOS: .BYTE 1
MOTORSCHALT: .BYTE 1
SCHORNSTEIN: .BYTE 3
SERVO: .BYTE 18
SERVOC: .BYTE 18
TIMEOUT: .BYTE 1

// Temperatur
adr_TEMPERATUR_KTY_L: .BYTE 1
adr_TEMPERATUR_KTY_H: .BYTE 1

adr_TEMPERATUR_LM35_L: .BYTE 1
adr_TEMPERATUR_LM35_H: .BYTE 1

adr_ADC_0_L: .BYTE 1
adr_ADC_0_H: .BYTE 1
adr_ADC_1_L: .BYTE 1
adr_ADC_1_H: .BYTE 1
adr_ADC_2_L: .BYTE 1
adr_ADC_2_H: .BYTE 1
adr_ADC_3_L: .BYTE 1
adr_ADC_3_H: .BYTE 1
adr_ADC_4_L: .BYTE 1
adr_ADC_4_H: .BYTE 1
adr_ADC_5_L: .BYTE 1
adr_ADC_5_H: .BYTE 1
adr_ADC_6_L: .BYTE 1
adr_ADC_6_H: .BYTE 1
adr_ADC_7_L: .BYTE 1
adr_ADC_7_H: .BYTE 1

// Drehzahl
DREHZAHL0:     .BYTE 64 // Messergebnisse
DREHZAHL1:     .BYTE 64
DREHZAHL2:     .BYTE 64

DREHZAHL_POS0: .BYTE 1 // Position in der Liste der Messergebnisse
DREHZAHL_POS1: .BYTE 1
DREHZAHL_POS2: .BYTE 1


DREHZAHL_LAST: .BYTE 1 // alter Zustand der Lichtschranke
DREHZAHL_MESS0:.BYTE 2 // Aktive Messung
DREHZAHL_MESS1:.BYTE 2
DREHZAHL_MESS2:.BYTE 2

// Kommunikation mit LED+SERVO
REC_POS: .BYTE 1 // welches Bit wird gerade gesendet
REC_Takt: .BYTE 1 // 1 oder 0
INP: .BYTE 1  // zu sendendes Byte
INP_POS: .BYTE 1 // gesamt senden, wievielte Position von 26 

// TSIC 206
adr_TEMPERATUR_L: .BYTE 1
adr_TEMPERATUR_H: .BYTE 1
adr_TEMPERATURDATEN_L: .BYTE 1
adr_TEMPERATURDATEN_H: .BYTE 1
adr_BIT_A: .BYTE 1
adr_BIT_B: .BYTE 1
adr_BIT_C: .BYTE 1
adr_BIT_D: .BYTE 1
adr_BIT_E: .BYTE 1
adr_BIT_F: .BYTE 1
adr_BIT_G: .BYTE 1
adr_BIT_H: .BYTE 1
adr_BIT_I: .BYTE 1
adr_BIT_J: .BYTE 1
adr_BIT_K: .BYTE 1
adr_BIT_L: .BYTE 1
adr_BIT_M: .BYTE 1
adr_BIT_N: .BYTE 1
adr_BIT_O: .BYTE 1
adr_BIT_P: .BYTE 1
adr_BIT_Q: .BYTE 1
adr_BIT_R: .BYTE 1
adr_STROBE: .BYTE 1
Sensor_Cooldown: .BYTE 1
