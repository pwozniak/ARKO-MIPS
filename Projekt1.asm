# (C) by Piotr Woźniak
# Cieniowanie trójkąta

.data

intro: .ascii "Cieniowanie trojkata algorytmem Gourauda\n"
       .asciiz "Wprowadz dane dla 3 wierzcholkow:\n"
un: .asciiz "1.\n"
deux: .asciiz "2.\n"
trois: .asciiz "3.\n"
out1: .asciiz "Wprowadz wspolrzedne wierzcholka\nX: "
out2: .asciiz "Y: "
out3: .asciiz "Wprowadz kolor\nR: "
out4: .asciiz "G: "
out5: .asciiz "B: "
X1: .word 0
Y1: .word 0
adres1: .word 0
X2: .word 0
Y2: .word 0
adres2: .word 0
X3: .word 0
Y3: .word 0
adres3: .word 0
kolor1: .word 0
kolor2: .word 0
kolor3: .word 0
dx1: .word 0
dx2: .word 0
dx3: .word 0
dr1: .word 0
dg1: .word 0
db1: .word 0
dr2: .word 0
dg2: .word 0
db2: .word 0
dr3: .word 0
dg3: .word 0
db3: .word 0
dr: .word 0
dg: .word 0
db: .word 0
S1: .word 0
S2: .word 0
S3: .word 0
Sx: .word 0 # przyrost
Sr: .word 0# przyrost
Sg: .word 0# przyrost
Sb: .word 0# przyrost
Ex: .word 0# przyrost
Er: .word 0# przyrost
Eg: .word 0# przyrost
Eb: .word 0# przyrost
Pr: .word 0# przyrost
Pg: .word 0# przyrost
Pb: .word 0# przyrost
plik: .asciiz "/home/users/pwoznia1/Dokumenty/ARKO/Beztytulu.bmp"
wynikowy: .asciiz "/home/users/pwoznia1/Dokumenty/ARKO/cieniowanie.bmp"
naglowek: .space 54
obrazek: .space 180000

.macro wspolrzedne (%x, %y, %Vx, %Vy, %adres)
nowalinia:
beq %y, %Vy, vertex
addu %adres, %adres, $s4
addiu %y, %y, 1
j nowalinia

vertex:
beq %x, %Vx, end
addiu %x, %x, 1
addiu %adres, %adres, 3
j vertex

end:
nop

.end_macro

.macro koloruj (%r, %g, %b, %adres)
sb %b, (%adres)
addiu %adres, %adres, 1
sb %g, (%adres)
addiu %adres, %adres, 1
sb %r, (%adres)
addiu %adres, %adres, 1
.end_macro

.macro odcinek (%BEGINx, %ENDx, %linenr, %x, %y, %adres, %r, %g, %b)
oddo:
wspolrzedne (%x, %y, %BEGINx, %linenr, %adres)
move $a3, %adres
wspolrzedne (%x, %y, %ENDx, %linenr, %adres)

loop:
beq $a3, %adres, end
koloruj (%r, %g, %b, $a3)

lw $s5, dr
lw $a0, Pr
lw $t4, Sr
add $a0, $a0, $s5
srl $a1, $a0, 8
add %r, $t4, $a1
sw $a0, Pr
li $a1, 0

lw $s5, dg
lw $a0, Pg
lw $t4, Sg
add $a0, $a0, $s5
srl $a1, $a0, 8
add %g, $t4, $a1
sw $a0, Pg
li $a1, 0

lw $s5, db
lw $a0, Pb
lw $t4, Sb
add $a0, $a0, $s5
srl $a1, $a0, 8
add %b, $t4, $a1
sw $a0, Pb
li $a1, 0

j loop

end:
koloruj (%r, %g, %b, %adres)

subu %adres, %adres, 3
li $a3, 0
mulu %x, %x, 3
subu %adres, %adres, %x
addu %adres, %adres, $s4
li %x, 0
addiu %y, %y, 1
.end_macro

.macro deltas (%sx, %ex, %sr, %sg, %sb, %er, %eg, %eb)
if:
sub $s0, %ex, %sx
bgtz $s0, drgb
li $a1, 0
li $a2, 0
li $a3, 0
j end

drgb:
sub $a1, %er, %sr
abs $a1, $a1
sll $a1, $a1, 8
div $a1, $a1, $s0
sw $a1, dr

sub $a2, %eg, %sg
abs $a2, $a2
sll $a2, $a2, 8
div $a2, $a2, $s0
sw $a2, dg

