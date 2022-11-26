clearTable:
dw $007F,$007F,$007F,$007F,$007F,$007F,$007F,$007F,$007F,$007F,$007F,$007F,$007F,$007F,$007F,$007F,$007F,$007F,$007F,$007F,$007F,$007F,$007F,$007F,$007F,$007F,$007F,$007F,$007F,$007F,$007F,$007F


WriteText:
{
PHP
; $7EC025 = Timer
; $7EC026 = When we find an empty item get set on 1
; $7EC027 = character data

    LDX.b #$80 : STX.w INIDISP
    REP #$20
    LDA.w #$6000+$0340 : STA.w VMADDL

    LDA.w #$C027 : STA.w A1T4L
    LDX.b #$7E : STX.w A1B4
    LDA.w #$0040 : STA.w DAS4L
    LDA.w #$1801 : STA.w DMAP4
    LDX.b #$10 : STX.w MDMAEN

    LDX.b #$0F : STX.w INIDISP
    PLP
RTL
}


ClearBG:
{
PHP
    LDX.b #$80 : STX.w INIDISP
    REP #$20
    LDA.w #$6000+$0340 : STA.w VMADDL
    LDA.w #clearTable : STA.w A1T4L
    LDX.b #clearTable>>16 : STX.w A1B4

    LDA.w #$0040 : STA.w DAS4L
    LDA.w #$1801 : STA.w DMAP4
    LDX.b #$10 : STX.w MDMAEN

    LDX.b #$0F : STX.w INIDISP
    PLP
RTL
}
