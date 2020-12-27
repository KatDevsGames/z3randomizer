;===============================================================================
; Complete fucking revamp of how item get works
;===============================================================================

Ancilla_ReceiveItem_rupee_anim_tiles:
	db $24, $25, $26

Ancilla_ReceiveItem_rupee_anim_timers:
	db 9, 5, 5

Ancilla_ReceiveItem_oam_props:
	db $05, $01, $04

Ancilla_ReceiveItem_hp_messages:
	dw -1, $0155, $0156, $0157






AddReceiveItem:







.routine
	fillword $0000 : fill $FF*2

.y_offsets
	fillbyte $00 : fill $FF

.x_offsets
	fillbyte $00 : fill $FF

.gfx_offsets
	fillword $0000 : fill $FF*2

.wideness
	fillbyte $00 : fill $FF

.pal
	fillbyte $00 : fill $FF

.sram_addr
	fillword $0000 : fill $FF*2

.sram_write
	fillbyte $00 : fill $FF

.message
	fillbyte $00 : fill $FF

.sound
	fillbyte $00 : fill $FF

; Pal defines:
!r = 1 ; red
!b = 2 ; blue
!g = 4 ; green
!e = 5 ; sword/shield

!t = $00 ; not wide
!w = $80 ; wide

; song storage
; top 2 bits = which address to write
;    00   $00   Song
;    01   $40   SFX1
;    10   $80   SFX2
;    11   $C0   SFX3
; bottom 6 bits = data to write

!sfxsong = $00<<6
!sfx1 = $01<<6
!sfx2 = $02<<6
!sfx3 = $03<<6

!dodododo = $0F|!sfx3
!badgesong = $13|!sfxsong
!hpsfx = $2D|!sfx3
!hcsfx = $0D|!sfx3

!itemx = -1
macro ritem(name, routine, y_off, x_off, gfx_off, oam_props, sram_addr, sram_write, message, sfx)
	!itemx #= !itemx+1
	!get_<name> #= !itemx

	#g<name>:
	pushpc
	; routine points to either a general handler
	; or a specific routine for this item or class of items
	org AddReceiveItem_routine+!itemx*2 : dw <routine>

	; gfx dictates an offset into uncompressed 4bpp graphics data
	org AddReceiveItem_gfx_offsets+!itemx*2 : dw <g>


	;org AddReceiveItem_routine+!itemx*2 : dw <r>
	;org AddReceiveItem_y_offsets+!itemx : db <y>
	;org AddReceiveItem_x_offsets+!itemx : db <x>
	;org AddReceiveItem_gfx_offsets+!itemx*2 : dw <g>
	;org AddReceiveItem_wideness+!itemx : db <w>
	;org AddReceiveItem_pal+!itemx : db <p>

	; SRAM address is an 
	org AddReceiveItem_sram_addr+!itemx*2 : dw <s>
	org AddReceiveItem_sram_write+!itemx : db <t>
	;org AddReceiveItem_message+!itemx : db <m>
	;org AddReceiveItem_sound+!itemx : db <f>
	pullpc
endmacro

;===============================================================================
; Vanilla Items
%ritem("fighter_sword", .directWrite,\ ; name, routine
		-5, 4, $0420, !THIN|!e,\ ; OAM y/x offset, GFX char offset, props
		$F359, 1,\ ; SRAM address, SRAM value
		$FFFF,!dodododo) ; Message, Sound


%ritem("master_sword", .directWrite,\ ; name, routine
		-5, 4, $09C0, !THIN|!e,\ ; OAM y/x offset, GFX char offset, props
		$F359, 2,\ ; SRAM address, SRAM value
		$FFFF,!dodododo) ; Message, Sound


%ritem("tempered_sword", .directWrite,\ ; name, routine
		-5, 4, $09C0, !THIN|!e,\ ; OAM y/x offset, GFX char offset, props
		$F359, 3,\ ; SRAM address, SRAM value
		$FFFF,!dodododo) ; Message, Sound