sub $a3, %eb, %sb
abs $a3, $a3
sll $a3, $a3, 8
div $a3, $a3, $s0
sw $a3, db

end:
nop
.end_macro

.text

wczytajplik:
li $v0, 13
la $a0, plik
li $a1, 0
li $a2, 0
syscall

move $s0, $v0
li $v0, 14
move $a0, $s0
la $a1, naglowek
li $a2, 54
syscall

la $t0, naglowek
ulw $s4, 18($t0)
mulu $s4, $s4, 3

li $v0, 14
move $a0, $s0
la $a1, obrazek
li $a2, 180000
syscall

move $s1, $v0
la $t1, obrazek

li $v0, 16
syscall

li $t8, 0
li $t9, 0

main:
li $v0, 4
la $a0, intro
syscall

li $v0, 4
la $a0, un
syscall

jal wczytajdane

sb $t4, kolor1
sb $t5, kolor1+1
sb $t6, kolor1+2
sw $t2, X1
sw $t3, Y1
subu $t1, $t1, 3
sw $t1, adres1

li $t8, 0
li $t9, 0
la $t1, obrazek

li $v0, 4
la $a0, deux
syscall

jal wczytajdane

sb $t4, kolor2
sb $t5, kolor2+1
sb $t6, kolor2+2
sw $t2, X2
sw $t3, Y2
subu $t1, $t1, 3
sw $t1, adres2

li $t8, 0
li $t9, 0
la $t1, obrazek

li $v0, 4
la $a0, trois
syscall

jal wczytajdane

sb $t4, kolor3
sb $t5, kolor3+1
sb $t6, kolor3+2
sw $t2, X3
sw $t3, Y3
subu $t1, $t1, 3
sw $t1, adres3

li $t8, 0
li $t9, 0
la $t1, obrazek

j trojkat


wczytajdane:
li $v0, 4
la $a0, out1
syscall

li $v0, 5
syscall
move $t2, $v0

li $v0, 4
la $a0, out2
syscall

li $v0, 5
syscall
move $t3, $v0

wczytajkolor:
li $v0, 4
la $a0, out3
syscall
li $v0, 5
syscall
move $t4, $v0
li $v0, 4
la $a0, out4
syscall
li $v0, 5
syscall
move $t5, $v0
li $v0, 4
la $a0, out5
syscall
li $v0, 5
syscall
move $t6, $v0

putpixel:
wspolrzedne ($t8, $t9, $t2, $t3, $t1)
koloruj ($t4, $t5, $t6, $t1)
jr $ra

trojkat:
lw $t7, Y1 # A Y
lw $t8, Y2 # B Y
lw $t9, Y3 # C Y
lw $t1, X1 # A X
lw $t2, X2 # B X
lw $t3, X3 # C X
lb $t4, kolor1 # A R
lb $t5, kolor1+1 # A G
lb $t6, kolor1+2 # A B
lb $a0, kolor2 # B R
lb $a1, kolor2+1 # B G
lb $a2, kolor2+2 # B B
lb $s1, kolor3 # C R
lb $s2, kolor3+1 # C G
lb $s3, kolor3+2 # C B

j deltyABC

sortuj:
bleu $t7, $t8, sortujAB
bgt $t7, $t8, sortujBA
bleu $t9, $t8, sortujCB
bgt $t9, $t8, sortujBC

sortujAB:
bleu $t9, $t7, deltyCAB
bleu $t8, $t9, deltyABC

sortujBA:
bleu $t9, $t8, deltyCBA
bleu $t7, $t9, deltyBAC

sortujCB:
bleu $t7, $t9, deltyACB

sortujBC:
bleu $t9, $t7, deltyBCA

deltyCAB:
sub $t4, $t7, $t9 # A-C
sub $t5, $t8, $t9 # B-C
sub $t6, $t8, $t7 # B-A


deltyABC:
lw $t0, adres1
sub $a0, $a0, $t4 # B-A R
sub $a1, $a1, $t5 # B-A G
sub $a2, $a2, $t6 # B-A B
sub $s1, $s1, $t4 # C-A R
sub $s2, $s2, $t5 # C-A G
sub $s3, $s3, $t6 # C-A B
sub $t4, $t8, $t7 # B-A Y
sub $t5, $t9, $t7 # C-A Y
sub $t6, $t9, $t8 # C-B Y
sub $s5, $t2, $t1 # B-A X
sub $s6, $t3, $t1 # C-A X
sub $s7, $t3, $t2 # C-B X
bgtz $t4, Delta1
li $s5, 0
bgtz $t5, Delta2
li $s6, 0
bgtz $t6, Delta3
li $s7, 0
j trianglefill

