;BUNNY MAP FIX (J)
;
;This is a repair so that the bunny is on the correct palette when going
; to and from the world map (otherwise, it goes to Link's mail palette,
; and the flesh colors replace some of the pink)
;This bug is much more noticable with custom player sprites, and so this
; fix should address the issues that sprite artists have been having in
; this regard
;This fix will not work for non-J versions.  For some reason, the relevant
; subroutine seems much different in the other ROMs.
;
;Written by Artheau
; while sitting in an uncomfortable chair
; on Jul. 1, 2019
;



;THE PROBLEM
;
;This is a snippet of the relevant code that is causing the problem
;
;;;; starting at $02:fdf0   (main subroutine begins at $02:fd6d)
; .loop
;	 lda [$00]
;	 sta $7ec300, x    <-- this is the problem
;	 sta $7ec500, x
;	 inc $00
;	 inc $00
;	 inx
;	 inx
;	 dey
; bpl .loop
; rts


;THE FIX
;
;$7ec300 is supposed to be the palette cache.  The bug is that instead
; of caching the correct palette, the bugged code is just overwriting
; the cache.  So, we need to make it actually caches the palette.
;There is code already present elsewhere which pulls the palettes from
; the cache afterwards, so we do not need to concern ourselves with
; such matters.


CachePalettesBeforeMapLoad:
.loop
	lda $7ec500,x     ;load up current palette
	sta $7ec300,X     ;cache the palette correctly
	lda [$00]         ;load the map palette
	sta $7ec500,x     ;store the map palette
	inc $00
	inc $00           ;next color in memory
	inx
	inx               ;next color index
	dey               ;decrease loop counter
bpl .loop             ;loop over all the colors
rtl                   ;GET OUT





;================================================================================
; THIS BLOCK WAS PLACED IN HOOKS.ASM:    Bunny Palette/Overworld Map Bugfix
;--------------------------------------------------------------------------------
;org $02fdf0 ; <- Not present in (U) disassembly. Consult bunnymapfix.asm for details
;JSL CachePalettesBeforeMapLoad
;RTS
;================================================================================

