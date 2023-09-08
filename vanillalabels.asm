;===================================================================================================
; Vanilla Labels
;===================================================================================================
; EVERY LABEL SHOULD BE IN A FAST ROM BANK
;===================================================================================================
; Labels for routines in the vanilla portion of the ROM. More or less in sequential
; order. Most of these names came from the MoN US disassembly. But we should
; refer to the JP 1.0 disassembly as that's what the randomizer is based on.
;===================================================================================================
;---------------------------------------------------------------------------------------------------
;===================================================================================================
; Long routines (use JSL)
;===================================================================================================
Vram_EraseTilemaps_triforce                                = $808333
JumpTableLocal                                             = $808781
JumpTableLong                                              = $80879C
Sound_LoadLightWorldSongBank                               = $808913
Sound_LoadLightWorldSongBank_do_load                       = $80891D
EnableForceBlank                                           = $80893D
DungeonMask                                                = $8098C0
DecompSwordGfx                                             = $80D308
DecompShieldGfx                                            = $80D348
Tagalong_LoadGfx                                           = $80D463
GetAnimatedSpriteTile                                      = $80D51B
GetAnimatedSpriteTile_variable                             = $80D52D
Attract_DecompressStoryGfx                                 = $80D84E
InitializeTilesets                                         = $80E1DB
LoadSelectScreenGfx                                        = $80E529
CopyFontToVRAM                                             = $80E596
PrepDungeonExit                                            = $80F945
Mirror_InitHdmaSettings                                    = $80FDEE
Dungeon_LoadRoom                                           = $81873A
Underworld_HandleRoomTags                                  = $81C2FD
Module_PreDungeon                                          = $82821E
Module_PreDungeon_setAmbientSfx                            = $828296
Dungeon_SaveRoomData                                       = $82A0A8
Dungeon_SaveRoomData_justKeys                              = $82A0BE
Dungeon_SaveRoomQuadrantData                               = $82B861
LoadGearPalettes_bunny                                     = $82FD8A
LoadGearPalettes_variable                                  = $82FD95
Filter_Majorly_Whiten_Color                                = $82FEAB
MasterSword_InPedestal                                     = $858908
MasterSword_InPedestal_exit                                = $85894C
Ancilla_SpawnFallingPrize                                  = $85A51D
Sprite_DrawMultiple                                        = $85DF6C
Sprite_DrawMultiple_quantity_preset                        = $85DF70
Sprite_DrawMultiple_player_deferred                        = $85DF75
Sprite_ShowSolicitedMessageIfPlayerFacing                  = $85E1A7
Sprite_ShowMessageFromPlayerContact                        = $85E1F0
Sprite_ShowMessageUnconditional                            = $85E219
Sprite_ZeldaLong                                           = $85EC96
Sprite_EA_HeartContainer                                   = $85EF3F
Sprite_EB_HeartPiece_handle_flags                          = $85F0C0
Player_ApplyRumbleToSprites                                = $8680FA
Sprite_Main                                                = $868328
Utility_CheckIfHitBoxesOverlapLong                         = $8683E6
Sprite_PrepAndDrawSingleLargeLong                          = $86DBF8
Sprite_PrepAndDrawSingleSmallLong                          = $86DC00
Sprite_DrawShadowLong                                      = $86DC5C
DashKey_Draw                                               = $86DD40
Sprite_ApplySpeedTowardsPlayerLong                         = $86EA18
Sprite_DirectionToFacePlayerLong                           = $86EAA6
Sprite_CheckDamageToPlayerSameLayerLong                    = $86F12F
OAM_AllocateDeferToPlayerLong                              = $86F86A
Player_HaltDashAttackLong                                  = $8791B3
Link_ReceiveItem                                           = $87999D
Sprite_CheckIfPlayerPreoccupied                            = $87F4AA
Sprite_AttemptDamageToPlayerPlusRecoilLong                 = $86F425
Ancilla_Main                                               = $888242
Ancilla_ReceiveItem                                        = $88C3AE
Ancilla_BreakTowerSeal_draw_single_crystal                 = $88CE93
Ancilla_BreakTowerSeal_stop_spawning_sparkles              = $88CEC3
BreakTowerSeal_ExecuteSparkles                             = $88CF59
Ancilla_SetOam_XY_Long                                     = $88F710
AddReceivedItem                                            = $8985E2
AncillaAdd_ItemReceipt_not_crystal                         = $898605
AncillaAdd_FallingPrize                                    = $898BAD
AncillaAdd_FallingPrize_not_medallion                      = $898BD6
AddWeathervaneExplosion                                    = $898CFD
AddDashTremor                                              = $8993DF
AddAncillaLong                                             = $899D04
Ancilla_CheckIfAlreadyExistsLong                           = $899D1A
GiveRupeeGift                                              = $89AD58
Sprite_SetSpawnedCoords                                    = $89AE64
OverworldMap_InitGfx                                       = $8ABA4F
OverworldMap_DarkWorldTilemap                              = $8ABA99
OverworldMap_LoadSprGfx                                    = $8ABAB9
NameFile_MakeScreenVisible                                 = $8CD7D1
InitializeSaveFile                                         = $8CDB3E
InitializeSaveFile_build_checksum                          = $8CDBC0
InitializeSaveFile_checksum_done                           = $8CDBDB
GetRandomInt                                               = $8DBA71
OAM_AllocateFromRegionA                                    = $8DBA80
OAM_AllocateFromRegionB                                    = $8DBA84
OAM_AllocateFromRegionC                                    = $8DBA88
OAM_AllocateFromRegionD                                    = $8DBA8C
OAM_AllocateFromRegionE                                    = $8DBA90
OAM_AllocateFromRegionF                                    = $8DBA94
Sound_SetSfxPanWithPlayerCoords                            = $8DBB67
Sound_SetSfx1PanLong                                       = $8DBB6E
Sound_SetSfx2PanLong                                       = $8DBB7C
Sound_SetSfx3PanLong                                       = $8DBB8A
HUD_RefreshIconLong                                        = $8DDB7F
Equipment_UpdateEquippedItemLong                           = $8DDD32
BottleMenu_movingOn                                        = $8DE01E
RestoreNormalMenu                                          = $8DE346
Equipment_SearchForEquippedItemLong                        = $8DE395
HUD_RebuildLong                                            = $8DFA78
HUD_RebuildIndoor_Palace                                   = $8DFA88
HUD_RebuildLong2                                           = $8DFA88
Messaging_Text                                             = $8EEE10
AfterDeathCounterOutput                                    = $8E8FD
Overworld_TileAttr                                         = $8FFD94
Overworld_DrawPersistentMap16                              = $9BC97C
Palette_Sword                                              = $9BED03
Palette_Shield                                             = $9BED29
Palette_ArmorAndGloves                                     = $9BEDF9
Palette_Hud                                                = $9BEE52
Palette_SelectScreen                                       = $9BEF96
Sprite_NullifyHookshotDrag                                 = $9CF500
Ancilla_CheckForAvailableSlot                              = $9CF537
ShopKeeper_RapidTerminateReceiveItem                       = $9CFAAA
Filter_MajorWhitenMain                                     = $9DE9B6
Sprite_SpawnDynamically                                    = $9DF65D
Sprite_SpawnDynamically_arbitrary                          = $9DF65F
DiggingGameGuy_AttemptPrizeSpawn                           = $9DFD4B
Sprite_GetEmptyBottleIndex                                 = $9EDE28
CrystalCutscene_Initialize_skip_palette                    = $9ECD39
Sprite_PlayerCantPassThrough                               = $9EF4E7

;===================================================================================================
; Local routines (use JSR)
;===================================================================================================
LoadBackgroundGraphics                                     = $80E649
LoadBackgroundGraphics_arbitrary                           = $80E64D
RoomTag_PrizeTriggerDoor_open                              = $81C529
RoomTag_PrizeTriggerDoor_exit                              = $81C529
RoomTag_GetHeartForPrize                                   = $81C709
RoomTag_GetHeartForPrize_spawn_prize                       = $81C731
RoomTag_GetHeartForPrize_delete_tag                        = $81C749
Chicken_SpawnAvengerChicken                                = $86A7DB
Link_PerformOpenChest_no_replacement                       = $87B59F
Sprite_EA_HeartContainer_main                              = $85EF47
Ancilla_ExecuteAll                                         = $88832B
Ancilla_ExecuteOne                                         = $88833C
Ancilla22_ItemReceipt_is_pendant                           = $88C421
Ancilla22_ItemReceipt_wait_for_music                       = $88C42B
ItemReceipt_Animate_continue                               = $88C637
AncillaDraw_ItemReceipt                                    = $88C6B4
Ancilla29_MilestoneItemReceipt                             = $88CAB0
Ancilla29_MilestoneItemReceipt_skip_crystal_sfx            = $88CAE5
Ancilla29_MilestoneItemReceipt_no_sparkle                  = $88CB2E
Ancilla_SetOAM_XY                                          = $88F6F3
Ancilla_AddAncilla                                         = $899CCE
UpdateHUD                                                  = $8DDFA9
UpdateEquippedItem                                         = $8DDFAF
DrawProgressIcons                                          = $8DE9C8
ItemMenu_DrawEquippedYItem                                 = $8DEB3A
ItemMenu_DrawEquippedYItem_exit                            = $8DECE6
ItemMenu_DrawEquipment_dungeonitems                        = $8DEDCC
DrawEquipment                                              = $8DED29
DrawEquipment_in_a_dungeon                                 = $8DEDFE
RebuildHUD                                                 = $8DFA90
RebuildHUD_update                                          = $8DFAA5
UpdateHUDBuffer_update_item_check_arrows                   = $8DFB41
RenderText_DecompressAndDrawSingle                         = $8EF4FB
DecompressFontGFX                                          = $8EF572
CopyDecompressedCharToTransferBuffer                       = $8EF5BC
CopyDecompressedToFullBuffer                               = $8EF6A8
Trinexx_FinalPhase                                         = $9DADB5
Trinexx_PreFinalPhase                                      = $9DB0D2

;===================================================================================================
; Palettes
;===================================================================================================
PalettesVanillaBank                                        = $9B0000
PalettesVanilla_none                                       = $9B0000
PalettesVanilla_red_melon                                  = $9BD218
PalettesVanilla_blue_ice                                   = $9BD236
PalettesVanilla_green_blue_guard                           = $9BD272
PalettesVanilla_dark_world_melon                           = $9BD290
PalettesVanilla_blue_dark_ice                              = $9BD2BC
PalettesVanilla_spraux09                                   = $9BD47E

;===================================================================================================
; Misc. Data
;===================================================================================================
WorldMapIcon_AdjustCoordinate                              = $8AC59B
WorldMap_CalculateOAMCoordinates                           = $8AC3B1
WorldMap_HandleSpriteBlink                                 = $8AC52E
WorldMap_RedXChars                                         = $8ABF70
TextCharMasks                                              = $8EB844
