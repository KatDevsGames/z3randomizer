org $008781
UseImplicitRegIndexedLocalJumpTable:

org $00879c
UseImplicitRegIndexedLongJumpTable:

org $008333
Vram_EraseTilemaps_triforce:

org $008913
Sound_LoadLightWorldSongBank:
org $00891D
    .do_load

org $00893D
EnableForceBlank:

DungeonMask = $0098C0

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

org $02821E
Module_PreDungeon:
org $028296
    .setAmbientSfx

org $02A0A8
Dungeon_SaveRoomData:

org $02A0BE
Dungeon_SaveRoomData_justKeys:

org $02B861
Dungeon_SaveRoomQuadrantData:

org $02FD8A ; 17D8A - Bank0E.asm: 3732 Note: Different bank
LoadGearPalettes_bunny:

org $02FD95 ; 17D95 - Bank0E.asm: 3742 Note: Different bank
LoadGearPalettes_variable:

org $02FEAB
Filter_Majorly_Whiten_Color:

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

org $05F0C0
Sprite_EB_HeartPiece_handle_flags:

org $0680FA
Player_ApplyRumbleToSprites:

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

org $08CE93
Ancilla_BreakTowerSeal_draw_single_crystal:

org $08CEC3
Ancilla_BreakTowerSeal_stop_spawning_sparkles:

org $08CF59
BreakTowerSeal_ExecuteSparkles:

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

org $099D1A
Ancilla_CheckIfAlreadyExistsLong:

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

org $0CD7D1
NameFile_MakeScreenVisible:
org $0CDB3E
InitializeSaveFile:
org $0CDBC0
InitializeSaveFile_build_checksum:

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

org $1BC97C
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
