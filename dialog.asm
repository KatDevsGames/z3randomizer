;================================================================================
; Dialog Pointer Override
;--------------------------------------------------------------------------------
DialogOverride:
	LDA.l AltTextFlag : BEQ .skip
	LDA.l DialogBuffer, X ; use alternate buffer
RTL
	.skip
    LDA.l DecompressionBuffer+$1200, X
RTL

ResetDialogPointer:
	STZ.w TextID : STZ.w TextID+1 ; reset decompression buffer
	LDA.b #$00 : STA.l AltTextFlag ; zero out the alternate flag
	LDA.b #$1C : STA.w DelayTimer ; thing we wrote over
RTL

macro LoadDialogAddress(address)
	PHA : PHX : PHY
	PHP
	PHB : PHK : PLB
		SEP #$20 ; set 8-bit accumulator
		REP #$10 ; set 16-bit index registers
		PEI.b ($00)
		LDA.b Scrap02 : PHA
			STZ.w TextID : STZ.w TextID+1 ; reset decompression buffer
			LDA.b #$01 : STA.l AltTextFlag ; set flag
			%CopyDialog(<address>)
		PLA : STA.b Scrap02
		REP #$20
		PLA : STA.b Scrap00
	PLB
	PLP
	PLY : PLX : PLA
endmacro
;--------------------------------------------------------------------------------
macro CopyDialog(address)
	LDA.b #<address> : STA.b Scrap00 ; write pointer to direct page
	LDA.b #<address>>>8 : STA.b Scrap01
	LDA.b #<address>>>16 : STA.b Scrap02
	%CopyDialogIndirect()
endmacro
;--------------------------------------------------------------------------------
macro CopyDialogIndirect()
	REP #$20 : LDA.l DialogOffsetPointer : TAX : LDY.w #$0000 : SEP #$20 ; copy 2-byte offset pointer to X and set Y to 0
	?loop:
		LDA.b [$00], Y ; load the next character from the pointer
		STA.l DialogBuffer, X ; write to the buffer
		INX : INY
	CMP.b #$7F : BNE ?loop
	REP #$20 ; set 16-bit accumulator
	TXA : INC : STA.l DialogReturnPointer ; copy out X into
	LDA.w #$0000 : STA.l DialogOffsetPointer
	SEP #$20 ; set 8-bit accumulator
endmacro
;--------------------------------------------------------------------------------
LoadDialogAddressIndirect:
	STZ.w TextID : STZ.w TextID+1 ; reset decompression buffer
	LDA.b #$01 : STA.l AltTextFlag ; set flag
	%CopyDialogIndirect()
