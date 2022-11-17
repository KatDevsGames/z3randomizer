CheckReceivedItemPropertiesBeforeLoad:
    LDA.b RoomIndex : BEQ .normalCode
    LDA.l $7EC005 : BNE .lightOff
    .normalCode
    LDA.l AddReceivedItemExpanded_properties, X ;Restore Rando Code
    RTL

.lightOff
    PHX : PHY : PHB
    LDA.l AddReceivedItemExpanded_properties, X ; get palette

    REP #$30
    AND.w #$0007 ; mask out palette
    ASL #5 ; multiply by 32
    ADC.w #$C610 ; offset to latter half

    TAX ; give to destination
    LDY.w #$C610 ; target palette SP0 colors 8-F

    LDA.w #$000F ; 16 bytes
    MVN $7E, $7E ; move palette

    SEP #$30
    PLB : PLY : PLX
    INC.b $15
    LDA.b #$00
    RTL
