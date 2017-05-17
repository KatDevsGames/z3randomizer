;================================================================================
; Tree Kid Fix
;--------------------------------------------------------------------------------
org $06B12B ; <- 3312B - tree status set - 418 - LDA $7EF3C9 : ORA.b #$08 : STA $7EF3C9
LDA $7EF3C9 : AND.b #$F7 : STA $7EF3C9 ; unset arboration instead of setting it
;--------------------------------------------------------------------------------
org $06B072 ; <- 33072 - FluteAardvark_InitialStateFromFluteState - 418 : dw FluteAardvark_AlreadyArborated
db #$8B
;================================================================================