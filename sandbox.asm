;Spawn location table cryptic documentation
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
org $02E849 : dw $0043, $0056, $0058, $006C, $006F, $0070, $007B, $007F, $001B ; Dark World Flute Spots
org $02E8D5 : dw $07C8 ; nudge flute spot 3 out of gargoyle statue
org $02E8F7 : dw $01F8 ; nudge flute spot 3 out of gargoyle statue
org $07A943 : db $F0 ; Dark to light world mirror
org $07A96D : db $D0 ; residual portal?

org $08D40C : db $D0 ; morph poof
org $308174 : db $01 ; ER's Fix fake worlds fix. Currently needed for inverted

org $0280A6 : db $D0 ; Spawn logic

org $1FED31 : db $0E ; pre-open open TR bomb door
org $1FED41 : db $0E ; pre-open open TR bomb door

org $0ABFBB : db $90 ; Show portal on dark world map

org $308089 : db $01 ; Open TR Entrance if exiting from it

org $06B2AA : JSL Sprite_ShowMessageFromPlayerContact
; front end will actually do `org $06B2AB : dl $05E1F0`

; Write to StartingAreaOverworldDoor table to indicate the overworld door being used for
; the single entrance spawn point
org $308247 ; PC 0x180247
db $00, $5A, $00, $00, $00, $00, $00

org $1AF696 : db #$F0 ;Bat X position (sprite_retreat_bat.asm:130)
org $1AF6B2 : db #$33 ;Bat Delay (sprite_retreat_bat.asm:136)

;New Hole Mask Position
org $1AF730
db $6A, $9E, $0C, $00
db $7A, $9E, $0C, $00
db $8A, $9E, $0C, $00
db $6A, $AE, $0C, $00
db $7A, $AE, $0C, $00
db $8A, $AE, $0C, $00
db $67, $97, $0C, $00
db $8D, $97, $0C, $00

;Cryptic documentation of flute/whirlpool table format (all value 16 bit)
;eae5 - Overworld area that the exit leads to
;eb07 $0084 - VRAM locations to place Link at.
;eb29 $e6/0122/0124 - Y Scroll Data
;eb4b $e0/011e/0120 - X Scroll Data
;eb6d $20 - Link's Y Coordinate
;eb8f $22 - Link's X Coordinate
;ebb1 $0618 - Camera Y Coordinate
;ebd3 $061c - Camera X Coordinate
;ebf5 $0624- Ukn1 in HM
;ec17 $0628- Ukn2 in HM

;adjust flute spot 9 position
org $02E87B : dw $00ae
org $02E89D : dw $0610
org $02E8BF : dw $077e
org $02E8E1 : dw $0672
org $02E903 : dw $07f8
org $02E925 : dw $067d
org $02E947 : dw $0803
org $02E969 : dw $0000
org $02E98B : dw $FFF2

; aga tower exit/ pyramid spawn (now hyrule castle ledge spawn)
org $02DAEE+$06+$06 : dw $0020
org $02DB8C+$06 : db $1B
org $02DBDB+$06+$06 : dw $00ae
org $02DC79+$06+$06 : dw $0610
org $02DD17+$06+$06 : dw $077e
org $02DDB5+$06+$06 : dw $0672
org $02DE53+$06+$06 : dw $07f8
org $02DEF1+$06+$06 : dw $067d
org $02DF8F+$06+$06 : dw $0803
org $02E02D+$06 : db $00
org $02E07C+$06 : db $f2
org $02E0CB+$06+$06 : dw $0000
org $02E169+$06+$06 : dw $0000


org $308350 : db $00, $00, $01 ; Death mountain cave should start on overworld

;(0x????,0x1B,0x0130,0x060a,0x0716,0x0672,0x07f8,0x0681,0x0803,0x0c,0x02,xx,xx)
; Exit table cryptic documentation:
;??|$15D8A-$15E27 - (0x4F entries, 2 bytes each) - Rooms that exit to overworld Areas ("Room" in HM)
;??|$15E28-$15E76 - (0x4F entries, 1 byte each)  - Overworld area that the exit leads to. ("Map" in HM)
;84|$15E77-$15F14 - (0x4F entries, 2 bytes each) - VRAM locations to place Link at. Gets fed to $7E0084 (???? in HM)
;e6|$15F15-$15FB2 - (0x4F entries, 2 bytes each) - Y Scroll Data
;e0|$15FB3-$16050 - (0x4F entries, 2 bytes each) - X Scroll Data
;$20|$16051-$160EE - (0x4F entries, 2 bytes each) - Link's Y Coordinate
;$22|$160EF-$1618C - (0x4F entries, 2 bytes each) - Link's X Coordinate
;0618|$1618D-$1622A - (0x4F entries, 2 bytes each) - Camera Y Coordinate
;061c|$1622B-$162C8 - (0x4F entries, 2 bytes each) - Camera X Coordinate
;0624|$162C9-$16317 - (0x4F entries, 1 byte each)  - Ukn1 in HM
;0628|$16318-$16366 - (0x4F entries, 1 byte each)  - Ukn2 in HM

