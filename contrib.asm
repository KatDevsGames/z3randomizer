;================================================================
; Contributor: Myramong
;================================================================
Sprite_ShowMessageFromPlayerContact_Edit:
{
	STZ $1CE8 
	JSL.l Sprite_CheckDamageToPlayerSameLayerLong : BCC .dont_show

	LDA $4D : CMP.b #$02 : BEQ .dont_show
	
	JSL.l Sprite_DirectionToFacePlayerLong : TYA : EOR.b #$03
	SEC
RTL
.dont_show
	LDA $0DE0, X
	CLC
RTL
}
;================================================================
Sprite_ShowSolicitedMessageIfPlayerFacing_Edit:
{
	JSL.l Sprite_CheckDamageToPlayerSameLayerLong : BCC .alpha
	JSL.l Sprite_CheckIfPlayerPreoccupied : BCS .alpha
	LDA $F6 : BPL .alpha        
	LDA $0F10, X : BNE .alpha
	
	LDA $4D : CMP.b #$02 : BEQ .alpha
	
	STZ $1CE8 ; set text choice to 1st option (usually yes/confirm/etc)
	JSL.l Sprite_DirectionToFacePlayerLong : PHX : TYX
	
	; Make sure that the sprite is facing towards the player, otherwise
	; talking can't happen. (What sprites actually use this???)
	LDA $05E1A3, X : PLX : CMP $2F : BNE .not_facing_each_other
	PHY
	LDA.b #$40 : STA $0F10, X 
	PLA : EOR.b #$03
	SEC
RTL
.not_facing_each_other
.alpha
	LDA $0DE0, X  
	CLC 
RTL
}
;================================================================
OldMountainMan_TransitionFromTagalong_Edit:
{
	PHA
        
        LDA.b #$AD : JSL Sprite_SpawnDynamically
        
        PLA : PHX : TAX
        
        LDA $1A64, X : AND.b #$03 : STA $0EB0, Y
                                    STA $0DE0, Y
        
        LDA $1A00, X : CLC : ADC.b #$02 : STA $0D00, Y
        LDA $1A14, X : ADC.b #$00 : STA $0D20, Y
        
        LDA $1A28, X : CLC : ADC.b #$02 : STA $0D10, Y
        LDA $1A3C, X : ADC.b #$00 : STA $0D30, Y
        
        LDA $EE : STA $0F20, Y
        
        LDA.b #$01 : STA $0BA0, Y
                     STA $0E80, Y
        
        LDA.b #$01 : STA $02E4 ; OldMountainMan_FreezePlayer
					 STA $037B ; ^
        
        PLX
        
        LDA.b #$00 : STA $7EF3CC
        
        STZ $5E
        
        JML $09A6B6 ; <- 4A6B6 tagalong.asm:1194 (SEP #$30 : RTS)
}
;================================================================
!MAP_OVERLAY = "$7EF414" ; [2]
Sprite_ShowSolicitedMessageIfPlayerFacing_Alt:
{
	STA $1CF0
	STY $1CF1
	
	JSL Sprite_CheckDamageToPlayerSameLayerLong : BCC .alpha
	JSL Sprite_CheckIfPlayerPreoccupied : BCS .alpha
	
	LDA $F6 : BPL .alpha
	LDA $0F10, X : BNE .alpha
	LDA $4D : CMP.b #$02 : BEQ .alpha
	
	JSL Sprite_DirectionToFacePlayerLong : PHX : TYX
	
	; Make sure that the sprite is facing towards the player, otherwise
	; talking can't happen. (What sprites actually use this???)
	LDA $05E1A3, X : PLX : CMP $2F : BNE .not_facing_each_other
	
	PHY
	
	LDA $1CF0
	LDY $1CF1
	
	; Check what room we're in so we know which npc we're talking to
	LDA.b $A0 :	CMP #$05 : BEQ .SahasrahlaDialogs
				CMP #$1C : BEQ .BombShopGuyDialog
						   BRA .SayNothing
	
	.SahasrahlaDialogs
		REP #$20 : LDA.l MapReveal_Sahasrahla : ORA !MAP_OVERLAY : STA !MAP_OVERLAY : SEP #$20
		JSL DialogSahasrahla : BRA .SayNothing
	
	.BombShopGuyDialog
		REP #$20 : LDA.l MapReveal_BombShop : ORA !MAP_OVERLAY : STA !MAP_OVERLAY : SEP #$20
		JSL DialogBombShopGuy
	
	.SayNothing
	
	LDA.b #$40 : STA $0F10, X
	
	PLA : EOR.b #$03
	
	SEC
	
	RTL

.not_facing_each_other
.alpha

	LDA $0DE0, X
	
	CLC
	
	RTL
}
;================================================================