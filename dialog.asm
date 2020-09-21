;================================================================================
; Dialog Pointer Override
;--------------------------------------------------------------------------------
DialogOverride:
	LDA $7F5035 : BEQ .skip
	LDA $7F5700, X ; use alternate buffer
RTL
	.skip
    LDA $7F1200, X
RTL
;--------------------------------------------------------------------------------
; $7F5035 - Alternate Text Pointer Flag ; 0=Disable
; $7F5036 - Padding Byte (Must be Zero)
; $7F5700 - $7F57FF - Dialog Buffer
;--------------------------------------------------------------------------------
ResetDialogPointer:
	STZ $1CF0 : STZ $1CF1 ; reset decompression buffer
	LDA.b #$00 : STA $7F5035 ; zero out the alternate flag
	LDA.b #$1C : STA $1CE9 ; thing we wrote over
RTL
;--------------------------------------------------------------------------------
;macro LoadDialog(index,table)
;	PHA : PHX : PHY
;	PHB : PHK : PLB
;	LDA $00 : PHA
;	LDA $01 : PHA
;	LDA $02 : PHA
;		LDA.b #$01 : STA $7F5035 ; set flag
;
;		LDA <index> : ASL : !ADD.l <index> : TAX ; get quote offset *3, move to X
;		LDA <table>, X : STA $00 ; write pointer to direct page
;		LDA <table>+1, X : STA $01
;		LDA <table>+2, X : STA $02
;
;		LDX.b #$00 : LDY.b #$00
;		-
;			LDA [$00], Y ; load the next character from the pointer
;			STA $7F5700, X ; write to the buffer
;			INX : INY
;		CMP.b #$7F : BNE -
;	PLA : STA $02
;	PLA : STA $01
;	PLA : STA $00
;	PLB
;	PLY : PLX : PLA
;endmacro
;--------------------------------------------------------------------------------
;macro LoadDialogAddress(address)
;	PHA : PHX : PHY
;	PHP
;	PHB : PHK : PLB
;		SEP #$30 ; set 8-bit accumulator and index registers
;		LDA $00 : PHA
;		LDA $01 : PHA
;		LDA $02 : PHA
;			LDA.b #$01 : STA $7F5035 ; set flag
;
;			LDA.b #<address> : STA $00 ; write pointer to direct page
;			LDA.b #<address>>>8 : STA $01
;			LDA.b #<address>>>16 : STA $02
;
;			LDX.b #$00 : LDY.b #$00
;			-
;				LDA [$00], Y ; load the next character from the pointer
;				STA $7F5700, X ; write to the buffer
;				INX : INY
;			CMP.b #$7F : BNE -
;		PLA : STA $02
;		PLA : STA $01
;		PLA : STA $00
;	PLB
;	PLP
;	PLY : PLX : PLA
;endmacro
;--------------------------------------------------------------------------------
!OFFSET_POINTER = "$7F5094"
!OFFSET_RETURN = "$7F5096"
!DIALOG_BUFFER = "$7F5700"
macro LoadDialogAddress(address)
	PHA : PHX : PHY
	PHP
	PHB : PHK : PLB
		SEP #$20 ; set 8-bit accumulator
		REP #$10 ; set 16-bit index registers
		LDA $00 : PHA
		LDA $01 : PHA
		LDA $02 : PHA
			STZ $1CF0 : STZ $1CF1 ; reset decompression buffer
			LDA.b #$01 : STA $7F5035 ; set flag
			%CopyDialog(<address>)
		PLA : STA $02
		PLA : STA $01
		PLA : STA $00
	PLB
	PLP
	PLY : PLX : PLA
endmacro
;--------------------------------------------------------------------------------
macro CopyDialog(address)
	LDA.b #<address> : STA $00 ; write pointer to direct page
	LDA.b #<address>>>8 : STA $01
	LDA.b #<address>>>16 : STA $02
	%CopyDialogIndirect()