%ritem("butter_sword", .directWrite,\ ; name, routine
		-5, 4, $09C0, !THIN|!e,\ ; OAM y/x offset, GFX char offset, props
		$F359, 4,\ ; SRAM address, SRAM value
		$FFFF,!dodododo) ; Message, Sound


%ritem("fighter_shield", .fighterShield,\ ; name, routine
		-5, 4, $11E0, !THIN|!e,\ ; OAM y/x offset, GFX char offset, props
		$F35A, 1,\ ; SRAM address, SRAM value
		$FFFF,!dodododo) ; Message, Sound


%ritem("red_shield", .directWrite,\ ; name, routine
		-4, 0, $0140, !WIDE|!e,\ ; OAM y/x offset, GFX char offset, props
		$F35A, 2,\ ; SRAM address, SRAM value
		$FFFF,!dodododo) ; Message, Sound


%ritem("mirror_shield", .directWrite,\ ; name, routine
		-4, 0, $1480, !WIDE|!e,\ ; OAM y/x offset, GFX char offset, props
		$F35A, 3,\ ; SRAM address, SRAM value
		$FFFF,!dodododo) ; Message, Sound


%ritem("fire_rod", .directWrite,\ ; name, routine
		-5, 4, $0480, !THIN|!r,\ ; OAM y/x offset, GFX char offset, props
		$F345, 1,\ ; SRAM address, SRAM value
		$FFFF,!dodododo) ; Message, Sound



; $08
%ritem("ice_rod", .directWrite,\ ; name, routine
		-5, 4, $0480, !THIN|!b,\ ; OAM y/x offset, GFX char offset, props
		$F346, 1,\ ; SRAM address, SRAM value
		$FFFF,!dodododo) ; Message, Sound


%ritem("hammer", .directWrite,\ ; name, routine
		-4, 4, $04A0, !THIN|!r,\ ; OAM y/x offset, GFX char offset, props
		$F34B, 1,\ ; SRAM address, SRAM value
		$FFFF,!dodododo) ; Message, Sound


%ritem("hookshot", .directWrite,\ ; name, routine
		-4, 4, $0460, !THIN|!r,\ ; OAM y/x offset, GFX char offset, props
		$F342, 1,\ ; SRAM address, SRAM value
		$FFFF,!dodododo) ; Message, Sound


%ritem("bow", .directWrite,\ ; name, routine
		-4, 4, $0400, !THIN|!r,\ ; OAM y/x offset, GFX char offset, props
		$F340, 1,\ ; SRAM address, SRAM value
		$FFFF,!dodododo) ; Message, Sound


%ritem("boomerang", .directWrite,\ ; name, routine
		-2, 5, $05E0, !THIN|!b,\ ; OAM y/x offset, GFX char offset, props
		$F341, 1,\ ; SRAM address, SRAM value
		$FFFF,!dodododo) ; Message, Sound


%ritem("powder", .directWrite,\ ; name, routine
		-4, 0, $04C0, !WIDE|!b,\ ; OAM y/x offset, GFX char offset, props
		$F344, 2,\ ; SRAM address, SRAM value
		$FFFF,!dodododo) ; Message, Sound


%ritem("bee", .bottles,\ ; name, routine
		-4, 0, $11A0, !WIDE|!b,\ ; OAM y/x offset, GFX char offset, props
		$F35C, 7,\ ; SRAM address, SRAM value
		$FFFF,!dodododo) ; Message, Sound


%ritem("bombos", .directWrite,\ ; name, routine
		-4, 4, $0C40, !WIDE|!g,\ ; OAM y/x offset, GFX char offset, props
		$F347, 1,\ ; SRAM address, SRAM value
		$FFFF,!dodododo) ; Message, Sound



; $10
%ritem("ether", .directWrite,\ ; name, routine
		-4, 0, $0C00, !WIDE|!g,\ ; OAM y/x offset, GFX char offset, props
		$F348, 1,\ ; SRAM address, SRAM value
		$FFFF,!dodododo) ; Message, Sound


%ritem("quake", .directWrite,\ ; name, routine
		-4, 0, $0C80, !WIDE|!g,\ ; OAM y/x offset, GFX char offset, props
		$F349, 1,\ ; SRAM address, SRAM value
		$FFFF,!dodododo) ; Message, Sound


