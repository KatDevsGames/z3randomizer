NewFireBarDamage:
{
    LDA $00EE : CMP $0F20, X : BNE .NotSameLayer
        JSL Sprite_AttemptDamageToPlayerPlusRecoilLong
        RTL
    .NotSameLayer
    RTL
}