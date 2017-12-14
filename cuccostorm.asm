;================================================================================
StartCuccoStorm:
	;STA $FFFFFF
	PHA : PHX : PHY : PHP
		SEP #$30 ; set 8-bit accumulator & index registers
		LDA $1B : BNE .done ; skip if indoors
		
			LDY.b #$0A
			LDA.b #$0B : JSL Sprite_SpawnDynamically_arbitrary : BMI .done ; spawn a chicken
			JSL Sprite_SetSpawnedCoords
			LDA.b #$24 : STA $0DA0, Y ; turn it into an attack chicken
			LDA.b #$01 : STA $0DB0, Y
		
	.done
	PLP : PLY : PLX : PLA
RTL
;================================================================================
SpawnAngryCucco:
    TXA : EOR $1A : AND.b #$0F : ORA $1B : BNE .spawn_delay
    
    LDA.b #$0B
    LDY.b #$0A
    
    JSL Sprite_SpawnDynamically_arbitrary : BMI .spawn_failed
    
    PHX
    
    TYX
    
    LDA.b #$1E : JSL Sound_SetSfx3PanLong
    
    PLX
    
    LDA.b #$01 : STA $0DB0, Y
    
    PHX
    
    JSL GetRandomInt : STA $0F : AND.b #$02 : BEQ .vertical_entry_point
    
    LDA $0F : ADC $E2    : STA $0D10, Y
    LDA $E3 : ADC.b #$00 : STA $0D30, Y
    
    LDA $0F : AND.b #$01 : TAX
    
    LDA $9F3C, X : ADC $E8    : STA $0D00, Y
    LDA $E9      : ADC.b #$00 : STA $0D20, Y
    
    BRA .set_velocity

.vertical_entry_point

    LDA $0F : ADC $E8    : STA $0D00, Y
    LDA $E9 : ADC.b #$00 : STA $0D20, Y
    
    LDA $0F : AND.b #$01 : TAX
    
    LDA $9F3C, X : ADC $E2    : STA $0D10, Y
    LDA $E3      : ADC.b #$00 : STA $0D30, Y

.set_velocity

    TYX
    
    LDA.b #$20 : JSL Sprite_ApplySpeedTowardsPlayerLong
    
    PLX

    LDA.b #$30 : JSL Sound_SetSfx2PanLong

.spawn_failed
.spawn_delay

RTL
;================================================================================