%ritem("lamp", .directWrite,\ ; name, routine
		-4, 0, $08C0, !WIDE|!r,\ ; OAM y/x offset, GFX char offset, props
		$F34A, 1,\ ; SRAM address, SRAM value
		$FFFF,!dodododo) ; Message, Sound


%ritem("shovel", .directWrite,\ ; name, routine
		-4, 4, $09E0, !THIN|!r,\ ; OAM y/x offset, GFX char offset, props
		$F34C, 1,\ ; SRAM address, SRAM value
		$FFFF,!dodododo) ; Message, Sound


%ritem("flute", .directWrite,\ ; name, routine
		-4, 0, $1440, !WIDE|!b,\ ; OAM y/x offset, GFX char offset, props
		$F34C, 3,\ ; SRAM address, SRAM value
		$FFFF,!dodododo) ; Message, Sound


%ritem("somaria", .directWrite,\ ; name, routine
		-4, 4, $0440, !THIN|!r,\ ; OAM y/x offset, GFX char offset, props
		$F350, 1,\ ; SRAM address, SRAM value
		$FFFF,!dodododo) ; Message, Sound


%ritem("bottle", .newBottle,\ ; name, routine
		-4, 0, $0CC0, !WIDE|!r,\ ; OAM y/x offset, GFX char offset, props
		$F35C, 0,\ ; SRAM address, SRAM value
		$FFFF,!dodododo) ; Message, Sound


%ritem("hp", .hp,\ ; name, routine
		-4, 0, $1400, !WIDE|!r,\ ; OAM y/x offset, GFX char offset, props
		$F36B, 0,\ ; SRAM address, SRAM value
		$FFFF,!hpsfx) ; Message, Sound



; $18
%ritem("byrna", .directWrite,\ ; name, routine
		-4, 4, $0440, !THIN|!b,\ ; OAM y/x offset, GFX char offset, props
		$F351, 1,\ ; SRAM address, SRAM value
		$FFFF,!dodododo) ; Message, Sound


%ritem("cape", .directWrite,\ ; name, routine
		-4, 0, $0900, !WIDE|!r,\ ; OAM y/x offset, GFX char offset, props
		$F352, 1,\ ; SRAM address, SRAM value
		$FFFF,!dodododo) ; Message, Sound


%ritem("mirror", .directWrite,\ ; name, routine
		-4, 0, $0840, !WIDE|!b,\ ; OAM y/x offset, GFX char offset, props
		$F353, 2,\ ; SRAM address, SRAM value
		$FFFF,!dodododo) ; Message, Sound


%ritem("glove", .directWrite,\ ; name, routine
		-4, 0, $0540, !WIDE|!r,\ ; OAM y/x offset, GFX char offset, props
		$F354, 1,\ ; SRAM address, SRAM value
		$FFFF,!dodododo) ; Message, Sound


%ritem("mitts", .directWrite,\ ; name, routine
		-4, 0, $0540, !WIDE|!g,\ ; OAM y/x offset, GFX char offset, props
		$F354, 2,\ ; SRAM address, SRAM value
		$FFFF,!dodododo) ; Message, Sound


%ritem("book", .directWrite,\ ; name, routine
		-4, 0, $0580, !WIDE|!g,\ ; OAM y/x offset, GFX char offset, props
		$F34E, 1,\ ; SRAM address, SRAM value
		$FFFF,!dodododo) ; Message, Sound


%ritem("flippers", .flippers,\ ; name, routine
		-4, 0, $0800, !WIDE|!b,\ ; OAM y/x offset, GFX char offset, props
		$F356, 1,\ ; SRAM address, SRAM value
		$FFFF,!dodododo) ; Message, Sound


%ritem("pearl", .directWrite,\ ; name, routine
		-4, 0, $0980, !WIDE|!r,\ ; OAM y/x offset, GFX char offset, props
		$F357, 1,\ ; SRAM address, SRAM value
		$FFFF,!dodododo) ; Message, Sound