endmacro
;--------------------------------------------------------------------------------
macro CopyDialogIndirect()
	REP #$20 : LDA !OFFSET_POINTER : TAX : LDY.w #$0000 : SEP #$20 ; copy 2-byte offset pointer to X and set Y to 0
	?loop:
		LDA [$00], Y ; load the next character from the pointer
		STA !DIALOG_BUFFER, X ; write to the buffer
		INX : INY
	CMP.b #$7F : BNE ?loop
	REP #$20 ; set 16-bit accumulator
	TXA : INC : STA !OFFSET_RETURN ; copy out X into
	LDA.w #$0000 : STA !OFFSET_POINTER
	SEP #$20 ; set 8-bit accumulator
endmacro
;--------------------------------------------------------------------------------
LoadDialogAddressIndirect:
	STZ $1CF0 : STZ $1CF1 ; reset decompression buffer
	LDA.b #$01 : STA $7F5035 ; set flag
	%CopyDialogIndirect()
	;%LoadDialogAddress(UncleText)
RTL
;--------------------------------------------------------------------------------
!ITEM_TEMPORARY = "$7F5040"
FreeDungeonItemNotice:
	STA !ITEM_TEMPORARY

	PHA : PHX : PHY
	PHP
	PHB : PHK : PLB
		SEP #$20 ; set 8-bit accumulator
		REP #$10 ; set 16-bit index registers
		LDA $00 : PHA
		LDA $01 : PHA
		LDA $02 : PHA
	;--------------------------------

	LDA.l FreeItemText : BNE + : BRL .skip : +

	LDA #$00 : STA $7F5010 ; initialize scratch
	LDA.l FreeItemText : AND.b #$01 : CMP.b #$01 : BNE + ; show message for general small key
	LDA !ITEM_TEMPORARY : CMP.b #$24 : BNE + ; general small key
		%CopyDialog(Notice_SmallKeyOf)
		LDA !OFFSET_RETURN : DEC #2 : STA !OFFSET_POINTER
		%CopyDialog(Notice_Self)
		BRL .done
	+ : LDA.l FreeItemText : AND.b #$02 : CMP.b #$02 : BNE + ; show message for general compass
	LDA !ITEM_TEMPORARY : CMP.b #$25 : BNE + ; general compass
		%CopyDialog(Notice_CompassOf)
		LDA !OFFSET_RETURN : DEC #2 : STA !OFFSET_POINTER
		%CopyDialog(Notice_Self)
		BRL .done
	+ : LDA.l FreeItemText : AND.b #$04 : CMP.b #$04 : BNE + ; show message for general map
	LDA !ITEM_TEMPORARY : CMP.b #$33 : BNE + ; general map
		%CopyDialog(Notice_MapOf)
		LDA !OFFSET_RETURN : DEC #2 : STA !OFFSET_POINTER
		%CopyDialog(Notice_Self)
		BRL .done
	+ : LDA.l FreeItemText : AND.b #$08 : CMP.b #$08 : BNE + ; show message for general big key
	LDA !ITEM_TEMPORARY : CMP.b #$32 : BNE + ; general big key
		%CopyDialog(Notice_BigKeyOf)
		LDA !OFFSET_RETURN : DEC #2 : STA !OFFSET_POINTER
		%CopyDialog(Notice_Self)
		BRL .done
	+
	LDA.l FreeItemText : AND.b #$04 : CMP.b #$04 : BNE + ; show message for dungeon map
	LDA !ITEM_TEMPORARY : AND.b #$F0 ; looking at high bits only
	CMP.b #$70 : BNE + ; map of...
		%CopyDialog(Notice_MapOf)
		BRL .dungeon
	+ : LDA.l FreeItemText : AND.b #$02 : CMP.b #$02 : BNE + ; show message for dungeon compass
	LDA !ITEM_TEMPORARY : AND.b #$F0 : CMP.b #$80 : BNE + ; compass of...
		%CopyDialog(Notice_CompassOf)
		BRL .dungeon
	+ : LDA.l FreeItemText : AND.b #$08 : CMP.b #$08 : BNE + ; show message for dungeon big key
	LDA !ITEM_TEMPORARY : AND.b #$F0 : CMP.b #$90 : BNE + ; big key of...
		%CopyDialog(Notice_BigKeyOf)
		BRA .dungeon
	+ : LDA.l FreeItemText : AND.b #$01 : CMP.b #$01 : BNE + ; show message for dungeon small key
	LDA !ITEM_TEMPORARY : AND.b #$F0 : CMP.b #$A0 : BNE + ; small key of...
		LDA !ITEM_TEMPORARY : CMP.b #$AF : BNE ++ : BRL .skip : ++
		%CopyDialog(Notice_SmallKeyOf)
		PLA : AND.b #$0F : STA $7F5020 : LDA.b #$0F : !SUB $7F5020 : PHA
		LDA #$01 : STA $7F5010 ; set up a flip for small keys
		BRA .dungeon
	+
	BRL .skip ; it's not something we are going to give a notice for

	.dungeon
	LDA !OFFSET_RETURN : DEC #2 : STA !OFFSET_POINTER
	LDA !ITEM_TEMPORARY
	AND.b #$0F ; looking at low bits only
	STA $7F5011
	LDA $7F5010 : BEQ +
		LDA $7F5010
		LDA #$0F : !SUB $7F5011 : STA $7F5011 ; flip the values for small keys
	+
	LDA $7F5011
	CMP.b #$00 : BNE + ; ...light world
		%CopyDialog(Notice_LightWorld) : BRL .done
	+ : CMP.b #$01 : BNE + ; ...dark world
		%CopyDialog(Notice_DarkWorld) : BRL .done
	+ : CMP.b #$02 : BNE + ; ...ganon's tower
		%CopyDialog(Notice_GTower) : BRL .done
	+ : CMP.b #$03 : BNE + ; ...turtle rock
		%CopyDialog(Notice_TRock) : BRL .done
	+ : CMP.b #$04 : BNE + ; ...thieves' town
		%CopyDialog(Notice_Thieves) : BRL .done
	+ : CMP.b #$05 : BNE + ; ...tower of hera
		%CopyDialog(Notice_Hera) : BRL .done
	+ : CMP.b #$06 : BNE + ; ...ice palace
		%CopyDialog(Notice_Ice) : BRL .done
	+ : CMP.b #$07 : BNE + ; ...skull woods
		%CopyDialog(Notice_Skull) : BRL .done
	+ : CMP.b #$08 : BNE + ; ...misery mire
		%CopyDialog(Notice_Mire) : BRL .done
	+ : CMP.b #$09 : BNE + ; ...dark palace
		%CopyDialog(Notice_PoD) : BRL .done
	+ : CMP.b #$0A : BNE + ; ...swamp palace
		%CopyDialog(Notice_Swamp) : BRL .done
	+ : CMP.b #$0B : BNE + ; ...agahnim's tower
		%CopyDialog(Notice_AgaTower) : BRL .done
	+ : CMP.b #$0C : BNE + ; ...desert palace
		%CopyDialog(Notice_Desert) : BRL .done
	+ : CMP.b #$0D : BNE + ; ...eastern palace
		%CopyDialog(Notice_Eastern) : BRA .done
	+ : CMP.b #$0E : BNE + ; ...hyrule castle
		%CopyDialog(Notice_Castle) : BRA .done
	+ : CMP.b #$0F : BNE + ; ...sewers
		%CopyDialog(Notice_Sewers)
	+
	.done

	STZ $1CF0 : STZ $1CF1 ; reset decompression buffer
	LDA.b #$01 : STA $7F5035 ; set alternate dialog flag
	LDA.b #$01 : STA $7F509F

	;--------------------------------
		PLA : STA $02
		PLA : STA $01
		PLA : STA $00
	PLB
	PLP
	PLY : PLX : PLA
	;JSL.l Main_ShowTextMessage_Alt