RTL
;--------------------------------------------------------------------------------
FreeDungeonItemNotice:
        STA.l ScratchBufferV

        PHA : PHX : PHY
        PHP
        PHB : PHK : PLB
        SEP #$20 ; set 8-bit accumulator
        REP #$10 ; set 16-bit index registers
        PEI.b (Scrap00)
        LDA.b Scrap02 : PHA
        LDA.l ScratchBufferNV : PHA
        LDA.l ScratchBufferNV+1 : PHA
	;--------------------------------

	LDA.l FreeItemText : BNE + : JMP .skip : +

	LDA.b #$00 : STA.l ScratchBufferNV ; initialize scratch
	LDA.l FreeItemText : AND.b #$01 : BEQ + ; show message for general small key
	LDA.l ScratchBufferV : CMP.b #$24 : BNE + ; general small key
		%CopyDialog(Notice_SmallKeyOf)
		LDA.l DialogReturnPointer : DEC #2 : STA.l DialogOffsetPointer
		%CopyDialog(Notice_Self)
		JMP .done
	+ : LDA.l FreeItemText : AND.b #$02 : BEQ + ; show message for general compass
	LDA.l ScratchBufferV : CMP.b #$25 : BNE + ; general compass
		%CopyDialog(Notice_CompassOf)
		LDA.l DialogReturnPointer : DEC #2 : STA.l DialogOffsetPointer
		%CopyDialog(Notice_Self)
		JMP .done
	+ : LDA.l FreeItemText : AND.b #$04 : BEQ + ; show message for general map
	LDA.l ScratchBufferV : CMP.b #$33 : BNE + ; general map
		%CopyDialog(Notice_MapOf)
		LDA.l DialogReturnPointer : DEC #2 : STA.l DialogOffsetPointer
		%CopyDialog(Notice_Self)
		JMP .done
	+ : LDA.l FreeItemText : AND.b #$08 : BEQ + ; show message for general big key
	LDA.l ScratchBufferV : CMP.b #$32 : BNE + ; general big key
		%CopyDialog(Notice_BigKeyOf)
		LDA.l DialogReturnPointer : DEC #2 : STA.l DialogOffsetPointer
		%CopyDialog(Notice_Self)
		JMP .done
	+
	LDA.l FreeItemText : AND.b #$04 : BEQ + ; show message for dungeon map
	LDA.l ScratchBufferV : AND.b #$F0 ; looking at high bits only
	CMP.b #$70 : BNE + ; map of...
		%CopyDialog(Notice_MapOf)
		JMP .dungeon
	+ : LDA.l FreeItemText : AND.b #$02 : BEQ + ; show message for dungeon compass
	LDA.l ScratchBufferV : AND.b #$F0 : CMP.b #$80 : BNE + ; compass of...
		%CopyDialog(Notice_CompassOf)
		JMP .dungeon
	+ : LDA.l FreeItemText : AND.b #$08 : BEQ + ; show message for dungeon big key
	LDA.l ScratchBufferV : AND.b #$F0 : CMP.b #$90 : BNE + ; big key of...
		%CopyDialog(Notice_BigKeyOf)
		JMP .dungeon
	+ : LDA.l FreeItemText : AND.b #$01 : BEQ + ; show message for dungeon small key
	LDA.l ScratchBufferV : AND.b #$F0 : CMP.b #$A0 : BNE + ; small key of...
		LDA.l ScratchBufferV : CMP.b #$AF : BNE ++ : JMP .skip : ++
		%CopyDialog(Notice_SmallKeyOf)
		LDA.b #$01 : STA.l ScratchBufferNV ; set up a flip for small keys
		BRA .dungeon
	+ : LDA.l FreeItemText : AND.b #$20 : BEQ + ; show message for crystal
	LDA.l ScratchBufferV : CMP.b #$B0 : !BLT + ;  crystal #
                               CMP.b #$B7 : !BGE +
		%CopyDialog(Notice_Crystal)
		JMP .crystal
        +
	JMP .skip ; it's not something we are going to give a notice for

	.dungeon
	LDA.l DialogReturnPointer : DEC #2 : STA.l DialogOffsetPointer
	LDA.l ScratchBufferV
	AND.b #$0F
	STA.l ScratchBufferNV+1
	LDA.l ScratchBufferNV : BEQ +
		LDA.l ScratchBufferNV
		LDA.b #$0F : !SUB.l ScratchBufferNV+1 : STA.l ScratchBufferNV+1 ; flip the values for small keys
	+
	LDA.l ScratchBufferNV+1
        ASL : TAX
        REP #$20
        LDA.l DungeonItemIDMap,X : CMP.w #$0003 : BCC .hc_sewers
                                   CMP.w DungeonID : BNE +
                BRA .self_notice
                .hc_sewers
                LDA.w DungeonID : CMP.w #$0003 : BCS +
                        .self_notice
                        SEP #$20
		        %CopyDialog(Notice_Self)
                        JMP.w .done
        +
        SEP #$20
	LDA.l ScratchBufferNV+1
	CMP.b #$00 : BNE + ; ...light world
		%CopyDialog(Notice_LightWorld) : JMP .done
	+ : CMP.b #$01 : BNE + ; ...dark world
		%CopyDialog(Notice_DarkWorld) : JMP .done
	+ : CMP.b #$02 : BNE + ; ...ganon's tower
		%CopyDialog(Notice_GTower) : JMP .done
	+ : CMP.b #$03 : BNE + ; ...turtle rock
		%CopyDialog(Notice_TRock) : JMP .done
	+ : CMP.b #$04 : BNE + ; ...thieves' town
		%CopyDialog(Notice_Thieves) : JMP .done
	+ : CMP.b #$05 : BNE + ; ...tower of hera
		%CopyDialog(Notice_Hera) : JMP .done
	+ : CMP.b #$06 : BNE + ; ...ice palace
		%CopyDialog(Notice_Ice) : JMP .done
	+ : CMP.b #$07 : BNE + ; ...skull woods
		%CopyDialog(Notice_Skull) : JMP .done
	+ : CMP.b #$08 : BNE + ; ...misery mire
		%CopyDialog(Notice_Mire) : JMP .done
	+ : CMP.b #$09 : BNE + ; ...dark palace
		%CopyDialog(Notice_PoD) : JMP .done
	+ : CMP.b #$0A : BNE + ; ...swamp palace
		%CopyDialog(Notice_Swamp) : JMP .done
	+ : CMP.b #$0B : BNE + ; ...agahnim's tower
		%CopyDialog(Notice_AgaTower) : JMP .done
	+ : CMP.b #$0C : BNE + ; ...desert palace
		%CopyDialog(Notice_Desert) : JMP .done
	+ : CMP.b #$0D : BNE + ; ...eastern palace
		%CopyDialog(Notice_Eastern) : JMP .done
	+ : CMP.b #$0E : BNE + ; ...hyrule castle
		%CopyDialog(Notice_Castle) : JMP .done
	+ : CMP.b #$0F : BNE + ; ...sewers
		%CopyDialog(Notice_Sewers)
	+
        JMP .done

        .crystal
	LDA.l DialogReturnPointer : DEC #2 : STA.l DialogOffsetPointer
	LDA.l ScratchBufferV
	AND.b #$0F ; looking at low bits only
	CMP.b #$00 : BNE +
		%CopyDialog(Notice_Six) : JMP .done
	+ : CMP.b #$01 : BNE +
		%CopyDialog(Notice_One) : JMP .done
	+ : CMP.b #$02 : BNE +
		%CopyDialog(Notice_Five) : JMP .done
	+ : CMP.b #$03 : BNE +
		%CopyDialog(Notice_Seven) : JMP .done
	+ : CMP.b #$04 : BNE +
		%CopyDialog(Notice_Two) : JMP .done
	+ : CMP.b #$05 : BNE +
		%CopyDialog(Notice_Four) : JMP .done
	+ : CMP.b #$06 : BNE +
		%CopyDialog(Notice_Three) : JMP .done
        +

	.done

	STZ.w TextID : STZ.w TextID+1 ; reset decompression buffer
	LDA.b #$01 : STA.l AltTextFlag ; set alternate dialog flag
	STA.l TextBoxDefer

	;--------------------------------
	.skip
        PLA : STA.l ScratchBufferNV+1
        PLA : STA.l ScratchBufferNV
        PLA : STA.b Scrap02
        REP #$20
        PLA : STA.b Scrap00
        PLB
        PLP
        PLY : PLX : PLA
RTL

;--------------------------------------------------------------------------------
DialogResetSelectionIndex:
    JSL.l Attract_DecompressStoryGfx ; what we wrote over
    STZ.w MessageCursor
RTL
;--------------------------------------------------------------------------------
DialogItemReceive:
	BCS .nomessage ; if doubling the item value overflowed it must be a rando item
	CPY.b #$98 : BCC ++ ;if the item is $4C or greater it must be a rando item
.nomessage
	LDA.w #$FFFF

	BRA .done

