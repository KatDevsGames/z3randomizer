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
			!ADD $7EF36D ; add to current health
			CMP $7EF36C : !BLT +++ : LDA $7EF36C : +++
			STA !BUSY_HEALTH
		++

		LDA $7EF36D : CMP.l !BUSY_HEALTH : !BLT ++
			LDA.b #$00 : STA $7EF372
			LDA $020A : BNE .notDone
			LDA.b #$00 : STA !BUSY_HEALTH
			SEC
			RTL
		++
			LDA.b #$08 : STA $7EF372 ; refill some health
			.notDone
			CLC
			RTL
	.done

    ; Check goal health versus actual health.
    ; if(actual < goal) then branch.
    LDA $7EF36D : CMP $7EF36C : BCC .refillAllHealth
    LDA $7EF36C : STA $7EF36D
    LDA.b #$00 : STA $7EF372
    ; ??? not sure what purpose this branch serves.
    LDA $020A : BNE .beta
        SEC
    RTL
.refillAllHealth
    ; Fill up ze health.
    LDA.b #$A0 : STA $7EF372
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
			!ADD $7EF36E ; add to current magic
			CMP.b #$80 : !BLT +++ : LDA.b #$80 : +++
			STA !BUSY_MAGIC
		++

		LDA $7EF36E : CMP.l !BUSY_MAGIC : !BLT ++
			LDA.b #$00 : STA !BUSY_MAGIC
			SEC
			RTL
		++
			LDA.b #$01 : STA $7EF373 ; refill some magic
			CLC
			RTL
	.done

    SEP #$30
    ; Check if Link's magic meter is full
    LDA $7EF36E : CMP.b #$80
    BCS .itsFull
    ; Tell the magic meter to fill up until it's full.
    LDA.b #$80 : STA $7EF373
    SEP #$30
    RTL
.itsFull
    ; Set the carry, signifying we're done filling it.
    SEP #$31
RTL
;--------------------------------------------------------------------------------
