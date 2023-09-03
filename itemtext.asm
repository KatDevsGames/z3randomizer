org $B28000
; You have found
; the map of
Notice_MapOf:
	db $74, $00, $C2, $00, $DE, $00, $E4, $00, $FF, $00, $D7, $00, $D0, $00, $E5, $00, $D4, $00, $FF, $00, $D5, $00, $DE, $00, $E4, $00, $DD, $00, $D3
	db $75, $00, $E3, $00, $D7, $00, $D4, $00, $FF, $00, $DC, $00, $D0, $00, $DF, $00, $FF, $00, $DE, $00, $D5
	dw #$7F7F

; You have found
; the compass of
Notice_CompassOf:
	db $74, $00, $C2, $00, $DE, $00, $E4, $00, $FF, $00, $D7, $00, $D0, $00, $E5, $00, $D4, $00, $FF, $00, $D5, $00, $DE, $00, $E4, $00, $DD, $00, $D3
	db $75, $00, $E3, $00, $D7, $00, $D4, $00, $FF, $00, $D2, $00, $DE, $00, $DC, $00, $DF, $00, $D0, $00, $E2, $00, $E2, $00, $FF, $00, $DE, $00, $D5
	dw #$7F7F

; Oh look! it's
; the big key of
Notice_BigKeyOf:
	db $74, $00, $B8, $00, $D7, $00, $FF, $00, $DB, $00, $DE, $00, $DE, $00, $DA, $00, $C7, $00, $FF, $00, $D8, $00, $E3, $00, $9D, $00, $E2
	db $75, $00, $E3, $00, $D7, $00, $D4, $00, $FF, $00, $D1, $00, $D8, $00, $D6, $00, $FF, $00, $DA, $00, $D4, $00, $E8, $00, $FF, $00, $DE, $00, $D5
	dw #$7F7F

; this is a
; small key to
Notice_SmallKeyOf:
	db $74, $00, $BD, $00, $D7, $00, $D8, $00, $E2, $00, $FF, $00, $D8, $00, $E2, $00, $FF, $00, $D0
	db $75, $00, $E2, $00, $DC, $00, $D0, $00, $DB, $00, $DB, $00, $FF, $00, $DA, $00, $D4, $00, $E8, $00, $FF, $00, $E3, $00, $DE
	dw #$7F7F

; You picked up
Notice_Crystal:
	db $74, $00, $C2, $00, $DE, $00, $E4, $00, $FF, $00, $DF, $00, $D8, $00, $D2, $00, $DA, $00, $D4, $00, $D3, $00, $FF, $00, $E4, $00, $DF
        dw $7F7F

; light world
Notice_LightWorld:
	db $76, $00, $B5, $00, $D8, $00, $D6, $00, $D7, $00, $E3, $00, $FF, $00, $C0, $00, $DE, $00, $E1, $00, $DB, $00, $D3
	dw #$7F7F

; dark world
Notice_DarkWorld:
	db $76, $00, $AD, $00, $D0, $00, $E1, $00, $DA, $00, $FF, $00, $C0, $00, $DE, $00, $E1, $00, $DB, $00, $D3
	dw #$7F7F

; Ganons Tower
Notice_GTower:
	db $76, $00, $B0, $00, $D0, $00, $DD, $00, $DE, $00, $DD, $00, $E2, $00, $FF, $00, $BD, $00, $DE, $00, $E6, $00, $D4, $00, $E1
	dw #$7F7F

; Turtle Rock
Notice_TRock:
	db $76, $00, $BD, $00, $E4, $00, $E1, $00, $E3, $00, $DB, $00, $D4, $00, $FF, $00, $BB, $00, $DE, $00, $D2, $00, $DA
	dw #$7F7F

; Thieves Town
Notice_Thieves:
	db $76, $00, $BD, $00, $D7, $00, $D8, $00, $D4, $00, $E5, $00, $D4, $00, $E2, $00, $FF, $00, $BD, $00, $DE, $00, $E6, $00, $DD
	dw #$7F7F

; Tower of Hera
Notice_Hera:
	db $76, $00, $BD, $00, $DE, $00, $E6, $00, $D4, $00, $E1, $00, $FF, $00, $DE, $00, $D5, $00, $FF, $00, $B1, $00, $D4, $00, $E1, $00, $D0
	dw #$7F7F

; Ice Palace
Notice_Ice:
	db $76, $00, $B2, $00, $D2, $00, $D4, $00, $FF, $00, $B9, $00, $D0, $00, $DB, $00, $D0, $00, $D2, $00, $D4
	dw #$7F7F

; Skull Woods
Notice_Skull:
	db $76, $00, $BC, $00, $DA, $00, $E4, $00, $DB, $00, $DB, $00, $FF, $00, $C0, $00, $DE, $00, $DE, $00, $D3, $00, $E2
	dw #$7F7F

