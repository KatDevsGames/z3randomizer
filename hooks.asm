;================================================================================
; Init Hook
;--------------------------------------------------------------------------------
org $00802F ; <- 2F - Bank00.asm : 45
JSL.l Init_Primary
NOP
;--------------------------------------------------------------------------------

;================================================================================
; Frame Hook
;--------------------------------------------------------------------------------
org $008056 ; <- 56 - Bank00.asm : 77
JSL.l FrameHookAction
;--------------------------------------------------------------------------------

;================================================================================
; NMI Hook
;--------------------------------------------------------------------------------
org $0080CC ; <- CC - Bank00.asm : 164 (PHA : PHX : PHY : PHD : PHB)
JML.l NMIHookAction
org $0080D0 ; <- D0 - Bank00.asm : 164 (PHA : PHX : PHY : PHD : PHB)
NMIHookReturn:
;--------------------------------------------------------------------------------
;org $00821B ; <- 21B - Bank00.asm : 329 (LDA $13 : STA $2100)
;JML.l PostNMIHookAction : NOP
;PostNMIHookReturn:
;--------------------------------------------------------------------------------

;================================================================================
; Anti-ZSNES Hook
;--------------------------------------------------------------------------------
org $008023 ;<- 23 - Bank00.asm : 36 (LDA.w #$01FF : TCS)
JML.l CheckZSNES
ReturnCheckZSNES:
;--------------------------------------------------------------------------------

;================================================================================
; Dungeon Entrance Hook (works, but not needed at the moment)
;--------------------------------------------------------------------------------
;org $02D8C7 ; <- 158C7 - Bank02.asm : 10981 (STA $7EC172)
;JSL.l OnDungeonEntrance
;--------------------------------------------------------------------------------

;================================================================================
; D-Pad Invert
;--------------------------------------------------------------------------------
;org $0083D9 ; <- 3D9 - Bank00.asm : 611 (LDA $4219 : STA $01)
;JSL.l InvertDPad : NOP
org $0083D4 ; <- 3D4 - Bank00.asm : 610 (LDA $4218 : STA $00)
JML.l InvertDPad : SKIP 6
InvertDPadReturn:
;--------------------------------------------------------------------------------

;================================================================================
; Enable/Disable Boots
;--------------------------------------------------------------------------------
org $079C22 ; <- 39222 - Bank07.asm : 4494 (AND $7EF379 : BEQ .cantDoAction)
JSL.l ModifyBoots
;--------------------------------------------------------------------------------

;================================================================================
; Dungeon Exit Hook
;--------------------------------------------------------------------------------
org $02E21B ; <- 1621B - Bank02.asm : 11211 (STA $040C)
JSL.l OnDungeonExit : NOP #2
;--------------------------------------------------------------------------------

;================================================================================
; Quit Hook (for both types of save and quit)
;--------------------------------------------------------------------------------
org $09F60B ; <- 4F60B - module_death.asm : 530 (LDA.b #$10 : STA $1C)
JSL.l OnQuit
;--------------------------------------------------------------------------------

;================================================================================
; Title Screen
;--------------------------------------------------------------------------------
org $0CCDA5 ; <- Bank0C.asm : 1650 (JSL Palette_SelectScreen)
JSL.l SetFileSelectPalette
;--------------------------------------------------------------------------------
org $0CCE41 ; <- 64E41 - Bank0C.asm : 1907 (DEC $C8 : BPL .done)
JSL FSCursorUp : NOP #4 ; set cursor to only select first file and erase
org $0CCE50 ; <- 64E50 - Bank0C.asm : 1918 (INC $C8)
JSL FSCursorDown : NOP #6 ; set cursor to only select first file and erase
org $0CCE0F ; < 64E0F - Bank0C.asm : 1880 (LDX $00 : INX #2 : CPX.w #$0006 : BCC .nextFile)
NOP #9 ; don't draw the other two save files
;--------------------------------------------------------------------------------
org $0CCE71 ; <- Bank0C.asm : 1941 (LDA.b #$F1 : STA $012C)
JML.l FSSelectFile : NOP
FSSelectFile_continue:
org $0CCEB1 ; <- Bank0C.asm : 2001 (.return)
FSSelectFile_return:
;--------------------------------------------------------------------------------
; Replace copy file module with a fully custom module
org $008061+$02 ; <- Bank00.asm : 103 (dl Module_CopyFile)
db Module_Password
org $00807D+$02 ; <- Bank00.asm : 103 (dl Module_CopyFile)
db Module_Password>>8
org $008099+$02 ; <- Bank00.asm : 103 (dl Module_CopyFile)
db Module_Password>>16

; Hook up password screen tilemap
org $00937a+$07
db Password_Tilemap
org $009383+$07
db Password_Tilemap>>8
org $00938c+$07
db Password_Tilemap>>16
;--------------------------------------------------------------------------------
org $0CD527 ; <- 65527 : Bank0C.asm : 2913 (LDA.w #$0004 : STA $02) [LDA.w #$0006 : STA $02]
JSL.l DrawPlayerFile : NOP ; hijack hearts draw routine to draw a full inventory

org $0ccdd5 ; Bank0C.asm:1881 (LDX.w #$00FD)
JSL.l AltBufferTable : NOP #8 ; Selection screen
org $0cd393 ; Bank0c.asm:2674 (LDX.w #$00FD)
JSL.l AltBufferTable : NOP #8 ; Delete screen
;--------------------------------------------------------------------------------
org $0CCCCC ;<- 64CCC - Bank0C.asm : 1628 (JSL Intro_ValidateSram) / Bank02.asm : 75 (REP #$30)
; Explanation: In JP 1.0 the code for Intro_ValidateSram was inline in Bank 0C
JML.l Validate_SRAM ;(Return via RTL. Original code JML'd to Intro_LoadSpriteStats which returns with RTL, but we want to skip that)
org $0CCD57 ;<- 64D57 - Bank0C.asm :
RTL ;Just in case anybody ever removes the previous hook
;--------------------------------------------------------------------------------
org $00E55D ; <- 0655D - Bank00.asm : 5473 (LDA.w #$7000 : STA $2116)
LDA.w #$2000 ; Load file select screen graphics to VRAM word addres 0x2000 instead of 0x7000
;--------------------------------------------------------------------------------
org $00833A ; <- 0033A - Bank00.asm : 481 (LDA.w #$007F)
LDA.w #$0180 ; change which character is used as the blank character for the select screen
;--------------------------------------------------------------------------------
org $0CD50C ; <- 6550C  (Not in disassembly, would be in bank0c.asm if it were) Position table for Name and Hearts
;dw $0012, $0112, $0212 ; vanilla-ish positions of file names
;dw $0026, $0126, $0226 ; vanilla-ish positions of hearts names
dw $00CC, $014A, $01CA ; repositioned, only the first value matters
dw $002A, $0192, $0112
org $0CD53B ; <- 6553B : Bank0c.asm : 2919 (ADD.w #$0010 : STA $102C, Y) [... : STA $1034, Y]
STA.w $1042, Y ; Make 2nd half of names line up properly
org $0CD540 ; <- 65540 : Bank0c.asm : 2923 (INY #2) [INY #4]
NOP #2 ; Remove space between name characters
org $0CD571 ; <- 65571 : Bank0c.asm : 2943 (LDA $04 : ADD.w #$002A : TAY) [... : ADD.w #$0032 : ...]
ADC.w #$0040 ;make Hearts line up properly
;--------------------------------------------------------------------------------
org $0CCC67 ; <- (Not in disassembly, would be in bank0c.asm if it were) Y position table for File select fairy
db $42, $00, $00, $AF, $C7
org $0CD308 ; <- (Not in disassembly, would be in bank0c.asm if it were) Y position table for File Delete fairy
db $42, $00, $00, $C7
org $0CD57E ; <- Y position table for File select link sprite
db $3d
org $0CD6BD ; <- Y position table for Death Counts
db $51
;--------------------------------------------------------------------------------

;================================================================================
; Name Entry Screen
;--------------------------------------------------------------------------------
org $0CD7BE ; <- 657BE : Bank0C.asm : 3353 (STA $7003D9, X)
JSL.l WriteBlanksToPlayerName
org $0CDB11 ; <- 65B11 : Bank0C.asm : 3605 (LDA $00 : AND.w #$FFF0 : ASL A : ORA $02 : STA $7003D9, X)
JSL.l WriteCharacterToPlayerName
org $0CDCA9 ; <- 65CA9 : Bank0C.asm : 3853 (LDA $7003D9, X)
JSL.l ReadCharacterFromPlayerName
org $0CDC90 ; <- 65C90 : Bank0C.asm : 3847 (ORA $DD24, Y) [ORA $DC82, Y]
JSL.l GetCharacterPosition
org $0CDA79 ; <- 65A79 : Bank0C.asm : 3518 (LDA $0CDA13, X : STA $0800, Y) [LDA $0CD98f, X : ...]
LDA.l HeartCursorPositions, X
org $0CDAEB ; <- 65AEB : Bank0C.asm : 3571-3575,3581-3587 (...) [LDA $0B12 : AND #$03]
; JP here is different. Indicated line number implement the US version of the same functionality
JSL.l WrapCharacterPosition : NOP
;--------------------------------------------------------------------------------
org $0CE43A ; No assembly source. Makes name entry box wider
db $2C
org $0CE448
db $2D, $40, $1E
org $0CE45C
db $4D, $40, $1E
org $0CE462
db $6D, $40, $1E
org $0CE468
db $8D, $40, $1E
org $0CE46E
db $AD, $40, $1E
;--------------------------------------------------------------------------------
org $0CE41A ; No assembly source.
; Fix name screen background to use the not-overwritten copy of its graphics
db $09 : SKIP 5 : db $09 : SKIP 5 : db $09 : SKIP 5 : db $09 : SKIP 5 : db $09 : SKIP 5
db $09 : SKIP 5 : db $49 : SKIP 1 : db $49 : SKIP 1 : db $49 : SKIP 1 : db $49 : SKIP 1
db $c9 : SKIP 5 : db $09 : SKIP 5 : db $09 : SKIP 1 : db $09 : SKIP 1 : db $09 : SKIP 1
db $09 : SKIP 1 : db $89 : SKIP 4 : db $80, $09 : SKIP 4 : db $80, $09 : SKIP 4
db $80, $09 : SKIP 5 : db $89 : SKIP 5
db $49 : SKIP 5 : db $09 : SKIP 5 : db $09 : SKIP 5 : db $49 : SKIP 5 : db $09 : SKIP 5
db $C9 : SKIP 5 : db $89 : SKIP 5 : db $89 : SKIP 5 : db $09 : SKIP 1 : db $09 : SKIP 1
db $09 : SKIP 1 : db $09 : SKIP 1 : db $09 : SKIP 1 : db $09 : SKIP 1 : db $09 : SKIP 1
db $09 : SKIP 5 : db $09 : SKIP 1 : db $09 : SKIP 1 : db $09 : SKIP 1 : db $09 : SKIP 1
db $09 : SKIP 1 : db $09 : SKIP 1 : db $09 : SKIP 1 : db $09 : SKIP 5 : db $05
;--------------------------------------------------------------------------------

;================================================================================
; Delete file Screen
;--------------------------------------------------------------------------------
; Remove code that tries to hide non-selected player files
org $0CD435 ; <- 65435 - Bank0C.asm : 2772 (LDX.b #$64) [LDX.b #$50]
LDX.b #$44
LDA $D324, X
org $0CD446 ; <- 65446 - Bank0C.asm : 2782 (LDX $C8 : CPX.b #$02 : BEQ BRANCH_11)
db $80 ; BRA
;--------------------------------------------------------------------------------

;================================================================================
; Remove Mirrored copy of save file
;--------------------------------------------------------------------------------
; Saving to mirrored copy
org $00895D ; <- 0095D - Bank00.asm : 1286 (LDA $7EF000, X : STA $0000, Y : STA $0F00, Y)
SKIP 7 : NOP #3
SKIP 7 : NOP #3
SKIP 7 : NOP #3
SKIP 7 : NOP #3
SKIP 7 : NOP #3
;--------------------------------------------------------------------------------
; Clearing mirrored copy on file erase
org $0CD4E7 ; <- 654E7 - Bank0C.asm : 2282 (STA $700400, X : STA $700F00, X : STA $701000, X : STA $701100, X)
NOP #20
;--------------------------------------------------------------------------------

;================================================================================
; Cross World Damage fixes
;--------------------------------------------------------------------------------
org $068891 ; Sprite_Prep.asm : 378 //LDA .damage_class, Y : STA $0CD2, X
nop #$08
JSL.l NewBatInit
;--------------------------------------------------------------------------------

;================================================================================
; Damage table Relocation from WRAM
;--------------------------------------------------------------------------------
org $06EDB5 ;<- 36DBE - Bank06.asm : 4882 (LDA $7F6000, X : STA $02)
JSL.l LookupDamageLevel
;--------------------------------------------------------------------------------
!StalfosBombDamage = "$7F509D"
org $1eab5e ;<- F2B5E - sprite_stalfos_knight.asm : 135  (LDA.b #$00 : STA $7F6918)
STA.l !StalfosBombDamage
org $1eaad6 ;<- F2AB6 - sprite_stalfos_knight.asm : 32  (LDA.b #$02 : STA $7F6918)
STA.l !StalfosBombDamage
;--------------------------------------------------------------------------------

;================================================================================
; Duck Map Load Hook
;--------------------------------------------------------------------------------
org $0AB76E ; <- 5376E - Bank0A.asm : 30 (JSL OverworldMap_InitGfx)
JSL.l OnLoadDuckMap
;--------------------------------------------------------------------------------

;================================================================================
; Infinite Bombs / Arrows / Magic
;--------------------------------------------------------------------------------
org $08A17A ; <- 4217A - ancilla_arrow.asm : 42 (AND.b #$04 : BEQ .dont_spawn_sparkle)
CMP.b #$03 : db #$90 ; !BLT
org $08A40E ; <- 4240E - ancilla_arrow.asm : 331 (AND.b #$04 : BNE .use_silver_palette)
CMP.b #$03 : db #$B0 ; !BGE
;--------------------------------------------------------------------------------
org $098127 ; <- 48127 - ancilla_init.asm : 202 (LDA $7EF343 : BNE .player_has_bombs)
JSL.l LoadBombCount
org $098133 ; <- 48133 - ancilla_init.asm : 211 (STA $7EF343 : BNE .bombs_left_over)
JSL.l StoreBombCount
;--------------------------------------------------------------------------------
org $0DE4BF ; <- 6E4BF - equipment.asm : 1249 (LDA $7EF343 : AND.w #$00FF : BEQ .gotNoBombs)
JSL.l LoadBombCount16
;--------------------------------------------------------------------------------
org $0DDEB3 ; <- 6DEB3 - equipment.asm : 328 (LDA $7EF33F, X)
JSL.l IsItemAvailable
;--------------------------------------------------------------------------------

;================================================================================
; Inverted Mode
;--------------------------------------------------------------------------------
org $028413 ; <- 10413 - Bank02.asm : 853 (LDA $7EF357 : BNE .notBunny)
NOP #6
JSL.l DecideIfBunny : db #$D0 ; BNE
;--------------------------------------------------------------------------------
org $07AA44 ; <- 3AA44 - Bank07.asm : 853 (LDA $7EF357 : BNE .playerHasMoonPearl)
NOP #6
JSL.l DecideIfBunnyByScreenIndex : db #$D0 ; BNE
;--------------------------------------------------------------------------------
org $02D9B9 ; <- 159B9 - Bank02.asm : 11089  (LDA $7EF3C8)
JSL AllowStartFromSingleEntranceCave
;--------------------------------------------------------------------------------
org $028496 ; <- 15496 - Bank02.asm : 959  (LDA $7EF3C8 : PHA)
JML.l AllowStartFromExit
AllowStartFromExitReturn:
;--------------------------------------------------------------------------------
org $1bc2a7 ; <- DC2A7 - Bank1B.asm : 1143 (Overworld_CreatePyramidHole:)
JSL.l Overworld_CreatePyramidHoleModified
RTL
C9DE_LONG:
JSR $C9DE ; surprisingly same address as US
RTL
;--------------------------------------------------------------------------------
org $07ff5f ; <- 3ff5f - Bank0E.asm : 5252 (LDA.w #$0E3F : STA $23BC)
JSL.l Draw_PyramidOverlay
RTS
;--------------------------------------------------------------------------------
;Remove Electric Barrier Hook
org $06891E ; <- sprite_prep.asm : 537 (LDA $7EF280, X : PLX : AND.b #$40 : BEQ .not_dead)
JSL Electric_Barrier
;--------------------------------------------------------------------------------
org $08CDAC ; <- ancilla_break_tower_seal.asm : 117 (LDA.b #$05 : STA $04C6)
JSL GanonTowerAnimation
NOP #05
;--------------------------------------------------------------------------------
org $1AF5C1 ; <- sprite_waterfall.asm : 40 (LDA $8A : CMP.b #$43)
JSL GanonTowerInvertedCheck
;--------------------------------------------------------------------------------
org $02EC8D ; <- bank02.asm : 11981 (LDA.w #$020F : LDX $8A : CPX.w #$0033 : BNE .noRock)
JSL HardcodedRocks
NOP #19 ;23 bytes removed with the JSL
;--------------------------------------------------------------------------------
org $04E7AE ; <- bank0E.asm : 4230 (LDA $7EF287 : AND.w #$0020)
JSL.l TurtleRockPegSolved
;--------------------------------------------------------------------------------
org $1BBD05 ; <- bank1B.asm : 261 (TYA : STA $00) ; hook starts at the STA
JML.l PreventEnterOnBonk
NOP
PreventEnterOnBonk_return:
org $1BBD77 ; <- bank1B.asm : 308 (SEP #$30)
PreventEnterOnBonk_BRANCH_IX:
;--------------------------------------------------------------------------------


;================================================================================
; Hash Key Display
;--------------------------------------------------------------------------------
org $0CCDB5 ; <- 64DB5 - Bank0C.asm : 1776 (LDA.b #$06 : STA $14)
JSL.l OnPrepFileSelect
;--------------------------------------------------------------------------------

;================================================================================
; Agahnim 0bb
;--------------------------------------------------------------------------------
;org $1ED6EF ; <- F56EF - sprite_agahnim.asm : 636 (JSL GetRandomInt : AND.b #$01 : BNE BRANCH_GAMMA)
;NOP #18
;--------------------------------------------------------------------------------

;================================================================================
; Zelda Sprite Fixes
;--------------------------------------------------------------------------------
org $05EBCF ; <- 2EBCF - sprite_zelda.asm : 23 (LDA $7EF359 : CMP.b #$02 : BCS .hasMasterSword)
JSL.l SpawnZelda : NOP #2
;NOP #8
;--------------------------------------------------------------------------------
;org $06C06F ; <- 3406F - Bank06.asm : 1794 (JSL Sprite_ZeldaLong)
;JSL.l SpawnZelda
;--------------------------------------------------------------------------------

;================================================================================
; Alternate Goal
;--------------------------------------------------------------------------------
;Invincible Ganon
org $06F2C8 ; <- 372C8 - Bank06.asm : 5776 (LDA $44 : CMP.b #$80 : BEQ .no_collision)
JSL.l GoalItemGanonCheck
;--------------------------------------------------------------------------------
;Hammerable Ganon
org $06F2EA ; <- 372EA - Bank06.asm : 5791 (LDA $0E20, X : CMP.b #$D6 : BCS .no_collision)
JSL.l CheckGanonHammerDamage : NOP
;--------------------------------------------------------------------------------

;================================================================================
; Stat Hooks
;--------------------------------------------------------------------------------
org $079202 ; 39202 <- Bank07.asm : 2859 (JSL AddDashTremor)
JSL.l StatBonkCounter
;--------------------------------------------------------------------------------
org $02B797 ; <- 13797 - Bank02.asm : 8712 (LDA.b #$19 : STA $10)
JSL.l StatsFinalPrep
;--------------------------------------------------------------------------------
org $07A95B ; <- 3A95B - Bank07.asm : 6565 (JSL Dungeon_SaveRoomData)
JSL.l IncrementUWMirror
;--------------------------------------------------------------------------------
org $0288D1 ; <- 108D1 - Bank02.asm : 1690 (STZ $0646)
JSL.l IndoorSubtileTransitionCounter
NOP #2
;--------------------------------------------------------------------------------
org $07B574 ; <- 3B574 - Bank07.asm : 8519 (LDA.b #$01 : STA $02E9)
JSL.l IncrementChestCounter
NOP
;--------------------------------------------------------------------------------
;org $05FC7E ; <- 2FC7E - sprite_dash_item.asm : 118 (LDA $7EF36F : INC A : STA $7EF36F)
;JSL.l IncrementSmallKeys
;--------------------------------------------------------------------------------
;org $06D18D ; <- 3518D - sprite_absorbable.asm : 274 (LDA $7EF36F : INC A : STA $7EF36F)
org $06D192 ; <- 35192 - sprite_absorbable.asm : 274 (STA $7EF36F)
JSL.l IncrementSmallKeysNoPrimary
;--------------------------------------------------------------------------------
org $00F945 ; <- 7945 - Bank00.asm : 8557 (JSL SavePalaceDeaths)
JSL.l StatTransitionCounter ; we're not bothering to restore the instruction we wrote over
;--------------------------------------------------------------------------------
org $09F443 ; <- 4F443 - module_death.asm : 257 (STA $7EF35C, X)
JSL.l IncrementFairyRevivalCounter
;--------------------------------------------------------------------------------
org $02B6F3 ; <- 136F3 - Bank02.asm : 8600 (LDA.b #$0F : STA $10)
JSL.l DungeonExitTransition
;--------------------------------------------------------------------------------
org $1BBD6A ; <- DBD6A - Bank1B.asm : 301 (LDA.b #$0F : STA $10)
JSL.l DungeonExitTransition
;--------------------------------------------------------------------------------
org $01C3A7 ; <- C3A7 - Bank01.asm : 9733 (JSL Dungeon_SaveRoomQuadrantData)
JSL.l DungeonStairsTransition
;--------------------------------------------------------------------------------
org $0BFFAC ; <- 5FFAC - Bank0B.asm : 170 (JSL Dungeon_SaveRoomQuadrantData)
JSL.l DungeonStairsTransition
;--------------------------------------------------------------------------------
org $029A17 ; <- 11A17 - Bank02.asm : 4770 (JSL EnableForceBlank)
JSL.l DungeonHoleEntranceTransition
;--------------------------------------------------------------------------------
org $0794EB ; <- 394EB - Bank07.asm : 3325 (LDA $01C31F, X : STA $0476)
JSL.l DungeonHoleWarpTransition
;--------------------------------------------------------------------------------
org $0CC999 ; <- 64999 - Bank0C.asm : 1087 (LDA.b #$0F : STA $13)
NOP #4
;--------------------------------------------------------------------------------
org $01ED75 ; <- ED75 - Bank01.asm : 13963 (JSL Dungeon_SaveRoomQuadrantData)
JSL.l IncrementBigChestCounter
;--------------------------------------------------------------------------------

;================================================================================
; Dialog Override
;--------------------------------------------------------------------------------
;org $0EEE8D ; 0x76E8D <- vwf.asm : 152 (LDA $7F71C0, X : STA $04)
;JSL.l DialogOverride
;NOP #7
;--------------------------------------------------------------------------------
org $0EF1FF ; 0x771FF <- vwf.asm : 1212 (LDA $7F1200, X : AND.w #$007F : SUB.w #$0066 : BPL .commandByte)
JSL.l DialogOverride
org $0EF2DC ; every other LDA $7F1200, X in vwf.asm
JSL.l DialogOverride
org $0EF315
JSL.l DialogOverride
org $0EF332
JSL.l DialogOverride
org $0EF375
JSL.l DialogOverride
org $0EF394
JSL.l DialogOverride
org $0EF511
JSL.l DialogOverride
org $0EF858
JSL.l DialogOverride
org $0EFA26
JSL.l DialogOverride
org $0EFA4C
JSL.l DialogOverride
org $0EFAB4
JSL.l DialogOverride
org $0EFAC8
JSL.l DialogOverride
org $0EFAE1
JSL.l DialogOverride
org $0EFB11
JSL.l DialogOverride
;--------------------------------------------------------------------------------
org $0EFBC6 ; <- 77BC6 - vwf.asm : 2717 (LDA.b #$1C : STA $1CE9)
JSL.l ResetDialogPointer
RTS
;--------------------------------------------------------------------------------
org $0EED0B ; <- PC 0x76D0B - Bank0E.asm : 3276 (LDA $E924, Y : STA $1008, X)
JSL.l EndingSequenceTableOverride
NOP #2
;--------------------------------------------------------------------------------
org $0EED15 ; <- PC 0x76D15 - Bank0E.asm : 3282 (LDA $E924, Y : STA $1008, X)
JSL.l EndingSequenceTableOverride
NOP #2
;--------------------------------------------------------------------------------
org $0EED2A ; <- PC 0x76D2A - Bank0E.asm : 3295 (LDA $E924, Y : AND.w #$00FF)
JSL.l EndingSequenceTableLookupOverride
NOP #2
;--------------------------------------------------------------------------------

;================================================================================
; Master Sword Chest Fix
;--------------------------------------------------------------------------------
;org $0987d7 ; <- ancilla_init.asm : 1071
;NOP #4
;--------------------------------------------------------------------------------

;================================================================================
; File Select Init Event
;--------------------------------------------------------------------------------
org $0CCC89 ; <- 0x64C89 Bank0C.asm : 1598 (JSL EnableForceBlank)
JSL.l OnInitFileSelect
;--------------------------------------------------------------------------------

;================================================================================
; Hyrule Castle Rain Sequence Guards (allowing Gloves in Link's house)
;--------------------------------------------------------------------------------
org $09C8B7 ; <- 4C8B7
dw #CastleRainSpriteData
org $09F7BD ; <- 4F7BD
CastleRainSpriteData:
db $06, $1F, $40, $12, $01, $3F, $14, $01, $3F, $13, $1F, $42, $1A, $1F, $4B, $1A, $20, $4B, $25, $2D, $3F, $29, $20, $3F, $2A, $3C, $3F, $FF
;--------------------------------------------------------------------------------

;================================================================================
; Sprite_DrawMultiple
;--------------------------------------------------------------------------------
org $05DFB1 ; <- 2DFB1 - Bank05.asm : 2499
JSL.l SkipDrawEOR
;--------------------------------------------------------------------------------

;================================================================================
; Kiki Big Bomb Fix
;--------------------------------------------------------------------------------
org $1EE4AF ; <- f64af sprite_kiki.asm : 285 (LDA.b #$0A : STA $7EF3CC)
JSL.l AssignKiki
NOP #2
;--------------------------------------------------------------------------------

;================================================================================
; Hard & Masochist Mode Fixes
;--------------------------------------------------------------------------------
org $07D22B ; <- 3D22B - Bank05.asm : 12752 (LDA $D055, Y : STA $0373)
JSL.l CalculateSpikeFloorDamage : NOP #2
;--------------------------------------------------------------------------------
org $08DCC3 ; <- 45CC3 - ancilla_cane_spark.asm : 272 (LDA $7EF36E)
JSL.l CalculateByrnaUsage
;--------------------------------------------------------------------------------
org $07AE17 ; <- 3AE17 - Bank07.asm : 7285 (LDA $7EF36E)
JSL.l CalculateCapeUsage
;--------------------------------------------------------------------------------
org $07AE98 ; <- 3AE98 - Bank07.asm : 7380 (LDA $7EF36E)
JSL.l CalculateCapeUsage
;--------------------------------------------------------------------------------
org $08DCA7 ; <- 45CA7 - ancilla_cane_spark.asm : 256 (LDA.b #$01 : STA $037B)
JSL.l ActivateInvulnerabilityOrDont : NOP
;--------------------------------------------------------------------------------
ORG $06EDC6 ;  <- 36DC6 - Bank06.asm : 4890 (LDA $0DB8F1, X)
JSL.l GetItemDamageValue
;--------------------------------------------------------------------------------

;================================================================================
; Misc Stats
;--------------------------------------------------------------------------------
org $029E2E ; <- 11E2E - module_ganon_emerges.asm : 59 (JSL Dungeon_SaveRoomData.justKeys)
JSL.l OnAga2Defeated
;--------------------------------------------------------------------------------
org $0DDBDE ; <- 6DBDE - headsup_display.asm : 105 (DEC A : BPL .subtractRupees)
JSL.l IncrementSpentRupees
NOP #6
;org $0DDBF7 ; <- 6DBF7 - headsup_display.asm : 121 (STA $7EF362)
;RefillLogic_subtractRupees:
;--------------------------------------------------------------------------------

;================================================================================
; Remove Item Menu Text
;--------------------------------------------------------------------------------
org $0DEBB0 ; <- 6EBB0 - equipment.asm : 1810 (LDA $0202)
JMP DrawItem_finished
org $0DECE6 ; <- 6ECE6 - equipment.asm : 1934 (SEP #$30)
DrawItem_finished:
org $0DEB48 ; <- 6EB48 - equipment.asm : 1784 (LDA $0000)
LDA $0000, Y : STA $11F2
LDA $0002, Y : STA $11F4
LDA $0040, Y : STA $1232
LDA $0042, Y : STA $1234
;---------------------------
org $0DE24B ; <- 6E24B - equipment.asm : 951 (LDA $0000)
LDA $0000, Y : STA $11F2
LDA $0002, Y : STA $11F4
LDA $0040, Y : STA $1232
LDA $0042, Y : STA $1234
;--------------------------------------------------------------------------------
org $0DE2DC ; <- 6E2DC - equipment.asm : 989 (LDA $F449, X : STA $122C, Y)
JMP UpdateBottleMenu_return
org $0DE2F1 ; <- 6E2F1 - equipment.asm : 1000 (SEP #$30)
UpdateBottleMenu_return:
;--------------------------------------------------------------------------------
;org $0DDDC3 ; <- 6DDC3 - equipment.asm : 131 (JSR DrawAbilityText)
;NOP #3
org $0DE6F4 ; <- 6E6F4 - equipment.asm : 1474 (BCC .lacksAbility)
db #$80 ; BRA
org $0DE81A ; <- 6E81A - equipment.asm : 1597 (STA $00)
RTS
org $0DE7B9 ; <- 6E7B9 - equipment.asm : 1548 (LDA.w #$16D0 : STA $00)
JSL.l DrawGlovesInMenuLocation : NOP
org $0DE7CF ; <- 6E7CF - equipment.asm : 1554 (LDA.w #$16C8 : STA $00)
JSL.l DrawBootsInMenuLocation : NOP
org $0DE7E5 ; <- 6E7E5 - equipment.asm : 1560 (LDA.w #$16D8 : STA $00)
JSL.l DrawFlippersInMenuLocation : NOP
org $0DECEB ; <- 6ECEB - equipment.asm : 1946 (LDA.w #$16E0 : STA $00)
JSL.l DrawMoonPearlInMenuLocation : NOP
;--------------------------------------------------------------------------------
;org $0DE9D8 ; <- 6E9D8 - equipment.asm : 1635 (LDA $E860, X : STA $12EA, X)
;BRA DrawProgressIcons_initPendantDiagram_notext
;org $0DEA0E ; <- 6EA0E - equipment.asm : 1645 (INX #2)
;DrawProgressIcons_initPendantDiagram_notext:
;--------------------------------------------------------------------------------

;================================================================================
; Map Always Zoomed
;--------------------------------------------------------------------------------
;org $0ABA49 ; <- 53A49 - Bank0A.asm : 447 (LDA.b #$80 : STA $211A)
;JSL.l PrepMapZoom : RTL
;org $0ABB32 ; <- 53B32 - Bank0A.asm : 626 (LDA $F6 : AND.b #$70)
;JSL.l ForceMapZoom
;--------------------------------------------------------------------------------

;================================================================================
; Zelda S&Q Mirror Fix
;--------------------------------------------------------------------------------
org $02D9A4 ; <- 159A4 - Bank02.asm : 11077 (dw $0000, $0002, $0002, $0032, $0004, $0006, $0030)
dw $0000, $0002, $0004, $0032, $0004, $0006, $0030
;--------------------------------------------------------------------------------

;================================================================================
; Accessability
;--------------------------------------------------------------------------------
;org $0AC574 ; <- 54574 - Bank0A.asm : 1797 (LDA $0D : STA $0802, X)
;JSL FlipGreenPendant
;NOP #6
;--------------------------------------------------------------------------------
org $08AAE1 ; <- 42AE1 - ancilla_ether_spell.asm : 28 (LDA $031D : CMP.b #$0B)
JSL.l SetEtherFlicker : NOP
;--------------------------------------------------------------------------------
org $0CF37B ; <- 6737B - Bank0C.asm : 5055 (JSL Filter_MajorWhitenMain)
JSL.l SetAttractMaidenFlicker : NOP #2
;--------------------------------------------------------------------------------

;================================================================================
; Ice Floor Toggle
;--------------------------------------------------------------------------------
org $07D234 ; <- 3D234 - Bank07.asm : 12758 (LDA $0348 : AND.b #$11 : BEQ .notWalkingOnIce)
JSL.l LoadModifiedIceFloorValue_a11 : NOP
;--------------------------------------------------------------------------------
org $07D26E ; <- 3D26E - Bank07.asm : 12786 (LDA $0348 : AND.b #$01 : BNE BRANCH_RESH)
JSL.l LoadModifiedIceFloorValue_a01 : NOP
;--------------------------------------------------------------------------------

;================================================================================
; Sword Upgrade Randomization
;--------------------------------------------------------------------------------
org $03FC16 ; <- 1FC16 ($A8, $B8, $3D, $D0, $B8, $3D)
db $B1, $C6, $F9, $C9, $C6, $F9 ; data insert - 2 chests, fat fairy room
org $01E97E ; <- E97E ($280016, $250016)
dl $080116, $070116; <- E97E
;--------------------------------------------------------------------------------
;org $06C9BC ; <- 349BC - sprite_ponds.asm : 1066
;org $06C9C0 ; <- 349C0 - sprite_ponds.asm : 1068
;org $06C926 ; <- 34926 - sprite_ponds.asm : 945
;JML.l GetFairySword
;NOP #12
org $06C936 ; <- 34936 - sprite_ponds.asm : 952
PyramidFairy_BRANCH_IOTA:
org $06C948 ; <- 34948 - sprite_ponds.asm : 961
PyramidFairy_BRANCH_GAMMA:
;--------------------------------------------------------------------------------
;org $0EF7BD ; <- 777BD - sprite_ponds.asm : 1890 (LDA $7EF340, X : BMI .invalidValue : BNE VWF_ChangeItemTiles)
;JSL.l ReadInventoryPond
;org $0EF7E4 ; <- 777E4 - sprite_ponds.asm : 1922 (LDA $7EF340, X : BMI .invalidValue : BNE VWF_ChangeItemTiles)
;JSL.l ReadInventoryPond
;--------------------------------------------------------------------------------
org $1EE16E ; <- F616E - sprite_bomb_shop_entity.asm : 73
NOP #8 ; fix bomb shop dialog for dwarfless big bomb
org $068A14 ; <- 30A14 - sprite_prep.asm : 716
NOP #8 ; fix bomb shop spawn for dwarfless big bomb
;--------------------------------------------------------------------------------
org $06B489 ; <- 33489 - sprite_smithy_bros.asm : 473 (LDA $7EF359 : CMP.b #$03 : BCS .tempered_sword_or_better)
JML.l GetSmithSword
NOP #4
Smithy_DoesntHaveSword:
org $06B49D ; <- 3349D - sprite_smithy_bros.asm : 485 (.tempered_sword_or_better)
Smithy_AlreadyGotSword:
;--------------------------------------------------------------------------------
org $06ED55 ; <- 36D55 - Bank06.asm : 4817
JSL.l LoadSwordForDamage ; moth gold sword fix
;--------------------------------------------------------------------------------
org $08C5F7 ; <- 445F7 - ancilla_receive_item.asm : 400 (LDA.b #$09 : STA $012D)
NOP #5 ; remove spooky telepathy sound
;--------------------------------------------------------------------------------
org $08C431 ; <- 44431 - ancilla_receive_item.asm : 125 (LDA $0C5E, X : CMP.b #$01 : BNE .notMasterSword2)
JSL.l MSMusicReset : NOP
;LDA $8A : CMP.b #$80 : NOP
; $22 = $0000 - $00FF - MS Pedestal
; $22 = $0100 - $00FF - Hobo
;--------------------------------------------------------------------------------

;================================================================================
; Temporary Nerfs and Buffs
;--------------------------------------------------------------------------------
org $06F400 ; <- 37F400 - Bank06.asm : 5963 (CLC : ADC $7EF35B)
JSL.l LoadModifiedArmorLevel : NOP
;--------------------------------------------------------------------------------
org $07ADDB ; <- 3ADDB - Bank07.asm : 7251 (LDA $7EF37B : TAY)
JSL.l LoadModifiedMagicLevel
;--------------------------------------------------------------------------------
org $07AE0D ; <- 3AE0D - Bank07.asm : 7279 (LDA $7EF37B : TAY)
JSL.l LoadModifiedMagicLevel
;--------------------------------------------------------------------------------
org $07AE8E ; <- 3AE8E - Bank07.asm : 7376 (LDA $7EF37B : TAY)
JSL.l LoadModifiedMagicLevel
;--------------------------------------------------------------------------------
org $08DCB9 ; <- 45CB9 - ancilla_cane_spark.asm : 256 (LDA $7EF37B : TAY)
JSL.l LoadModifiedMagicLevel
;--------------------------------------------------------------------------------
org $07B08B
LinkItem_MagicCostBaseIndices:
;--------------------------------------------------------------------------------
org $07B096 ; <- 3B096 - Bank07.asm : 7731 (LDA LinkItem_MagicCostBaseIndices, X : CLC : ADC $7EF37B : TAX)
JSL.l LoadModifiedMagicLevel : !ADD.w LinkItem_MagicCostBaseIndices, X
;--------------------------------------------------------------------------------
org $07B0D5 ; <- 3B0D5 - Bank07.asm : 7783 (LDA LinkItem_MagicCostBaseIndices, X : CLC : ADC $7EF37B : TAX)
JSL.l LoadModifiedMagicLevel : !ADD.w LinkItem_MagicCostBaseIndices, X
;--------------------------------------------------------------------------------

;================================================================================
; New Items
;--------------------------------------------------------------------------------
org $07B57B ; <- 3B57B - Bank07.asm : 8523 (BMI .cantOpen)
NOP #2
;--------------------------------------------------------------------------------
org $00D531 ; 5531 - Bank00.asm:3451 (LDY.b #$5D)
JML.l GetAnimatedSpriteGfxFile

org $00D547 ; 5547 - Bank00.asm:3467 (JSR Decomp_spr_high)
GetAnimatedSpriteGfxFile_return:

org $00D557 ; 5557 - Bank00.asm:3486 (LDA $00 : ADC $D469, X)
JSL.l GetAnimatedSpriteBufferPointer
NOP

org $0799F7 ; 399F7 - Bank07.asm:4107 (JSL AddReceivedItem)
JSL.l AddReceivedItemExpanded

org $098611 ; 48611 - ancilla_init.asm:720 (LDA .item_target_addr+0, X)
LDA.w AddReceivedItemExpanded_item_target_addr+0, X
org $098616 ; 48616 - ancilla_init.asm:721 (LDA .item_target_addr+1, X)
LDA.w AddReceivedItemExpanded_item_target_addr+1, X
org $09861F ; 4861F - ancilla_init.asm:724 (LDA .item_values, Y)
LDA.w AddReceivedItemExpanded_item_values, Y

org $098627 ; 48627 - ancilla_init.asm:731 (LDA .item_target_addr+0, X)
LDA.w AddReceivedItemExpanded_item_target_addr+0, X
org $09862C ; 4862C - ancilla_init.asm:722 (LDA .item_target_addr+1, X)
LDA.w AddReceivedItemExpanded_item_target_addr+1, X
org $098635 ; 48635 - ancilla_init.asm:727 (LDA .item_values, Y)
LDA.w AddReceivedItemExpanded_item_values, Y

org $0986AA ; 486AA - ancilla_init.asm:848 (LDA .item_masks, X)
LDA.w AddReceivedItemExpanded_item_masks, X

org $098769 ; 48769 - ancilla_init.asm:1005 (LDA .item_graphics_indices, Y)
LDA.w AddReceivedItemExpanded_item_graphics_indices, Y

org $09884D ; 4884D - ancilla_init.asm:1137 (LDA $836C, Y)
LDA.w AddReceivedItemExpanded_y_offsets, Y
org $09885B ; 4885B - ancilla_init.asm:1139 (LDA .x_offsets, X) - I think the disassembly is wrong here, should have been LDA .x_offsets, Y
LDA.w AddReceivedItemExpanded_x_offsets, Y

org $0988B7 ; 488B7 - ancilla_init.asm:1199 (LDA .wide_item_flag, Y)
LDA.w AddReceivedItemExpanded_wide_item_flag, Y

org $0988EF ; 488EF - ancilla_init.asm:1248 (LDA $836C, Y)
LDA.w AddReceivedItemExpanded_y_offsets, Y
org $098908 ; 48908 - ancilla_init.asm:1258 (LDA .x_offsets, Y)
LDA.w AddReceivedItemExpanded_x_offsets, Y

org $08C6C8 ; 446C8 - ancilla_receive_item.asm:538 (LDA AddReceiveItem.properties, X)
LDA.l AddReceivedItemExpanded_properties, X

org $08C6DE ; 446DE - ancilla_receive_item.asm:550 (LDA .wide_item_flag, X)
LDA.l AddReceivedItemExpanded_wide_item_flag, X

org $08C6F9 ; 446F9 - ancilla_receive_item.asm:570 (LDA AddReceiveItem.properties, X)
LDA.l AddReceivedItemExpanded_properties, X

org $08C70F ; 4470F - ancilla_receive_item.asm : 582 - (LDA.b #$00 : STA ($92), Y)
JSL.l LoadNarrowObject

org $0985ED ; 485ED - ancilla_init.asm:693 (LDA $02E9 : CMP.b #$01)
JSL.l AddReceivedItemExpandedGetItem
NOP

org $07B57D ; 3B57D - Bank07.asm:8527 (LDA Link_ReceiveItemAlternates, Y : STA $03)
JSL.l Link_ReceiveItemAlternatesExpanded_loadAlternate
NOP
;--------------------------------------------------------------------------------
org $09892E ; 4892E - ancilla_init.asm:1307 (LDA BottleList, X)
LDA.w BottleListExpanded, X

org $09895C ; 4895C - ancilla_init.asm:1344 (LDA PotionList, X)
LDA.w PotionListExpanded, X
;--------------------------------------------------------------------------------
;org $098A36 ; <- 48A36 - ancilla_init.asm:1432 (LDA AddReceiveItem.item_graphics_indices, Y : STA $72)
;LDA AddReceivedItemExpanded_item_graphics_indices, Y
;--------------------------------------------------------------------------------
org $06D1EB ; 351EB - sprite_absorbable.asm:364 (STA $7EF375) ; bugbug commented out until i figure out why it doesn't work
JSL HandleBombAbsorbtion
;--------------------------------------------------------------------------------
;org $09873F ; <- 04873F - ancilla_init.asm : 960 (ADC [$00] : STA [$00] )
;JSL.l AddToStock
;--------------------------------------------------------------------------------

;================================================================================
; Kholdstare Shell Fix
;--------------------------------------------------------------------------------
org $00EC88 ; <- 6C88 - Bank00.asm:6671 - (LDA $7EC380, X : STA $7EC580, X)
LDA $7EC3A0, X : STA $7EC5A0, X
;--------------------------------------------------------------------------------
org $00ECEB ; <- 6CEB - Bank00.asm:6730 - (LDX.w #$0080)
LDX.w #$00A0
LDA.w #$00B0
;--------------------------------------------------------------------------------

;================================================================================
; Potion Refill Fixes
;--------------------------------------------------------------------------------
;org $0DF1B3 ; <- 6F1B3 - headsup_display.asm:492 - (SEP #$30)
;JSL.l RefillMagic
;RTL
;--------------------------------------------------------------------------------
;org $0DF128 ; <- 6F128 - headsup_display.asm:407 - (LDA $7EF36D : CMP $7EF36C : BCC .refillAllHealth)
;JSL.l RefillHealth
;RTL
;--------------------------------------------------------------------------------
org $00F8FB ; <- 78FB - Bank00.asm:8507 - (JSL HUD.RefillHealth : BCC BRANCH_ALPHA)
JSL.l RefillHealth
;--------------------------------------------------------------------------------
org $00F911 ; <- 7911 - Bank00.asm:8528 - (JSL HUD.RefillMagicPower : BCS BRANCH_$7901)
JSL.l RefillMagic
;--------------------------------------------------------------------------------
org $00F918 ; <- 7918 - Bank00.asm:8537 - (JSL HUD.RefillHealth : BCC .alpha)
JSL.l RefillHealth
;--------------------------------------------------------------------------------
org $00F922 ; <- 7922 - Bank00.asm:8543 - (JSL HUD.RefillMagicPower : BCC .beta)
JSL.l RefillMagic
;--------------------------------------------------------------------------------

;================================================================================
; Early Bottle Fix
;--------------------------------------------------------------------------------
org $09894C ; <- 4894C - ancilla_init.asm:1327
JSL.l InitializeBottles
;--------------------------------------------------------------------------------

;================================================================================
; Agahnim Doors Fix
;--------------------------------------------------------------------------------
org $1BBC94 ; <- DBC94 - Bank1B.asm : 201 (LDA $7EF3C5 : AND.w #$000F : CMP.w #$0003 : BCS BRANCH_EPSILON)
JSL.l LockAgahnimDoors : BNE Overworld_Entrance_BRANCH_EPSILON : NOP #6

org $1BBCC1 ; <- DBCC1 - Bank1B.asm : 223 (LDA $0F8004, X : AND.w #$01FF : STA $00)
Overworld_Entrance_BRANCH_EPSILON: ; go here to lock doors
;--------------------------------------------------------------------------------
; -- HOOK THIS LATER TO FUCK WITH BOSS DROPS --
org $01C73E ; <- C73E - Bank01.asm : 10377 (LDA $01C6FC, X : JSL Sprite_SpawnFallingItem)
JSL.l DropSafeDungeon
NOP #4
;--------------------------------------------------------------------------------

;================================================================================
; Uncle / Sage Fixes - Old Man Fixes - Link's House Fixes
;--------------------------------------------------------------------------------
org $05DA4F ; <- 2DA4F - sprite_uncle_and_priest.asm : 45 (BCC .agahnim_not_defeated)
db 80 ; BRA
;--------------------------------------------------------------------------------
org $05DA61 ; <- 2DA61 - sprite_uncle_and_priest.asm : 51 (BEQ .priest_not_already_dead)
db 80 ; BRA
;--------------------------------------------------------------------------------
org $05DA81 ; <- 2DA81 - sprite_uncle_and_priest.asm : 65 (BCC .dontHaveMasterSword)
db 80 ; BRA
;--------------------------------------------------------------------------------
;org $05DE1D ; <- 2DE1D - sprite_uncle_and_priest.asm : 725 (LDA.b #$A0 : STA $7EF372)
;JSL.l RefillHealthPlusMagic8bit
;NOP #2
;--------------------------------------------------------------------------------
org $05DEF8 ; <- 2DEF8 - sprite_uncle_and_priest.asm : 917 (LDA.b #$05)
LDA.b #$00
;--------------------------------------------------------------------------------
;org $1EEAB6 ; <- F6AB6 - sprite_old_mountain_man.asm : 338 (LDA.b #$A0 : STA $7EF372)
;JSL.l RefillHealthPlusMagic8bit
;NOP #2
;--------------------------------------------------------------------------------
;org $01E5B2 ; <- E5B8 - lower pot link's house
;db $14 ; fairy
;org $01E5B5 ; <- E5B8 - lower pot link's house
;db $14 ; fairy
;org $01E5B8 ; <- E5B8 - lower pot link's house
;db $0D ; big magic
;--------------------------------------------------------------------------------

;================================================================================
; Ganon's Tower Basement Door Fix
;--------------------------------------------------------------------------------
;org $1FF3F4 ; <- 0FF3F4
;db $00
;--------------------------------------------------------------------------------
; Misery Mire Basement Door Fix
;--------------------------------------------------------------------------------
;org $1FB8E4 ; <- 0FB8E4
;db $00
;--------------------------------------------------------------------------------
;0xFE465 -> 0x1E
org $1FE465
db #$1E
;--------------------------------------------------------------------------------

;================================================================================
; Bomb & Arrow Capacity Updates
;--------------------------------------------------------------------------------
org $0DDC27 ; <- 6DC27 - headsup_display.asm:151 (LDA $7EF370 : TAY)
JSL.l IncrementBombs
NOP #15
;--------------------------------------------------------------------------------
org $0DDC49 ; <- 6DC49 - headsup_display.asm:169 (LDA $7EF371 : TAY)
JSL.l IncrementArrows
NOP #15
;--------------------------------------------------------------------------------
org $1EE199 ; <- F6199 - sprite_bomb_shop_entity.asm:102 (LDA $7EF370 : PHX : TAX)
JSL.l CompareBombsToMax
NOP #11
;--------------------------------------------------------------------------------

;================================================================================
; Bonk Items
;--------------------------------------------------------------------------------
org $05FC7E ; <- 2FC7E - sprite_dash_item.asm : 118 (LDA $7EF36F : INC A : STA $7EF36F)
JSL.l GiveBonkItem : NOP #5
org $05FC97 ; <- 2FC97 - sprite_dash_item.asm : 126 (LDA.b #$2F : JSL Sound_SetSfx3PanLong)
NOP #6
;--------------------------------------------------------------------------------
org $068D39 ; <- 30D39 - sprite_prep.asm : 1435 - (LDA.b #$08 : STA $0F50, X)
JSL.l LoadBonkItemGFX
;--------------------------------------------------------------------------------
org $05FC04 ; <- 2FC04 - sprite_dash_item.asm : 38 - (JSL DashKey_Draw)
JSL.l DrawBonkItemGFX
;--------------------------------------------------------------------------------

;================================================================================
; Library Item
;--------------------------------------------------------------------------------
org $05FD44 ; <- 2FD44 - sprite_dash_item.asm : 244 - (JSL Link_ReceiveItem)
JSL.l SetLibraryItem
;--------------------------------------------------------------------------------
org $068D1B ; <- 30D1B - sprite_prep.asm : 1414 - (JSL GetAnimatedSpriteTile.variable)
JSL.l LoadLibraryItemGFX
;--------------------------------------------------------------------------------
org $05FC9E ; <- 2FC9E - sprite_dash_item.asm : 138 - (JSL Sprite_PrepAndDrawSingleLargeLong)
JSL.l DrawLibraryItemGFX
;--------------------------------------------------------------------------------
org $068D0E ; <- 30D0E - sprite_prep.asm : 1401 - (LDA $7EF34E : BEQ .book_of_mudora)
JSL.l ItemCheck_Library
;--------------------------------------------------------------------------------

;================================================================================
; Inventory Updates
;--------------------------------------------------------------------------------
org $0DDF38 ; <- 6DF38 - equipment.asm : 480
JSL.l ProcessMenuButtons
BCC _equipment_497
JMP.w _equipment_544
;NOP #7
ResetEquipment:
JSR.w RestoreNormalMenu ; (short)
RTL
NOP #3

warnpc $0DDF49
org $0DDF49 ; <- 6DF49 - equipment.asm : 497
_equipment_497: ; LDA $F4 : AND.b #$08 : BEQ .notPressingUp - NO BUTTON CAPTURE
;org $0DDF7E ; <- 6DF7E - equipment.asm : 539
org $0DDF88 ; <- 6DF88 - equipment.asm : 544
;org $0DE10E ; <- 6E10E - equipment.asm : 806
_equipment_544:
;--------------------------------------------------------------------------------
org $0DEB98 ; <- 6EB98 - equipment.asm : 1803
;LDA.w #$3C60 : STA $FFBE, Y
;ORA.w #$4000 : STA $FFC4, Y
;ORA.w #$8000 : STA $0084, Y
;EOR.w #$4000 : STA $007E, Y
LDA.w #$3C60 : STA $FFBE, Y
ORA.w #$8000 : STA $007E, Y
ORA.w #$4000 : STA $0084, Y
JSL.l AddYMarker
NOP #2
;--------------------------------------------------------------------------------
org $0DF789+6 ; <- 6F789+6 (not in disassembly) - red bottle hud tile, lower right
dw #$2413 ; (Orig: #$24E3)
org $0DF789+6+8  ; green bottle hud tile, lower right
dw #$3C12 ; (Orig: #$3CE3)
org $0DF789+6+16 ; blue bottle hud tile, lower right
dw #$2C14 ; (Orig: #$2CD2)
org $0DF789+6+40 ; good bee hud tile, lower right
dw #$2815 ; (Orig: #$283A)
org $0DF8A1+6 ; <- 6F8A1+6 (not in disassembly) - green mail tile, lower right
dw #$3C4B ; (Orig: #$7C78)
org $0DF8A1+6+8  ; blue mail tile tile, lower right
dw #$2C4F ; (Orig: #$6C78)
org $0DF8A1+6+16 ; red mail tile, lower right
dw #$242F ; (Orig: #$6478)
;--------------------------------------------------------------------------------
;org $0DDE9B ; <- 6DE9B equipment.asm:296 - LDA $0202 : CMP.b #$10 : BNE .notOnBottleMenu (CMP instruction)
;CMP.b #$FF
;--------------------------------------------------------------------------------
org $0DDE9F ; <- 6DE9F equipment.asm:300 - LDA.b #$0A : STA $0200
LDA.b #$04
;--------------------------------------------------------------------------------
org $0DDE59 ; <- 6DE59 equipment.asm:247 - REP #$20
JSL.l BringMenuDownEnhanced : RTS
;--------------------------------------------------------------------------------
org $0DDFBC ; <- 6DFBC equipment.asm:599 - LDA $EA : ADD.w #$0008 : STA $EA : SEP #$20 : BNE .notDoneScrolling
JSL.l RaiseHudMenu : NOP #3
;--------------------------------------------------------------------------------
org $0DDE3D ; <- 6DE3D equipment.asm:217 - BNE .equippedItemIsntBottle
db $80 ; BRA
;--------------------------------------------------------------------------------
org $0DDF9A ; <- 6DF9A - equipment.asm : 554
JSL.l OpenBottleMenu
NOP
;--------------------------------------------------------------------------------
org $0DE12D ; <- 6E12D - equipment.asm : 828
JSL.l CloseBottleMenu
;--------------------------------------------------------------------------------
org $0DDF1E ; <- 6DF1E - equipment.asm : 462 - LDA $F4 : AND.b #$10 : BEQ .dontLeaveMenu
JSL.l CheckCloseItemMenu
;--------------------------------------------------------------------------------
org $0DEE70 ; <- 6EE70 - equipment.asm : 2137
JSL.l PrepItemScreenBigKey
NOP
;--------------------------------------------------------------------------------
org $08D395 ; <- 45395 - ancilla_bird_travel_intro.asm : 253
JSL.l UpgradeFlute
NOP #2
;--------------------------------------------------------------------------------
org $05E4D7 ; <- 2E4D7 - sprite_witch.asm : 213
JSL.l RemoveMushroom
NOP #2
;--------------------------------------------------------------------------------
org $05F55F ; <- 2F55F - sprite_potion_shop.asm : 59
JSL.l LoadPowder
;--------------------------------------------------------------------------------
org $05F681 ; <- 2F681 - sprite_potion_shop.asm : 234
JSL.l DrawPowder
RTS
NOP #8
;--------------------------------------------------------------------------------
org $05F65D ; <- 2F65D - sprite_potion_shop.asm : 198
JSL.l CollectPowder
NOP #5
;--------------------------------------------------------------------------------
org $05EE5F ; <- 2EE5F - sprite_mushroom.asm : 30
JSL.l LoadMushroom
NOP
;--------------------------------------------------------------------------------
org $05EE78 ; <- 2EE78 - sprite_mushroom.asm : 58
JSL.l DrawMushroom
;--------------------------------------------------------------------------------
org $05EE97 ; <- 2EE97 - sprite_mushroom.asm : 81
NOP #14
;--------------------------------------------------------------------------------
org $07A36F ; <- 3A36F - Bank07.asm : 5679
NOP #5
org $07A379 ; <- 3A379 - Bank07.asm : 5687
JSL.l SpawnHauntedGroveItem
;--------------------------------------------------------------------------------
org $07A303 ; 3A303 - Bank07.asm : 5622
;JSL.l FixShovelLock
;--------------------------------------------------------------------------------
org $07A3A2 ; 3A3A2 - Bank07.asm : 5720 - JSL DiggingGameGuy_AttemptPrizeSpawn
JSL.l SpawnShovelItem
BRA _Bank07_5726
org $07A3AB ; 3A3AB - Bank07.asm : 5726 - LDA.b #$12 : JSR Player_DoSfx2
_Bank07_5726:
;org $07A381 ; 3A381 - Bank07.asm : 5693 - ORA $035B
;ORA $035B
;--------------------------------------------------------------------------------
org $079A0E ; 39A0E - Bank07.asm : 4117 - JSL HUD.RefreshIconLong
JSL.l Link_ReceiveItem_HUDRefresh
;--------------------------------------------------------------------------------

;================================================================================
; Swordless Mode
;--------------------------------------------------------------------------------
org $07A49F ; <- 3A49F - Bank07.asm:5903 (LDA $7EF359 : INC A : AND.b #$FE : BEQ .cant_cast_play_sound) - Ether
JSL.l CheckMedallionSword
;--------------------------------------------------------------------------------
org $07A574 ; <- 3A574 - Bank07.asm:6025 (LDA $7EF359 : INC A : AND.b #$FE : BEQ BRANCH_BETA) - Bombos
JSL.l CheckMedallionSword
;--------------------------------------------------------------------------------
org $07A656 ; <- 3A656 - Bank07.asm:6133 (LDA $7EF359 : INC A : AND.b #$FE : BEQ BRANCH_BETA) - Quake
JSL.l CheckMedallionSword
;--------------------------------------------------------------------------------
org $05F3A0 ; <- 2F3A0 - sprite_medallion_tablet.asm:240 (LDA $7EF359 : BMI .zeta)
JSL.l CheckTabletSword
;--------------------------------------------------------------------------------
org $05F40A ; <- 2F40A - sprite_medallion_tablet.asm:303 (LDA $7EF359 : BMI .show_hylian_script)
JSL.l CheckTabletSword
;--------------------------------------------------------------------------------
org $1DF086 ; <- EF086 - sprite_evil_barrier.asm:303 (LDA $7EF359 : CMP.b #$02 : BCS .anozap_from_player_attack)
JSL.l GetSwordLevelForEvilBarrier
;--------------------------------------------------------------------------------

;================================================================================
; Medallion Tablets
;--------------------------------------------------------------------------------
org $05F274 ; <- 2F274
JSL.l ItemCheck_BombosTablet
;--------------------------------------------------------------------------------
org $05F285 ; <- 2F285
JSL.l ItemCheck_EtherTablet
;--------------------------------------------------------------------------------
;org $098BCC ; <- 48BCC - ancilla_init.asm : 1679 (LDA AddReceiveItem.item_graphics_indices, Y : STA $72)
;;JSL.l SetTabletItem
;JSL SpawnTabletItem : PLX : PLB : RTL
;--------------------------------------------------------------------------------
org $07859F ; <- 3859F - Bank07.asm : 965 (JSL AddPendantOrCrystal)
JSL SpawnTabletItem
org $07862A ; <- 3862A - Bank07.asm : 1064 (JSL AddPendantOrCrystal)
JSL SpawnTabletItem
;--------------------------------------------------------------------------------

;================================================================================
; Medallion Entrances
;--------------------------------------------------------------------------------
org $08B504 ; <- 43504 - ancilla_bombos_spell.asm : 671
JSL.l MedallionTrigger_Bombos
NOP
;--------------------------------------------------------------------------------
org $08ACC8 ; <- 42CC8 - ancilla_ether_spell.asm : 350
JSL.l MedallionTrigger_Ether
JMP _ancilla_ether_spell_363
warnpc $08ACE6
org $08ACE6 ; <- 42CE6 - ancilla_quake_spell.asm : 363
_ancilla_ether_spell_363:
;--------------------------------------------------------------------------------
org $08B6EA ; <- 436EA - ancilla_quake_spell.asm : 67
JSL.l MedallionTrigger_Quake
JMP _ancilla_quake_spell_83
Ancilla_CheckIfEntranceTriggered:
	JSR $F856
RTL
warnpc $08B708
org $08B708 ; <- 43708 - ancilla_quake_spell.asm : 83
_ancilla_quake_spell_83:
;--------------------------------------------------------------------------------

;================================================================================
; Animated Entrances
;--------------------------------------------------------------------------------
org $1BCAC4 ; <- Bank1B.asm : 1537 (STA $02E4 ; Link can't move.)
JSL AnimatedEntranceFix
BNE +
	RTL
	NOP #2
+
;--------------------------------------------------------------------------------

;================================================================================
; Big & Great Fairies
;--------------------------------------------------------------------------------
org $1DC475 ; <- EC475 - sprite_big_fairie.asm : 70 (LDA.w #$00A0 : ADD $7EF372 : STA $7EF372)
JSL.l RefillHealthPlusMagic
NOP #8

org $1DC489 ; <- EC489 - sprite_big_fairie.asm : 88 (LDA $7EF36D : CMP $7EF36C : BNE .player_hp_not_full_yet)
NOP #4
JSL.l CheckFullHealth
;--------------------------------------------------------------------------------

;================================================================================
; RNG Fixes
;--------------------------------------------------------------------------------
org $1DFD9E ; <- EFD9E - sprite_diggin_guy.asm : 307
NOP #8
;--------------------------------------------------------------------------------
org $1DFD67 ; <- EFD67 - sprite_diggin_guy.asm : 242
JSL.l RigDigRNG
;--------------------------------------------------------------------------------
org $01EE94 ; <- EE94 - Bank01.asm : 14121
JSL.l RigChestRNG
;--------------------------------------------------------------------------------
org $1ED63E ; <- F563E - sprite_agahnim.asm
JSL RNG_Agahnim1
org $1ED6EF ; <- F56EF - sprite_agahnim.asm
JSL RNG_Agahnim1
org $1D91E3 ; <- E91E3 - sprite_ganon.asm
JSL RNG_Ganon_Extra_Warp
org $1D9488 ; <- E9488 - sprite_ganon.asm
JSL RNG_Ganon
;--------------------------------------------------------------------------------
;org $01EDB2 ; <- EDB2 - Bank01.asm : 14038
;INC $04C4
;--------------------------------------------------------------------------------
org $05A3F4 ; <- 2A3F4 - sprite_lanmola.asm : 112 (JSL GetRandomInt : AND.b #$07 : TAY)
JSL.l RNG_Lanmolas1
org $05A401 ; <- 2A401 - sprite_lanmola.asm : 116 (JSL GetRandomInt : AND.b #$07 : TAY)
JSL.l RNG_Lanmolas1
org $05A4FA ; <- 2A4FA - sprite_lanmola.asm : 241 (JSL GetRandomInt : AND.b #$07 : TAY)
JSL.l RNG_Lanmolas1
org $05A507 ; <- 2A507 - sprite_lanmola.asm : 245 (JSL GetRandomInt : AND.b #$07 : TAY)
JSL.l RNG_Lanmolas1
;--------------------------------------------------------------------------------
org $1DD817 ; <- ED817 - sprite_giant_moldorm.asm : 187 (JSL GetRandomInt : AND.b #$02 : DEC A : STA $0EB0, X)
JSL.l RNG_Moldorm1
org $1DD821 ; <- ED821 - sprite_giant_moldorm.asm : 189 (JSL GetRandomInt : AND.b #$1F : ADC.b #$20 : STA !timer_0, X)
JSL.l RNG_Moldorm1
org $1DD832 ; <- ED832 - sprite_giant_moldorm.asm : 203 (JSL GetRandomInt : AND.b #$0F : ADC.b #$08 : STA !timer_0, X)
JSL.l RNG_Moldorm1
;--------------------------------------------------------------------------------
org $1E81A9 ; <- F01A9 - sprite_helmasaur_king.asm : 247 (JSL GetRandomInt : AND.b #$07 : TAY)
JSL.l RNG_Helmasaur
org $1E8262 ; <- F0262 - sprite_helmasaur_king.asm : 373 (JSL GetRandomInt : AND.b #$01 : BEQ BRANCH_BETA)
JSL.l RNG_Helmasaur
org $1DEEE1 ; <- EEEE1 - sprite_helmasaur_fireball.asm : 236 (JSL GetRandomInt : STA $0FB6)
JSL.l RNG_Helmasaur
;--------------------------------------------------------------------------------
org $1EB5F7 ; <- F35F7 - sprite_arrghus.asm : 328 (JSL GetRandomInt : AND.b #$3F : ADC.b #$30 : STA $0DF0, X)
JSL.l RNG_Arrghus
;--------------------------------------------------------------------------------
org $1EBF4D ; <- F3F4D - sprite_mothula.asm : 180 (JSL GetRandomInt : AND.b #$07 : TAY)
JSL.l RNG_Mothula
org $1EBF60 ; <- F3F60 - sprite_mothula.asm : 187 (JSL GetRandomInt : AND.b #$1F : ADC.b #$40 : STA $0DF0, X)
JSL.l RNG_Mothula
org $1EBFBE ; <- F3FBE - sprite_mothula.asm : 261 (JSL GetRandomInt : AND.b #$1F : ORA.b #$40 : STA !beam_timer, X)
JSL.l RNG_Mothula
org $1EC095 ; <- F4095 - sprite_mothula.asm : 373 (JSL GetRandomInt : AND.b #$1F : CMP #$1E : BCC .already_in_range)
JSL.l RNG_Mothula
;--------------------------------------------------------------------------------
org $1E957A ; <- F157A - sprite_kholdstare.asm : 209 (JSL GetRandomInt : AND.b #$3F : ADC.b #$20 : STA $0DF0, X)
JSL.l RNG_Kholdstare
org $1E95F0 ; <- F15F0 - sprite_kholdstare.asm : 289 (JSL GetRandomInt : AND.b #$3F : ADC.b #$60 : STA $0DF0, X)
JSL.l RNG_Kholdstare
org $1E95FB ; <- F15FB - sprite_kholdstare.asm : 291 (JSL GetRandomInt : PHA : AND.b #$03 : TAY)
JSL.l RNG_Kholdstare
org $1E96C9 ; <- F16C9 - sprite_kholdstare.asm : 453 (JSL GetRandomInt : AND.b #$07 : TAY)
JSL.l RNG_Kholdstare
org $1E96E5 ; <- F16E5 - sprite_kholdstare.asm : 458 (JSL GetRandomInt : AND.b #$07 : TAY)
JSL.l RNG_Kholdstare
org $1E97D5 ; <- F17D5 - sprite_kholdstare.asm : 605 (JSL GetRandomInt : AND.b #$04 : STA $0D)
JSL.l RNG_Kholdstare
;--------------------------------------------------------------------------------
org $1DE5E4 ; <- EE5E4 - sprite_vitreous.asm : 207 (JSL GetRandomInt : AND.b #$0F : TAY)
JSL.l RNG_Vitreous
org $1DE626 ; <- EE626 - sprite_vitreous.asm : 255 (JSL GetRandomInt : AND.b #$07 : STA $0D90, Y)
JSL.l RNG_Vitreous
;--------------------------------------------------------------------------------
org $1DB16C ; <- EB16C - sprite_trinexx.asm : 530 (JSL GetRandomInt : AND.b #$07 : TAY)
JSL.l RNG_Trinexx
org $1DB186 ; <- EB186 - sprite_trinexx.asm : 535 (JSL GetRandomInt : AND.b #$07 : TAY)
JSL.l RNG_Trinexx
org $1DB25E ; <- EB25E - sprite_trinexx.asm : 643 (JSL GetRandomInt : AND.b #$03 : TAY : CMP $00 : BEQ BRANCH_ALPHA)
JSL.l RNG_Trinexx
org $1DB28D ; <- EB28D - sprite_trinexx.asm : 661 (JSL GetRandomInt : AND.b #$03 : CMP.b #$01 : TYA : BCS BRANCH_GAMMA)
JSL.l RNG_Trinexx
org $1DB9B0 ; <- EB9B0 - sprite_sidenexx.asm : 165 (JSL GetRandomInt : AND.b #$07 : INC A : CMP.b #$05 : BCS BRANCH_ALPHA)
JSL.l RNG_Trinexx
org $1DB9CC ; <- EB9CC - sprite_sidenexx.asm : 175 (JSL GetRandomInt : LSR A : BCS BRANCH_ALPHA)
JSL.l RNG_Trinexx
org $1DBA5D ; <- EBA5D - sprite_sidenexx.asm : 270 (JSL GetRandomInt : AND.b #$0F : STA $0DF0, X)
JSL.l RNG_Trinexx
org $1DBAB1 ; <- EBAB1 - sprite_sidenexx.asm : 314 (JSL GetRandomInt : AND.b #$0F : LDY.b #$00 : SUB.b #$03)
JSL.l RNG_Trinexx
org $1DBAC3 ; <- EBAC3 - sprite_sidenexx.asm : 323 (JSL GetRandomInt : AND.b #$0F : ADD.b #$0C : STA $02 : STZ $03)
JSL.l RNG_Trinexx
;================================================================================
; HUD Changes
;--------------------------------------------------------------------------------
org $0DFC4C ; <- 6FC4C - headsup_display.asm : 836 (LDA $7EF36E : AND.w #$00FF : ADD.w #$0007 : AND.w #$FFF8 : TAX)
JML.l OnDrawHud
NOP #197
ReturnFromOnDrawHud:
SEP #$30
LDX.b #$FF ; vanilla hud code ends with #$FF in X, and it's required for unknown reasons.


;org $0DFD0A ; <- 6FD0A - headsup_display.asm : 900
;STA $7EC766 ; nudge key digit right

;org $0DFD13 ; <- 6FD13 - headsup_display.asm : 905
;STA $7EC726 ; key icon blank

org $0DFC37 ; <- 6FC37 - headsup_display.asm : 828 (LDA.w #$28F7)
JSL.l DrawMagicHeader
BRA + : NOP #15 : +
;--------------------------------------------------------------------------------
org $0DFB29 ; <- headsup_display.asm : 688 (LDA.b #$86 : STA $7EC71E)
;LDA.b #$86 : STA $7EC720 ; nudge silver arrow right - remember to update this in newit
;LDA.b #$24 : STA $7EC721
;LDA.b #$87 : STA $7EC722
;LDA.b #$24 : STA $7EC723
JSL.l DrawHUDArrows : BRA +
	NOP #18
+
;--------------------------------------------------------------------------------
org $01CF67 ; <- CF67 - Bank01.asm : 11625 (STA $7EF36F)
JSL.l DecrementSmallKeys
;--------------------------------------------------------------------------------
org $0DED04 ; <- 6ED04 - equipment.asm : 1963 (REP #$30)
JSL.l DrawHUDDungeonItems
;--------------------------------------------------------------------------------
; Insert our version of the hud tilemap
org $0DFA96 ; <- 6FA96 - headsup_display.asm : 626 (LDX.w #.hud_tilemap)
LDX.w #HUD_TileMap
org $0DFA9C ; <- 6FA9C - headsup_display.asm : 629 (MVN $0D, $7E ; $Transfer 0x014A bytes from $6FE77 -> $7EC700)
MVN $217E
;--------------------------------------------------------------------------------
;org $0DE48E ; <- 6E48E - equipment.asm : 1233 (LDA.w #$11CE : STA $00) - HOOK HERE TO DRAW ON THE ITEM SCREEN
;JSL.l DrawHUDDungeonItems
;NOP
;--------------------------------------------------------------------------------
org $0DFB1F ; 6FB1F - headsup_display.asm : 681 (LDA $7EF340 : BEQ .hastNoBow)
JSL.l CheckHUDSilverArrows
;--------------------------------------------------------------------------------

;================================================================================
; 300 Rupee NPC
;--------------------------------------------------------------------------------
org $1EF060 ; <- F7060 - sprite_shopkeeper.asm:242 (INC $0D80, X)
JSL.l Set300RupeeNPCItem
NOP
;--------------------------------------------------------------------------------

;================================================================================
; Glitched Mode Fixes
;--------------------------------------------------------------------------------
org $0691AC ; <- 311AC - sprite_prep.asm:2453 (LDY $0FFF)
JSL.l GetAgahnimPalette
NOP #2
;--------------------------------------------------------------------------------
org $06F0DD ; <- 370DD - Bank06.asm:5399 (STA $0BA0, X)
JSL.l GetAgahnimDeath
NOP #2
;--------------------------------------------------------------------------------
org $1ED4E6 ; <- F54E6 - sprite_agahnim.asm:314 (LDY $0FFF)
JSL.l GetAgahnimType
NOP #2
;--------------------------------------------------------------------------------
org $1ED577 ; <- F5577 - sprite_agahnim.asm:418 (PHX)
JML.l GetAgahnimSlot
GetAgahnimSlotReturn:
;--------------------------------------------------------------------------------
org $1ED678 ; <- F5678 - sprite_agahnim.asm:587 (INC $0E30, X)
NOP #2
JSL.l GetAgahnimLightning
;--------------------------------------------------------------------------------
org $0287E0 ; <- 107E0 - Bnak02.asm:1507 (LDA $0112 : ORA $02E4 : ORA $0FFC : BEQ .allowJoypadInput)
JSL.l AllowJoypadInput : NOP #5
;--------------------------------------------------------------------------------
; OWG sign on EDM
;--------------------------------------------------------------------------------
org $02EC2E ; Bank02.asm : 11919 LDX.w #$001E
JSL AddSignToEDMBridge : NOP #$02
;--------------------------------------------------------------------------------
org $02ED51 ; Bank02.asm : 12113 LDX.w #$001E
JSL AddSignToEDMBridge : NOP #$02
;--------------------------------------------------------------------------------

;================================================================================
; Half Magic Bat
;--------------------------------------------------------------------------------
org $05FBD3 ; <- 2FBD3 - sprite_mad_batter.asm:209 - (STA $7EF37B)
JSL.l GetMagicBatItem
;--------------------------------------------------------------------------------

;================================================================================
; MSU Music
;--------------------------------------------------------------------------------
org $0080D7 ; <- D7 - Bank00.asm:172 (SEP #$30)
JML msu_main : NOP
spc_continue:

org $08C421 ; <- AD4021 F005 - ancilla_receive_item.asm:108 (LDA $2140 : BEQ .wait_for_music)
JML pendant_fanfare : NOP
pendant_continue:

org $08C42B
pendant_done:

org $08C62A ; <- AD4021 D008 - ancilla_receive_item.asm:442 (LDA $2140 : BNE .waitForSilence)
JML crystal_fanfare : NOP
crystal_done:

org $08C637
crystal_continue:

org $0EE6EC ; <- E220 A922 - Bank0E.asm:2892 (SEP #$20 : LDA.b #$22 : STA $012C)
JSL.l ending_wait
;--------------------------------------------------------------------------------

;================================================================================
; Replacement Shopkeeper
;--------------------------------------------------------------------------------
org $068BEB ; <- 30BEB - sprite_prep.asm:1125 - (INC $0BA0, X)
JSL.l SpritePrep_ShopKeeper : RTS : NOP
ShopkeeperFinishInit:
;--------------------------------------------------------------------------------
org $1EEEE3 ; <- F6EE3 - sprite_shopkeeper.asm:7 - (LDA $0E80, X)
JSL.l Sprite_ShopKeeper : RTS : NOP
ShopkeeperJumpTable:
;--------------------------------------------------------------------------------

;================================================================================
; Tile Target Loader
;--------------------------------------------------------------------------------
org $00D55E ; <- 555E - Bank00.asm:3491 (LDX.w #$2D40)
JSL.l LoadModifiedTileBufferAddress : NOP #2
;--------------------------------------------------------------------------------

;================================================================================
; Permabunny Fix
;--------------------------------------------------------------------------------
org $078F32 ; <- 38F32 - Bank07.asm:2420 - (LDA $7EF357)
JSL.l DecideIfBunny ; for bunny beams
;--------------------------------------------------------------------------------

;================================================================================
; Other bunny Fixes
;--------------------------------------------------------------------------------
org $029E7C; <- 11E7C - module_ganon_emerges.asm:127 - (LDA.b #$09 : STA $012C)
JSL.l FixAga2Bunny : NOP
;--------------------------------------------------------------------------------

;================================================================================
; Open Mode Fixes
;--------------------------------------------------------------------------------
org $05DF65 ; <- 2DF65 - sprite_uncle_and_priest.asm:994 - (LDA.b #$01 : STA $7EF3C5)
JSL.l SetUncleRainState : RTS
;--------------------------------------------------------------------------------
;org $0280DD ; <- 100DD - Bank02.asm:298 - (LDA $7EF3C5 : CMP.b #$02 : BCC .indoors)
;JSL.l ForceLinksHouse
;--------------------------------------------------------------------------------
org $05EDDF ; <- 2EDDF - sprite_zelda.asm:398 - (LDA.b #$02 : STA $7EF3C5)
JSL.l EndRainState : NOP #2
;--------------------------------------------------------------------------------
org $05DF49 ; <- 2DF49 - sprite_uncle_and_priest.asm:984 - (JSL Link_ReceiveItem)
JSL.l OnUncleItemGet
;--------------------------------------------------------------------------------

;================================================================================
; Generic Keys
;--------------------------------------------------------------------------------
org $028157 ; <- 10157 - Bank02.asm:381 - (LDA $040C : CMP.b #$FF : BEQ .notPalace)
JSL.l CheckKeys : NOP
;--------------------------------------------------------------------------------
org $028166 ; <- 10166 - Bank02.asm:396 - (LDA $7EF37C, X)
JSL.l LoadKeys
;--------------------------------------------------------------------------------
org $029A31 ; <- 11A31 - Bank02.asm:4785 - (LDA $7EF37C, X)
JSL.l LoadKeys
;--------------------------------------------------------------------------------
org $02A0D1 ; <- 120D1 - Bank02.asm:5841 - (STA $7EF37C, X)
JSL.l SaveKeys
;--------------------------------------------------------------------------------
org $09F584 ; <- 4F584 - module_death.asm:447 - (STA $7EF37C, X)
JSL.l SaveKeys
;--------------------------------------------------------------------------------
org $0282EC ; <- 102EC - Bank02.asm:650 - (STA $7EF36F)
JSL.l ClearOWKeys
;--------------------------------------------------------------------------------
org $0DFA80 ; <- 6FA80 : headsup_display.asm:596 - (LDA.b #$00 : STA $7EC017)
JSL.l HUDRebuildIndoor : NOP #4
;--------------------------------------------------------------------------------
org $029A35 ; <- 11A35 : Bank02.asm:4789 - (JSL HUD.RebuildIndoor.palace)
JSL.l HUDRebuildIndoorHole
;--------------------------------------------------------------------------------

;================================================================================
; Pendant / Crystal Fixes
;--------------------------------------------------------------------------------
;org $0DE9C8 ; <- 6E9C8 - original check for agahnim 1 being defeated
;;LDA $7EF3CA : CMP.b #$40 ; check for dark world instead
;JSL.l CheckPendantHUD
;NOP #2
;================================================================================
org $098BB0 ; <- 048BB0 - ancilla_init.asm:1663 - (STX $02D8 : JSR AddAncilla)
JSL.l TryToSpawnCrystalUntilSuccess
NOP
org $01C74B ; <- 00C74B - bank01.asm:10368 - (STZ $AE, X)
NOP #2 ; this STZ is what makes the crystal never spawn if it fails to spawn on the first try
;================================================================================
org $0DE9C8 ; <- 6E9C8 - equipment.asm:1623 - (LDA $7EF3C5 : CMP.b #$03 : BCC .beforeAgahnim)
JSL.l DrawPendantCrystalDiagram : RTS
;NOP #11
;================================================================================
org $0DEDCC ; <- 6EDCC - equipment.asm:2043 - (LDA $040C : AND.w #$00FF : CMP.w #$00FF : BNE .inSpecificDungeon)
JSL.l ShowDungeonItems : NOP #5

org $0DEE59 ; <- 6EE59 - equipment.asm:2126 - (LDA $040C : AND.w #$00FF : CMP.w #$00FF : BEQ .notInPalace)
JSL.l ShowDungeonItems : NOP #5

org $0DEE8A ; <- 6EE8A - equipment.asm:2151 - (LDA $040C : AND.w #$00FF : CMP.w #$00FF : BEQ .notInPalaceAgain)
JSL.l ShowDungeonItems : NOP #5

org $0DEF3B ; <- 6EF3B - equipment.asm:2290 - (LDA $040C : AND.w #$00FF : CMP.w #$00FF : BEQ .notInPalace)
JSL.l ShowDungeonItems : NOP #5
;================================================================================
org $0DEA5F ; <- 6EA5F - equipment.asm:1679 - (SEP #$30)
;NOP #5
;BRL .skipCrystalInit
;org $0DEAA4 ; <- 6EAA4 - equipment.asm:1706 - (LDA $7EF37A : AND.w #$0001)
;.skipCrystalInit
;================================================================================
org $0DE9D8 ; <- 6E9D8 - equipment.asm:1635 - (LDA $E860, X : STA $12EA, X)
org $0DEA15 ; <- 6EA15 - equipment.asm:1647 - (LDA.w #$13B2 : STA $00)
;================================================================================
org $00F97E ; <- 797E - Bank00.asm:8586 - (LDA $7EF3CA : EOR.b #$40 : STA $7EF3CA)
JSL.l FlipLWDWFlag : NOP #6
;================================================================================
org $02B15C ; <- 1315C - Bank02.asm:7672 - (LDA $7EF3CA : EOR.b #$40 : STA $7EF3CA)
JSL.l IncrementOWMirror
JSL.l FlipLWDWFlag
NOP #2
;================================================================================
;Clear level to open doors
org $01C50D ; 0xC50D - Bank01.asm:10032 - (LDA $7EF3CA : BNE .inDarkWorld)
LDA CrystalPendantFlags_2, X
;================================================================================
;Kill enemy to clear level
org $01C715 ; <- C715 - Bank01.asm:10358 - (LDA $7EF3CA : BNE .inDarkWorld)
LDA CrystalPendantFlags_2, X
;JSL.l GetPendantCrystalWorld
;================================================================================
;org $0AC5C3 ; <- 545C3 - Bank0A.asm:1859 - (LDA $7EF374 : AND $0AC5A6, X : BEQ .fail)
;NOP #10
;CLC
;================================================================================
org $0AC5BB ; < 545BB - Bank0A.asm:1856 - (LDA $7EF3C7 : CMP.b #$03 : BNE .fail)
JSL.l OverworldMap_CheckObject : RTS
org $0AC5D8 ; < 545D8 - Bank0A.asm:1885 - (LDA $7EF3C7 : CMP.b #$07 : BNE OverworldMap_CheckPendant_fail)
JSL.l OverworldMap_CheckObject : RTS
;================================================================================
org $0AC53e ; <- 5453E - Bank0A.asm:1771 - (LDA $0AC50D, X : STA $0D)
JSL.l GetCrystalNumber
;================================================================================
; EVERY INSTANCE OF STA $7EF3C7 IN THE ENTIRE CODEBASE
org $029D51 ; <- 11D51
JSL.l SetLWDWMap
org $0589BB ; <- 289BB
JSL.l SetLWDWMap
org $05DD9A ; <- 2DD9A
JSL.l SetLWDWMap

org $05F1F6 ; <- 2F1F6
JSL.l SetLWDWMap
org $05F209 ; <- 2F209
JSL.l SetLWDWMap
org $05FF91 ; <- 2FF91
JSL.l SetLWDWMap

org $098687 ; <- 48687
JSL.l SetLWDWMap
org $1ECEDD ; <- F4EDD
JSL.l SetLWDWMap
org $1ECF0D ; <- F4F0D
JSL.l SetLWDWMap
;================================================================================
; EVERY INSTANCE OF LDA $7EF3C7 IN THE ENTIRE CODEBASE
org $05DDFE ; <- 2DDFE
JSL.l GetMapMode
org $05EE25 ; <- 2EE25
JSL.l GetMapMode
org $05F17D ; <- 2F17D
JSL.l GetMapMode
org $05FF7D ; <- 2FF7D
JSL.l GetMapMode

org $0AC01A ; <- 5401A
JSL.l GetMapMode
org $0AC037 ; <- 54037
JSL.l GetMapMode
org $0AC079 ; <- 54079
JSL.l GetMapMode
org $0AC0B8 ; <- 540B8 x
JSL.l GetMapMode
org $0AC0F8 ; <- 540F8
JSL.l GetMapMode
org $0AC137 ; <- 54137
JSL.l GetMapMode
org $0AC179 ; <- 54179
JSL.l GetMapMode
org $0AC1B3 ; <- 541B3
JSL.l GetMapMode
org $0AC1F5 ; <- 541F5
JSL.l GetMapMode
org $0AC22F ; <- 5422F
JSL.l GetMapMode
org $0AC271 ; <- 54271
JSL.l GetMapMode
org $0AC2AB ; <- 542AB
JSL.l GetMapMode
org $0AC2ED ; <- 542ED
JSL.l GetMapMode
org $0AC327 ; <- 54327
JSL.l GetMapMode
org $0AC369 ; <- 54369
JSL.l GetMapMode

org $0DC849 ; <- 6C849
JSL.l GetMapMode
;================================================================================
org $0AC012 ; <- 54012 - Bank0A.asm:1039 (LDA $7EF2DB : AND.b #$20 : BNE BRANCH_DELTA)
NOP #8
;org $0AC012 ; <- 54012 - Bank0A.asm:1039 - (LDA $7EF2DB)
;JSL.l OnLoadMap
;================================================================================
org $028B8F ; <- 10B8F - Bank02.asm:2236 (LDA $7EF374 : LSR A : BCS BRANCH_BETA)
JSL.l CheckHeraObject : BNE + : NOP
LDX.b #$F1 : STX $012C
+
;================================================================================
org $029090 ; <- 11090 - Bank02.asm:3099 (LDA $7EF374 : LSR A : BCS BRANCH_GAMMA)
JSL.l CheckHeraObject : BNE + : NOP
STX $012C ; DON'T MOVE THIS FORWARD OR MADNESS AWAITS
+
;================================================================================
org $029798 ; <- 11798 - Bank02.asm:4287 (CMP $02895C, X : BNE BRANCH_ALPHA)
NOP #6 ; remove crystal room cutscene check that causes softlocks
;================================================================================

;================================================================================
; Text Changes
;--------------------------------------------------------------------------------
;org $06C7D3 ; <- 347D3 - sprite_ponds.asm:720 (LDA.b #$8A)
;JSL.l DialogFairyThrow
;--------------------------------------------------------------------------------
org $06C7BB ; <- 347BB - sprite_ponds.asm:702 (JSL Sprite_ShowMessageFromPlayerContact : BCC BRANCH_ALPHA)
JSL.l FairyPond_Init
;--------------------------------------------------------------------------------
org $1D92EC ; <- E92EC - sprite_ganon.asm:947 (JSL Sprite_ShowMessageMinimal)
JSL.l DialogGanon1
;--------------------------------------------------------------------------------
org $1D9078 ; <- E9078 - sprite_ganon.asm:552 (LDA.b #$70 : STA $1CF0)
JSL.l DialogGanon2 : RTS
;--------------------------------------------------------------------------------
;-- Convert Capitalism fairy to shop
org $06C4BD ; <- 34C4BD - sprite_ponds.asm:107 (LDA $A0 : CMP.b #$15 : BEQ Sprite_HappinessPond)
JSL.l HappinessPond_Check
;--------------------------------------------------------------------------------
;-- Sahasrahla (no green pendant)
org $05F16C ; <- 2F16C sprite_elder.asm:137 (JSL Sprite_ShowSolicitedMessageIfPlayerFacing)
JSL.l Sprite_ShowSolicitedMessageIfPlayerFacing_Alt
;--------------------------------------------------------------------------------
;-- Sahasrahla (have boots)
org $05F1A8 ; <- 2F1A8 sprite_elder.asm:170 (JSL Sprite_ShowSolicitedMessageIfPlayerFacing)
JSL.l Sprite_ShowSolicitedMessageIfPlayerFacing_Alt
;--------------------------------------------------------------------------------
;-- Sahasrahla (have boots, have ice rod)
org $05F1BC ; <- 2F1BC sprite_elder.asm:182 (JSL Sprite_ShowSolicitedMessageIfPlayerFacing)
JSL.l Sprite_ShowSolicitedMessageIfPlayerFacing_Alt
;--------------------------------------------------------------------------------
;-- Sahasrahla (have boots, have ice rod, have 3 pendants)
org $05F1CE ; <- 2F1CE sprite_elder.asm:194 (JSL Sprite_ShowSolicitedMessageIfPlayerFacing)
JSL.l Sprite_ShowSolicitedMessageIfPlayerFacing_Alt
;--------------------------------------------------------------------------------
;-- Sahasrahla (have boots, have ice rod, have 3 pendants, have master sword)
org $05F1D8 ; <- 2F1D8 sprite_elder.asm:204 (JSL Sprite_ShowSolicitedMessageIfPlayerFacing)
JSL.l Sprite_ShowSolicitedMessageIfPlayerFacing_Alt
;----------------------------------------------------------
;-- Bomb shop guy (talking to him before and after big bomb is available)
org $1EE181 ; <- F6181 sprite_bomb_shop_entity.asm : 85 (JSL Sprite_ShowSolicitedMessageIfPlayerFacing)
JSL Sprite_ShowSolicitedMessageIfPlayerFacing_Alt
;----------------------------------------------------
;-- Bombos tablet
org $05F3BF ; <- 2F3BF sprite_medallion_tablet.asm : 254 (JSL Sprite_ShowMessageUnconditional)
JSL.l DialogBombosTablet
;----------------------------------------------------
;-- Ether tablet
org $05F429 ; <- 2F429 sprite_medallion_tablet.asm : 317 (JSL Sprite_ShowMessageUnconditional)
JSL.l DialogEtherTablet
;----------------------------------------------------
;-- Thrown fish (move to different text ID)
org $1D82B2 ; <-  0xE82B2 low byte of message
db #$8F
;================================================================================

;================================================================================
; Text Removal
;--------------------------------------------------------------------------------
org $05FA8E
Sprite_ShowMessageMinimal:
JML.l Sprite_ShowMessageMinimal_Alt
;--------------------------------------------------------------------------------
;org $1CFD69
;Main_ShowTextMessage:
;JML.l Main_ShowTextMessage_Alt
;--------------------------------------------------------------------------------
org $07b0cc ; <- 3b0d0 - Bank 07.asm : 7767 (JSL Main_ShowTextMessage)
JSL.l Main_ShowTextMessage_Alt
;--------------------------------------------------------------------------------
org $08c5fe ; <- 445FE - ancilla_receive_item.asm : 408 (JSL Main_ShowTextMessage)
JSL.l Main_ShowTextMessage_Alt
;--------------------------------------------------------------------------------
org $05E21F ; <- 2E21F - Bank05.asm : 2691 (STZ $0223)
JSL.l Sprite_ShowMessageMinimal_Alt
BRA Sprite_ShowMessageUnconditional_Rest
org $05E232 ; <- 2E232 - Bank05.asm : 2700 (PHX)
Sprite_ShowMessageUnconditional_Rest:
;--------------------------------------------------------------------------------
;-- Music restarting at zelda fix
org $05ED10 ; <- 2ED10 - sprite_zelda.asm : 233 - (LDA.b #$19 : STA $012C)
NOP #5
;--------------------------------------------------------------------------------
org $1ECE47 ; <- F4E47 - sprite_crystal_maiden.asm : 220
JML.l MaidenCrystalScript
;--------------------------------------------------------------------------------
org $1ECCEB ; <- F4CEB - sprite_crystal_maiden.asm : 25 ; skip all palette nonsense
JML.l SkipCrystalPalette
org $1ECD39
SkipCrystalPalette:
;--------------------------------------------------------------------------------
org $08C3FD ; <- 443FD - ancilla_receive_item.asm : 89
!MS_GOT = "$7F5031"
LDA #$40 : STA !MS_GOT
;;NOP #6 ; don't set master sword follower
;--------------------------------------------------------------------------------
org $08C5E5 ; <- 445ED - ancilla_receive_item.asm:395 (LDA .item_messages, Y : CMP.w #$FFFF : BEQ .handleGraphics)
JSL.l DialogItemReceive : NOP #2
org $08C301 ; <- 44301 - ancilla_receive_item.asm:8 (.item_messages)
Ancilla_ReceiveItem_item_messages:
;----------------------------------------------------------
;-- Shopkeepers
org $1EF379 ; <- F7379 sprite_shopkeeper.asm : 810 (JSL Sprite_ShowMessageUnconditional : JSL ShopKeeper_RapidTerminateReceiveItem)
NOP #4 ;Just remove the rapid terminate call
;--------------------------------------------------------------------------------
;-- Reset Dialog Selection index for each new message
org $0EEE5D ; <- 76E5D - vwf.asm:84 (JSL Attract_DecompressStoryGfx)
JSL.l DialogResetSelectionIndex
;----------------------------------------------------
;-- Agahnim 1 Defeated
org $068475 ; <- 30475 Bank06.asm : 762 - (JSL Sprite_ShowMessageMinimal)
JSL.l AddInventory_incrementBossSwordLong
;NOP #4
;----------------------------------------------------------
;-- We'll take your sword
org $06B4F3 ; <- 334F3 sprite_smithy_bros.asm : 556 (JSL Sprite_ShowMessageUnconditional)
JSL ItemSet_SmithSword
;NOP #4
;----------------------------------------------------------

;===================================
;-- Escort Text
;-- dw coordinate, coordinate, flag, text message number, tagalong number
;===================================
org $09A4C2 ; <- 4A4C2 tagalong.asm : 967 - (.room_data_1)
dw $1EF0, $0288, $0001, $0097, $00F0 ; Old man first text after encounter text
dw $1E58, $02F0, $0002, $0098, $00F0 ; Old man "dead end" (when you run to the pot)
dw $1EA8, $03B8, $0004, $0099, $00F0 ; Old man "turn right here"
dw $0CF8, $025B, $0001, $001F, $00F0 ; Zelda "there's a secret passage"
dw $0CF8, $039D, $0002, $001F, $00F0 ; Zelda "there's a secret passage"
dw $0C78, $0238, $0004, $001F, $00F0 ; Zelda "there's a secret passage"
dw $0A30, $02F8, $0001, $0020, $00F0 ; Zelda "we can push this"
dw $0178, $0550, $0001, $0021, $00F0 ; Zelda "pull the lever"
dw $0168, $04F8, $0002, $0028, $00F0 ; Zelda room before sanctuary
dw $1BD8, $16FC, $0001, $0122, $00F0 ; Blind (maiden) "don't take me outside!"
dw $1520, $167C, $0001, $0122, $00F0 ; Blind (maiden) "don't take me outside!"
dw $05AC, $04FC, $0001, $0027, $00F0 ; Zelda in the water room
;----------------------------------------------------------
;----------------------------------------------------------
;-- Speed up Walls (Desert, Mire, and Palace of Darkness)
; org $01CA66 ; <- CA66 Bank01.asm : 10864 - (LDA.w #$2200 : ADD $041C : STA $041C)
; LDA.w #$4400 ; #$2200 is the normal speed, $#FF00 is max.
;----------------------------------------------------------
;-- Hobo gives item faster
; org $06BE3A ; <- 33E3A sprite_hobo.asm : 90 - (db 6, 2, 6, 6, 2, 100, 30)
; db 6, 2, 6, 6, 2, 6, 30
;----------------------------------------------------------
;-- Sick kid gives item faster
; org $06B9A1 ; <- 339A1 sprite_bug_net_kid : 62 - (db 8, 12, 8, 12, 8, 96, 16)
; db 8, 12, 8, 12, 8, 32, 16
;----------------------------------------------------------

;================================================================================
; Ganon Fixes
;--------------------------------------------------------------------------------
;org $1D91E3 ; <- E91E3 - sprite_ganon.asm : 778
;JSL.l GanonWarpRNG
;NOP #2
;LDA #$00 : NOP #4
;--------------------------------------------------------------------------------

;================================================================================
; Dark World Spawn Location Fix & Follower Fixes
;--------------------------------------------------------------------------------
org $00894A ; <- 94A
PHB : JSL.l DarkWorldSaveFix
;--------------------------------------------------------------------------------
org $028046 ; <- 10046 - Bank02.asm : 217 (JSL EnableForceBlank) (Start of Module_LoadFile)
JSL.l OnFileLoad
;--------------------------------------------------------------------------------
org $09F520 ; <- 4F520 - module_death.asm : 401 (LDA $7EF3C5 : CMP.b #$03 : BCS BRANCH_THETA)
JSL.l OnPlayerDead
JSL.l IncrementDeathCounter
NOP #6
;--------------------------------------------------------------------------------
;org $02D61A ; <- 1561A
;LDA.b #$01 : STA $1B ; fix something i wrote over i shouldn't have
;--------------------------------------------------------------------------------
org $1ED379 ; <- F5379 - sprite_agahnim.asm:75 - JSL PrepDungeonExit
JSL FixAgahnimFollowers
;================================================================================

;================================================================================
; Randomize NPC Items
;--------------------------------------------------------------------------------
org $028823 ; <- 10823 - Bank02.asm:1560 (LDA $7EF3C5 : BEQ .ignoreInput)
JSL.l AllowSQ
;--------------------------------------------------------------------------------
org $08C45F ; <- 4445F - ancilla_recieve_item.asm:157 (STZ $02E9)
JSL.l PostItemAnimation : NOP #2
;--------------------------------------------------------------------------------
org $1EE90A ; <- F690A
JSL.l ItemCheck_OldMan
NOP #2
;--------------------------------------------------------------------------------
org $0280F2 ; <- 100F2
JSL.l ItemCheck_OldMan
NOP #2
;--------------------------------------------------------------------------------
org $1EE9FE ; <- F69FE
JSL.l ItemSet_OldMan
;--------------------------------------------------------------------------------
org $068F16 ; <- 30F16
JSL.l ItemCheck_ZoraKing
;--------------------------------------------------------------------------------
org $059ACA ; <- 29ACA
JSL $1DE1AA ; Sprite_SpawnFlippersItem
;--------------------------------------------------------------------------------
org $1DE1E4 ; <- EE1E4 - sprite_great_catfish.asm : 489
JSL.l LoadZoraKingItemGFX
NOP #2
;--------------------------------------------------------------------------------
org $068D86 ; <- 30D86
JSL.l ItemCheck_SickKid
;--------------------------------------------------------------------------------
org $06B9D4 ; <- 339D4 - sprite_bug_net_kid.asm : 111 (JSL Link_ReceiveItem)
JSL.l ItemSet_SickKid
;--------------------------------------------------------------------------------
org $068BAC ; <- 30BAC - SpritePrep_FluteBoy : 1068
JSL.l ItemCheck_TreeKid2

org $06908D ; <- 3108D - SpritePrep_FluteBoy : 2175
JSL.l ItemCheck_TreeKid
CMP.b #$08
BEQ $0A

org $069095 ; <- 31095 - SpritePrep_FluteBoy : 2177
JSL.l ItemCheck_TreeKid
CMP.b #$08

org $0690BD ; <- 310BD - SpritePrep_FluteBoy : 2202
JSL.l ItemCheck_TreeKid2

org $06AF9B ; <- 32F9B - FluteBoy_Chillin : 73 : LDA $7EF34C : CMP.b #$02 : BCS .player_has_flute
;NOP #8
LDA !HAS_GROVE_ITEM : AND.b #$01
db #$D0 ; BNE

org $06B062 ; <- 33062 - FluteAardvark_InitialStateFromFluteState : 225 : LDA $7EF34C : AND.b #$03 : !BGE #$05
JSL.l ItemCheck_TreeKid2
NOP #$02 ; remove pointless AND

org $06B048 ; <- 33048
JSL.l ItemCheck_TreeKid3

org $06AF59 ; <- 32F59 - sprite_flute_boy.asm : 36 (LDA $0D80, X : CMP.b #$03 : BEQ .invisible)
JML.l FluteBoy
FluteBoy_Abort:
RTS
FluteBoy_Continue:

;org $1E9968 ; <- F1968 - sprite_flute_boy_ostrich.asm : 14 (dw FluteBoyOstrich_Chillin)
;dw #$9991 ; FluteBoyOstrich_RunAway
;--------------------------------------------------------------------------------
org $06B0C9 ; <- 330C9
JSL.l ItemSet_TreeKid
;--------------------------------------------------------------------------------
org $05F177 ; <- 2F177
JSL.l ItemCheck_Sahasrala
;--------------------------------------------------------------------------------
org $05F200 ; <- 2F200
JSL.l ItemSet_Sahasrala
;--------------------------------------------------------------------------------
org $1DE102 ; <- EE102
JSL.l ItemCheck_Catfish
org $1DE11C ; <- EE11C
JSL.l ItemCheck_Catfish
;--------------------------------------------------------------------------------
org $1DE1A1 ; <- EE1A1 - sprite_great_catfish.asm : 445
JSL.l LoadCatfishItemGFX
NOP #2
;--------------------------------------------------------------------------------
org $1DDF49 ; <- EDF49 - sprite_great_catfish.asm : 19
JML.l JumpToSplashItemTarget : NOP
org $1DDF4E ; <- EDF4E - sprite_great_catfish.asm : 21
SplashItem_SpawnSplash:
org $1DDF52 ; <- EDF52 - sprite_great_catfish.asm : 27
SplashItem_SpawnOther:
org $1DE228 ; <- EE228 - sprite_great_catfish.asm : 290
LDA.b #$FF
;--------------------------------------------------------------------------------
org $1DDF81 ; <- EDF81 - sprite_great_catfish.asm : 61
JSL.l DrawThrownItem
;--------------------------------------------------------------------------------
;org $1DE1B0 ; <- EE1B0 - sprite_great_catfish.asm : 461
;NOP #2
;--------------------------------------------------------------------------------
org $05EE53 ; <- 2EE53 - mushroom.asm : 22
JSL.l ItemCheck_Mushroom
NOP #2
;--------------------------------------------------------------------------------
org $05EE8C ; <- 2EE8C - mushroom.asm : 69
JSL.l ItemSet_Mushroom
NOP
;--------------------------------------------------------------------------------
org $05F53E ; <- 2F53E - sprite_potion_shop.asm : 40
JSL.l ItemCheck_Powder
CMP.b #$20
;--------------------------------------------------------------------------------
; the quake medallion AND FLIPPERS
org $1DDF71 ; <- EDF71 - sprite_great_catfish.asm : 47
JSL.l MarkThrownItem
;--------------------------------------------------------------------------------
;org $05F65D ; <- 2F65D - DONE IN INVENTORY
;JSL.l ItemSet_Powder
;NOP #2
;--------------------------------------------------------------------------------
;JSL.l ItemCheck_RupeeNPC
;--------------------------------------------------------------------------------
;JSL.l ItemSet_RupeeNPC
;--------------------------------------------------------------------------------
;org $08D01B ; PC 0x4501B - ancilla_flute.asm - 55
;JSL.l ItemSet_Flute
;--------------------------------------------------------------------------------
org $05FAFF ; <- 2FAFF - sprite_mad_batter.asm:57 (LDA $7EF37B : CMP.b #$01 : BCS .magic_already_doubled)
JSL.l ItemCheck_MagicBat : BEQ + : RTS : NOP : +
;================================================================================


;================================================================================
; Boss Hearts
;--------------------------------------------------------------------------------
org $05EF5D ; <- 2EF5D - sprite_heart_upgrades.asm:110 (JSL GetAnimatedSpriteTile.variable)
JSL.l HeartContainerSpritePrep
;--------------------------------------------------------------------------------
org $05EF79 ; <- 2EF79 - sprite_heart_upgrades.asm:128 (JSL Sprite_PrepAndDrawSingleLargeLong)
JSL.l DrawHeartContainerGFX
;--------------------------------------------------------------------------------
org $05EFCE ; <- 2EFCE - sprite_heart_upgrades.asm:176 (JSL Link_ReceiveItem)
;org $05EFEE ; <- 2EFEE - sprite_heart_upgrades.asm:202 (JSL Link_ReceiveItem)
JSL.l HeartContainerGet
;--------------------------------------------------------------------------------
;--------------------------------------------------------------------------------
org $0799B1 ; 399B1 - Bank07.asm:4063 (CPY.b #$3E : BNE .notHeartContainer)
JSL.l HeartContainerSound
BCC Link_ReceiveItem_notHeartContainer
; JSR Player_DoSfx3
org $0799BA ; 399BA - Bank07.asm:4070 (LDA.b #$60 : STA $02D9)
Link_ReceiveItem_notHeartContainer:
;--------------------------------------------------------------------------------
org $09887F ; <- 4887F - ancilla_init.asm : 1163 (LDA $0C5E, X : CMP.b #$3E : BEQ .doneWithSoundEffects)
JSL NormalItemSkipSound
NOP
BCS AddReceivedItem_doneWithSoundEffects
org $0988AE ; <- 488AE - ancilla_init.asm : 1193 (LDA.b #$0A : STA $02)
AddReceivedItem_doneWithSoundEffects:
;================================================================================
; Heart Pieces
;--------------------------------------------------------------------------------
org $05F030 ; <- 2F030 - display item
JSL.l DrawHeartPieceGFX
;--------------------------------------------------------------------------------
org $05F08A ; <- 2F08A - sprite_heart_upgrades.asm : 324 - (LDA $7EF36B : INC A : AND.b #$03 : STA $7EF36B : BNE .got_4_piecese) item determination
JSL.l HeartPieceGet
BCS $18 ; reinsert the near branch that appears midway through what we overrode
NOP #22
;--------------------------------------------------------------------------------
org $06C0B0 ; <- 340B0 - sprite prep
JSL.l HeartPieceSpritePrep
;--------------------------------------------------------------------------------
org $08C45B ; <- 4445B - ancilla_receive_item.asm : 152
JSL.l HPItemReset
;--------------------------------------------------------------------------------
org $05EF1E ; <- 2EF1E - sprite_heart_upgrades.asm : 48 (LDA $7EF280, X : AND.b #$40 : BEQ .dont_self_terminate)
JSL.l HeartUpgradeSpawnDecision
;--------------------------------------------------------------------------------
org $05EFFA ; <- 2EFFA - sprite_heart_upgrades.asm : 216 (LDA $7EF280, X : ORA.b #$40 : STA $7EF280, X)
JSL.l SaveHeartCollectedStatus
NOP #6
;================================================================================

;================================================================================
; Fake Flippers Softlock Fix + General Damage Hooks
;--------------------------------------------------------------------------------
org $078091 ; <- 38091 - Bank07.asm:138 (LDA $037B : BNE .linkNotDamaged)
LDA $0373 : STA $00 : STZ $0373 ; store and zero damage
LDA $037B : BNE LinkDamaged_linkNotDamaged ; skip if immune
;--------------------------------------------------------------------------------
org $0780C6 ; <- 380C6 - Bank07.asm:174 (LDA $7EF36D)
JSL.l OnLinkDamaged
;--------------------------------------------------------------------------------
org $0780FB ; <- 380FB - Bank07.asm:207 (.linkNotDamaged)
LinkDamaged_linkNotDamaged:
;--------------------------------------------------------------------------------
org $0794FB ; <- 394FB - Bank07.asm:3336 (LDA.b #$14 : STA $11)
JSL.l OnLinkDamagedFromPit
;--------------------------------------------------------------------------------
org $01FFE7 ; <- FFE7 - Bank01.asm:16375 (LDA $7EF36D)
JSL.l OnLinkDamagedFromPitOutdoors
;--------------------------------------------------------------------------------
org $078F27 ; <- 38F27
JSL.l FlipperReset
;--------------------------------------------------------------------------------
org $09F40B ; <- 4F40B - module_death.asm:222 (LDX.b #$00)
JSL.l IgnoreFairyCheck
;--------------------------------------------------------------------------------
org $078F51 ; <- 38F51 - Bank07.asm:2444 (JSR $AE54 ; $3AE54 IN ROM)
JSL.l OnEnterWater : NOP
;--------------------------------------------------------------------------------

;================================================================================
; Floodgate Softlock Fix
;--------------------------------------------------------------------------------
org $0AB8E5 ; <- 538E5
JSL.l FloodGateAndMasterSwordFollowerReset
JSL.l IncrementFlute
STZ $1000 : STZ $1001
NOP #26
;--------------------------------------------------------------------------------
org $02AA87 ; <- 12A87
JSL.l OnOWTransition
NOP #36

;================================================================================
;Inverted mode tile map update (executed right after the original tile load)
;--------------------------------------------------------------------------------
org $02ED51 ; <- 16D51
JSL.l Overworld_LoadNewTiles
NOP #$02
;--------------------------------------------------------------------------------
;Same as above
org $02EC2E ;<- 016C2E
JSL.l Overworld_LoadNewTiles
NOP #$02
;================================================================================
org $07A3E2 ;<- 3A3E2 Bank07.asm:5764 (LDA.b #$80 : STA $03F0)
JSL.l FreeDuckCheck : BEQ +
	NOP
	skip 3 ; a JSR we need to keep
+
;================================================================================
org $07A9AC ; <- 3A9AC - Bank07.asm:6628 (LDA $0C : ORA $0E : STA $00 : AND.b #$0C : BEQ BRANCH_BETA)
JML.l MirrorBonk
MirrorBonk_NormalReturn:
org $07A9D1 ; <- 3A9D1 - Bank07.asm:6649 (BRANCH_GAMMA:)
MirrorBonk_BranchGamma:
;================================================================================

;================================================================================
; Add SFX
;--------------------------------------------------------------------------------
org $1DFDA8 ; <- EFDA9 - sprite_digging_game_guy.asm:309 (STA $7FFE00)
JSL.l SpawnShovelGamePrizeSFX
;--------------------------------------------------------------------------------
;org $01EEB6 ; <- EEB6 - Bank01.asm:14138 (ORA.b #$40 : STA $0403)
org $01EECD ; <- EECD - Bank01.asm:14160 (LDA.b #$0E : STA $012F)
JSL.l SpawnChestGamePrizeSFX : NOP
;================================================================================

;================================================================================
; Heart Beep Timer
;--------------------------------------------------------------------------------
org $0DDC9B ; <- 6DC9B
JSL.l BeepLogic
NOP #6
;================================================================================

;================================================================================
; Item Downgrade Fix
;--------------------------------------------------------------------------------
org $09865E ; <- 4865E
JSL.l $1BEE1B ; fix something i wrote over i shouldn't have
;--------------------------------------------------------------------------------
org $098638 ; <- 48638 - ancilla_init.asm:737 - LDA .item_values, Y : BMI .dontWrite (BMI)
JSL.l ItemDowngradeFix
;================================================================================

;================================================================================
; Lamp Mantle & Light Cone Fix
;--------------------------------------------------------------------------------
org $1AFC4D ; <- D7C4D - sprite_movable_mantle.asm:31 (LDA $7EF3CC : CMP.b #$01 : BNE .return)
JSL.l CheckForZelda
;--------------------------------------------------------------------------------
org $1AFC55 ; <- D7C55 - sprite_movable_mantle.asm:34 (LDA $7EF34A : BEQ .return)
NOP #6 ; remove check
;--------------------------------------------------------------------------------
org $068841 ; <- 30841 - sprite_prep.asm:269 (LDA $0D00, X : ADD.b #$03 : STA $0D00, X)
JSL.l Mantle_CorrectPosition : NOP #2
;--------------------------------------------------------------------------------
org $0DFA53 ; <- 6FA53 - hud check for lantern
JSL.l LampCheck
;--------------------------------------------------------------------------------
org $01F503 ; <- F503 - Bank01.asm:14994 (LDA.b #$01 : STA $1D)
JSL.l SetOverlayIfLamp
;================================================================================

;================================================================================
; Overworld Door Frame Overlay Fix
;
; When entering an overworld entrance, if it is an entrance to a simple cave, we
; store the overworld door id, then use that (instead of the cave id) to determine the
; overlay to draw when leaving the cave again. We also use this value to
; identify the tavern entrance to determine whether link should walk up or down.
;--------------------------------------------------------------------------------
org $1BBD5F ; <- Bank1b.asm:296 (LDA $1BBB73, X : STA $010E)
JSL.l StoreLastOverworldDoorID
NOP #3
;--------------------------------------------------------------------------------
org $02D754 ; <- Bank02.asm:10847 (LDA $D724, X : STA $0696 : STZ $0698)
JSL.l CacheDoorFrameData
NOP #5
;--------------------------------------------------------------------------------
org $0298AD ; <- Bank02.asm:4495 (LDA $010E : CMP.b #$43)
JSL.l WalkDownIntoTavern
NOP #1
;================================================================================

;================================================================================
; Hole fixes
;--------------------------------------------------------------------------------
org $1BB88E ; <- DB88E - Bank1B.asm:59 (LDX.w #$0024)
JML.l CheckHole
org $1BB8A4 ; <- DB8A4 - Bank1B.asm:78 (LDX.w #$0026)
Overworld_Hole_GotoHoulihan:
org $1BB8AF ; <- DB8AF - Bank1B.asm:85 (.matchedHole)
Overworld_Hole_matchedHole:
org $1BB8BD ; <- DB8BD - Bank1B.asm:85 (PLB)
Overworld_Hole_End:

;--------------------------------------------------------------------------------


;================================================================================
; Music fixes
;--------------------------------------------------------------------------------
org $0282F4 ; <- Bank02.asm:654 (LDY.b #$58 ...)
JML.l PreOverworld_LoadProperties_ChooseMusic
org $028389  ; <- Bank02.asm:763
PreOverworld_LoadProperties_SetSong:
;--------------------------------------------------------------------------------
org $05CC58 ; <- Bank05.asm:1307 (LDA $040A : CMP.b #$18)
JSL PsychoSolder_MusicCheck
NOP #1
;================================================================================

;================================================================================
; Hooks for roomloading.asm
;--------------------------------------------------------------------------------
org $02895D ; <- Bank02.asm:1812 (JSL Dungeon_LoadRoom)
    JSL LoadRoomHook
;--------------------------------------------------------------------------------
org $028BE7 ; <- Bank02.asm:2299 (JSL Dungeon_LoadRoom)
    JSL LoadRoomHook_noStats
;--------------------------------------------------------------------------------
org $029309 ; <- Bank02.asm:3533 (JSL Dungeon_LoadRoom)
    JSL LoadRoomHook_noStats
;--------------------------------------------------------------------------------
org $02C2F3 ; <- Bank02.asm:10391 (JSL Dungeon_LoadRoom)
    JSL LoadRoomHook_noStats
;================================================================================

;================================================================================
; Hooks into the "Reloading all graphics" routine
;--------------------------------------------------------------------------------
org $00E64D ; <- Bank00.asm:5656 (STZ $00 : STX $01 : STA $02)
    JML BgGraphicsLoading
    BgGraphicsLoadingCancel:
    RTS : NOP
    BgGraphicsLoadingResume:
;================================================================================

;================================================================================
; Hook when updating the floor tileset in dungeons (such as between floors)
;--------------------------------------------------------------------------------
org $00DF62 ; <- Bank00.asm:4672 (LDX.w #$0000 : LDY.w #$0040)
    JML ReloadingFloors
    NOP : NOP
    ReloadingFloorsResume:
org $00DF6E ; <- A few instructions later, right after JSR Do3To4High16Bit
    ReloadingFloorsCancel:
;================================================================================

;================================================================================
; Hook bow use - to use rupees instead of actual arrows
;--------------------------------------------------------------------------------
org $07A055 ; <- Bank07.asm:5205 (LDA $0B99 : BEQ BRANCH_DELTA)
JSL.l ArrowGame : NOP #14

org $07A06C ; <- Bank07.asm:5215 (LDA $7EF377 : BEQ BRANCH_EPSILON)
JSL.l DecrementArrows : SKIP 2 : NOP : LDA $7EF377
;================================================================================

;================================================================================
; Quick Swap
;--------------------------------------------------------------------------------
org $0287FB ; <- 107FB - Bank02.asm:1526 (LDA $F6 : AND.b #$40 : BEQ .dontActivateMap)
JSL.l QuickSwap

org $02A451 ; <- 12451 - Bank02.asm:6283 (LDA $F6 : AND.b #$40 : BEQ .xButtonNotDown)
JSL.l QuickSwap
;================================================================================

;================================================================================
; Tagalong Fixes
;--------------------------------------------------------------------------------
org $0689AB ; <- 309AB - sprite_prep.asm: 647 (LDA $7EF3CC : CMP.b #$06 : BEQ .killSprite)
; Note: In JP 1.0 we have: (CMP.b #$00 : BNE .killSprite) appling US bugfix
; Prevent followers from causing blind/maiden to despawn:
CMP.b #$06 : db #$F0 ; BEQ
;--------------------------------------------------------------------------------
; Fix old man purple chest issues using the same method as above
org $1EE906 ; <- F6906 - sprite_old_mountain_man.asm : 31 (LDA $7EF3CC : CMP.b #$00 : BNE .already_have_tagalong)
CMP.b #$04 : db #$F0 ; BEQ
;--------------------------------------------------------------------------------
;Control which doors frog/smith can enter
org $1BBCF0 ; <- DBCF0 - Bank1B.asm: 248 (LDA $04B8 : BNE BRANCH_MU)
Overworld_Entrance_BRANCH_LAMBDA: ; Branch here to show Cannot Enter with Follower message

org $1BBD55 ; <- DBD55 - Bank1B.asm: 290 (CPX.w #$0076 : BCC BRANCH_LAMBDA)
JML.l SmithDoorCheck : NOP
Overworld_Entrance_BRANCH_RHO: ; branch here to continue into door
;================================================================================

;================================================================================
; Paradox Cave Shopkeeper Fixes
;--------------------------------------------------------------------------------
org $008C19 ; Bank00.asm@1633 (LDA.b #$01 : STA $420B)
JSL ParadoxCaveGfxFix
NOP
;================================================================================

;================================================================================
; Player Sprite Fixes
;--------------------------------------------------------------------------------
org $0DA9C8 ; <- 06A9C8 - player_oam.asm: 1663 (AND.w #$00FF : CMP.w #$00F8 : BCC BRANCH_MARLE)
; We are converting this branching code that basically puts the carry from the
; CMP into $02 into constant time code, so that player sprite head-bobbing can
; be removed by sprites while remaining race legal (cycle-for-cycle identical
; to the link sprite).
LDA $02 ; always zero! (this replaces the BCC)
ADC.w #0000 ; put the carry bit into the accumulator instead of a hardcoded 1.
;================================================================================

;================================================================================
; Chest Encryption
;--------------------------------------------------------------------------------
org $01EBEB ; <- 0EBEB - bank01.asm : 13760 (INC $0E)
JML.l GetChestData : NOP
org $01EBDE ; <- 0EBDE - bank01.asm : 13740 (.couldntFindChest)
Dungeon_OpenKeyedObject_couldntFindChest:
org $01EBF0 ; <- 0EBF0 - bank01.asm : 13764 (.nextChest)
Dungeon_OpenKeyedObject_nextChest:
org $01EC14 ; <- 0EC14 - bank01.asm : 13783 (LDX $040C)
Dungeon_OpenKeyedObject_bigChest:
org $01EC38 ; <- 0EC38 - bank01.asm : 13809 (.smallChest)
Dungeon_OpenKeyedObject_smallChest:
;================================================================================