deltyCBA:
sub $t4, $t8, $t9 # B-C
sub $t5, $t7, $t9 # A-C
sub $t6, $t7, $t8 # A-B



deltyBAC:
sub $t4, $t7, $t8 # A-B
sub $t5, $t9, $t8 # C-B
sub $t6, $t9, $t7 # C-A



deltyACB:
sub $t4, $t9, $t7 # C-A
sub $t5, $t8, $t7 # B-A
sub $t6, $t8, $t9 # B-C



deltyBCA:
sub $t4, $t9, $t8 # C-B
sub $t5, $t7, $t8 # A-B
sub $t6, $t7, $t9 # A-C



Delta1:
abs $s5, $s5
sll $s5, $s5, 8
sll $a0, $a0, 8
sll $a1, $a1, 8
sll $a2, $a2, 8
div $s5, $s5, $t4 # dx1
div $a0, $a0, $t4
div $a1, $a1, $t4
div $a2, $a2, $t4
sw $a1, dr1
sw $a2, dg1
sw $a3, db1
sw $s5, dx1
bgtz $t5, Delta2
li $s6, 0
bgtz $t6, Delta3
li $s7, 0
j trianglefill

Delta2:
abs $s6, $s6
sll $s1, $s1, 8
sll $s2, $s2, 8
sll $s3, $s3, 8
sll $s6, $s6, 8
div $s6, $s6, $t5 # dx2
div $s1, $s1, $t5
div $s2, $s2, $t5
div $s3, $s3, $t5
sw $s1, dr2
sw $s2, dg2
sw $s3, db2
sw $s6, dx2
bgtz $t6, Delta3
li $s7, 0
j trianglefill

Delta3:
lb $s1, kolor3 # C R
lb $s2, kolor3+1 # C G
lb $s3, kolor3+2 # C B
lb $a0, kolor2 # B R
lb $a1, kolor2+1 # B G
lb $a2, kolor2+2 # B B
sub $s1, $s1, $a0 # C-B R
sub $s2, $s2, $a1 # C-B G
sub $s3, $s3, $a2 # C-B B
abs $s7, $s7
sll $s7, $s7, 8
sll $s1, $s1, 8
sll $s2, $s2, 8
sll $s3, $s3, 8
div $s7, $s7, $t6 # dx3
div $s1, $s1, $t6 # 
div $s2, $s2, $t6 # 
div $s3, $s3, $t6 # 
sw $s1, dr3
sw $s2, dg3
sw $s3, db3
sw $s7, dx3

trianglefill:
lw $t4, X1 # S.x=A.x
move $t2, $t4 # S.x dynamiczne
move $t3, $t4 # E.x dynamiczne
lw $t6, Y1 # line number : S.y=E.y=A.y
lb $s1, kolor1 # R
lb $s2, kolor1+1 # G
lb $s3, kolor1+2 # B
li $a0, 0
li $a1, 0
li $a2, 0
li $a3, 0
bgt $s5, $s6, trojkatAB
beq $t7, $t8, trojkatAB
move $t5, $s1
move $s6, $s2
move $s7, $s3
j trojkatAB2

trojkatAB:
move $t5, $s1
move $s6, $s2
move $s7, $s3

trojkatAB1:
beq $t6, $t8, trojkatBC1
deltas ($t2, $t3, $s1, $s2, $s3, $t5, $s6, $s7)

sw $s1, S1
sw $s2, S2
sw $s3, S3
odcinek ($t2, $t3, $t6, $t1, $t7, $t0, $s1, $s2, $s3)
lw $s1, S1
lw $s2, S2
lw $s3, S3

lw $s5, dx2
lw $a0, Sx
lw $t4, X1 # A.x
add $a0, $a0, $s5
srl $a1, $a0, 8
add $t2, $t4, $a1
sw $a0, Sx
li $a1, 0

lw $s5, dx1
lw $a0, Ex
lw $t4, X1
add $a0, $a0, $s5
srl $a1, $a0, 8
add $t3, $t4, $a1
sw $a0, Ex
li $a1, 0

lw $s5, dr2
lw $a0, Sr
lb $t4, kolor1 # A.r
add $a0, $a0, $s5
sra $a1, $a0, 8
add $s1, $t4, $a1
sw $a0, Sr
li $a1, 0

