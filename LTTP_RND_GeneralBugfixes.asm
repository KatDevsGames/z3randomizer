;================================================================================
; The Legend of Zelda, A Link to the Past - Randomizer General Development & Bugfixes
;================================================================================

lorom

;================================================================================

;org $00FFC0 ; <- 7FC0 - Bank00.asm : 9173 (db "THE LEGEND OF ZELDA  " ; 21 bytes)
;db #$23, $4E

org $00FFD5 ; <- 7FD5 - Bank00.asm : 9175 (db $20   ; rom layout)
;db #$35 ; set fast exhirom
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
db #$20, #$17, #$09, #$18 ; year/month/day

;================================================================================

!ADD = "CLC : ADC"
!SUB = "SEC : SBC"
!BLT = "BCC"
!BGE = "BCS"

!NPC_FLAGS   = "$7EF410"
!NPC_FLAGS_2 = "$7EF411"
!INVENTORY_SWAP = "$7EF412"
!INVENTORY_SWAP_2 = "$7EF414"
!MAP_ZOOM = "$7EF415"
!PROGRESSIVE_SHIELD = "$7EF416" ; ss-- ----
!HUD_FLAG = "$7EF416" ; --h- ----
!FORCE_PYRAMID = "$7EF416" ; ---- p---
!IGNORE_FAIRIES = "$7EF416" ; ---- -i--
!SHAME_CHEST = "$7EF416" ; ---s ----
!HAS_GROVE_ITEM = "$7EF416" ; ---- ---g general flags, don't waste these
!HIGHEST_SWORD_LEVEL = "$7EF417" ; --- -sss
!SRAM_SINK = "$7EF41E" ; <- change this
!FRESH_FILE_MARKER = "$7EF4F0" ; zero if fresh file
;$7EF41A[w] - Programmable Item #1
;$7EF41C[w] - Programmable Item #2
;$7EF41E[w] - Programmable Item #3
;$7EF420 - $7EF44F - Stat Tracking Bank 1
;$7EF450 - $7EF45F - RNG Item (Single) Flags
;$7EF460 - Goal Item Counter

!MS_GOT = "$7F5031"
!DARK_WORLD = "$7EF3CA"

!REDRAW = "$7F5000"
!GANON_WARP_CHAIN = "$7F5032";

!FORCE_HEART_SPAWN = "$7F5033";
!SKIP_HEART_SAVE = "$7F5034";

;================================================================================

incsrc hooks.asm
incsrc treekid.asm

;org $208000 ; bank #$20
org $A08000 ; bank #$A0
incsrc itemdowngrade.asm
incsrc bugfixes.asm
incsrc darkworldspawn.asm
incsrc lampmantlecone.asm
incsrc floodgatesoftlock.asm
incsrc heartpieces.asm
incsrc npcitems.asm
incsrc utilities.asm
incsrc flipperkill.asm
incsrc previewdatacopy.asm
incsrc pendantcrystalhud.asm
incsrc potions.asm
incsrc shopkeeper.asm
incsrc bookofmudora.asm
incsrc crypto.asm
incsrc tablets.asm
incsrc rupeelimit.asm
incsrc fairyfixes.asm
incsrc rngfixes.asm
incsrc medallions.asm
incsrc inventory.asm
incsrc ganonfixes.asm
incsrc zelda.asm
incsrc maidencrystals.asm
incsrc zoraking.asm
incsrc catfish.asm
incsrc flute.asm
incsrc dungeondrops.asm
incsrc halfmagicbat.asm
incsrc newitems.asm
incsrc mantle.asm
incsrc swordswap.asm
incsrc stats.asm
incsrc scratchpad.asm
incsrc map.asm
incsrc dialog.asm
incsrc events.asm
incsrc entrances.asm
incsrc clock.asm
incsrc accessability.asm
incsrc heartbeep.asm
incsrc capacityupgrades.asm
incsrc hud.asm
incsrc timer.asm
incsrc glitched.asm
incsrc hardmode.asm
incsrc goalitem.asm
incsrc compasses.asm
incsrc doorframefixes.asm
incsrc hashalphabet.asm ; <- TAKE OUT THE EXTRA ORGS IN HERE - THIS IS WHY WE COULDN'T ADD MORE FILES EARLIER
warnpc $A18000

org $1C8000 ; text tables for translation
incbin i18n_en.bin
warnpc $1CF356

