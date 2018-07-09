;================================================================================
; RTPreview SRAM Hook
;--------------------------------------------------------------------------------
MaybeWriteSRAMTrace:
	LDA EnableSRAMTrace : AND.l TournamentSeedInverse : BEQ +
		JSL.l WriteStatusPreview
	+
RTL
;--------------------------------------------------------------------------------
WriteStatusPreview:
	PHA
		LDA $4300 : PHA ; preserve DMA parameters
		LDA $4301 : PHA ; preserve DMA parameters
		LDA $4302 : PHA ; preserve DMA parameters
		LDA $4303 : PHA ; preserve DMA parameters
		LDA $4304 : PHA ; preserve DMA parameters
		LDA $4305 : PHA ; preserve DMA parameters
		LDA $4306 : PHA ; preserve DMA parameters
		;--------------------------------------------------------------------------------
		LDA #$80 : STA $4300 ; set DMA transfer direction B -> A, bus A auto increment, single-byte mode
		
		STA $4301 ; set bus B source to WRAM register
		
		LDA #$40 : STA $2181 ; set WRAM register source address
		LDA #$F3 : STA $2182
		LDA #$7E : STA $2183
		
		STZ $4302 ; set bus A destination address to SRAM
		LDA #$1E : STA $4303
		LDA #$70 : STA $4304
		
		LDA #$80 : STA $4305 ; set transfer size to 0x180
		LDA #$01 : STA $4306 ; STZ $4307
		
		LDA #$01 : STA $420B ; begin DMA transfer
		;--------------------------------------------------------------------------------
		PLA : STA $4306 ; restore DMA parameters
		PLA : STA $4305 ; restore DMA parameters
		PLA : STA $4304 ; restore DMA parameters
		PLA : STA $4303 ; restore DMA parameters
		PLA : STA $4302 ; restore DMA parameters
		PLA : STA $4301 ; restore DMA parameters
		PLA : STA $4300 ; restore DMA parameters
	PLA
RTL
;--------------------------------------------------------------------------------
;WriteStatusPreview:
;	PHA : PHX : PHP
;	
;	REP #$20 ; set 16-bit accumulator
;	CLC
;	LDX.b #$00
;	-
;		LDA $7EF340, X   : STA $701E00, X 
;		LDA $7EF340+2, X : STA $701E00+2, X
;		LDA $7EF340+4, X : STA $701E00+4, X
;		TXA : ADC.b #$06 : TAX
;		CPX #$24 : !BLT -
;
;	SEP #$20 ; set 8-bit accumulator
;	LDA $7EF374 : STA $701E24
;	LDA $7EF37A : STA $701E25
;	
;	PLP : PLX : PLA
;RTL
;--------------------------------------------------------------------------------