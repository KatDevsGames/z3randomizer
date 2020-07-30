CheckReceivedItemPropertiesBeforeLoad:
    LDA $A0 : BEQ .normalCode
    LDA $7EC005 : BNE .lightOff
    .normalCode
    LDA.l AddReceivedItemExpanded_properties, X ;Restore Rando Code
    RTL

.lightOff
    PHX : PHY : PHB
    LDA.l AddReceivedItemExpanded_properties, X ; get palette

    REP #$30
    AND #$0007 ; mask out palette
    ASL #5 ; multiply by 32
    ADC #$C610 ; offset to latter half

    TAX ; give to destination
    LDY #$C610 ; target palette SP0 colors 8-F

    LDA #$000F ; 16 bytes
    MVN $7E, $7E ; move palette

    SEP #$30
    PLB : PLY : PLX
    INC $15
    LDA #$00
    RTL
