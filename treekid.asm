;================================================================================
; Tree Kid Fix
;--------------------------------------------------------------------------------
org $06B12B ; <- 3312B - tree status set - 418 - LDA NpcFlagsVanilla : ORA.b #$08 : STA NpcFlagsVanilla
LDA NpcFlagsVanilla : AND.b #$F7 : STA NpcFlagsVanilla ; unset arboration instead of setting it
;--------------------------------------------------------------------------------
org $06B072 ; <- 33072 - FluteAardvark_InitialStateFromFluteState - 418 : dw FluteAardvark_AlreadyArborated
db #$8B
;================================================================================
