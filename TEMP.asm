Read 10, temp8

cpi temp8, '1'
brne over7
// 1 AN
rcall ADC_INITIALISIERUNG
rcall ADC_REFERENZ_ON

Ausgeben 15
rjmp end_order
over7:
cpi temp8, '0'
brne over7_0
// 1 AUS
rcall ADC_REFERENZ_OFF

Ausgeben 15
rjmp end_order
over7_0:

// Fehler
Ausgeben 29