lw $s5, dg2
lw $a0, Sg
lb $t4, kolor1+1
add $a0, $a0, $s5
sra $a1, $a0, 8
add $s2, $t4, $a1
sw $a0, Sg
li $a1, 0

lw $s5, db2
lw $a0, Sb
lb $t4, kolor1+2
add $a0, $a0, $s5
sra $a1, $a0, 8
add $s3, $t4, $a1
sw $a0, Sb
li $a1, 0

lw $s5, dr1
lw $a0, Er
lb $t4, kolor1
add $a0, $a0, $s5
sra $a1, $a0, 8
add $t5, $t4, $a1
sw $a0, Er
li $a1, 0

lw $s5, dg1
lw $a0, Eg
lb $t4, kolor1+1
add $a0, $a0, $s5
sra $a1, $a0, 8
add $s6, $t4, $a1
sw $a0, Eg
li $a1, 0

lw $s5, db1
lw $a0, Eb
lb $t4, kolor1+2
add $a0, $a0, $s5
sra $a1, $a0, 8
add $s7, $t4, $a1
sw $a0, Eb
li $a1, 0

addiu $t6, $t6, 1
j trojkatAB1

trojkatBC1:
lw $t3, X2 # E.x=B.x
lw $t6, Y2
li $a2, 0
li $a3, 0
lb $t5, kolor2
lb $s6, kolor2+1
lb $s7, kolor2+2
sw $zero, Ex
sw $zero, Er
sw $zero, Eg
sw $zero, Eb

trojkatBC1loop:
beq $t6, $t9, zapisz
deltas ($t2, $t3, $s1, $s2, $s3, $t5, $s6, $s7)

sw $s1, S1
sw $s2, S2
sw $s3, S3
odcinek ($t2, $t3, $t6, $t1, $t7, $t0, $s1, $s2, $s3)
lw $s1, S1
lw $s2, S2
lw $s3, S3

lw $s5, dx2
lw $a0, Sx
lw $t4, X1 # A.x
add $a0, $a0, $s5
srl $a1, $a0, 8
add $t2, $t4, $a1
sw $a0, Sx
li $a1, 0

lw $s5, dx3
lw $a0, Ex
lw $t4, X2
add $a0, $a0, $s5
srl $a1, $a0, 8
sub $t3, $t4, $a1
sw $a0, Ex
li $a1, 0

lw $s5, dr2
lw $a0, Sr
lb $t4, kolor1 # A.r
add $a0, $a0, $s5
sra $a1, $a0, 8
add $s1, $t4, $a1
sw $a0, Sr
li $a1, 0

lw $s5, dg2
lw $a0, Sg
lb $t4, kolor1+1
add $a0, $a0, $s5
sra $a1, $a0, 8
add $s2, $t4, $a1
sw $a0, Sg
li $a1, 0

lw $s5, db2
lw $a0, Sb
lb $t4, kolor1+2
add $a0, $a0, $s5
sra $a1, $a0, 8
add $s3, $t4, $a1
sw $a0, Sb
li $a1, 0

lw $s5, dr3
lw $a0, Er
lb $t4, kolor2
add $a0, $a0, $s5
sra $a1, $a0, 8
add $t5, $t4, $a1
sw $a0, Er
li $a1, 0

lw $s5, dg3
lw $a0, Eg
lb $t4, kolor2+1
add $a0, $a0, $s5
sra $a1, $a0, 8
add $s6, $t4, $a1
sw $a0, Eg
li $a1, 0

lw $s5, db3
lw $a0, Eb
lb $t4, kolor2+2
add $a0, $a0, $s5
sra $a1, $a0, 8
add $s7, $t4, $a1
sw $a0, Eb
li $a1, 0

addiu $t6, $t6, 1
j trojkatBC1loop

trojkatAB2:
beq $t6, $t8, trojkatBC2
deltas ($t2, $t3, $s1, $s2, $s3, $t5, $s6, $s7)

sw $s1, S1
sw $s2, S2
sw $s3, S3
odcinek ($t2, $t3, $t6, $t1, $t7, $t0, $s1, $s2, $s3)
lw $s1, S1
lw $s2, S2
lw $s3, S3

lw $s5, dx1
lw $a0, Sx
lw $t4, X1 # A.x
add $a0, $a0, $s5
srl $a1, $a0, 8
sub $t2, $t4, $a1
sw $a0, Sx
li $a1, 0

