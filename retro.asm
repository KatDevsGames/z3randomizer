CheckEnoughRupeeArrows:
{
    LDA $0B99 : BNE .minigame_arrow
    LDA $7EF340 : CMP #$03 : BCS .skip_arrow_check ;03 is the silver bow without arrows
    LDA $7EF377 : BEQ .no_arrows
    .skip_arrow_check
    PHX
    REP #$30 ;Set 16bit mode
    LDA $7EF340 : AND #$00FF : TAX
    LDA $7EF360 : CMP.l .rupees_cost, X : BCC .not_enough_rupees ;Load Rupees count
    SBC.l .rupees_cost, X : STA $7EF360 ;decrease rupee by 5

    SEP #$30
    PLX
    BRA .ignore_minigame
    .minigame_arrow
    DEC $0B99
    .ignore_minigame
    LDA #$01 ;return 01 if we have enough rupee so it doesnt despawn the arrow
    RTL

    .not_enough_rupees
    SEP #$30
    PLX
    .no_arrows
    LDA #$00 ;Return 00 if we don't have enough rupee so it despawn the arrow
    RTL

    .rupees_cost ;Normal, Normal, Silver, Silver
    dw #$0005, #$0005, #$000A, #$000A
}
