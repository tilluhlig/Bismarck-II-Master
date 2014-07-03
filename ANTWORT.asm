Read 8, temp8

cpi temp8, '1'
brne over19
// 1 AN
sts ANTWORT, EINS

Ausgeben 19
rjmp end_order
over19:
cpi temp8, '0'
brne over19_0
// 1 AUS
sts ANTWORT, NULL

Ausgeben 19
rjmp end_order
over19_0:

// Fehler
Ausgeben 29
