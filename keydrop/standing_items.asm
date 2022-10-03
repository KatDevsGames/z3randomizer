; hooks
org $01E6B0
	JSL RevealPotItem
	RTS

org $09C2BB
	JSL ClearSpriteData

org $09C327
	JSL LoadSpriteData

org $06F976
	JSL RevealSpriteDrop : NOP

org $06E3C4
	JSL RevealSpriteDrop2 : NOP

org $06926e ; <- 3126e - sprite_prep.asm : 2664 (LDA $0B9B : STA $0CBA, X)
	JSL SpriteKeyPrep : NOP #2

org $06d049 ; <- 35049 sprite_absorbable : 31-32 (JSL Sprite_DrawRippleIfInWater : JSR Sprite_DrawAbsorbable)
	JSL SpriteKeyDrawGFX : BRA + : NOP : +

org $06d03d
	JSL ShouldSpawnItem : NOP #2

org $06D19F
	JSL MarkSRAMForItem : NOP #2

org $06d180
	JSL BigKeyGet : BCS $07 : NOP #5

org $06d18d ; <- 3518D - sprite_absorbable.asm : 274 (LDA $7EF36F : INC A : STA $7EF36F)
	JSL KeyGet

org $06f9f3 ; bank06.asm : 6732 (JSL Sprite_LoadProperties)
	JSL LoadProperties_PreserveCertainProps

org $008BAA ; NMI hook
	JSL TransferPotGFX

org $06828A
	JSL CheckSprite_Spawn

org $07B169
	JSL PreventPotSpawn : NOP

org $07B17D
	JSL PreventPotSpawn2

org $068275
	JSL SubstitionFlow

org $00A9DC
dw $1928, $1938, $5928, $5938 ; change weird ugly black diagonal pot to blue-ish pot

org $018650
dw $B395 ; change tile type to normal pot

org $01B3D5
JSL CheckIfPotIsSpecial


; refs to other functions
org $0681F4
Sprite_SpawnSecret_pool_ID:
org $068283
Sprite_SpawnSecret_NotRandomBush:
org $06828A
Sprite_SpawnSecret_SpriteSpawnDynamically:
org $06d23a
Sprite_DrawAbsorbable:
org $1eff81
Sprite_DrawRippleIfInWater:
org $0db818
Sprite_LoadProperties:
org $06D038
KeyRoomFlagMasks:

; defines
; Ram usage
SpawnedItemID = $7E0720 ; 0x02
SpawnedItemIndex = $7E0722 ; 0x02
SpawnedItemIsMultiWorld = $7E0724 ; 0x02
SpawnedItemFlag = $7E0726 ; 0x02 - one for pot, 2 for sprite drop
; (flag used as a bitmask in conjunction with StandingItemCounterMask)
SpawnedItemMWPlayer = $7E0728 ; 0x02
; clear all of them in a loop during room load
SprDropsItem = $7E0730 ; 0x16
SprItemReceipt = $7E0740 ; 0x16
SprItemIndex = $7E0750
SprItemMWPlayer = $7E0760 ; 0x16
SprItemFlags = $7E0770 ; 0x16 (used for both pots and drops) (combine with SprDropsItem?)

; todo: move sprites
; ----------------------------------------------------------------
; BIG NOTE - ultimate home of UW sprite data is going to be here
; pots will move to bank 09 at that time instead of being here
; ----------------------------------------------------------------
;org $09D62E
;UWSpritesPointers ; 0x250 bytes for 0x128 rooms' 16-bit pointers

;org $09D87E
;UWPotsPointers ; 0x250 bytes for 0x128 rooms' 16-bit pointers

;org $09DACE
;UWPotsData ; variable number of bytes (max 0x11D1) for all pots data

;org $A88000
;UWSpritesData ; variable number of bytes (max 0x2800) for all sprites and sprite drop data
; First $2800 bytes of this bank (28) is reserved for the sprite tables

; $2800 bytes reserved for sprites

; temporary pot table until sprites get moved:
org $A88000
UWPotsPointers: ; 0x250 bytes for 0x128 rooms' 16-bit pointers

org $A88250
UWPotsData:

org $A8A800
;tables:
PotMultiWorldTable:
; Reserved $250 296 * 2

org $A8AA50
StandingItemsOn: ; 142A50
db 0
MultiClientFlagsROM: ; 142A51-2 -> stored in SRAM at 7ef33d (for now)
dw 0
SwampDrain1HasItem: ; 142A53
db 1
SwampDrain2HasItem: ; 142A54
db 1
StandingItemCounterMask: ; 142A55
db 0 ; if 0x01 is set then pot should be counted, if 0x02 then sprite drops, 0x03 (both bits for both)
PotCountMode: ; 28AA56-7
; 0 is don't count pots
; 1 for check PotCollectionRateTable
dw 0

org $A8AA60
PotCollectionRateTable:
; Reserved $250 296 * 2

org $A8ACB0

RevealPotItem:
	STA.b $04 ; save tilemap coordinates
	STZ.w SpawnedItemFlag
	STZ.w SpawnedItemMWPlayer
	LDA.w $0B9C : AND.w #$FF00 : STA.w $0B9C

	LDA.b $A0 : ASL : TAX

	LDA.l UWPotsPointers,X : STA.b $00 ; we may move this
	LDA.w #UWPotsPointers>>16 : STA.b $02

	LDY.w #$FFFD : LDX.w #$FFFF

.next_pot
	INY : INY : INY

	LDA.b [$00],Y
	CMP.w #$FFFF : BEQ .exit

	INX

	STA.w $08 ; remember the exact value
	AND.w #$3FFF
	CMP.b $04 : BNE .next_pot ; not the correct value

	STZ.w SpawnedItemIsMultiWorld
	BIT.b $08
	BVS LoadMultiWorldPotItem
	BMI LoadMajorPotItem

.normal_secret
	STA $08

	PHX : PHY
		; set bit and count if first time lifting this pot
		TXA : ASL : TAX : LDA.l BitFieldMasks, X : STA $0A
		LDA.b $A0 : ASL : TAX
		JSR ShouldCountNormalPot : BCC .obtained
		LDA.l RoomPotData, X : BIT $0A : BNE .obtained
			ORA $0A : STA RoomPotData, X
			; increment dungeon counts
			SEP #$30
			LDA $040C : CMP #$FF : BEQ +
				BNE ++
				 	INC #2 ; treat sewers as HC
				++ LSR : TAX : LDA DungeonLocationsChecked, X : INC : STA DungeonLocationsChecked, X
				; Could increment GT Tower Pre Big Key but we aren't showing that stat right now
			+ REP #$30
			LDA TotalItemCounter : INC : STA TotalItemCounter ; Increment Item Total
		.obtained
	PLY : PLX

	PLA ; remove the JSL return lower 16 bits
	LDA $08
	PEA.w $01E6E2-1 ; change return address to go back to the vanilla routine
.exit
	RTL

LoadMultiWorldPotItem:
	INY : INY
	LDA.b [$00],Y : AND.w #$00FF

	INC.w SpawnedItemIsMultiWorld
	PHX
	ASL : TAX

	LDA.l PotMultiWorldTable+1,X : AND.w #$00FF : STA.w SpawnedItemMWPlayer

	LDA.l PotMultiWorldTable+0,X : AND.w #$00FF

	PLX

	BRA SaveMajorItemDrop

LoadMajorPotItem:
	INY : INY
	LDA.b [$00],Y : AND.w #$00FF

SaveMajorItemDrop:
	; A currently holds the item receipt ID
	; X currently holds the pot item index
	STA.w SpawnedItemID
	STX.w SpawnedItemIndex
	INC.w SpawnedItemFlag
	TAY : LDA.w #$0008
	CPY.w #$0036 : BNE +  ; Red Rupee
		LDA.w #$0016 : BRA .substitute
	+ CPY.w #$0044 : BNE + ; 10 pack arrows
		LDA.w #$0017 : BRA .substitute
	+ CPY.w #$0028 : BNE + ; 3 pack bombs
		LDA.w #$0018 : BRA .substitute
	+ CPY.w #$0031 : BNE + ; 10 pack bombs
		LDA.w #$0019 : BRA .substitute
	+ STA $0B9C ; indicates we should use the key routines or a substitute
RTL
	.substitute
	PHA
		TXA : ASL : STA.b $00
		LDA.w #$001F : SBC $00
		TAX : LDA.l BitFieldMasks, X : STA $00
		LDA.b $A0 : ASL : TAX
		LDA.l $7EF580, X
		AND.b $00
		BNE .exit
		LDA.l $7EF580, X : ORA $00 : STA.l $7EF580, X
	PLA : STA $0B9C
RTL
	.exit
	PLA : STZ.w $0B9C
RTL

ShouldCountNormalPot:
	INY : INY : LDA [$00], Y : AND #$00FF : CMP #$0080 : BCS .clear
	LDA.l PotCountMode : BEQ .clear
	LDA.l PotCollectionRateTable, X : BIT $0A : BEQ .clear ; don't count if clear
.set
	SEC
RTS
.clear
	CLC
RTS

IncrementCountsForSubstitute:
	PHX : REP #$30
	LDA.w SpawnedItemIndex : ASL : TAX : LDA.l BitFieldMasks, X : STA $0A
	LDA.b $A0 : ASL : TAX
	LDA.l RoomPotData, X : BIT $0A : BNE .obtained
		ORA $0A : STA RoomPotData, X
		SEP #$30
		LDA $040C : CMP #$FF : BEQ +
			BNE ++
				INC #2 ; treat sewers as HC
			++ LSR : TAX : LDA DungeonLocationsChecked, X : INC : STA DungeonLocationsChecked, X
			; Could increment GT Tower Pre Big Key but we aren't showing that stat right now
		+ REP #$30
		LDA TotalItemCounter : INC : STA TotalItemCounter ; Increment Item Total
	.obtained
	SEP #$30 : PLX
RTS

ClearSpriteData:
	STZ.b $02 : STZ.b $03 ; what we overrode
	PHX
		LDA #$00 : LDX #$00
		.loop
			STA SprDropsItem, X :  STA SprItemReceipt, X : STA SprItemIndex, X
			STA SprItemMWPlayer, X : STA SprItemFlags, X
			INX : CPX #$10 : BCC .loop
	PLX
	RTL

; Runs during sprite load of the room
LoadSpriteData:
	INY : INY
	LDA.b ($00), Y
	CMP #$F3 : BCC .normal
		PHA
			DEC.b $02 ; standing items shouldn't consume a sprite slot
			LDX.b $02
			CMP #$F9 : BNE .not_multiworld
				DEY : LDA.b ($00), Y : STA.l SprItemMWPlayer, X
				LDA.b #$02 : STA.l SprDropsItem, X : BRA .common
			.not_multiworld
			LDA.b #$00 : STA.l SprItemMWPlayer, X
			LDA.b #$01 : STA.l SprDropsItem, X
			DEY
			.common
			DEY : LDA.b ($00), Y : STA.l SprItemReceipt, X
		INY : INY
		PLA
		PLA : PLA ; remove the JSL return lower 16 bits
		PEA.w $09C344-1 ; change return address to exit from Underworld_LoadSingleSprite
		RTL
	.normal
	RTL

; Run when a sprite dies ... Sets Flag to #$02 and Index to sprite slot for
RevealSpriteDrop:
	LDA.l SprDropsItem, X : BEQ .normal
		LDA #$02 : STA.l SpawnedItemFlag
		STX.w SpawnedItemIndex
		LDA.l SprItemReceipt, X : STA SpawnedItemID
		LDA.l SprItemMWPlayer, X : STA SpawnedItemMWPlayer
		LDY.b #$01 ; trigger the small key routines
		LDA SpawnedItemID : CMP #$32 : BNE +
		LDA.l StandingItemsOn : BNE +
			INY ; big key routine
		+ RTL ; unstun if stunned
	.normal
	LDY.w $0CBA, X : BEQ .no_forced_drop
		RTL
	.no_forced_drop
	PLA : PLA ; remove the JSL reswamturn lower 16 bits
	PEA.w $06F996-1 ; change return address to .no_forced_drop of (Sprite_DoTheDeath)
	RTL

RevealSpriteDrop2:
	LDY.w SprDropsItem, X : BEQ .normal
		BRA .no_forced_drop
	.normal
	LDY.w $0CBA, X : BEQ .no_forced_drop
		RTL
	.no_forced_drop
	PLA : PLA ; remove the JSL reswamturn lower 16 bits
	PEA.w $06E3CE-1 ; change return address to .no_forced_drop of (Sprite_DoTheDeath)
	RTL

BitFieldMasks:
dw $8000, $4000, $2000, $1000, $0800, $0400, $0200, $0100
dw $0080, $0040, $0020, $0010, $0008, $0004, $0002, $0001

; Runs during Sprite_E4_SmallKey and duning Sprite_E5_BigKey spawns
ShouldSpawnItem:
	LDA $048E : CMP.b #$87 : BNE + ; check for hera basement cage
	LDA $A8 : AND.b #$03 : CMP.b #$02 : BNE + ; we're not in that quadrant
			LDA.w $0403 : AND.w KeyRoomFlagMasks,Y : RTL
	+
	; checking our sram table
	PHX : PHY
		REP #$30
		LDA.b $A0 : ASL : TAY
		LDA.w SprItemIndex, X : AND #$00FF : ASL
		PHX
			TAX : LDA.l BitFieldMasks, X : STA $00
		PLX ; restore X again
		LDA.w SprItemFlags, X : AND #$00FF : CMP #$0001 : BEQ +
			TYX : LDA.l SpritePotData, X : BIT $00 : BEQ .notObtained
			BRA .obtained
		+ TYX : LDA.l RoomPotData, X : BIT $00 : BEQ .notObtained
			.obtained
			SEP #$30 : PLY : PLX : LDA #$01 : RTL ; already obtained
	.notObtained
	SEP #$30 : PLY : PLX
	LDA #$00
	RTL

MarkSRAMForItem:
	LDA $048E : CMP.b #$87 : BNE + ; check for hera basement cage
		LDA $A8 : AND.b #$03 : CMP.b #$02 : BNE +
		LDA.w $0403 : ORA.w KeyRoomFlagMasks, Y : RTL
	+ PHX : PHY : REP #$30
		LDA.b $A0 : ASL : TAY
		LDA.l SpawnedItemIndex : ASL
		TAX : LDA.l BitFieldMasks, X : STA $00
		TYX
		LDA.w SpawnedItemFlag : CMP #$0001 : BEQ +
			LDA SpritePotData, X : ORA $00 : STA SpritePotData, X : BRA .end
		+ LDA RoomPotData, X : ORA $00 : STA RoomPotData, X
	.end
	SEP #$30 : PLY : PLX
	LDA.w $0403
	RTL

SpriteKeyPrep:
	LDA.w $0B9B : STA.w $0CBA, X ; what we wrote over
	PHA
		LDA $A0 : CMP #$87 : BNE .continue
			LDA $A9 : ORA $AA : AND #$03 : CMP #$02 : BNE .continue
				LDA #$00 : STA.w SpawnedItemFlag : STA SprItemFlags, X
				LDA #$24 : STA $0E80, X
				BRA +
		.continue
		LDA.w SpawnedItemIndex : STA SprItemIndex, X
		LDA.w SpawnedItemMWPlayer : STA SprItemMWPlayer, X
		LDA.w SpawnedItemFlag : STA SprItemFlags, X : BEQ +
		LDA.l SpawnedItemID : STA $0E80, X
		PHA
			JSL.l GetSpritePalette : STA $0F50, X ; setup the palette
		PLA
		CMP #$24 : BNE ++ ;
			LDA $A0 : CMP.b #$80 : BNE +
			LDA SpawnedItemFlag : BNE +
				LDA #$24  ; it's the big key drop?
		++ JSL RequestStandingItemVRAMSlot
	+ PLA
	RTL

SpriteKeyDrawGFX:
    JSL Sprite_DrawRippleIfInWater
    PHA
    LDA $0E80, X
   	CMP.b #$24 : BNE +
   		LDA $A0 : CMP #$80 : BNE ++
   		LDA SpawnedItemFlag : BNE ++
    		LDA #$24 : BRA +
    	++ PLA
		   PHK : PEA.w .jslrtsreturn-1
		   PEA.w $068014 ; an rtl address - 1 in Bank06
		   JML Sprite_DrawAbsorbable
		   .jslrtsreturn
		   RTL
	+ JSL DrawPotItem
    CMP #$03 : BNE +
        PHA : LDA $0E60, X : ORA.b #$20 : STA $0E60, X : PLA
    + JSL.l Sprite_DrawShadowLong
    PLA : RTL

KeyGet:
    LDA CurrentSmallKeys ; what we wrote over
    PHA
    	LDA.l StandingItemsOn : BNE +
    		PLA : RTL
    	+ LDY $0E80, X
    	LDA SprItemIndex, X : STA SpawnedItemIndex
    	LDA SprItemFlags, X : STA SpawnedItemFlag
    	LDA $A0 : CMP #$87 : BNE + ;check for hera cage
    	LDA SpawnedItemFlag : BNE + ; if it came from a pot, it's fine
    		JSR ShouldKeyBeCountedForDungeon : BCC ++
			JSL CountChestKeyLong
    		++ PLA : RTL
    	+ STY $00
    	LDA SprItemMWPlayer, X : STA !MULTIWORLD_ITEM_PLAYER_ID : BNE .receive
    	PHX
			LDA $040C : CMP #$FF : BNE +
				LDA $00 : CMP.b #$AF : BNE .skip
				LDA CurrentGenericKeys : INC : STA CurrentGenericKeys
				LDA $00 : BRA .countIt
			+ LSR : TAX
			LDA $00 : CMP.l KeyTable, X : BNE +
				.countIt
				LDA.l StandingItemCounterMask : AND SpawnedItemFlag : BEQ ++
					JSL.l FullInventoryExternal : JSL CountChestKeyLong
				++ PLX : PLA : RTL
			+ CMP.b #$AF : beq .countIt ; universal key
			CMP.b #$24 : beq .countIt   ; small key for this dungeon
    	.skip PLX
    	.receive
    	JSL $0791b3 ; Player_HaltDashAttackLong
    	JSL.l Link_ReceiveItem
	PLA : DEC : RTL

KeyTable:
db $A0, $A0, $A2, $A3, $A4, $A5, $A6, $A7, $A8, $A9, $AA, $AB, $AC, $AD

; Input Y - the item type
ShouldKeyBeCountedForDungeon:
	PHX
		LDA $040C : CMP #$FF : BEQ .done
		LSR : TAX
		TYA : cmp KeyTable, X : BNE +
			- PLX : SEC : RTS
		+ CMP.B #$24 : BEQ -
	.done
	PLX : CLC : RTS


BigKeyGet:
	LDY $0E80, X
	CPY #$32 : BNE +
		STZ $02E9 : LDY.b #$32 ; what we wrote over
		PHX : JSL Link_ReceiveItem : PLX ; what we wrote over
		CLC : RTL
	+ SEC : RTL

LoadProperties_PreserveCertainProps:
	LDA $0E20, X : CMP #$E4 : BEQ +
	CMP #$E5 : BEQ +
		JML Sprite_LoadProperties
	+ LDA $0F50, X : PHA
    LDA $0E80, X : PHA
    JSL Sprite_LoadProperties
    PLA : STA $0E80, X
    PLA : STA $0F50, X
    RTL

