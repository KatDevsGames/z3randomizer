;--------------------------------------------------------------------------------
; $7F5092 - Potion Animation Busy Flags (Health)
; $7F5093 - Potion Animation Busy Flags (Magic)
;--------------------------------------------------------------------------------
!BUSY_HEALTH = $7F5092
RefillHealth:
	REP #$20 ; set 16-bit accumulator
	LDA $A0 ; these are all decimal because i got them that way
	CMP.w #279 : BNE + ; Spike Cave bottles work normally
		SEP #$20 ; set 8-bit accumulator
		LDA #$A0
		BRA .done
	+
	SEP #$20 ; set 8-bit accumulator
	LDA.l PotionHealthRefill : CMP.b #$A0 : !BGE .done
		LDA !BUSY_HEALTH : BNE ++
			LDA.l PotionHealthRefill ; load refill amount
			!ADD CurrentHealth ; add to current health
			CMP MaximumHealth : !BLT +++ : LDA MaximumHealth : +++
			STA !BUSY_HEALTH
		++

		LDA CurrentHealth : CMP.l !BUSY_HEALTH : !BLT ++
			LDA.b #$00 : STA HeartsFiller
			LDA $020A : BNE .notDone
			LDA.b #$00 : STA !BUSY_HEALTH
			SEC
			RTL
		++
			LDA.b #$08 : STA HeartsFiller ; refill some health
			.notDone
			CLC
			RTL
	.done

    ; Check goal health versus actual health.
    ; if(actual < goal) then branch.
    LDA CurrentHealth : CMP MaximumHealth : BCC .refillAllHealth
    LDA MaximumHealth : STA CurrentHealth
    LDA.b #$00 : STA HeartsFiller
    ; ??? not sure what purpose this branch serves.
    LDA $020A : BNE .beta
        SEC
    RTL
.refillAllHealth
    ; Fill up ze health.
    LDA.b #$A0 : STA HeartsFiller
.beta
    CLC
RTL
;--------------------------------------------------------------------------------
!BUSY_MAGIC = $7F5093
RefillMagic:
	REP #$20 ; set 16-bit accumulator
	LDA $A0 ; these are all decimal because i got them that way
	CMP.w #279 : BNE + ; Spike Cave bottles work normally
		SEP #$20 ; set 8-bit accumulator
		LDA #$80
		BRA .done
	+
	SEP #$20 ; set 8-bit accumulator
	LDA.l PotionMagicRefill : CMP.b #$80 : !BGE .done
		LDA !BUSY_MAGIC : BNE ++
			LDA.l PotionMagicRefill ; load refill amount
			!ADD CurrentMagic ; add to current magic
			CMP.b #$80 : !BLT +++ : LDA.b #$80 : +++
			STA !BUSY_MAGIC
		++

		LDA CurrentMagic : CMP.l !BUSY_MAGIC : !BLT ++
			LDA.b #$00 : STA !BUSY_MAGIC
			SEC
			RTL
		++
			LDA.b #$01 : STA MagicFiller ; refill some magic
			CLC
			RTL
	.done

    SEP #$30
    ; Check if Link's magic meter is full
    LDA CurrentMagic : CMP.b #$80
    BCS .itsFull
    ; Tell the magic meter to fill up until it's full.
    LDA.b #$80 : STA MagicFiller
    SEP #$30
    RTL
.itsFull
    ; Set the carry, signifying we're done filling it.
    SEP #$31
RTL
;--------------------------------------------------------------------------------