; redefine some map16 tiles
org $0FF1C8
dw #$190F, #$190F, #$190F, #$194C
dw #$190F, #$194B, #$190F, #$195C
dw #$594B, #$194C, #$19EE, #$19EE
dw #$194B, #$19EE, #$19EE, #$19EE
dw #$594B, #$190F, #$595C, #$190F
dw #$190F, #$195B, #$190F, #$190F
dw #$19EE, #$19EE, #$195C, #$19EE
dw #$19EE, #$19EE, #$19EE, #$595C
dw #$595B, #$190F, #$190F, #$190F

; Redefine more map16 tiles
org $0FA480
dw #$190F, #$196B, #$9D04, #$9D04
dw #$196B, #$190F, #$9D04, #$9D04

; update pyramid hole entrances
org $1bb810 : dw $00BE, $00C0, $013E
org $1bb836 : dw $001B, $001B, $001B
; add an extra pyramid hole entrance
; ExtraHole_Map16:
org $308300 : dw $0140
; ExtraHole_Area:
org $308320 : dw $001B
; ExtraHole_Entrance:
org $308340 : db $7B

;prioritize retreat Bat and use 3rd sprite section
org $1af504 : dw $148B
org $1af50c : dw $149B
org $1af514 : dw $14A4
org $1af51c : dw $1489
org $1af524 : dw $14AC
org $1af52c : dw $54AC
org $1af534 : dw $148C
org $1af53c : dw $548C
org $1af544 : dw $1484
org $1af54c : dw $5484
org $1af554 : dw $14A2
org $1af55c : dw $54A2
org $1af564 : dw $14A0
org $1af56c : dw $54A0
org $1af574 : dw $148E
org $1af57c : dw $548E
org $1af584 : dw $14AE
org $1af58c : dw $54AE

;Make retreat bat gfx available in Hyrule castle.
org $00DB9D : db $1A ;sprite set 1, section 3
org $00DC09 : db $1A ;sprite set 27, section 3

;use new castle hole graphics (The values are the SNES address of the graphics: 31e000)
org $00D009 : db $31
org $00D0e8 : db $E0
org $00D1c7 : db $00

;add color for shading for castle hole
org $1BE8DA : dw $39AD

; TR tail jump
org $00886e : db $5C, $00, $A0, $A1

;Remove Hyrule Castle Gate warp
org $09D436 : db $F3 ;replace whirlpool with (harmless) SpritePositionTarget Overlord

;Add warps under rocks, etc.
org $1BC67A : db #$2E, #$0B, #$82 ; Replace a rupee under bush to add a warp on map 80 (top of kak)
org $1BC81E : db #$94, #$1D, #$82 ; Replace a heart under bush to add a warp on map 120 (mire)
org $1BC655 : db #$4A, #$1D, #$82 ; Replace a bomb :( under bush to add a warp on map 78 (DM)
org $1BC80D : db #$B2, #$0B, #$82 ; map 111
org $1BC3DF : db #$D8, #$D1 ; new pointer for map 115 no items to replace
org $1BD1D8 : db #$A8, #$02, #$82, #$FF, #$FF ;new data for map115
org $1BC85A : db #$50, #$0F, #$82

org $1BC387 : db #$DD, #$D1 ;New pointer for map 71 no items to replace
org $1BD1DD : db #$A4, #$06, #$82, #$9E, #$06, #$82, #$FF, #$FF ;new data for map 71


;;move pyramid exit overworld door
org $1BB96F+$35+$35 : dw $001b
org $1BBA71+$35+$35 : dw $06a4
org $1BBB73+$35 : db $36

