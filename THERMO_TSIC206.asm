; ##############################################################################
; ##############################################################################
; ##############################################################################
SENSOR_TSIC_ABFRAGEN:
    ; INITIALISIERUNG        
    clr temp1
    clr temp2
    STS(adr_TEMPERATUR_L),NULL
    STS(adr_TEMPERATUR_H),NULL
    STS(adr_STROBE),NULL
    clr temp6                    ; PARITÄT                        
    ldi temp8,15                 ;(STROBE typisch bei 1MHz=15)    
    clr temp9                    ;(Impulslänge)                    
;===============================================================================
    ; SENSOR-SPANNUNG ein    
//    sbi (SENSOR_V_PORT),(SENSOR_V_PIN)
//    rcall wait5ms
    ; sendet Sensor DATEN ?    
    rcall SENSOR_DATEN_SUCHEN    ; OUT temp
    tst temp
    brne SENSOR_TSIC_ABFRAGEN_START
    ; ERROR (keine DATEN)
    
    ret
;===============================================================================
SENSOR_TSIC_ABFRAGEN_START:
    ; auf Sendepause warten 
    rcall SENSOR_PAUSE_SUCHEN
;===============================================================================

    ; START-BIT (STROBE)    
    rcall SENSOR_PIN_ABFRAGEN    ; out temp    
    STS(adr_STROBE),temp9        ; STROBE speichern im SRAM        
    mov temp8,temp9                ; STROBE speichern im Register    
    ; Bit-7 (MSB)    
    rcall SENSOR_PIN_ABFRAGEN    ; out temp    
    STS(adr_BIT_A),temp            ; für TEST-Darstellung
    LSL temp
    ROL temp2
    ; Bit-6            
    rcall SENSOR_PIN_ABFRAGEN    ; out temp
    STS(adr_BIT_B),temp
    LSL temp
    ROL temp2
    ; Bit-5            
    rcall SENSOR_PIN_ABFRAGEN    ; out temp
    STS(adr_BIT_C),temp
    LSL temp
    ROL temp2
    ; Bit-4            
    rcall SENSOR_PIN_ABFRAGEN    ; out temp
    STS(adr_BIT_D),temp
    LSL temp
    ROL temp2