; $20
%ritem("crystal", .palaceItem,\ ; name, routine
		-4, 0, $10A0, !WIDE|6,\ ; OAM y/x offset, GFX char offset, props
		$F37A, 0,\ ; SRAM address, SRAM value
		$FFFF,!dodododo) ; Message, Sound


%ritem("net", .directWrite,\ ; name, routine
		-4, 0, $1060, !WIDE|!r,\ ; OAM y/x offset, GFX char offset, props
		$F34D, 1,\ ; SRAM address, SRAM value
		$FFFF,!dodododo) ; Message, Sound


%ritem("blue_mail", .blueMail,\ ; name, routine
		-4, 0, $0100, !WIDE|!b,\ ; OAM y/x offset, GFX char offset, props
		$F35B, 1,\ ; SRAM address, SRAM value
		$FFFF,!dodododo) ; Message, Sound


%ritem("red_mail", .directWrite,\ ; name, routine
		-5, 0, $0100, !WIDE|!r,\ ; OAM y/x offset, GFX char offset, props
		$F35B, 2,\ ; SRAM address, SRAM value
		$FFFF,!dodododo) ; Message, Sound


%ritem("key", .addKey,\ ; name, routine
		-4, 4, $05C0, !THIN|!b,\ ; OAM y/x offset, GFX char offset, props
		$F36F, 1,\ ; SRAM address, SRAM value
		$FFFF,!dodododo) ; Message, Sound


%ritem("compass", .palaceItem,\ ; name, routine
		-4, 0, $0940, !WIDE|!b,\ ; OAM y/x offset, GFX char offset, props
		$F364, 0,\ ; SRAM address, SRAM value
		$FFFF,!dodododo) ; Message, Sound


%ritem("4hp", .4hp,\ ; name, routine
		-4, 0, $00C0, !WIDE|!r,\ ; OAM y/x offset, GFX char offset, props
		$F36C, 0,\ ; SRAM address, SRAM value
		$FFFF,!dodododo) ; Message, Sound


%ritem("bomb", .addBombs,\ ; name, routine
		-4, 0, $0880, !WIDE|!r,\ ; OAM y/x offset, GFX char offset, props
		$F375, 1,\ ; SRAM address, SRAM value
		$FFFF,!dodododo) ; Message, Sound



; $28
%ritem("3_bombs", .addBombs,\ ; name, routine
		-4, 0, $0040, !WIDE|!r,\ ; OAM y/x offset, GFX char offset, props
		$F375, 3,\ ; SRAM address, SRAM value
		$FFFF,!dodododo) ; Message, Sound


%ritem("mushroom", .mushroom,\ ; name, routine
		-4, 0, $0D40, !WIDE|!g,\ ; OAM y/x offset, GFX char offset, props
		$F344, 1,\ ; SRAM address, SRAM value
		$FFFF,!dodododo) ; Message, Sound


%ritem("red_boomerang", .directWrite,\ ; name, routine
		-2, 5, $05E0, !THIN|!r,\ ; OAM y/x offset, GFX char offset, props
		$F341, 2,\ ; SRAM address, SRAM value
		$FFFF,!dodododo) ; Message, Sound


%ritem("red_cauldron", .bottles,\ ; name, routine
		-4, 0, $0000, !WIDE|!r,\ ; OAM y/x offset, GFX char offset, props
		$F35C, 3,\ ; SRAM address, SRAM value
		$FFFF,!dodododo) ; Message, Sound


%ritem("green_cauldron", .bottles,\ ; name, routine
		-4, 0, $0000, !WIDE|!g,\ ; OAM y/x offset, GFX char offset, props
		$F35C, 4,\ ; SRAM address, SRAM value
		$FFFF,!dodododo) ; Message, Sound


%ritem("blue_cauldron", .bottles,\ ; name, routine
		-4, 0, $0000, !WIDE|!b,\ ; OAM y/x offset, GFX char offset, props
		$F35C, 5,\ ; SRAM address, SRAM value
		$FFFF,!dodododo) ; Message, Sound


