;================================================================================
; Utility Functions
;================================================================================
; GetSpriteTile
; in:	A - Loot ID
; out:	A - Sprite GFX ID
;--------------------------------------------------------------------------------
GetSpriteID:
	JSR.w AttemptItemSubstitution
	JSR.w ResolveLootID
        CMP.b #$6D : BEQ .server_F0 ; Server Request F0
        CMP.b #$6E : BEQ .server_F1 ; Server Request F1
        CMP.b #$6F : BEQ .server_F2 ; Server Request F2
	BRA .normal
                .server_F0
                JSL.l ItemVisualServiceRequest_F0
                BRA .normal
                .server_F1
                JSL.l ItemVisualServiceRequest_F1
		BRA .normal
		.server_F2
		JSL.l ItemVisualServiceRequest_F2
	.normal
	PHX
	TAX : LDA.l ItemReceipts_graphics, X ; look up item gfx
	PLX
RTL

;--------------------------------------------------------------------------------
; GetSpritePalette
; in:	A - Loot ID
; out:	A - Palette
;--------------------------------------------------------------------------------
GetSpritePalette:
        JSR AttemptItemSubstitution
        JSR.w ResolveLootID
        .resolved
        TAX
        LDA.l SpriteProperties_standing_palette, X : BIT #$80 : BNE .load_palette
        ASL
RTL
        .load_palette
        JSL.l LoadItemPalette
        ASL
RTL

;--------------------------------------------------------------------------------
; PrepDynamicTile
; in:	A - Loot ID
;-------------------------------------------------------------------------------- 20/8477
PrepDynamicTile:
	PHA : PHX : PHY : PHB
	JSR.w ResolveLootID
        -
	JSR.w LoadDynamicTileOAMTable
	JSL TransferItemReceiptToBuffer_using_ReceiptID
        SEP #$30
	PLB : PLY : PLX : PLA
RTL
        .loot_resolved
	PHA : PHX : PHY : PHB
        BRA -
;--------------------------------------------------------------------------------

;--------------------------------------------------------------------------------
; LoadDynamicTileOAMTable
; in:	A - Loot ID
;-------------------------------------------------------------------------------- 20/847B
LoadDynamicTileOAMTable:
        PHA : PHP
        REP #$20
        LDA.w #$0000 : STA.l SpriteOAM : STA.l SpriteOAM+2
        LDA.w #$0200 : STA.l SpriteOAM+6
        SEP #$20
        LDA.b #$24 : STA.l SpriteOAM+4

        LDA.w SpriteItemType,X
        JSL.l GetSpritePalette_resolved
        STA.l SpriteOAM+5 : STA.l SpriteOAM+13
        PHX
        LDA.l SpriteProperties_standing_width,X : BEQ .narrow
        BRA .done

        .narrow
        REP #$20
        LDA.w #$0400 : STA.l SpriteOAM+7 : STA.l SpriteOAM+14
        LDA.w #$0800 : STA.l SpriteOAM+9
        LDA.w #$3400 : STA.l SpriteOAM+11
        SEP #$20
        LDA.b #$04 : STA.l SpriteOAM

        .done
        PLX
        PLP : PLA
RTS
;--------------------------------------------------------------------------------

;--------------------------------------------------------------------------------
; DrawDynamicTile
; in:	A - Loot ID
; out:  A - OAM Slots Taken
;--------------------------------------------------------------------------------
; This wastes two OAM slots if you don't want a shadow - fix later - I wrote "fix later" over a year ago and it's still not fixed (Aug 6, 2017) - lol (May 25th, 2019)
;-------------------------------------------------------------------------------- 2084B8
DrawDynamicTile:
        PHX
        TAX
        LDA.l SpriteProperties_standing_width,X : BEQ .narrow

        .full
        PLX
        LDA.b #$01 : STA.b Scrap06
        LDA.b #$0C : JSL.l OAM_AllocateFromRegionC
        LDA.b #$02 : PHA
        BRA .draw

        .narrow
        PLX
        LDA.b #$02 : STA.b Scrap06
        LDA.b #$10 : JSL.l OAM_AllocateFromRegionC
        LDA.b #$03 : PHA

        .draw
        LDA.b #SpriteOAM>>0 : STA.b Scrap08
        LDA.b #SpriteOAM>>8 : STA.b Scrap09
        STZ.b Scrap07
        LDA.b #$7E : PHB : PHA : PLB
        LDA.b #$01 : STA.l SpriteSkipEOR
        JSL Sprite_DrawMultiple_quantity_preset
        LDA.b #$00 : STA.l SpriteSkipEOR
        PLB

        LDA.b OAMPtr : !ADD.b #$08 : STA.b OAMPtr ; leave the pointer in the right spot to draw the shadow, if desired
        LDA.b OAMPtr+2 : INC #2 : STA.b OAMPtr+2
        PLA