++	LDA.w Ancilla_ReceiveItem_item_messages, Y
	.done
	CMP.w #$FFFF
RTL
;--------------------------------------------------------------------------------
DialogFairyThrow:
	LDA.l Restrict_Ponds : BEQ .normal
	LDA.l BottleContentsOne
        ORA.l BottleContentsTwo : ORA.l BottleContentsThree : ORA.l BottleContentsFour : BNE .normal
	
	.noInventory
	LDA.w SpriteActivity, X : !ADD #$08 : STA.w SpriteActivity, X
	LDA.b #$51
	LDY.b #$01
RTL
	.normal
	LDA.b #$88
	LDY.b #$00
RTL
;--------------------------------------------------------------------------------
DialogGanon1:
	JSL.l CheckGanonVulnerability
	REP #$20
	LDA.w #$018C
	BCC +
	LDA.w #$016D
+	STA.w TextID
	SEP #$20
	JSL.l Sprite_ShowMessageMinimal_Alt
RTL
;--------------------------------------------------------------------------------
; #$0192 - no bow
; #$0193 - no silvers alternate
; #$0194 - no silvers
; #$0195 - silvers
; BowTracking - bsp-- ---
; b = bow
; s = silver arrow bow
; p = 2nd progressive bow
DialogGanon2:
        JSL.l CheckGanonVulnerability

        REP #$20
        BCS +
        LDA.w #$018D : BRA ++
        +
        LDA.l BowTracking

        BIT.w #$0080 : BNE + ; branch if bow
        LDA.w #$0192 : BRA ++
        +
        BIT.w #$0040 : BEQ + ; branch if no silvers
        LDA.w #$0195 : BRA ++
        +
        BIT.w #$0020 : BNE + ; branch if p bow
        LDA.w #$0194 : BRA ++
        +
        BIT.w #$0080 : BEQ + ; branch if no bow
        LDA.w #$0193 : BRA ++
        +
        LDA.w #$016E
        ++
        STA.w TextID
        SEP #$20
        JSL.l Sprite_ShowMessageMinimal_Alt
RTL
;--------------------------------------------------------------------------------
DialogEtherTablet:
	PHA
	LDA.w ItemCursor : CMP.b #$0F : BEQ + ; Show normal text if book is not equipped
	-
	PLA : JML Sprite_ShowMessageUnconditional ; Wacky Hylian Text
	+
	BIT.b Joy1A_New : BVC - ; Show normal text if Y is not pressed
	LDA.l AllowHammerTablets : BEQ ++
		LDA.l HammerEquipment : BEQ .yesText : BRA .noText
	++
		LDA.l SwordEquipment : CMP.b #$FF : BEQ .yesText : CMP.b #$02 : BCS .noText
	;++
	.yesText
	PLA
	LDA.b #$0C
	LDY.b #$01
	JML Sprite_ShowMessageUnconditional ; Text From MSPedestalText (tables.asm)

	.noText
	PLA
RTL
;--------------------------------------------------------------------------------
DialogBombosTablet:
	PHA
	LDA.w ItemCursor : CMP.b #$0F : BEQ + ; Show normal text if book is not equipped
	-
	PLA : JML Sprite_ShowMessageUnconditional ; Wacky Hylian Text
	+
	BIT.b Joy1A_New : BVC - ; Show normal text if Y is not pressed
	LDA.l AllowHammerTablets : BEQ ++
		LDA.l HammerEquipment : BEQ .yesText : BRA .noText
	++
		LDA.l SwordEquipment : CMP.b #$FF : BEQ .yesText : CMP.b #$02 : !BGE .noText
	;++
	.yesText
	PLA 
	LDA.b #$0D
	LDY.b #$01
	JML Sprite_ShowMessageUnconditional ; Text From MSPedestalText (tables.asm)

	.noText
	PLA
RTL
;--------------------------------------------------------------------------------
DialogSahasrahla:
	LDA.l PendantsField : AND.b #$04 : BEQ + ;Check if player has green pendant
		LDA.b #$2F
        LDY.b #$00
		JML Sprite_ShowMessageUnconditional
	+
RTL
;--------------------------------------------------------------------------------
DialogBombShopGuy:
	LDY.b #$15
	LDA.l CrystalsField : AND.b #$05 : CMP.b #$05 : BNE + ;Check if player has crystals 5 & 6
		INY ; from 15 to 16
	+
	TYA
	LDY.b #$01
	JSL.l Sprite_ShowMessageUnconditional
RTL

;---------------------------------------------------------------------------------------------------
AgahnimAsksAboutPed:
	LDA.l GanonVulnerableMode
	CMP.b #$06 : BNE .vanilla

	LDA.l OverworldEventDataWRAM+$80 ; check ped flag
	AND.b #$40
	BNE .vanilla

	LDA.b #$8C ; message 018C for no ped
	STA.w TextID

.vanilla
	JML $85FA8E ; Sprite_ShowMessageMinimal
;--------------------------------------------------------------------------------
Main_ShowTextMessage_Alt:
	; Are we in text mode? If so then end the routine.
	LDA.b GameMode : CMP.b #$0E : BEQ .already_in_text_mode