;-------------------------------------------------------------------------------
    ; ERROR-CHECK (Bit 7 bis 4 muss NULL sein
    mov temp,temp2
    andi temp,0b11111000
    tst temp
    breq SENSOR_TSIC_ABFRAGEN_NULL_OK
    
SENSOR_TSIC_ABFRAGEN_NULL_OK:
;-------------------------------------------------------------------------------
    ; Bit-3            
    rcall SENSOR_PIN_ABFRAGEN    ; out temp
    STS(adr_BIT_E),temp
    LSL temp
    ROL temp2
    ; Bit-2            
    rcall SENSOR_PIN_ABFRAGEN    ; out temp
    STS(adr_BIT_F),temp
    LSL temp
    ROL temp2
    ; Bit-1            
    rcall SENSOR_PIN_ABFRAGEN    ; out temp
    STS(adr_BIT_G),temp
    LSL temp
    ROL temp2
    ; Bit-0    (LSB)    
    rcall SENSOR_PIN_ABFRAGEN    ; out temp
    STS(adr_BIT_H),temp
    LSL temp
    ROL temp2
    ; PARITY-BIT    
    rcall SENSOR_PIN_ABFRAGEN    ; out temp
    STS(adr_BIT_I),temp
;-------------------------------------------------------------------------------
    ; PARITÄTS-PRÜFUNG        
    mov temp6,temp2
    rcall BERECHNUNG_SENSOR_PARITAET    ; inp/out: temp6
    cp temp6,temp
    breq SENSOR_TSIC_ABFRAGEN_P1_OK
    
SENSOR_TSIC_ABFRAGEN_P1_OK:
;===============================================================================
    ; START-BIT        
    rcall SENSOR_PIN_ABFRAGEN    ; out temp
    ; Bit-7 (MSB)    
    rcall SENSOR_PIN_ABFRAGEN    ; out temp
    STS(adr_BIT_J),temp
    LSL temp
    ROL temp1
    ; Bit-6            
    rcall SENSOR_PIN_ABFRAGEN    ; out temp
    STS(adr_BIT_K),temp
    LSL temp
    ROL temp1
    ; Bit-5            
    rcall SENSOR_PIN_ABFRAGEN    ; out temp
    STS(adr_BIT_L),temp
    LSL temp
    ROL temp1
    ; Bit-4            
    rcall SENSOR_PIN_ABFRAGEN    ; out temp
    STS(adr_BIT_M),temp
    LSL temp
    ROL temp1
    ; Bit-3            
    rcall SENSOR_PIN_ABFRAGEN    ; out temp
    STS(adr_BIT_N),temp
    LSL temp
    ROL temp1
    ; Bit-2            
    rcall SENSOR_PIN_ABFRAGEN    ; out temp
    STS(adr_BIT_O),temp
    LSL temp
    ROL temp1
    ; Bit-1            
    rcall SENSOR_PIN_ABFRAGEN    ; out temp
    STS(adr_BIT_P),temp
    LSL temp
    ROL temp1
    ; Bit-0    (LSB)    
    rcall SENSOR_PIN_ABFRAGEN    ; out temp
    STS(adr_BIT_Q),temp
    LSL temp
    ROL temp1
    ; PARITY-BIT    
    rcall SENSOR_PIN_ABFRAGEN    ; out temp
    STS(adr_BIT_R),temp
;-------------------------------------------------------------------------------
    ; PARITÄTS-PRÜFUNG        
    mov temp6,temp1
    rcall BERECHNUNG_SENSOR_PARITAET    ; inp/out: temp6
    cp temp6,temp
    breq SENSOR_TSIC_ABFRAGEN_P2_OK
        
SENSOR_TSIC_ABFRAGEN_P2_OK:
;-------------------------------------------------------------------------------
    ; SENSOR-SPANNUNG aus    
//    rcall wait5ms
//    cbi (SENSOR_V_PORT),(SENSOR_V_PIN)
    ; ZWISCHENERGEBNIS        
    STS(adr_TEMPERATURDATEN_L),temp1
    STS(adr_TEMPERATURDATEN_H),temp2
    ; BERECHNUNG Temperatur    
    rcall SENSOR_BERECHNUNG
    ; BERECHNUNG OFFSET        
    rcall SENSOR_BERECHNUNG_OFFSET
    ; Temperatur speichern    
    STS(adr_TEMPERATUR_L),temp1
    STS(adr_TEMPERATUR_H),temp2
ret
; ##############################################################################
; ##############################################################################
; ##############################################################################
; nach einem Pegelwechsel suchen                                                
SENSOR_DATEN_SUCHEN:
    ; Schleifen-Initialisierung    
    ldi ZL,LOW (65535)
    ldi ZH,HIGH(65535)
    ; SCHLEIFE                    
SENSOR_DATEN_SUCHEN_L:
    sbiw ZL,1
    tst ZL
    brne SENSOR_DATEN_SUCHEN_L_W
    tst ZH
    brne SENSOR_DATEN_SUCHEN_L_W
    ; ERROR            
    clr temp
    ret
SENSOR_DATEN_SUCHEN_L_W:
    sbic (SENSOR_EINGANG_PORT),(SENSOR_EINGANG_PIN)        ; "skip if bit ..."
    rjmp SENSOR_DATEN_SUCHEN_L    
;-------------------------------------------------------------------------------
    ; Schleifen-Initialisierung    
    ldi ZL,LOW (65535)
    ldi ZH,HIGH(65535)
    ; SCHLEIFE                    
SENSOR_DATEN_SUCHEN_H:
    sbiw ZL,1
    tst ZL
    brne SENSOR_DATEN_SUCHEN_H_W
    tst ZH
    brne SENSOR_DATEN_SUCHEN_H_W
    ; ERROR            
    clr temp
    ret
SENSOR_DATEN_SUCHEN_H_W:
    sbis (SENSOR_EINGANG_PORT),(SENSOR_EINGANG_PIN)        ; "skip if bit ..."
    rjmp SENSOR_DATEN_SUCHEN_H    
;-------------------------------------------------------------------------------
    ; Freigabe        
    ldi temp,1
ret
; ##############################################################################
; ##############################################################################
; ##############################################################################
; warten auf Sendepause des Sensors (ca.40ms)                                    
; hiermit kann die Zeit der Interruptsperrung verkürzt werden                    
SENSOR_PAUSE_SUCHEN:
    ldi ZL,LOW (2500)
    ldi ZH,HIGH(2500)
SENSOR_PAUSE_SUCHEN_s:
    ; Warteschleife, wenn PIN "LOW" ist            
    sbis (SENSOR_EINGANG_PORT),(SENSOR_EINGANG_PIN)       ; "skip if bit ..."    
    rjmp SENSOR_PAUSE_SUCHEN
    dec ZL
    brne SENSOR_PAUSE_SUCHEN_s
    dec ZH
    brne SENSOR_PAUSE_SUCHEN_s
ret
; ##############################################################################
; ##############################################################################
; ##############################################################################
; INP: temp8 (STROBE)                                                             
; OUT: temp + temp9(Impulslänge)                                                
SENSOR_PIN_ABFRAGEN:
    clr temp9
SENSOR_PIN_ABFRAGEN_S:
    ; Warteschleife, wenn PIN "HIGH" ist            
    sbic (SENSOR_EINGANG_PORT),(SENSOR_EINGANG_PIN)        ; "skip if bit ..."
    rjmp SENSOR_PIN_ABFRAGEN_S

SENSOR_PIN_ABFRAGEN_Z:
    ; Warteschleife, wenn PIN "LOW" ist            
    inc temp9                     ; ZÄHLER+1
    sbis (SENSOR_EINGANG_PORT),(SENSOR_EINGANG_PIN)        ; "skip if bit ..."    
    rjmp SENSOR_PIN_ABFRAGEN_Z

    ; VERGLEICH    mit STROBE-WERT                    
    cp temp9,temp8
    brlo SENSOR_LOGIC_HIGH

SENSOR_LOGIC_LOW:
    clr temp
    ret
SENSOR_LOGIC_HIGH:
    ldi temp,255
ret
; ##############################################################################
; ##############################################################################
; ##############################################################################
; INP: temp1 + temp2                                                            
; OUT: temp1 + temp2                                                            
;===============================================================================
; BERECHNUNG der Temperatur aus den Temperaturdaten                                
; Formel:    °C = WERT x 2000/2048-500                                            
;    -50°C       0 (0x000)                                                        
;    -10°C     409 (0x199)                                                        
;      0°C     512 (0x200)                                                        
;     25°C     767 (0x2FF)                                                        
;     60°C    1125 (0x465)                                                        
;    125°C    1790 (0x6FE)                                                        
;    150°C    2047 (0x7FF)                                                        
SENSOR_BERECHNUNG:
    clr temp3
    mov temp4,temp1
    mov temp5,temp2
    clr temp6
    ; x 2000                    
    ldi ZL,LOW (125-1)
    ldi ZH,HIGH(125-1)
SENSOR_BERECHNUNG_SCHLEIFE:
    add temp1,temp4
    adc temp2,temp5
    adc temp3,temp6
    sbiw ZL,1
    tst ZL
    brne SENSOR_BERECHNUNG_SCHLEIFE
    tst ZH
    brne SENSOR_BERECHNUNG_SCHLEIFE
    ; :2048        
    mov temp4, temp1
    mov temp5, temp2
    mov temp6, temp3
lsl temp1
lsl temp2
lsl temp3
sbrc temp4, 7
add temp2, EINS
sbrc temp5, 7
add temp3, EINS

    mov temp1,temp2    ; :256
    mov temp2,temp3
                    
    ; -500                        
    ldi temp3,low (-500)
    ldi temp4,high(-500)
    add temp1,temp3
    adc temp2,temp4
ret
; ##############################################################################
; ##############################################################################
; ##############################################################################
; Temperaturoffset                                                                
; INP: temp1 + temp2                                                            
; OUT: temp1 + temp2                                                            
SENSOR_BERECHNUNG_OFFSET:
    ldi temp3,LOW (SENSOR_OFFSET)
    ldi temp4,HIGH(SENSOR_OFFSET)
    add temp,temp3
    adc temp2,temp4    
ret
; ##############################################################################
; ##############################################################################
; ##############################################################################
; INP: temp6                                                                    
; OUT: temp6                                                                    
BERECHNUNG_SENSOR_PARITAET:
    push temp    ; sichern            
    clr temp    

    ; 1xrechts ==> Carry rollt raus
    LSR temp6
    rcall BERECHNUNG_SENSOR_PARITAET_Z
    LSR temp6
    rcall BERECHNUNG_SENSOR_PARITAET_Z
    LSR temp6
    rcall BERECHNUNG_SENSOR_PARITAET_Z
    LSR temp6
    rcall BERECHNUNG_SENSOR_PARITAET_Z
    LSR temp6
    rcall BERECHNUNG_SENSOR_PARITAET_Z
    LSR temp6
    rcall BERECHNUNG_SENSOR_PARITAET_Z
    LSR temp6
    rcall BERECHNUNG_SENSOR_PARITAET_Z
    LSR temp6
    rcall BERECHNUNG_SENSOR_PARITAET_Z
    ; Bitmuster     
    andi temp,0b00000001
    ; gleich NULL ?    
    tst temp
    brne BERECHNUNG_SENSOR_PARITAET_1
BERECHNUNG_SENSOR_PARITAET_0:
    ; Ergebnis         
    ldi temp6,0
    pop temp ; wieder herstellen    
    ret
BERECHNUNG_SENSOR_PARITAET_1:
    ; Ergebnis         
    ldi temp6,255
    pop temp ; wieder herstellen    
    ret
;-------------------------------------------------------------------------------
BERECHNUNG_SENSOR_PARITAET_Z:
    brcs BERECHNUNG_SENSOR_PARITAET_ZZ
    ret
BERECHNUNG_SENSOR_PARITAET_ZZ:
    ; Carrys zählen    
    inc temp
ret
; ##############################################################################
; ##############################################################################
; ##############################################################################