%ritem("red_cauldron2", .bottles,\ ; name, routine
		-4, 0, $0000, !WIDE|!r,\ ; OAM y/x offset, GFX char offset, props
		$F36D, 0,\ ; SRAM address, SRAM value
		$FFFF,!dodododo) ; Message, Sound


%ritem("green_cauldron2", .bottles,\ ; name, routine
		-4, 0, $0000, !WIDE|!g,\ ; OAM y/x offset, GFX char offset, props
		$F36E, 0,\ ; SRAM address, SRAM value
		$FFFF,!dodododo) ; Message, Sound



; $30
%ritem("blue_cauldron2", .bottles,\ ; name, routine
		-4, 0, $0000, !WIDE|!b,\ ; OAM y/x offset, GFX char offset, props
		$F36E, 0,\ ; SRAM address, SRAM value
		$FFFF,!dodododo) ; Message, Sound


%ritem("10_bombs", .addBombs,\ ; name, routine
		-4, 0, $0500, !WIDE|!r,\ ; OAM y/x offset, GFX char offset, props
		$F375, 10,\ ; SRAM address, SRAM value
		$FFFF,!dodododo) ; Message, Sound


%ritem("big_key", .palaceItem,\ ; name, routine
		-4, 0, $0DC0, !WIDE|!g,\ ; OAM y/x offset, GFX char offset, props
		$F366, 0,\ ; SRAM address, SRAM value
		$FFFF,!dodododo) ; Message, Sound


%ritem("map", .palaceItem,\ ; name, routine
		-4, 0, $0D80, !WIDE|!g,\ ; OAM y/x offset, GFX char offset, props
		$F368, 0,\ ; SRAM address, SRAM value
		$FFFF,!dodododo) ; Message, Sound


%ritem("1_rupee", .addRupees,\ ; name, routine
		-2, 4, $1000, !THIN|!g,\ ; OAM y/x offset, GFX char offset, props
		$F360, 1,\ ; SRAM address, SRAM value
		$FFFF,!dodododo) ; Message, Sound


%ritem("5_rupees", .addRupees,\ ; name, routine
		-2, 4, $1000, !THIN|!b,\ ; OAM y/x offset, GFX char offset, props
		$F360, 5,\ ; SRAM address, SRAM value
		$FFFF,!dodododo) ; Message, Sound


%ritem("20_rupees", .addRupees,\ ; name, routine
		-2, 4, $1000, !THIN|!r,\ ; OAM y/x offset, GFX char offset, props
		$F360, 20,\ ; SRAM address, SRAM value
		$FFFF,!dodododo) ; Message, Sound


%ritem("green_pendant", .palaceItem,\ ; name, routine
		-4, 0, $1880, !WIDE|!g,\ ; OAM y/x offset, GFX char offset, props
		$F374, 0,\ ; SRAM address, SRAM value
		$FFFF,!dodododo) ; Message, Sound



; $38
%ritem("blue_pendant", .palaceItem,\ ; name, routine
		-4, 0, $1880, !WIDE|!r,\ ; OAM y/x offset, GFX char offset, props
		$F374, 0,\ ; SRAM address, SRAM value
		$FFFF,!dodododo) ; Message, Sound


%ritem("red_pendant", .palaceItem,\ ; name, routine
		-4, 0, $1880, !WIDE|!b,\ ; OAM y/x offset, GFX char offset, props
		$F374, 0,\ ; SRAM address, SRAM value
		$FFFF,!dodododo) ; Message, Sound


%ritem("tossed_bow", .directWrite,\ ; name, routine
		-4, 0, $1120, !WIDE|!b,\ ; OAM y/x offset, GFX char offset, props
		$F340, 1,\ ; SRAM address, SRAM value
		$FFFF,!dodododo) ; Message, Sound


%ritem("silvers", .directWrite,\ ; name, routine
		-4, 0, $10E0, !WIDE|!r,\ ; OAM y/x offset, GFX char offset, props
		$F340, 3,\ ; SRAM address, SRAM value
		$FFFF,!dodododo) ; Message, Sound


