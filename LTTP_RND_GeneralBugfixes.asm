;================================================================================
; The Legend of Zelda, A Link to the Past - Randomizer General Development & Bugfixes
;================================================================================
lorom

;================================================================================

;org $00FFC0 ; <- 7FC0 - Bank00.asm : 9173 (db "THE LEGEND OF ZELDA  " ; 21 bytes)
;db #$23, $4E

org $00FFD5 ; <- 7FD5 - Bank00.asm : 9175 (db $20   ; rom layout)
db #$30 ; set fast lorom

;org $00FFD6 ; <- 7FD6 - Bank00.asm : 9176 (db $02   ; cartridge type)
;db #$55 ; enable S-RTC

org $00FFD7 ; <- 7FD7 - Bank00.asm : 9177 (db $0A   ; rom size)
db #$0B ; mark rom as 16mbit

org $00FFD8 ; <- 7FD8 - Bank00.asm : 9178 (db $03   ; ram size (sram size))
db #$05 ; mark sram as 32k

org $3FFFFF ; <- 1FFFFF
db #$00 ; expand file to 2mb

org $1FFFF8 ; <- FFFF8 timestamp rom
db #$20, #$19, #$08, #$31 ; year/month/day

;================================================================================
!ROM_VERSION_LOW ?= 1  ; ROM version (two 16-bit integers)
!ROM_VERSION_HIGH ?= 2 ;

org $00FFE0 ; Unused hardware vector
RomVersion:
dw !ROM_VERSION_LOW
dw !ROM_VERSION_HIGH

;================================================================================
!ADD = "CLC : ADC"
!SUB = "SEC : SBC"
!BLT = "BCC"
!BGE = "BCS"

function hexto555(h) = ((((h&$FF)/8)<<10)|(((h>>8&$FF)/8)<<5)|(((h>>16&$FF)/8)<<0))

; Feature flags, run asar with -DFEATURE_X=1 to enable
!FEATURE_NEW_TEXT ?= 0

;================================================================================

incsrc hooks.asm
incsrc spriteswap.asm
incsrc hashalphabethooks.asm
incsrc sharedplayerpalettefix.asm
incsrc ram.asm
incsrc sram.asm
incsrc registers.asm
incsrc vanillalabels.asm

;org $208000 ; bank #$20
org $A08000 ; bank #$A0
incsrc newitems.asm ; LEAVE THIS AS FIRST
incsrc itemdowngrade.asm
incsrc bugfixes.asm
incsrc darkworldspawn.asm
incsrc lampmantlecone.asm
incsrc floodgatesoftlock.asm
incsrc heartpieces.asm
incsrc npcitems.asm
incsrc utilities.asm
incsrc flipperkill.asm
incsrc pendantcrystalhud.asm
incsrc potions.asm
incsrc shopkeeper.asm
incsrc bookofmudora.asm
incsrc crypto.asm
incsrc tablets.asm
incsrc fairyfixes.asm
incsrc rngfixes.asm
incsrc medallions.asm
incsrc inventory.asm
incsrc zelda.asm
incsrc maidencrystals.asm
incsrc flute.asm
incsrc dungeondrops.asm
incsrc halfmagicbat.asm
incsrc swordswap.asm
incsrc stats.asm
incsrc dialog.asm
incsrc entrances.asm
incsrc accessibility.asm
incsrc heartbeep.asm
incsrc capacityupgrades.asm
incsrc timer.asm
incsrc doorframefixes.asm
incsrc music.asm
incsrc roomloading.asm
incsrc icepalacegraphics.asm
warnpc $A18000

org $1C8000 ; text tables for translation
incbin "data/i18n_en.bin"
warnpc $1CF356

org $A18000 ; static mapping area
incsrc framehook.asm
warnpc $A186B0

org $A186B0 ; static mapping area, do not move
incsrc hud.asm
warnpc $A18800

org $A18800 ; static mapping area
incsrc zsnes.asm
warnpc $A19000

org $A1A000 ; static mapping area. Referenced by front end. Do not move.
incsrc invertedstatic.asm
warnpc $A1A100

org $A1B000
incsrc failure.asm
warnpc $A1FF00


org $A1FF00 ; static mapping area
incsrc init.asm

org $A48000 ; code bank - PUT NEW CODE HERE
incsrc glitched.asm
incsrc hardmode.asm
incsrc goalitem.asm
incsrc quickswap.asm
incsrc endingsequence.asm
incsrc cuccostorm.asm
incsrc retro.asm
incsrc controllerjank.asm
incsrc boots.asm
incsrc events.asm
incsrc fileselect.asm
incsrc playername.asm
incsrc decryption.asm
incsrc hashalphabet.asm
incsrc inverted.asm
incsrc invertedmaps.asm
incsrc newhud.asm
incsrc compasses.asm
incsrc save.asm
incsrc password.asm
incsrc enemy_adjustments.asm
incsrc hudtext.asm
incsrc servicerequest.asm
incsrc elder.asm
incsrc toast.asm
incsrc darkroomitems.asm
incsrc fastcredits.asm
incsrc msu.asm
incsrc dungeonmap.asm
if !FEATURE_NEW_TEXT
    incsrc textrenderer.asm
