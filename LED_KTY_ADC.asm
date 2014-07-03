; ##############################################################################
; ##############################################################################
; ##############################################################################
;														
; ADC initialisieren mit "Free Run" und Vorteiler		
;														
; 	ADEN: ADC Enable                             		
; 	ADSC: ADC Start Conversion                   		
; 	ADFR: ADC Free Running Select                		
; 	ADIF: ADC Interrzpt Flag                     		
; 	ADIE: ADC Interrupt Enable                   		
; 	ADPS2: Vorteiler                             		
; 	ADPS2: Vorteiler                             		
; 	ADPS2: Vorteiler                             		
;														
;	ADPS2 ADPS1 ADPS0 Division Factor					
;	0 		0 	0 		2								
;	0 		0 	1 		2								
;	0 		1 	0 		4								
;	0 		1 	1 		8								
;	1 		0 	0 		16								
;	1 		0 	1	 	32								
; *	1 		1 	0 		64								
;	1 		1 	1 		128								
;														
ADC_INITIALISIERUNG:
	ldi temp, ((1<<ADEN)|(1<<ADSC)|(1<<ADPS2)|(1<<ADPS1)|(1<<ADPS0) | (1<<ADATE)) // ??? |(1<<ADFR)
	output ADCSRA, temp
ldi temp , 0xFF
output didr0, temp

		ldi temp, (1<<REFS1)|(1<<REFS0) //
	output ADMUX, temp
ret
; ##############################################################################
; ##############################################################################
; ##############################################################################
;																					
; ADC REFERENZ																		
;																					
; REFS1 REFS0 Voltage Reference Selection											
;  0     0    AREF, Internal Vref turned off										
;  0     1    AVCC with external capacitor at AREF pin								
; *1     1    Internal 2.56V Voltage Reference with external capacitor at AREF pin	
ADC_REFERENZ_ON:
	ldi temp, (1<<REFS1)|(1<<REFS0)
	sts ADMUX, temp
ret
; ##############################################################################
; ##############################################################################
; ##############################################################################
ADC_REFERENZ_OFF:
//ldi temp
	sts ADMUX, NULL
ret
; ##############################################################################
; ##############################################################################
; ##############################################################################
; 																				
; Canal 0																		
MESSEN_0:

	lds temp, ADMUX
	andi temp, 0b11100000
	subi temp, 0			; KANAL 0	
	sts ADMUX, temp

	rcall MESSEN			; OUT: temp / TEMP2	

	; OFFSET
	ldi ZL, low(-3) ; "-3"
	ldi ZH,high(-3)
	add temp,ZL
	adc	temp2,ZH

	STS(adr_ADC_0_L),temp	; in SRAM speichern		
	STS(adr_ADC_0_H),temp2	; in SRAM speichern		

	; Umwandlung	
//	rcall FUNKTION_KTY81_122_1400OHM
	; SPEICHERN		
// 	STS(adr_TEMPERATUR_KTY_L),temp	; in SRAM speichern		
//	STS(adr_TEMPERATUR_KTY_H),temp2	; in SRAM speichern		
ret
; ##############################################################################
; ##############################################################################
; ##############################################################################
; 																				
; Canal 1																		
MESSEN_1:
	lds temp, ADMUX
	andi temp, 0b11100000
	subi temp, -1			; KANAL 1	
	sts ADMUX, temp

	rcall MESSEN			; OUT: temp / TEMP2	

	STS(adr_ADC_1_L),temp	; in SRAM speichern		
	STS(adr_ADC_1_H),temp2	; in SRAM speichern		
ret
; ##############################################################################
; ##############################################################################
; ##############################################################################
; 																				
; Canal 2																		
MESSEN_2:
	lds temp, ADMUX
	andi temp, 0b11100000
	subi temp, -2			; KANAL 2	
	sts ADMUX, temp

	rcall MESSEN			; OUT: temp / TEMP2	

	STS(adr_ADC_2_L),temp	; in SRAM speichern		
	STS(adr_ADC_2_H),temp2	; in SRAM speichern		