; Misery Mire
Notice_Mire:
	db $76, $00, $B6, $00, $D8, $00, $E2, $00, $D4, $00, $E1, $00, $E8, $00, $FF, $00, $B6, $00, $D8, $00, $E1, $00, $D4
	dw #$7F7F

; Dark Palace
Notice_PoD:
	db $76, $00, $AD, $00, $D0, $00, $E1, $00, $DA, $00, $FF, $00, $B9, $00, $D0, $00, $DB, $00, $D0, $00, $D2, $00, $D4
	dw #$7F7F

; Swamp Palace
Notice_Swamp:
	db $76, $00, $BC, $00, $E6, $00, $D0, $00, $DC, $00, $DF, $00, $FF, $00, $B9, $00, $D0, $00, $DB, $00, $D0, $00, $D2, $00, $D4
	dw #$7F7F

; Castle Tower
Notice_AgaTower:
	db $76, $00, $AC, $00, $D0, $00, $E2, $00, $E3, $00, $DB, $00, $D4, $00, $FF, $00, $BD, $00, $DE, $00, $E6, $00, $D4, $00, $E1
	dw #$7F7F

; Desert Palace
Notice_Desert:
	db $76, $00, $AD, $00, $D4, $00, $E2, $00, $D4, $00, $E1, $00, $E3, $00, $FF, $00, $B9, $00, $D0, $00, $DB, $00, $D0, $00, $D2, $00, $D4
	dw #$7F7F

; Eastern Palace
Notice_Eastern:
	db $76, $00, $AE, $00, $D0, $00, $E2, $00, $E3, $00, $D4, $00, $E1, $00, $DD, $00, $FF, $00, $B9, $00, $D0, $00, $DB, $00, $D0, $00, $D2, $00, $D4
	dw #$7F7F

; Hyrule Castle
Notice_Castle:
	db $76, $00, $B1, $00, $E8, $00, $E1, $00, $E4, $00, $DB, $00, $D4, $00, $FF, $00, $AC, $00, $D0, $00, $E2, $00, $E3, $00, $DB, $00, $D4
	dw #$7F7F

; Hyrule Castle
Notice_Sewers:
	db $76, $00, $B1, $00, $E8, $00, $E1, $00, $E4, $00, $DB, $00, $D4, $00, $FF, $00, $AC, $00, $D0, $00, $E2, $00, $E3, $00, $DB, $00, $D4
	dw #$7F7F

; This Dungeon
Notice_Self:
	db $76, $00, $E3, $00, $D7, $00, $D8, $00, $E2, $00, $FF, $00, $D3, $00, $E4, $00, $DD, $00, $D6, $00, $D4, $00, $DE, $00, $Dd
	dw #$7F7F

; Crystal numbers
Notice_One:
        db $75, $00, $D2, $00, $E1, $00, $E8, $00, $E2, $00, $E3, $00, $D0, $00, $DB, $00, $FF, $00, $DE, $00, $DD, $00, $D4
	dw #$7F7F

Notice_Two:
        db $75, $00, $D2, $00, $E1, $00, $E8, $00, $E2, $00, $E3, $00, $D0, $00, $DB, $00, $FF, $00, $E3, $00, $E6, $00, $DE
	dw #$7F7F

Notice_Three:
        db $75, $00, $D2, $00, $E1, $00, $E8, $00, $E2, $00, $E3, $00, $D0, $00, $DB, $00, $FF, $00, $E3, $00, $D7, $00, $E1, $00, $D4, $00, $D4
	dw #$7F7F

Notice_Four:
        db $75, $00, $D2, $00, $E1, $00, $E8, $00, $E2, $00, $E3, $00, $D0, $00, $DB, $00, $FF, $00, $D5, $00, $DE, $00, $E4, $00, $E1
	dw #$7F7F

Notice_Five:
        db $75, $00, $D2, $00, $E1, $00, $E8, $00, $E2, $00, $E3, $00, $D0, $00, $DB, $00, $FF, $00, $D5, $00, $D8, $00, $E5, $00, $D4
	dw #$7F7F

Notice_Six:
        db $75, $00, $D2, $00, $E1, $00, $E8, $00, $E2, $00, $E3, $00, $D0, $00, $DB, $00, $FF, $00, $E2, $00, $D8, $00, $E7
	dw #$7F7F

Notice_Seven:
        db $75, $00, $D2, $00, $E1, $00, $E8, $00, $E2, $00, $E3, $00, $D0, $00, $DB, $00, $FF, $00, $E2, $00, $D4, $00, $E5, $00, $D4, $00, $DD
	dw #$7F7F
