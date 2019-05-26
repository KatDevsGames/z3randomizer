clearTable:
dw $007F,$007F,$007F,$007F,$007F,$007F,$007F,$007F,$007F,$007F,$007F,$007F,$007F,$007F,$007F,$007F,$007F,$007F,$007F,$007F,$007F,$007F,$007F,$007F,$007F,$007F,$007F,$007F,$007F,$007F,$007F,$007F


WriteText:
{
PHP
; $7EC025 = Timer
; $7EC026 = When we find an empty item get set on 1
; $7EC027 = character data

    LDX #$80 : STX $2100
    REP #$20
    LDA #$6000+$0340 : STA $2116

    LDA.w #$C027 : STA $4342
    LDX.b #$7E : STX $4344
    LDA #$0040 : STA $4345
    LDA #$1801 : STA $4340
    LDX #$10 : STX $420B

    LDX #$0F : STX $2100
    PLP
RTL
}


ClearBG:
{
PHP
    LDX #$80 : STX $2100
    REP #$20
    LDA #$6000+$0340 : STA $2116
    LDA.w #clearTable : STA $4342
    LDX.b #clearTable>>16 : STX $4344

    LDA #$0040 : STA $4345
    LDA #$1801 : STA $4340
    LDX #$10 : STX $420B

    LDX #$0F : STX $2100
    PLP
RTL
}