%ritem("good_bee", .bottles,\ ; name, routine
		-4, 0, $11A0, !WIDE|!b,\ ; OAM y/x offset, GFX char offset, props
		$F35C, 7,\ ; SRAM address, SRAM value
		$FFFF,!dodododo) ; Message, Sound


%ritem("fairy", .bottles,\ ; name, routine
		-4, 0, $1160, !WIDE|!b,\ ; OAM y/x offset, GFX char offset, props
		$F35C, 6,\ ; SRAM address, SRAM value
		$FFFF,!dodododo) ; Message, Sound


%ritem("boss_hc", .hc,\ ; name, routine
		-4, 0, $00C0, !WIDE|!r,\ ; OAM y/x offset, GFX char offset, props
		$F36C, 0,\ ; SRAM address, SRAM value
		$FFFF,!hcsfx) ; Message, Sound


%ritem("sanc_hc", .4hp,\ ; name, routine
		-4, 0, $00C0, !WIDE|!r,\ ; OAM y/x offset, GFX char offset, props
		$F36C, 0,\ ; SRAM address, SRAM value
		$FFFF,!dodododo) ; Message, Sound



; $40
%ritem("100_rupees", .addRupees,\ ; name, routine
		-4, 0, $1520, !WIDE|!g,\ ; OAM y/x offset, GFX char offset, props
		$F360, 100,\ ; SRAM address, SRAM value
		$FFFF,!dodododo) ; Message, Sound


%ritem("50_rupees", .addRupees,\ ; name, routine
		-4, 0, $1560, !WIDE|!g,\ ; OAM y/x offset, GFX char offset, props
		$F360, 50,\ ; SRAM address, SRAM value
		$FFFF,!dodododo) ; Message, Sound


%ritem("heart", .addHeart,\ ; name, routine
		-2, 4, $14C0, !THIN|!r,\ ; OAM y/x offset, GFX char offset, props
		$F372, 8,\ ; SRAM address, SRAM value
		$FFFF,!dodododo) ; Message, Sound


%ritem("arrow", .addArrows,\ ; name, routine
		-2, 4, $1500, !THIN|!b,\ ; OAM y/x offset, GFX char offset, props
		$F376, 1,\ ; SRAM address, SRAM value
		$FFFF,!dodododo) ; Message, Sound


%ritem("10_arrows", .addArrows,\ ; name, routine
		-4, 0, $0080, !WIDE|!b,\ ; OAM y/x offset, GFX char offset, props
		$F376, 10,\ ; SRAM address, SRAM value
		$FFFF,!dodododo) ; Message, Sound


%ritem("small_magic", .addMagic,\ ; name, routine
		-2, 4, $14E0, !THIN|!g,\ ; OAM y/x offset, GFX char offset, props
		$F373, 16,\ ; SRAM address, SRAM value
		$FFFF,!dodododo) ; Message, Sound


%ritem("300_rupees", .add300Rupees,\ ; name, routine
		-4, 0, $15A0, !WIDE|!g,\ ; OAM y/x offset, GFX char offset, props
		$F360, 0,\ ; SRAM address, SRAM value
		$FFFF,!dodododo) ; Message, Sound


%ritem("20_rupees_green", .addRupees,\ ; name, routine
		-4, 0, $1800, !WIDE|!g,\ ; OAM y/x offset, GFX char offset, props
		$F360, 20,\ ; SRAM address, SRAM value
		$FFFF,!dodododo) ; Message, Sound



; $48
%ritem("gold_bee", .bottles,\ ; name, routine
		-4, 0, $11A0, !WIDE|!b,\ ; OAM y/x offset, GFX char offset, props
		$F35C, 8,\ ; SRAM address, SRAM value
		$FFFF,!dodododo) ; Message, Sound


%ritem("tossed_fighter_sword", .directWrite,\ ; name, routine
		-5, 4, $0420, !THIN|!e,\ ; OAM y/x offset, GFX char offset, props
		$F359, 1,\ ; SRAM address, SRAM value
		$FFFF,!dodododo) ; Message, Sound


%ritem("active_flute", .directWrite,\ ; name, routine
		-4, 0, $1440, !WIDE|!b,\ ; OAM y/x offset, GFX char offset, props
		$F34C, 3,\ ; SRAM address, SRAM value
		$FFFF,!dodododo) ; Message, Sound


