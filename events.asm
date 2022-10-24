;--------------------------------------------------------------------------------
; OnLoadOW
;--------------------------------------------------------------------------------
;OnLoadMap:
;	LDA OverworldEventDataWRAM+$5B ; thing we wrote over
;RTL
;--------------------------------------------------------------------------------
OnPrepFileSelect:
	LDA $11 : CMP.b #$03 : BNE +
		LDA.b #$06 : STA $14 ; thing we wrote over
		RTL
	+
	JSL.l LoadAlphabetTilemap
	JML.l LoadFullItemTiles
;--------------------------------------------------------------------------------
OnDrawHud:
	JSL.l DrawChallengeTimer ; this has to come before NewDrawHud because the timer overwrites the compass counter
	JSL.l NewDrawHud
	JSL.l SwapSpriteIfNecessary
	JSL.l CuccoStorm
	JSL.l PollService
JML.l ReturnFromOnDrawHud
;--------------------------------------------------------------------------------
OnDungeonEntrance:
	STA $7EC172 ; thing we wrote over
        JSL MaybeFlagCompassTotalEntrance
RTL
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
		JSL.l SQEGFix
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
	JSL.l SQEGFix
	LDA.b #$00 : STA $7F5035 ; bandaid patch bug with mirroring away from text
	LDA.b #$10 : STA $1C ; thing we wrote over
RTL
;--------------------------------------------------------------------------------
OnUncleItemGet:
	PHA

	LDA.l EscapeAssist
	BIT.b #$04 : BEQ + : STA !INFINITE_MAGIC : +
	BIT.b #$02 : BEQ + : STA InfiniteBombs : +
	BIT.b #$01 : BEQ + : STA !INFINITE_ARROWS : +

	PLA
	JSL.l Link_ReceiveItem

	LDA.l UncleRefill : BIT.b #$04 : BEQ + : LDA.b #$80 : STA.l MagicFiller : + ; refill magic
	LDA.l UncleRefill : BIT.b #$02 : BEQ + : LDA.b #50 : STA.l BombsFiller : + ; refill bombs
	LDA.l UncleRefill : BIT.b #$01 : BEQ + ; refill arrows
		LDA.b #70 : STA.l ArrowsFiller

		LDA.l ArrowMode : BEQ +
			LDA.l BowTracking : ORA.b #$80 : STA.l BowTracking ; enable bow toggle
			REP #$20 ; set 16-bit accumulator
			LDA.l CurrentRupees : !ADD.l FreeUncleItemAmount : STA.l CurrentRupees ; rupee arrows, so also give the player some money to start
			SEP #$20 ; set 8-bit accumulator
	+
        LDA.l ProgressIndicator : BNE +
                LDA.b #$01 : STA.l ProgressIndicator ; handle rain state
        +
RTL
;--------------------------------------------------------------------------------
OnAga2Defeated:
        JSL.l Dungeon_SaveRoomData_justKeys ; thing we wrote over, make sure this is first
        LDA.b #$01 : STA.l Aga2Duck
        JML.l IncrementAgahnim2Sword
;--------------------------------------------------------------------------------
OnFileCreation:
        ; Copy initial SRAM state from ROM to cart SRAM
        ; If the inital SRAM table is move these addresses must be changed
        PHB
        LDA.w #$03D7                ; \
        LDX.w #$B000                ;  | Copies from beginning of inital sram table up to file name
        LDY.w #$0000                ;  | (exclusively)
        MVN SRAMBank, SRAMTableBank ; /
                                    ; Skip file name and validity value
        LDA.w #$010C                ; \
        LDX.w #$B3E3                ;  | Rando-Specific Assignments & Game Stats block
        LDY.w #$03E3                ;  |
        MVN SRAMBank, SRAMTableBank ; /
        PLB

        ; resolve instant post-aga if standard
        SEP #$20
        LDA.l InitProgressIndicator : BIT #$80 : BEQ +
                LDA.b #$00 : STA.l ProgressIndicatorSRAM  ; set post-aga after zelda rescue
                LDA.b #$00 : STA.l OverworldEventDataSRAM+$02 ; keep rain state vanilla
        +
        REP #$20

        ; Set validity value and do some cleanup. Jump to checksum.
        LDA.w #$55AA : STA.l $7003E1
        STZ $00
        STZ $01
        LDX.b $00
        LDY.w #$0000
        TYA

JML.l InitializeSaveFile_build_checksum
;--------------------------------------------------------------------------------
!RNG_ITEM_LOCK_IN = "$7F5090"
OnFileLoad:
	REP #$10 ; set 16 bit index registers
	JSL.l EnableForceBlank ; what we wrote over

	LDA.b #$07 : STA $210C ; Restore screen 3 to normal tile area

	LDA.l FileMarker : BNE +
		JSL.l OnNewFile
		LDA.b #$FF : STA.l FileMarker
	+
	LDA.w $010A : BNE + ; don't adjust the worlds for "continue" or "save-continue"
	LDA.l $7EC011 : BNE + ; don't adjust worlds if mosiac is enabled (Read: mirroring in dungeon)
		JSL.l DoWorldFix
	+
	JSL.l MasterSwordFollowerClear
	LDA.b #$FF : STA !RNG_ITEM_LOCK_IN ; reset rng item lock-in
	LDA.b #$00 : STA $7F5001 ; mark fake flipper softlock as impossible
	LDA.l GenericKeys : BEQ +
		LDA.l CurrentGenericKeys : STA.l CurrentSmallKeys ; copy generic keys to key counter
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
		; reset some values on new file that are otherwise only reset on hard reset
		SEP #$20 ; set 8-bit accumulator
		STZ $03C4 ; ancilla slot index
		STZ $047A ; EG
		STZ $0B08 : STZ $0B09 ; arc variable
		STZ $0CFB ; enemies killed (pull trees)
		STZ $0CFC ; times taken damage (pull trees)
		STZ $0FC7 : STZ $0FC8 : STZ $0FC9 : STZ $0FCA : STZ $0FCB : STZ $0FCC : STZ $0FCD ; prize packs
		LDA #$00 : STA $7EC011 ; mosaic
		JSL InitRNGPointerTable ; boss RNG
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
	JSL.l IncrementDamageTakenCounter_Arb
	;JSL.l FlipperKill
	JML.l OHKOTimer

;--------------------------------------------------------------------------------
OnEnterWater:
	JSL.l RegisterWaterEntryScreen

	JSL.l MysteryWaterFunction
	LDX.b #$04
RTL
;--------------------------------------------------------------------------------
OnLinkDamagedFromPit:
	JSL.l OHKOTimer

	LDA.l AllowAccidentalMajorGlitch
	BEQ ++
--	LDA.b #$14 : STA $11 ; thing we wrote over

	RTL

++	LDA.b $10 : CMP.b #$12 : BNE --

	STZ.b $11
	RTL
;--------------------------------------------------------------------------------
OnLinkDamagedFromPitOutdoors:
	JML.l OHKOTimer ; make sure this is last

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
	JML OverworldMap_DarkWorldTilemap

;--------------------------------------------------------------------------------
PreItemGet:
	LDA.b #$01 : STA !ITEM_BUSY ; mark item as busy
RTL
;--------------------------------------------------------------------------------
PostItemGet:

RTL
;--------------------------------------------------------------------------------
PostItemAnimation:
	LDA.b #$00 : STA !ITEM_BUSY ; mark item as finished

	LDA $7F509F : BEQ +
		STZ $1CF0 : STZ $1CF1 ; reset decompression buffer
		JSL.l Main_ShowTextMessage_Alt
		LDA.b #$00 : STA $7F509F
	+

	LDA.w $02E9 : CMP.b #$01 : BNE +
		LDA.b $2F : BEQ +
			JSL.l IncrementChestTurnCounter
	+

    STZ $02E9 : LDA $0C5E, X ; thing we wrote over to get here
RTL
;--------------------------------------------------------------------------------