RTL

	.skip
	;--------------------------------
		PLA : STA $02
		PLA : STA $01
		PLA : STA $00
	PLB
	PLP
	PLY : PLX : PLA
RTL
;--------------------------------------------------------------------------------
DialogResetSelectionIndex:
    JSL.l Attract_DecompressStoryGfx ; what we wrote over
    STZ $1CE8
RTL
;--------------------------------------------------------------------------------
DialogItemReceive:
	BCS .noMessage ; if doubling the item value overflowed it must be a rando item
	CPY #$98 : !BLT + ;if the item is $4C or greater it must be a rando item
		.noMessage
		LDA.w #$FFFF
		BRA .done
	+
	LDA.w Ancilla_ReceiveItem_item_messages, Y
	.done
	CMP.w #$FFFF
RTL
;--------------------------------------------------------------------------------
DialogFairyThrow:
	LDA.l Restrict_Ponds : BEQ .normal
	LDA $7EF35C : ORA $7EF35D : ORA $7EF35E : ORA $7EF35F : BNE .normal
	
	.noInventory
	LDA $0D80, X : !ADD #$08 : STA $0D80, X
	LDA.b #$51
	LDY.b #$01
RTL
	.normal
	LDA.b #$88
	LDY.b #$00
RTL
;--------------------------------------------------------------------------------
DialogGanon1:
	JSL.l CheckGanonVulnerability : BCS +
		REP #$20 : LDA.w #$018C : STA $1CF0 : SEP #$20
		BRA ++
	+
		REP #$20 : LDA.w #$016D : STA $1CF0 : SEP #$20
	++
	JSL.l Sprite_ShowMessageMinimal_Alt
