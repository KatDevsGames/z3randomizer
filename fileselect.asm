;DrawPlayerFile:
;	PHX : PHY
;	
;		; draw bow
;		LDA.w #$21DA : STA $1070
;		LDA.w #$21DB : STA $1072
;		LDA.w #$21EA : STA $10A2
;		LDA.w #$21EB : STA $10A4
;		
;		; draw bow
;		LDA.w #$21DA : STA $1070
;		LDA.w #$21DB : STA $1072
;		LDA.w #$21EA : STA $10A2
;		LDA.w #$21EB : STA $10A4
;		
;	PLY : PLX
;	LDA.w #$0004 : STA $02 ; thing we wrote over
;RTL
AltBufferTable:
 
    REP #$20
    LDX.w #500 ; 10 rows with 50 bytes (23 tiles * 2 + 4 byte header)
    ;fill with the blank character
    LDA.w #$0188
    -
        STA $1000, X
        DEX : DEX : BNE -
 
    ; set vram offsets
    LDA.w #$2861 : STA $1002 ;file 1 top row
	
    LDA.w #$4861 : STA $1034 ;file 1 bottom row
	
    LDA.w #$6861 : STA $1066 ;gap row top
    LDA.w #$8861 : STA $1098 ;gap row bottom
	
    LDA.w #$A861 : STA $10CA ;file 2 top row
    LDA.w #$C861 : STA $10FC ;file 2 bottom row
	
    LDA.w #$E861 : STA $112E ;gap row top
    LDA.w #$0862 : STA $1160 ;gap row bottom
	
    LDA.w #$2862 : STA $1192 ;file 3 top row
    LDA.w #$4862 : STA $11c4 ;file 3 bottom row
 
    ; set lengths
    LDA.w #$2d00
    STA $1004 ;file 1 top row
    STA $1036 ;file 1 bottom row
    STA $1068 ;gap row top
    STA $109A ;gap row bottom
    STA $10CC ;file 2 top row
    STA $10FE ;file 2 bottom row
    STA $1130 ;gap row top
    STA $1162 ;gap row bottom
    STA $1194 ;file 3 top row
    STA $11c6 ;file 3 bottom row
 
    ; Set last packet marker
    LDA.w #$00FF : STA $11f6
    SEP #$20

RTL
;------------------------------------------------------------------------------
Validate_SRAM:
RTL