lw $s5, dx2
lw $a0, Ex
lw $t4, X1
add $a0, $a0, $s5
srl $a1, $a0, 8
sub $t3, $t4, $a1
sw $a0, Ex
li $a1, 0

lw $s5, dr1
lw $a0, Sr
lb $t4, kolor1 # A.r
add $a0, $a0, $s5
sra $a1, $a0, 8
add $s1, $t4, $a1
sw $a0, Sr
li $a1, 0

lw $s5, dg1
lw $a0, Sg
lb $t4, kolor1+1
add $a0, $a0, $s5
sra $a1, $a0, 8
add $s2, $t4, $a1
sw $a0, Sg
li $a1, 0

lw $s5, db1
lw $a0, Sb
lb $t4, kolor1+2
add $a0, $a0, $s5
sra $a1, $a0, 8
add $s3, $t4, $a1
sw $a0, Sb
li $a1, 0

lw $s5, dr2
lw $a0, Er
lb $t4, kolor1
add $a0, $a0, $s5
sra $a1, $a0, 8
add $t5, $t4, $a1
sw $a0, Er
li $a1, 0

lw $s5, dg2
lw $a0, Eg
lb $t4, kolor1+1
add $a0, $a0, $s5
sra $a1, $a0, 8
add $s6, $t4, $a1
sw $a0, Eg
li $a1, 0

lw $s5, db2
lw $a0, Eb
lb $t4, kolor1+2
add $a0, $a0, $s5
sra $a1, $a0, 8
add $s7, $t4, $a1
sw $a0, Eb
li $a1, 0

addiu $t6, $t6, 1
j trojkatAB2

trojkatBC2:
lw $t4, X2 # S.x=B.x
move $t2, $t4
lw $t6, Y2
li $a0, 0
li $a1, 0
sw $zero, Sx
sw $zero, Sr
sw $zero, Sg
sw $zero, Sb

trojkatBC2loop:
beq $t6, $t9, zapisz
deltas ($t2, $t3, $s1, $s2, $s3, $t5, $s6, $s7)

sw $s1, S1
sw $s2, S2
sw $s3, S3
odcinek ($t2, $t3, $t6, $t1, $t7, $t0, $s1, $s2, $s3)
lw $s1, S1
lw $s2, S2
lw $s3, S3

lw $s5, dx3
lw $a0, Sx
lw $t4, X2 # B.x
add $a0, $a0, $s5
srl $a1, $a0, 8
add $t2, $t4, $a1
sw $a0, Sx
li $a1, 0

lw $s5, dx2
lw $a0, Ex
lw $t4, X1
add $a0, $a0, $s5
srl $a1, $a0, 8
sub $t3, $t4, $a1
sw $a0, Ex
li $a1, 0

lw $s5, dr3
lw $a0, Sr
lb $t4, kolor2
add $a0, $a0, $s5
sra $a1, $a0, 8
add $s1, $t4, $a1
sw $a0, Sr
li $a1, 0

lw $s5, dg3
lw $a0, Sg
lb $t4, kolor2+1
add $a0, $a0, $s5
sra $a1, $a0, 8
add $s2, $t4, $a1
sw $a0, Sg
li $a1, 0

lw $s5, db3
lw $a0, Sb
lb $t4, kolor2+2
add $a0, $a0, $s5
sra $a1, $a0, 8
add $s3, $t4, $a1
sw $a0, Sb
li $a1, 0

lw $s5, dr2
lw $a0, Er
lb $t4, kolor1
add $a0, $a0, $s5
sra $a1, $a0, 8
add $t5, $t4, $a1
sw $a0, Er
li $a1, 0

lw $s5, dg2
lw $a0, Eg
lb $t4, kolor1+1
add $a0, $a0, $s5
sra $a1, $a0, 8
add $s6, $t4, $a1
sw $a0, Eg
li $a1, 0

lw $s5, db2
lw $a0, Eb
lb $t4, kolor1+2
add $a0, $a0, $s5
sra $a1, $a0, 8
add $s7, $t4, $a1
sw $a0, Eb
li $a1, 0

addiu $t6, $t6, 1
j trojkatBC2loop

zapisz:
li $v0, 13
la $a0, wynikowy
li $a1, 1
li $a2, 0
syscall
move $s2, $v0
li $v0, 15
move $a0, $s2
la $a1, naglowek
li $a2, 54
syscall
li $v0, 15
la $a1, obrazek
li $a2, 180000
syscall
move $s3, $v0
li $v0, 16
syscall

end:
li $v0, 10
syscall
