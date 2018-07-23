!ExtendedPlayerName = "$700500"

;FS prefix means file_select, since these defines and macros are specific to this screen
!FS_INVENTORY_SWAP = "$70038C"
!FS_INVENTORY_SWAP_2 = "$70038E"


!FS_COLOR_BROWN = "$0000" ;(only used for: Shovel, hammer, powder)
!FS_COLOR_RED = "$0400"
!FS_COLOR_YELLOW = "$0800"
!FS_COLOR_BLUE = "$0C00"
!FS_COLOR_GRAY = "$1000" ;(Used to gray out items)
!FS_COLOR_BOOTS = "$1400"
!FS_COLOR_GREEN = "$1800"
!FS_COLOR_BW = "$1C00"

macro fs_draw8x8(screenrow,screencol)
	;Note due to XKAS's screwy math this formula is misleading.
	;in normal math we have $1004+2*col+$40*row
	STA.w <screenrow>*$20+<screencol>*2+$1004
endmacro
macro fs_draw16x8(screenrow,screencol)
	%fs_draw8x8(<screenrow>,<screencol>)
	INC A
	%fs_draw8x8(<screenrow>,<screencol>+1)
endmacro
macro fs_draw8x16(screenrow,screencol)
	%fs_draw8x8(<screenrow>,<screencol>)
	!ADD #$0010
	%fs_draw8x8(<screenrow>+1,<screencol>)
endmacro
macro fs_draw16x16(screenrow,screencol)
	%fs_draw16x8(<screenrow>,<screencol>)
	!ADD #$000F
	%fs_draw16x8(<screenrow>+1,<screencol>)
endmacro


DrawPlayerFile:
	PHX : PHY

	LDA !ExtendedPlayerName+$00 : ORA.w #!FS_COLOR_BW
	%fs_draw8x16(6,3)
	LDA !ExtendedPlayerName+$02 : ORA.w #!FS_COLOR_BW
	%fs_draw8x16(6,5)
	LDA !ExtendedPlayerName+$04 : ORA.w #!FS_COLOR_BW
	%fs_draw8x16(6,7)
	LDA !ExtendedPlayerName+$06 : ORA.w #!FS_COLOR_BW
	%fs_draw8x16(6,9)

	LDA !ExtendedPlayerName+$08 : ORA.w #!FS_COLOR_BW
	%fs_draw8x16(9,3)
	LDA !ExtendedPlayerName+$0A : ORA.w #!FS_COLOR_BW
	%fs_draw8x16(9,5)
	LDA !ExtendedPlayerName+$0C : ORA.w #!FS_COLOR_BW
	%fs_draw8x16(9,7)
	LDA !ExtendedPlayerName+$0E : ORA.w #!FS_COLOR_BW
	%fs_draw8x16(9,9)

;	;bow
;	LDA.l !FS_INVENTORY_SWAP_2 : AND.w #$0040 : BEQ +
;		LDA.l $700340 : AND.w #$00FF : BEQ ++
;			LDA.w #$0201|!FS_COLOR_YELLOW :	%fs_draw8x8(2,12)
;			LDA.w #$0204|!FS_COLOR_YELLOW :	%fs_draw8x8(2,13)
;			LDA.w #$0203|!FS_COLOR_RED : %fs_draw8x8(3,12)
;			LDA.w #$0212|!FS_COLOR_YELLOW : %fs_draw8x8(3,13)
;			BRA .bow_end
;		++
;			LDA #$0214|!FS_COLOR_RED : %fs_draw8x8(2,13)
;			LDA.w #$0213|!FS_COLOR_RED : %fs_draw8x8(3,12)
;			BRA .bow_end
;	+
;		LDA.l $700340 : AND.w #$00FF : BEQ ++
;			LDA.w #$0201|!FS_COLOR_YELLOW : %fs_draw16x16(2,12)
;			BRA .bow_end
;		++
;		LDA.w #$0201|!FS_COLOR_GRAY : %fs_draw16x16(2,12)
;	.bow_end
;
;	;hookshot
;	LDA.l $700342 : AND.w #$00FF : BEQ +
;		LDA.w #$0215|!FS_COLOR_RED
;		BRA .draw_hook
;	+
;	LDA.w #$0215|!FS_COLOR_GRAY
;	.draw_hook
;	%fs_draw8x8(2,17)
;	!ADD.w #$0230-$0215 ;hookshot handle
;	%fs_draw8x8(3,16)
;
;	;powder
;	LDA !FS_INVENTORY_SWAP : AND.w #$0010 : BEQ +
;		LDA.w #$020A|!FS_COLOR_BROWN
;		BRA .draw_powder
;	+
;	LDA.w #$020A|!FS_COLOR_GRAY
;    .draw_powder
;	%fs_draw16x16(2,20)
;
;	;mushroom
;	LDA !FS_INVENTORY_SWAP : AND.w #$0020 : BEQ +
;		LDA.w #$0262|!FS_COLOR_RED
;		BRA .draw_shroom
;	+
;	LDA.w #$0262|!FS_COLOR_GRAY
;	.draw_shroom
;	%fs_draw16x16(2,22)

	PLY : PLX
	LDA.w #$0004 : STA $02 ; thing we wrote over
RTL
;--------------------------------------------------------------------------------
AltBufferTable:
    LDA.b #$02 : STA $210c ; Have Screen 3 use same tile area as screens 1

    REP #$20
    LDX.w #$0300 ; 12 rows with 64 bytes (30 tiles * 2 + 4 byte header)
    ;fill with the blank character
    LDA.w #$0188
    -
        STA $1000, X
        DEX : DEX : BNE -

    ; set vram offsets
    LDA.w #$2161 : STA $1002 ;file 1 top row
    LDA.w #$4161 : STA $1042 ;file 1 bottom row

    LDA.w #$6161 : STA $1082 ;gap row top
    LDA.w #$8161 : STA $10C2 ;gap row bottom

    LDA.w #$A161 : STA $1102 ;file 2 top row
    LDA.w #$C161 : STA $1142 ;file 2 bottom row

    LDA.w #$E161 : STA $1182 ;gap row top
    LDA.w #$0162 : STA $11c2 ;gap row bottom

    LDA.w #$2162 : STA $1202 ;file 3 top row
    LDA.w #$4162 : STA $1242 ;file 3 bottom row

    LDA.w #$6162 : STA $1282 ;extra gap row top
    LDA.w #$8162 : STA $12c2 ;extra gap row bottom

    ; set lengths
    LDA.w #$3B00
    STA $1004 ;file 1 top row
    STA $1044 ;file 1 bottom row
    STA $1084 ;gap row top
    STA $10C4 ;gap row bottom
    STA $1104 ;file 2 top row
    STA $1144 ;file 2 bottom row
    STA $1184 ;gap row top
    STA $11c4 ;gap row bottom
    STA $1204 ;file 3 top row
    STA $1244 ;file 3 bottom row
    STA $1284 ;extra gap row top
    STA $12c4 ;extra gap row bottom

    ; Set last packet marker
    LDA.w #$00FF : STA $1302
    SEP #$20

RTL
;--------------------------------------------------------------------------------
Validate_SRAM:
RTL
;--------------------------------------------------------------------------------
