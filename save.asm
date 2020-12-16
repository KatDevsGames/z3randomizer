;--------------------------------------------------------------------------------
Validate_SRAM:
	REP #$30 ; vanilla behavior from $0CCD45, includes prize pack reset after save and quit
		LDX #$00FE : -
			STZ $0D00, X
			STZ $0E00, X
			STZ $0F00, X
			DEX #2
		BPL -
	SEP #$30
RTL
;--------------------------------------------------------------------------------
ClearExtendedSaveFile:
	STA $700400, X ; what we wrote over
	STA $700500, X
	STA $700600, X
	STA $700700, X
	STA $700800, X
	STA $700900, X
	STA $700A00, X
	STA $700B00, X
	STA $700C00, X
	STA $700D00, X
	STA $700E00, X
	STA $700F00, X
RTL
;--------------------------------------------------------------------------------
ClearExtendedWRAMSaveFile:
	STA $7EF400, X ; what we wrote over
	STA $7F6500, X
	STA $7F6600, X
	STA $7F6700, X
	STA $7F6800, X
	STA $7F6900, X
	STA $7F6A00, X
	STA $7F6B00, X
	STA $7F6C00, X
	STA $7F6D00, X
	STA $7F6E00, X
	STA $7F6F00, X
RTL
;--------------------------------------------------------------------------------
CopyExtendedSaveFileToWRAM:
	PHA
	SEP #$30
		LDA $4300 : PHA ; preserve DMA parameters
		LDA $4301 : PHA ; preserve DMA parameters
		LDA $4302 : PHA ; preserve DMA parameters
		LDA $4303 : PHA ; preserve DMA parameters
		LDA $4304 : PHA ; preserve DMA parameters
		LDA $4305 : PHA ; preserve DMA parameters
		LDA $4306 : PHA ; preserve DMA parameters
		;--------------------------------------------------------------------------------
		LDA #$00 : STA $4300 ; set DMA transfer direction A -> B, bus A auto increment, single-byte mode

		LDA #$80 : STA $4301 ; set bus B source to WRAM register

		LDA #$00 : STA $2181 ; set WRAM register source address
		LDA #$65 : STA $2182
		LDA #$7F : STA $2183

		STZ $4302 ; set bus A destination address to SRAM
		LDA #$05 : STA $4303
		LDA #$70 : STA $4304

		LDA #$00 : STA $4305 ; set transfer size to 0xB00
		LDA #$0B : STA $4306 ; STZ $4307

		LDA #$01 : STA $420B ; begin DMA transfer
		;--------------------------------------------------------------------------------
		PLA : STA $4306 ; restore DMA parameters
		PLA : STA $4305 ; restore DMA parameters
		PLA : STA $4304 ; restore DMA parameters
		PLA : STA $4303 ; restore DMA parameters
		PLA : STA $4302 ; restore DMA parameters
		PLA : STA $4301 ; restore DMA parameters
		PLA : STA $4300 ; restore DMA parameters
	REP #$30
	PLA
	STA $7EC00D ; what we wrote over
RTL
;--------------------------------------------------------------------------------
CopyExtendedWRAMSaveFileToSRAM:
	PHA
	PHB
	SEP #$30
	LDA #$00 : PHA : PLB
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

		LDA #$00 : STA $2181 ; set WRAM register source address
		LDA #$65 : STA $2182
		LDA #$7F : STA $2183

		STZ $4302 ; set bus A destination address to SRAM
		LDA #$05 : STA $4303
		LDA #$70 : STA $4304

		LDA #$00 : STA $4305 ; set transfer size to 0xB00
		LDA #$0B : STA $4306 ; STZ $4307

		LDA #$01 : STA $420B ; begin DMA transfer
		;--------------------------------------------------------------------------------
		PLA : STA $4306 ; restore DMA parameters
		PLA : STA $4305 ; restore DMA parameters
		PLA : STA $4304 ; restore DMA parameters
		PLA : STA $4303 ; restore DMA parameters
		PLA : STA $4302 ; restore DMA parameters
		PLA : STA $4301 ; restore DMA parameters
		PLA : STA $4300 ; restore DMA parameters
	REP #$30
	PLB
	PLA
	LDX.w #$0000 : TXA ; what we wrote over
RTL
