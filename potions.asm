;--------------------------------------------------------------------------------
; $7F5092 - Potion Animation Busy Flags (Health)
; $7F5093 - Potion Animation Busy Flags (Magic)
;--------------------------------------------------------------------------------
RefillHealth:
	REP #$20 ; set 16-bit accumulator
	LDA.b RoomIndex ; these are all decimal because i got them that way
	CMP.w #279 : BNE + ; Spike Cave bottles work normally
		SEP #$20 ; set 8-bit accumulator
		LDA.b #$A0
		BRA .done
	+
	SEP #$20 ; set 8-bit accumulator
	LDA.l PotionHealthRefill : CMP.b #$A0 : !BGE .done
		LDA.l BusyHealth : BNE ++
			LDA.l PotionHealthRefill ; load refill amount
			!ADD CurrentHealth ; add to current health
			CMP.l MaximumHealth : !BLT +++ : LDA.l MaximumHealth : +++
			STA.l BusyHealth
		++

		LDA.l CurrentHealth : CMP.l BusyHealth : !BLT ++
			LDA.b #$00 : STA.l HeartsFiller
			LDA.w $020A : BNE .notDone
			LDA.b #$00 : STA.l BusyHealth
			SEC
			RTL
		++
			LDA.b #$08 : STA.l HeartsFiller ; refill some health
			.notDone
			CLC
			RTL
	.done

    ; Check goal health versus actual health.
    ; if(actual < goal) then branch.
    LDA.l CurrentHealth : CMP.l MaximumHealth : BCC .refillAllHealth
    LDA.l MaximumHealth : STA.l CurrentHealth
    LDA.b #$00 : STA.l HeartsFiller
    ; ??? not sure what purpose this branch serves.
    LDA.w $020A : BNE .beta
        SEC
    RTL
.refillAllHealth
    ; Fill up ze health.
    LDA.b #$A0 : STA.l HeartsFiller
.beta
    CLC
RTL
;--------------------------------------------------------------------------------
RefillMagic:
	REP #$20 ; set 16-bit accumulator
	LDA.b RoomIndex ; these are all decimal because i got them that way
	CMP.w #279 : BNE + ; Spike Cave bottles work normally
		SEP #$20 ; set 8-bit accumulator
		LDA.b #$80
		BRA .done
	+
	SEP #$20 ; set 8-bit accumulator
	LDA.l PotionMagicRefill : CMP.b #$80 : !BGE .done
		LDA.l BusyMagic : BNE ++
			LDA.l PotionMagicRefill ; load refill amount
			!ADD CurrentMagic ; add to current magic
			CMP.b #$80 : !BLT +++ : LDA.b #$80 : +++
			STA.l BusyMagic
		++

		LDA.l CurrentMagic : CMP.l BusyMagic : !BLT ++
			LDA.b #$00 : STA.l BusyMagic
			SEC
			RTL
		++
			LDA.b #$01 : STA.l MagicFiller ; refill some magic
			CLC
			RTL
	.done

    SEP #$30
    ; Check if Link's magic meter is full
    LDA.l CurrentMagic : CMP.b #$80
    BCS .itsFull
    ; Tell the magic meter to fill up until it's full.
    LDA.b #$80 : STA.l MagicFiller
    SEP #$30
    RTL
.itsFull
    ; Set the carry, signifying we're done filling it.
    SEP #$31
RTL
;--------------------------------------------------------------------------------