ret
; ##############################################################################
; ##############################################################################
; ##############################################################################
; 																				
; Canal 3																		
MESSEN_3:
	lds temp, ADMUX
	andi temp, 0b11100000
	subi temp, -3			; KANAL 3	
	sts ADMUX, temp

	rcall MESSEN			; OUT: temp / TEMP2	

	STS(adr_ADC_3_L),temp	; in SRAM speichern		
	STS(adr_ADC_3_H),temp2	; in SRAM speichern		
ret
; ##############################################################################
; ##############################################################################
; ##############################################################################
; 																				
; Canal 4																		
; KTY81-22 																		
MESSEN_4:
	lds temp, ADMUX
	andi temp, 0b11100000
	subi temp, -4			; KANAL 4	
	sts ADMUX, temp

	rcall MESSEN			; OUT: temp / TEMP2	

	STS(adr_ADC_4_L),temp	; in SRAM speichern		
	STS(adr_ADC_4_H),temp2	; in SRAM speichern		
ret
; ##############################################################################
; ##############################################################################
; ##############################################################################
; 																				
; Canal 5																		
MESSEN_5:
	lds temp, ADMUX
	andi temp, 0b11100000
	subi temp, -5			; KANAL 5	
	sts ADMUX, temp

	rcall MESSEN			; OUT: temp / TEMP2	


	STS(adr_ADC_5_L),temp	; in SRAM speichern		
	STS(adr_ADC_5_H),temp2	; in SRAM speichern		
ret
; ##############################################################################
; ##############################################################################
; ##############################################################################
; 																				
; Canal 6																		
MESSEN_6:
	lds temp, ADMUX
	andi temp, 0b11100000
	subi temp, -6			; KANAL 6	
	sts ADMUX, temp

	rcall MESSEN			; OUT: temp / TEMP2	


	STS(adr_ADC_6_L),temp	; in SRAM speichern		
	STS(adr_ADC_6_H),temp2	; in SRAM speichern		
ret
; ##############################################################################
; ##############################################################################
; ##############################################################################
; 																				
; Canal 7																		
MESSEN_7:
	lds temp, ADMUX
	andi temp, 0b11100000
	subi temp, -7			; KANAL 7	
	sts ADMUX, temp

	rcall MESSEN			; OUT: temp / TEMP2	


	STS(adr_ADC_7_L),temp	; in SRAM speichern		
	STS(adr_ADC_7_H),temp2	; in SRAM speichern		
ret
; ##############################################################################
; ##############################################################################
; ##############################################################################
; ADC-WERT 256 mal einlesen und daraus den Mittelwert bilden					
;																				
; OUT: 	temp (low)  															
;		TEMP2																	
; 																				
MESSEN:
	push temp3					; HILFSREGISTER sichern			
	push temp4
	push temp5
	push temp6
	push temp8
;--------------------------------------------------------------------------
	
	; HILFSREGISTER CLEAR			
	clr temp3					
	clr temp4
	clr temp5
	clr temp6

	; SCHLEIFE initialisieren		
	clr temp8
	
; neuen ADC-Wert lesen	 Wert verwerfen, da meist vom vorherigem ADC-Kanal
lds temp, 	ADCSRA
	sbr temp, ADIF  
	output ADCSRA, temp  		; logisch "1" löscht ADIF flag !
MESSEN_w:                  
inpu temp, ADCSRA
    sbrc    temp, ADIF			; warten bis ADIF flag gesetzt	
	rjmp MESSEN_w

; neuen ADC-Wert lesen	(Schleife - 256 mal)
;ldi temp8, 100								
MESSEN_SCHLEIFE:              
lds temp, 	ADCSRA
	sbr temp, ADIF  
	output ADCSRA, temp    		; logisch "1" löscht ADIF flag !