RTL
;--------------------------------------------------------------------------------
; #$0192 - no bow
; #$0193 - no silvers alternate
; #$0194 - no silvers
; #$0195 - silvers
; $7EF38E - bsp-- ---
; b = bow
; s = silver arrow bow
; p = 2nd progressive bow
DialogGanon2:
    JSL.l CheckGanonVulnerability : BCS +
        REP #$20 : LDA.w #$018D : STA $1CF0 : SEP #$20
        BRA ++
    +
        LDA.l $7EF38E : AND #$80 : BNE + ; branch if bow
        REP #$20 : LDA.w #$0192 : STA $1CF0 : SEP #$20 ; no bow
        BRA ++
    +
        LDA.l $7EF38E : AND #$40 : BEQ + ; branch if no silvers
        REP #$20 : LDA.w #$0195 : STA $1CF0 : SEP #$20 ;has silvers
        BRA ++
    +
        LDA.l $7EF38E : AND #$20 : BNE + ; branch if p bow
        REP #$20 : LDA.w #$0194 : STA $1CF0 : SEP #$20  ; bow, no-silvers, no-p-bow
        BRA ++
    +
        LDA.l $7EF38E : AND #$80 : BEQ + ; branch if no bow
        REP #$20 : LDA.w #$0193 : STA $1CF0 : SEP #$20 ; bow, no-silvers, p-bow
        BRA ++
    +
        REP #$20 : LDA.w #$016E : STA $1CF0 : SEP #$20 ; both bow and no bow. impossible.
    ++
    JSL.l Sprite_ShowMessageMinimal_Alt
RTL
;--------------------------------------------------------------------------------
DialogEtherTablet:
	PHA
	LDA $0202 : CMP.b #$0F : BEQ + ; Show normal text if book is not equipped
	-
	PLA : JSL Sprite_ShowMessageUnconditional ; Wacky Hylian Text
RTL
	+
	BIT $F4 : BVC - ; Show normal text if Y is not pressed
	LDA.l AllowHammerTablets : BEQ ++
		LDA $7EF34B : BEQ .yesText : BRA .noText
	++
		LDA $7EF359 : CMP.b #$FF : BEQ .yesText : CMP.b #$02 : !BGE .noText
	;++
	.yesText
	PLA
	LDA.b #$0c
	LDY.b #$01
	JSL Sprite_ShowMessageUnconditional ; Text From MSPedestalText (tables.asm)
RTL
	.noText
	PLA
RTL
;--------------------------------------------------------------------------------
DialogBombosTablet:
	PHA
	LDA $0202 : CMP.b #$0F : BEQ + ; Show normal text if book is not equipped
	-
	PLA : JSL Sprite_ShowMessageUnconditional ; Wacky Hylian Text