org $A18000 ; static mapping area
incsrc framehook.asm
warnpc $A19000

org $A1FF00 ; static mapping area
incsrc init.asm

org $A48000 ; code bank - PUT NEW CODE HERE
incsrc openmode.asm

;org $228000 ; contrib area
org $A28000 ; contrib area
incsrc contrib.asm

org $A38000
incsrc stats/main.asm

;incsrc sandbox.asm

org $308000 ; bank #$30
incsrc tables.asm

org $318000 ; bank #$31
GFX_Mire_Bombos:
incbin 99ff1_bombos.gfx
warnpc $318800

org $318800
GFX_Mire_Quake:
incbin 99ff1_quake.gfx
warnpc $319000

org $319000
GFX_TRock_Bombos:
incbin a6fc4_bombos.gfx
warnpc $319800

org $319800
GFX_TRock_Ether:
incbin a6fc4_ether.gfx
warnpc $31A000

org $31A000
GFX_HUD_Items:
incbin c2807_v3.gfx
warnpc $31A800

org $31A800
GFX_New_Items:
incbin newitems.gfx
warnpc $31B000

org $31B000
GFX_HUD_Main:
incbin c2e3e.gfx
warnpc $31B800

org $31B800
GFX_Hash_Alphabet:
incbin hashalphabet.chr.gfx
warnpc $31C001

org $338000
GFX_HUD_Palette:
incbin hudpalette.pal
warnpc $348000

org $328000
Extra_Text_Table:
incsrc itemtext.asm

incsrc externalhooks.asm
;================================================================================
org $119100 ; PC 0x89100
incbin map_icons.gfx
warnpc $119401
;================================================================================
org $AF8000 ; PC 0x178000
Static_RNG: ; each line below is 512 bytes of rng
db $90, $2B, $80, $B7, $A2, $E1, $C9, $4F, $1C, $B9, $E6, $20, $58, $67, $65, $A6, $11, $CF, $79, $4C, $C7, $61, $D1, $D4, $D3, $9B, $78, $3B, $FB, $AA, $A3, $15, $7C, $36, $D7, $8B, $0B, $AD, $26, $B5, $3B, $69, $E3, $83, $7F, $11, $E2, $92, $80, $67, $E1, $9C, $CF, $D5, $45, $F5, $6B, $36, $B6, $7A, $1A, $39, $84, $13, $47, $EC, $D8, $AE, $57, $9E, $F4, $0B, $61, $BB, $8D, $0A, $4D, $62, $8E, $22, $E3, $72, $C5, $71, $F7, $99, $0B, $10, $B1, $13, $52, $5E, $78, $43, $74, $8F, $37, $69, $07, $9A, $25, $0E, $30, $6A, $03, $9E, $8E, $0F, $77, $92, $38, $33, $89, $5D, $33, $B3, $01, $A1, $BF, $69, $8D, $97, $27, $6C, $4C, $9B, $A8, $18, $99, $7E, $B2, $DB, $A7, $44, $27, $A8, $A5, $BC, $F5, $AA, $EE, $2E, $CA, $A1, $FE, $C1, $FE, $49, $AD, $3B, $CA, $42, $F3, $6C, $D9, $71, $19, $03, $7B, $E3, $A9, $86, $6C, $D0, $A2, $2B, $FB, $19, $D9, $DB, $47, $88, $7A, $20, $1F, $D5, $3E, $C7, $3F, $7F, $87, $D4, $90, $9C, $D1, $EB, $F9, $78, $11, $2F, $B9, $9B, $77, $01, $80, $DF, $39, $17, $23, $9B, $62, $E3, $A6, $53, $3C, $DC, $F9, $C9, $34, $CC, $3D, $47, $2F, $9E, $1C, $25, $EE, $84, $9E, $45, $B8, $24, $01, $AA, $E3, $B2, $B5, $93, $05, $A1, $08, $09, $38, $19, $D6, $F7, $A6, $2C, $F5, $1D, $4D, $E7, $3B, $2D, $1B, $BC, $86, $40, $D8, $EB, $75, $F2, $8B, $EA, $8C, $D4, $B7, $F1, $A6, $B3, $63, $6B, $82, $92, $DA, $91, $5D, $33, $FD, $66, $32, $92, $C8, $2A, $C2, $10, $83, $49, $1B, $B9, $30, $78, $AA, $D6, $02, $AA, $92, $21, $E6, $04, $00, $F0, $EE, $40, $3F, $5E, $6E, $17, $88, $A9, $A7, $70, $CE, $CA, $E2, $41, $A1, $22, $07, $24, $F7, $C8, $E0, $56, $50, $E0, $85, $F6, $62, $81, $43, $E1, $B7, $6B, $7E, $9E, $0E, $22, $2D, $F3, $56, $49, $73, $CC, $B2, $43, $1B, $59, $40, $5E, $76, $A9, $D5, $F6, $86, $30, $F2, $2E, $40, $E1, $77, $D8, $29, $F3, $B8, $3F, $C3, $84, $19, $E5, $8D, $71, $8C, $20, $A9, $74, $2B, $3B, $30, $3A, $83, $E1, $B8, $3D, $FB, $48, $EF, $7D, $45, $DB, $77, $B6, $6A, $E0, $BB, $58, $55, $B4, $C5, $6A, $A2, $36, $AE, $C2, $AD, $AF, $66, $82, $AB, $F9, $0F, $D9, $58, $95, $65, $98, $DC, $99, $47, $E2, $71, $CD, $6F, $A2, $F9, $5D, $2B, $BF, $67, $6A, $E8, $93, $38, $17, $C0, $7A, $D8, $74, $13, $2D, $94, $7B, $65, $51, $6D, $FE, $05, $FA, $1E, $B3, $3C, $CA, $04, $DE, $E7, $00, $97, $7E, $A4, $4D, $2F, $72, $A2, $4F, $8F, $A9, $3F, $66, $38, $20, $3D, $D4, $AA, $A5, $77, $AB, $F3, $C8, $BE, $36, $F0, $AF, $14, $57, $03, $39, $1F, $DB, $A9, $F0, $28, $05, $1F, $E6, $28, $B5, $D2, $76, $1A, $A4, $BA, $7C, $BF, $7F, $B0, $28, $27, $91, $D3, $34, $43, $47, $AA, $5D, $03, $77, $F4, $83, $CF, $37, $55, $08
db $4F, $8D, $6D, $A3, $0A, $6B, $35, $E2, $C9, $76, $D0, $41, $C4, $49, $4B, $AB, $3F, $D6, $7E, $04, $DB, $FD, $18, $81, $8C, $17, $5C, $3E, $34, $17, $74, $13, $F2, $FC, $0E, $3A, $EF, $E2, $D6, $76, $08, $63, $03, $27, $C8, $09, $45, $C1, $86, $6B, $32, $F7, $F3, $38, $39, $80, $FF, $83, $E2, $75, $6F, $89, $88, $A6, $73, $77, $F3, $24, $E9, $1E, $E1, $B2, $E0, $18, $F3, $8F, $D8, $22, $CB, $EA, $8E, $F2, $1E, $C2, $85, $44, $28, $36, $C8, $9A, $B4, $7A, $A0, $9A, $12, $D9, $97, $37, $1D, $A7, $57, $A1, $F7, $27, $AB, $8D, $AB, $54, $4E, $34, $94, $99, $82, $9D, $F9, $1D, $28, $E4, $72, $CE, $D5, $73, $D9, $AA, $F1, $EB, $7C, $8A, $0A, $55, $E4, $BD, $84, $36, $04, $4E, $E7, $9D, $40, $69, $0F, $DB, $E2, $E3, $06, $08, $7E, $13, $5B, $76, $A6, $44, $D6, $79, $84, $2A, $10, $70, $37, $CF, $08, $FE, $E1, $75, $F8, $1A, $4A, $64, $97, $D5, $7F, $E2, $FC, $CA, $EF, $BA, $FF, $2B, $B3, $14, $CC, $70, $3E, $9A, $33, $DB, $35, $69, $35, $9B, $E0, $B6, $92, $41, $93, $C0, $5D, $B4, $83, $D4, $0F, $0C, $D7, $F6, $65, $ED, $2F, $12, $76, $C2, $DA, $D4, $43, $BB, $80, $E7, $11, $A9, $46, $7C, $C1, $66, $20, $17, $75, $C5, $09, $70, $45, $17, $9C, $43, $66, $E9, $4E, $4C, $02, $DF, $4E, $3D, $03, $EC, $49, $D2, $92, $18, $DF, $F6, $53, $67, $9C, $B1, $4B, $94, $78, $2E, $F8, $F9, $4A, $10, $E9, $C0, $B8, $8D, $A8, $E2, $44, $B3, $3E, $4E, $63, $C6, $4A, $F2, $5F, $32, $35, $D4, $1C, $47, $38, $9B, $DB, $A8, $F1, $4B, $11, $9C, $63, $9E, $72, $20, $AD, $1D, $44, $45, $EA, $B3, $A0, $B0, $8A, $94, $B8, $09, $35, $3B, $8B, $60, $2F, $C5, $46, $ED, $D0, $33, $8D, $97, $25, $CD, $C0, $DE, $74, $B2, $F1, $08, $EC, $5A, $68, $EA, $3C, $62, $46, $E9, $7E, $84, $FF, $73, $36, $7C, $85, $3E, $9A, $B5, $CE, $BC, $57, $78, $53, $52, $0A, $3C, $88, $A0, $E4, $42, $AC, $E8, $3E, $5D, $EC, $82, $FA, $6F, $A8, $D3, $C9, $66, $9A, $DD, $F5, $5D, $EA, $73, $39, $06, $35, $0C, $73, $F3, $DC, $6C, $E0, $9C, $EA, $0F, $A8, $D8, $5D, $F0, $8B, $6A, $E4, $25, $BA, $0C, $0C, $E5, $77, $02, $99, $B2, $69, $A7, $EC, $D9, $4B, $FF, $EE, $EC, $E2, $0A, $16, $30, $D3, $95, $AB, $F7, $1A, $3D, $F7, $D7, $06, $79, $B0, $6E, $57, $3E, $B9, $C7, $B6, $66, $05, $95, $99, $CF, $01, $6C, $62, $F4, $84, $D4, $70, $3B, $E0, $56, $66, $A4, $BC, $1C, $8F, $DA, $3B, $97, $19, $EB, $40, $C1, $C3, $FA, $B1, $17, $5D, $8A, $24, $DE, $3D, $77, $55, $DA, $9F, $99, $7B, $44, $72, $68, $43, $33, $72, $82, $A8, $09, $F6, $C4, $D3, $9F, $00, $3F, $F7, $42, $AE, $E8, $2E, $A0, $BB, $30, $37, $5E, $E2, $E7, $10, $23, $33, $09, $ED, $A2, $00, $70, $CC, $23, $F8, $82, $E0, $F6
;db $8D, $ED, $E9, $BE, $7A, $72, $CB, $F7, $8E, $B8, $8A, $6B, $32, $AE, $11, $52, $E5, $0C, $67, $95, $9A, $A5, $0D, $61, $26, $8D, $90, $03, $C9, $2E, $08, $6E, $DD, $66, $F8, $87, $38, $A5, $A9, $4D, $CC, $5C, $15, $20, $51, $78, $53, $B4, $D4, $C9, $85, $32, $AD, $1A, $2F, $55, $F0, $05, $BD, $3D, $E3, $04, $D9, $CD, $F2, $96, $87, $29, $11, $EB, $65, $43, $93, $A9, $FB, $B1, $3E, $D3, $48, $1F, $8D, $1B, $54, $6A, $F9, $36, $C9, $BD, $F8, $E2, $E8, $34, $34, $8D, $9E, $51, $1B, $B7, $98, $4F, $A8, $27, $EE, $F7, $6E, $5D, $9B, $C3, $18, $77, $09, $1E, $33, $7E, $C3, $0E, $CF, $6E, $E4, $E2, $EA, $9F, $41, $E9, $37, $A8, $DE, $4F, $2C, $79, $8F, $E8, $EB, $68, $01, $64, $AB, $5B, $26, $CB, $56, $5C, $CB, $3E, $AF, $67, $36, $58, $62, $47, $3E, $85, $D7, $11, $9B, $D7, $5A, $D9, $34, $7B, $28, $99, $98, $9D, $8E, $9D, $1F, $AC, $4D, $01, $8D, $C0, $FB, $A5, $5E, $0B, $9A, $3E, $3E, $CE, $6D, $19, $1C, $60, $37, $4A, $A2, $47, $FF, $A6, $A6, $07, $98, $62, $34, $40, $1B, $2C, $C6, $B2, $58, $54, $3B, $12, $B3, $75, $54, $56, $66, $16, $65, $D4, $B5, $82, $9B, $BA, $9A, $76, $42, $34, $61, $9F, $93, $EE, $AA, $1B, $4A, $B4, $AD, $FE, $13, $3C, $5A, $25, $82, $8E, $82, $18, $81, $BE, $D6, $61, $92, $BB, $98, $68, $AA, $AE, $81, $19, $23, $89, $FC, $7D, $65, $F6, $8A, $A5, $CB, $47, $07, $AB, $11, $A7, $35, $60, $73, $4A, $9B, $06, $C7, $3D, $58, $F6, $BA, $B3, $C1, $AD, $31, $1B, $04, $32, $D2, $CC, $31, $21, $71, $31, $2B, $D0, $A9, $FD, $B7, $F7, $10, $69, $6B, $2B, $26, $23, $CC, $46, $44, $8B, $3E, $DF, $17, $4C, $6B, $68, $72, $AF, $0E, $AD, $85, $D6, $7A, $67, $62, $AD, $72, $5E, $D2, $52, $10, $78, $AE, $57, $4C, $14, $44, $53, $8C, $7F, $C4, $D8, $F7, $03, $17, $37, $D6, $BA, $38, $19, $09, $A7, $47, $A3, $5F, $59, $12, $AB, $17, $92, $69, $44, $6A, $14, $79, $51, $68, $27, $36, $3F, $B3, $72, $14, $BA, $C4, $E9, $23, $FD, $FB, $17, $45, $F6, $26, $C9, $83, $2B, $F3, $44, $63, $20, $F3, $A6, $7D, $A4, $C9, $87, $C5, $A2, $CC, $E0, $89, $9F, $B9, $99, $7A, $81, $CB, $9E, $43, $E9, $6E, $36, $42, $43, $7B, $D0, $77, $3D, $10, $16, $5A, $5F, $95, $B1, $10, $58, $D7, $1C, $6E, $90, $85, $F8, $D6, $05, $27, $6C, $2B, $B6, $6E, $68, $4D, $E7, $08, $4B, $0F, $AC, $33, $15, $84, $29, $E4, $79, $97, $B4, $72, $4F, $D7, $F7, $B4, $81, $92, $CB, $2D, $F6, $6C, $C7, $48, $C4, $E6, $F4, $34, $32, $83, $83, $6B, $72, $74, $86, $C4, $15, $00, $71, $20, $52, $BA, $63, $2D, $6C, $E9, $61, $11, $A2, $B9, $92, $5C, $D0, $40, $1F, $04, $44, $D3, $39, $5C, $0E, $0D, $86, $D8, $9B, $07, $3B, $D2, $F6, $A2, $87, $84, $D3, $CC, $54
;db $D5, $ED, $72, $7E, $77, $EF, $CD, $AF, $21, $72, $1E, $B0, $AC, $92, $C1, $1A, $E7, $A5, $95, $A6, $EC, $67, $0D, $11, $22, $3B, $22, $8D, $77, $DD, $4D, $97, $D8, $3B, $AC, $D5, $95, $82, $7F, $DC, $DB, $F4, $14, $08, $F6, $28, $E3, $82, $DE, $7C, $E5, $EE, $07, $51, $07, $89, $42, $95, $79, $25, $54, $43, $B7, $D8, $E0, $92, $94, $4B, $C1, $5C, $A8, $EC, $92, $05, $89, $82, $96, $B2, $6D, $66, $D9, $C5, $86, $45, $5D, $BF, $E0, $C0, $98, $22, $18, $8D, $EC, $65, $EF, $1C, $AD, $CE, $5D, $89, $06, $B0, $38, $F0, $39, $AE, $B6, $07, $49, $5A, $CC, $6A, $EF, $F5, $EC, $C7, $C1, $19, $5B, $88, $D6, $B7, $70, $87, $29, $D9, $72, $00, $46, $21, $0A, $16, $BB, $27, $91, $B2, $7C, $DD, $A7, $6B, $38, $8D, $D6, $C8, $F3, $71, $33, $CA, $A5, $EA, $87, $25, $21, $B7, $D1, $25, $61, $19, $7D, $04, $BD, $2A, $AA, $EC, $C1, $3A, $93, $1C, $69, $6A, $29, $08, $E8, $D8, $C9, $64, $14, $85, $9B, $C4, $11, $FA, $3D, $6C, $57, $5C, $7A, $FE, $49, $13, $FE, $49, $9D, $99, $F9, $2E, $C4, $96, $6E, $C7, $9E, $C4, $DF, $52, $E9, $F7, $3E, $6B, $16, $15, $D3, $5D, $38, $8D, $25, $4A, $F4, $7C, $05, $48, $04, $85, $13, $EA, $D5, $F2, $F5, $2B, $28, $E3, $25, $E0, $D2, $6D, $D2, $28, $A3, $FF, $F1, $19, $89, $2F, $5B, $88, $3E, $67, $FF, $2E, $CC, $CB, $FE, $3B, $71, $9E, $FE, $7C, $55, $CB, $45, $6A, $9F, $9E, $08, $44, $BE, $C1, $51, $D4, $05, $94, $D0, $F8, $90, $7C, $6E, $04, $A8, $68, $53, $A6, $CF, $C4, $F4, $04, $F7, $31, $7A, $AE, $A4, $48, $77, $86, $3E, $C8, $C1, $DC, $1E, $27, $6F, $A7, $C0, $CE, $77, $2A, $59, $13, $50, $42, $E1, $3E, $7F, $56, $D0, $7A, $B6, $38, $13, $05, $72, $63, $2D, $CD, $ED, $EC, $3D, $29, $83, $74, $3F, $14, $52, $94, $5F, $68, $DF, $52, $70, $DB, $6F, $86, $E7, $AB, $9C, $9E, $9E, $EC, $6A, $0A, $EE, $F2, $56, $6F, $A8, $DD, $5F, $DE, $B0, $BF, $79, $B2, $A6, $7E, $54, $CF, $37, $48, $F3, $64, $43, $66, $11, $16, $BF, $A9, $CF, $EF, $EB, $3A, $8E, $E6, $81, $BA, $97, $A6, $69, $50, $E5, $3D, $F3, $85, $A8, $11, $1C, $12, $6D, $87, $6D, $44, $ED, $11, $FE, $F6, $B7, $73, $08, $28, $42, $87, $64, $8E, $0E, $A2, $F2, $DE, $C0, $F8, $04, $B2, $95, $C9, $99, $5A, $5F, $BC, $F0, $58, $61, $6E, $3D, $4C, $26, $1E, $93, $6F, $08, $87, $8A, $7F, $4D, $CB, $B3, $7E, $CB, $EF, $A7, $61, $25, $4E, $58, $B0, $DE, $A7, $9A, $C6, $39, $9A, $9C, $07, $9E, $16, $AF, $F0, $1B, $93, $37, $C6, $B9, $F1, $23, $EE, $8F, $11, $5A, $99, $C5, $F5, $D1, $DE, $82, $48, $53, $B8, $F0, $7F, $38, $A2, $33, $8B, $BC, $EB, $21, $0B, $59, $4E, $0E, $B6, $09, $7D, $8D, $85, $2F, $3E, $B8, $DD, $48, $06, $1B, $17, $A5, $C0, $C9, $2C
warnpc $AF8401
;================================================================================
;bank $3A reserved for downstream use (Plandomizer)
;bank $3B reserved for downstream use (Plandomizer)
;bank $3F reserved for internal debugging
;$7F5700 - $7F57FF reserved for downstream use
;================================================================================
;org $0080DC ; <- 0xDC - Bank00.asm:179 - Kill Music
;db #$A9, #$00, #$EA
;LDA.b #$00 : NOP
;================================================================================
;org $0AC53E ; <- 5453E - Bank0A.asm:1103 - (LDA $0AC51F, X) - i have no idea what this is for anymore
;LDA.b #$7F
;NOP #2
;================================================================================
;org $05DF8B ; <- 2DF8B - Bank05.asm : 2483
;AND.w #$0100 ; allow Sprite_DrawMultiple to access lower half of sprite tiles
;================================================================================
;org $0DF8F1 ; this is required for the X-indicator in the HUD except not anymore obviously
;
;;red pendant
;db $2B, $31, $2C, $31, $3D, $31, $2E, $31
;db $2B, $25, $2C, $25, $2D, $25, $2E, $25
;
;;blue pendant
;db $2B, $31, $2C, $31, $3D, $31, $2E, $31
;db $2B, $2D, $2C, $2D, $2D, $2D, $2E, $2D
;
;;green pendant
;db $2B, $31, $2C, $31, $3D, $31, $2E, $31
;db $2B, $3D, $2C, $3D, $2D, $3D, $2E, $3D
;================================================================================
;org $00CFF2 ; 0x4FF2 - Mire H
;db GFX_Mire_Bombos>>16
;org $00D0D1 ; 0x50D1 - Mire M
;db GFX_Mire_Bombos>>8
;org $00D1B0 ; 0x51B0 - Mire L
;db GFX_Mire_Bombos

;org $00D020 ; 0x5020 - Trock H
;db GFX_TRock_Bombos>>16
;org $00D0FF ; 0x50FF - Trock M
;db GFX_TRock_Bombos>>8
;org $00D1DE ; 0x51DE - Trock L
;db GFX_TRock_Bombos

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
org $008333
Vram_EraseTilemaps_triforce:

org $00893D
EnableForceBlank:

org $00D308
DecompSwordGfx:

org $00D348
DecompShieldGfx:

org $00D51B
GetAnimatedSpriteTile:

org $00D52D
GetAnimatedSpriteTile_variable:

org $00E529
LoadSelectScreenGfx:

org $00F945
PrepDungeonExit:

org $00FDEE
Mirror_InitHdmaSettings:

org $01873A
Dungeon_LoadRoom:

org $02A0A8
Dungeon_SaveRoomData:

org $02A0BE
Dungeon_SaveRoomData_justKeys:

org $02B861
Dungeon_SaveRoomQuadrantData:

org $05A51D
Sprite_SpawnFallingItem:

org $05DF6C ; 02DF6C - Bank05.asm : 2445
Sprite_DrawMultiple:

org $05DF70 ; 02DF70 - Bank05.asm : 2454
Sprite_DrawMultiple_quantity_preset:

org $05DF75 ; 02DF75 - Bank05.asm : 2461
Sprite_DrawMultiple_player_deferred:

org $05E1A7 ; 02E1A7 - Bank05.asm : 2592
Sprite_ShowSolicitedMessageIfPlayerFacing:

org $05E219
Sprite_ShowMessageUnconditional:

org $05FA8E
Sprite_ShowMessageMinimal:

org $05EC96
Sprite_ZeldaLong:

org $06DC5C
Sprite_DrawShadowLong:

org $06DD40
DashKey_Draw:

org $06DBF8
Sprite_PrepAndDrawSingleLargeLong:

org $06DC00
Sprite_PrepAndDrawSingleSmallLong:

org $06EAA6
Sprite_DirectionToFacePlayer:

org $06F12F
Sprite_CheckDamageToPlayerSameLayerLong:

org $07999D
Link_ReceiveItem:

org $07E68F
Unknown_Method_0: ; In US version disassembly simply called "$3E6A6 IN ROM"

org $07F4AA
Sprite_CheckIfPlayerPreoccupied:

org $08C3AE
Ancilla_ReceiveItem:

org $08F710
Ancilla_SetOam_XY_Long:

org $0985E2 ; (break on $0985E4)
AddReceivedItem:

org $098BAD
AddPendantOrCrystal:

org $0993DF
AddDashTremor:

org $09AD58
GiveRupeeGift:

org $1CFD69
Main_ShowTextMessage:

org $0DBA71
GetRandomInt:

org $0DBA80
OAM_AllocateFromRegionA:
org $0DBA84
OAM_AllocateFromRegionB:
org $0DBA88
OAM_AllocateFromRegionC:
org $0DBA8C
OAM_AllocateFromRegionD:
org $0DBA90
OAM_AllocateFromRegionE:
org $0DBA94
OAM_AllocateFromRegionF:

org $0DBB67
Sound_SetSfxPanWithPlayerCoords:

org $0DBB8A
Sound_SetSfx3PanLong:

org $0DDB7F
HUD_RefreshIconLong:

org $0DE01E ; 6E10E - equipment.asm : 787
BottleMenu_movingOn:

org $0DE346
RestoreNormalMenu:

org $0DE9C8
DrawProgressIcons: ; this returns short

org $0DED29
DrawEquipment: ; this returns short

org $0DFA78
HUD_RebuildLong:

org $0EEE10
Messaging_Text:

org $1BED03
Palette_Sword:

org $1BED29
Palette_Shield:

org $1BEDF9
Palette_ArmorAndGloves:

org $1BEE52
Palette_Hud:

org $1DF65D
Sprite_SpawnDynamically:

org $1DFD4B
DiggingGameGuy_AttemptPrizeSpawn:
;================================================================================