endif
warnpc $A58000

org $A28000

org $A38000
incsrc stats/main.asm

org $308000 ; bank #$30
incsrc tables.asm

org $348000
incsrc spc.asm

org $318000 ; bank #$31
GFX_Mire_Bombos:
incbin "data/99ff1_bombos.gfx"
warnpc $318800

org $318800
GFX_Mire_Quake:
incbin "data/99ff1_quake.gfx"
warnpc $319000

org $319000
GFX_TRock_Bombos:
incbin "data/a6fc4_bombos.gfx"
warnpc $319800

org $319800
GFX_TRock_Ether:
incbin "data/a6fc4_ether.gfx"
warnpc $31A000

org $31A000
GFX_HUD_Items:
incbin "data/c2807_v4.gfx"
warnpc $31A800

org $31A800
GFX_New_Items:
incbin "data/newitems.gfx"
;incbin eventitems.gfx ; *EVENT*
warnpc $31B000

org $31B000
GFX_HUD_Main:
incbin "data/c2e3e.gfx"
warnpc $31B800

org $31C000
IcePalaceFloorGfx:
incbin "data/ice_palace_floor.bin"
warnpc $31C801

org $31C800
Damage_Table:
incbin "data/damage_table.bin"
warnpc $31D001

org $31D000
FileSelectNewGraphics:
incbin "data/fileselect.chr.gfx"
warnpc $31E001

org $31E000
InvertedCastleHole: ;address used by front end. DO NOT MOVE!
incbin "data/sheet73.gfx"
warnpc $31E501

org $338000
GFX_HUD_Palette:
incbin "data/hudpalette.pal"
warnpc $338041

org $339000
incbin "data/sheet178.gfx"
warnpc $339600

org $339600
BossMapIconGFX:
incbin "data/bossicons.4bpp"

if !FEATURE_NEW_TEXT
    org $339C00
    NewFont:
    incbin "data/newfont.bin"
    NewFontInverted:
    incbin "data/newfont_inverted.bin"

    org $0CD7DF
    incbin "data/text_unscramble1.bin"
    org $0CE4D5
    incbin "data/text_unscramble2.bin"
endif

org $328000
Extra_Text_Table:
incsrc itemtext.asm

incsrc externalhooks.asm
;================================================================================
org $119100 ; PC 0x89100
incbin "data/map_icons.gfx"
warnpc $119401
;================================================================================
org $AF8000 ; PC 0x178000
Static_RNG: ; each line below is 512 bytes of rng
incsrc staticrng.asm
warnpc $AF8401
;================================================================================
org $AF8400
incsrc tournament.asm
incsrc eventdata.asm
warnpc $B08000
;================================================================================
;Bank Map
;$20 Code Bank
;$21 Reserved (Frame Hook & Init)
;$22 Unused
;$23 Stats & Credits
;$24 Code Bank
;$29 External hooks (rest of bank not used)
;$2E Reserved for Tournament Use
;$2F Static RNG (rest is reserved for tournament use)
;$30 Main Configuration Table
;$31 Graphics Bank
;$32 Text Bank
;$33 Graphics Bank
;$36 reserved for Enemizer
;$3A reserved for downstream use
;$3B reserved for downstream use
;$3F reserved for internal debugging
;================================================================================
;RAM
;See ram.asm for label assignments
;$7EC900[0x1F00]: BigRAM buffer
;$7EF000[0x500]: SRAM mirror First 0x500 bytes of SRAM
;   See sram.asm for labels and assignments
;$7F5000[0x800]: Rando's main free ram region
;   See ram.asm for specific assignments
;$7F6000[0x1000]: SRAM buffer mapped to vanilla save slots 1 and 2
;   See sram.asm for labels and assignments
;$7F7667[0x6719] - free ram
;================================================================================
;SRAM Map
;See sram.asm for label assignments and documentation
;$70:0000 (5K) Game state
;  0000-04FF Vanilla Slot 1 (mirrored at $7EF000)
;  0500-14FF Ext Slot 1 (mirrored at $7F6000)
;$70:2000 (0x25) ROM Name and version number
;$70:3000 (0x16) Password
;$70:6000 (8K) Scratch buffers
;================================================================================

org $00D09C ; 0x509C - HUD Items H
db GFX_HUD_Items>>16
org $00D17B ; 0x517B - HUD Items M
db GFX_HUD_Items>>8
org $00D25A ; 0x525A - HUD Items L
db GFX_HUD_Items

; this used to be a pointer to a dummy file
org $00D065 ; 005065 - New Items H
db GFX_New_Items>>16
org $00D144 ; 005114 - New Items M
db GFX_New_Items>>8
org $00D223 ; 005223 - New Items L
db GFX_New_Items

org $00D09D ; 0x509D - HUD Main H
db GFX_HUD_Main>>16
org $00D17C ; 0x517C - HUD Main M
db GFX_HUD_Main>>8
org $00D25B ; 0x525B - HUD Main L
db GFX_HUD_Main
;================================================================================
