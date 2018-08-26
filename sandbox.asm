
;$A0      |$15B6E - $15B7B (2) Starting room
;$0601    |$15B7C - $15BB3 (8) scroll ranges
;$E2      |$15BB4 - $15BC1 (2) Location X? Scroll Data
;$E8      |$15BC2 - $15BCF (2) Location Y? Scroll Data
;$20      |$15BD0 - $15BDD (2) link x?
;$22      |$15BDE - $15BEB (2) link y?
;$0618    |$15BEC - $15BF9 (2) camera y?
;$061c    |$15BFA - $15C07 (2) camera x?
;$0AA1    |$15C08 - $15C0E (1) Starting Location Blockset Type
;$A4      |$15C0F - $15C15 (1) Starting Location Floor Type
;$040C    |$15C16 - $15C1C (1) Dungeon Designation
;$EE,$0476|$15C1D - $15C23 (1) ladder and background
;$A6,$A7  |$15C24 - $15C2A (1) scroll properties
;$A9,$AA  |$15C2B - $15C31 (1) Scroll Quandrant
;$0696    |$15C32 - $15C3F (2) overworld exit location
;$010E    |$15C40 - $15C4D (2) starting location entrance value
;$0132    |$15C4E - $15C54 (1) music

;-----------------------------------------------
; Sanc Spawn point at dark sanc
;-----------------------------------------------

org $02D8D4 : dw $112
org $02D8E8 : db $22, $22, $22, $23, $04, $04, $04, $05
org $02D91A : dw $0400
org $02D928 : dw $222e
org $02D936 : dw $229a
org $02D944 : dw $0480
org $02D952 : dw $00a5
org $02D960 : dw $007F
org $02D96D : db $14
org $02D974 : db $00
org $02D97B : db $FF
org $02D982 : db $00
org $02D989 : db $02
org $02D990 : db $00
org $02D998 : dw $0000
org $02D9A6 : dw $005A
org $02D9B3 : db $12

; Handle exit from this cave
org $308250 ;StartingAreaExitTable
dw $0112 : db $53 : dw $001e, $0400, $06e2, $0446, $0758, $046d, $075f : db $00, $00, $00
org $308240 ;StartingAreaExitOffset
db $00, $01, $00, $00, $00, $00, $00


;-----------------------------------------------
; Old man spawn point at End of Cave
;-----------------------------------------------
org $02D8DE : dw $00F1
org $02D910 : db $1F, $1E, $1F, $1F, $03, $02, $03, $03
org $02D924 : dw $0300
org $02D932 : dw $1F10
org $02D940 : dw $1FC0
org $02D94E : dw $0378
org $02D95C : dw $0187
org $02D96A : dw $017F
org $02D972 : db $06
org $02D979 : db $00
org $02D980 : db $FF
org $02D987 : db $00
org $02D98E : db $22
org $02D995 : db $12
org $02D9A2 : dw $0000
org $02D9B0 : dw $0007
org $02D9B8 : db $12


;--------------------------------------------------------------
; Make Houlihan exit at Pyramid
;--------------------------------------------------------------
org $02DB68 : dw $0003
org $02DBC9 : db $5b
org $02DC55 : dw $0b0e
org $02DCF3 : dw $075a
org $02DD91 : dw $0674
org $02DE2F : dw $07a8
org $02DECD : dw $06e8
org $02DF6B : dw $07c7
org $02E009 : dw $06f3
org $02E06A : db $06
org $02E0B9 : db $fa
org $02E145 : dw $0000
org $02E1E3 : dw $0000

;--------------------------------------------------------------
; Make Houlihan exit at C-Shaped House
;--------------------------------------------------------------
;org $02DB68 : dw $0003
;org $02DBC9 : db $58
;org $02DC55 : dw $09d8
;org $02DCF3 : dw $0744
;org $02DD91 : dw $02ce
;org $02DE2F : dw $0797
;org $02DECD : dw $0348
;org $02DF6B : dw $07b3
;org $02E009 : dw $0353
;org $02E06A : db $0a
;org $02E0B9 : db $f6
;org $02E145 : dw $0DE8
;org $02E1E3 : dw $0000

;--------------------------------------------------------------
; Inverted Exit Shuffles
;--------------------------------------------------------------

; swap bomb shop and links house
org $02DB8C+$00 : db $6C
org $1BBB73+$00 : db $53
org $1BBB73+$52 : db $01

; swap AT and GT
org $1BBB73+$23 : db $37
org $1BBB73+$36 : db $24
org $02DAEE+$38+$38 : dw $00e0
org $02DAEE+$25+$25 : dw $000c

; Bumper Cave (Bottom) => Old Man Cave (West)
org $1BBB73+$15 : db $06
org $02DAEE+$17+$17 : dw $00f0

; Old Man Cave (West) => Bumper Cave (Bottom)
org $1BBB73+$05 : db $16
org $02DAEE+$07+$07 : dw $00fb

; Death Mountain Return Cave (West) => Bumper Cave (Top)
org $1BBB73+$2d : db $17
org $02DAEE+$2f+$2f : dw $00eb

; Old Man Cave (East) => Death Mountain Return Cave (West)
org $1BBB73+$06 : db $2e
org $02DAEE+$08+$08 : dw $00e6

; Bumper Cave (Top) => Dark Death Mountain Fairy
org $1BBB73+$16 : db $5e

; Dark Death Mountain Healer Fairy => Old Man Cave (East)
org $1BBB73+$6F : db $07
org $02DAEE+$18+$18 : dw $00f1
org $02DB8C+$18 : db $43
org $02DBDB+$18+$18 : dw $1400
org $02DC79+$18+$18 : dw $0294
org $02DD17+$18+$18 : dw $0600
org $02DDB5+$18+$18 : dw $02e8
org $02DE53+$18+$18 : dw $0678
org $02DEF1+$18+$18 : dw $0303
org $02DF8F+$18+$18 : dw $0685
org $02E02D+$18 : db $0a
org $02E07C+$18 : db $f6
org $02E0CB+$18+$18 : dw $0000
org $02E169+$18+$18 : dw $0000

