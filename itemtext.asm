org $328000
; You have found
; the map of
Notice_MapOf:
	db $74, $00, $C2, $00, $B8, $00, $BE, $00, $FF, $00, $B1, $00, $AA, $00, $BF, $00, $AE, $00, $FF, $00, $AF, $00, $B8, $00, $BE, $00, $B7, $00, $AD
	db $75, $00, $BD, $00, $B1, $00, $AE, $00, $FF, $00, $B6, $00, $AA, $00, $B9, $00, $FF, $00, $B8, $00, $AF
	dw #$7F7F

; You have found
; the compass of
Notice_CompassOf:
	db $74, $00, $C2, $00, $B8, $00, $BE, $00, $FF, $00, $B1, $00, $AA, $00, $BF, $00, $AE, $00, $FF, $00, $AF, $00, $B8, $00, $BE, $00, $B7, $00, $AD
	db $75, $00, $BD, $00, $B1, $00, $AE, $00, $FF, $00, $AC, $00, $B8, $00, $B6, $00, $B9, $00, $AA, $00, $BC, $00, $BC, $00, $FF, $00, $B8, $00, $AF
	dw #$7F7F

; Oh look! it's
; the big key of
Notice_BigKeyOf:
	db $74, $00, $B8, $00, $B1, $00, $FF, $00, $B5, $00, $B8, $00, $B8, $00, $B4, $00, $C7, $00, $FF, $00, $B2, $00, $BD, $00, $D8, $00, $BC
	db $75, $00, $BD, $00, $B1, $00, $AE, $00, $FF, $00, $AB, $00, $B2, $00, $B0, $00, $FF, $00, $B4, $00, $AE, $00, $C2, $00, $FF, $00, $B8, $00, $AF
	dw #$7F7F

; this is a
; small key to
Notice_SmallKeyOf:
	db $74, $00, $BD, $00, $B1, $00, $B2, $00, $BC, $00, $FF, $00, $B2, $00, $BC, $00, $FF, $00, $AA
	db $75, $00, $BC, $00, $B6, $00, $AA, $00, $B5, $00, $B5, $00, $FF, $00, $B4, $00, $AE, $00, $C2, $00, $FF, $00, $BD, $00, $B8
	dw #$7F7F

; light world
Notice_LightWorld:
	db $76, $00, $B5, $00, $B2, $00, $B0, $00, $B1, $00, $BD, $00, $FF, $00, $C0, $00, $B8, $00, $BB, $00, $B5, $00, $AD
	dw #$7F7F

; dark world
Notice_DarkWorld:
	db $76, $00, $AD, $00, $AA, $00, $BB, $00, $B4, $00, $FF, $00, $C0, $00, $B8, $00, $BB, $00, $B5, $00, $AD
	dw #$7F7F

; Ganons Tower
Notice_GTower:
	db $76, $00, $B0, $00, $AA, $00, $B7, $00, $B8, $00, $B7, $00, $BC, $00, $FF, $00, $BD, $00, $B8, $00, $C0, $00, $AE, $00, $BB
	dw #$7F7F

; Turtle Rock
Notice_TRock:
	db $76, $00, $BD, $00, $BE, $00, $BB, $00, $BD, $00, $B5, $00, $AE, $00, $FF, $00, $BB, $00, $B8, $00, $AC, $00, $B4
	dw #$7F7F

; Thieves Town
Notice_Thieves:
	db $76, $00, $BD, $00, $B1, $00, $B2, $00, $AE, $00, $BF, $00, $AE, $00, $BC, $00, $FF, $00, $BD, $00, $B8, $00, $C0, $00, $B7
	dw #$7F7F

; Tower of Hera
Notice_Hera:
	db $76, $00, $BD, $00, $B8, $00, $C0, $00, $AE, $00, $BB, $00, $FF, $00, $B8, $00, $AF, $00, $FF, $00, $B1, $00, $AE, $00, $BB, $00, $AA
	dw #$7F7F

; Ice Palace
Notice_Ice:
	db $76, $00, $B2, $00, $AC, $00, $AE, $00, $FF, $00, $B9, $00, $AA, $00, $B5, $00, $AA, $00, $AC, $00, $AE
	dw #$7F7F

; Skull Woods
Notice_Skull:
	db $76, $00, $BC, $00, $B4, $00, $BE, $00, $B5, $00, $B5, $00, $FF, $00, $C0, $00, $B8, $00, $B8, $00, $AD, $00, $BC
	dw #$7F7F

; Misery Mire
Notice_Mire:
	db $76, $00, $B6, $00, $B2, $00, $BC, $00, $AE, $00, $BB, $00, $C2, $00, $FF, $00, $B6, $00, $B2, $00, $BB, $00, $AE
	dw #$7F7F

; Dark Palace
Notice_PoD:
	db $76, $00, $AD, $00, $AA, $00, $BB, $00, $B4, $00, $FF, $00, $B9, $00, $AA, $00, $B5, $00, $AA, $00, $AC, $00, $AE
	dw #$7F7F

; Swamp Palace
Notice_Swamp:
	db $76, $00, $BC, $00, $C0, $00, $AA, $00, $B6, $00, $B9, $00, $FF, $00, $B9, $00, $AA, $00, $B5, $00, $AA, $00, $AC, $00, $AE
	dw #$7F7F

; Castle Tower
Notice_AgaTower:
	db $76, $00, $AC, $00, $AA, $00, $BC, $00, $BD, $00, $B5, $00, $AE, $00, $FF, $00, $BD, $00, $B8, $00, $C0, $00, $AE, $00, $BB
	dw #$7F7F

; Desert Palace
Notice_Desert:
	db $76, $00, $AD, $00, $AE, $00, $BC, $00, $AE, $00, $BB, $00, $BD, $00, $FF, $00, $B9, $00, $AA, $00, $B5, $00, $AA, $00, $AC, $00, $AE
	dw #$7F7F

; Eastern Palace
Notice_Eastern:
	db $76, $00, $AE, $00, $AA, $00, $BC, $00, $BD, $00, $AE, $00, $BB, $00, $B7, $00, $FF, $00, $B9, $00, $AA, $00, $B5, $00, $AA, $00, $AC, $00, $AE
	dw #$7F7F

; Hyrule Castle
Notice_Castle:
	db $76, $00, $B1, $00, $C2, $00, $BB, $00, $BE, $00, $B5, $00, $AE, $00, $FF, $00, $AC, $00, $AA, $00, $BC, $00, $BD, $00, $B5, $00, $AE
	dw #$7F7F

; Hyrule Castle
Notice_Sewers:
	db $76, $00, $B1, $00, $C2, $00, $BB, $00, $BE, $00, $B5, $00, $AE, $00, $FF, $00, $AC, $00, $AA, $00, $BC, $00, $BD, $00, $B5, $00, $AE
	dw #$7F7F

; This Dungeon
Notice_Self:
	db $76, $00, $BD, $00, $B1, $00, $B2, $00, $BC, $00, $FF, $00, $AD, $00, $BE, $00, $B7, $00, $B0, $00, $AE, $00, $B8, $00, $B7
	dw #$7F7F
