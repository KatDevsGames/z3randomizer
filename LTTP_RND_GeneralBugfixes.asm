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
db #$20, #$18, #$07, #$23 ; year/month/day

;================================================================================

!ADD = "CLC : ADC"
!SUB = "SEC : SBC"
!BLT = "BCC"
!BGE = "BCS"

!INVENTORY_SWAP = "$7EF38C"
!INVENTORY_SWAP_2 = "$7EF38E"
!NPC_FLAGS   = "$7EF410"
!NPC_FLAGS_2 = "$7EF411"
!MAP_OVERLAY = "$7EF414" ; [2]
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
;$7EF418 - Goal Item Counter
;$7EF420 - $7EF466 - Stat Tracking Bank 1
;$7EF450 - $7EF45F - RNG Item (Single) Flags

!MS_GOT = "$7F5031"
!DARK_WORLD = "$7EF3CA"

!REDRAW = "$7F5000"
!GANON_WARP_CHAIN = "$7F5032";

!TILE_UPLOAD_BUFFER = "$7EA180";

!FORCE_HEART_SPAWN = "$7F5033";
!SKIP_HEART_SAVE = "$7F5034";

!INVENTORY_SWAP = "$7EF38C"
!INVENTORY_SWAP_2 = "$7EF38E"

!ITEM_LIMIT_COUNTS = "$7EF390"
!SHOP_PURCHASE_COUNTS = "$7EF302"
;================================================================================

incsrc hooks.asm
incsrc treekid.asm
incsrc spriteswap.asm
incsrc hashalphabethooks.asm

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
incsrc msu.asm
incsrc dialog.asm
incsrc events.asm
incsrc entrances.asm
incsrc clock.asm
incsrc accessability.asm
incsrc heartbeep.asm
incsrc capacityupgrades.asm
incsrc timer.asm
incsrc doorframefixes.asm
incsrc music.asm
incsrc roomloading.asm
incsrc icepalacegraphics.asm
warnpc $A18000

org $1C8000 ; text tables for translation
incbin i18n_en.bin
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

org $A1FF00 ; static mapping area
incsrc init.asm

org $A48000 ; code bank - PUT NEW CODE HERE
incsrc glitched.asm
incsrc hardmode.asm
incsrc goalitem.asm
incsrc openmode.asm
incsrc quickswap.asm
incsrc endingsequence.asm
incsrc cuccostorm.asm
incsrc compression.asm
incsrc retro.asm
incsrc dpadinvert.asm
incsrc boots.asm
incsrc fileselect.asm
incsrc playername.asm
incsrc decryption.asm
incsrc hashalphabet.asm
incsrc inverted.asm
incsrc invertedmaps.asm
incsrc newhud.asm
incsrc compasses.asm
incsrc password.asm
incsrc enemy_adjustments.asm
warnpc $A58000

;org $228000 ; contrib area
org $A28000 ; contrib area
incsrc contrib.asm

org $A38000
incsrc stats/main.asm

org $308000 ; bank #$30
incsrc tables.asm

;incsrc sandbox.asm

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
;incbin eventitems.gfx ; *EVENT*
warnpc $31B000

org $31B000
GFX_HUD_Main:
incbin c2e3e.gfx
warnpc $31B800

org $31C000
IcePalaceFloorGfx:
incbin ice_palace_floor.bin
warnpc $31C801

org $31C800
Damage_Table:
incbin damage_table.bin
warnpc $31D001

org $31D000
FileSelectNewGraphics:
incbin fileselect.chr.gfx
warnpc $31E001

org $31E000
InvertedCastleHole: ;address used by front end. DO NOT MOVE!
incbin sheet73.gfx
warnpc $31E501

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
;$22 Contrib Code
;$23 Stats & Credits
;$24 Code Bank
;$29 External hooks (rest of bank not used)
;$2E Reserved for Tournament Use
;$2F Static RNG (rest is reserved for tournament use)
;$30 Main Configuration Table
;$31 Graphics Bank
;$32 Text Bank
;$33 Graphics Bank
;$37 Don't Use ZSNES Graphics
;$38 Don't Use ZSNES Graphics (continued)
;$3A reserved for downstream use
;$3B reserved for downstream use
;$3F reserved for internal debugging
;$7F5700 - $7F57FF reserved for downstream use
;================================================================================
;SRAM Map
;$70:0000 ( 4K) Game state
;$70:1000 (20K) Log entries
;$70:6000 ( 8K) Scratch buffers
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
org $008781
UseImplicitRegIndexedLocalJumpTable:

org $00879c
UseImplicitRegIndexedLongJumpTable:

org $008333
Vram_EraseTilemaps_triforce:

org $00893D
EnableForceBlank:

org $00D308
DecompSwordGfx:

org $00D348
DecompShieldGfx:

org $00D463
Tagalong_LoadGfx:

org $00D51B
GetAnimatedSpriteTile:

org $00D52D
GetAnimatedSpriteTile_variable:

org $00D84E
Attract_DecompressStoryGfx:

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

org $02FD8A ; 17D8A - Bank07.asm: 3732 Note: Different bank
LoadGearPalettes_bunny:

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

org $05E1F0
Sprite_ShowMessageFromPlayerContact:

org $05E219
Sprite_ShowMessageUnconditional:

org $05EC96
Sprite_ZeldaLong:

org $0683E6
Utility_CheckIfHitBoxesOverlapLong:

org $06A7DB
Chicken_SpawnAvengerChicken: ; returns short

org $06DC5C
Sprite_DrawShadowLong:

org $06DD40
DashKey_Draw:

org $06DBF8
Sprite_PrepAndDrawSingleLargeLong:

org $06DC00
Sprite_PrepAndDrawSingleSmallLong:

org $06EA18
Sprite_ApplySpeedTowardsPlayerLong:

org $06EAA6
Sprite_DirectionToFacePlayerLong:

org $06F12F
Sprite_CheckDamageToPlayerSameLayerLong:

org $06F86A
OAM_AllocateDeferToPlayerLong:

org $0791B3
Player_HaltDashAttackLong:

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

org $098CFD
AddWeathervaneExplosion:

org $0993DF
AddDashTremor:

org $099D04
AddAncillaLong:

org $09AE64
Sprite_SetSpawnedCoords:

org $09AD58
GiveRupeeGift:

org $0ABA4F
OverworldMap_InitGfx:

org $0ABA99
OverworldMap_DarkWorldTilemap:

org $0ABAB9
OverworldMap_LoadSprGfx:

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

org $0DBB6E
Sound_SetSfx1PanLong:

org $0DBB7C
Sound_SetSfx2PanLong:

org $0DBB8A
Sound_SetSfx3PanLong:

org $0DDB7F
HUD_RefreshIconLong:

org $0DDD32
Equipment_UpdateEquippedItemLong:

org $0DE01E ; 6E10E - equipment.asm : 787
BottleMenu_movingOn:

org $0DE346
RestoreNormalMenu:

org $0DE395
Equipment_SearchForEquippedItemLong:

org $0DE9C8
DrawProgressIcons: ; this returns short

org $0DED29
DrawEquipment: ; this returns short

org $0DFA78
HUD_RebuildLong:

org $0DFA88
HUD_RebuildIndoor_Palace:

org $0DFA88
HUD_RebuildLong2:

org $0EEE10
Messaging_Text:

org $0FFD94
Overworld_TileAttr:

org $1BC97C:
Overworld_DrawPersistentMap16:

org $1BED03
Palette_Sword:

org $1BED29
Palette_Shield:

org $1BEDF9
Palette_ArmorAndGloves:

org $1BEE52
Palette_Hud:

org $1BEF96
Palette_SelectScreen:

org $1CFAAA
ShopKeeper_RapidTerminateReceiveItem:

org $1CF500
Sprite_NullifyHookshotDrag:

org $1CF537
Ancilla_CheckForAvailableSlot:

org $1DE9B6
Filter_MajorWhitenMain:

org $1DF65D
Sprite_SpawnDynamically:

org $1DF65F
Sprite_SpawnDynamically_arbitrary:

org $1DFD4B
DiggingGameGuy_AttemptPrizeSpawn:

org $1EDE28
Sprite_GetEmptyBottleIndex: ; this is totally in sprite_bees.asm

org $1EF4E7
Sprite_PlayerCantPassThrough:
;================================================================================
