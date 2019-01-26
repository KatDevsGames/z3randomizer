lorom

;SHARED SPRITE PALETTE FIX
;
;This is a repair so that sprites that previously shared Link's palette
;no longer share his palette.  In the vanilla game this was not an issue
;but with custom sprites some very strange color transitions can occur.
;
;The convention in the comments here is that bits are labeled [7:0]
;
;Written by Artheau
;during a cold morning on Oct. 29, 2018
;


;Bee (Credits)
;Seems like this was a bug in the vanilla game
;This puts the bee on the palette it uses in the rest of the game (bits 1-3)
;Appears virtually identical
org $8ECFBA		;$74FBA in ROM
db $76

;Chests (Credits)
;Gives them a much more natural color (bits 1-3)
;There is one hex value for each chest
;The result is a visual improvement
org $8ED35A		;7535A in ROM
db $37
org $8ED362		;75362 in ROM
db $37
org $8ED36A		;7536A in ROM
db $37

;Sweeping Woman (In-Game)
;Puts her on the same color of red that she is in the ending credits (bits 1-3)
org $8DB383		;6B383 in ROM
db $07

;Ravens (Credits)
;Puts them on the same color as they are in-game (bits 1-3)
org $8ED653		;75653 in ROM
db $09

;Running Man (In-Game)
;Puts the jacket on the same palette as the hat
;bits 1-3 are XORed with the base palette (currently 0b011)
org $85E9DA		;2E9DA in ROM
db $00
org $85E9EA		;2E9EA in ROM
db $40
org $85E9FA		;2E9FA in ROM
db $00
org $85EA0A		;2EA0A in ROM
db $40
org $85EA1A		;2EA1A in ROM
db $00
org $85EA2A		;2EA2A in ROM
db $00
org $85EA3A		;2EA3A in ROM
db $40
org $85EA4A		;2EA4A in ROM
db $40

;Running Man (Credits Only)
;Puts the jacket and the arm on the same palette as the hat (bits 1-3)
org $8ECE72		;74E72 in ROM
db $47
org $8ECE8A		;74E8A in ROM
db $07
org $8ECE92		;74E92 in ROM
db $07
org $8ECEA2		;74EA2 in ROM
db $47
org $8ECEAA		;74EAA in ROM
db $07
org $8ECEBA		;74EBA in ROM
db $47

;Hoarder (when under a stone)
;Complete fix
;This was a bug that made the hoarder ignore its palette setting only when it was under a rock
org $86AAAC		;32AAC in ROM
db $F0
;But now we have to give it the correct palette info (bits 1-3)
org $86AA46		;32A46 in ROM
db $0B
org $86AA48		;32A48 in ROM
db $0B
org $86AA4A		;32A4A in ROM
db $0B
org $86AA4C		;32A4C in ROM
db $0B
org $86AA4E		;32A4E in ROM
db $4B

;Thief (friendly thief in cave)
;There is a subtle difference in color here (more pastel)
;His palette is given by bits 1-3
org $8DC322		;6C322 in ROM
db $07			;set him to red
;Alternate palette options:
;db $09			;lavender
;db $0B			;green
;db $0D 		;yellow (same as he is in the credits)

;Pedestal Pull
;This edit DOES create a visual difference
;so I also present some alternate options
;
;
;Option A: Fix the red pendant, but now it ignores shadows
;and as a result, looks bugged
;org $85893D	;2893D in ROM
;db $07
;
;
;Option B: Make the red pendant a yellow pendant
;org $85893D	;2893D in ROM
;db $0D
;
;
;Option C: Also change the other pendants so that they all
;ignore shadows.  This looks better because they appear to
;glow even brighter
;BUT I had to compromise on the color of the blue pendant
org $858933		;28933 in ROM
db $05			;change palette of blue pendant
org $858938		;28938 in ROM
db $01			;change palette of green pendant
org $85893D		;2893D in ROM
db $07			;change palette of red pendant
;the pendants travel in a direction determined by their color
;so option C also requires a fix to their directional movement
org $858D21		;28D21 in ROM
db $04
org $858D22		;28D22 in ROM
db $04
org $858D23		;28D23 in ROM
db $FC
org $858D24		;28D24 in ROM
db $00
org $858D25		;28D25 in ROM
db $FE
org $858D26		;28D26 in ROM
db $FE
org $858D27		;28D27 in ROM
db $FE
org $858D28		;28D28 in ROM
db $FC

;Blind Maiden
;Previously she switched palettes when she arrived at the light (although it was very subtle)
;Here we just set it so that she starts at that color
org $8DB410		;6B410 in ROM
db $4B			;sets the palette of the prison sprite (bits 1-3)
org $89A8EB		;4A8EB in ROM
db $05			;sets the palette of the tagalong (bits 0-2)

;Crystal Maiden (credits)
;One of the crystal maidens was on Link's palette, but only in the end sequence
;palette given by bits 1-3
org $8EC8C3		;748C3 in ROM
db $37

;Cukeman (Everywhere)
;This guy is such a bugfest. Did you know that his body remains an enemy and if you try talking to him,
;you have to target the overlaid sprite that only has eyeballs and a mouth?
;This is why you can still be damaged by him. In any case, I digress.  Let's talk edits.
;
;These edits specifically target the color of his lips
;Bits 1-3 are XORed with his base ID palette (0b100)
;and the base palette cannot be changed without breaking buzzblobs (i.e. green dancing pickles)
org $9AFA93		;D7A93 in ROM
db $0F
org $9AFAAB		;D7AAB in ROM
db $0F
org $9AFAC3		;D7AC3 in ROM
db $0F
org $9AFADB		;D7ADB in ROM
db $0F
org $9AFAF3		;D7AF3 in ROM
db $0F
org $9AFB0B		;D7B0B in ROM
db $0F
;BUT there is a very specific ramification of the above edits:
;Because his lips were moved to the red palette, his lips
;no longer respond to shadowing effects
;(like how red rupees appear in lost woods)
;this will only be apparent if enemizer places him in areas like lost woods
;or in the end credits sequence during his short cameo,
;so the line below replaces him in the end sequence
;with a buzzblob
org $8ED664		;75664 in ROM
db $00			;number of cukeman in the scene (up to 4)
