;================================================================================
; Init Hook
; this needs to be a JML, otherwise we're not using fast ROM when we return
;--------------------------------------------------------------------------------
org $80802F
JML Init_Primary
NOP
ReturnFromInit:

org $8CC1AC ; <- 63 D4 00 - Bank0C.asm:8 (dl Tagalong_LoadGfx)
dl Init_PostRAMClear
;--------------------------------------------------------------------------------

;================================================================================
; Frame Hook
;--------------------------------------------------------------------------------
org $808056 ; <- 56 - Bank00.asm : 77
JSL FrameHookAction
;--------------------------------------------------------------------------------
org $80805D
JML HandleOneMindController

;================================================================================
; NMI Hook
;--------------------------------------------------------------------------------
org $8080CC ; <- CC - Bank00.asm : 164 (PHA : PHX : PHY : PHD : PHB)
JML NMIHookAction

NMIHookReturn = $8080D0
;--------------------------------------------------------------------------------
org $80821B ; <- 21B - Bank00.asm : 329 (LDA $13 : STA $2100)
JML PostNMIHookAction : NOP
PostNMIHookReturn:
;--------------------------------------------------------------------------------

;================================================================================
; Anti-ZSNES Hook
;--------------------------------------------------------------------------------
org $808023 ;<- 23 - Bank00.asm : 36 (LDA.w #$01FF : TCS)
JML CheckZSNES
ReturnCheckZSNES:
;--------------------------------------------------------------------------------

;================================================================================
; Ok so basically, in rare cases, major glitches may try to read far into the
; A bus until they reach a value of $FFFF
; For maximum security of vanilla behavior, I am reserving this space
; that could otherwise be considered free ROM.
;--------------------------------------------------------------------------------
org $8089C2
dw $FFFF, $FFFF, $FFFF, $FFFF
dw $FFFF, $FFFF, $FFFF, $FFFF
dw $FFFF, $FFFF, $FFFF, $FFFF

;===================================================================================================
; fastrom interrupts
;===================================================================================================
org $00FFEA : dw NMIBounce
org $00FFEE : dw IRQBounce

org $8098AB
NMIBounce: JML.l $8080C9
IRQBounce: JML.l $8082D8
warnpc $8098C0

;================================================================================
; BSOD for BRK and COP opcodes
;--------------------------------------------------------------------------------
org $80FFB7
SoftwareInterrupt:
JML Crashed

org $80FFE4
dw SoftwareInterrupt
org $80FFE6
dw SoftwareInterrupt
org $80FFF4
dw SoftwareInterrupt

;================================================================================
; Dungeon Entrance Hook (works, but not needed at the moment)
;--------------------------------------------------------------------------------
org $82D8C7 ; <- 158C7 - Bank02.asm : 10981 (STA $7EC172)
JSL OnDungeonEntrance
;--------------------------------------------------------------------------------

;================================================================================
; D-Pad Invert
;--------------------------------------------------------------------------------
org $8083D1 ; <- 3D1 - Bank00.asm (STZ.w JOYPAD - useless instruction here)
JML InvertDPad : SKIP 9
InvertDPadReturn:
;--------------------------------------------------------------------------------

;================================================================================
; Enable/Disable Boots
;--------------------------------------------------------------------------------
org $879C22 ; <- 39222 - Bank07.asm : 4494 (AND $7EF379 : BEQ .cantDoAction)
JSL ModifyBoots
;--------------------------------------------------------------------------------

;================================================================================
; Enable/Disable Bonk Tremors
;--------------------------------------------------------------------------------
org $879202 ; 39202 <- Bank07.asm : 2859 (JSL AddDashTremor : JSL Player_ApplyRumbleToSprites)
JSL AddBonkTremors : NOP #4
;--------------------------------------------------------------------------------

;================================================================================
; Bonk Breakable Walls
;--------------------------------------------------------------------------------
org $81CF8E ; CF8E <- Bank01.asm : 11641 (LDA $0372 : AND.w #$00FF)
JSL BonkBreakableWall : NOP #2
;--------------------------------------------------------------------------------

;================================================================================
; Bonk Rock Pile
;--------------------------------------------------------------------------------
org $87C196 ; 3C196 <- Bank07.asm : 10310 (LDA $02EF : AND.b #$70)
JSL BonkRockPile : NOP
;--------------------------------------------------------------------------------

;================================================================================
; Move Gravestone
;--------------------------------------------------------------------------------
org $87C0FD ; 3C0FD <- Bank07.asm : 10197 (LDA $0372 : BNE .moveGravestone)
JML GravestoneHook : NOP
GravestoneHook_continue:
org $87C106
moveGravestone:
;--------------------------------------------------------------------------------

;================================================================================
; Jump Down Ledge
;--------------------------------------------------------------------------------
org $878966 ; 38966 <- Bank07.asm : 1618 (LDA $1B : BNE .indoors : LDA.b #$02 : STA $EE)
JSL JumpDownLedge : NOP #4
;--------------------------------------------------------------------------------

;================================================================================
; Bonk Recoil
;--------------------------------------------------------------------------------
org $87922C ; 3922C <- Bank07.asm : 2869 (LDA.b #$24 : STA $29)
JSL BonkRecoil
;--------------------------------------------------------------------------------

;================================================================================
; Dungeon Exit Hook
;--------------------------------------------------------------------------------
org $82E21B ; <- 1621B - Bank02.asm : 11211 (STA $040C)
JSL.l OnDungeonExit : NOP #2

; change data bank to our new tables
; this fits exactly, so we can't put anything else in here
org $82E238
JSL FindOutletID
PEA.w NewOutletData>>8 ; push upper 16 bits
PLB
PLB

; it seems safe to leave X in 16 bit for all of this, as nothing scary happens with X
; and by the time it is needed, there's a SEP #$30
; update pointers to new data
org $82E241 : LDA.w NewOutletData_vertical_scroll,X
org $82E24E : LDA.w NewOutletData_horizontal_scroll,X
org $82E25B : LDA.w NewOutletData_y_coordinate,X
org $82E260 : LDA.w NewOutletData_x_coordinate,X
org $82E265 : LDA.w NewOutletData_exit_vram_addr,X
org $82E281 : LDA.w NewOutletData_camera_trigger_y,X
org $82E28C : LDA.w NewOutletData_camera_trigger_x,X
org $82E29C : LDA.w NewOutletData_door_graphic,X
org $82E2A2 : LDA.w NewOutletData_door_graphic_location,X
org $82E2AD : LDA.w NewOutletData_overworld_id,X
org $82E2BA : LDA.w NewOutletData_scroll_mod_y,X
org $82E2C9 : LDA.w NewOutletData_scroll_mod_x,X

;--------------------------------------------------------------------------------

;================================================================================
; Quit Hook (for both types of save and quit)
;--------------------------------------------------------------------------------
org $89F60B ; <- 4F60B - module_death.asm : 530 (LDA.b #$10 : STA $1C)
JSL OnQuit
;--------------------------------------------------------------------------------

;================================================================================
; Title Screen
;--------------------------------------------------------------------------------
org $8CCDA5 ; <- Bank0C.asm : 1650 (JSL Palette_SelectScreen)
JSL SetFileSelectPalette
;--------------------------------------------------------------------------------
org $8CCE41 ; <- 64E41 - Bank0C.asm : 1907 (DEC $C8 : BPL .done)
JSL FSCursorUp : NOP #4 ; set cursor to only select first file and erase
org $8CCE50 ; <- 64E50 - Bank0C.asm : 1918 (INC $C8)
JSL FSCursorDown : NOP #6 ; set cursor to only select first file and erase
org $8CCE0F ; < 64E0F - Bank0C.asm : 1880 (LDX $00 : INX #2 : CPX.w #$0006 : BCC .nextFile)
NOP #9 ; don't draw the other two save files
;--------------------------------------------------------------------------------
org $8CCE71 ; <- Bank0C.asm : 1941 (LDA.b #$F1 : STA $012C)
JML FSSelectFile : NOP
FSSelectFile_continue:
FSSelectFile_return = $8CCEB1
;--------------------------------------------------------------------------------
; Replace copy file module with a fully custom module
org $808061+$02 ; <- Bank00.asm : 103 (dl Module_CopyFile)
db Module_Password
org $80807D+$02 ; <- Bank00.asm : 103 (dl Module_CopyFile)
db Module_Password>>8
org $808099+$02 ; <- Bank00.asm : 103 (dl Module_CopyFile)
db Module_Password>>16

; Hook up password screen tilemap
org $80937A+$07
db Password_Tilemap
org $809383+$07
db Password_Tilemap>>8
org $80938C+$07
db Password_Tilemap>>16
;--------------------------------------------------------------------------------
org $8CD527 ; <- 65527 : Bank0C.asm : 2913 (LDA.w #$0004 : STA $02) [LDA.w #$0006 : STA $02]
JSL DrawPlayerFile : NOP ; hijack hearts draw routine to draw a full inventory

org $8CCDD5 ; Bank0C.asm:1881 (LDX.w #$00FD)
JSL AltBufferTable : NOP #8 ; Selection screen
org $8CD393 ; Bank0c.asm:2674 (LDX.w #$00FD)
JSL AltBufferTable : NOP #8 ; Delete screen
;--------------------------------------------------------------------------------
org $8CCCCC ;<- 64CCC - Bank0C.asm : 1628 (JSL Intro_ValidateSram) / Bank02.asm : 75 (REP #$30)
; Explanation: In JP 1.0 the code for Intro_ValidateSram was inline in Bank 0C
JML ValidateSRAM ;(Return via RTL. Original code JML'd to Intro_LoadSpriteStats which returns with RTL, but we want to skip that)
org $8CCD57 ;<- 64D57 - Bank0C.asm :
RTL ;Just in case anybody ever removes the previous hook
;--------------------------------------------------------------------------------
org $80E55D ; <- 0655D - Bank00.asm : 5473 (LDA.w #$7000 : STA $2116)
LDA.w #$2000 ; Load file select screen graphics to VRAM word addres 0x2000 instead of 0x7000
;--------------------------------------------------------------------------------
org $80E568 : LDX.w #$0EFF ; Load full decompressed character set into VRAM
;--------------------------------------------------------------------------------
org $80E581 : JSL.l LoadFileSelectVanillaItems : BRA + : NOP #13 : +
;--------------------------------------------------------------------------------
org $80833A ; <- 0033A - Bank00.asm : 481 (LDA.w #$007F)
LDA.w #$0180 ; change which character is used as the blank character for the select screen
;--------------------------------------------------------------------------------
org $8CD50C ; <- 6550C  (Not in disassembly, would be in bank0c.asm if it were) Position table for Name and Hearts
dw $00CC, $014A, $01CA ; repositioned, only the first value matters
dw $002A, $0192, $0112
org $8CD53B ; <- 6553B : Bank0c.asm : 2919 (ADD.w #$0010 : STA $102C, Y) [... : STA $1034, Y]
STA.w $1042, Y ; Make 2nd half of names line up properly
org $8CD540 ; <- 65540 : Bank0c.asm : 2923 (INY #2) [INY #4]
NOP #2 ; Remove space between name characters
org $8CD571 ; <- 65571 : Bank0c.asm : 2943 (LDA $04 : ADD.w #$002A : TAY) [... : ADD.w #$0032 : ...]
ADC.w #$0040 ;make Hearts line up properly
;--------------------------------------------------------------------------------
org $8CCC67 ; <- Y position table for File select fairy
db $42, $00, $00, $AF, $C7
org $8CD308 ; <- Y position table for File Delete fairy
db $42, $00, $00, $C7
org $8CD57E ; <- Y position table for File select link sprite
db $3D
org $8CD6BD ; <- Y position table for Death Counts
db $51
;--------------------------------------------------------------------------------
org $8CD55F : JSL.l CheckHeartPaletteFileSelect : NOP #2

;================================================================================
; Name Entry Screen
;--------------------------------------------------------------------------------
org $8CD7BE ; <- 657BE : Bank0C.asm : 3353 (STA $7003D9, X)
JSL WriteBlanksToPlayerName
org $8CDB11 ; <- 65B11 : Bank0C.asm : 3605 (LDA $00 : AND.w #$FFF0 : ASL A : ORA $02 : STA $7003D9, X)
JSL WriteCharacterToPlayerName
org $8CDCA9 ; <- 65CA9 : Bank0C.asm : 3853 (LDA $7003D9, X)
JSL ReadCharacterFromPlayerName
org $8CDC90 ; <- 65C90 : Bank0C.asm : 3847 (ORA $DD24, Y) [ORA $DC82, Y]
JSL GetCharacterPosition
org $8CDA79 ; <- 65A79 : Bank0C.asm : 3518 (LDA $0CDA13, X : STA $0800, Y) [LDA $0CD98F, X : ...]
LDA.l HeartCursorPositions, X
org $8CDAEB ; <- 65AEB : Bank0C.asm : 3571-3575,3581-3587 (...) [LDA $0B12 : AND #$03]
; JP here is different. Indicated line number implement the US version of the same functionality
JSL WrapCharacterPosition : NOP
org $8CD75E ; bank_0C.asm (dl NameFile_MakeScreenVisible)
dl MaybeForceFileName
;--------------------------------------------------------------------------------
org $8CE43A ; No assembly source. Makes name entry box wider
db $2C
org $8CE448
db $2D, $40, $1E
org $8CE45C
db $4D, $40, $1E
org $8CE462
db $6D, $40, $1E
org $8CE468
db $8D, $40, $1E
org $8CE46E
db $AD, $40, $1E
;--------------------------------------------------------------------------------
org $8CE41A
; Fix name screen background to use the not-overwritten copy of its graphics
db $09 : SKIP 5 : db $09 : SKIP 5 : db $09 : SKIP 5 : db $09 : SKIP 5 : db $09 : SKIP 5
db $09 : SKIP 5 : db $49 : SKIP 1 : db $49 : SKIP 1 : db $49 : SKIP 1 : db $49 : SKIP 1
db $C9 : SKIP 5 : db $09 : SKIP 5 : db $09 : SKIP 1 : db $09 : SKIP 1 : db $09 : SKIP 1
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
org $8CD435 ; <- 65435 - Bank0C.asm : 2772 (LDX.b #$64) [LDX.b #$50]
LDX.b #$44
LDA.w $D324, X
org $8CD446 ; <- 65446 - Bank0C.asm : 2782 (LDX $C8 : CPX.b #$02 : BEQ BRANCH_11)
db $80 ; BRA
;--------------------------------------------------------------------------------

;================================================================================
; Remove Mirrored copy of save file
;--------------------------------------------------------------------------------
; Saving to mirrored copy
org $80895D ; <- 0095D - Bank00.asm : 1286 (LDA $7EF000, X : STA $0000, Y : STA $0F00, Y)
SKIP 7 : NOP #3
SKIP 7 : NOP #3
SKIP 7 : NOP #3
SKIP 7 : NOP #3
SKIP 7 : NOP #3
;--------------------------------------------------------------------------------
; remove Clearing mirrored copy on file erase, instead clearing the extended save file too
org $8CD4E3 ; <- Bank0C.asm : 2282 (STA $700400, X : STA $700F00, X : STA $701000, X : STA $701100, X)
JSL ClearExtendedSaveFile
BRA + : NOP #18 : +
;--------------------------------------------------------------------------------

;================================================================================
; Extended SRAM Save file
;--------------------------------------------------------------------------------
org $8CCF08 ; <- Bank0C.asm : 2036 (LDA.w #$0007 : STA $7EC00D : STA $7EC013)
JSL CopyExtendedSaveFileToWRAM
;--------------------------------------------------------------------------------
org $808998 ; <- Bank00.asm : 1296 (LDX.w #$0000)
JSL CopyExtendedWRAMSaveFileToSRAM
;--------------------------------------------------------------------------------
org $80899C ; <- bank_00.asm : #_00899C (CLC)
JSL WriteSaveChecksumAndBackup
PLA : SEP #$30 : PLB : RTL
padbyte $FF : pad $0089C2 ; Fill adjacent free rom forward. See bank_00.asm: #_0089C2
;--------------------------------------------------------------------------------
org $8CD7AB ; <- Bank0C.asm : 3342 (STA $700400, X)
JSL ClearExtendedSaveFile
;--------------------------------------------------------------------------------
org $8CC2EB ; <- Bank0C.asm : 348 (STA $7EF000, X : STA $7EF100, X : STA $7EF200, X : STA $7EF300, X : STA $7EF400, X)
JSL ClearExtendedWRAMSaveFile
;--------------------------------------------------------------------------------
org $89F653 ; <- module_death.asm : 556 (STA $7EF400, X)
JSL ClearExtendedWRAMSaveFile
;--------------------------------------------------------------------------------

;================================================================================
; Remove storage of selected file index from end of vanilla SRAM
;--------------------------------------------------------------------------------
org $8087EB ; <- Bank00.asm : 986 (STA $7EC500 : STA $701FFE)
BRA AfterFileWrittenChecks
;Also skip totally redundant checking and clearing the "file written" marker,
;since it is not even useful in the original code, much less with only one save slot
org $80881F ; <- Bank00.asm : 1011 (STY $01FE)
AfterFileWrittenChecks:
;--------------------------------------------------------------------------------
org $808951 ; <- Bank00.asm : 1278 (LDX $1FFE : LDA $00848A, X : TAY : PHY)
LDX.w #$0002
;--------------------------------------------------------------------------------
org $8CCE85 ; <- Bank0C.asm : 1953 (LDA $C8 : ASL A : INC #2 : STA $701FFE)
NOP #4
;--------------------------------------------------------------------------------
org $8CDB4C ; <- Bank0C.asm : 3655 (LDA $C8 : ASL A : INC #2 : STA $701FFE : TAX)
JML OnFileCreation : NOP
;--------------------------------------------------------------------------------
org $89F5EA ; <- module_death.asm : 510 (LDA $701FFE : TAX : DEX #2)
LDA.w #$0002 : NOP
;--------------------------------------------------------------------------------
org $8EEFEB ; <- vwf.asm : 310 (LDA $701FFE : TAX)
LDA.w #$0002 : NOP
;--------------------------------------------------------------------------------

;================================================================================
; Cross World Damage fixes
;--------------------------------------------------------------------------------
org $868891 ; Sprite_Prep.asm : 378 //LDA .damage_class, Y : STA $0CD2, X
NOP #8
JSL NewBatInit

;================================================================================
; Damage table Relocation from WRAM
;--------------------------------------------------------------------------------
org $86EDB5 ;<- 36DBE - Bank06.asm : 4882 (LDA $7F6000, X : STA $02)
JSL LookupDamageLevel
;--------------------------------------------------------------------------------
org $9EAB5E ;<- F2B5E - sprite_stalfos_knight.asm : 135  (LDA.b #$00 : STA $7F6918)
STA.l StalfosBombDamage
org $9EAAD6 ;<- F2AB6 - sprite_stalfos_knight.asm : 32  (LDA.b #$02 : STA $7F6918)
STA.l StalfosBombDamage
;--------------------------------------------------------------------------------

;================================================================================
; Duck Map Load Hook
;--------------------------------------------------------------------------------
org $8AB76E ; <- 5376E - Bank0A.asm : 30 (JSL OverworldMap_InitGfx)
JSL OnLoadDuckMap

;================================================================================
; Infinite Bombs / Arrows / Magic
;--------------------------------------------------------------------------------
org $88A17A ; <- 4217A - ancilla_arrow.asm : 42 (AND.b #$04 : BEQ .dont_spawn_sparkle)
CMP.b #$03 : db $90 ; !BLT
org $88A40E ; <- 4240E - ancilla_arrow.asm : 331 (AND.b #$04 : BNE .use_silver_palette)
CMP.b #$03 : db $B0 ; !BGE
;--------------------------------------------------------------------------------
org $898127 ; <- 48127 - ancilla_init.asm : 202 (LDA $7EF343 : BNE .player_has_bombs)
JSL LoadBombCount
org $898133 ; <- 48133 - ancilla_init.asm : 211 (STA $7EF343 : BNE .bombs_left_over)
JSL StoreBombCount
;--------------------------------------------------------------------------------
org $8DE4BF ; <- 6E4BF - equipment.asm : 1249 (LDA $7EF343 : AND.w #$00FF : BEQ .gotNoBombs)
JSL LoadBombCount16
;--------------------------------------------------------------------------------
org $8DDEB3 ; <- 6DEB3 - equipment.asm : 328 (LDA $7EF33F, X)
JSL IsItemAvailable
;--------------------------------------------------------------------------------
org $8DDDE8 ; <- 6DDE8 - equipment.asm : 148 (LDA $7EF340)
JSL SearchForEquippedItem
;--------------------------------------------------------------------------------
org $8DDE70 ; <- 6DE70 - equipment.asm : 273 (LDA $7EF340)
JSL SearchForEquippedItem
;--------------------------------------------------------------------------------
org $8DE39D ; <- 6E39D - equipment.asm : 1109 (LDA $7EF340)
JSL SearchForEquippedItem
;--------------------------------------------------------------------------------

;================================================================================
; Inverted Mode
;--------------------------------------------------------------------------------
org $828413 ; <- 10413 - Bank02.asm : 853 (LDA $7EF357 : BNE .notBunny)
NOP #6
JSL DecideIfBunny : db $D0 ; BNE
;--------------------------------------------------------------------------------
org $87AA44 ; <- 3AA44 - Bank07.asm : 853 (LDA $7EF357 : BNE .playerHasMoonPearl)
NOP #6
JSL DecideIfBunnyByScreenIndex : db $D0 ; BNE
;--------------------------------------------------------------------------------
org $82D9B9 ; <- 159B9 - Bank02.asm : 11089  (LDA $7EF3C8)
JSL AllowStartFromSingleEntranceCave
;--------------------------------------------------------------------------------
org $828496 ; <- 15496 - Bank02.asm : 959  (LDA $7EF3C8 : PHA)
JML AllowStartFromExit
AllowStartFromExitReturn:
;--------------------------------------------------------------------------------
org $9BC2A7 ; <- DC2A7 - Bank1B.asm : 1143 (Overworld_CreatePyramidHole:)
JSL Overworld_CreatePyramidHoleModified : RTL
C9DE_LONG:
JSR.w $1BC9DE : RTL ; surprisingly same address as US
;--------------------------------------------------------------------------------
org $87FF5F ; <- 3ff5f - Bank0E.asm : 5252 (LDA.w #$0E3F : STA $23BC)
JSL Draw_PyramidOverlay : RTS
;--------------------------------------------------------------------------------
;Remove Electric Barrier Hook
org $86891E ; <- sprite_prep.asm : 537 (LDA $7EF280, X : PLX : AND.b #$40 : BEQ .not_dead)
JSL Electric_Barrier
;--------------------------------------------------------------------------------
org $88CDAC ; <- ancilla_break_tower_seal.asm : 117 (LDA.b #$05 : STA $04C6)
JSL GanonTowerAnimation : NOP #05
;--------------------------------------------------------------------------------
org $9AF5C1 ; <- sprite_waterfall.asm : 40 (LDA $8A : CMP.b #$43)
JSL GanonTowerInvertedCheck
;--------------------------------------------------------------------------------
org $82EC8D ; <- bank02.asm : 11981 (LDA.w #$020F : LDX $8A : CPX.w #$0033 : BNE .noRock)
JSL HardcodedRocks : NOP #19 ;23 bytes removed with the JSL
;--------------------------------------------------------------------------------
org $84E7AE ; <- bank0E.asm : 4230 (LDA $7EF287 : AND.w #$0020)
JSL TurtleRockPegSolved

org $84E7B9 ; <- bank0E.asm : 4237 (LDX $04C8)
JMP.w TurtleRockTrollPegs
TurtleRockPegCheck:

org $84E7C9
TurtleRockPegSuccess:

org $84E7F5
TurtleRockPegFail:

org $84E96F
PegProbability:
db $00  ; Probability out of 255.  0 = Vanilla behavior
TurtleRockTrollPegs:
SEP #$20
LDX.w $04C8 : CPX.w #$FFFF : BEQ .vanilla
JSL GetRandomInt
LDA.l PegProbability : BEQ .vanilla : CMP.l $7E0FA1
REP #$20 : !BGE .succeed
.fail
JMP.w TurtleRockPegFail
.succeed
JMP.w TurtleRockPegSuccess
.vanilla
REP #$20 : JMP.w TurtleRockPegCheck
;--------------------------------------------------------------------------------
org $9BBD05 ; <- bank1B.asm : 261 (TYA : STA $00) ; hook starts at the STA
JML PreventEnterOnBonk : NOP
PreventEnterOnBonk_return:
org $9BBD77 ; <- bank1B.asm : 308 (SEP #$30)
PreventEnterOnBonk_BRANCH_IX:
;--------------------------------------------------------------------------------

;================================================================================
; Crystals Mode
;--------------------------------------------------------------------------------
org $899B7F ; <- ancilla_init.asm : 4136 (LDA $7EF37A : AND.b #$7F : CMP.b #$7F)
JSL CheckTowerOpen : BCC $899B6D
;--------------------------------------------------------------------------------
org $88CE0C ; <- 44E0C - ancilla_break_tower_seal.asm : 168 (BEQ #$03 : JSR BreakTowerSeal_ExecuteSparkles : LDX.b #$06)
JML GetRequiredCrystalsForTower : NOP #3
GetRequiredCrystalsForTower_continue:
;--------------------------------------------------------------------------------
org $88CF19 ; <- 44F19 - ancilla_break_tower_seal.asm : 336 (TXA : AND.b #$07 : TAX)
JSL GetRequiredCrystalsInX
;--------------------------------------------------------------------------------
org $88CFC9 ; <- 44FC9 - ancilla_break_tower_seal.asm : 414 (RTS)
RTL
;--------------------------------------------------------------------------------

;================================================================================
; Hash Key Display
;--------------------------------------------------------------------------------
org $8CCDB5 ; <- 64DB5 - Bank0C.asm : 1776 (LDA.b #$06 : STA $14)
JSL OnPrepFileSelect

;================================================================================
; Light speed
;--------------------------------------------------------------------------------
; Message
org $9ED4FF
JSL AgahnimAsksAboutPed

; Spam blue balls if ped not pulled
org $9ED6E8
JSL CheckAgaForPed : NOP

;================================================================================
; Zelda Sprite Fixes
;--------------------------------------------------------------------------------
org $85EBCF ; <- 2EBCF - sprite_zelda.asm : 23 (LDA $7EF359 : CMP.b #$02 : BCS .hasMasterSword)
JSL SpawnZelda : NOP #2

;================================================================================
; Alternate Goal
;--------------------------------------------------------------------------------
;Invincible Ganon
org $86F2C8 ; <- 372C8 - Bank06.asm : 5776 (LDA $44 : CMP.b #$80 : BEQ .no_collision)
JSL GoalItemGanonCheck
;--------------------------------------------------------------------------------
;Hammerable Ganon
org $86F2EA ; <- 372EA - Bank06.asm : 5791 (LDA $0E20, X : CMP.b #$D6 : BCS .no_collision)
JSL CheckGanonHammerDamage : NOP
;--------------------------------------------------------------------------------
org $858922
JSL.l CheckPedestalPull : BCC MasterSword_InPedestal_exit

;================================================================================
; Stat Hooks
;--------------------------------------------------------------------------------
org $82B797 ; <- 13797 - Bank02.asm : 8712 (LDA.b #$19 : STA $10)
JSL StatsFinalPrep
;--------------------------------------------------------------------------------
org $87A95B ; <- 3A95B - Bank07.asm : 6565 (JSL Dungeon_SaveRoomDataWRAM)
JSL IncrementUWMirror
;--------------------------------------------------------------------------------
org $8288D1 ; <- 108D1 - Bank02.asm : 1690 (STZ $0646)
JSL IndoorSubtileTransitionCounter : NOP #2
org $86D192 ; <- 35192 - sprite_absorbable.asm : 274 (STA $7EF36F)
JSL IncrementSmallKeysNoPrimary
;--------------------------------------------------------------------------------
org $80F945 ; <- 7945 - Bank00.asm : 8557 (JSL SavePalaceDeaths)
JSL OnDungeonBossExit
;--------------------------------------------------------------------------------
org $89F443 ; <- 4F443 - module_death.asm : 257 (STA $7EF35C, X)
JSL IncrementFairyRevivalCounter
;--------------------------------------------------------------------------------
org $82B6F3 ; <- 136F3 - Bank02.asm : 8600 (LDA.b #$0F : STA $10)
JSL DungeonExitTransition
;--------------------------------------------------------------------------------
org $9BBD6A ; <- DBD6A - Bank1B.asm : 301 (LDA.b #$0F : STA $10)
JSL DungeonExitTransition
;--------------------------------------------------------------------------------
org $81C3A7 ; <- C3A7 - Bank01.asm : 9733 (JSL Dungeon_SaveRoomQuadrantData)
JSL DungeonStairsTransition
;--------------------------------------------------------------------------------
org $8BFFAC ; <- 5FFAC - Bank0B.asm : 170 (JSL Dungeon_SaveRoomQuadrantData)
JSL DungeonStairsTransition
;--------------------------------------------------------------------------------
org $829A17 ; <- 11A17 - Bank02.asm : 4770 (JSL EnableForceBlank)
JSL DungeonHoleEntranceTransition
;--------------------------------------------------------------------------------
org $8794EB ; <- 394EB - Bank07.asm : 3325 (LDA $01C31F, X : STA $0476)
JSL DungeonHoleWarpTransition
;--------------------------------------------------------------------------------
org $8CC999 ; <- 64999 - Bank0C.asm : 1087 (LDA.b #$0F : STA $13)
NOP #4
;--------------------------------------------------------------------------------
org $81ED75 ; <- ED75 - Bank01.asm : 13963 (JSL Dungeon_SaveRoomQuadrantData)
JSL IncrementBigChestCounter
;--------------------------------------------------------------------------------
org $8EE67A : STA.l PostGameCounter : BRA + : NOP #18 : +

;================================================================================
; DialogOverride
;--------------------------------------------------------------------------------
org $8EF1FF : JSL DialogOverride ; DialogOverride
org $8EF2DC : JSL DialogOverride ; DialogOverride
org $8EF315 : JSL DialogOverride ; DialogOverride
org $8EF332 : JSL DialogOverride ; DialogOverride
org $8EF375 : JSL DialogOverride ; DialogOverride
org $8EF394 : JSL DialogOverride ; DialogOverride
org $8EF511 : JSL DialogOverride ; DialogOverride
org $8EF858 : JSL DialogOverride ; DialogOverride
org $8EFA26 : JSL DialogOverride ; DialogOverride
org $8EFA4C : JSL DialogOverride ; DialogOverride
org $8EFAB4 : JSL DialogOverride ; DialogOverride
org $8EFAC8 : JSL DialogOverride ; DialogOverride
org $8EFAE1 : JSL DialogOverride ; DialogOverride
org $8EFB11 : JSL DialogOverride ; DialogOverride
;--------------------------------------------------------------------------------
org $8EFBC6 ; <- 77BC6 - vwf.asm : 2717 (LDA.b #$1C : STA $1CE9)
JSL ResetDialogPointer : RTS
;--------------------------------------------------------------------------------
org $8EED0B ; <- PC 0x76D0B - Bank0E.asm : 3276 (LDA $E924, Y : STA $1008, X)
JSL EndingSequenceTableOverride : NOP #2
;--------------------------------------------------------------------------------
org $8EED15 ; <- PC 0x76D15 - Bank0E.asm : 3282 (LDA $E924, Y : STA $1008, X)
JSL EndingSequenceTableOverride : NOP #2
;--------------------------------------------------------------------------------
org $8EED2A ; <- PC 0x76D2A - Bank0E.asm : 3295 (LDA $E924, Y : AND.w #$00FF)
JSL EndingSequenceTableLookupOverride : NOP #7
;--------------------------------------------------------------------------------

;================================================================================
; Master Sword Overlay Fix
;--------------------------------------------------------------------------------
org $8987B2 ; <- ancilla_init.asm : 1051 (LDA.b #$09)
JSL PedestalPullOverlayFix

org $8987B8 ; <- ancilla_init.asm : 1055 (STA $039F, X)
NOP #3

org $8987DF ; <- ancilla_init.asm : 1077 (STA $039F, X)
NOP #3
;--------------------------------------------------------------------------------

;================================================================================
; File Select Init Event
;--------------------------------------------------------------------------------
org $8CCC89 ; <- 0x64C89 Bank0C.asm : 1598 (JSL EnableForceBlank)
JSL OnInitFileSelect

;================================================================================
; Hyrule Castle Rain Sequence Guards (allowing Gloves in Link's house)
;--------------------------------------------------------------------------------
org $89C8B7 ; <- 4C8B7
dw CastleRainSpriteData

org $89F7BD ; <- 4F7BD
CastleRainSpriteData:
db $06, $1F, $40, $12, $01, $3F, $14, $01, $3F, $13, $1F, $42, $1A, $1F, $4B, $1A, $20, $4B, $25, $2D, $3F, $29, $20, $3F, $2A, $3C, $3F, $FF
;--------------------------------------------------------------------------------

;================================================================================
; Sprite_DrawMultiple
;--------------------------------------------------------------------------------
org $85DFB1 ; <- 2DFB1 - Bank05.asm : 2499
JSL SkipDrawEOR

;================================================================================
; Kiki Big Bomb Fix
;--------------------------------------------------------------------------------
org $9EE4AF ; <- f64af sprite_kiki.asm : 285 (LDA.b #$0A : STA $7EF3CC)
JSL AssignKiki : NOP #2

;================================================================================
; Wallmaster camera fix
;--------------------------------------------------------------------------------
org $9EAF77 ; <- F2F77 sprite_wallmaster.asm : 141 (LDA.b #$2A : JSL Sound_SetSfx3PanLong)
JSL WallmasterCameraFix

;================================================================================
; Hard & Masochist Mode Fixes
;--------------------------------------------------------------------------------
org $87D22B ; <- 3D22B - Bank05.asm : 12752 (LDA $D055, Y : STA $0373)
JSL CalculateSpikeFloorDamage : NOP #2
;--------------------------------------------------------------------------------
org $88DCC3 ; <- 45CC3 - ancilla_cane_spark.asm : 272 (LDA $7EF36E)
JSL CalculateByrnaUsage
;--------------------------------------------------------------------------------
org $87AE17 ; <- 3AE17 - Bank07.asm : 7285 (LDA $7EF36E)
JSL CalculateCapeUsage
;--------------------------------------------------------------------------------
org $87AE98 ; <- 3AE98 - Bank07.asm : 7380 (LDA $7EF36E)
JSL CalculateCapeUsage
;--------------------------------------------------------------------------------
org $88DCA7 ; <- 45CA7 - ancilla_cane_spark.asm : 256 (LDA.b #$01 : STA $037B)
JSL ActivateInvulnerabilityOrDont : NOP
;--------------------------------------------------------------------------------
org $86EDC6 ;  <- 36DC6 - Bank06.asm : 4890 (LDA $0DB8F1, X)
JSL GetItemDamageValue
;--------------------------------------------------------------------------------

;================================================================================
; Misc Stats
;--------------------------------------------------------------------------------
org $80F970
JSL OnAga1Defeated
org $829E2E ; <- 11E2E - module_ganon_emerges.asm : 59 (JSL Dungeon_SaveRoomDataWRAM.justKeys)
JSL OnAga2Defeated
;--------------------------------------------------------------------------------
org $8DDBDE ; <- 6DBDE - headsup_display.asm : 105 (DEC A : BPL .subtractRupees)
JSL IncrementSpentRupees : NOP #6

;================================================================================
; Remove Item Menu Text
;--------------------------------------------------------------------------------
org $8DEBB0 ; <- 6EBB0 - equipment.asm : 1810 (LDA $0202)
JMP DrawItem_finished
org $8DECE6 ; <- 6ECE6 - equipment.asm : 1934 (SEP #$30)
DrawItem_finished:
org $8DEB48 ; <- 6EB48 - equipment.asm : 1784 (LDA $0000)
LDA.w $0000, Y : STA.w GFXStripes+$01F2
LDA.w $0002, Y : STA.w GFXStripes+$01F4
LDA.w $0040, Y : STA.w GFXStripes+$0232
LDA.w $0042, Y : STA.w GFXStripes+$0234
;---------------------------
org $8DE24B ; <- 6E24B - equipment.asm : 951 (LDA $0000)
LDA.w $0000, Y : STA.w GFXStripes+$01F2
LDA.w $0002, Y : STA.w GFXStripes+$01F4
LDA.w $0040, Y : STA.w GFXStripes+$0232
LDA.w $0042, Y : STA.w GFXStripes+$0234
;--------------------------------------------------------------------------------
org $8DE2DC ; <- 6E2DC - equipment.asm : 989 (LDA $F449, X : STA $122C, Y)
JMP UpdateBottleMenu_return
UpdateBottleMenu_return =  $8DE2F1 ; <- 6E2F1 - equipment.asm : 1000 (SEP #$30)
;--------------------------------------------------------------------------------
org $8DE6F4 ; <- 6E6F4 - equipment.asm : 1474 (BCC .lacksAbility)
db $80 ; BRA
org $8DE81A ; <- 6E81A - equipment.asm : 1597 (STA $00)
RTS
org $8DE7B9 ; <- 6E7B9 - equipment.asm : 1548 (LDA.w #$16D0 : STA $00)
JSL DrawGlovesInMenuLocation : NOP
org $8DE7CF ; <- 6E7CF - equipment.asm : 1554 (LDA.w #$16C8 : STA $00)
JSL DrawBootsInMenuLocation : NOP
org $8DE7E5 ; <- 6E7E5 - equipment.asm : 1560 (LDA.w #$16D8 : STA $00)
JSL DrawFlippersInMenuLocation : NOP
org $8DECEB ; <- 6ECEB - equipment.asm : 1946 (LDA.w #$16E0 : STA $00)
JSL DrawMoonPearlInMenuLocation : NOP

;================================================================================
; Zelda S&Q Mirror Fix
;--------------------------------------------------------------------------------
org $82D9A4 ; <- 159A4 - Bank02.asm : 11077 (dw $0000, $0002, $0002, $0032, $0004, $0006, $0030)
dw $0000, $0002, $0004, $0032, $0004, $0006, $0030

;================================================================================
; Accessibility
;--------------------------------------------------------------------------------
org $82A3F4 ; <- 123F4 - Bank02.asm : 6222 (LDA.b #$72 : BRA .setBrightness)
BRA + : NOP #2 : +
org $82A3FD ; <- 123FD - Bank02.asm : 6233 (LDA.b #$32 : STA $9A)
JSL ConditionalLightning
;--------------------------------------------------------------------------------
org $9DE9CD ; <- EE9CD - Bank1D.asm : 568 (JSL Filter_Majorly_Whiten_Bg)
JSL ConditionalWhitenBg
;--------------------------------------------------------------------------------
org $88AAE9 ; <- 042AE9 - ancilla_ether_spell.asm : 34 (JSL Palette_ElectroThemedGear)
JSL LoadElectroPalette
;--------------------------------------------------------------------------------
org $88AAF5 ; <- 042AF5 - ancilla_ether_spell.asm : 45 (JSL LoadActualGearPalettes)
JSL RestoreElectroPalette
;--------------------------------------------------------------------------------
org $88AAF9 ; -< 42AF9 - ancilla_ether_spell.asm : 46 (JSL Palette_Restore_BG_From_Flash)
JSL RestoreBgEther
;--------------------------------------------------------------------------------
org $88AAED ; <- 42AED - ancilla_ether_spell.asm : 35 (JSL Filter_Majorly_Whiten_Bg)
JSL ConditionalWhitenBg
;--------------------------------------------------------------------------------
org $82FEE6 ; <- 17EE6 - Bank0E.asm : 3907 (RTS)
RTL		 ; the whiten color routine is only JSL-ed to
;--------------------------------------------------------------------------------
org $87FA7B ; <- 3FA7B - Bank0E.asm : 4735 (REP #$20 : LDX.b #$02)  
JML DDMConditionalLightning
;--------------------------------------------------------------------------------
org $87FACB ; <- 3FACB - Bank0E.asm : 4773 (REP #$20 : LDA #$F531, Y) 
JSL ConditionalGTFlash : BRA + : NOP #11 : +
;--------------------------------------------------------------------------------
org $8AFF48 ; <- 57F48 - Bank0A.asm : 4935 (REP #$20 : LDA $7EC3DA)
JSL ConditionalRedFlash : BRA + : NOP #13 : +
;--------------------------------------------------------------------------------
org $88C2A1 ; <- 442A3 - ancilla_sword_ceremony.asm : 54 (REP #$20)
JSL ConditionalPedAncilla : BRA + : NOP #4 : +
;--------------------------------------------------------------------------------
org $879976 ; <- 039976 - Bank07.asm : 4009 (JSL Palette_ElectroThemedGear)
JSL LoadElectroPalette
;--------------------------------------------------------------------------------
org $87997C ; <- 03997C - Bank07.asm : 4015 (JSL LoadActualGearPalettes) 
JSL RestoreElectroPalette

;================================================================================
; Ice Floor Toggle
;--------------------------------------------------------------------------------
org $87D234 ; <- 3D234 - Bank07.asm : 12758 (LDA $0348 : AND.b #$11 : BEQ .notWalkingOnIce)
JSL LoadModifiedIceFloorValue_a11 : NOP
;--------------------------------------------------------------------------------
org $87D26E ; <- 3D26E - Bank07.asm : 12786 (LDA $0348 : AND.b #$01 : BNE BRANCH_RESH)
JSL LoadModifiedIceFloorValue_a01 : NOP

;================================================================================
; Sword Upgrade Randomization
;--------------------------------------------------------------------------------
org $83FC16 ; <- 1FC16 ($A8, $B8, $3D, $D0, $B8, $3D)
db $B1, $C6, $F9, $C9, $C6, $F9 ; data insert - 2 chests, fat fairy room

; unused item receipts
org $81E97E
dw $0116 : db $08
dw $0116 : db $25

;--------------------------------------------------------------------------------
PyramidFairy_BRANCH_IOTA = $86C936
PyramidFairy_BRANCH_GAMMA = $86C948

;--------------------------------------------------------------------------------
org $9EE16E ; <- F616E - sprite_bomb_shop_entity.asm : 73
NOP #8 ; fix bomb shop dialog for dwarfless big bomb
org $868A14 ; <- 30A14 - sprite_prep.asm : 716
NOP #8 ; fix bomb shop spawn for dwarfless big bomb
;--------------------------------------------------------------------------------
org $86B489 ; <- 33489 - sprite_smithy_bros.asm : 473 (LDA $7EF359 : CMP.b #$03 : BCS .tempered_sword_or_better)
JML GetSmithSword : NOP #4
Smithy_DoesntHaveSword:
org $86B49D ; <- 3349D - sprite_smithy_bros.asm : 485 (.tempered_sword_or_better)
Smithy_AlreadyGotSword:
;--------------------------------------------------------------------------------
org $86ED55 ; <- 36D55 - Bank06.asm : 4817
JSL LoadSwordForDamage ; moth gold sword fix
;--------------------------------------------------------------------------------
org $88C5F7 ; <- 445F7 - ancilla_receive_item.asm : 400 (LDA.b #$09 : STA $012D)
NOP #5 ; remove spooky telepathy sound
;--------------------------------------------------------------------------------
org $88C431 ; <- 44431 - ancilla_receive_item.asm : 125 (LDA $0C5E, X : CMP.b #$01 : BNE .notMasterSword2)
JSL MSMusicReset : NOP

;================================================================================
; Temporary Nerfs and Buffs
;--------------------------------------------------------------------------------
org $86F400 ; <- 37F400 - Bank06.asm : 5963 (CLC : ADC $7EF35B)
JSL LoadModifiedArmorLevel : NOP
;--------------------------------------------------------------------------------
org $87ADDB ; <- 3ADDB - Bank07.asm : 7251 (LDA $7EF37B : TAY)
JSL LoadModifiedMagicLevel
;--------------------------------------------------------------------------------
org $87AE0D ; <- 3AE0D - Bank07.asm : 7279 (LDA $7EF37B : TAY)
JSL LoadModifiedMagicLevel
;--------------------------------------------------------------------------------
org $87AE8E ; <- 3AE8E - Bank07.asm : 7376 (LDA $7EF37B : TAY)
JSL LoadModifiedMagicLevel
;--------------------------------------------------------------------------------
org $88DCB9 ; <- 45CB9 - ancilla_cane_spark.asm : 256 (LDA $7EF37B : TAY)
JSL LoadModifiedMagicLevel
;--------------------------------------------------------------------------------
org $87B08B
LinkItem_MagicCostBaseIndices:
;--------------------------------------------------------------------------------
org $87B096 ; <- 3B096 - Bank07.asm : 7731 (LDA LinkItem_MagicCostBaseIndices, X : CLC : ADC $7EF37B : TAX)
JSL LoadModifiedMagicLevel : !ADD.w LinkItem_MagicCostBaseIndices, X
;--------------------------------------------------------------------------------
org $87B0D5 ; <- 3B0D5 - Bank07.asm : 7783 (LDA LinkItem_MagicCostBaseIndices, X : CLC : ADC $7EF37B : TAX)
JSL LoadModifiedMagicLevel : !ADD.w LinkItem_MagicCostBaseIndices, X

;================================================================================
; Faster Great Fairies
;--------------------------------------------------------------------------------
org $86C83D ; <- sprite_ponds.asm : 784 ( LDA.b #$FF : STA $0DF0, X )
db $30 ; (any faster and she appears as link is still throwing the bottle)
;--------------------------------------------------------------------------------
org $86C896 ; <- sprite_ponds.asm : 844 ( LDA $1A : AND.b #$07 : BNE BRANCH_ALPHA )
db $03 ; fade in speed. Should be power of 2 minus 1
org $86C985 ; <- sprite_ponds.asm : 1025 ( LDA $1A : AND.b #$07 : BNE BRANCH_ALPHA )
db $03 ; fade out speed. Should be power of 2 minus 1

;================================================================================
; New Items
;--------------------------------------------------------------------------------
org $87B574 ; <- 3B574 - Bank07.asm : 8519 (LDA.b #$01 : STA $02E9)
JSL ChestPrep : NOP #3
db $90 ; !BCC .cantOpen
;--------------------------------------------------------------------------------
org $80D531 ; 5531 - Bank00.asm:3451 (LDY.b #$5D)
JML GetAnimatedSpriteGfxFile

org $80D547 ; 5547 - Bank00.asm:3467 (JSR Decomp_spr_high)
GetAnimatedSpriteGfxFile_return:

org $80D557 ; 5557 - Bank00.asm:3486 (LDA $00 : ADC $D469, X)
JSL GetAnimatedSpriteBufferPointer : NOP

org $8799F7 ; 399F7 - Bank07.asm:4107 (JSL AddReceivedItem)
JSL AddReceivedItemExpanded

org $898611 ; 48611 - ancilla_init.asm:720 (LDA .item_target_addr+0, X)
LDA.w ItemReceipts_target+0, X
org $898616 ; 48616 - ancilla_init.asm:721 (LDA .item_target_addr+1, X)
LDA.w ItemReceipts_target+1, X
org $89861F ; 4861F - ancilla_init.asm:724 (LDA .item_values, Y)
LDA.w ItemReceipts_value, Y

org $898627 ; 48627 - ancilla_init.asm:731 (LDA .item_target_addr+0, X)
LDA.w ItemReceipts_target+0, X
org $89862C ; 4862C - ancilla_init.asm:722 (LDA .item_target_addr+1, X)
LDA.w ItemReceipts_target+1, X
org $898635 ; 48635 - ancilla_init.asm:727 (LDA .item_values, Y)
LDA.w ItemReceipts_value, Y

org $8986AA ; 486AA - ancilla_init.asm:848 (LDA .item_masks, X)
LDA.w DungeonItemMasks, X

org $898769 ; 48769 - ancilla_init.asm:1005 (LDA .item_graphics_indices, Y)
LDA.w ItemReceipts_graphics, Y

org $898811
JSL.l SetItemRiseTimer

org $89884D ; 4884D - ancilla_init.asm:1137 (LDA $836C, Y)
LDA.w ItemReceipts_offset_y, Y
org $89885B ; 4885B - ancilla_init.asm:1139 (LDA .x_offsets, X) - I think the disassembly is wrong here, should have been LDA .x_offsets, Y
LDA.w ItemReceipts_offset_x, Y

org $8988B7 ; 488B7 - ancilla_init.asm:1199 (LDA .wide_item_flag, Y)
LDA.w SpriteProperties_chest_width, Y

org $8988EF ; 488EF - ancilla_init.asm:1248 (LDA $836C, Y)
LDA.w ItemReceipts_offset_y, Y
org $898908 ; 48908 - ancilla_init.asm:1258 (LDA .x_offsets, Y)
LDA.w ItemReceipts_offset_x, Y

org $88C6C8 ; 446C8 - ancilla_receive_item.asm:538 (LDA AddReceiveItem.properties, X)
JSL CheckReceivedItemPropertiesBeforeLoad

org $88C6DE ; 446DE - ancilla_receive_item.asm:550 (LDA .wide_item_flag, X)
JSL.l ItemReceiptWidthCheck

org $88C6F9 ; 446F9 - ancilla_receive_item.asm:570 (LDA AddReceiveItem.properties, X)
JSL CheckReceivedItemPropertiesBeforeLoad

org $8985ED ; 485ED - ancilla_init.asm:693 (LDA $02E9 : CMP.b #$01)
JSL AddReceivedItemExpandedGetItem : NOP

org $87B57D ; 3B57D - Bank07.asm:8527 (LDA Link_ReceiveItemAlternates, Y : STA $03)
BRA Link_PerformOpenChest_no_replacement
;--------------------------------------------------------------------------------
org $89892E ; 4892E - ancilla_init.asm:1307 (LDA BottleList, X)
LDA.w BottleListExpanded, X

org $89895C ; 4895C - ancilla_init.asm:1344 (LDA PotionList, X)
LDA.w PotionListExpanded, X
;--------------------------------------------------------------------------------
org $86D1EB ; 351EB - sprite_absorbable.asm:364 (STA $7EF375) ; bugbug commented out until i figure out why it doesn't work
JSL HandleBombAbsorbtion

;================================================================================
; Kholdstare Shell Fix
;--------------------------------------------------------------------------------
org $80EC88 ; <- 6C88 - Bank00.asm:6671 - (LDA $7EC380, X : STA $7EC580, X)
LDA.l $7EC3A0, X : STA.l $7EC5A0, X
;--------------------------------------------------------------------------------
org $80ECEB ; <- 6CEB - Bank00.asm:6730 - (LDX.w #$0080)
LDX.w #$00A0 : LDA.w #$00B0

;================================================================================
; Potion Refill Fixes
;--------------------------------------------------------------------------------
org $80F8FB ; <- 78FB - Bank00.asm:8507 - (JSL HUD.RefillHealth : BCC BRANCH_ALPHA)
JSL RefillHealth
;--------------------------------------------------------------------------------
org $80F911 ; <- 7911 - Bank00.asm:8528 - (JSL HUD.RefillMagicPower : BCS BRANCH_$7901)
JSL RefillMagic
;--------------------------------------------------------------------------------
org $80F918 ; <- 7918 - Bank00.asm:8537 - (JSL HUD.RefillHealth : BCC .alpha)
JSL RefillHealth
;--------------------------------------------------------------------------------
org $80F922 ; <- 7922 - Bank00.asm:8543 - (JSL HUD.RefillMagicPower : BCC .beta)
JSL RefillMagic

;================================================================================
; Early Bottle Fix
;--------------------------------------------------------------------------------
org $89894C ; <- 4894C - ancilla_init.asm:1327
JSL InitializeBottles

;================================================================================
; Agahnim Doors Fix
;--------------------------------------------------------------------------------
org $899BBA
JSL FlagAgahnimDoor

org $9BBC94 ; <- DBC94 - Bank1B.asm : 201 (LDA $7EF3C5 : AND.w #$000F : CMP.w #$0003 : BCS BRANCH_EPSILON)
JSL LockAgahnimDoors : BNE Overworld_Entrance_BRANCH_EPSILON : NOP #6

org $9BBCC1 ; <- DBCC1 - Bank1B.asm : 223 (LDA $0F8004, X : AND.w #$01FF : STA $00)
Overworld_Entrance_BRANCH_EPSILON: ; go here to lock doors
;--------------------------------------------------------------------------------
; Dungeon Drops
;--------------------------------------------------------------------------------
org $81C50D : JSL.l CheckDungeonWorld
org $81C517 : JSL.l CheckDungeonCompletion
org $81C523 : JSL.l CheckDungeonCompletion
org $81C710 : JSL.l CheckSpawnPrize
BCS RoomTag_GetHeartForPrize_spawn_prize : BRA RoomTag_GetHeartForPrize_delete_tag
org $81C742 : JSL.l SpawnDungeonPrize : PLA : RTS
org $8799EA : JML.l SetItemPose
org $88C415 : JSL.l PendantMusicCheck
BCS Ancilla22_ItemReceipt_is_pendant : BRA Ancilla22_ItemReceipt_wait_for_music
org $88C452 : JSL.l MaybeKeepLootID : NOP #2
org $88C61D : JSL.l AnimatePrizeCutscene : NOP
org $88C622 : BCC ItemReceipt_Animate_continue
org $88C6BA : JSL.l CheckPoseItemCoordinates
org $88CAD6 : JSL.l HandleDropSFX : NOP #2
org $88CADC : BCC Ancilla29_MilestoneItemReceipt_skip_crystal_sfx
org $88CAE9 : JSL.l PrepPrizeTile 
org $88CB23 : JSL.l PrizeDropSparkle : BCC Ancilla29_MilestoneItemReceipt_no_sparkle : NOP #2
org $88CB97 : JSL.l PrepPrizeOAMCoordinates : BRA + : NOP #$12 : +
org $88CBFF : JSL.l PrepPrizeShadow
org $88CC6C : JSL.l HandleCrystalsField
org $88CCA6 : JSL.l PrepPrizeOAMCoordinates : NOP
org $8985FA : JSL.l SetCutsceneFlag : NOP #3 : BCC AncillaAdd_ItemReceipt_not_crystal
org $8988B2 : JSL.l SetPrizeCoords : NOP


;================================================================================
; Uncle / Sage Fixes - Old Man Fixes - Link's House Fixes
;--------------------------------------------------------------------------------
org $85DA4F ; <- 2DA4F - sprite_uncle_and_priest.asm : 45 (BCC .agahnim_not_defeated)
db $80 ; BRA
;--------------------------------------------------------------------------------
org $85DA61 ; <- 2DA61 - sprite_uncle_and_priest.asm : 51 (BEQ .priest_not_already_dead)
db $80 ; BRA
;--------------------------------------------------------------------------------
org $85DA81 ; <- 2DA81 - sprite_uncle_and_priest.asm : 65 (BCC .dontHaveMasterSword)
db $80 ; BRA
;--------------------------------------------------------------------------------
org $85DEF8 ; <- 2DEF8 - sprite_uncle_and_priest.asm : 917 (LDA.b #$05)
LDA.b #$00
;--------------------------------------------------------------------------------
;0xFE465 -> 0x1E
org $9FE465 ; changes key door in tr pipes to a normal door
db $1E
;--------------------------------------------------------------------------------

;================================================================================
; Bomb & Arrow Capacity Updates
;--------------------------------------------------------------------------------
org $8DDC27 ; <- 6DC27 - headsup_display.asm:151 (LDA $7EF370 : TAY)
JSL IncrementBombs : NOP #15
;--------------------------------------------------------------------------------
org $8DDC49 ; <- 6DC49 - headsup_display.asm:169 (LDA $7EF371 : TAY)
JSL IncrementArrows : NOP #15
;--------------------------------------------------------------------------------
org $9EE199 ; <- F6199 - sprite_bomb_shop_entity.asm:102 (LDA $7EF370 : PHX : TAX)
JSL CompareBombsToMax : NOP #11

;================================================================================
; Bonk Items
;--------------------------------------------------------------------------------
org $85FC7E ; <- 2FC7E - sprite_dash_item.asm : 118 (LDA $7EF36F : INC A : STA $7EF36F)
JSL GiveBonkItem : NOP #5
org $85FC97 ; <- 2FC97 - sprite_dash_item.asm : 126 (LDA.b #$2F : JSL Sound_SetSfx3PanLong)
NOP #6
;--------------------------------------------------------------------------------
org $868D39 ; <- 30D39 - sprite_prep.asm : 1435 - (LDA.b #$08 : STA $0F50, X)
JSL LoadBonkItemGFX
;--------------------------------------------------------------------------------
org $85FC04 ; <- 2FC04 - sprite_dash_item.asm : 38 - (JSL DashKey_Draw)
JSL DrawBonkItemGFX

;================================================================================
; Library Item
;--------------------------------------------------------------------------------
org $85FD44 ; <- 2FD44 - sprite_dash_item.asm : 244 - (JSL Link_ReceiveItem)
JSL SetLibraryItem
;--------------------------------------------------------------------------------
org $868D1B ; <- 30D1B - sprite_prep.asm : 1414 - (JSL GetAnimatedSpriteTile.variable)
JSL LoadLibraryItemGFX
;--------------------------------------------------------------------------------
org $85FC9E ; <- 2FC9E - sprite_dash_item.asm : 138 - (JSL Sprite_PrepAndDrawSingleLargeLong)
JSL DrawLibraryItemGFX
;--------------------------------------------------------------------------------
org $868D0E ; <- 30D0E - sprite_prep.asm : 1401 - (LDA $7EF34E : BEQ .book_of_mudora)
JSL ItemCheck_Library

;================================================================================
; Inventory Updates
;--------------------------------------------------------------------------------
org $8DDF38 ; <- 6DF38 - equipment.asm : 480
JSL ProcessMenuButtons
BCC _equipment_497
JMP.w _equipment_544
ResetEquipment:
JSR.w RestoreNormalMenu ; (short)
RTL
NOP #3

warnpc $8DDF49
org $8DDF49 ; <- 6DF49 - equipment.asm : 497
_equipment_497: ; LDA $F4 : AND.b #$08 : BEQ .notPressingUp - NO BUTTON CAPTURE
org $8DDF88 ; <- 6DF88 - equipment.asm : 544
_equipment_544:
;--------------------------------------------------------------------------------
org $8DEB98 ; <- 6EB98 - equipment.asm : 1803
LDA.w #$3C60 : STA $FFBE, Y
ORA.w #$8000 : STA $007E, Y
ORA.w #$4000 : STA $0084, Y
JSL AddYMarker : NOP #2
;--------------------------------------------------------------------------------
org $8DF789+6 ; <- 6F789+6 (not in disassembly) - red bottle hud tile, lower right
dw $2413 ; (Orig: #$24E3)
org $8DF789+6+8  ; green bottle hud tile, lower right
dw $3C12 ; (Orig: #$3CE3)
org $8DF789+6+16 ; blue bottle hud tile, lower right
dw $2C14 ; (Orig: #$2CD2)
org $8DF789+6+40 ; good bee hud tile, lower right
dw $2815 ; (Orig: #$283A)
org $8DF8A1+6 ; <- 6F8A1+6 (not in disassembly) - green mail tile, lower right
dw $3C4B ; (Orig: #$7C78)
org $8DF8A1+6+8  ; blue mail tile tile, lower right
dw $2C4F ; (Orig: #$6C78)
org $8DF8A1+6+16 ; red mail tile, lower right
dw $242F ; (Orig: #$6478)
;--------------------------------------------------------------------------------
org $8DDE9F ; <- 6DE9F equipment.asm:300 - LDA.b #$0A : STA $0200
LDA.b #$04
;--------------------------------------------------------------------------------
org $8DDE59 ; <- 6DE59 equipment.asm:247 - REP #$20
JSL BringMenuDownEnhanced : RTS
;--------------------------------------------------------------------------------
org $8DDFBC ; <- 6DFBC equipment.asm:599 - LDA $EA : ADD.w #$0008 : STA $EA : SEP #$20 : BNE .notDoneScrolling
JSL RaiseHudMenu : NOP #3
;--------------------------------------------------------------------------------
org $8DDE3D ; <- 6DE3D equipment.asm:217 - BNE .equippedItemIsntBottle
db $80 ; BRA
;--------------------------------------------------------------------------------
org $8DDF9A ; <- 6DF9A - equipment.asm : 554
JSL OpenBottleMenu : NOP
;--------------------------------------------------------------------------------
org $8DE12D ; <- 6E12D - equipment.asm : 828
JSL CloseBottleMenu
;--------------------------------------------------------------------------------
org $8DDF1E ; <- 6DF1E - equipment.asm : 462 - LDA $F4 : AND.b #$10 : BEQ .dontLeaveMenu
JSL CheckCloseItemMenu
;--------------------------------------------------------------------------------
org $8DEE70 ; <- 6EE70 - equipment.asm : 2137
JSL PrepItemScreenBigKey : NOP
;--------------------------------------------------------------------------------
org $0DDEA5 ; LDA.b Joy1A_New : BEQ .wait_for_button 
JSL.l HandleEmptyMenu : RTS
org $0DEB3C ; LDA.w ItemCursor : AND.w #$00FF
JML.l MaybeDrawEquippedItem : NOP #2
org $0DE363 ; LDA.b #$04 : STA.w SubModuleInterface
JSL.l RestoreMenu_SetSubModule : NOP
;--------------------------------------------------------------------------------
org $88D395 ; <- 45395 - ancilla_bird_travel_intro.asm : 253
JSL.l UpgradeFlute : NOP #2
;--------------------------------------------------------------------------------
org $85E4D7 ; <- 2E4D7 - sprite_witch.asm : 213
JSL RemoveMushroom : NOP #2
;--------------------------------------------------------------------------------
org $85F55F ; <- 2F55F - sprite_potion_shop.asm : 59
JSL LoadPowder
;--------------------------------------------------------------------------------
org $85F681 ; <- 2F681 - sprite_potion_shop.asm : 234
JSL DrawPowder : RTS
NOP #8
;--------------------------------------------------------------------------------
org $85F65D ; <- 2F65D - sprite_potion_shop.asm : 198
JSL CollectPowder : NOP #5
;--------------------------------------------------------------------------------
org $85EE5F ; <- 2EE5F - sprite_mushroom.asm : 30
JSL LoadMushroom : NOP
;--------------------------------------------------------------------------------
org $85EE78 ; <- 2EE78 - sprite_mushroom.asm : 58
JSL DrawMushroom
;--------------------------------------------------------------------------------
org $85EE97 ; <- 2EE97 - sprite_mushroom.asm : 81
NOP #14
;--------------------------------------------------------------------------------
org $87A36F ; <- 3A36F - Bank07.asm : 5679
NOP #5
org $87A379 ; <- 3A379 - Bank07.asm : 5687
JSL SpawnHauntedGroveItem
;--------------------------------------------------------------------------------
org $87A3A2 ; 3A3A2 - Bank07.asm : 5720 - JSL DiggingGameGuy_AttemptPrizeSpawn
JSL SpawnShovelItem
BRA _Bank07_5726
org $87A3AB ; 3A3AB - Bank07.asm : 5726 - LDA.b #$12 : JSR Player_DoSfx2
_Bank07_5726:
;--------------------------------------------------------------------------------
org $879A0E ; 39A0E - Bank07.asm : 4117 - JSL HUD.RefreshIconLong
JSL Link_ReceiveItem_HUDRefresh

;================================================================================
; Swordless Mode
;--------------------------------------------------------------------------------
org $87A49F ; <- 3A49F - Bank07.asm:5903 (LDA $7EF359 : INC A : AND.b #$FE : BEQ .cant_cast_play_sound) - Ether
JSL CheckMedallionSword
;--------------------------------------------------------------------------------
org $87A574 ; <- 3A574 - Bank07.asm:6025 (LDA $7EF359 : INC A : AND.b #$FE : BEQ BRANCH_BETA) - Bombos
JSL CheckMedallionSword
;--------------------------------------------------------------------------------
org $87A656 ; <- 3A656 - Bank07.asm:6133 (LDA $7EF359 : INC A : AND.b #$FE : BEQ BRANCH_BETA) - Quake
JSL CheckMedallionSword
;--------------------------------------------------------------------------------
org $85F3A0 ; <- 2F3A0 - sprite_medallion_tablet.asm:240 (LDA $7EF359 : BMI .zeta)
JSL CheckTabletSword
;--------------------------------------------------------------------------------
org $85F40A ; <- 2F40A - sprite_medallion_tablet.asm:303 (LDA $7EF359 : BMI .show_hylian_script)
JSL CheckTabletSword
;--------------------------------------------------------------------------------
org $9DF086 ; <- EF086 - sprite_evil_barrier.asm:303 (LDA $7EF359 : CMP.b #$02 : BCS .anozap_from_player_attack)
JSL GetSwordLevelForEvilBarrier
;--------------------------------------------------------------------------------

;================================================================================
; Medallion Tablets
;--------------------------------------------------------------------------------
org $85F274 ; <- 2F274
JSL ItemCheck_BombosTablet
;--------------------------------------------------------------------------------
org $85F285 ; <- 2F285
JSL ItemCheck_EtherTablet
;--------------------------------------------------------------------------------
org $87859F ; <- 3859F - Bank07.asm : 965 (JSL AddPendantOrCrystal)
JSL SpawnTabletItem
org $87862A ; <- 3862A - Bank07.asm : 1064 (JSL AddPendantOrCrystal)
JSL SpawnTabletItem
;--------------------------------------------------------------------------------
org $85EF1E ; LDA.l $7EF280,X : AND #$40
JSL CheckTabletItem : NOP #2

;================================================================================
; Medallion Entrances
;--------------------------------------------------------------------------------
org $88B504 ; <- 43504 - ancilla_bombos_spell.asm : 671
JSL MedallionTrigger_Bombos : NOP
;--------------------------------------------------------------------------------
org $88ACC8 ; <- 42CC8 - ancilla_ether_spell.asm : 350
JSL MedallionTrigger_Ether
JMP _ancilla_ether_spell_363
warnpc $88ACE6
org $88ACE6 ; <- 42CE6 - ancilla_quake_spell.asm : 363
_ancilla_ether_spell_363:
;--------------------------------------------------------------------------------
org $88B6EA ; <- 436EA - ancilla_quake_spell.asm : 67
JSL MedallionTrigger_Quake
JMP _ancilla_quake_spell_83
Ancilla_CheckIfEntranceTriggered:
	JSR $F856
RTL
warnpc $88B708
org $88B708 ; <- 43708 - ancilla_quake_spell.asm : 83
_ancilla_quake_spell_83:

;================================================================================
; Animated Entrances
;--------------------------------------------------------------------------------
org $9BCAC4 ; <- Bank1B.asm : 1537 (STA $02E4 ; Link can't move.)
JSL AnimatedEntranceFix
BNE +
	RTL
	NOP #2
+

;================================================================================
; Big & Great Fairies
;--------------------------------------------------------------------------------
org $9DC475 ; <- EC475 - sprite_big_fairie.asm : 70 (LDA.w #$00A0 : ADD $7EF372 : STA $7EF372)
JSL RefillHealthPlusMagic : NOP #8

org $9DC489 ; <- EC489 - sprite_big_fairie.asm : 88 (LDA $7EF36D : CMP $7EF36C : BNE .player_hp_not_full_yet)
NOP #4 : JSL CheckFullHealth
;--------------------------------------------------------------------------------

;================================================================================
; RNG Fixes
;--------------------------------------------------------------------------------
org $9DFD9E ; <- EFD9E - sprite_diggin_guy.asm : 307
NOP #8
;--------------------------------------------------------------------------------
org $9DFD67 ; <- EFD67 - sprite_diggin_guy.asm : 242
JSL RigDigRNG
;--------------------------------------------------------------------------------
org $81EE94 ; <- EE94 - Bank01.asm : 14121
JSL RigChestRNG
org $81EEF5 ; <- EEF5 - Bank01.asm
JSL FixChestCounterForChestGame
org $81EEFD ; <- EEFD - Bank01.asm
JSL FixChestCounterForChestGame
;--------------------------------------------------------------------------------
org $9ED63E ; <- F563E - sprite_agahnim.asm
JSL RNG_Agahnim1
org $9ED6EF ; <- F56EF - sprite_agahnim.asm
JSL RNG_Agahnim1
org $9D91E3 ; <- E91E3 - sprite_ganon.asm
JSL RNG_Ganon_Extra_Warp
org $9D9488 ; <- E9488 - sprite_ganon.asm
JSL RNG_Ganon
;--------------------------------------------------------------------------------
org $85A3F4 ; <- 2A3F4 - sprite_lanmola.asm : 112 (JSL GetRandomInt : AND.b #$07 : TAY)
JSL RNG_Lanmolas1
org $85A401 ; <- 2A401 - sprite_lanmola.asm : 116 (JSL GetRandomInt : AND.b #$07 : TAY)
JSL RNG_Lanmolas1
org $85A4FA ; <- 2A4FA - sprite_lanmola.asm : 241 (JSL GetRandomInt : AND.b #$07 : TAY)
JSL RNG_Lanmolas1
org $85A507 ; <- 2A507 - sprite_lanmola.asm : 245 (JSL GetRandomInt : AND.b #$07 : TAY)
JSL RNG_Lanmolas1
;--------------------------------------------------------------------------------
org $9DD817 ; <- ED817 - sprite_giant_moldorm.asm : 187 (JSL GetRandomInt : AND.b #$02 : DEC A : STA $0EB0, X)
JSL RNG_Moldorm1
org $9DD821 ; <- ED821 - sprite_giant_moldorm.asm : 189 (JSL GetRandomInt : AND.b #$1F : ADC.b #$20 : STA !timer_0, X)
JSL RNG_Moldorm1
org $9DD832 ; <- ED832 - sprite_giant_moldorm.asm : 203 (JSL GetRandomInt : AND.b #$0F : ADC.b #$08 : STA !timer_0, X)
JSL RNG_Moldorm1
;--------------------------------------------------------------------------------
org $9E81A9 ; <- F01A9 - sprite_helmasaur_king.asm : 247 (JSL GetRandomInt : AND.b #$07 : TAY)
JSL RNG_Helmasaur
org $9E8262 ; <- F0262 - sprite_helmasaur_king.asm : 373 (JSL GetRandomInt : AND.b #$01 : BEQ BRANCH_BETA)
JSL RNG_Helmasaur
org $9DEEE1 ; <- EEEE1 - sprite_helmasaur_fireball.asm : 236 (JSL GetRandomInt : STA $0FB6)
JSL RNG_Helmasaur
;--------------------------------------------------------------------------------
org $9EB5F7 ; <- F35F7 - sprite_arrghus.asm : 328 (JSL GetRandomInt : AND.b #$3F : ADC.b #$30 : STA $0DF0, X)
JSL RNG_Arrghus
;--------------------------------------------------------------------------------
org $9EBF4D ; <- F3F4D - sprite_mothula.asm : 180 (JSL GetRandomInt : AND.b #$07 : TAY)
JSL RNG_Mothula
org $9EBF60 ; <- F3F60 - sprite_mothula.asm : 187 (JSL GetRandomInt : AND.b #$1F : ADC.b #$40 : STA $0DF0, X)
JSL RNG_Mothula
org $9EBFBE ; <- F3FBE - sprite_mothula.asm : 261 (JSL GetRandomInt : AND.b #$1F : ORA.b #$40 : STA !beam_timer, X)
JSL RNG_Mothula
org $9EC095 ; <- F4095 - sprite_mothula.asm : 373 (JSL GetRandomInt : AND.b #$1F : CMP #$1E : BCC .already_in_range)
JSL RNG_Mothula
;--------------------------------------------------------------------------------
org $9E957A ; <- F157A - sprite_kholdstare.asm : 209 (JSL GetRandomInt : AND.b #$3F : ADC.b #$20 : STA $0DF0, X)
JSL RNG_Kholdstare
org $9E95F0 ; <- F15F0 - sprite_kholdstare.asm : 289 (JSL GetRandomInt : AND.b #$3F : ADC.b #$60 : STA $0DF0, X)
JSL RNG_Kholdstare
org $9E95FB ; <- F15FB - sprite_kholdstare.asm : 291 (JSL GetRandomInt : PHA : AND.b #$03 : TAY)
JSL RNG_Kholdstare
org $9E96C9 ; <- F16C9 - sprite_kholdstare.asm : 453 (JSL GetRandomInt : AND.b #$07 : TAY)
JSL RNG_Kholdstare
org $9E96E5 ; <- F16E5 - sprite_kholdstare.asm : 458 (JSL GetRandomInt : AND.b #$07 : TAY)
JSL RNG_Kholdstare
org $9E97D5 ; <- F17D5 - sprite_kholdstare.asm : 605 (JSL GetRandomInt : AND.b #$04 : STA $0D)
JSL RNG_Kholdstare
;--------------------------------------------------------------------------------
org $9DE5E4 ; <- EE5E4 - sprite_vitreous.asm : 207 (JSL GetRandomInt : AND.b #$0F : TAY)
JSL RNG_Vitreous
org $9DE626 ; <- EE626 - sprite_vitreous.asm : 255 (JSL GetRandomInt : AND.b #$07 : STA $0D90, Y)
JSL RNG_Vitreous
;--------------------------------------------------------------------------------
org $9DB16C ; <- EB16C - sprite_trinexx.asm : 530 (JSL GetRandomInt : AND.b #$07 : TAY)
JSL RNG_Trinexx
org $9DB186 ; <- EB186 - sprite_trinexx.asm : 535 (JSL GetRandomInt : AND.b #$07 : TAY)
JSL RNG_Trinexx
org $9DB25E ; <- EB25E - sprite_trinexx.asm : 643 (JSL GetRandomInt : AND.b #$03 : TAY : CMP $00 : BEQ BRANCH_ALPHA)
JSL RNG_Trinexx
org $9DB28D ; <- EB28D - sprite_trinexx.asm : 661 (JSL GetRandomInt : AND.b #$03 : CMP.b #$01 : TYA : BCS BRANCH_GAMMA)
JSL RNG_Trinexx
org $9DB9B0 ; <- EB9B0 - sprite_sidenexx.asm : 165 (JSL GetRandomInt : AND.b #$07 : INC A : CMP.b #$05 : BCS BRANCH_ALPHA)
JSL RNG_Trinexx
org $9DB9CC ; <- EB9CC - sprite_sidenexx.asm : 175 (JSL GetRandomInt : LSR A : BCS BRANCH_ALPHA)
JSL RNG_Trinexx
org $9DBA5D ; <- EBA5D - sprite_sidenexx.asm : 270 (JSL GetRandomInt : AND.b #$0F : STA $0DF0, X)
JSL RNG_Trinexx
org $9DBAB1 ; <- EBAB1 - sprite_sidenexx.asm : 314 (JSL GetRandomInt : AND.b #$0F : LDY.b #$00 : SUB.b #$03)
JSL RNG_Trinexx
org $9DBAC3 ; <- EBAC3 - sprite_sidenexx.asm : 323 (JSL GetRandomInt : AND.b #$0F : ADD.b #$0C : STA $02 : STZ $03)
JSL RNG_Trinexx
;--------------------------------------------------------------------------------
org $6F9B8 ; <- 379B8 - bank06.asm : 6693 (JSL GetRandomInt : PLY  : AND $FA5C, Y : BNE BRANCH_MU)
JSL RNG_Enemy_Drops
;================================================================================
; HUD Changes
;--------------------------------------------------------------------------------
org $8DFDCB
JSL UpdateHearts
RTS
org $8DF191 : JSL.l ColorAnimatedHearts : BRA + : NOP #7 : +

org $8DFC4C ; <- 6FC4C - headsup_display.asm : 836 (LDA $7EF36E : AND.w #$00FF : ADD.w #$0007 : AND.w #$FFF8 : TAX)
JML OnDrawHud : NOP #197 ; why? it's not hurting anyone lol
ReturnFromOnDrawHud:
SEP #$30
LDX.b #$FF ; vanilla hud code ends with #$FF in X, and it's required for unknown reasons.

org $8DFC37 ; <- 6FC37 - headsup_display.asm : 828 (LDA.w #$28F7)
JSL DrawMagicHeader
BRA + : NOP #15 : +
;--------------------------------------------------------------------------------
org $81CF67 ; <- CF67 - Bank01.asm : 11625 (STA $7EF36F)
JSL DecrementSmallKeys
;--------------------------------------------------------------------------------
org $8DED04 ; <- 6ED04 - equipment.asm : 1963 (REP #$30)
JSL DrawHUDDungeonItems
;--------------------------------------------------------------------------------
; Insert our version of the hud tilemap
org $8DFA96 ; <- 6FA96 - headsup_display.asm : 626 (LDX.w #.hud_tilemap)
LDX.w #HUD_TileMap
org $8DFA9C ; <- 6FA9C - headsup_display.asm : 629 (MVN $0D, $7E ; $Transfer 0x014A bytes from $6FE77 -> $7EC700)
MVN $A17E
;--------------------------------------------------------------------------------
org $8DFB1F : JSL CheckHUDSilverArrows
org $8DFB29 : BRA UpdateHUDBuffer_update_item_check_arrows
;--------------------------------------------------------------------------------
org $8DF1AB : JSR.w RebuildHUD_update
org $8DDFC8 : JSR.w RebuildHUD_update
org $8DDB85 : JSR.w RefreshIcon_UpdateHUD : BRA + : NOP : +
;--------------------------------------------------------------------------------
org $87A205 : JSL.l RebuildHUD_update_long
org $87A1A4 : JSL.l RebuildHUD_update_long
org $87A1CF : JSL.l RebuildHUD_update_long
org $87A21D : JSL.l RebuildHUD_update_long
org $87A235 : JSL.l RebuildHUD_update_long
org $8AEF62 : JSL.l RebuildHUD_update_long
;--------------------------------------------------------------------------------
org $8DFFE1
RebuildHUD_update_long:
JSR.w RebuildHUD_update : RTL

RefreshIcon_UpdateHUD:
LDA.b #$01 : STA.l UpdateHUDFlag
JSR.w RebuildHUD
JSR.w UpdateEquippedItem
RTS
warnpc $8E8000
;--------------------------------------------------------------------------------
org $8DEDE8
JSL.l DrawHeartPiecesMenu : BRA DrawEquipment_in_a_dungeon
;--------------------------------------------------------------------------------

;================================================================================
; 300 Rupee NPC
;--------------------------------------------------------------------------------
org $9EF060 ; <- F7060 - sprite_shopkeeper.asm:242 (INC $0D80, X)
JSL Set300RupeeNPCItem : NOP

;================================================================================
; Tree Kid Fix
;--------------------------------------------------------------------------------
org $86B12B ; <- 3312B - tree status set - 418 - LDA NpcFlagsVanilla : ORA.b #$08 : STA NpcFlagsVanilla
LDA.l NpcFlagsVanilla : AND.b #$F7 : STA.l NpcFlagsVanilla ; unset arboration instead of setting it
;--------------------------------------------------------------------------------
org $86B072 ; <- 33072 - FluteAardvark_InitialStateFromFluteState - 418 : dw FluteAardvark_AlreadyArborated
dw $06B08B
;================================================================================

;================================================================================
; Glitched Mode Fixes
;--------------------------------------------------------------------------------
org $8691AC ; <- 311AC - sprite_prep.asm:2453 (LDY $0FFF)
JSL GetAgahnimPalette : NOP #2
;--------------------------------------------------------------------------------
org $86F0DD ; <- 370DD - Bank06.asm:5399 (STA $0BA0, X)
JSL GetAgahnimDeath : NOP #2
;--------------------------------------------------------------------------------
org $9ED4E6 ; <- F54E6 - sprite_agahnim.asm:314 (LDY $0FFF)
JSL GetAgahnimType : NOP #2
;--------------------------------------------------------------------------------
org $9ED577 ; <- F5577 - sprite_agahnim.asm:418 (PHX)
JML GetAgahnimSlot
GetAgahnimSlotReturn:
;--------------------------------------------------------------------------------
org $9ED678 ; <- F5678 - sprite_agahnim.asm:587 (INC $0E30, X)
NOP #2 : JSL GetAgahnimLightning
;--------------------------------------------------------------------------------
org $8287E0 ; <- 107E0 - Bnak02.asm:1507 (LDA $0112 : ORA $02E4 : ORA $0FFC : BEQ .allowJoypadInput)
JSL AllowJoypadInput : BRA ++ : NOP #3 : ++

;================================================================================
; Half Magic Bat
;--------------------------------------------------------------------------------
org $85FBD3 ; <- 2FBD3 - sprite_mad_batter.asm:209 - (STA $7EF37B)
JSL GetMagicBatItem

;================================================================================
; MSU Music
;--------------------------------------------------------------------------------
org $8080D7 ; <- D7 - Bank00.asm:172 (SEP #$30)
JML MSUMain : NOP
SPCContinue:

org $828B7A ; <- C220 A5A0 - Bank02.asm:2225 (REP #$20 : LDA $A0)
JSL SpiralStairsPreCheck

org $829069 ; <- A21C A5A0 - Bank02.asm:3081 (LDX.b #$1C : LDA $A0)
JSL SpiralStairsPostCheck

org $82D6E8 ; <- 9C0A01 - Bank02.asm:10811 (STZ $010A)
NOP #3

org $88C421 ; <- AD4021 F005 - ancilla_receive_item.asm:108 (LDA $2140 : BEQ .wait_for_music)
JML PendantFanfareWait : NOP
PendantFanfareContinue:

org $88C42B
PendantFanfareDone:

org $88C62A ; <- AD4021 D008 - ancilla_receive_item.asm:442 (LDA $2140 : BNE .waitForSilence)
JML CrystalFanfareWait : NOP
CrystalFanfareDone:

org $88C637
CrystalFanfareContinue:

org $8988A0 ; <- 8D2C01 8009 - ancilla_init.asm:1179 (STA $012C : BRA .doneWithSoundEffects)
JML FanfarePreload : NOP

org $89F2A7 ; <- 8F27C27E - module_death.asm:56 (STA $7EC227)
JSL StoreMusicOnDeath

org $8EE6EC ; <- E220 A922 - Bank0E.asm:2892 (SEP #$20 : LDA.b #$22 : STA $012C)
JSL EndingMusicWait

; Process music commands in NMI from new location after muting is processed
org $8080DD
dw MusicControl

org $808101
dw MusicControl

org $89F512
dw MusicControl

org $8CF05F
dw MusicControl

;================================================================================
; Replacement Shopkeeper
;--------------------------------------------------------------------------------
org $868BEB ; <- 30BEB - sprite_prep.asm:1125 - (INC $0BA0, X)
JSL SpritePrep_ShopKeeper : RTS : NOP
ShopkeeperFinishInit:
;--------------------------------------------------------------------------------
org $9EEEE3 ; <- F6EE3 - sprite_shopkeeper.asm:7 - (LDA $0E80, X)
JSL Sprite_ShopKeeper : RTS : NOP
ShopkeeperJumpTable:

;================================================================================
; Tile Target Loader
;--------------------------------------------------------------------------------
org $80D55E ; <- 555E - Bank00.asm:3491 (LDX.w #$2D40)
JSL LoadModifiedTileBufferAddress : NOP #2

;================================================================================
; Permabunny Fix
;--------------------------------------------------------------------------------
org $878F32 ; <- 38F32 - Bank07.asm:2420 - (LDA $7EF357)
JSL DecideIfBunny ; for bunny beams

;================================================================================
; Other bunny Fixes
;--------------------------------------------------------------------------------
org $829E7C; <- 11E7C - module_ganon_emerges.asm:127 - (LDA.b #$09 : STA $012C)
JSL FixAga2Bunny : NOP

;================================================================================
; Open Mode Fixes
;--------------------------------------------------------------------------------
org $85DF65 ; <- 2DF65 - sprite_uncle_and_priest.asm:994 - (LDA.b #$01 : STA $7EF3C5)
NOP #6
;--------------------------------------------------------------------------------
org $85EDDF ; <- 2EDDF - sprite_zelda.asm:398 - (LDA.b #$02 : STA $7EF3C5)
JSL EndRainState : NOP #2
;--------------------------------------------------------------------------------
org $85DF49 ; <- 2DF49 - sprite_uncle_and_priest.asm:984 - (JSL Link_ReceiveItem)
JSL OnUncleItemGet

;================================================================================
; Generic Keys
;--------------------------------------------------------------------------------
org $828157 ; <- 10157 - Bank02.asm:381 - (LDA $040C : CMP.b #$FF : BEQ .notPalace)
JSL CheckKeys : NOP
;--------------------------------------------------------------------------------
org $828166 ; <- 10166 - Bank02.asm:396 - (LDA $7EF37C, X)
JSL LoadKeys
;--------------------------------------------------------------------------------
org $829A31 ; <- 11A31 - Bank02.asm:4785 - (LDA $7EF37C, X)
JSL LoadKeys
;--------------------------------------------------------------------------------
org $82A0D1 ; <- 120D1 - Bank02.asm:5841 - (STA $7EF37C, X)
JSL SaveKeys
;--------------------------------------------------------------------------------
org $89F584 ; <- 4F584 - module_death.asm:447 - (STA $7EF37C, X)
JSL SaveKeys
;--------------------------------------------------------------------------------
org $8282EC ; <- 102EC - Bank02.asm:650 - (STA $7EF36F)
JSL ClearOWKeys
;--------------------------------------------------------------------------------
org $8DFA80 ; <- 6FA80 : headsup_display.asm:596 - (LDA.b #$00 : STA $7EC017)
JSL HUDRebuildIndoor : NOP #4
;--------------------------------------------------------------------------------
org $829A35 ; <- 11A35 : Bank02.asm:4789 - (JSL HUD.RebuildIndoor.palace)
JSL HUDRebuildIndoorHole

;================================================================================
; Pendant / Crystal Fixes
;--------------------------------------------------------------------------------
;================================================================================
org $8DE9C8 ; <- 6E9C8 - equipment.asm:1623 - (LDA $7EF3C5 : CMP.b #$03 : BCC .beforeAgahnim)
JSL DrawPendantCrystalDiagram : RTS
;================================================================================
org $8DEDCC ; <- 6EDCC - equipment.asm:2043 - (LDA $040C : AND.w #$00FF : CMP.w #$00FF : BNE .inSpecificDungeon)
JSL ShowDungeonItems : NOP #5

org $8DEE59 ; <- 6EE59 - equipment.asm:2126 - (LDA $040C : AND.w #$00FF : CMP.w #$00FF : BEQ .notInPalace)
JSL ShowDungeonItems : NOP #5

org $8DEE8A ; <- 6EE8A - equipment.asm:2151 - (LDA $040C : AND.w #$00FF : CMP.w #$00FF : BEQ .notInPalaceAgain)
JSL ShowDungeonItems : NOP #5

org $8DEF3B ; <- 6EF3B - equipment.asm:2290 - (LDA $040C : AND.w #$00FF : CMP.w #$00FF : BEQ .notInPalace)
JSL ShowDungeonItems : NOP #5
;================================================================================
org $80F97E ; <- 797E - Bank00.asm:8586 - (LDA $7EF3CA : EOR.b #$40 : STA $7EF3CA)
JSL FlipLWDWFlag : NOP #6
;================================================================================
org $82B15C ; <- 1315C - Bank02.asm:7672 - (LDA $7EF3CA : EOR.b #$40 : STA $7EF3CA)
JSL IncrementOWMirror
JSL FlipLWDWFlag : NOP #2
;================================================================================
;org $8AC5BB ; < 545BB - Bank0A.asm:1856 - (LDA $7EF3C7 : CMP.b #$03 : BNE .fail)
;JSL OverworldMap_CheckObject : RTS
;org $8AC5D8 ; < 545D8 - Bank0A.asm:1885 - (LDA $7EF3C7 : CMP.b #$07 : BNE OverworldMap_CheckPendant_fail)
;JSL OverworldMap_CheckObject : RTS
;================================================================================
org $8AC53E ; <- 5453E - Bank0A.asm:1771 - (LDA $0AC50D, X : STA $0D)
LDA.l CrystalNumberTable-1,X
;================================================================================
; EVERY INSTANCE OF STA $7EF3C7 IN THE ENTIRE CODEBASE
org $829D51 : JSL SetLWDWMap
org $8589BB : JSL SetLWDWMap
org $85DD9A : JSL SetLWDWMap

org $85F1F6 : JSL SetLWDWMap
org $85F209 : JSL SetLWDWMap
org $85FF91 : JSL SetLWDWMap

org $898687 : JSL SetLWDWMap
org $9ECEDD : JSL SetLWDWMap
org $9ECF0D : JSL SetLWDWMap
;================================================================================
org $85DDFE : JSL GetMapMode
org $85EE25 : JSL GetMapMode
org $85F17D : JSL GetMapMode
org $85FF7D : JSL GetMapMode
org $8AC01A : JSL GetMapMode
org $8DC849 : JSL GetMapMode
;================================================================================
org $8AC012 ; <- 54012 - Bank0A.asm:1039 (LDA $7EF2DB : AND.b #$20 : BNE BRANCH_DELTA)
NOP #8
;================================================================================
org $828B8F ; <- 10B8F - Bank02.asm:2236 (LDA $7EF374 : LSR A : BCS BRANCH_BETA)
JSL CheckHeraBossDefeated : BNE + : NOP
LDX.b #$F1 : STX.w MusicControlRequest
+
;================================================================================
org $829090 ; <- 11090 - Bank02.asm:3099 (LDA $7EF374 : LSR A : BCS BRANCH_GAMMA)
JSL CheckHeraBossDefeated : BNE + : NOP
STX.w MusicControlRequest ; DON'T MOVE THIS FORWARD OR MADNESS AWAITS
+
;================================================================================
org $829798 ; <- 11798 - Bank02.asm:4287 (CMP $02895C, X : BNE BRANCH_ALPHA)
NOP #6 ; remove crystal room cutscene check that causes softlocks
;================================================================================

;================================================================================
; Text Changes
;--------------------------------------------------------------------------------
org $86C7BB ; <- 347BB - sprite_ponds.asm:702 (JSL Sprite_ShowMessageFromPlayerContact : BCC BRANCH_ALPHA)
JSL FairyPond_Init
;--------------------------------------------------------------------------------
org $9D92EC ; <- E92EC - sprite_ganon.asm:947 (JSL Sprite_ShowMessageMinimal)
JSL DialogGanon1
;--------------------------------------------------------------------------------
org $9D9078 ; <- E9078 - sprite_ganon.asm:552 (LDA.b #$70 : STA $1CF0)
JSL DialogGanon2 : RTS
;--------------------------------------------------------------------------------
;-- Convert Capitalism fairy to shop
org $86C4BD ; <- 34C4BD - sprite_ponds.asm:107 (LDA $A0 : CMP.b #$15 : BEQ Sprite_HappinessPond)
JSL HappinessPond_Check
;--------------------------------------------------------------------------------
;-- Sahasrahla (no green pendant)
org $85F16C ; <- 2F16C sprite_elder.asm:137 (JSL Sprite_ShowSolicitedMessageIfPlayerFacing)
JSL Sprite_ShowSolicitedMessageIfPlayerFacing_Alt
;--------------------------------------------------------------------------------
;-- Sahasrahla (have boots)
org $85F1A8 ; <- 2F1A8 sprite_elder.asm:170 (JSL Sprite_ShowSolicitedMessageIfPlayerFacing)
JSL Sprite_ShowSolicitedMessageIfPlayerFacing_Alt
;--------------------------------------------------------------------------------
;-- Sahasrahla (have boots, have ice rod)
org $85F1BC ; <- 2F1BC sprite_elder.asm:182 (JSL Sprite_ShowSolicitedMessageIfPlayerFacing)
JSL Sprite_ShowSolicitedMessageIfPlayerFacing_Alt
;--------------------------------------------------------------------------------
;-- Sahasrahla (have boots, have ice rod, have 3 pendants)
org $85F1CE ; <- 2F1CE sprite_elder.asm:194 (JSL Sprite_ShowSolicitedMessageIfPlayerFacing)
JSL Sprite_ShowSolicitedMessageIfPlayerFacing_Alt
;--------------------------------------------------------------------------------
;-- Sahasrahla (have boots, have ice rod, have 3 pendants, have master sword)
org $85F1D8 ; <- 2F1D8 sprite_elder.asm:204 (JSL Sprite_ShowSolicitedMessageIfPlayerFacing)
JSL Sprite_ShowSolicitedMessageIfPlayerFacing_Alt
;----------------------------------------------------------
;-- Bomb shop guy (talking to him before and after big bomb is available)
org $9EE181 ; <- F6181 sprite_bomb_shop_entity.asm : 85 (JSL Sprite_ShowSolicitedMessageIfPlayerFacing)
JSL Sprite_ShowSolicitedMessageIfPlayerFacing_Alt
;----------------------------------------------------
;-- Bombos tablet
org $85F3BF ; <- 2F3BF sprite_medallion_tablet.asm : 254 (JSL Sprite_ShowMessageUnconditional)
JSL DialogBombosTablet
;----------------------------------------------------
;-- Ether tablet
org $85F429 ; <- 2F429 sprite_medallion_tablet.asm : 317 (JSL Sprite_ShowMessageUnconditional)
JSL DialogEtherTablet
;----------------------------------------------------
;-- Thrown fish (move to different text ID)
org $9D82B2 ; <-  0xE82B2 low byte of message
db $8F
;================================================================================

;================================================================================
; Text Removal
;--------------------------------------------------------------------------------
org $85FA8E
Sprite_ShowMessageMinimal:
JML Sprite_ShowMessageMinimal_Alt
;--------------------------------------------------------------------------------
org $87B0CC ; <- 3b0d0 - Bank 07.asm : 7767 (JSL Main_ShowTextMessage)
JSL Main_ShowTextMessage_Alt
;--------------------------------------------------------------------------------
org $88C5FE ; <- 445FE - ancilla_receive_item.asm : 408 (JSL Main_ShowTextMessage)
JSL Main_ShowTextMessage_Alt
;--------------------------------------------------------------------------------
org $85E21F ; <- 2E21F - Bank05.asm : 2691 (STZ $0223)
JSL Sprite_ShowMessageMinimal_Alt
BRA Sprite_ShowMessageUnconditional_Rest
org $85E232 ; <- 2E232 - Bank05.asm : 2700 (PHX)
Sprite_ShowMessageUnconditional_Rest:
;--------------------------------------------------------------------------------
;-- Music restarting at zelda fix
org $85ED10 ; <- 2ED10 - sprite_zelda.asm : 233 - (LDA.b #$19 : STA $012C)
NOP #5
;--------------------------------------------------------------------------------
org $9ECE47 ; <- F4E47 - sprite_crystal_maiden.asm : 220
JML MaidenCrystalScript
;--------------------------------------------------------------------------------
org $9ECCEB ; <- F4CEB - sprite_crystal_maiden.asm : 25 ; skip all palette nonsense
BRA CrystalCutscene_Initialize_skip_palette
;--------------------------------------------------------------------------------
org $88C3FD ; <- 443FD - ancilla_receive_item.asm : 89
BRA + : NOP #4 : +
;--------------------------------------------------------------------------------
org $88C5E5 ; <- 445ED - ancilla_receive_item.asm:395 (LDA .item_messages, Y : CMP.w #$FFFF : BEQ .handleGraphics)
JSL DialogItemReceive : NOP #2
org $88C301 ; <- 44301 - ancilla_receive_item.asm:8 (.item_messages)
Ancilla_ReceiveItem_item_messages:
;----------------------------------------------------------
;-- Shopkeepers
org $9EF379 ; <- F7379 sprite_shopkeeper.asm : 810 (JSL Sprite_ShowMessageUnconditional : JSL ShopKeeper_RapidTerminateReceiveItem)
NOP #4 ;Just remove the rapid terminate call
;--------------------------------------------------------------------------------
;-- Reset Dialog Selection index for each new message
org $8EEE5D ; <- 76E5D - vwf.asm:84 (JSL Attract_DecompressStoryGfx)
JSL DialogResetSelectionIndex
;----------------------------------------------------
;-- Agahnim 1 Defeated
org $868475 ; <- 30475 Bank06.asm : 762 - (JSL Sprite_ShowMessageMinimal)
JSL IncrementBossSword
;----------------------------------------------------------
;-- We'll take your sword
org $86B4F3 ; <- 334F3 sprite_smithy_bros.asm : 556 (JSL Sprite_ShowMessageUnconditional)
JSL ItemSet_SmithSword
;----------------------------------------------------------

;===================================
;-- Escort Text
;-- dw coordinate, coordinate, flag, text message number, tagalong number
;===================================
org $89A4C2 ; <- 4A4C2 tagalong.asm : 967 - (.room_data_1)
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
;-- New Sign table offet calculation
org $87B4FE ; <- 3b4fe - bank07.asm : 8454 (LDA $8A : ASL A : TAY)
JSL CalculateSignIndex

;================================================================================
; Dark World Spawn Location Fix & Follower Fixes
;--------------------------------------------------------------------------------
org $80894A ; <- 94A
PHB : JSL DarkWorldSaveFix
;--------------------------------------------------------------------------------
org $828046 ; <- 10046 - Bank02.asm : 217 (JSL EnableForceBlank) (Start of Module_LoadFile)
JSL OnFileLoad
;--------------------------------------------------------------------------------
org $89F520 ; <- 4F520 - module_death.asm : 401 (LDA $7EF3C5 : CMP.b #$03 : BCS BRANCH_THETA)
JSL OnPlayerDead
JSL IncrementDeathCounter : NOP #6
;--------------------------------------------------------------------------------
org $9ED379 ; <- F5379 - sprite_agahnim.asm:75 - JSL PrepDungeonExit
JSL FixAgahnimFollowers
;================================================================================

;================================================================================
; Randomize NPC Items
;--------------------------------------------------------------------------------
org $828823 ; <- 10823 - Bank02.asm:1560 (LDA $7EF3C5 : BEQ .ignoreInput)
JSL AllowSQ
;--------------------------------------------------------------------------------
org $88C45F ; <- 4445F - ancilla_recieve_item.asm:157 (STZ $02E9)
JSL PostItemAnimation : NOP #2
;--------------------------------------------------------------------------------
org $9EE90A ; <- F690A
JSL ItemCheck_OldMan : NOP #2
;--------------------------------------------------------------------------------
org $8280F2 ; <- 100F2
JSL ItemCheck_OldMan : NOP #2
;--------------------------------------------------------------------------------
org $9EE9FE ; <- F69FE
JSL ItemSet_OldMan
;--------------------------------------------------------------------------------
org $868F16 ; <- 30F16
JSL ItemCheck_ZoraKing
;--------------------------------------------------------------------------------
org $859ACA ; <- 29ACA
JSL $9DE1AA ; Sprite_SpawnFlippersItem
;--------------------------------------------------------------------------------
org $9DE1E4 ; <- EE1E4 - sprite_great_catfish.asm : 489
JSL LoadZoraKingItemGFX : NOP #2
;--------------------------------------------------------------------------------
org $868D86 ; <- 30D86
JSL ItemCheck_SickKid
;--------------------------------------------------------------------------------
org $86B9D4 ; <- 339D4 - sprite_bug_net_kid.asm : 111 (JSL Link_ReceiveItem)
JSL ItemSet_SickKid
;--------------------------------------------------------------------------------
org $868BAC ; <- 30BAC - SpritePrep_FluteBoy : 1068
JSL ItemCheck_TreeKid2

org $86908D ; <- 3108D - SpritePrep_FluteBoy : 2175
JSL ItemCheck_TreeKid : CMP.b #$08 : BEQ $0A

org $869095 ; <- 31095 - SpritePrep_FluteBoy : 2177
JSL ItemCheck_TreeKid : CMP.b #$08

org $8690BD ; <- 310BD - SpritePrep_FluteBoy : 2202
JSL ItemCheck_TreeKid2

org $86AF9B ; <- 32F9B - FluteBoy_Chillin : 73 : LDA $7EF34C : CMP.b #$02 : BCS .player_has_flute
LDA HasGroveItem : AND.b #$01
db $D0 ; BNE

org $86B062 ; <- 33062 - FluteAardvark_InitialStateFromFluteState : 225 : LDA $7EF34C : AND.b #$03 : !BGE #$05
JSL ItemCheck_TreeKid2 : NOP #$02 ; remove pointless AND

org $86B048 ; <- 33048
JSL ItemCheck_TreeKid3

org $86AF59 ; <- 32F59 - sprite_flute_boy.asm : 36 (LDA $0D80, X : CMP.b #$03 : BEQ .invisible)
JML FluteBoy
FluteBoy_Abort:
RTS
FluteBoy_Continue:

;--------------------------------------------------------------------------------
org $86B0C9 ; <- 330C9
JSL ItemSet_TreeKid
;--------------------------------------------------------------------------------
org $85F177 ; <- 2F177
JSL ItemCheck_Sahasrala
;--------------------------------------------------------------------------------
org $85F200 ; <- 2F200
JSL ItemSet_Sahasrala
;--------------------------------------------------------------------------------
org $9DE102 ; <- EE102
JSL ItemCheck_Catfish
org $9DE11C ; <- EE11C
JSL ItemCheck_Catfish
;--------------------------------------------------------------------------------
org $9DE1A1 ; <- EE1A1 - sprite_great_catfish.asm : 445
JSL LoadCatfishItemGFX : NOP #2
;--------------------------------------------------------------------------------
org $9DDF49 ; <- EDF49 - sprite_great_catfish.asm : 19
JML JumpToSplashItemTarget : NOP
org $9DDF4E ; <- EDF4E - sprite_great_catfish.asm : 21
SplashItem_SpawnSplash:
org $9DDF52 ; <- EDF52 - sprite_great_catfish.asm : 27
SplashItem_SpawnOther:
org $9DE228 ; <- EE228 - sprite_great_catfish.asm : 290
LDA.b #$FF
;--------------------------------------------------------------------------------
org $9DDF81 ; <- EDF81 - sprite_great_catfish.asm : 61
JSL DrawThrownItem
;--------------------------------------------------------------------------------
org $85EE53 ; <- 2EE53 - mushroom.asm : 22
JSL ItemCheck_Mushroom : NOP #2
;--------------------------------------------------------------------------------
org $85EE8C ; <- 2EE8C - mushroom.asm : 69
JSL ItemSet_Mushroom : NOP
;--------------------------------------------------------------------------------
org $85F53E ; <- 2F53E - sprite_potion_shop.asm : 40
JSL ItemCheck_Powder : CMP.b #$20
;--------------------------------------------------------------------------------
; the quake medallion AND FLIPPERS
org $9DDF71 ; <- EDF71 - sprite_great_catfish.asm : 47
JSL MarkThrownItem
;--------------------------------------------------------------------------------
org $85FAFF ; <- 2FAFF - sprite_mad_batter.asm:57 (LDA $7EF37B : CMP.b #$01 : BCS .magic_already_doubled)
JSL ItemCheck_MagicBat : BEQ + : RTS : NOP : +
;================================================================================

;================================================================================
; Boss Hearts
;--------------------------------------------------------------------------------
org $85EF5D ; <- 2EF5D - sprite_heart_upgrades.asm:110 (JSL GetAnimatedSpriteTile.variable)
JSL HeartContainerSpritePrep
;--------------------------------------------------------------------------------
org $85EF79 ; <- 2EF79 - sprite_heart_upgrades.asm:128 (JSL Sprite_PrepAndDrawSingleLargeLong)
JSL DrawHeartContainerGFX
;--------------------------------------------------------------------------------
org $85EFCE ; <- 2EFCE - sprite_heart_upgrades.asm:176 (JSL Link_ReceiveItem)
JSL HeartContainerGet
;--------------------------------------------------------------------------------
;--------------------------------------------------------------------------------
org $8799B1 ; 399B1 - Bank07.asm:4063 (CPY.b #$3E : BNE .notHeartContainer)
JSL HeartContainerSound : BCC Link_ReceiveItem_notHeartContainer
org $8799BA ; 399BA - Bank07.asm:4070 (LDA.b #$60 : STA $02D9)
Link_ReceiveItem_notHeartContainer:
;--------------------------------------------------------------------------------
org $89887F ; <- 4887F - ancilla_init.asm : 1163 (LDA $0C5E, X : CMP.b #$3E : BEQ .doneWithSoundEffects)
JSL NormalItemSkipSound : NOP : BCS AddReceivedItem_doneWithSoundEffects
org $8988AE ; <- 488AE - ancilla_init.asm : 1193 (LDA.b #$0A : STA $02)
AddReceivedItem_doneWithSoundEffects:
;================================================================================
; Heart Pieces
;--------------------------------------------------------------------------------
org $85F030 ; <- 2F030 - display item
JSL DrawHeartPieceGFX
;--------------------------------------------------------------------------------
org $85F08A ; <- 2F08A - sprite_heart_upgrades.asm : 324 - (LDA $7EF36B : INC A : AND.b #$03 : STA $7EF36B : BNE .got_4_piecese) item determination
JSL HeartPieceGet
JSL DynamicDrawCleanup
JSL IsMedallion
BCS + : BRA Sprite_EB_HeartPiece_handle_flags : + ; Don't change OW flags if we're
STZ.w SpriteAITable, X : RTS                      ; getting a tablet item
;--------------------------------------------------------------------------------
org $86C0B0 ; <- 340B0 - sprite prep
JSL HeartPieceSpritePrep
;--------------------------------------------------------------------------------
org $88C45B ; <- 4445B - ancilla_receive_item.asm : 152
JSL HPItemReset
;================================================================================

;================================================================================
; Fake Flippers Softlock Fix + General Damage Hooks
;--------------------------------------------------------------------------------
org $878091 ; <- 38091 - Bank07.asm:138 (LDA $037B : BNE .linkNotDamaged)
LDA.w DamageReceived : STA.b Scrap00 : STZ.w DamageReceived ; store and zero damage
LDA.w NoDamage : BNE LinkDamaged_linkNotDamaged ; skip if immune
;--------------------------------------------------------------------------------
org $8780C6 ; <- 380C6 - Bank07.asm:174 (LDA $7EF36D)
JSL OnLinkDamaged
;--------------------------------------------------------------------------------
org $8780FB ; <- 380FB - Bank07.asm:207 (.linkNotDamaged)
LinkDamaged_linkNotDamaged:
;--------------------------------------------------------------------------------
org $8794FB ; <- 394FB - Bank07.asm:3336 (LDA.b #$14 : STA $11)
JSL OnLinkDamagedFromPit
;--------------------------------------------------------------------------------
org $81FFE7 ; <- FFE7 - Bank01.asm:16375 (LDA $7EF36D)
JSL OnLinkDamagedFromPitOutdoors
;--------------------------------------------------------------------------------
org $82B468
dw FakeFlipperProtection

org $82FFC7
FakeFlipperProtection:
	JSR.w $029485
	JSL protectff
	RTS
;--------------------------------------------------------------------------------
;org $878F51 ; <- 38F51 - Bank07.asm:2444 (JSR $AE54 ; $3AE54 IN ROM)
;JSL OnEnterWater : NOP
;================================================================================
; Floodgate Softlock Fix
;--------------------------------------------------------------------------------
org $8AB8E5 ; <- 538E5
JSL FloodGateAndMasterSwordFollowerReset
JSL IncrementFlute
STZ.w GFXStripes : STZ.w GFXStripes+1
BRA ++ : NOP #24 : ++
;--------------------------------------------------------------------------------
org $82AA87 ; <- 12A87
JSL OnOWTransition : BRA ++ : NOP #34 : ++

;================================================================================
;Inverted mode tile map update (executed right after the original tile load)
;--------------------------------------------------------------------------------
org $82ED51
JSL Overworld_LoadNewTiles : BRA ++ : ++
org $82EC2E
JSL Overworld_LoadNewTiles : BRA ++ : ++
;================================================================================
org $87A3E2 ;<- 3A3E2 Bank07.asm:5764 (LDA.b #$80 : STA $03F0)
JSL FreeDuckCheck : BEQ +
	NOP
	skip 3 ; a JSR we need to keep
+
;================================================================================
org $87A9AC ; <- 3A9AC - Bank07.asm:6628 (LDA $0C : ORA $0E : STA $00 : AND.b #$0C : BEQ BRANCH_BETA)
JML MirrorBonk
MirrorBonk_NormalReturn:
org $87A9D1 ; <- 3A9D1 - Bank07.asm:6649 (BRANCH_GAMMA:)
MirrorBonk_BranchGamma:
;================================================================================

;================================================================================
; Add SFX
;--------------------------------------------------------------------------------
org $9DFDA8 ; <- EFDA9 - sprite_digging_game_guy.asm:309 (STA $7FFE00)
JSL SpawnShovelGamePrizeSFX
;--------------------------------------------------------------------------------
org $81EECD ; <- EECD - Bank01.asm:14160 (LDA.b #$0E : STA $012F)
JSL SpawnChestGamePrizeSFX : NOP
;================================================================================

;================================================================================
; Heart Beep Timer
;--------------------------------------------------------------------------------
org $8DDC9B ; <- 6DC9B
JSL BeepLogic : NOP #6
;================================================================================

;================================================================================
; Item Downgrade Fix
;--------------------------------------------------------------------------------
org $89865E ; <- 4865E
JSL $9BEE1B ; fix something i wrote over i shouldn't have
;--------------------------------------------------------------------------------
org $898638 ; <- 48638 - ancilla_init.asm:737 - LDA .item_values, Y : BMI .dontWrite (BMI)
JSL ItemDowngradeFix
;================================================================================

;================================================================================
; Lamp Mantle & Light Cone Fix
;--------------------------------------------------------------------------------
org $9AFC4D ; <- D7C4D - sprite_movable_mantle.asm:31 (LDA $7EF3CC : CMP.b #$01 : BNE .return)
JSL CheckForZelda
;--------------------------------------------------------------------------------
org $9AFC55 ; <- D7C55 - sprite_movable_mantle.asm:34 (LDA $7EF34A : BEQ .return)
NOP #6 ; remove check
;--------------------------------------------------------------------------------
org $868841 ; <- 30841 - sprite_prep.asm:269 (LDA $0D00, X : ADD.b #$03 : STA $0D00, X)
JSL Mantle_CorrectPosition : NOP #2
;--------------------------------------------------------------------------------
org $8DFA53 ; <- 6FA53 - hud check for lantern
JSL LampCheck
;--------------------------------------------------------------------------------
org $81F503 ; <- F503 - Bank01.asm:14994 (LDA.b #$01 : STA $1D)
JSL SetOverlayIfLamp
;================================================================================

;================================================================================
; Overworld Door Frame Overlay Fix
;
; When entering an overworld entrance, if it is an entrance to a simple cave, we
; store the overworld door id, then use that (instead of the cave id) to determine the
; overlay to draw when leaving the cave again. We also use this value to
; identify the tavern entrance to determine whether link should walk up or down.
;--------------------------------------------------------------------------------
org $9BBD5F ; <- Bank1b.asm:296 (LDA $1BBB73, X : STA $010E)
JSL StoreLastOverworldDoorID : NOP #3
;--------------------------------------------------------------------------------
org $82D754 ; <- Bank02.asm:10847 (LDA $D724, X : STA $0696 : STZ $0698)
JSL CacheDoorFrameData : NOP #5
;--------------------------------------------------------------------------------
org $8298AD ; <- Bank02.asm:4495 (LDA $010E : CMP.b #$43)
JSL WalkDownIntoTavern : NOP #1
;================================================================================

;================================================================================
; Hole fixes
;--------------------------------------------------------------------------------
org $9BB88E ; <- DB88E - Bank1B.asm:59 (LDX.w #$0024)
JML CheckHole
org $9BB8A4 ; <- DB8A4 - Bank1B.asm:78 (LDX.w #$0026)
Overworld_Hole_GotoHoulihan:
org $9BB8AF ; <- DB8AF - Bank1B.asm:85 (.matchedHole)
Overworld_Hole_matchedHole:
org $9BB8BD ; <- DB8BD - Bank1B.asm:85 (PLB)
Overworld_Hole_End:

;================================================================================
; Replace pyramid hole check for killing aga2
;
; this check is intended to prevent getting fluted out a second time if you 
; return to his room after already killing him once.
;---------------------------------------------------------------------------------
org $81C74E ; 00C74E - bank_01.asm:13281 - (LDA.l $7EF2DB : AND.b #$20)
LDA.l Aga2Duck : NOP #2

;================================================================================
; Music fixes
;--------------------------------------------------------------------------------
org $8282F4 ; <- Bank02.asm:654 (LDY.b #$58 ...)
JML PreOverworld_LoadProperties_ChooseMusic
org $828389  ; <- Bank02.asm:763
PreOverworld_LoadProperties_SetSong:
;--------------------------------------------------------------------------------
; Remove Aga1 check for Kakariko music, always play track 7
org $82A992 ; (BCS $A999)
NOP #2
org $82A9B0 ; (BCS $A9B7)
NOP #2
org $82C1C8 ; (BCS $C1CC)
NOP #2
org $82ADA0 ; (LDA.b #$F1 : STA $012C)
JSL Overworld_MosaicDarkWorldChecks : NOP
;--------------------------------------------------------------------------------
org $85CC58 ; <- Bank05.asm:1307 (LDA $040A : CMP.b #$18)
JSL PsychoSolder_MusicCheck : NOP #1
;--------------------------------------------------------------------------------
org $82B13A ; <- Bank02.asm:7647
dl Overworld_FinishMirrorWarp
;--------------------------------------------------------------------------------
org $8AB949 ; <- Bank0A.asm:270 (Different from US ROM)
JSL BirdTravel_LoadTargetAreaMusic : NOP #16
;================================================================================

;================================================================================
; Hooks for roomloading.asm
;--------------------------------------------------------------------------------
org $82895D ; <- Bank02.asm:1812 (JSL Dungeon_LoadRoom)
JSL LoadRoomHook
;--------------------------------------------------------------------------------
org $828BE7 ; <- Bank02.asm:2299 (JSL Dungeon_LoadRoom)
JSL LoadRoomHook_noStats
;--------------------------------------------------------------------------------
org $829309 ; <- Bank02.asm:3533 (JSL Dungeon_LoadRoom)
JSL LoadRoomHook_noStats
;--------------------------------------------------------------------------------
org $82C2F3 ; <- Bank02.asm:10391 (JSL Dungeon_LoadRoom)
JSL LoadRoomHook_noStats
;================================================================================

;================================================================================
; Hooks into the "Reloading all graphics" routine
;--------------------------------------------------------------------------------
org $80E64D ; <- Bank00.asm:5656 (STZ $00 : STX $01 : STA $02)
JML BgGraphicsLoading
BgGraphicsLoadingCancel:
RTS : NOP
BgGraphicsLoadingResume:
;================================================================================

;================================================================================
; Hook when updating the floor tileset in dungeons (such as between floors)
;--------------------------------------------------------------------------------
org $80DF62 ; <- Bank00.asm:4672 (LDX.w #$0000 : LDY.w #$0040)
JML ReloadingFloors : NOP #2
ReloadingFloorsResume:
org $80DF6E ; <- A few instructions later, right after JSR Do3To.high16Bit
ReloadingFloorsCancel:
;================================================================================

;================================================================================
; Hook bow use - to use rupees instead of actual arrows
;--------------------------------------------------------------------------------
org $87A055 ; <- Bank07.asm:5205 (LDA $0B99 : BEQ BRANCH_DELTA)
JSL ArrowGame : BRA ++ : NOP #12 : ++

org $87A06C ; <- Bank07.asm:5215 (LDA $7EF377 : BEQ BRANCH_EPSILON)
JSL DecrementArrows : SKIP 2 : NOP : LDA CurrentArrows
;================================================================================

;================================================================================
; Quick Swap
;--------------------------------------------------------------------------------
org $8287FB ; <- 107FB - Bank02.asm:1526 (LDA $F6 : AND.b #$40 : BEQ .dontActivateMap)
JSL QuickSwap

org $82A451 ; <- 12451 - Bank02.asm:6283 (LDA $F6 : AND.b #$40 : BEQ .xButtonNotDown)
JSL QuickSwap
;================================================================================

;================================================================================
; Tagalong Fixes
;--------------------------------------------------------------------------------
org $8689AB ; <- 309AB - sprite_prep.asm: 647 (LDA $7EF3CC : CMP.b #$06 : BEQ .killSprite)
; Note: In JP 1.0 we have: (CMP.b #$00 : BNE .killSprite) appling US bugfix
; Prevent followers from causing blind/maiden to despawn:
CMP.b #$06 : db $F0 ; BEQ
;--------------------------------------------------------------------------------
; Fix old man purple chest issues using the same method as above
org $9EE906 ; <- F6906 - sprite_old_mountain_man.asm : 31 (LDA $7EF3CC : CMP.b #$00 : BNE .already_have_tagalong)
CMP.b #$04 : db $F0 ; BEQ
;--------------------------------------------------------------------------------
;Control which doors frog/smith can enter
org $9BBCF0 ; <- DBCF0 - Bank1B.asm: 248 (LDA $04B8 : BNE BRANCH_MU)
Overworld_Entrance_BRANCH_LAMBDA: ; Branch here to show Cannot Enter with Follower message

org $9BBD55 ; <- DBD55 - Bank1B.asm: 290 (CPX.w #$0076 : BCC BRANCH_LAMBDA)
JML SmithDoorCheck : NOP
Overworld_Entrance_BRANCH_RHO: ; branch here to continue into door
;================================================================================

;================================================================================
; Paradox Cave Shopkeeper Fixes
;--------------------------------------------------------------------------------
org $808C19 ; Bank00.asm 1633 (LDA.b #$01 : STA MDMAEN)
JSL ParadoxCaveGfxFix : NOP
;================================================================================

;================================================================================
; Resolve conflict between race game and witch item
;--------------------------------------------------------------------------------
; Change race game to use $021B instead of $0ABF for detecting cheating
org $8DCB9D ; STZ.w $0ABF
STZ.w RaceGameFlag

org $8DCBFE ; LDA.w $0ABF
LDA.w RaceGameFlag

org $82BFE0 ; LDA.b #$01 : STA.w $0ABF
JSL SetOverworldTransitionFlags : NOP
; For mirroring, the new flag is set in IncrementOWMirror in stats.asm
;================================================================================

;================================================================================
; Player Sprite Fixes
;--------------------------------------------------------------------------------
org $8DA9C8 ; <- 06A9C8 - player_oam.asm: 1663 (AND.w #$00FF : CMP.w #$00F8 : BCC BRANCH_MARLE)
; We are converting this branching code that basically puts the carry from the
; CMP into $02 into constant time code, so that player sprite head-bobbing can
; be removed by sprites while remaining race legal (cycle-for-cycle identical
; to the link sprite).
LDA.b Scrap02 ; always zero! (this replaces the BCC)
ADC.w #0000 ; put the carry bit into the accumulator instead of a hardcoded 1.
;-------------------------------------------------------------------------------
org $82FD6F ; <- 017d6f - bank0E.asm: 3694 (LoadActualGearPalettes:) Note: Overflow of bank02 moved to 0e in US Rom
JSL LoadActualGearPalettesWithGloves : RTL
;--------------------------------------------------------------------------------
; Bunny Palette/Overworld Map Bugfix
;--------------------------------------------------------------------------------
org $82FDF0 ; <- 017df0 - bank0E (LDA [$00] : STA $7EC300, X : STA $7EC500, X)
JSL LoadGearPalette_safe_for_bunny : RTS
;================================================================================

;================================================================================
; Chest Encryption
;--------------------------------------------------------------------------------
org $81EBEB ; <- 0EBEB - bank01.asm : 13760 (INC $0E)
JML GetChestData : NOP
org $81EBDE ; <- 0EBDE - bank01.asm : 13740 (.couldntFindChest)
Dungeon_OpenKeyedObject_couldntFindChest:
org $81EBF0 ; <- 0EBF0 - bank01.asm : 13764 (.nextChest)
Dungeon_OpenKeyedObject_nextChest:
org $81EC14 ; <- 0EC14 - bank01.asm : 13783 (LDX $040C)
Dungeon_OpenKeyedObject_bigChest:
org $81EC38 ; <- 0EC38 - bank01.asm : 13809 (.smallChest)
Dungeon_OpenKeyedObject_smallChest:
;================================================================================

;================================================================================
; Murahdahla (The brother who re-assembles the triforce pieces)
;--------------------------------------------------------------------------------
org $86C092 ; bank06.asm:1864 (JSL Sprite_ElderLong) [22 CD F0 05]
JSL NewElderCode
;--------------------------------------------------------------------------------
; Add him to Castle Map post-rain, and post aga1
;--------------------------------------------------------------------------------
org $89D0AC
db $18, $0F, $43, $FF ; remove heart from tree adjancent map [LW1]
db $12, $19, $16 ; add sahasrala in castle Y, X, Sprite ID
org $89C937
db $B0, $D0 ; change [LW1] map 01C pointers
org $89D421
db $18, $0F, $45, $FF ; remove heart from tree adjancent map [LW2]
db $12, $19, $16 ; add sahasrala in castle Y, X, Sprite ID
org $89CA57
db $25, $D4 ; change [LW2] map 01C pointers
;--------------------------------------------------------------------------------
; Expanded trinexx sheet gfx.
;--------------------------------------------------------------------------------
org $80CFC0+178 : db ExpandedTrinexx>>16
org $80D09F+178 : db ExpandedTrinexx>>8
org $80D17E+178 : db ExpandedTrinexx>>0
; Use above sheet in Hyrule castle courtyard after rain state.
org $80DB9E ; Hyrule Castle GFX Sprite Sheet 4 on [LW1]
db $3F
org $80DC0A ; Hyrule Castle GFX Sprite Sheet 4 on [LW2]
db $3F
;--------------------------------------------------------------------------------
; Updated evil barrier animation table
;--------------------------------------------------------------------------------
org $9DF0E1 ;Evil Barrier new draw code

dw   0,  0 : db $CC, $00, $00, $02
dw -29,  3 : db $EA, $00, $00, $00
dw -29, 11 : db $FA, $00, $00, $00
dw  37,  3 : db $EA, $40, $00, $00
dw  37, 11 : db $FA, $40, $00, $00
dw -24, -2 : db $CE, $00, $00, $02
dw  -8, -2 : db $CE, $00, $00, $02
dw   8, -2 : db $CE, $40, $00, $02
dw  24, -2 : db $CE, $40, $00, $02

dw   0,  0 : db $EC, $00, $00, $02
dw -29,  3 : db $EB, $00, $00, $00
dw -29, 11 : db $FB, $00, $00, $00
dw  37,  3 : db $EB, $40, $00, $00
dw  37, 11 : db $FB, $40, $00, $00
dw   0,  0 : db $EC, $00, $00, $02
dw   0,  0 : db $EC, $00, $00, $02
dw   0,  0 : db $EC, $00, $00, $02
dw   0,  0 : db $EC, $00, $00, $02

dw   0,  0 : db $EC, $00, $00, $02
dw -29,  3 : db $EB, $00, $00, $00
dw -29, 11 : db $FB, $00, $00, $00
dw  37,  3 : db $EB, $40, $00, $00
dw  37, 11 : db $FB, $40, $00, $00
dw -24, -2 : db $CE, $80, $00, $02
dw  -8, -2 : db $CE, $80, $00, $02
dw   8, -2 : db $CE, $C0, $00, $02
dw  24, -2 : db $CE, $C0, $00, $02

dw   0,  0 : db $CC, $00, $00, $02
dw -29,  3 : db $EA, $00, $00, $00
dw -29, 11 : db $FA, $00, $00, $00
dw  37,  3 : db $EA, $40, $00, $00
dw  37, 11 : db $FA, $40, $00, $00
dw   0,  0 : db $CC, $00, $00, $02
dw   0,  0 : db $CC, $00, $00, $02
dw   0,  0 : db $CC, $00, $00, $02
dw   0,  0 : db $CC, $00, $00, $02

dw -29,  3 : db $EB, $00, $00, $00
dw -29, 11 : db $FB, $00, $00, $00
dw  37,  3 : db $EB, $40, $00, $00
dw  37, 11 : db $FB, $40, $00, $00
dw  37, 11 : db $FB, $40, $00, $00
dw  37, 11 : db $FB, $40, $00, $00
dw  37, 11 : db $FB, $40, $00, $00
dw  37, 11 : db $FB, $40, $00, $00
dw  37, 11 : db $FB, $40, $00, $00
;================================================================================

;--------------------------------------------------------------------------------
; Allow Bunny Link to Read Signposts
;--------------------------------------------------------------------------------
org $87839E ; bunny BAGE check
BunnyRead:
	JSR.w $07B5A9 ; check A button
	BCC .noA
	JSR.w CheckIfReading
	BNE .noread
	JSR.w $07B4DB
	NOP
.noread
.noA

org $87FFF4
CheckIfReading:
	JSR.w $07D36C ; check action
	LDA.b #$80 : TRB.b $3B
	CPX.b #$04
	RTS

;================================================================================

; remove kill room requirements
org $8DB4CA : db $40, $40 ; fire bar
org $8DB4A9 : db $50, $50, $6E, $6E ; roller
org $8DB4B2 : db $40, $40, $40, $40 ; cannon
org $8DB4C3 : db $C0 ; anti fairy
org $8DB516 : db $40 ; chain chomp

;--------------------------------------------------------------------------------
; Keep Firebar Damage on Same Layer
;--------------------------------------------------------------------------------
org $9ED1B6 : JSL NewFireBarDamage

;================================================================================
; Remove heart beeps from 1/2 max HP
org $8DDB60
db $00, $00
;================================================================================
; Credits
;================================================================================
org $8EE651 : JSL LoadCreditsTiles
org $8EEDAF : JSL NearEnding
org $8EEDD9 : JSL EndingItems
org $8EE828 : JSL PreparePointer : LDA.b [CreditsPtr],Y : NOP
org $8EE83F : LDA.b [CreditsPtr],Y : NOP
org $8EE853
LDA.b [CreditsPtr],Y : NOP : AND.w #$00FF : ASL A : JSL CheckFontTable
org $8EE86D : JSL RenderCreditsStatCounter : JMP.w AfterDeathCounterOutput
org $82857D : JSL LoadOverworldCreditsTiles
;================================================================================
; Fast credits
org $8EC2B1 : JSL FlagFastCredits
org $82A096 : JSL DumbFlagForMSU
org $8EC3AF : JSL FastCreditsScrollOW : JMP.w $0EC3C7
org $8EC41F : JSL FastCreditsCutsceneUnderworldY
org $8EC42C : JSL FastCreditsCutsceneUnderworldX
org $8EC488 : JSL FastCreditsCutsceneTimer
org $8EE773 : JSL FastTextScroll : NOP

;================================================================================
org $81FFEE : JSL IncrementDamageTakenCounter_Eight ; overworld pit
org $879506 : JSL IncrementDamageTakenCounter_Eight ; underworld pit

org $87B0B1 : JSL IncrementMagicUseCounter

;================================================================================
; Boss icons
org $8AEEDF : db $02 ; big icon
org $8AEAFF : db $48 ; X position

org $8AEED4 ; disable flashing
BRA ++ : NOP #6 : ++

org $8AEEF2
SBC.b #$03 : STA.w $0801,X
LDA.b #$03 : STA.w $0802,X
LDA.b #$31 : STA.w $0803,X

org $808BE5 ; hijack stripes for boss GFX transfer
JSL DoDungeonMapBossIcon

;================================================================================
org $81C4B8
JSL FixJingleGlitch
org $81C536
JSL FixJingleGlitch
org $81C592
JSL FixJingleGlitch
org $81C65F
JSL FixJingleGlitch

;================================================================================
; Text Renderer
;--------------------------------------------------------------------------------
org $8EF51B : JML RenderCharExtended
org $8EF520 : RenderCharExtended_returnOriginal:
org $8EF567 : RenderCharExtended_returnUncompressed:
org $8EF356 : JSL RenderCharLookupWidth
org $8EF3BA : JSL RenderCharLookupWidth
org $8EF48E : JML RenderCharLookupWidthDraw
org $8EF499 : RenderCharLookupWidthDraw_return:
org $8EF6AA : JML RenderCharToMapExtended
org $8EF6C2 : RenderCharToMapExtended_return:
org $8EFA50 : JSL RenderCharSetColorExtended
org $8EEE5D : JSL RenderCharSetColorExtended_init
org $8EF285 : JSL RenderCharSetColorExtended_close : NOP

;================================================================================
; VRAM
;--------------------------------------------------------------------------------
org $008BE5 ; hijack stripes
JSL.l TransferVRAMStripes

;===================================================================================================
; Fix fairy palette on file select
;===================================================================================================
org $9BF029+1 : db $10

;===================================================================================================
; Item decompression/loading
;===================================================================================================
; mushroom - are these even necessary in rando?
org $8283CF : JSL TransferItemReceiptToBuffer_using_GraphicsID
org $82ADB6 : JSL TransferItemReceiptToBuffer_using_GraphicsID
org $82ADE9 : JSL TransferItemReceiptToBuffer_using_GraphicsID

; big key
org $869261 : JSL TransferItemReceiptToBuffer_using_GraphicsID

; falling items
org $898BD2 : JSL TransferItemReceiptToBuffer_using_GraphicsID

; misc
org $89878C : JSL TransferItemReceiptToBuffer_using_GraphicsID

; rupees
org $88C6A0 : JSL TransferRupeesProperly


; pond items
org $898A4D : JSL TransferItemReceiptToBuffer_using_GraphicsID
org $898AEE : JSL TransferItemReceiptToBuffer_using_GraphicsID

; flute
org $898C85 : JSL TransferItemReceiptToBuffer_using_GraphicsID

; gt cutscene
org $899BBE : JSL TransferItemReceiptToBuffer_using_GraphicsID

;===================================================================================================
; gratuitous NOPs removed for speed
;===================================================================================================
org $1D8E75 : RTS

org $1DB5D8 : JML.l $9DB5DF
org $1DB605 : JML.l $9DB60C
org $1DBBF1 : JML.l $9DBBF8
org $1DBC19 : JML.l $9DBC20
org $1DC072 : JMP.w $9DC079
org $1DC0A5 : JMP.w $9DC0AC
org $1DED3B : JML.l $9DED42
org $1DED7A : JML.l $9DED81

org $05B55E : JMP ++ : ++
org $05B580 : JMP ++ : ++

org $05B5BE : RTS

org $0DD7AD : JMP ++ : ++
org $0DD7CB : JMP ++ : ++

org $1E8A85 : RTS

org $1E8955 : LDA 1,S : NOP
org $1E8973 : LDA 1,S : NOP
org $1E89AF : LDA 1,S : NOP
org $1E89D5 : LDA 1,S : NOP
org $1EB797 : LDA 1,S : NOP
org $1EB7D1 : LDA 1,S : NOP
org $1ED0A9 : LDA 1,S : NOP

org $1ED122 : JMP ++ : ++
org $1ED141 : JMP ++ : ++

;===================================================================================================
