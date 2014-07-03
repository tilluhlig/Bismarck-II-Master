.MACRO Read ; Position, Ziel (ohne 48/49 abziehen)
ldi     zl,low(INPUT);            
ldi     zh,high(INPUT);
ldi @1, @0
add zl, @1
adc zh,NULL
ld @1, Z+
.ENDMACRO

.MACRO Read3 ; Position, Ziel, temp, temp2
ldi @1, 0 // Ergebnis 0 - 255
ldi     zl,low(INPUT);            
ldi     zh,high(INPUT);
addi zl, @0
adc zh,NULL
ld @2, Z+
subi @2, 48
ldi @3, 100
mul @2, @3
add @1, r0
ld @2, Z+
subi @2, 48
ldi @3, 10
mul @2, @3
add @1, r0
ld @2, Z+
subi @2, 48
add @1, @2
.ENDMACRO

.MACRO Read2 ; Position, Ziel, temp, temp2
ldi @1, 0 // Ergebnis 0 - 99
ldi     zl,low(INPUT);            
ldi     zh,high(INPUT);
addi zl, @0
adc zh,NULL
ld @2, Z+
subi @2, 48
ldi @3, 10
mul @2, @3
add @1, r0
ld @2, Z+
subi @2, 48
add @1, @2
.ENDMACRO

.MACRO addi ;zl, 12
//subi @0, -@1
push temp
ldi temp, @1
add @0, temp
pop temp
.ENDMACRO

.MACRO Zwischen ; Register, Von, Bis, Fehlercode
cpi @0, @1
brge ok
Ausgeben @3
rjmp end_order
ok:
cpi @0, @2+1
brlo ok2
Ausgeben @3
rjmp end_order
ok2:
.ENDMACRO

.MACRO Ausgeben ; Fehldercode
ldi temp8, @0
rcall add_antwort_send
.ENDMACRO