MESSEN_SCHLEIFE_w:                
inpu temp, ADCSRA
    sbrc    temp, ADIF		; warten bis ADIF flag gesetzt	
	rjmp MESSEN_SCHLEIFE_w
; ADC einlesen:																
	lds  temp, ADCL 			; immer zuerst LOW Byte lesen
	lds  temp2, ADCH 			; danach das mittlerweile gesperrte High Byte

  /*  ldi     temp, (1<<ADEN) | (1<<ADPS2) | (1<<ADPS1) | (1<<ADPS0)
    output     ADCSRA, temp

inpu temp, ADCSRA
sbr temp,ADSC
output ADCSRA, temp 
 //sbi     ADCSRA, ADSC 


wait_adc:
inpu temp, ADCSRA
    sbrc    temp, ADSC        ; wenn der ADC fertig ist, wird dieses Bit gelöscht
	rjmp    wait_adc
	
	inpu      temp, ADCL         ; immer zuerst LOW Byte lesen
    inpu      temp2, ADCH  */     ; danach das mittlerweile gesperrte High Byte
    

/*	add     temp3, temp       ; addieren
    adc     temp4, temp2      ; addieren über Carry
	
    adc     temp5, r5      ; addieren über Carry, temp1 enthält 0
    dec     messungen           ; Schleifenzähler MINUS 1
    brne    sample_adc          ; wenn noch keine 256 ADC Werte -> nächsten Wert einlesen

mov     temp, temp4
    mov     temp2, temp5
	ldi temp3, 14
	ldi temp4, 0

clr temp2*/


; alle 256 ADC-Werte addieren												
//	add temp4,temp     		; addieren  						
//	adc temp5,temp2     		; addieren über Carry  				
//	adc temp6,NULL  	 		; addieren über Carry  				

//	dec temp8			 		; Schleifenzähler MINUS 1			
//	brne MESSEN_SCHLEIFE 		; ==> SCHLEIFE						

; MITTELWERT-BERECHNUNG	(128 addieren)										
//	ldi temp,128
//	add temp4,temp	     		; addieren  						
//	adc temp5,NULL	     		; addieren über Carry  				
//	adc temp6,NULL    	 		; addieren über Carry  				

; 	Ergebnis durch 256 teilen (temp5+6 nach temp+2 kopieren)				
//	mov temp,temp5
//	mov temp2,temp6


;--------------------------------------------------------------------------
	pop temp8					; Hilfsregister wieder herstellen	
	pop temp6
	pop temp5
	pop temp4
	pop temp3
ret
; ##############################################################################
; ##############################################################################
; ##############################################################################
; KTY81-122 mit 1,4k gegen Uref	(Stand 23.05.2011)								
FUNKTION_KTY81_122_1400OHM:
	; 379 subtrahieren	
	ldi ZL,low (-379)
	ldi ZH,high(-379)
	add temp,ZL
	adc	temp2,ZH
 	; ist negativ ?
 	tst temp2
 	brmi FUNKTION_KTY81_122_1400OHM_NEG
 
 	; x 10 (9xaddieren)	
	mov ZL,temp
	mov ZH,temp2

	add temp,ZL	; 1
	adc temp2,ZH
	add temp,ZL	; 
	adc temp2,ZH
	add temp,ZL	; 
	adc temp2,ZH
	add temp,ZL	; 
	adc temp2,ZH
	add temp,ZL	; 
	adc temp2,ZH
	add temp,ZL	; 
	adc temp2,ZH
	add temp,ZL	; 
	adc temp2,ZH
	add temp,ZL	; 
	adc temp2,ZH
	add temp,ZL	; 
	adc temp2,ZH
	; durch 2
	LSR temp2	; :2
	ROR temp
	ret