RTL
;--------------------------------------------------------------------------------
DrawDynamicTileNoShadow:
        PHX
        TAX
        LDA.l SpriteProperties_standing_width,X : BEQ .narrow

        .full
        PLX
        LDA.b #$01 : STA.b Scrap06
        LDA.b #$04 : JSL.l OAM_AllocateFromRegionC
        BRA .draw

        .narrow
        PLX
        LDA.b #$02 : STA.b Scrap06
        LDA.b #$08 : JSL.l OAM_AllocateFromRegionC

        .draw
        LDA.b #SpriteOAM>>0 : STA.b Scrap08
        LDA.b #SpriteOAM>>8 : STA.b Scrap09
        STZ.b Scrap07
        LDA.b #$7E : PHB : PHA : PLB
        LDA.b #$01 : STA.l SpriteSkipEOR
        JSL Sprite_DrawMultiple_quantity_preset
        LDA.l Bob : BNE + : LDA.b #$00 : STA.l SpriteSkipEOR : + ; Bob fix is conditional
        PLB

        LDA.b OAMPtr : !ADD.b #$08 : STA.b OAMPtr
        LDA.b OAMPtr+2 : INC #2 : STA.b OAMPtr+2
RTL
;--------------------------------------------------------------------------------

;--------------------------------------------------------------------------------
LoadModifiedTileBufferAddress:
	PHA
	LDA.l TileUploadOffsetOverride : BEQ +
		TAX
    	LDY.w #$0002
		LDA.w #$0000 : STA.l TileUploadOffsetOverride
		BRA .done
	+
    LDX.w #$2D40
    LDY.w #$0002
	.done
	PLA
RTL
;--------------------------------------------------------------------------------

;--------------------------------------------------------------------------------
; Sprite_IsOnscreen
; in:	X - Sprite Slot
; out:	Carry - 1 = On Screen, 0 = Off Screen
;--------------------------------------------------------------------------------
Sprite_IsOnscreen:
        JSR .check_sprite
        BCS +
                REP #$20
                LDA.b BG2H : PHA : !SUB.w #$0F : STA.b BG2H
                LDA.b BG2V : PHA : !SUB.w #$0F : STA.b BG2V
                SEP #$20
                JSR .check_sprite
                REP #$20
                PLA : STA.b BG2V
                PLA : STA.b BG2H
                SEP #$20
        +
RTL

.check_sprite
        LDA.w SpritePosXLow, X : CMP.b BG2H
        LDA.w SpritePosXHigh, X : SBC.b BG2H+1 : BNE .offscreen

        LDA.w SpritePosYLow, X : CMP.b BG2V
        LDA.w SpritePosYHigh, X : SBC.b BG2V+1 : BNE .offscreen
        SEC
RTS
        .offscreen
        CLC
RTS
;--------------------------------------------------------------------------------

;--------------------------------------------------------------------------------
; Sprite_GetScreenRelativeCoords:
; out:	$00.w Sprite Y
; out:	$02.w Sprite X
; out:	$06.b Sprite Y Relative
; out:	$07.b Sprite X Relative
;--------------------------------------------------------------------------------
; Copied from bank $06
;--------------------------------------------------------------------------------
Sprite_GetScreenRelativeCoords:
	STY.b Scrap0B

	STA.b Scrap08

	LDA.w SpritePosYLow, X : STA.b Scrap00
	!SUB.b BG2V       : STA.b Scrap06
	LDA.w SpritePosYHigh, X : STA.b Scrap01

	LDA.w SpritePosXLow, X : STA.b Scrap02 
	!SUB.b BG2H       : STA.b Scrap07
	LDA.w SpritePosXHigh, X : STA.b Scrap03
RTL
;--------------------------------------------------------------------------------

;--------------------------------------------------------------------------------
; SkipDrawEOR - Shims in Bank05.asm : 2499
;--------------------------------------------------------------------------------
SkipDrawEOR:
	LDA.l SpriteSkipEOR : BEQ .normal
	LDA.w #$0000 : STA.l SpriteSkipEOR
	LDA.w #$0F00 : TRB.b Scrap04
	.normal
	LDA.b ($08), Y : EOR.w Scrap04 ; thing we wrote over
RTL
;--------------------------------------------------------------------------------
; Look up table of bit counts in the values $00-$0F
NybbleBitCounts:
db #00, #01, #01, #02, #01, #02, #02, #03, #01, #02, #02, #03, #02, #03, #03, #04