Sprite_ShowMessageMinimal_Alt:
	STZ.b GameSubMode

	PHX : PHY
	PEI.b (Scrap00)
	LDA.b Scrap02 : PHA

	LDA.b #$1C : STA.b Scrap02
	REP #$30
		LDA.w TextID : ASL : TAX
		LDA.l $7F71C0, X
		STA.b Scrap00
	SEP #$30

	LDY.b #$00
	      LDA.b [Scrap00], Y : CMP.b #$FE : BNE +
	INY : LDA.b [Scrap00], Y : CMP.b #$6E : BNE +
	INY : LDA.b [Scrap00], Y :            : BNE +
	INY : LDA.b [Scrap00], Y : CMP.b #$FE : BNE +
	INY : LDA.b [Scrap00], Y : CMP.b #$6B : BNE +
	INY : LDA.b [Scrap00], Y : CMP.b #$04 : BNE +
		STZ.w MessageCursor
		JMP .end
	+

	STZ.w MessageJunk   ; Otherwise set it so we are in text mode.
	STZ.w MessageSubModule

	; Go to text display mode (as opposed to maps, etc)
	LDA.b #$02 : STA.b GameSubMode

	; Store the current module in the temporary location.
	LDA.b GameMode : STA.w GameModeCache

	; Switch the main module ($10) to text mode.
	LDA.b #$0E : STA.b GameMode
	.end
	PLA : STA.b Scrap02
	PLA : STA.b Scrap01
	PLA : STA.b Scrap00
	PLY : PLX

Main_ShowTextMessage_Alt_already_in_text_mode:
RTL

CalculateSignIndex:
  ; for the big 1024x1024 screens we are calculating link's effective
  ; screen area, as though the screen was 4 different 512x512 screens.
  ; And we do this in a way that will likely give the right value even 
  ; with major glitches.

  LDA.b OverworldIndex : ASL A : TAY ;what we wrote over

  LDA.w OWScreenSize : BEQ .done ; If a small map, we can skip these calculations.

  LDA.b LinkPosY+1 : AND.w #$0002 : ASL #2 : EOR.b OverworldIndex : AND.w #$0008 : BEQ +
  	TYA : !ADD.w #$0010 : TAY  ;add 16 if we are in lower half of big screen.
  + 

  LDA.b LinkPosX+1 : AND.w #$0002 : LSR : EOR.b OverworldIndex : AND.w #$0001 : BEQ +
  TYA : INC #2 : TAY  ;add 16 if we are in lower half of big screen.
  +
  ; ensure even if things go horribly wrong, we don't read the sign out of bounds and crash:
  TYA : AND.w #$00FF : TAY 

.done
RTL

;================================================================
; Contributor: Myramong
;================================================================
Sprite_ShowSolicitedMessageIfPlayerFacing_Alt:
{
	STA.w TextID
	STY.w TextID+1

	JSL Sprite_CheckDamageToPlayerSameLayerLong : BCC .alpha
	JSL Sprite_CheckIfPlayerPreoccupied : BCS .alpha

	LDA.b Joy1B_New : BPL .alpha
	LDA.w SpriteTimerE, X : BNE .alpha
	LDA.b LinkJumping : CMP.b #$02 : BEQ .alpha

	JSL Sprite_DirectionToFacePlayerLong : PHX : TYX

	; Make sure that the sprite is facing towards the player, otherwise
	; talking can't happen. (What sprites actually use this???)
	LDA.l $85E1A3, X : PLX : CMP.b LinkDirection : BNE .not_facing_each_other

	PHY

	LDA.w TextID
	LDY.w TextID+1

	; Check what room we're in so we know which npc we're talking to
        LDA.b RoomIndex
        CMP.b #$05 : BEQ .SahasrahlaDialogs
        CMP.b #$1C : BEQ .BombShopGuyDialog
        BRA .SayNothing

	.SahasrahlaDialogs
		REP #$20 : LDA.l MapReveal_Sahasrahla : ORA.l MapOverlay : STA.l MapOverlay : SEP #$20
		JSL DialogSahasrahla : BRA .SayNothing

	.BombShopGuyDialog
		REP #$20 : LDA.l MapReveal_BombShop : ORA.l MapOverlay : STA.l MapOverlay : SEP #$20
		JSL DialogBombShopGuy

	.SayNothing

	LDA.b #$40 : STA.w SpriteTimerE, X

	PLA : EOR.b #$03

	SEC

	RTL

.not_facing_each_other
.alpha

	LDA.w SpriteMoveDirection, X

	CLC

	RTL
}
;================================================================
Sprite_ShowSolicitedMessageIfPlayerFacing_PreserveMessage:
{
	PHY
	PHA

	JSL Sprite_CheckDamageToPlayerSameLayerLong : BCC .alpha
	JSL Sprite_CheckIfPlayerPreoccupied : BCS .alpha

	LDA.b Joy1B_New : BPL .alpha
	LDA.w SpriteTimerE, X : BNE .alpha
	LDA.b LinkJumping : CMP.b #$02 : BEQ .alpha

	JSL Sprite_DirectionToFacePlayerLong : PHX : TYX

	; Make sure that the sprite is facing towards the player, otherwise
	; talking can't happen. (What sprites actually use this???)
	LDA.l $85E1A3, X : PLX : CMP.b LinkDirection : BNE .not_facing_each_other

	PLA : XBA : PLA

	PHY

	TAY : XBA
	
	JSL Sprite_ShowMessageUnconditional

	LDA.b #$40 : STA.w SpriteTimerE, X

	PLA : EOR.b #$03

	SEC

	RTL

.not_facing_each_other
.alpha
	PLY
	PLA

	LDA.w SpriteMoveDirection, X

	CLC

	RTL
}

