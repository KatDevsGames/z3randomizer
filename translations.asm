;--------------------------------------------------------------------------------
org $1C801B ; <- E001B - E003E ; game over menu - 0x24
db $FC, $00, $BC, $AA, $BF, $AE, $C9, $AC, $B8, $B7, $BD, $B2, $B7, $BE, $AE, $F8, $BC, $AA, $BF, $AE, $C9, $BA, $BE, $B2, $BD, $F9, $AC, $B8, $B7, $BD, $B2, $B7, $BE, $AE, $FB, $FC
;--------------------------------------------------------------------------------
org $1C818F ; <- E018F - E01B6 ; tutorial guard's text 1 - 0x28
db $B8, $B7, $B5, $C2, $FF, $AA, $AD, $BE, $B5, $BD, $BC, $FF, $FF, $FF, $F8, $BC, $B1, $B8, $BE, $B5, $AD, $FF, $BD, $BB, $AA, $BF, $AE, $B5, $FF, $F9, $AA, $BD, $FF, $B7, $B2, $B0, $B1, $BD, $FF, $FB
;--------------------------------------------------------------------------------
;org $1C81B7 ; <- E01B7 - E01E3 ; tutorial guard's text 2 - 0x2D
db $C2, $B8, $BE, $FF, $AC, $AA, $B7, $FF, $B9, $BE, $BC, $B1, $FF, $C1, $F8, $BD, $B8, $FF, $BF, $B2, $AE, $C0, $FF, $BD, $B1, $AE, $FF, $FF, $FF, $F9, $B6, $AA, $B9, $CD, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FB
;--------------------------------------------------------------------------------
;org $1C81E4 ; <- E01E4 - E0210 ; tutorial guard's text 3 - 0x2D
db $B9, $BB, $AE, $BC, $BC, $FF, $BD, $B1, $AE, $FF, $AA, $FF, $FF, $FF, $F8, $AB, $BE, $BD, $BD, $B8, $B7, $FF, $BD, $B8, $FF, $B5, $B2, $AF, $BD, $F9, $BD, $B1, $B2, $B7, $B0, $BC, $FF, $AB, $C2, $FF, $C2, $B8, $BE, $FF, $FB
;--------------------------------------------------------------------------------
;org $1C8211 ; <- E0211 - E023D ; tutorial guard's text 4 - 0x2D
db $C0, $B1, $AE, $B7, $FF, $C2, $B8, $BE, $FF, $B1, $AA, $BC, $FF, $AA, $FF, $FF, $F8, $BC, $C0, $B8, $BB, $AD, $FF, $B9, $BB, $AE, $BC, $BC, $FF, $AB, $F9, $BD, $B8, $FF, $BC, $B5, $AA, $BC, $B1, $FF, $FF, $FF, $FF, $FF, $FB
;--------------------------------------------------------------------------------
;org $1C823E ; <- E023E - E0269 ; tutorial guard's text 5 - 0x2C
db $BE, $BC, $AE, $FF, $C2, $B8, $BE, $BB, $FF, $B6, $AA, $B9, $FF, $FF, $F8, $BD, $B8, $FF, $AF, $B2, $B7, $AD, $FF, $BD, $B1, $AE, $FF, $FF, $FF, $F9, $AC, $BB, $C2, $BC, $BD, $AA, $B5, $BC, $FF, $FF, $FF, $FF, $FF, $FB
;--------------------------------------------------------------------------------
;org $1C826A ; <- E026A - E0296 ; tutorial guard's text 6 - 0x2D
db $AA, $BB, $AE, $FF, $C0, $AE, $FF, $BB, $AE, $AA, $B5, $B5, $C2, $F8, $BC, $BD, $B2, $B5, $B5, $FF, $BB, $AE, $AA, $AD, $B2, $B7, $B0, $F9, $BD, $B1, $AE, $BC, $AE, $C6, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $F9, $F9, $FB
;--------------------------------------------------------------------------------
;org $1C8297 ; <- E0297 - E02BF ; tutorial guard's text 7 - 0x29
db $B3, $AE, $AE, $C3, $AE, $FF, $BD, $B1, $AE, $BB, $AE, $F8, $BB, $AE, $AA, $B5, $B5, $C2, $FF, $AA, $BB, $AE, $FF, $AA, $FF, $F9, $B5, $B8, $BD, $FF, $B8, $AF, $FF, $BD, $B1, $B2, $B7, $B0, $BC, $FF, $FB
;--------------------------------------------------------------------------------
;org $1C8CB0 ; <- E0CB0 - ; Saharala text (skipping selection) Eventual text
; free space
;--------------------------------------------------------------------------------
org $1C935A ; <- E135A - E1388 ; first sign (rain state) - 0x2F
db $E0, $FF, $AD, $C2, $B2, $B7, $B0, $FF, $BE, $B7, $AC, $B5, $AE, $FF, $F8, $FF, $FF, $BD, $B1, $B2, $BC, $FF, $C0, $AA, $C2, $FF, $FF, $FF, $FF, $F9, $F9, $F9, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FB
;--------------------------------------------------------------------------------
org $1C9389 ; <- E1389 - E13B4 ; first sign - 0x2C
db $D2, $D3, $FF, $BB, $AA, $B7, $AD, $B8, $B6, $B2, $C3, $AE, $BB, $FF, $F8, $AD, $B8, $B7, $D8, $BD, $FF, $BB, $AE, $AA, $AD, $FF, $B6, $AE, $C8, $F9, $B0, $B8, $FF, $AB, $AE, $AA, $BD, $FF, $B0, $AA, $B7, $B8, $B7, $FB
;--------------------------------------------------------------------------------
org $1C93B5 ; <- E13B5 - E13D7 ; DM cave sign - 0x23
db $AC, $AA, $BF, $AE, $FF, $BD, $B8, $FF, $BD, $B1, $AE, $F8, $B5, $B8, $BC, $BD, $FF, $B8, $B5, $AD, $FF, $B6, $AA, $B7, $F9, $B0, $B8, $B8, $AD, $FF, $B5, $BE, $AC, $B4, $FB
;--------------------------------------------------------------------------------
org $1C93D8 ; <- E13D8 - E13E6 ; Skull Woods sign - 0xF
db $E0, $FF, $B5, $B8, $BC, $BD, $FF, $C0, $B8, $B8, $AD, $BC, $FF, $FF, $FB
;--------------------------------------------------------------------------------
org $1C944B ; <- E144B - E145B ; {left} kakariko sign - 0x11 (0x12)
db $E3, $FF, $B4, $AA, $B4, $AA, $BB, $B2, $B4, $B8, $F8, $FF, $FF, $BD, $B8, $C0, $B7, $FB
;--------------------------------------------------------------------------------
org $1C94FE ; <- E14FE - E150E ; {down} kakariko sign - 0x11
db $E1, $FF, $B4, $AA, $B4, $AA, $BB, $B2, $B4, $B8, $F8, $FF, $FF, $BD, $B8, $C0, $B7, $FB
;--------------------------------------------------------------------------------
org $1C9631 ; <- E1631 - E164F ; Potion Shop no empty bottles - 0x1F (0x20)
db $C0, $B1, $B8, $AA, $FF, $AB, $BE, $AC, $B4, $B8, $C8, $F8, $B7, $B8, $FF, $AE, $B6, $B9, $BD, $C2, $FF, $FF, $F9, $AB, $B8, $BD, $BD, $B5, $AE, $BC, $CD, $FB
;--------------------------------------------------------------------------------
org $1C9E13 ; <- E1E13 ; no big key
db $BC, $B8, $B6, $AE, $BD, $B1, $B2, $B7, $B0, $FF, $B2, $BC, $F8, $B6, $B2, $BC, $BC, $B2, $B7, $B0, $CC, $FF, $FF, $F9, $BD, $B1, $AE, $FF, $AB, $B2, $B0, $FF, $B4, $AE, $C2, $C6, $FB
;--------------------------------------------------------------------------------
org $1CA96D ; <- E296D - E29F1 ; unkown - 0x85 (0x2D)
db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $F8, $FF, $FF, $FF, $FF, $FF, $C2, $B8, $C7, $FF, $FF, $FF, $FF, $FF, $FF, $F9, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FB
;--------------------------------------------------------------------------------
;org $1CA9F2 ; <- E29F2 - E2A0E ; Old Man in Tavern - 0x1D (0x70)
db $B5, $B2, $AF, $AE, $C6, $FF, $B5, $B8, $BF, $AE, $C6, $FF, $FF, $FF, $F8, $B1, $AA, $B9, $B9, $B2, $B7, $AE, $BC, $BC, $C6, $FF, $BD, $B1, $AE, $F9, $BA, $BE, $AE, $BC, $BD, $B2, $B8, $B7, $FF, $C2, $B8, $BE, $FF, $FF, $FA, $F6, $BC, $B1, $B8, $BE, $B5, $AD, $FF, $BB, $AE, $AA, $B5, $B5, $C2, $F6, $AA, $BC, $B4, $FF, $B2, $BC, $C8, $FF, $C0, $AA, $BC, $F6, $BD, $B1, $B2, $BC, $FF, $B0, $AE, $B7, $AE, $BB, $AA, $BD, $AE, $AD, $FA, $F6, $AB, $C2, $FF, $BC, $BD, $B8, $B8, $B9, $BC, $FF, $AA, $B5, $BE, $F6, $B8, $BB, $FF, $BC, $BD, $B8, $B8, $B9, $BC, $FF, $B3, $AE, $BD, $C6, $FB
;--------------------------------------------------------------------------------
;org $1CAA0F ; <- E2A0F - E2A3D ; Chicken hut lady - 0x2F (0x36)
db $BD, $B1, $B2, $BC, $FF, $B2, $BC, $F8, $AC, $B1, $BB, $B2, $BC, $BD, $B8, $BC, $D8, $FF, $B1, $BE, $BD, $C8, $FA, $F9, $B1, $AE, $D8, $BC, $FF, $B8, $BE, $BD, $F6, $BC, $AE, $AA, $BB, $AC, $B1, $B2, $B7, $B0, $F6, $AF, $B8, $BB, $FF, $AA, $FF, $AB, $B8, $C0, $CD, $FB
;--------------------------------------------------------------------------------
;org $1CAA3E ; <- E2A3E - E2AD2 ; Running Man - 0x95 (0x8E)
db $B1, $B2, $C8, $FF, $AD, $B8, $FF, $C2, $B8, $BE, $F8, $B4, $B7, $B8, $C0, $FF, $BF, $AE, $AE, $BD, $B8, $BB, $B9, $C6, $F9, $FA, $F6, $C2, $B8, $BE, $FF, $BB, $AE, $AA, $B5, $B5, $C2, $F6, $BC, $B1, $B8, $BE, $B5, $AD, $CD, $FF, $AA, $B7, $AD, $F6, $AA, $B5, $B5, $FF, $BD, $B1, $AE, $FF, $B8, $BD, $B1, $AE, $BB, $FA, $F6, $B0, $BB, $AE, $AA, $BD, $FF, $B0, $BE, $C2, $BC, $FF, $C0, $B1, $B8, $F6, $B6, $AA, $AD, $AE, $FF, $BD, $B1, $B2, $BC, $F6, $B9, $B8, $BC, $BC, $B2, $AB, $B5, $AE, $CD, $FA, $F6, $B0, $B8, $FF, $BD, $B1, $AA, $B7, $B4, $FF, $BD, $B1, $AE, $B6, $F6, $F6, $FA, $F6, $B2, $AF, $FF, $C2, $B8, $BE, $FF, $AC, $AA, $B7, $FF, $F6, $AC, $AA, $BD, $AC, $B1, $FF, $BD, $B1, $AE, $B6, $CC, $FB
;--------------------------------------------------------------------------------
org $1CAAD3 ; <- E2AD3 ; race game sign
db $C0, $B1, $C2, $FF, $AA, $BB, $AE, $FF, $C2, $B8, $BE, $FF, $F8, $BB, $AE, $AA, $AD, $B2, $B7, $B0, $FF, $BD, $B1, $B2, $BC, $F9, $BC, $B2, $B0, $B7, $C6, $FF, $BB, $BE, $B7, $C7, $C7, $C7, $FB
;--------------------------------------------------------------------------------
org $1CAAFA ; <- E2AFA ; cape cave sign
db $C2, $B8, $BE, $FF, $B7, $AE, $AE, $AD, $FF, $AC, $AA, $B9, $AE, $F8, $AB, $BE, $BD, $FF, $B7, $B8, $BD, $F9, $B1, $B8, $B8, $B4, $BC, $B1, $B8, $BD, $FB
;--------------------------------------------------------------------------------
org $1CAB34 ; <- E2B34 ; north of outcasts
db $E0, $FF, $BC, $B4, $BE, $B5, $B5, $FF, $C0, $B8, $B8, $AD, $BC, $F9, $E1, $FF, $BC, $BD, $AE, $BF, $AE, $D8, $BC, $FF, $BD, $B8, $C0, $B7, $FB
;--------------------------------------------------------------------------------
org $1CAB51 ; <- E2B51 ; there is a cave sign
db $F8, $E2, $FF, $B4, $AA, $BB, $B4, $AA, $BD, $BC, $FF, $AC, $AA, $BF, $AE, $FB
;--------------------------------------------------------------------------------
org $1CAB61 ; <- E2B61 ; temple of Yami sign
db $F8, $E2, $FF, $AD, $AA, $BB, $B4, $FF, $B9, $AA, $B5, $AA, $AC, $AE, $FB
;--------------------------------------------------------------------------------
org $1CAB70 ; <- E2B70 ; bomb shop sign
db $F8, $E3, $FF, $AB, $B8, $B6, $AB, $FF, $BC, $B1, $B8, $B9, $B9, $AE, $FB
;--------------------------------------------------------------------------------
org $1CAB7F ; <- E2B7F ; Misery Mire sign
db $E3, $FF, $B6, $B2, $BC, $AE, $BB, $C2, $FF, $B6, $B2, $BB, $AE, $FF, $F8, $B7, $B8, $FF, $C0, $AA, $C2, $FF, $B2, $B7, $FF, $AA, $B7, $AD, $FF, $F9, $B7, $B8, $FF, $C0, $AA, $C2, $FF, $B8, $BE, $BD, $CD, $FF, $FF, $FF, $F9, $F9, $F9, $F9, $FB
;--------------------------------------------------------------------------------
org $1CABB0 ; <- E2BB0 ; outcasts sign
db $B1, $AA, $BF, $AE, $FF, $AA, $FF, $BD, $BB, $BE, $B5, $B2, $AE, $F8, $AA, $C0, $AE, $BC, $B8, $B6, $AE, $FF, $AD, $AA, $C2, $C7, $FB
;--------------------------------------------------------------------------------
org $1CABED ; <- E2BED - E2C1C ; guard on top of castle - 0x30
db $B5, $B8, $B8, $B4, $B2, $B7, $B0, $FF, $AF, $B8, $BB, $FF, $AA, $FF, $F8, $B9, $BB, $B2, $B7, $AC, $AE, $BC, $BC, $C6, $FF, $B5, $B8, $B8, $B4, $F9, $AD, $B8, $C0, $B7, $BC, $BD, $AA, $B2, $BB, $BC, $CD, $FF, $FF, $FF, $F9, $F9, $F9, $FB
;--------------------------------------------------------------------------------
org $1CAC1D ; <- E2C1D - E2C40 ; Gate guard - 0x24
db $B7, $B8, $FF, $B5, $B8, $B7, $B4, $BC, $FF, $FF, $FF, $FF, $FF, $FF, $F8, $AA, $B5, $B5, $B8, $C0, $AE, $AD, $C7, $FF, $FF, $FF, $FF, $FF, $F9, $FF, $FF, $FF, $FF, $FF, $FF, $FB
;--------------------------------------------------------------------------------
org $1CB019 ; <- E3019 - E3067 ; telepathic tile: Ice Palace large ice room - 0x4F
db $FE, $6B, $02, $AA, $B5, $B5, $FF, $BB, $B2, $B0, $B1, $BD, $FF, $BC, $BD, $B8, $B9, $F8, $AC, $B8, $B5, $B5, $AA, $AB, $B8, $BB, $AA, $BD, $AE, $F9, $AA, $B7, $AD, $FF, $B5, $B2, $BC, $BD, $AE, $B7, $FF, $B2, $AC, $AE, $FA, $F6, $B2, $BC, $FF, $AB, $AA, $AC, $B4, $FF, $C0, $B2, $BD, $B1, $F6, $B6, $C2, $FF, $AB, $BB, $AA, $B7, $AD, $FF, $B7, $AE, $C0, $F6, $B2, $B7, $BF, $AE, $B7, $BD, $B2, $B8, $B7, $FB
;--------------------------------------------------------------------------------
;org $1CB068 ; <- E3068 - E3098 ; telepathic tile: Turtle Rock entrance - 0x31
db $FE, $6B, $02, $C2, $B8, $BE, $FF, $BC, $B1, $AA, $B5, $B5, $FF, $B7, $B8, $BD, $FF, $F8, $B9, $AA, $BC, $BC, $CC, $FF, $C0, $B2, $BD, $B1, $B8, $BE, $BD, $FF, $F9, $BD, $B1, $AE, $FF, $BB, $AE, $AD, $FF, $AC, $AA, $B7, $AE, $FB
;--------------------------------------------------------------------------------
org $1CB099 ; <- E3099 - E30C1 ; telepathic tile: Ice Palace entrance - 0x24
db $FE, $6B, $02, $C2, $B8, $BE, $FF, $AC, $AA, $B7, $FF, $BE, $BC, $AE, $FF, $FF, $F8, $AF, $B2, $BB, $AE, $FF, $BB, $B8, $AD, $FF, $B8, $BB, $F9, $AB, $B8, $B6, $AB, $B8, $BC, $FF, $BD, $B8, $FF, $B9, $AA, $BC, $BC, $FB
;--------------------------------------------------------------------------------
;org $1CB0C2 ; <- E30C2 - E30F3 ; telepathic tile: Ice Palace Stalfos Knights room - 0x32
db $FE, $6B, $02, $B4, $B7, $B8, $AC, $B4, $FF, $AE, $B6, $FF, $AD, $B8, $C0, $B7, $FF, $F8, $AA, $B7, $AD, $FF, $BD, $B1, $AE, $B7, $FF, $AB, $B8, $B6, $AB, $F9, $BD, $B1, $AE, $B6, $FF, $AD, $AE, $AA, $AD, $FF, $FF, $FF, $FF, $FF, $FB
;--------------------------------------------------------------------------------
org $1CB176 ; <- E3176 ; catch a bee
db $AC, $AA, $BE, $B0, $B1, $BD, $FF, $AA, $FF, $AB, $AE, $AE, $FF, $FF, $F8, $FF, $FF, $E4, $FF, $FF, $B4, $AE, $AE, $B9, $FF, $FF, $FF, $FF, $FF, $F9, $FF, $FF, $FF, $FF, $FF, $BB, $AE, $B5, $AE, $AA, $BC, $AE, $FE, $68
;--------------------------------------------------------------------------------
org $1CB1A3 ; <- E31A3 ; catch a fairy
db $AC, $AA, $BE, $B0, $B1, $BD, $FF, $AF, $AA, $B2, $BB, $C2, $C7, $FF, $FF, $FF, $E4, $FF, $B4, $AE, $AE, $B9, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $BB, $AE, $B5, $AE, $AA, $BC, $AE, $FE, $68
;--------------------------------------------------------------------------------
org $1CB1CD ; <- E31CD ; no empty bottles
db $C0, $B1, $B8, $AA, $FF, $AB, $BE, $AC, $B4, $B8, $C8, $F8, $B7, $B8, $FF, $AE, $B6, $B9, $BD, $C2, $FF, $FF, $F9, $AB, $B8, $BD, $BD, $B5, $AE, $BC, $CD
;--------------------------------------------------------------------------------
org $1CB1ED ; <- E31ED ; race game boy
db $C2, $B8, $BE, $BB, $FF, $BD, $B2, $B6, $AE, $F8, $C0, $AA, $BC, $F9, $FE, $6C, $03, $FE, $6C, $02, $FF, $B6, $B2, $B7, $FF, $FE, $6C, $01, $FE, $6C, $00, $FF, $BC, $AE, $AC, $CD
;--------------------------------------------------------------------------------
org $1CB212 ; <- E3212 ; race game girl
db $C2, $B8, $BE, $FF, $B1, $AA, $BF, $AE, $FF, $A1, $A5, $FF, $FF, $FF, $F8, $BC, $AE, $AC, $B8, $B7, $AD, $BC, $C8, $FF, $FF, $FF, $FF, $FF, $FF, $F9, $B0, $B8, $CC, $FF, $B0, $B8, $CC, $FF, $B0, $B8, $CC, $FF, $FF
;--------------------------------------------------------------------------------
org $1CB23E ; <- E323E ; race game boy success
db $B7, $B2, $AC, $AE, $C7, $FF, $FF, $FF, $FF, $F8, $C2, $B8, $BE, $FF, $AC, $AA, $B7, $FF, $B1, $AA, $BF, $AE, $F9, $BD, $B1, $B2, $BC, $FF, $BD, $BB, $AA, $BC, $B1, $C7, $FB
;--------------------------------------------------------------------------------
org $1CB261 ; <- E3261 ; race game boy fail
db $BD, $B8, $B8, $FF, $BC, $B5, $B8, $C0, $C7, $FF, $F8, $B2, $FF, $B4, $AE, $AE, $B9, $FF, $B6, $C2, $F9, $B9, $BB, $AE, $AC, $B2, $B8, $BE, $BC, $C7, $FB
;--------------------------------------------------------------------------------
org $1CB280 ; <- E3280 - E3299 ; race game already collected - 0x1A (E32A2 - 0x23)
db $C2, $B8, $BE, $FF, $AA, $B5, $BB, $AE, $AA, $AD, $C2, $F8, $B1, $AA, $BF, $AE, $FF, $C2, $B8, $BE, $BB, $F9, $B9, $BB, $B2, $C3, $AE, $FF, $AD, $B2, $B7, $B0, $BE, $BC, $FB
;--------------------------------------------------------------------------------
org $1CBE1D ; <- E3E1D - E3E4B ; sick kid no bottle - 0x2F
db $FE, $6D, $01, $B2, $D8, $B6, $FF, $BC, $B2, $AC, $B4, $C7, $FF, $BC, $B1, $B8, $C0, $F8, $B6, $AE, $FF, $AA, $FF, $AB, $B8, $BD, $BD, $B5, $AE, $C8, $FF, $F9, $B0, $AE, $BD, $FF, $BC, $B8, $B6, $AE, $BD, $B1, $B2, $B7, $B0, $C7, $FB
;--------------------------------------------------------------------------------
;org $1CBE4C ; <- E3E4C - E3ED3 ; sick kid get item - 0x88
; free space
;--------------------------------------------------------------------------------
org $1CBEC8 ; <- E3ED4 - E3EF3 ; sick kid after bottle - 0x20 (0x2B)
db $FB ; close free space
db $B5, $AE, $AA, $BF, $AE, $FF, $B6, $AE, $FF, $AA, $B5, $B8, $B7, $AE, $F8, $B2, $D8, $B6, $FF, $BC, $B2, $AC, $B4, $CD, $FF, $C2, $B8, $BE, $F9, $B1, $AA, $BF, $AE, $FF, $B6, $C2, $FF, $B2, $BD, $AE, $B6, $CD, $FB
;--------------------------------------------------------------------------------
org $1CC2AA : db $FF ; <- E42AA ; overwrite end boxes for intro
org $1CC2EA : db $FF ; <- E42EA ; overwrite end boxes for intro
org $1CC32B : db $FF ; <- E432B ; overwrite end boxes for intro
org $1CC369 : db $FF ; <- E4369 ; overwrite end boxes for intro
org $1CC0DD ; <- E40DD - E438C ; Intro sequence - 0x2B0
; Main intro
db $FE, $6E, $00, $FE, $77, $07, $FC, $03, $FE, $6B, $02, $FE, $67, $FF, $AE, $B9, $B2, $BC, $B8, $AD, $AE, $FF, $FF, $B2, $B2, $B2, $FF, $FE, $78, $03, $F8, $FF, $AA, $FF, $B5, $B2, $B7, $B4, $FF, $BD, $B8, $FF, $FF, $FF, $FF, $F9, $FF, $FF, $FF, $BD, $B1, $AE, $FF, $B9, $AA, $BC, $BD, $FF, $FF, $FF, $FE, $78, $03, $F6, $F9, $FF, $FF, $BB, $AA, $B7, $AD, $B8, $B6, $B2, $C3, $AE, $BB, $FE, $78, $03, $F6, $F9, $AA, $AF, $BD, $AE, $BB, $FF, $B6, $B8, $BC, $BD, $B5, $C2, $F6, $F9, $AD, $B2, $BC, $BB, $AE, $B0, $AA, $BB, $AD, $B2, $B7, $B0, $F6, $F9, $C0, $B1, $AA, $BD, $FF, $B1, $AA, $B9, $B9, $AE, $B7, $AE, $AD, $F6, $F9, $B2, $B7, $FF, $BD, $B1, $AE, $FF, $AF, $B2, $BB, $BC, $BD, $F6, $F9, $BD, $C0, $B8, $FF, $B0, $AA, $B6, $AE, $BC, $CD, $FE, $78, $03, $F6, $F9, $B5, $B2, $B7, $B4, $FF, $AA, $C0, $AA, $B4, $AE, $B7, $BC, $F6, $F9, $BD, $B8, $FF, $B1, $B2, $BC, $FF, $BE, $B7, $AC, $B5, $AE, $F6, $F9, $B5, $AE, $AA, $BF, $B2, $B7, $B0, $FF, $BD, $B1, $AE, $F6, $F9, $B1, $B8, $BE, $BC, $AE, $C8, $FE, $78, $03, $F6, $F9, $B1, $AE, $FF, $B3, $BE, $BC, $BD, $FF, $BB, $BE, $B7, $BC, $F6, $F9, $B8, $BE, $BD, $FF, $BD, $B1, $AE, $FF, $AD, $B8, $B8, $BB, $FE, $78, $03, $F6, $F9, $B2, $B7, $BD, $B8, $FF, $BD, $B1, $AE, $FF, $BB, $AA, $B2, $B7, $C2, $F6, $F9, $B7, $B2, $B0, $B1, $BD, $CD, $FE, $78, $03, $FE, $67, $FE, $67, $F6, $F9, $B0, $AA, $B7, $B8, $B7, $FF, $B1, $AA, $BC, $F6, $F9, $B6, $B8, $BF, $AE, $AD, $FF, $AA, $B5, $B5, $FF, $BD, $B1, $AE, $F6, $F9, $B2, $BD, $AE, $B6, $BC, $FF, $AA, $BB, $B8, $BE, $B7, $AD, $F6, $F9, $B1, $C2, $BB, $BE, $B5, $AE, $CD, $FE, $78, $07, $F6, $F9, $C2, $B8, $BE, $FF, $C0, $B2, $B5, $B5, $FF, $B1, $AA, $BF, $AE, $F6, $F9, $BD, $B8, $FF, $AF, $B2, $B7, $AD, $FF, $AA, $B5, $B5, $F6, $F9, $BD, $B1, $AE, $FF, $B2, $BD, $AE, $B6, $BC, $F6, $F9, $B7, $AE, $AC, $AE, $BC, $BC, $AA, $BB, $C2, $FF, $BD, $B8, $F6, $F9, $AB, $AE, $AA, $BD, $FF, $B0, $AA, $B7, $B8, $B7, $CD, $FE, $78, $07, $F6, $F9, $BD, $B1, $B2, $BC, $FF, $B2, $BC, $FF, $C2, $B8, $BE, $BB, $F6, $F9, $AC, $B1, $AA, $B7, $AC, $AE, $FF, $BD, $B8, $FF, $AB, $AE, $FF, $AA, $F6, $F9, $B1, $AE, $BB, $B8, $FE, $78, $03, $FE, $67, $FE, $67, $F6, $F9, $C2, $B8, $BE, $FF, $B6, $BE, $BC, $BD, $FF, $B0, $AE, $BD, $F6, $F9, $BD, $B1, $AE, $FF, $A7, $FF, $AC, $BB, $C2, $BC, $BD, $AA, $B5, $BC, $F6, $F9, $BD, $B8, $FF, $AB, $AE, $AA, $BD, $FF, $B0, $AA, $B7, $B8, $B7, $CD, $FE, $78, $09, $FE, $67, $FE, $67, $FB
; Skeleton King
db $FE, $6B, $02, $FE, $77, $07, $FC, $03, $F7, $B5, $B8, $B8, $B4, $FF, $AA, $BD, $FF, $BD, $B1, $B2, $BC, $FF, $FF, $F8, $BC, $BD, $AA, $B5, $AF, $B8, $BC, $FF, $B8, $B7, $FF, $BD, $B1, $AE, $F9, $BD, $B1, $BB, $B8, $B7, $AE, $CD, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FB
; Zelda's cell
db $FE, $6B, $02, $FE, $77, $07, $FC, $03, $F7, $B2, $BD, $FF, $B2, $BC, $FF, $C2, $B8, $BE, $BB, $FF, $FF, $FF, $FF, $F8, $BD, $B2, $B6, $AE, $FF, $BD, $B8, $FF, $BC, $B1, $B2, $B7, $AE, $C7, $FB
; Agahnim magic'ing
db $FE, $6B, $02, $FE, $77, $07, $FC, $03, $F7, $AA, $B5, $BC, $B8, $FF, $C2, $B8, $BE, $FF, $B7, $AE, $AE, $AD, $FF, $F8, $BD, $B8, $FF, $AD, $AE, $AF, $AE, $AA, $BD, $FF, $BD, $B1, $B2, $BC, $F9, $B0, $BE, $C2, $C7, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FB
;--------------------------------------------------------------------------------
org $1CC820 ; <- E4820 - E484A ; Lumberjack left - 0x2B
db $B8, $B7, $AE, $FF, $B8, $AF, $FF, $BE, $BC, $FF, $FF, $FF, $FF, $F8, $AA, $B5, $C0, $AA, $C2, $BC, $FF, $B5, $B2, $AE, $BC, $CD, $FF, $FF, $F9, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FB
;--------------------------------------------------------------------------------
org $1CC84B ; <- E484B - E4874 ; Lumberjack right - 0x2A
db $B8, $B7, $AE, $FF, $B8, $AF, $FF, $BE, $BC, $FF, $FF, $FF, $FF, $F8, $AA, $B5, $C0, $AA, $C2, $BC, $FF, $BD, $AE, $B5, $B5, $BC, $F9, $BD, $B1, $AE, $FF, $BD, $BB, $BE, $BD, $B1, $CD, $FF, $FF, $FF, $FF, $FB
;--------------------------------------------------------------------------------
org $1CE792 ; <- E6792 - E67B8 ; treasure chest game not played yet - 0x27
db $C2, $B8, $BE, $FF, $C0, $AA, $B7, $BD, $FF, $BD, $B8, $FF, $FF, $F8, $B9, $B5, $AA, $C2, $FF, $B0, $AA, $B6, $AE, $C6, $F9, $BD, $AA, $B5, $B4, $FF, $BD, $B8, $FF, $B6, $AE, $CD, $FF, $FF, $FB
;--------------------------------------------------------------------------------
org $1CE7B9 ; <- E67B9 - E67DD ; treasure chest game played - 0x25
db $C2, $B8, $BE, $D8, $BF, $AE, $FF, $B8, $B9, $AE, $B7, $AE, $AD, $F8, $BD, $B1, $AE, $FF, $AC, $B1, $AE, $BC, $BD, $BC, $CD, $F9, $BD, $B2, $B6, $AE, $FF, $BD, $B8, $FF, $B0, $B8, $FB
;--------------------------------------------------------------------------------
org $1CE91B ; <- E691B ; no empty bottles
db $AE, $B6, $B9, $BD, $C2, $FF, $AB, $B8, $BD, $BD, $B5, $AE, $BC, $FF, $F8, $AA, $BB, $AE, $FF, $C0, $B1, $AA, $BD, $FF, $C2, $B8, $BE, $FF, $FF, $F9, $BB, $AE, $AA, $B5, $B5, $C2, $FF, $B7, $AE, $AE, $AD, $C7, $FF, $FF, $FB
;--------------------------------------------------------------------------------
org $1CEF09 ; <- E6F09 - E6F24 ; powdered pickle - 0x1C
db $B2, $D8, $B6, $FF, $AA, $FF, $B5, $B8, $B7, $AE, $B5, $C2, $F8, $AD, $AA, $B7, $AC, $B2, $B7, $B0, $FF, $B9, $B2, $AC, $B4, $B5, $AE, $FB
;--------------------------------------------------------------------------------
org $1CEF45 ; <- E6F45 - E6F61 ; potion shop no cash - 0x1D (0x24)
db $C2, $B8, $C7, $FF, $B2, $D8, $B6, $FF, $B7, $B8, $BD, $F8, $BB, $BE, $B7, $B7, $B2, $B7, $B0, $FF, $AA, $F9, $AC, $B1, $AA, $BB, $B2, $BD, $C2, $FF, $B1, $AE, $BB, $AE, $CD, $FB
;--------------------------------------------------------------------------------
org $1CEFEA ; <- E6FEA - E7039 ; LW chest game south of Kakriko do you want to play? - 0x4F
db $B9, $AA, $C2, $FF, $A2, $A0, $FF, $BB, $BE, $B9, $AE, $AE, $BC, $F8, $B8, $B9, $AE, $B7, $FF, $A1, $FF, $AC, $B1, $AE, $BC, $BD, $F9, $AA, $BB, $AE, $FF, $C2, $B8, $BE, $FF, $B5, $BE, $AC, $B4, $C2, $C6, $FA, $F6, $BC, $B8, $C8, $FF, $B9, $B5, $AA, $C2, $FF, $B0, $AA, $B6, $AE, $C6, $F6, $FF, $FF, $E4, $FF, $B9, $B5, $AA, $C2, $F6, $FF, $FF, $FF, $FF, $B7, $AE, $BF, $AE, $BB, $C7, $FE, $68, $FB
;--------------------------------------------------------------------------------
;org $1CF03A ; <- E703A - E704B ; LW chest game yes play - 0x12
db $B0, $B8, $B8, $AD, $FF, $B5, $BE, $AC, $B4, $FF, $BD, $B1, $AE, $B7, $F8, $FF, $FF, $FB
;--------------------------------------------------------------------------------
;org $1CF04C ; <- E704C - E7071 ; LW chest game no play - 0x26
db $C0, $AE, $B5, $B5, $FF, $AF, $B2, $B7, $AE, $C8, $FF, $B2, $F8, $AD, $B2, $AD, $B7, $D8, $BD, $FF, $C0, $AA, $B7, $BD, $F9, $C2, $B8, $BE, $BB, $FF, $BB, $BE, $B9, $AE, $AE, $BC, $CD, $FB
;--------------------------------------------------------------------------------
org $1CF072; <- E7072 - E7039 ; LW chest game south of Kakriko do you want to play? - 0x50
db $B9, $AA, $C2, $FF, $A1, $A0, $A0, $FF, $BB, $BE, $B9, $AE, $AE, $BC, $F8, $B8, $B9, $AE, $B7, $FF, $A1, $FF, $AC, $B1, $AE, $BC, $BD, $F9, $AA, $BB, $AE, $FF, $C2, $B8, $BE, $FF, $B5, $BE, $AC, $B4, $C2, $C6, $FA, $F6, $BC, $B8, $C8, $FF, $B9, $B5, $AA, $C2, $FF, $B0, $AA, $B6, $AE, $C6, $F6, $FF, $FF, $E4, $FF, $B9, $B5, $AA, $C2, $F6, $FF, $FF, $FF, $FF, $B7, $AE, $BF, $AE, $BB, $C7, $FE, $68, $FB
;--------------------------------------------------------------------------------
org $1CF1E4 ; <- E71E4 ; translate house/sanc spawn menu
db $FE, $6D, $00, $FC, $00, $E4, $FE, $6A, $D8, $BC, $FF, $B1, $B8, $BE, $BC, $AE, $FF, $FF, $F8, $FF, $BC, $AA, $B7, $AC, $BD, $BE, $AA, $BB, $C2, $FE, $72, $FB
;--------------------------------------------------------------------------------
org $1CF204 ; <- E7204 ; translate house/sanc/mountain spawn menu
db $FE, $6D, $00, $FC, $00, $E4, $FE, $6A, $D8, $BC, $FF, $B1, $B8, $BE, $BC, $AE, $F8, $FF, $BC, $AA, $B7, $AC, $BD, $BE, $AA, $BB, $C2, $F9, $FF, $B6, $B8, $BE, $B7, $BD, $AA, $B2, $B7, $FF, $AC, $AA, $BF, $AE, $FE, $71, $FB
;--------------------------------------------------------------------------------
org $1CF2C8 ; <- E72C8 ; digging game no cash
db $C2, $B8, $BE, $FF, $C0, $AA, $B7, $BD, $FF, $BD, $B8, $F8, $AD, $B2, $B0, $C6, $FF, $B2, $FF, $C0, $AA, $B7, $BD, $F9, $A8, $A0, $FF, $BB, $BE, $B9, $AE, $AE, $BC, $CD, $FF, $FB
;--------------------------------------------------------------------------------
org $1CF231 ; <- E7231 - Save and quit
db $FC, $00, $E4, $AC, $B8, $B7, $BD, $B2, $B7, $BE, $AE, $F8, $FF, $BC, $AA, $BF, $AE, $FF, $AA, $B7, $AD, $FF, $BA, $BE, $B2, $BD, $FE, $72, $FB
;--------------------------------------------------------------------------------
org $1CF325 ; <- E7325 ; digging game, no follower
db $BC, $B8, $B6, $AE, $BD, $B1, $B2, $B7, $B0, $FF, $B2, $BC, $FF, $F8, $AF, $B8, $B5, $B5, $B8, $C0, $B2, $B7, $B0, $FF, $C2, $B8, $BE, $F9, $B2, $FF, $AD, $B8, $B7, $D8, $BD, $FF, $B5, $B2, $B4, $AE, $CD, $F9, $F9, $F9, $F9, $F9, $F9, $F9
;--------------------------------------------------------------------------------
