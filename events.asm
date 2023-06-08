OnPrepFileSelect:
	LDA.b GameSubMode : CMP.b #$03 : BNE +
		LDA.b #$06 : STA.b NMISTRIPES ; thing we wrote over
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
	STA.l PegColor ; thing we wrote over
        JSL MaybeFlagDungeonTotalsEntrance
        INC.w UpdateHUD
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

	STA.w DungeonID : STZ.w Map16ChangeIndex ; thing we wrote over

	PHA : PHP
		JSL.l HUD_RebuildLong
                INC.w UpdateHUD
		JSL.l FloodGateResetInner
		JSL.l SetSilverBowMode
	PLP : PLA
RTL
;--------------------------------------------------------------------------------
OnQuit:
	JSL.l SQEGFix
	LDA.b #$00 : STA.l AltTextFlag ; bandaid patch bug with mirroring away from text
	LDA.b #$10 : STA.b MAINDESQ ; thing we wrote over
RTL
;--------------------------------------------------------------------------------
OnUncleItemGet:
	PHA

	LDA.l EscapeAssist
	BIT.b #$04 : BEQ + : STA.l InfiniteMagic : +
	BIT.b #$02 : BEQ + : STA.l InfiniteBombs : +
	BIT.b #$01 : BEQ + : STA.l InfiniteArrows : +

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
        LDA.w #$03D7                  ; \
        LDX.w #$B000                  ;  | Copies from beginning of inital sram table up to file name
        LDY.w #$0000                  ;  | (exclusively)
        MVN !SRAMBank, !SRAMTableBank ; /
                                      ; Skip file name and validity value
        LDA.w #$010C                  ; \
        LDX.w #$B3E3                  ;  | Rando-Specific Assignments & Game Stats block
        LDY.w #$03E3                  ;  |
        MVN !SRAMBank, !SRAMTableBank ; /
        PLB

        ; resolve instant post-aga if standard
        SEP #$20
        LDA.l InitProgressIndicator : BIT #$80 : BEQ +
                LDA.b #$00 : STA.l ProgressIndicatorSRAM  ; set post-aga after zelda rescue
                LDA.b #$00 : STA.l OverworldEventDataSRAM+$02 ; keep rain state vanilla
        +
        REP #$20

        ; Set validity value and do some cleanup. Jump to checksum.
        LDA.w #$55AA : STA.l FileValiditySRAM
        JSL.l WriteNewFileChecksum
        STZ.b Scrap00
        STZ.b Scrap01

JML.l InitializeSaveFile_done
;--------------------------------------------------------------------------------
OnFileLoad:
	REP #$10 ; set 16 bit index registers
	JSL.l EnableForceBlank ; what we wrote over

	LDA.b #$07 : STA.w BG34NBA ; Restore screen 3 to normal tile area

	LDA.l FileMarker : BNE +
		JSL.l OnNewFile
		LDA.b #$FF : STA.l FileMarker
	+
	LDA.w DeathReloadFlag : BNE + ; don't adjust the worlds for "continue" or "save-continue"
	LDA.l MosaicLevel : BNE + ; don't adjust worlds if mosiac is enabled (Read: mirroring in dungeon)
		JSL.l DoWorldFix
	+
	JSL.l MasterSwordFollowerClear
	LDA.b #$FF : STA.l RNGLockIn ; reset rng item lock-in
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
OnNewFile:
	PHX : PHP
		; reset some values on new file that are otherwise only reset on hard reset
		SEP #$20 ; set 8-bit accumulator
		STZ.w AncillaSearch
		STZ.w LayerAdjustment ; EG
		STZ.w ArcVariable : STZ.w ArcVariable+1
		STZ.w TreePullKills
		STZ.w TreePullHits
		STZ.w PrizePackIndexes
                STZ.w PrizePackIndexes+1
                STZ.w PrizePackIndexes+2
                STZ.w PrizePackIndexes+3
                STZ.w PrizePackIndexes+4
                STZ.w PrizePackIndexes+5
                STZ.w PrizePackIndexes+6
		LDA.b #$00 : STA.l MosaicLevel
		JSL InitRNGPointerTable
	PLP : PLX
RTL
;--------------------------------------------------------------------------------
OnInitFileSelect:
	LDA.b #$51 : STA.w $0AA2 ;<-- Line missing from JP1.0, needed to ensure "extra" copy of naming screen graphics are loaded.
	JSL.l EnableForceBlank
RTL
;--------------------------------------------------------------------------------
OnLinkDamaged:
	JSL.l IncrementDamageTakenCounter_Arb
	JML.l OHKOTimer
;--------------------------------------------------------------------------------
;OnEnterWater:
;       JSL.l UnequipCapeQuiet ; what we wrote over
;RTL
;--------------------------------------------------------------------------------
OnLinkDamagedFromPit:
	JSL.l OHKOTimer

	LDA.l AllowAccidentalMajorGlitch
	BEQ ++
--	LDA.b #$14 : STA.b GameSubMode ; thing we wrote over

	RTL

++	LDA.b GameMode : CMP.b #$12 : BNE --

	STZ.b GameSubMode
	RTL
;--------------------------------------------------------------------------------
OnLinkDamagedFromPitOutdoors:
	JML.l OHKOTimer ; make sure this is last
;--------------------------------------------------------------------------------
OnOWTransition:
	JSL.l FloodGateReset
	JSL.l StatTransitionCounter
	PHP
	SEP #$20 ; set 8-bit accumulator
	LDA.b #$FF : STA.l RNGLockIn ; clear lock-in
	PLP
RTL
;--------------------------------------------------------------------------------
OnLoadDuckMap:
	LDA.l DuckMapFlag
	BNE +
		INC : STA.l DuckMapFlag
		JSL OverworldMap_InitGfx : DEC.w SubModuleInterface
		RTL
	+
	LDA.b #$00 : STA.l DuckMapFlag
	JML OverworldMap_DarkWorldTilemap
;--------------------------------------------------------------------------------
PreItemGet:
	LDA.b #$01 : STA.l BusyItem ; mark item as busy
RTL
;--------------------------------------------------------------------------------
PostItemGet:

RTL
;--------------------------------------------------------------------------------
PostItemAnimation:
	LDA.b #$00 : STA.l BusyItem ; mark item as finished

	LDA.l TextBoxDefer : BEQ +
		STZ.w TextID : STZ.w TextID+1 ; reset decompression buffer
		JSL.l Main_ShowTextMessage_Alt
		LDA.b #$00 : STA.l TextBoxDefer
	+

	LDA.w ItemReceiptMethod : CMP.b #$01 : BNE +
		LDA.b LinkDirection : BEQ +
			JSL.l IncrementChestTurnCounter
	+

    STZ.w ItemReceiptMethod : LDA.w AncillaGet, X ; thing we wrote over to get here
RTL
;--------------------------------------------------------------------------------
