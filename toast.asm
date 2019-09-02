!TOAST_BUFFER = "$7F5400" ; for now
!TOAST_BUFFER_LOW = "$5400" ; for now
;--------------------------------------------------------------------------------
; DoToast:
; in:	A(w) - VRAM Destination
; in:	X(w) - Length in Tiles
;--------------------------------------------------------------------------------
DoToast:
	PHY : PHP
		LDY.w !TOAST_BUFFER_LOW
		JSL.l WriteVRAMBlock
	PLP : PLY
RTL
;--------------------------------------------------------------------------------