;--------------------------------------------------------------
; Other inverted
;--------------------------------------------------------------
org $30804A : db $01 ; main toggle
org $0283E0 : db $F0 ; residual portal
org $02B34D : db $F0 ; residual portal
org $06DB78 : db $8B ; residual portal

org $05AF79 : db $F0 ; vortex
org $0DB3C5 : db $C6 ; vortex
org $07A3F4 : db $F0 ; duck
org $07A3F4 : db $F0 ; duck
org $02E849 : dw $0043, $0056, $0058, $006C, $006F, $0070, $007B, $007F ; Dark World Flute Spots
org $02E8D5 : dw $07C8 ; nudge flute spot 3 out of gargoyle statue
org $02E8F7 : dw $01F8 ; nudge flute spot 3 out of gargoyle statue
org $07A943 : db $F0 ; Dark to light world mirror
org $07A96D : db $D0 ; residual portal?
org $07A9A7 : db $F0 ; residual portal?
org $07A9F3 : db $F0 ; residual portal?
org $07AA3A : db $D0 ; residual portal?
org $08D40C : db $D0 ; morph poof
org $308174 : db $01 ; ER's Fix fake worlds fix. Currently needed for inverted

org $1FED31 : db $0E ; pre-open open TR bomb door
org $1FED41 : db $0E ; pre-open open TR bomb door

; Write to StartingAreaOverworldDoor table to indicate the overworld door being used for
; the single entrance spawn point
org $308247 ; PC 0x180247
db $00, $5A, $00, $00, $00, $00, $00


;org $02E849 ; Fly 1 to Sanctuary
;db #$13, #$00, #$16, #$00, #$18, #$00, #$2C, #$00, #$2F, #$00, #$30, #$00, #$3B, #$00, #$3F, #$00, #$5B, #$00, #$35, #$00, #$0F, #$00, #$15, #$00, #$33, #$00, #$12, #$00, #$3F, #$00, #$55, #$00, #$7F, #$00, #$1A, #$00, #$88, #$08, #$30, #$0B, #$88, #$05, #$98, #$07, #$80, #$18, #$9E, #$06, #$10, #$08, #$2E, #$00, #$42, #$12, #$80, #$06, #$12, #$01, #$9E, #$05, #$8E, #$04, #$80, #$02, #$12, #$01, #$80, #$02, #$00, #$04, #$16, #$05, #$59, #$07, #$B9, #$0A, #$FA, #$0A, #$1E, #$0F, #$DF, #$0E, #$05, #$0F, #$00, #$06, #$46, #$0E, #$C6, #$02, #$2A, #$04, #$BA, #$0C, #$9A, #$04, #$56, #$0E, #$2A, #$04, #$56, #$0E, #$D6, #$06, #$4E, #$0C, #$7E, #$01, #$40, #$08, #$B2, #$0E, #$00, #$00, #$F2, #$06, #$75, #$0E, #$78, #$07, #$0A, #$0C, #$06, #$0E, #$8A, #$0A, #$EA, #$06, #$62, #$04, #$00, #$0E, #$8A, #$0A, #$00, #$0E, #$68, #$04, #$78, #$05, #$B7, #$07, #$17, #$0B, #$58, #$0B, #$A8, #$0F, #$3D, #$0F, #$67, #$0F, #$5C, #$06, #$A8, #$0E, #$28, #$03, #$88, #$04, #$18, #$0D, #$F8, #$04, #$B8, #$0E, #$88, #$04, #$B8, #$0E, #$56, #$07, #$C8, #$0C, #$00, #$02, #$B8, #$08, #$30, #$0F, #$78, #$00, #$78, #$07, #$F3, #$0E, #$F0, #$07, #$90, #$0C, #$80, #$0E, #$10, #$0B, #$70, #$07, #$E8, #$04, #$68, #$0E, #$10, #$0B, #$68, #$0E, #$70, #$04, #$83, #$05, #$C6, #$07, #$26, #$0B, #$67, #$0B, #$8D, #$0F, #$4C, #$0F, #$72, #$0F, #$6D, #$06, #$B3, #$0E, #$33, #$03, #$97, #$04, #$27, #$0D, #$07, #$05, #$C3, #$0E, #$97, #$04, #$C3, #$0E, #$56, #$07, #$D3, #$0C, #$0B, #$02, #$BF, #$08, #$37, #$0F, #$8D, #$00, #$7F, #$07, #$FA, #$0E, #$F7, #$07, #$97, #$0C, #$8B, #$0E, #$17, #$0B, #$77, #$07, #$EF, #$04, #$85, #$0E, #$17, #$0B, #$85, #$0E, #$F6, #$FF, #$FA, #$FF, #$07, #$00, #$F7, #$FF, #$F6, #$FF, #$00, #$00, #$F1, #$FF, #$FB, #$FF, #$00, #$00, #$FA, #$FF, #$0A, #$00, #$F6, #$FF, #$F6, #$FF, #$F6, #$FF, #$FA, #$FF, #$F6, #$FF, #$FA, #$FF, #$F2, #$FF, #$F2, #$FF, #$02, #$00, #$00, #$00, #$0E, #$00, #$00, #$00, #$FE, #$FF, #$0B, #$00, #$F8, #$FF, #$06, #$00, #$FA, #$FF, #$FA, #$FF, #$06, #$00, #$0E, #$00, #$00, #$00, #$FA, #$FF, #$00, #$00
;
