;================================================================================
; RAM Labels & Assertions
;--------------------------------------------------------------------------------
; Labels for values in WRAM and assertions that ensure they're correct and
; at the expected addresses. All values larger than one byte are little endian.
;--------------------------------------------------------------------------------
; Placeholder and for compass item max count allocations, still WIP
;--------------------------------------------------------------------------------
CompassTotalsWRAM = $7F5410

;================================================================================
; RAM Assertions
;--------------------------------------------------------------------------------
macro assertRAM(label, address)
  assert <label> = <address>, "<label> labeled at incorrect address."
endmacro

%assertRAM(CompassTotalsWRAM, $7F5410)
