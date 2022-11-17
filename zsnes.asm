;--------------------------------------------------------------------------------
CheckZSNES:
    SEP #$28
    LDA.b #$FF
    CLC
    ADC.b #$FF
    CMP.b #$64
    CLD
    BEQ .zsnes
    REP #$20
    LDA.w #$01FF : TCS ; thing we wrote over - initialize stack
JML.l ReturnCheckZSNES
.zsnes
	JML DontUseZSNES
;--------------------------------------------------------------------------------