;--------------------------------------------------------------------------------
; WriteVRAMStripe
; in:	A(w) - VRAM Destination
; in:	X(w) - Length in Tiles
; in:	Y(w) - Word to Write
;--------------------------------------------------------------------------------
WriteVRAMStripe:
	PHX
		LDX.w GFXStripes ; get pointer
		AND.w #$7F : STA.w GFXStripes+2, X : INX #2 ; set destination
	PLA : ASL : AND.w #$7FFF : ORA.w #$7000 : STA.w GFXStripes+2, X : INX #2 ; set length and enable RLE
	TYA : STA.w GFXStripes+2, X : INX #2 ; set tile
	SEP #$20 ; set 8-bit accumulator
		LDA.b #$FF : STA.w GFXStripes+2, X
		STX.w GFXStripes
		LDA.b #01 : STA.b NMISTRIPES
	REP #$20 ; set 16-bit accumulator
RTL
;--------------------------------------------------------------------------------

;--------------------------------------------------------------------------------
; WriteVRAMBlock
; in:	A(w) - VRAM Destination
; in:	X(w) - Length in Tiles
; in:	Y(w) - Address of Data to Copy
;--------------------------------------------------------------------------------
WriteVRAMBlock:
        PHX
        LDX.w GFXStripes ; get pointer
        AND.w #$7F : STA.w GFXStripes+2, X : INX #2 ; set destination
        PLA : ASL : AND.w #$3FFF : STA.w GFXStripes+2, X : INX #2 ; set length

        PHX
                TYX ; set X to source
                PHA
                        TXA : !ADD #$1002 : TAY ; set Y to dest
                PLA
                ;A is already the value we need for mvn
                MVN $7F7E ; currently we transfer from our buffers in 7F to the vram buffer in 7E

                !ADD 1, s ; add the length in A to the stack pointer on the top of the stack
        PLX : TAX ; pull and promptly ignore, copying the value we just got over it

        SEP #$20 ; set 8-bit accumulator
                LDA.b #$FF : STA.w GFXStripes+$02, X
                STX.w GFXStripes
                LDA.b #01 : STA.w NMISTRIPES
        REP #$20 ; set 16-bit accumulator
RTL
;--------------------------------------------------------------------------------
;Byte 1   byte 2  Byte 3   byte 4
;Evvvvvvv vvvvvvv DRllllll llllllll
;
;E if set indicates that this is not a header, but instead is the terminator byte. Only the topmost bit matters in that case.
;The v's form a vram address.
;if D is set, the dma will increment the vram address by a row per word, instead of incrementing by a column (1).
;R if set enables a run length encoding feature
;the l's are the number of bytes to upload minus 1 (don't forget this -1, it is important)
;
;This is then followed by the bytes to upload, in normal format.

;RLE feature:
;This feature makes it easy to draw the same tile repeatedly. If this bit is set, the length bits should be set to 2 times the number of copies of the tile to upload. (Without subtracting 1!)
;It is followed by a single tile (word).  Combining this this with the D bit makes it easy to draw large horizontal or vertical runs of a tile without using much space. Geat for erasing or drawing horizontal or verical box edges.
;================================================================================

DynamicDrawCleanup:
        PHA
        REP #$20
        LDA.w #$F000
        STA.w OAMBuffer
        STA.w OAMBuffer+$04
        STA.w OAMBuffer+$08
        STA.w OAMBuffer+$0C
        STZ.w OAMBuffer+$02
        STZ.w OAMBuffer+$06
        STZ.w OAMBuffer+$0A
        STZ.w OAMBuffer+$0E
        SEP #$20
        PLA
RTL

;------------------------------------------------------------------------------
CheckReceivedItemPropertiesBeforeLoad:
        LDA.b RoomIndex : BEQ .normalCode
        LDA.l RoomFade : BNE .load_palette
        LDA.l SpriteProperties_chest_palette,X : BIT #$80 : BNE .load_palette
        .normalCode
RTL
        .load_palette
        JSL.l LoadItemPalette
RTL

;------------------------------------------------------------------------------
LoadItemPalette:
; In: X - Loot ID
; Out: A - Sprite palette index
        PHX : PHY : PHB
        LDA.b #PalettesVanillaBank>>16 : STA.b Scrap0C
        LDA.b #$7E
        PHA : PLB
        REP #$30
        
        TXA : ASL : TAX
        LDA.l SpriteProperties_palette_addr,X : STA.b Scrap0A
        LDY.w #$000E
        LDA.w TransparencyFlag : BNE .SP05
                -
                        LDA.b [Scrap0A], Y : STA.w PaletteBuffer+$0170,Y
                        DEY #2
                BPL -
                LDA.w #$0003
                BRA .done
        .SP05
        -
                LDA.b [Scrap0A], Y : STA.w PaletteBuffer+$01B0,Y
                DEY #2
        BPL -
        LDA.w #$0005
        .done
        SEP #$30
        PLB : PLY : PLX
        INC.b NMICGRAM
RTL