RTL
	+
	BIT $F4 : BVC - ; Show normal text if Y is not pressed
	LDA.l AllowHammerTablets : BEQ ++
		LDA $7EF34B : BEQ .yesText : BRA .noText
	++
		LDA $7EF359 : CMP.b #$FF : BEQ .yesText : CMP.b #$02 : !BGE .noText
	;++
	.yesText
	PLA 
	LDA.b #$0D
	LDY.b #$01
	JSL Sprite_ShowMessageUnconditional ; Text From MSPedestalText (tables.asm)
RTL
	.noText
	PLA
RTL
;--------------------------------------------------------------------------------
DialogSahasrahla:
	LDA.l $7EF374 : AND #$04 : BEQ + ;Check if player has green pendant
		LDA.b #$2F
        LDY.b #$00
		JSL.l Sprite_ShowMessageUnconditional
	+
RTL
;--------------------------------------------------------------------------------
DialogBombShopGuy:
	LDA.l $7EF37A : AND #$05 : CMP #$05 : BEQ + ;Check if player has crystals 5 & 6
		LDA.b #$15
        LDY.b #$01
		JSL.l Sprite_ShowMessageUnconditional
		RTL
	+
	LDA.b #$16
    LDY.b #$01
	JSL.l Sprite_ShowMessageUnconditional
RTL
;--------------------------------------------------------------------------------
Main_ShowTextMessage_Alt:
	; Are we in text mode? If so then end the routine.
	LDA $10 : CMP.b #$0E : BEQ .already_in_text_mode
Sprite_ShowMessageMinimal_Alt:
	STZ $11

	PHX : PHY
	LDA.b $00 : PHA
	LDA.b $01 : PHA
	LDA.b $02 : PHA

	LDA.b #$1C : STA.b $02
	REP #$30
		LDA.w $1CF0 : ASL : TAX
		LDA.l $7f71c0, X
		STA.b $00
	SEP #$30

	LDY.b #$00
	      LDA [$00], Y : CMP.b #$fe : BNE +
	INY : LDA [$00], Y : CMP.b #$6e : BNE +
	INY : LDA [$00], Y :            : BNE +
	INY : LDA [$00], Y : CMP.b #$fe : BNE +
	INY : LDA [$00], Y : CMP.b #$6b : BNE +
	INY : LDA [$00], Y : CMP.b #$04 : BNE +
		STZ $1CE8
		BRL .end
	+

	STZ $0223   ; Otherwise set it so we are in text mode.
	STZ $1CD8   ; Initialize the step in the submodule

	; Go to text display mode (as opposed to maps, etc)
	LDA.b #$02 : STA $11

	; Store the current module in the temporary location.
	LDA $10 : STA $010C

	; Switch the main module ($10) to text mode.
	LDA.b #$0E : STA $10
	.end
	PLA : STA.b $02
	PLA : STA.b $01
	PLA : STA.b $00
	PLY : PLX

Main_ShowTextMessage_Alt_already_in_text_mode:
RTL

CalculateSignIndex:
  ; for the big 1024x1024 screens we are calculating link's effective
  ; screen area, as though the screen was 4 different 512x512 screens.
  ; And we do this in a way that will likely give the right value even 
  ; with major glitches.

  LDA $8A : ASL A : TAY ;what we wrote over

  LDA $0712 : BEQ .done ; If a small map, we can skip these calculations.

  LDA $21 : AND.w #$0002 : ASL #2 : EOR $8A : AND.w #$0008 : BEQ +
  	TYA : !ADD.w #$0010 : TAY  ;add 16 if we are in lower half of big screen.
  + 

  LDA $23 : AND.w #$0002 : LSR : EOR $8A : AND.w #$0001 : BEQ +
  TYA : INC #2 : TAY  ;add 16 if we are in lower half of big screen.
  +
  ; ensure even if things go horribly wrong, we don't read the sign out of bounds and crash:
  TYA : AND.w #$00FF : TAY 

.done
RTL

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
