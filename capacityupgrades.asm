;================================================================================
; Capacity Logic
;================================================================================
IncrementBombs:
        LDA.l BombCapacity : BEQ + ; Skip if we can't have bombs
                DEC
                CMP.l BombsEquipment : !BLT +
                        LDA.l BombsEquipment
                        CMP.b #99 : !BGE +
                                INC : STA.l BombsEquipment
        +
RTL
;--------------------------------------------------------------------------------
IncrementArrows:
        LDA.l ArrowCapacity : DEC
        CMP.l CurrentArrows : !BLT +
                LDA.l CurrentArrows
                        CMP.b #99 : !BGE +
                        INC : STA.l CurrentArrows
        +
RTL
;--------------------------------------------------------------------------------
CompareBombsToMax:
        LDA.l BombCapacity
        CMP.l BombsEquipment
RTL
;--------------------------------------------------------------------------------