%ritem("boots", .boots,\ ; name, routine
		-4, 0, $1840, !WIDE|!r,\ ; OAM y/x offset, GFX char offset, props
		$F355, 1,\ ; SRAM address, SRAM value
		$FFFF,!dodododo) ; Message, Sound


%ritem("Bomb_50"
%ritem("Arrow_70"
%ritem("Half_Magic"
%ritem("Quarter_Magic"

; $50
%ritem("Safe_MS"
%ritem("Bomb_plus5"
%ritem("Bomb_plus10"
%ritem("Arrow_plus5"
%ritem("Arrow_plus10"
%ritem("PRGM_1"
%ritem("PRGM_2"
%ritem("PRGM_3"

; $58
%ritem("Upgrade_Silvers"
%ritem("Rupoor"
%ritem("NULL"
%ritem("Clock_red"
%ritem("Clock_blue"
%ritem("Clock_green"
%ritem("Prog_Sword"
%ritem("Prog_Shield"

; $60
%ritem("Prog_Mail"
%ritem("Prog_Glove"
%ritem("RNG_Single"
%ritem("RNG_Multi"
%ritem("Prog_Bow"
%ritem("Prog_Bow"
%ritem(
%ritem(

; $68
%ritem(
%ritem(
%ritem("Goal_Trifoce"
%ritem("Goal_Multi_Star"
%ritem("Goal_Multi_Triforce"
%ritem("Server_F0"
%ritem("Server_F1"
%ritem("Server_F2"

; $70
%ritem("
%ritem(
%ritem(
%ritem(
%ritem(
%ritem(
%ritem(
%ritem(

; $78
%ritem(
%ritem(
%ritem(
%ritem(
%ritem(
%ritem(
%ritem(
%ritem(

; $80
%ritem(
%ritem(
%ritem(
%ritem(
%ritem(
%ritem(
%ritem(
%ritem(

; $88
%ritem(
%ritem(
%ritem(
%ritem(
%ritem(
%ritem(
%ritem(
%ritem(

; $90
%ritem(
%ritem(
%ritem(
%ritem(
%ritem(
%ritem(
%ritem(
%ritem(

; $98
%ritem(
%ritem(
%ritem(
%ritem(
%ritem(
%ritem(
%ritem(
%ritem(

; $A0
%ritem(
%ritem(
%ritem(
%ritem(
%ritem(
%ritem(
%ritem(
%ritem(

; $A8
%ritem(
%ritem(
%ritem(
%ritem(
%ritem(
%ritem(
%ritem(
%ritem(

; $B0
%ritem(
%ritem(
%ritem(
%ritem(
%ritem(
%ritem(
%ritem(
%ritem(

; $B8
%ritem(
%ritem(
%ritem(
%ritem(
%ritem(
%ritem(
%ritem(
%ritem(

; $C0
%ritem(
%ritem(
%ritem(
%ritem(
%ritem(
%ritem(
%ritem(
%ritem(

; $C8
%ritem(
%ritem(
%ritem(
%ritem(
%ritem(
%ritem(
%ritem(
%ritem(

; $D0
%ritem(
%ritem(
%ritem(
%ritem(
%ritem(
%ritem(
%ritem(
%ritem(

; $D8
%ritem(
%ritem(
%ritem(
%ritem(
%ritem(
%ritem(
%ritem(
%ritem(

; $E0
%ritem(
%ritem(
%ritem(
%ritem(
%ritem(
%ritem(
%ritem(
%ritem(

; $E8
%ritem(
%ritem(
%ritem(
%ritem(
%ritem(
%ritem(
%ritem(
%ritem(

; $F0
%ritem(
%ritem(
%ritem(
%ritem(
%ritem(
%ritem(
%ritem(
%ritem(

; $F8
%ritem(
%ritem(
%ritem(
%ritem(
%ritem(
%ritem(
%ritem("Server_async"
%ritem("NULL_2"





org $08C3AE
Ancilla_ReceiveItem:


