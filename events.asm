;--------------------------------------------------------------------------------
; OnLoadOW
;--------------------------------------------------------------------------------
;OnLoadMap:
;	LDA $7EF2DB ; thing we wrote over
;RTL
;--------------------------------------------------------------------------------
OnPrepFileSelect:
	LDA $11 : CMP.b #$03 : BNE +
		LDA.b #$06 : STA $14 ; thing we wrote over
		RTL
	+
	JSL.l LoadAlphabetTilemap
	JSL.l LoadFullItemTiles
RTL
;--------------------------------------------------------------------------------
OnDrawHud:
	JSL.l DrawChallengeTimer ; this has to come before NewDrawHud because the timer overwrites the compass counter
	JSL.l NewDrawHud
	JSL.l SwapSpriteIfNecissary
JML.l ReturnFromOnDrawHud
;--------------------------------------------------------------------------------
;OnDungeonEntrance:
;	STA $7EC172 ; thing we wrote over
;RTL
;--------------------------------------------------------------------------------
OnPlayerDead:
	PHA
		JSL.l SetDeathWorldChecked
		JSL.l SetSilverBowMode
		JSL.l RefreshRainAmmo
	PLA
RTL
;--------------------------------------------------------------------------------
OnDungeonExit:
	PHA : PHP
		SEP #$20 ; set 8-bit accumulator
		JSL.l PodEGFix
	PLP : PLA

	STA $040C : STZ $04AC ; thing we wrote over
	
	PHA : PHP
		JSL.l HUD_RebuildLong
		JSL.l FloodGateResetInner
		JSL.l SetSilverBowMode
	PLP : PLA
RTL
;--------------------------------------------------------------------------------
OnQuit:
	JSL.l PodEGFix

	LDA.b #$10 : STA $1C ; thing we wrote over
RTL
;--------------------------------------------------------------------------------
OnUncleItemGet:
	JSL Link_ReceiveItem
	
	LDA.l EscapeAssist
	BIT.b #$04 : BEQ + : STA !INFINITE_MAGIC : +
	BIT.b #$02 : BEQ + : STA !INFINITE_BOMBS : +
	BIT.b #$01 : BEQ + : STA !INFINITE_ARROWS : +

	LDA.l UncleRefill : BIT.b #$04 : BEQ + : LDA.b #$80 : STA $7EF373 : + ; refill magic
	LDA.l UncleRefill : BIT.b #$02 : BEQ + : LDA.b #50 : STA $7EF375 : + ; refill bombs
	LDA.l UncleRefill : BIT.b #$01 : BEQ + ; refill arrows
		LDA.b #70 : STA $7EF376 
		
		LDA.l ArrowMode : BEQ +
			LDA !INVENTORY_SWAP_2 : ORA #$80 : STA !INVENTORY_SWAP_2 ; enable bow toggle
			REP #$20 ; set 16-bit accumulator
			LDA $7EF360 : !ADD.l FreeUncleItemAmount : STA $7EF360 ; rupee arrows, so also give the player some money to start
			SEP #$20 ; set 8-bit accumulator
	+ 
RTL
;--------------------------------------------------------------------------------
OnAga2Defeated:
	JSL.l Dungeon_SaveRoomData_justKeys ; thing we wrote over, make sure this is first
	JSL.l IncrementAgahnim2Sword
RTL
;--------------------------------------------------------------------------------
!RNG_ITEM_LOCK_IN = "$7F5090"
OnFileLoad:
	REP #$10 ; set 16 bit index registers
	JSL.l EnableForceBlank ; what we wrote over

	LDA.b #$07 : STA $210c ; Restore screen 3 to normal tile area

	LDA !FRESH_FILE_MARKER : BNE +
		JSL.l OnNewFile
		LDA.b #$FF : STA !FRESH_FILE_MARKER
	+
	LDA.w $010A : BNE + ; don't adjust the worlds for "continue" or "save-continue"
	LDA.l $7EC011 : BNE + ; don't adjust worlds if mosiac is enabled (Read: mirroring in dungeon)
		JSL.l DoWorldFix
	+
	JSL.l MasterSwordFollowerClear
	JSL.l InitOpenMode
	LDA #$FF : STA !RNG_ITEM_LOCK_IN ; reset rng item lock-in
	LDA #$00 : STA $7F5001 ; mark fake flipper softlock as impossible
	LDA.l GenericKeys : BEQ +
		LDA $7EF38B : STA $7EF36F ; copy generic keys to key counter
	+

	JSL.l SetSilverBowMode
	JSL.l RefreshRainAmmo
	JSL.l SetEscapeAssist

	LDA.l IsEncrypted : CMP.b #01 : BNE +
		JSL LoadStaticDecryptionKey
	+
	SEP #$10 ; restore 8 bit index registers
RTL
;--------------------------------------------------------------------------------
!RNG_ITEM_LOCK_IN = "$7F5090"
OnNewFile:
	PHX : PHP
		REP #$20 ; set 16-bit accumulator
		LDA.l LinkStartingRupees : STA $7EF362 : STA $7EF360
		LDA.l StartingTime : STA $7EF454
		LDA.l StartingTime+2 : STA $7EF454+2

		LDX.w #$00 : - ; copy over starting equipment
			LDA StartingEquipment, X : STA $7EF340, X
			INX : INX
		CPX.w #$004F : !BLT -

		SEP #$20 ; set 8-bit accumulator
		;LDA #$FF : STA !RNG_ITEM_LOCK_IN ; reset rng item lock-in
		LDA.l PreopenCurtains : BEQ +
			LDA.b #$80 : STA $7EF061 ; open aga tower curtain
			LDA.b #$80 : STA $7EF093 ; open skull woods curtain
		+
		LDA StartingSword : STA $7EF359 ; set starting sword type
	PLP : PLX
RTL
;--------------------------------------------------------------------------------
OnInitFileSelect:
	; LDA.b #$10 : STA $BC ; init sprite pointer - does nothing unless spriteswap.asm is included
	; JSL.l SpriteSwap_SetSprite
	LDA.b #$51 : STA $0AA2 ;<-- Line missing from JP1.0, needed to ensure "extra" copy of naming screen graphics are loaded.
	JSL.l EnableForceBlank
RTL
;--------------------------------------------------------------------------------
OnLinkDamaged:
	JSL.l FlipperKill
	JSL.l OHKOTimer
RTL
;--------------------------------------------------------------------------------
OnEnterWater:
	JSL.l RegisterWaterEntryScreen

	JSL.l MysteryWaterFunction
	LDX.b #$04
RTL
;--------------------------------------------------------------------------------
OnLinkDamagedFromPit:
	JSL.l OHKOTimer
	LDA.b #$14 : STA $11 ; thing we wrote over
RTL
;--------------------------------------------------------------------------------
OnLinkDamagedFromPitOutdoors:
	JSL.l OHKOTimer ; make sure this is last
RTL
;--------------------------------------------------------------------------------
!RNG_ITEM_LOCK_IN = "$7F5090"
OnOWTransition:
	JSL.l FloodGateReset
	JSL.l FlipperFlag
	JSL.l StatTransitionCounter
	PHP
	SEP #$20 ; set 8-bit accumulator
	LDA.b #$FF : STA !RNG_ITEM_LOCK_IN ; clear lock-in
	PLP
RTL
;--------------------------------------------------------------------------------
!DARK_DUCK_TEMP = "$7F509C"
OnLoadDuckMap:
	LDA !DARK_DUCK_TEMP
	BNE +
		INC : STA !DARK_DUCK_TEMP
		JSL OverworldMap_InitGfx : DEC $0200
		
		RTL
	+
	LDA.b #$00 : STA !DARK_DUCK_TEMP
	JSL OverworldMap_DarkWorldTilemap
RTL
;--------------------------------------------------------------------------------
PreItemGet:
	LDA.b #$01 : STA !ITEM_BUSY ; mark item as busy
RTL
;--------------------------------------------------------------------------------
PostItemGet:
	JSL.l MaybeWriteSRAMTrace
RTL
;--------------------------------------------------------------------------------
PostItemAnimation:
	LDA.b #$00 : STA !ITEM_BUSY ; mark item as finished

	LDA $7F50A0 : BEQ +
		STZ $1CF0 : STZ $1CF1 ; reset decompression buffer
		JSL.l Main_ShowTextMessage_Alt
		LDA.b #$00 : STA $7F50A0
	+

    STZ $02E9 : LDA $0C5E, X ; thing we wrote over to get here
RTL
;--------------------------------------------------------------------------------
