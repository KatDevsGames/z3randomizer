;--------------------------------------------------------------------------------
; GenerateSeedTags
;--------------------------------------------------------------------------------
;GenerateSeedTags:
;	PHA : PHX : PHY : PHP
;	REP #$20 ; set 16-bit accumulator
;		LDA $00 : PHA
;		LDA $02 : PHA
;		LDA $04 : PHA
;		LDA $06 : PHA
;		JSL.l NameHash ; get the titlecard hashes
;		
;		LDA $00 : AND.w #$1F1F : STA $00 ; keep it under 0x20 or we'll run out of items
;		LDA $02 : AND.w #$1F1F : STA $02
;		LDA $04 : AND.w #$1F1F : STA $04
;		LDA $06 : AND.w #$1F1F : STA $06
;		
;		REP #$30 ; set 8-bit accumulator & index registers
;		
;		LDY #$08
;		-
;			
;			
;		DEY : BNE -
;		
;
;		REP #20 ; set 16-bit accumulator
;		PLA : STA $06
;		PLA : STA $04
;		PLA : STA $02
;		PLA : STA $00
;	PLP : PLY : PLX : PLA
;RTL
;--------------------------------------------------------------------------------