org $02DAEE+$37+$37 : dw $0010
org $02DB8C+$37 : db $1B
org $02DBDB+$37+$37 : dw $0418
org $02DC79+$37+$37 : dw $0679
org $02DD17+$37+$37 : dw $06b4
org $02DDB5+$37+$37 : dw $06c6
org $02DE53+$37+$37 : dw $0728
org $02DEF1+$37+$37 : dw $06e6
org $02DF8F+$37+$37 : dw $0733
org $02E02D+$37 : db $07
org $02E07C+$37 : db $f9
org $02E0CB+$37+$37 : dw $0000
org $02E169+$37+$37 : dw $0000


;org $02E849 ; Fly 1 to Sanctuary
;db #$13, #$00, #$16, #$00, #$18, #$00, #$2C, #$00, #$2F, #$00, #$30, #$00, #$3B, #$00, #$3F, #$00, #$5B, #$00, #$35, #$00, #$0F, #$00, #$15, #$00, #$33, #$00, #$12, #$00, #$3F, #$00, #$55, #$00, #$7F, #$00, #$1A, #$00, #$88, #$08, #$30, #$0B, #$88, #$05, #$98, #$07, #$80, #$18, #$9E, #$06, #$10, #$08, #$2E, #$00, #$42, #$12, #$80, #$06, #$12, #$01, #$9E, #$05, #$8E, #$04, #$80, #$02, #$12, #$01, #$80, #$02, #$00, #$04, #$16, #$05, #$59, #$07, #$B9, #$0A, #$FA, #$0A, #$1E, #$0F, #$DF, #$0E, #$05, #$0F, #$00, #$06, #$46, #$0E, #$C6, #$02, #$2A, #$04, #$BA, #$0C, #$9A, #$04, #$56, #$0E, #$2A, #$04, #$56, #$0E, #$D6, #$06, #$4E, #$0C, #$7E, #$01, #$40, #$08, #$B2, #$0E, #$00, #$00, #$F2, #$06, #$75, #$0E, #$78, #$07, #$0A, #$0C, #$06, #$0E, #$8A, #$0A, #$EA, #$06, #$62, #$04, #$00, #$0E, #$8A, #$0A, #$00, #$0E, #$68, #$04, #$78, #$05, #$B7, #$07, #$17, #$0B, #$58, #$0B, #$A8, #$0F, #$3D, #$0F, #$67, #$0F, #$5C, #$06, #$A8, #$0E, #$28, #$03, #$88, #$04, #$18, #$0D, #$F8, #$04, #$B8, #$0E, #$88, #$04, #$B8, #$0E, #$56, #$07, #$C8, #$0C, #$00, #$02, #$B8, #$08, #$30, #$0F, #$78, #$00, #$78, #$07, #$F3, #$0E, #$F0, #$07, #$90, #$0C, #$80, #$0E, #$10, #$0B, #$70, #$07, #$E8, #$04, #$68, #$0E, #$10, #$0B, #$68, #$0E, #$70, #$04, #$83, #$05, #$C6, #$07, #$26, #$0B, #$67, #$0B, #$8D, #$0F, #$4C, #$0F, #$72, #$0F, #$6D, #$06, #$B3, #$0E, #$33, #$03, #$97, #$04, #$27, #$0D, #$07, #$05, #$C3, #$0E, #$97, #$04, #$C3, #$0E, #$56, #$07, #$D3, #$0C, #$0B, #$02, #$BF, #$08, #$37, #$0F, #$8D, #$00, #$7F, #$07, #$FA, #$0E, #$F7, #$07, #$97, #$0C, #$8B, #$0E, #$17, #$0B, #$77, #$07, #$EF, #$04, #$85, #$0E, #$17, #$0B, #$85, #$0E, #$F6, #$FF, #$FA, #$FF, #$07, #$00, #$F7, #$FF, #$F6, #$FF, #$00, #$00, #$F1, #$FF, #$FB, #$FF, #$00, #$00, #$FA, #$FF, #$0A, #$00, #$F6, #$FF, #$F6, #$FF, #$F6, #$FF, #$FA, #$FF, #$F6, #$FF, #$FA, #$FF, #$F2, #$FF, #$F2, #$FF, #$02, #$00, #$00, #$00, #$0E, #$00, #$00, #$00, #$FE, #$FF, #$0B, #$00, #$F8, #$FF, #$06, #$00, #$FA, #$FF, #$FA, #$FF, #$06, #$00, #$0E, #$00, #$00, #$00, #$FA, #$FF, #$00, #$00
;