FUNKTION_KTY81_122_1400OHM_NEG:
	; invertieren		
	com temp 
	com temp2
	add temp,EINS 
	adc temp2,NULL
 	; x 10 (9xaddieren)	
	mov ZL,temp
	mov ZH,temp2

	add temp,ZL	; 1
	adc temp2,ZH
	add temp,ZL	; 
	adc temp2,ZH
	add temp,ZL	; 
	adc temp2,ZH
	add temp,ZL	; 
	adc temp2,ZH
	add temp,ZL	; 
	adc temp2,ZH
	add temp,ZL	; 
	adc temp2,ZH
	add temp,ZL	; 
	adc temp2,ZH
	add temp,ZL	; 
	adc temp2,ZH
	add temp,ZL	; 
	adc temp2,ZH
	; durch 2
	LSR temp2	; :2
	ROR temp
	; invertieren		
	com temp 
	com temp2
	add temp,EINS 
	adc temp2,NULL

ret

;######################################################################## 	
;########################################################################	
;######################################################################## 	
; INP: temp3																
; OUT: temp3+2 (z.B."FF") 		!!!Achtung Rückwärts, erst temp3, dann temp2!!!											
FUNKTION_HEX:
	; SICHERUNGSKOPIE						
	push temp
	; 1-er STELLE		
	mov temp2,temp3
	mov temp,temp3	

	rcall FUNKTION_HEX_UMWANDLUNG
	mov temp3,temp
	; 10-er STELLE		
	mov temp,temp2	
	; NIBBLES tausch	
	swap temp
	rcall FUNKTION_HEX_UMWANDLUNG
	mov temp2,temp
	; SICHERUNGSKOPIE wieder herstellen		
	pop temp
	ret
;-------------------------------------------------------------------------------
FUNKTION_HEX_UMWANDLUNG:
	; BITMUSTER	
	andi temp,0b00001111
	; vergleich	
	cpi temp,0
	breq FUNKTION_HEX_0
	cpi temp,1
	breq FUNKTION_HEX_1
	cpi temp,2
	breq FUNKTION_HEX_2
	cpi temp,3
	breq FUNKTION_HEX_3
	cpi temp,4
	breq FUNKTION_HEX_4
	cpi temp,5
	breq FUNKTION_HEX_5
	cpi temp,6
	breq FUNKTION_HEX_6
	cpi temp,7
	breq FUNKTION_HEX_7
	cpi temp,8
	breq FUNKTION_HEX_8
	cpi temp,9
	breq FUNKTION_HEX_9
	cpi temp,10
	breq FUNKTION_HEX_A
	cpi temp,11
	breq FUNKTION_HEX_B
	cpi temp,12
	breq FUNKTION_HEX_C
	cpi temp,13
	breq FUNKTION_HEX_D
	cpi temp,14
	breq FUNKTION_HEX_E
	cpi temp,15
	breq FUNKTION_HEX_F

FUNKTION_HEX_0:
	ldi temp,'0'
	ret
FUNKTION_HEX_1:
	ldi temp,'1'
	ret
FUNKTION_HEX_2:
	ldi temp,'2'
	ret
FUNKTION_HEX_3:
	ldi temp,'3'
	ret
FUNKTION_HEX_4:
	ldi temp,'4'
	ret
FUNKTION_HEX_5:
	ldi temp,'5'
	ret
FUNKTION_HEX_6:
	ldi temp,'6'
	ret
FUNKTION_HEX_7:
	ldi temp,'7'
	ret
FUNKTION_HEX_8:
	ldi temp,'8'
	ret
FUNKTION_HEX_9:
	ldi temp,'9'
	ret
FUNKTION_HEX_A:
	ldi temp,'A'
	ret
FUNKTION_HEX_B:
	ldi temp,'B'
	ret
FUNKTION_HEX_C:
	ldi temp,'C'
	ret
FUNKTION_HEX_D:
	ldi temp,'D'
	ret
FUNKTION_HEX_E:
	ldi temp,'E'
	ret
FUNKTION_HEX_F:
	ldi temp,'F'
ret
; ##############################################################################
; ##############################################################################
; ##############################################################################