SubstitionFlow:
	CPY.b #$04 : BNE +
		RTL ; let enemizer/vanilla take care of it
	+ PLA : PLA ; remove JSL stuff
	CPY.b #$16 : BCS +
		PEA.w Sprite_SpawnSecret_NotRandomBush-1 : RTL ; jump to not_random_bush spot
	; jump directly to new code
	+ PEA.w Sprite_SpawnSecret_SpriteSpawnDynamically-1
RTL

SubstitionTable:
	db $DB ; RED RUPEE - 0x16
	db $E2 ; ARROW REFILL 10 - 0x17
	db $DD ; BOMB REFILL 4 - 0x18
    db $DE ; BOMB REFILL 8  - 0x19


SubstituteSpriteId:
	CPY.b #$16 : BCS +
		RTS
	+ LDA.b #$01
	CPY.b #$18 : BCC +
		LDA.b #$05
	+ STA.b $0D
	JSR IncrementCountsForSubstitute
	PHB : PHK : PLB
		LDA.w SubstitionTable-$16, Y ; Do substitute
	PLB
RTS

CheckSprite_Spawn:
	JSR SubstituteSpriteId
	JSL Sprite_SpawnDynamically
	BMI .check
RTL
.check
	LDA $0D : CMP #$08 : BNE +
	LDA $0372 : BNE .error
		LDX #$0F

		; loop looking for a Sprite with state 0A (carried by the player)
		- LDA $0DD0, X : CMP #$0A : BEQ .foundIt
		DEX : BMI .error : BRA -

		.foundIt
		LDA #$00 : STZ $0DD0, X
		LDA #$E4 : JSL Sprite_SpawnDynamically
		BMI .error
		LDA #$40 : TSB $0308 : RTL

		.error
		LDA.b #$3C ; SFX2_3C - error beep
		STA.w $012E
	+ LDA #$FF
RTL

PreventPotSpawn:
	LDA #$40 : BIT $0308 : BEQ +
		STZ $0308 : RTL
	+ LDA.b #$80 : STA.w $0308  ; what we wrote over
RTL

PreventPotSpawn2:
	LDA $0308 : BEQ +
		LDA.b #$01 : TSB.b $50 ; what we wrote over
+ RTL

CheckIfPotIsSpecial:
	TXA ; give index to A so we can do a CMP.l
	CMP.l $018550 ; see if our current index is that of object 230
	BEQ .specialpot

    ; Normal pot, so run the vanilla code
	LDA.l $7EF3CA ; check for dark world
	.specialpot ; zero flag already set, so gtg
RTL


incsrc dynamic_si_vram.asm

;===================================================================================================
; Pot items
;===================================================================================================
;Vanilla:
;	Data starts at $01DDE7 formatted:
;	dw aaaa : db i

;	aaaa is a 14 bit number: ..tt tttt tttt tttt indicating the tilemap ID
;	i is the secrets ID

;Drop shuffle changes:
;	normal secrets stay vanilla

;	major items (anything not a secret) use the bits 14 and 15 to produce different behavior

;	aaaa is now a 16 bit number:
;	imtt tttt tttt tttt

;	t - is still tilemap id (aaaa & #$3FFF)
;	i - flag indicates a major item
;	m - indicates a multiworld item

;	for major items (non multiworld), i indicates the item receipt ID

;	for multi world items, i indicates the multiworld id
;	multiworld id indexes a new table of 256 entries of 2 bytes each

;	MultiWorldTable:
;		db <item receipt ID>, <player ID>



;===================================================================================================
; Sprite items
;===================================================================================================
;Vanilla:
;If this value appears in the sprite table, then the sprite that preceded it is given a key drop
;	db $FE, $00, $E4

;Drop shuffle changes:
;	db <receipt id>, $00, $F8 ; this denotes the previous sprite is given a major item (non MW)

;   db <receipt id>, <player>, $F9 ; this denotes the previous sprite is given a MW item