;--------------------------------------------------------------------------------
; A0 - A9 - 0 - 9
; AA - C3 - A - Z
; C6 - ?
; C7 - !
; C8 - ,
; C9 - - Hyphen
; CD - Japanese period
; CE - ~
; D8 - ` apostraphe
;;--------------------------------------------------------------------------------
;DialogUncleData:
;;--------------------------------------------------------------------------------
;	.pointers
;	dl #DialogUncleData_weetabix
;	dl #DialogUncleData_bootlessUntilBoots
;	dl #DialogUncleData_onlyOneBed
;	dl #DialogUncleData_onlyTextBox
;	dl #DialogUncleData_mothTutorial
;	dl #DialogUncleData_seedWorst
;	dl #DialogUncleData_chasingTail
;	dl #DialogUncleData_doneBefore
;	dl #DialogUncleData_capeCanPass
;	dl #DialogUncleData_bootsAtRace
;	dl #DialogUncleData_kanzeonSeed
;	dl #DialogUncleData_notRealUncle
;	dl #DialogUncleData_haveAVeryBadTime
;	dl #DialogUncleData_todayBadLuck
;	dl #DialogUncleData_leavingGoodbye
;	dl #DialogUncleData_iGotThis
;	dl #DialogUncleData_raceToCastle
;	dl #DialogUncleData_69BlazeIt
;	dl #DialogUncleData_hi
;	dl #DialogUncleData_gettingSmokes
;	dl #DialogUncleData_dangerousSeeYa
;	dl #DialogUncleData_badEnoughDude
;	dl #DialogUncleData_iAmError
;	dl #DialogUncleData_sub2Guaranteed
;	dl #DialogUncleData_chestSecretEverybody
;	dl #DialogUncleData_findWindFish
;	dl #DialogUncleData_shortcutToGanon
;	dl #DialogUncleData_moonCrashing
;	dl #DialogUncleData_fightVoldemort
;	dl #DialogUncleData_redMailForCowards
;	dl #DialogUncleData_heyListen
;	dl #DialogUncleData_excuseMePrincess
;;--------------------------------------------------------------------------------
;	.weetabix
;	; We’re out of / Weetabix. To / the store!
;	db $00, $c0, $00, $ae, $00, $d8, $00, $bb, $00, $ae, $00, $ff, $00, $b8, $00, $be, $00, $bd, $00, $ff, $00, $b8, $00, $af
;	db $75, $00, $c0, $00, $ae, $00, $ae, $00, $bd, $00, $aa, $00, $ab, $00, $b2, $00, $c1, $00, $cD, $00, $ff, $00, $bd, $00, $b8
;	db $76, $00, $bd, $00, $b1, $00, $ae, $00, $ff, $00, $bc, $00, $bd, $00, $b8, $00, $bb, $00, $ae, $00, $c7
;	db $7f, $7f
;;--------------------------------------------------------------------------------
;	.bootlessUntilBoots
;	; This seed is / bootless / until boots.
;	db $00, $bd, $00, $b1, $00, $b2, $00, $bc, $00, $ff, $00, $bc, $00, $ae, $00, $ae, $00, $ad, $00, $ff, $00, $b2, $00, $bc
;	db $75, $00, $ab, $00, $b8, $00, $b8, $00, $bd, $00, $b5, $00, $ae, $00, $bc, $00, $bc
;	db $76, $00, $be, $00, $b7, $00, $bd, $00, $b2, $00, $b5, $00, $ff, $00, $ab, $00, $b8, $00, $b8, $00, $bd, $00, $bc, $00, $cD
;	db $7f, $7f
;;--------------------------------------------------------------------------------
;	.onlyOneBed
;	; Why do we only / have one bed?
;	db $00, $c0, $00, $b1, $00, $c2, $00, $ff, $00, $ad, $00, $b8, $00, $ff, $00, $c0, $00, $ae, $00, $ff, $00, $b8, $00, $b7, $00, $b5, $00, $c2
;	db $75, $00, $b1, $00, $aa, $00, $bf, $00, $ae, $00, $ff, $00, $b8, $00, $b7, $00, $ae, $00, $ff, $00, $ab, $00, $ae, $00, $ad, $00, $c6
;	db $7f, $7f
;;--------------------------------------------------------------------------------
;	.onlyTextBox
;	; This is the / only textbox.
;	db $00, $bd, $00, $b1, $00, $b2, $00, $bc, $00, $ff, $00, $b2, $00, $bc, $00, $ff, $00, $bd, $00, $b1, $00, $ae
;	db $75, $00, $b8, $00, $b7, $00, $b5, $00, $c2, $00, $ff, $00, $bd, $00, $ae, $00, $c1, $00, $bd, $00, $ab, $00, $b8, $00, $c1, $00, $cD
;	db $7f, $7f
;;--------------------------------------------------------------------------------
;	.mothTutorial
;	; I'm going to / go watch the / Moth tutorial.
;	db $00, $b2, $00, $d8, $00, $b6, $00, $ff, $00, $b0, $00, $b8, $00, $b2, $00, $b7, $00, $b0, $00, $ff, $00, $bd, $00, $b8
;	db $75, $00, $b0, $00, $b8, $00, $ff, $00, $c0, $00, $aa, $00, $bd, $00, $ac, $00, $b1, $00, $ff, $00, $bd, $00, $b1, $00, $ae
;	db $76, $00, $b6, $00, $b8, $00, $bd, $00, $b1, $00, $ff, $00, $bd, $00, $be, $00, $bd, $00, $b8, $00, $bb, $00, $b2, $00, $aa, $00, $b5, $00, $cD
;	db $7f, $7f
;;--------------------------------------------------------------------------------
;	.seedWorst
;	; This seed is / the worst.
;	db $00, $bd, $00, $b1, $00, $b2, $00, $bc, $00, $ff, $00, $bc, $00, $ae, $00, $ae, $00, $ad, $00, $ff, $00, $b2, $00, $bc
;	db $75, $00, $bd, $00, $b1, $00, $ae, $00, $ff, $00, $c0, $00, $b8, $00, $bb, $00, $bc, $00, $bd, $00, $cD
;	db $7f, $7f
;;--------------------------------------------------------------------------------
;	.chasingTail
;	; Chasing tail. / Fly ladies. / Do not follow.
;	db $00, $ac, $00, $b1, $00, $aa, $00, $bc, $00, $b2, $00, $b7, $00, $b0, $00, $ff, $00, $bd, $00, $aa, $00, $b2, $00, $b5, $00, $cD
;	db $75, $00, $af, $00, $b5, $00, $c2, $00, $ff, $00, $b5, $00, $aa, $00, $ad, $00, $b2, $00, $ae, $00, $bc, $00, $cD
;	db $76, $00, $ad, $00, $b8, $00, $ff, $00, $b7, $00, $b8, $00, $bd, $00, $ff, $00, $af, $00, $b8, $00, $b5, $00, $b5, $00, $b8, $00, $c0, $00, $cD
;	db $7f, $7f
;;--------------------------------------------------------------------------------
;	.doneBefore
;	; I feel like / I’ve done this / before…
;	db $00, $b2, $00, $ff, $00, $af, $00, $ae, $00, $ae, $00, $b5, $00, $ff, $00, $b5, $00, $b2, $00, $b4, $00, $ae
;	db $75, $00, $b2, $00, $d8, $00, $bf, $00, $ae, $00, $ff, $00, $ad, $00, $b8, $00, $b7, $00, $ae, $00, $ff, $00, $bd, $00, $b1, $00, $b2, $00, $bc
;	db $76, $00, $ab, $00, $ae, $00, $af, $00, $b8, $00, $bb, $00, $ae, $00, $cD, $00, $cD, $00, $cD
;	db $7f, $7f
;;--------------------------------------------------------------------------------
;	.capeCanPass
;	; Magic cape can / pass through / the barrier!
;	db $00, $b6, $00, $aa, $00, $b0, $00, $b2, $00, $ac, $00, $ff, $00, $ac, $00, $aa, $00, $b9, $00, $ae, $00, $ff, $00, $ac, $00, $aa, $00, $b7
;	db $75, $00, $b9, $00, $aa, $00, $bc, $00, $bc, $00, $ff, $00, $bd, $00, $b1, $00, $bb, $00, $b8, $00, $be, $00, $b0, $00, $b1
;	db $76, $00, $bd, $00, $b1, $00, $ae, $00, $ff, $00, $ab, $00, $aa, $00, $bb, $00, $bb, $00, $b2, $00, $ae, $00, $bb, $00, $c7
;	db $7f, $7f
;;--------------------------------------------------------------------------------
;	.bootsAtRace
;	; Boots at race? / Seed confirmed / impossible.
;	db $00, $ab, $00, $b8, $00, $b8, $00, $bd, $00, $bc, $00, $ff, $00, $aa, $00, $bd, $00, $ff, $00, $bb, $00, $aa, $00, $ac, $00, $ae, $00, $c6
;	db $75, $00, $bc, $00, $ae, $00, $ae, $00, $ad, $00, $ff, $00, $ac, $00, $b8, $00, $b7, $00, $af, $00, $b2, $00, $bb, $00, $b6, $00, $ae, $00, $ad
;	db $76, $00, $b2, $00, $b6, $00, $b9, $00, $b8, $00, $bc, $00, $bc, $00, $b2, $00, $ab, $00, $b5, $00, $ae, $00, $cD
;	db $7f, $7f
;;--------------------------------------------------------------------------------
;	.kanzeonSeed
;	; If this is a / Kanzeon seed, / I'm quitting.
;	db $00, $b2, $00, $af, $00, $ff, $00, $bd, $00, $b1, $00, $b2, $00, $bc, $00, $ff, $00, $b2, $00, $bc, $00, $ff, $00, $aa
;	db $75, $00, $b4, $00, $aa, $00, $b7, $00, $c3, $00, $ae, $00, $b8, $00, $b7, $00, $ff, $00, $bc, $00, $ae, $00, $ae, $00, $ad, $00, $c8
;	db $76, $00, $b2, $00, $d8, $00, $b6, $00, $ff, $00, $ba, $00, $be, $00, $b2, $00, $bd, $00, $bd, $00, $b2, $00, $b7, $00, $b0, $00, $cD
;	db $7f, $7f
;;--------------------------------------------------------------------------------
;	.notRealUncle
;	; I am not your / real uncle.
;	db $00, $b2, $00, $ff, $00, $aa, $00, $b6, $00, $ff, $00, $b7, $00, $b8, $00, $bd, $00, $ff, $00, $c2, $00, $b8, $00, $be, $00, $bb
;	db $75, $00, $bb, $00, $ae, $00, $aa, $00, $b5, $00, $ff, $00, $be, $00, $b7, $00, $ac, $00, $b5, $00, $ae, $00, $cD
;	db $7f, $7f
;;--------------------------------------------------------------------------------
;	.haveAVeryBadTime
;	; You're going / to have a very / bad time.
;	db $00, $c2, $00, $b8, $00, $be, $00, $d8, $00, $bb, $00, $ae, $00, $ff, $00, $b0, $00, $b8, $00, $b2, $00, $b7, $00, $b0
;	db $75, $00, $bd, $00, $b8, $00, $ff, $00, $b1, $00, $aa, $00, $bf, $00, $ae, $00, $ff, $00, $aa, $00, $ff, $00, $bf, $00, $ae, $00, $bb, $00, $c2
;	db $76, $00, $ab, $00, $aa, $00, $ad, $00, $ff, $00, $bd, $00, $b2, $00, $b6, $00, $ae, $00, $cD
;	db $7f, $7f
;;--------------------------------------------------------------------------------
;	.todayBadLuck
;	; Today you / will have / bad luck.
;	db $00, $bd, $00, $b8, $00, $ad, $00, $aa, $00, $c2, $00, $ff, $00, $c2, $00, $b8, $00, $be, $00, $ff, $00, $c0, $00, $b2, $00, $b5, $00, $b5
;	db $75, $00, $b1, $00, $aa, $00, $bf, $00, $ae, $00, $ff, $00, $ab, $00, $aa, $00, $ad, $00, $ff, $00, $b5, $00, $be, $00, $ac, $00, $b4, $00, $c7
;	db $7f, $7f
;;--------------------------------------------------------------------------------
;	.leavingGoodbye
;	; I am leaving / forever. / Goodbye.
;	db $00, $b2, $00, $ff, $00, $aa, $00, $b6, $00, $ff, $00, $b5, $00, $ae, $00, $aa, $00, $bf, $00, $b2, $00, $b7, $00, $b0
;	db $75, $00, $af, $00, $b8, $00, $bb, $00, $ae, $00, $bf, $00, $ae, $00, $bb, $00, $cD
;	db $76, $00, $b0, $00, $b8, $00, $b8, $00, $ad, $00, $ab, $00, $c2, $00, $ae, $00, $cD
;	db $7f, $7f
;;--------------------------------------------------------------------------------
;	.iGotThis
;	; Don’t worry. / I got this / covered.
;	db $00, $ad, $00, $b8, $00, $b7, $00, $d8, $00, $bd, $00, $ff, $00, $c0, $00, $b8, $00, $bb, $00, $bb, $00, $c2, $00, $cD
;	db $75, $00, $b2, $00, $ff, $00, $b0, $00, $b8, $00, $bd, $00, $ff, $00, $bd, $00, $b1, $00, $b2, $00, $bc
;	db $76, $00, $ac, $00, $b8, $00, $bf, $00, $ae, $00, $bb, $00, $ae, $00, $ad, $00, $cD
;	db $7f, $7f
;;--------------------------------------------------------------------------------
;	.raceToCastle
;	; Race you to / the castle!
;	db $00, $bb, $00, $aa, $00, $ac, $00, $ae, $00, $ff, $00, $c2, $00, $b8, $00, $be, $00, $ff, $00, $bd, $00, $b8
;	db $75, $00, $bd, $00, $b1, $00, $ae, $00, $ff, $00, $ac, $00, $aa, $00, $bc, $00, $bd, $00, $b5, $00, $ae, $00, $c7
;	db $7f, $7f
;;--------------------------------------------------------------------------------
;	.69BlazeIt
;	; ~69 Blaze It!~
;	db $75, $00, $cE, $00, $a6, $00, $a9, $00, $ff, $00, $ab, $00, $b5, $00, $aa, $00, $c3, $00, $ae, $00, $ff, $00, $b2, $00, $bd, $00, $c7, $00, $cE
;	db $7f, $7f
;;--------------------------------------------------------------------------------
;	.hi
;	; hi
;	db $75, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $b1, $00, $b2
;	db $7f, $7f
;;--------------------------------------------------------------------------------
;	.gettingSmokes
;	; I'M JUST GOING / OUT FOR A / PACK OF SMOKES.
;	db $00, $b2, $00, $d8, $00, $b6, $00, $ff, $00, $b3, $00, $be, $00, $bc, $00, $bd, $00, $ff, $00, $b0, $00, $b8, $00, $b2, $00, $b7, $00, $b0
;	db $75, $00, $b8, $00, $be, $00, $bd, $00, $ff, $00, $af, $00, $b8, $00, $bb, $00, $ff, $00, $aa
;	db $76, $00, $b9, $00, $aa, $00, $ac, $00, $b4, $00, $ff, $00, $b8, $00, $af, $00, $ff, $00, $bc, $00, $b6, $00, $b8, $00, $b4, $00, $ae, $00, $bc, $00, $cD
;	db $7f, $7f
;;--------------------------------------------------------------------------------
;	.dangerousSeeYa
;	; It's dangerous / to go alone. / See ya!
;	db $00, $b2, $00, $bd, $00, $d8, $00, $bc, $00, $ff, $00, $ad, $00, $aa, $00, $b7, $00, $b0, $00, $ae, $00, $bb, $00, $b8, $00, $be, $00, $bc
;	db $75, $00, $bd, $00, $b8, $00, $ff, $00, $b0, $00, $b8, $00, $ff, $00, $aa, $00, $b5, $00, $b8, $00, $b7, $00, $ae, $00, $cD
;	db $76, $00, $bc, $00, $ae, $00, $ae, $00, $ff, $00, $c2, $00, $aa, $00, $c7
;	db $7f, $7f
;;--------------------------------------------------------------------------------
;	.badEnoughDude
;	; ARE YOU A BAD / ENOUGH DUDE TO / RESCUE ZELDA?
;	db $00, $aa, $00, $bb, $00, $ae, $00, $ff, $00, $c2, $00, $b8, $00, $be, $00, $ff, $00, $aa, $00, $ff, $00, $ab, $00, $aa, $00, $ad
;	db $75, $00, $ae, $00, $b7, $00, $b8, $00, $be, $00, $b0, $00, $b1, $00, $ff, $00, $ad, $00, $be, $00, $ad, $00, $ae, $00, $ff, $00, $bd, $00, $b8
;	db $76, $00, $bb, $00, $ae, $00, $bc, $00, $ac, $00, $be, $00, $ae, $00, $ff, $00, $c3, $00, $ae, $00, $b5, $00, $ad, $00, $aa, $00, $c6
;	db $7f, $7f
;;--------------------------------------------------------------------------------
;	.iAmError
;	; I AM ERROR
;	db $76, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $b2, $00, $ff, $00, $aa, $00, $b6, $00, $ff, $00, $ae, $00, $bb, $00, $bb, $00, $b8, $00, $bb
;	db $7f, $7f
;;--------------------------------------------------------------------------------
;	.sub2Guaranteed
;	; This seed is / sub 2 hours, / guaranteed.
;	db $00, $bd, $00, $b1, $00, $b2, $00, $bc, $00, $ff, $00, $bc, $00, $ae, $00, $ae, $00, $ad, $00, $ff, $00, $b2, $00, $bc
;	db $75, $00, $bc, $00, $be, $00, $ab, $00, $ff, $00, $a2, $00, $ff, $00, $b1, $00, $b8, $00, $be, $00, $bb, $00, $bc, $00, $c8
;	db $76, $00, $b0, $00, $be, $00, $aa, $00, $bb, $00, $aa, $00, $b7, $00, $bd, $00, $ae, $00, $ae, $00, $ad, $00, $cD
;	db $7f, $7f
;;--------------------------------------------------------------------------------
;	.chestSecretEverybody
;	; The chest is / a secret to / everybody.
;	db $00, $bd, $00, $b1, $00, $ae, $00, $ff, $00, $ac, $00, $b1, $00, $ae, $00, $bc, $00, $bd, $00, $ff, $00, $b2, $00, $bc
;	db $75, $00, $aa, $00, $ff, $00, $bc, $00, $ae, $00, $ac, $00, $bb, $00, $ae, $00, $bd, $00, $ff, $00, $bd, $00, $b8
;	db $76, $00, $ae, $00, $bf, $00, $ae, $00, $bb, $00, $c2, $00, $ab, $00, $b8, $00, $ad, $00, $c2, $00, $cD
;	db $7f, $7f
;;--------------------------------------------------------------------------------
;	.findWindFish
;	; I'm off to / find the / wind fish.
;	db $00, $b2, $00, $d8, $00, $b6, $00, $ff, $00, $b8, $00, $af, $00, $af, $00, $ff, $00, $bd, $00, $b8
;	db $75, $00, $af, $00, $b2, $00, $b7, $00, $ad, $00, $ff, $00, $bd, $00, $b1, $00, $ae
;	db $76, $00, $c0, $00, $b2, $00, $b7, $00, $ad, $00, $ff, $00, $af, $00, $b2, $00, $bc, $00, $b1, $00, $cD
;	db $7f, $7f
;;--------------------------------------------------------------------------------
;	.shortcutToGanon
;	; The shortcut / to Ganon / is this way!
;	db $00, $bd, $00, $b1, $00, $ae, $00, $ff, $00, $bc, $00, $b1, $00, $b8, $00, $bb, $00, $bd, $00, $ac, $00, $be, $00, $bd
;	db $75, $00, $bd, $00, $b8, $00, $ff, $00, $b0, $00, $aa, $00, $b7, $00, $b8, $00, $b7
;	db $76, $00, $b2, $00, $bc, $00, $ff, $00, $bd, $00, $b1, $00, $b2, $00, $bc, $00, $ff, $00, $c0, $00, $aa, $00, $c2, $00, $c7
;	db $7f, $7f
;;--------------------------------------------------------------------------------
;	.moonCrashing
;	; THE MOON IS / CRASHING! RUN / FOR YOUR LIFE!
;	db $00, $bd, $00, $b1, $00, $ae, $00, $ff, $00, $b6, $00, $b8, $00, $b8, $00, $b7, $00, $ff, $00, $b2, $00, $bc
;	db $75, $00, $ac, $00, $bb, $00, $aa, $00, $bc, $00, $b1, $00, $b2, $00, $b7, $00, $b0, $00, $c7, $00, $ff, $00, $bb, $00, $be, $00, $b7
;	db $76, $00, $af, $00, $b8, $00, $bb, $00, $ff, $00, $c2, $00, $b8, $00, $be, $00, $bb, $00, $ff, $00, $b5, $00, $b2, $00, $af, $00, $ae, $00, $c7
;	db $7f, $7f
;;--------------------------------------------------------------------------------
;	.fightVoldemort
;	; Time to fight / he who must / not be named.
;	db $00, $bd, $00, $b2, $00, $b6, $00, $ae, $00, $ff, $00, $bd, $00, $b8, $00, $ff, $00, $af, $00, $b2, $00, $b0, $00, $b1, $00, $bd
;	db $75, $00, $b1, $00, $ae, $00, $ff, $00, $c0, $00, $b1, $00, $b8, $00, $ff, $00, $b6, $00, $be, $00, $bc, $00, $bd
;	db $76, $00, $b7, $00, $b8, $00, $bd, $00, $ff, $00, $ab, $00, $ae, $00, $ff, $00, $b7, $00, $aa, $00, $b6, $00, $ae, $00, $ad, $00, $cD
;	db $7f, $7f
;;--------------------------------------------------------------------------------
;	.redMailForCowards
;	; RED MAIL / IS FOR / COWARDS.
;	db $00, $bb, $00, $ae, $00, $ad, $00, $ff, $00, $b6, $00, $aa, $00, $b2, $00, $b5
;	db $75, $00, $b2, $00, $bc, $00, $ff, $00, $af, $00, $b8, $00, $bb
;	db $76, $00, $ac, $00, $b8, $00, $c0, $00, $aa, $00, $bb, $00, $ad, $00, $bc, $00, $cD
;	db $7f, $7f
;;--------------------------------------------------------------------------------
;	.heyListen
;	; HEY! / / LISTEN!
;	db $00, $b1, $00, $ae, $00, $c2, $00, $c7
;	db $76, $00, $b5, $00, $b2, $00, $bc, $00, $bd, $00, $ae, $00, $b7, $00, $c7
;	db $7f, $7f
;;--------------------------------------------------------------------------------
;	.excuseMePrincess
;	; Well / excuuuuuse me, / princess!
;	db $00, $c0, $00, $ae, $00, $b5, $00, $b5
;	db $75, $00, $ae, $00, $c1, $00, $ac, $00, $be, $00, $be, $00, $be, $00, $be, $00, $be, $00, $bc, $00, $ae, $00, $ff, $00, $b6, $00, $ae, $00, $c8
;	db $76, $00, $b9, $00, $bb, $00, $b2, $00, $b7, $00, $ac, $00, $ae, $00, $bc, $00, $bc, $00, $c7
;	db $7f, $7f
;;-------------------------------------------------------------------------------- ^32nd
