;================================================================================
; Item Tables
;--------------------------------------------------------------------------------
org $308000 ; bank #$30 ; PC 0x180000
HeartPieceIndoorValues:
HeartPiece_Forest_Thieves:
	db #$17 ; #$17 = Heart Piece
HeartPiece_Lumberjack_Tree:
	db #$17
HeartPiece_Spectacle_Cave:
	db #$17
HeartPiece_Circle_Bushes:
	db #$17
HeartPiece_Graveyard_Warp:
	db #$17
HeartPiece_Mire_Warp:
	db #$17
HeartPiece_Smith_Pegs:
	db #$17
;--------------------------------------------------------------------------------
org $308010 ; PC 0x180010
RupeeNPC_MoldormCave:
	db #$46 ; #$46 = 300 Rupees
RupeeNPC_NortheastDarkSwampCave:
	db #$46 ; #$46 = 300 Rupees
LibraryItem:
	db #$1D ; #$1D = Book of Mudora
MushroomItem:
	db #$29 ; #$29 = Mushroom
WitchItem:
	db #$0D ; #$0D = Magic Powder
MagicBatItem:
	db #$4E ; #$4E = Half Magic Item (Default) - #$FF = Use Original Logic - See "HalfMagic" Below
EtherItem:
	db #$10 ; #$10 = Ether Medallion
BombosItem:
	db #$0F ; #$0F = Bombos Medallion
;--------------------------------------------------------------------------------
org $308020 ; PC 0x180020
DiggingGameRNG:
	db #$0F ; #$0F = 15 digs (default) (max ~30)
org $1DFD95 ; PC 0xEFD95
	db #$0F ; #$0F = 15 digs (default) (max ~30)
org $308021 ; PC 0x180021
ChestGameRNG:
db #$00 ; #$00 = 2nd chest (default) - #$01 = 1st chest
;--------------------------------------------------------------------------------
;0 = Bombos
;1 = Ether
;2 = Quake
org $308022 ; PC 0x180022
MireRequiredMedallion:
db #$01 ; #$01 = Ether (default)

org $308023 ; PC 0x180023
TRockRequiredMedallion:
db #$02 ; #$02 = Quake (default)
;--------------------------------------------------------------------------------
org $308024 ; PC 0x180024
BigFairyHealth:
db #$A0 ; #$A0 = Refill Health (default) - #$00 = Don't Refill Health
BigFairyMagic:
db #$00 ; #$80 = Refill Magic - #$00 = Don't Refill Magic (default)
SpawnNPCHealth:
db #$A0 ; #$A0 = Refill Health (default) - #$00 = Don't Refill Health
SpawnNPCMagic:
db #$00 ; #$80 = Refill Magic - #$00 = Don't Refill Magic (default)
;--------------------------------------------------------------------------------
org $308028 ; PC 0x180028
FairySword:
db #$03 ; #$03 = Golden Sword (default)

PedestalMusicCheck:
;org $08C435 ; <- 44435 - ancilla_receive_item.asm : 125
;db #$01 ; #$01 = Master Sword (default)
org $0589B0 ; PC 0x289B0 ; sprite_master_sword.asm : 179
PedestalSword:
db #$01 ; #$01 = Master Sword (default)

org $308029 ; PC 0x180029
SmithItemMode:
db #$01 ; #$00 = Classic Tempering Process - #$01 = Quick Item Get (default)
SmithItem:
db #$02 ; #$02 = Tempered Sword (default)

;org $06B48E ; PC 0x3348E ; sprite_smithy_bros.asm : 473
;SmithSwordCheck:
;db #$03 ; #$03 = Tempered Sword (default) ; THESE VALUES ARE +1
org $06B55C ; PC 0x3355C ; sprite_smithy_bros.asm : 634
SmithSword:
db #$02 ; #$02 = Tempered Sword (default)

;org $05EBD4 ; PC 0x2EBD4 - sprite_zelda.asm:23 - (LDA $7EF359 : CMP.b #$02 : BCS .hasMasterSword) - Zelda Spawnpoint Sword Check
;db #$05 ; #$02 = Tempered Sword (default) - #$05 = All Swords
;--------------------------------------------------------------------------------
org $308030 ; PC 0x180030
EnableSRAMTrace:
db #$00 ; #$00 = Off (default) - #$01 = On
;--------------------------------------------------------------------------------
org $308031 ; PC 0x180031
EnableEasterEggs:
db #$00 ; #$00 = Off (default) - #$01 = On
;--------------------------------------------------------------------------------
org $308032 ; PC 0x180032
OpenMode:
db #$01 ; #$00 = Classic (default) - #$01 = Open
;--------------------------------------------------------------------------------
org $308033 ; PC 0x180033
HeartBeep:
db #$20 ; #$00 = Off - #$20 = Normal (default) - #$40 = Half Speed - #$80 = Quarter Speed
;--------------------------------------------------------------------------------
org $308034 ; PC 0x180034
StartingMaxBombs:
db #10 ; #10 = Default (10 decimal)
StartingMaxArrows:
db #30 ; #30 = Default (30 decimal)
;--------------------------------------------------------------------------------
org $308036 ; PC 0x180036
RupoorDeduction:
dw #$000A ; #$0A - Default (10 decimal)
;--------------------------------------------------------------------------------
org $308038 ; PC 0x180038
LampConeSewers:
db #$01 ; #$00 = Off - #$01 = On (default)
LampConeLightWorld:
db #$01 ; #$00 = Off - #$01 = On (default)
LampConeDarkWorld:
db #$00 ; #$00 = Off (default) - #$01 = On
;--------------------------------------------------------------------------------
org $30803B ; PC 0x18003B
MapMode:
db #$00 ; #$00 = Always On (default) - #$01 = Require Map Item
CompassMode:
db #$02 ; #$00 = Off (default) - #$01 = Display Dungeon Count w/Compass - #$02 = Display Dungeon Count Always
;--------------------------------------------------------------------------------
org $30803D ; PC 0x18003D
PersistentFloodgate:
db #$00 ; #$00 = Off (default) - #$01 = On
;--------------------------------------------------------------------------------
org $30803E ; PC 0x18003E
InvincibleGanon:
db #$00
; #$00 = Off (default)
; #$01 = On
; #$02 = Require All Dungeons
; #$03 = Require Crystals and Aga2
; #$04 = Require Crystals
; #$05 = Require 100 Goal Items
;--------------------------------------------------------------------------------
org $30803F ; PC 0x18003F
HammerableGanon:
db #$00 ; #$00 = Off (default) - #$01 = On
;--------------------------------------------------------------------------------
org $308040 ; PC 0x180040
PreopenCurtains:
db #$00 ; #$00 = Off (default) - #$01 = On
;--------------------------------------------------------------------------------
org $308041 ; PC 0x180041
AllowSwordlessMedallionUse:
db #$00 ; #$00 = Off (default) - #$01 = Medallion Pads - #$02 = Always (Not Implemented)
;--------------------------------------------------------------------------------
org $308042 ; PC 0x180042
PermitSQFromBosses:
db #$00 ; #$00 = Off (default) - #$01 = On
;--------------------------------------------------------------------------------
org $308043 ; PC 0x180043
StartingSword:
db #$00 ; #$00 = No Sword (default) - #$FF = Non-Sword
;--------------------------------------------------------------------------------
org $308044 ; PC 0x180044
AllowHammerTablets:
db #$00 ; #$00 = Off (default) - #$01 = On
;--------------------------------------------------------------------------------
org $308045 ; PC 0x180045
HUDDungeonItems:
db #$00 ; display ----dcba a: Small Keys, b: Big Key, c: Map, d: Compass
;--------------------------------------------------------------------------------
org $308046 ; PC 0x180046 Link's starting equipment
LinkStartingRupees:
dw #$0000
;--------------------------------------------------------------------------------
org $308048 ; PC 0x180048
MenuSpeed:
db #$08 ; #$08 (default) - higher is faster - #$E8 = instant open
org $0DDD9A ; PC 0x6DD9A (equipment.asm:95) ; Menu Down Chime
db #$11 ; #$11 = Vwoop Down (Default) - #$20 = Menu Chime
org $0DDF2A ; PC 0x6DF2A (equipment.asm:466) ; Menu Up Chime
db #$12 ; #$12 = Vwoop Up (Default) - #$20 = Menu Chime
org $0DE0E9 ; PC 0x6E0E9 (equipment.asm:780) ; Menu Up Chime
db #$12 ; #$12 = Vwoop Up (Default) - #$20 = Menu Chime
;--------------------------------------------------------------------------------
org $308049 ; PC 0x180049
MenuCollapse:
db #$00 ; #$00 = Press Start (default) - #$10 = Release Start
;--------------------------------------------------------------------------------
org $308080 ; PC 0x180080
Upgrade5BombsRefill:
db #$00
Upgrade10BombsRefill:
db #$00
Upgrade5ArrowsRefill:
db #$00
Upgrade10ArrowsRefill:
db #$00
;--------------------------------------------------------------------------------
org $308084 ; PC 0x180084
PotionHealthRefill:
db #$A0 ; #$A0 - Full Refill (Default)
PotionMagicRefill:
db #$80 ; #$80 - Full Refill (Default)
;--------------------------------------------------------------------------------
org $308086 ; PC 0x180086
GanonAgahRNG:
db #$00 ; $00 = static rng, $01 = no extra blue balls/warps
;--------------------------------------------------------------------------------
org $308090 ; PC 0x180090
ProgressiveSwordLimit:
db #$04 ; #$04 - 4 Swords (default)
ProgressiveSwordReplacement:
db #$47 ; #$47 - 20 Rupees (default)
ProgressiveShieldLimit:
db #$03 ; #$03 - 3 Shields (default)
ProgressiveShieldReplacement:
db #$47 ; #$47 - 20 Rupees (default)
ProgressiveArmorLimit:
db #$02 ; #$02 - 2 Armors (default)
ProgressiveArmorReplacement:
db #$47 ; #$47 - 20 Rupees (default)
BottleLimit:
db #$04 ; #$04 - 4 Bottles (default)
BottleLimitReplacement:
db #$47 ; #$47 - 20 Rupees (default)
;--------------------------------------------------------------------------------
org $308100 ; PC 0x180100 (0x40 bytes)
ShovelSpawnTable:
	db $B2 ; Gold Bee
	db $D8, $D8, $D8 ; Single Heart
	db $D8, $D8, $D8, $D8, $D8 ; Single Heart
	db $D9, $D9, $D9, $D9, $D9 ; Green Rupee
	db $DA, $DA, $DA, $DA, $DA ; Blue Rupee
	db $DB, $DB, $DB, $DB, $DB ; Red Rupee
	db $DC, $DC, $DC, $DC, $DC ; 1 Bomb
	db $DD, $DD, $DD, $DD, $DD ; 4 Bombs
	db $DE, $DE, $DE, $DE, $DE ; 8 Bombs
	db $DF, $DF, $DF, $DF, $DF ; Small Magic
	db $E0, $E0, $E0, $E0, $E0 ; Large Magic
	db $E1, $E1, $E1, $E1, $E1 ; 5 Arrows
	db $E2, $E2, $E2, $E2, $E2 ; 10 Arrows
	db $E3, $E3, $E3, $E3, $E3 ; Fairy
;--------------------------------------------------------------------------------
org $098B7C ; PC 0x48B7C
EtherTablet:
	db #$10 ; #$10 = Ether
org $08CAA9 ; PC 0x44AA9
	db #$10 ; #$10 = Ether

org $098B81 ; PC 0x48B81
BombosTablet:
	db #$0F ; #$0F = Bombos
org $08CAAE ; PC 0x44AAE
	db #$0F ; #$0F = Bombos
;--------------------------------------------------------------------------------
org $05FBD2 ; PC 0x2FBD2 - sprite_mad_batter.asm:209 - (#$01)
HalfMagic:
db $01 ; #$01 = 1/2 Magic (default) - #$02 = 1/4 Magic
;--------------------------------------------------------------------------------
org $07ADA7 ; PC 0x3ADA7 - Bank07.asm:7216 - (db 4, 8, 8)
CapeMagicUse:
db $04, $08, $10 ; change to db $04, $08, $08 for original cape behavior
org $08DC42 ; PC 0x45C42 - ancilla_cane_spark.asm:200 - (db 4, 2, 1)
ByrnaMagicUsage:
db #$04, #$02, #$01 ; normal, 1/2, 1/4 magic
;--------------------------------------------------------------------------------
;Dungeon Music
;org $02D592 ; PC 0x15592
;11 - Pendant Dungeon
;16 - Crystal Dungeon

org $02D592+$08
Music_Eastern:
db $11

org $02D592+$09
Music_Desert:
db $11, $11, $11, $11

org $02D592+$33
Music_Hera:
db $11
org $02907A ; 0x1107A - Bank02.asm:3089 (#$11)
Music_Hera2:
db $11
org $028B8C ; 0x10B8C - Bank02.asm:2231 (#$11)
Music_Hera3:
db $11

org $02D592+$26
Music_Darkness:
db $16

org $02D592+$25
Music_Swamp:
db $16

org $02D592+$28
Music_Skull:
db $16, $16, $16, $16

org $02D592+$76
Music_Skul_Drop:
db $16, $16, $16, $16

org $02D592+$34
Music_Thieves:
db $16

org $02D592+$2D
Music_Ice:
db $16

org $02D592+$27
Music_Mire:
db $16

org $02D592+$35
Music_TRock:
db $16
org $02D592+$15
Music_TRock2:
db $16
org $02D592+$18
Music_TRock3:
db $16, $16

org $02D592+$37
Music_GTower:
db $16
;--------------------------------------------------------------------------------
; THIS ENTIRE TABLE IS DEPRECATED
;Map Crystal Locations
;org $0AC5B8 ; PC 0x545B8
;PendantLoc_Eastern: ; Green/Courage/Eastern Palace
;db $04 ; 04
;PendantLoc_Hera: ; Red/Wisdom/Hera
;db $01 ; 01
;PendantLoc_Desert: ; Blue/Power/Desert
;db $02 ; 02
;
;org $0AC5D1 ; PC 0x545D1
;CrystalLoc_Darkness:
;db $02
;CrystalLoc_Skull:
;db $40 ; 40
;CrystalLoc_TRock:
;db $08 ; 08
;CrystalLoc_Thieves:
;db $20
;CrystalLoc_Mire:
;db $01
;CrystalLoc_Ice:
;db $04
;CrystalLoc_Swamp:
;db $10
;
;Pendant 1: $04
;Pendant 2: $02
;Pendant 3: $01
;Crystal 1: $02
;Crystal 2: $10
;Crystal 3: $40
;Crystal 4: $20
;Crystal 5: $04
;Crystal 6: $01
;Crystal 7: $08
;--------------------------------------------------------------------------------
;Map Pendant / Crystal Indicators

org $0ABF2E ; PC 0x53F02
dw $0100 ; #$6234 - Master Sword

org $0ABEF8 ; PC 0x53EF8
MapObject_Eastern:
dw $6038 ; #$6038 - Green Pendant / Courage

org $0ABF1C ; PC 0x53F1C
MapObject_Desert:
dw $6034 ; #$6034 - Blue Pendant / Power

org $0ABF0A ; PC 0x53F0A
MapObject_Hera:
dw $6032 ; #$6032 - Red Pendant / Wisdom

org $0ABF00 ; PC 0x53F00
MapObject_Darkness:
dw $6434 ; #6434 - Crystal

org $0ABF6C ; PC 0x53F6C
MapObject_Swamp:
dw $6434 ; #6434 - Crystal

org $0ABF12 ; PC 0x53F12
MapObject_Skull:
dw $6434 ; #6434 - Crystal

org $0ABF36 ; PC 0x53F36
MapObject_Thieves:
dw $6434 ; #6434 - Crystal

org $0ABF5A ; PC 0x53F5A
MapObject_Ice:
dw $6432 ; #6434 - Crystal 5/6

org $0ABF48 ; PC 0x53F48
MapObject_Mire:
dw $6432 ; #6434 - Crystal 5/6

org $0ABF24 ; PC 0x53F24
MapObject_TRock:
dw $6434 ; #6434 - Crystal

;--------------------------------------------------------------------------------
org $308070 ; PC 0x180070
CrystalNumberTable:
db $00 ;
db $79 ; Swamp
db $00 ;
db $6E ; Ice
db $00 ;
db $6F ; Mire
db $00 ;
db $6D ; Thieves
db $69 ; Desert
db $7C ; TRock
db $69 ; Hera
db $6C ; Skull
db $69 ; Eastern
db $7F ; Darkness
db $00 ;
db $00 ;

;1 Indicator : 7F
;2 Indicator : 79
;3 Indicator : 6C
;4 Indicator : 6D
;5 Indicator : 6E
;6 Indicator : 6F
;7 Indicator : 7C
;8 Indicator : 7D
;9 Indicator : 7E

;Dark Red X  : 69
;Light Red X : 78
;White X     : 68

;Pendant UL  : 60
;Pendant UR  : 61
;Pendant BL  : 70
;Pendant BR  : 71

;Sword UL    : 62
;Sword UR    : 63
;Sword BL    : 72
;Sword BR    : 73

;Crystal UL  : 64
;Crystal UR  : 65
;Crystal BL  : 74
;Crystal BR  : 75

;Skull UL    : 66
;Skull UR    : 67
;Skull BL    : 76
;Skull BR    : 77

;Warp UL     : 6A
;Warp UR     : 6B
;Warp BL     : 7A
;Warp BR     : 7B
;--------------------------------------------------------------------------------
org $02A09B ; PC 0x1209B - Bank02.asm:5802 - (pool MilestoneItem_Flags:)
CrystalPendantFlags:
    db $00 ; Sewers
	db $00 ; Hyrule Castle
	db $04 ; Eastern Palace
	db $02 ; Desert Palace
	db $00 ; Agahnim's Tower
	db $10 ; Swamp Palace
	db $02 ; Palace of Darkness
	db $01 ; Misery Mire
    db $40 ; Skull Woods
	db $04 ; Ice Palace
.hera
	db $01 ; Tower of Hera
	db $20 ; Thieves' Town
	db $08 ; Turtle Rock
;Pendant 1: $04
;Pendant 2: $02
;Pendant 3: $01
;Crystal 1: $02
;Crystal 2: $10
;Crystal 3: $40
;Crystal 4: $20
;Crystal 5: $04
;Crystal 6: $01
;Crystal 7: $08
;--------------------------------------------------------------------------------
org $308050 ; PC 0x180050
CrystalPendantFlags_2:
    db $00 ; Sewers
	db $00 ; Hyrule Castle
	db $00 ; Eastern Palace
	db $00 ; Desert Palace
	db $00 ; Agahnim's Tower
	db $40 ; Swamp Palace
	db $40 ; Palace of Darkness
	db $40 ; Misery Mire
    db $40 ; Skull Woods
	db $40 ; Ice Palace
.hera
	db $00 ; Tower of Hera
	db $40 ; Thieves' Town
	db $40 ; Turtle Rock
;Pendant: $00
;Crystal: $40
;Dungeons with no drops should match their respective world's normal vanilla prize ;xxx
;--------------------------------------------------------------------------------
org $01C6FC ; PC 0xC6FC - Bank01.asm:10344 - (db $00, $00, $01, $02, $00, $06, $06, $06, $06, $06, $03, $06, $06)
	db $00 ; Sewers
	db $00 ; Hyrule Castle
	db $01 ; Eastern Palace
	db $02 ; Desert Palace
	db $00 ; Agahnim's Tower
	db $06 ; Swamp Palace
	db $06 ; Palace of Darkness
	db $06 ; Misery Mire
	db $06 ; Skull Woods
	db $06 ; Ice Palace
	db $03 ; Tower of Hera
	db $06 ; Thieves' Town
	db $06 ; Turtle Rock
;Ether/Nothing: $00
;Green Pendant: $01
;Blue Pendant: $02
;Red Pendant: $03
;Heart Container: $04
;Bombos: $05
;Crystal: $06
;--------------------------------------------------------------------------------
org $02885E ; PC 0x1085E - Bank02.asm:1606 - (dw $0006, $005A, $0029, $0090, $00DE, $00A4, $00AC, $000D) ; DEPRECATED - DISCONTINUE USE
dw $0006 ; Crystal 2 Location
dw $005A ; Crystal 1 Location
dw $0029 ; Crystal 3 Location
dw $0090 ; Crystal 6 Location
dw $00DE ; Crystal 5 Location
dw $00A4 ; Crystal 7 Location
dw $00AC ; Crystal 4 Location ; AC
dw $000D ; Agahnim II Location ; 0D

;C8 = Armos Room
;33 = Lanmolas Room
;07 = Moldorm Room

;06 = Arrghus Room
;5A = Helmasaur Room
;29 = Mothula Room
;90 = Viterous Room
;DE = Kholdstare Room
;A4 = Trinexx Room
;AC = Blind Room
;0D = Agahnim 2 Room
;--------------------------------------------------------------------------------
;org $098B7D ; PC 0x48B7D - ancilla_init.asm:1630 - (db $37, $39, $38) ; DEPRECATED - DISCONTINUE USE
;PendantEastern:
;db #$37
;PendantDesert:
;db #$39
;PendantHera:
;db #$38

;37:Pendant 1 Green / Courage
;38:Pendant 3 Red / Wisdom
;39:Pendant 2 Blue / Power
;--------------------------------------------------------------------------------
org $07B51D ; PC 0x3B51D
BlueBoomerangSubstitution:
db #$FF ; no substitution
org $07B53B ; PC 0x3B53B
RedBoomerangSubstitution:
db #$FF ; no substitution
;--------------------------------------------------------------------------------
org $308060 ; PC 0x180060
ProgrammableItemLogicJump_1:
JSL.l $000000 : RTL
ProgrammableItemLogicJump_2:
JSL.l $000000 : RTL
ProgrammableItemLogicJump_3:
JSL.l $000000 : RTL
;--------------------------------------------------------------------------------
org $308061 ; PC 0x180061
ProgrammableItemLogicPointer_1:
dl #$000000
org $308066 ; PC 0x180066
ProgrammableItemLogicPointer_2:
dl #$000000
org $30806B ; PC 0x18006B
ProgrammableItemLogicPointer_3:
dl #$000000
;--------------------------------------------------------------------------------
org $3080A0 ; PC 0x1800A0
Bugfix_MirrorlessSQToLW:
db #$01 ; #$00 = Original Behavior - #$01 = Randomizer Behavior (Default)
Bugfix_SwampWaterLevel:
db #$01 ; #$00 = Original Behavior - #$01 = Randomizer Behavior (Default)
Bugfix_PreAgaDWDungeonDeathToFakeDW:
db #$01 ; #$00 = Original Behavior - #$01 = Randomizer Behavior (Default)
Bugfix_SetWorldOnAgahnimDeath:
db #$01 ; #$00 = Original Behavior - #$01 = Randomizer Behavior (Default)
;--------------------------------------------------------------------------------
;org $08D01A ; PC 0x4501A - ancilla_flute.asm - 42
;OldHauntedGroveItem:
;	db #$14 ; #$14 = Flute
;--------------------------------------------------------------------------------
;2B:Bottle Already Filled w/ Red Potion
;2C:Bottle Already Filled w/ Green Potion
;2D:Bottle Already Filled w/ Blue Potion
;3C:Bottle Already Filled w/ Bee
;3D:Bottle Already Filled w/ Fairy
;48:Bottle Already Filled w/ Gold Bee
org $06C8FF ; PC 0x348FF
WaterfallPotion: ; <-------------------------- FAIRY POTION STUFF HERE
	db #$2C ; #$2C = Green Potion
org $06C93B ; PC 0x3493B
PyramidPotion:
	db #$2C ; #$2C = Green Potion
;--------------------------------------------------------------------------------
org $308140 ; PC 0x180140
HeartPieceOutdoorValues:
HeartPiece_Spectacle:
	db #$17
HeartPiece_Mountain_Warp:
	db #$17
HeartPiece_Maze:
	db #$17
HeartPiece_Desert:
	db #$17
HeartPiece_Lake:
	db #$17
HeartPiece_Swamp:
	db #$17
HeartPiece_Cliffside:
	db #$17
HeartPiece_Pyramid:
	db #$17
HeartPiece_Digging:
	db #$17
HeartPiece_Zora:
	db #$17
HauntedGroveItem:
	db #$14 ; #$14 = Flute
;================================================================================
org $308150 ; PC 0x180150
HeartContainerBossValues:
HeartContainer_ArmosKnights:
	db #$3E ; #$3E = Boss Heart (putting pendants here causes main pendants to not drop for obvious (in retrospect) reasons)
HeartContainer_Lanmolas:
	db #$3E
HeartContainer_Moldorm:
	db #$3E
HeartContainer_HelmasaurKing:
	db #$3E
HeartContainer_Arrghus:
	db #$3E
HeartContainer_Mothula:
	db #$3E
HeartContainer_Blind:
	db #$3E
HeartContainer_Kholdstare:
	db #$3E
HeartContainer_Vitreous:
	db #$3E
HeartContainer_Trinexx:
	db #$3E
;================================================================================
org $308160 ; PC 0x180160
BonkKey_Desert:
	db #$24 ; #$24 = Small Key (default)
BonkKey_GTower:
	db #$24 ; #$24 = Small Key (default)
StandingKey_Hera:
	db #$24 ; #$24 = Small Key (default)
;================================================================================
org $308165 ; PC 0x180165
GoalItemIcon:
dw #$280E ; #$280D = Star - #$280E = Triforce Piece (default)
;================================================================================
org $308167 ; PC 0x180167
GoalItemRequirement:
db #$00 ; #$00 = Off (default) - #$XX = Require $XX Goal Items - #$FF = Counter-Only
;================================================================================
org $308168 ; PC 0x180168
ByrnaCaveSpikeDamage:
db #$08 ; #$08 = 1 Heart (default) - #$02 = 1/4 Heart
;================================================================================
org $308169 ; PC 0x180169
AgahnimDoorStyle:
db #$00 ; #00 = Never Locked - #$01 = Locked During Escape (default)
;================================================================================
org $30816A ; PC 0x18016A
FreeItemText:
db #$00 ; #00 = Off (default) - #$01 = On
;================================================================================
org $30816B ; PC 0x18016B
HardModeExclusionCaneOfByrnaUsage:
db #$04, #$02, #$01 ; normal, 1/2, 1/4 magic
org $30816E ; PC 0x18016E
HardModeExclusionCapeUsage:
db #$04, #$08, #$10 ; normal, 1/2, 1/4 magic
;================================================================================
org $308171 ; PC 0x180171
GanonPyramidRespawn:
db #$01 ; #00 = Do not respawn on Pyramid after Death - #$01 = Respawn on Pyramid after Death (default)
;================================================================================
org $308172 ; PC 0x180172
GenericKeys:
db #$00 ; #00 = Dungeon-Specific Keys (Default) - #$01 = Generic Keys
;================================================================================
org $308173 ; PC 0x180173
Bob:
db #$01 ; #00 = Off - #$01 = On (Default)
;================================================================================
org $308174 ; PC 0x180174
; Flag to fix Fake Light World/Fake Dark World as caused by leaving the underworld
; to the other world (As can be caused by EG, Certain underworld clips, or Entance Randomizer).
; Currently, Fake Worlds triggered by other causes like YBA's Fake Flute, are not affected.
FixFakeWorld:
db #$00 ; #00 = Fix Off (Default) - #$01 = Fix On
;================================================================================
org $308190 ; PC 0x180190
TimerStyle:
db #$00 ; #$00 = Off (Default) - #$01 Countdown - #$02 = Stopwatch
TimeoutBehavior:
db #$00 ; #$00 = DNF (Default) - #$01 = Sign Change (Requires TimerRestart == 1) - #$02 = OHKO
TimerRestart:
db #$00 ; #$00 = Locked (Default) - #$01 = Restart
;================================================================================
org $308200 ; PC 0x180200
RedClockAmount:
dw #$4650, #$0000 ; $00004650 = +5 minutes
BlueClockAmount:
dw #$B9B0, #$FFFF ; $FFFFB9B0 = -5 minutes
GreenClockAmount:
dw #$0000, #$0000
StartingTime:
dw #$0000, #$0000 ; #$A5E0, #$0001 = 30 minutes
;================================================================================
org $09E3BB ; PC 0x4E3BB
db $E4 ; Hera Basement Key (Set to programmable HP $EB) (set to $E4 for original hookable/boomable key behavior)
;================================================================================
org $308210 ; PC 0x180210
RandomizerSeedType:
db #$00 ; #$00 = Casual (default) - #$01 = Glitched - #$02 = Speedrunner - #$FF = Not Randomizer
;--------------------------------------------------------------------------------
org $308211 ; PC 0x180211
GameType:
db #$00 ; #$00 = Randomizer (default) - #$01 = Plandomizer - #$FF = Other Editors
;--------------------------------------------------------------------------------
;dgGe mutT
;d - Nonstandard Dungeon Configuration (Not Map/Compass/BigKey/SmallKeys in same quantity as vanilla)
;g - Requires Minor Glitches (Fake flippers, bomb jumps, etc)
;G - Requires Major Glitches (OW YBA/Clips, etc)
;e - Requires EG
;
;m - Contains Multiples of Major Items
;u - Contains Unreachable Items
;t - Minor Trolling (Swapped around levers, etc)
;T - Major Trolling (Forced-guess softlocks, impossible seed, etc)
org $308212 ; PC 0x180212
WarningFlags:
db #$00
;--------------------------------------------------------------------------------
org $308213 ; PC 0x180213
TournamentSeed:
db #$00 ; #$00 = Off (default) - #$01 = On
TournamentSeedInverse:
db #$01 ; #$00 = On - #$01 = Off (Default)
;================================================================================
; $308220 (0x180220) - $30823F (0x18023F)
; Plandomizer Author Name (ASCII) - Leave unused chars as 0
org $308220 ; PC 0x180220
;================================================================================
; $308300 (0x180300) - $3083FF (0x1803FF)
; MS Pedestal Text (ALTTP JP Text Format)
org $308300 ; PC 0x180300
MSPedestalText:
db $00, $c0, $00, $ae, $00, $d8, $00, $bb, $00, $ae, $00, $ff, $00, $b8, $00, $be, $00, $bd, $00, $ff, $00, $b8, $00, $af
db $75, $00, $c0, $00, $ae, $00, $ae, $00, $bd, $00, $aa, $00, $ab, $00, $b2, $00, $c1, $00, $cD, $00, $ff, $00, $bd, $00, $b8
db $76, $00, $bd, $00, $b1, $00, $ae, $00, $ff, $00, $bc, $00, $bd, $00, $b8, $00, $bb, $00, $ae, $00, $c7
db $7f, $7f
;--------------------------------------------------------------------------------
; $308400 (0x180400) - $3084FF (0x1804FF)
; Triforce Text (ALTTP JP Text Format)
org $308400 ; PC 0x180400
TriforceText:
db $74, $75, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $B0, $00, $FF, $00, $B0, $7F
;--------------------------------------------------------------------------------
; $308500 (0x180500) - $3085FF (0x1805FF)
; Uncle Text (ALTTP JP Text Format)
org $308500 ; PC 0x180500
UncleText:
db $00, $c0, $00, $ae, $00, $d8, $00, $bb, $00, $ae, $00, $ff, $00, $b8, $00, $be, $00, $bd, $00, $ff, $00, $b8, $00, $af
db $75, $00, $c0, $00, $ae, $00, $ae, $00, $bd, $00, $aa, $00, $ab, $00, $b2, $00, $c1, $00, $cD, $00, $ff, $00, $bd, $00, $b8
db $76, $00, $bd, $00, $b1, $00, $ae, $00, $ff, $00, $bc, $00, $bd, $00, $b8, $00, $bb, $00, $ae, $00, $c7
db $7f, $7f
;--------------------------------------------------------------------------------
; $308600 (0x180600) - $3086FF (0x1806FF)
; Ganon Text 1 (ALTTP JP Text Format)
org $308600 ; PC 0x180600
GanonText1:
db $00, $c0, $00, $ae, $00, $d8, $00, $bb, $00, $ae, $00, $ff, $00, $b8, $00, $be, $00, $bd, $00, $ff, $00, $b8, $00, $af
db $75, $00, $c0, $00, $ae, $00, $ae, $00, $bd, $00, $aa, $00, $ab, $00, $b2, $00, $c1, $00, $cD, $00, $ff, $00, $bd, $00, $b8
db $76, $00, $bd, $00, $b1, $00, $ae, $00, $ff, $00, $bc, $00, $bd, $00, $b8, $00, $bb, $00, $ae, $00, $c7
db $7f, $7f
;--------------------------------------------------------------------------------
; $308700 (0x180700) - $3087FF (0x1807FF)
; Ganon Text 2 (ALTTP JP Text Format)
org $308700 ; PC 0x180700
GanonText2:
db $00, $c2, $00, $b8, $00, $be, $00, $d8, $00, $bb, $00, $ae, $00, $ff, $00, $b0, $00, $b8, $00, $b2, $00, $b7, $00, $b0
db $75, $00, $bd, $00, $b8, $00, $ff, $00, $b1, $00, $aa, $00, $bf, $00, $ae, $00, $ff, $00, $aa, $00, $ff, $00, $bf, $00, $ae, $00, $bb, $00, $c2
db $76, $00, $ab, $00, $aa, $00, $ad, $00, $ff, $00, $bd, $00, $b2, $00, $b6, $00, $ae, $00, $cD
db $7f, $7f
;--------------------------------------------------------------------------------
; $308800 (0x180800) - $3088FF (0x1808FF)
; Blind Text
org $308800 ; PC 0x180800
BlindText:
db $75, $00, $cE, $00, $a6, $00, $a9, $00, $ff, $00, $ab, $00, $b5, $00, $aa, $00, $c3, $00, $ae, $00, $ff, $00, $b2, $00, $bd, $00, $c7, $00, $cE
db $7f, $7f
;--------------------------------------------------------------------------------
; $308900 (0x180900) - $3089FF (0x1809FF)
; Fat Fairy Text
org $308900 ; PC 0x180900
FatFairyText:
db $00, $b1, $00, $ae, $00, $c2, $00, $c7
db $76, $00, $b5, $00, $b2, $00, $bc, $00, $bd, $00, $ae, $00, $b7, $00, $c7
db $7f, $7f
;--------------------------------------------------------------------------------
; $308A00 (0x180A00) - $308AFF (0x180AFF)
; SahasrahlaNoPendantText
org $308A00 ; PC 0x180A00
SahasrahlaNoPendantText:
; Want something|for free? Tell|you what|bring me the|green pendant.
db $74, $00, $C0, $00, $AA, $00, $B7, $00, $BD, $00, $FF, $00, $BC, $00, $B8, $00, $B6, $00, $AE, $00, $BD, $00, $B1, $00, $B2, $00, $B7, $00, $B0, $75, $00, $AF, $00, $B8, $00, $BB, $00, $FF, $00, $AF, $00, $BB, $00, $AE, $00, $AE, $00, $C6, $00, $FF, $00, $BD, $00, $AE, $00, $B5, $00, $B5, $76, $00, $C2, $00, $B8, $00, $BE, $00, $FF, $00, $C0, $00, $B1, $00, $AA, $00, $BD, $00, $CC, $7E, $73, $76, $00, $AB, $00, $BB, $00, $B2, $00, $B7, $00, $B0, $00, $FF, $00, $B6, $00, $AE, $00, $FF, $00, $BD, $00, $B1, $00, $AE, $73, $76, $00, $B0, $00, $BB, $00, $AE, $00, $AE, $00, $B7, $00, $FF, $00, $B9, $00, $AE, $00, $B7, $00, $AD, $00, $AA, $00, $B7, $00, $BD, $00, $CD
db $7f, $7f
;--------------------------------------------------------------------------------
; $308B00 (0x180B00) - $308BFF (0x180BFF)
; SahasrahlaAfterItemText
org $308B00 ; PC 0x180B00
SahasrahlaAfterItemText:
; I already gave|you all I have|Why don't you|go bother|someone else?
db $74, $00, $B2, $00, $FF, $00, $AA, $00, $B5, $00, $BB, $00, $AE, $00, $AA, $00, $AD, $00, $C2, $00, $FF, $00, $B0, $00, $AA, $00, $BF, $00, $AE, $75, $00, $C2, $00, $B8, $00, $BE, $00, $FF, $00, $AA, $00, $B5, $00, $B5, $00, $FF, $00, $B2, $00, $FF, $00, $B1, $00, $AA, $00, $BF, $00, $AE, $76, $00, $C0, $00, $B1, $00, $C2, $00, $FF, $00, $AD, $00, $B8, $00, $B7, $00, $D8, $00, $BD, $00, $FF, $00, $C2, $00, $B8, $00, $BE, $7E, $73, $76, $00, $B0, $00, $B8, $00, $FF, $00, $AB, $00, $B8, $00, $BD, $00, $B1, $00, $AE, $00, $BB, $73, $76, $00, $BC, $00, $B8, $00, $B6, $00, $AE, $00, $B8, $00, $B7, $00, $AE, $00, $FF, $00, $AE, $00, $B5, $00, $BC, $00, $AE, $00, $C6
db $7f, $7f
;--------------------------------------------------------------------------------
; $308C00 (0x180C00) - $308CFF (0x180CFF)
; AlcoholicText
org $308C00 ; PC 0x180C00
AlcoholicText:
; If you haven't|found Quake|yet|it's not your|fault.
db $74, $00, $B2, $00, $AF, $00, $FF, $00, $C2, $00, $B8, $00, $BE, $00, $FF, $00, $B1, $00, $AA, $00, $BF, $00, $AE, $00, $B7, $00, $D8, $00, $BD, $75, $00, $AF, $00, $B8, $00, $BE, $00, $B7, $00, $AD, $00, $FF, $00, $BA, $00, $BE, $00, $AA, $00, $B4, $00, $AE, $76, $00, $C2, $00, $AE, $00, $BD, $00, $CC, $7E, $73, $76, $00, $B2, $00, $BD, $00, $D8, $00, $BC, $00, $FF, $00, $B7, $00, $B8, $00, $BD, $00, $FF, $00, $C2, $00, $B8, $00, $BE, $00, $BB, $73, $76, $00, $AF, $00, $AA, $00, $BE, $00, $B5, $00, $BD, $00, $CD
db $7f, $7f
;--------------------------------------------------------------------------------
; $308D00 (0x180D00) - $308DFF (0x180DFF)
; BombShopGuyText
org $308D00 ; PC 0x180D00
BombShopGuyText:
; please deliver|this big bomb|to my fairy|friend in the|pyramid?
db $74, $00, $B9, $00, $B5, $00, $AE, $00, $AA, $00, $BC, $00, $AE, $00, $FF, $00, $AD, $00, $AE, $00, $B5, $00, $B2, $00, $BF, $00, $AE, $00, $BB, $75, $00, $BD, $00, $B1, $00, $B2, $00, $BC, $00, $FF, $00, $AB, $00, $B2, $00, $B0, $00, $FF, $00, $AB, $00, $B8, $00, $B6, $00, $AB, $76, $00, $BD, $00, $B8, $00, $FF, $00, $B6, $00, $C2, $00, $FF, $00, $AF, $00, $AA, $00, $B2, $00, $BB, $00, $C2, $7E, $73, $76, $00, $AF, $00, $BB, $00, $B2, $00, $AE, $00, $B7, $00, $AD, $00, $FF, $00, $B2, $00, $B7, $00, $FF, $00, $BD, $00, $B1, $00, $AE, $73, $76, $00, $B9, $00, $C2, $00, $BB, $00, $AA, $00, $B6, $00, $B2, $00, $AD, $00, $C6
db $7f, $7f
;--------------------------------------------------------------------------------
; $308E00 (0x180E00) - $308EFF (0x180EFF)
; BombShopGuyNoCrystalsText
org $308E00 ; PC 0x180E00
BombShopGuyNoCrystalsText:
; bring me the|5th and 6th|crystals so I|can make a big|bomb!
db $74, $00, $AB, $00, $BB, $00, $B2, $00, $B7, $00, $B0, $00, $FF, $00, $B6, $00, $AE, $00, $FF, $00, $BD, $00, $B1, $00, $AE, $75, $00, $A5, $00, $BD, $00, $B1, $00, $FF, $00, $AA, $00, $B7, $00, $AD, $00, $FF, $00, $A6, $00, $BD, $00, $B1, $76, $00, $AC, $00, $BB, $00, $C2, $00, $BC, $00, $BD, $00, $AA, $00, $B5, $00, $BC, $00, $FF, $00, $BC, $00, $B8, $00, $FF, $00, $B2, $7E, $73, $76, $00, $AC, $00, $AA, $00, $B7, $00, $FF, $00, $B6, $00, $AA, $00, $B4, $00, $AE, $00, $FF, $00, $AA, $00, $FF, $00, $AB, $00, $B2, $00, $B0, $73, $76, $00, $AB, $00, $B8, $00, $B6, $00, $AB, $00, $C7
db $7f, $7f
;--------------------------------------------------------------------------------
; $308F00 (0x180F00) - $308FFF (0x180FFF)
; EtherTabletText
org $308F00 ; PC 0x180F00
EtherTabletText:
; bring me the|5th and 6th|crystals so I|can make a big|bomb!
db $74, $00, $AB, $00, $BB, $00, $B2, $00, $B7, $00, $B0, $00, $FF, $00, $B6, $00, $AE, $00, $FF, $00, $BD, $00, $B1, $00, $AE, $75, $00, $A5, $00, $BD, $00, $B1, $00, $FF, $00, $AA, $00, $B7, $00, $AD, $00, $FF, $00, $A6, $00, $BD, $00, $B1, $76, $00, $AC, $00, $BB, $00, $C2, $00, $BC, $00, $BD, $00, $AA, $00, $B5, $00, $BC, $00, $FF, $00, $BC, $00, $B8, $00, $FF, $00, $B2, $7E, $73, $76, $00, $AC, $00, $AA, $00, $B7, $00, $FF, $00, $B6, $00, $AA, $00, $B4, $00, $AE, $00, $FF, $00, $AA, $00, $FF, $00, $AB, $00, $B2, $00, $B0, $73, $76, $00, $AB, $00, $B8, $00, $B6, $00, $AB, $00, $C7
db $7f, $7f
;--------------------------------------------------------------------------------
; $309000 (0x181000) - $3090FF (0x1810FF)
; BombosTabletText
org $309000 ; PC 0x181000
BombosTabletText:
; please deliver|this big bomb|to my fairy|friend in the|pyramid?
db $74, $00, $B9, $00, $B5, $00, $AE, $00, $AA, $00, $BC, $00, $AE, $00, $FF, $00, $AD, $00, $AE, $00, $B5, $00, $B2, $00, $BF, $00, $AE, $00, $BB, $75, $00, $BD, $00, $B1, $00, $B2, $00, $BC, $00, $FF, $00, $AB, $00, $B2, $00, $B0, $00, $FF, $00, $AB, $00, $B8, $00, $B6, $00, $AB, $76, $00, $BD, $00, $B8, $00, $FF, $00, $B6, $00, $C2, $00, $FF, $00, $AF, $00, $AA, $00, $B2, $00, $BB, $00, $C2, $7E, $73, $76, $00, $AF, $00, $BB, $00, $B2, $00, $AE, $00, $B7, $00, $AD, $00, $FF, $00, $B2, $00, $B7, $00, $FF, $00, $BD, $00, $B1, $00, $AE, $73, $76, $00, $B9, $00, $C2, $00, $BB, $00, $AA, $00, $B6, $00, $B2, $00, $AD, $00, $C6
db $7f, $7f
;--------------------------------------------------------------------------------
; $309100 (0x181100) - $3091FF (0x1811FF)
; Ganon Text 1 - Invincible Alternate (ALTTP JP Text Format)
org $309100 ; PC 0x181100
GanonText1Alternate:
; bring me the|5th and 6th|crystals so I|can make a big|bomb!
db $74, $00, $AB, $00, $BB, $00, $B2, $00, $B7, $00, $B0, $00, $FF, $00, $B6, $00, $AE, $00, $FF, $00, $BD, $00, $B1, $00, $AE, $75, $00, $A5, $00, $BD, $00, $B1, $00, $FF, $00, $AA, $00, $B7, $00, $AD, $00, $FF, $00, $A6, $00, $BD, $00, $B1, $76, $00, $AC, $00, $BB, $00, $C2, $00, $BC, $00, $BD, $00, $AA, $00, $B5, $00, $BC, $00, $FF, $00, $BC, $00, $B8, $00, $FF, $00, $B2, $7E, $73, $76, $00, $AC, $00, $AA, $00, $B7, $00, $FF, $00, $B6, $00, $AA, $00, $B4, $00, $AE, $00, $FF, $00, $AA, $00, $FF, $00, $AB, $00, $B2, $00, $B0, $73, $76, $00, $AB, $00, $B8, $00, $B6, $00, $AB, $00, $C7
db $7f, $7f
;--------------------------------------------------------------------------------
; $309200 (0x181200) - $3092FF (0x1812FF)
; Ganon Text 2 - Invincible Alternate (ALTTP JP Text Format)
org $309200 ; PC 0x181200
GanonText2Alternate:
; please deliver|this big bomb|to my fairy|friend in the|pyramid?
db $74, $00, $B9, $00, $B5, $00, $AE, $00, $AA, $00, $BC, $00, $AE, $00, $FF, $00, $AD, $00, $AE, $00, $B5, $00, $B2, $00, $BF, $00, $AE, $00, $BB, $75, $00, $BD, $00, $B1, $00, $B2, $00, $BC, $00, $FF, $00, $AB, $00, $B2, $00, $B0, $00, $FF, $00, $AB, $00, $B8, $00, $B6, $00, $AB, $76, $00, $BD, $00, $B8, $00, $FF, $00, $B6, $00, $C2, $00, $FF, $00, $AF, $00, $AA, $00, $B2, $00, $BB, $00, $C2, $7E, $73, $76, $00, $AF, $00, $BB, $00, $B2, $00, $AE, $00, $B7, $00, $AD, $00, $FF, $00, $B2, $00, $B7, $00, $FF, $00, $BD, $00, $B1, $00, $AE, $73, $76, $00, $B9, $00, $C2, $00, $BB, $00, $AA, $00, $B6, $00, $B2, $00, $AD, $00, $C6
db $7f, $7f
;--------------------------------------------------------------------------------
; $309300 (0x181300) - $3094FF (0x1814FF)
; free space
;--------------------------------------------------------------------------------
; $309500 (0x181500) - $309FFF (0x181FFF) original 0x39C bytes
; Replacement Ending Sequence Text Data
; if you modify this table you will need to modify the pointers to it located at $0EECC0
org $309500 ; PC 0x181500
EndingSequenceText:
; the return of the king
db $62, $65, $00, $2B, $2D, $21, $1E, $9F, $2B, $1E, $2D, $2E, $2B, $27, $9F, $28, $1F, $9F, $2D, $21, $1E, $9F, $24, $22, $27, $20
db $62, $E9, $00, $19, $64, $75, $6E, $71, $68, $61, $9F, $5F, $5D, $6F, $70, $68, $61
db $63, $09, $00, $19, $8A, $9B, $94, $97, $8E, $87, $9F, $85, $83, $95, $96, $8E, $87
; the loyal priest
db $62, $68, $00, $1F, $2D, $21, $1E, $9F, $25, $28, $32, $1A, $25, $9F, $29, $2B, $22, $1E, $2C, $2D
db $62, $EB, $00, $11, $6F, $5D, $6A, $5F, $70, $71, $5D, $6E, $75
db $63, $0B, $00, $11, $95, $83, $90, $85, $96, $97, $83, $94, $9B
; sahasralah's homecoming
db $62, $4F, $00, $01, $34
db $62, $65, $00, $2D, $2C, $1A, $21, $1A, $2C, $2B, $1A, $25, $1A, $21, $35, $2C, $9F, $21, $28, $26, $1E, $1C, $28, $26, $22, $27, $20
db $62, $E9, $00, $19, $67, $5D, $67, $5D, $6E, $65, $67, $6B, $9F, $70, $6B, $73, $6A
db $63, $09, $00, $19, $8D, $83, $8D, $83, $94, $8B, $8D, $91, $9F, $96, $91, $99, $90
; vultures rule the desert
db $62, $64, $00, $2F, $2F, $2E, $25, $2D, $2E, $2B, $1E, $2C, $9F, $2B, $2E, $25, $1E, $9F, $2D, $21, $1E, $9F, $1D, $1E, $2C, $1E, $2B, $2D
db $62, $E9, $00, $19, $60, $61, $6F, $61, $6E, $70, $9F, $6C, $5D, $68, $5D, $5F, $61
db $63, $09, $00, $19, $86, $87, $95, $87, $94, $96, $9F, $92, $83, $8E, $83, $85, $87
; the bully makes a friend
db $62, $64, $00, $2F, $2D, $21, $1E, $9F, $1B, $2E, $25, $25, $32, $9F, $26, $1A, $24, $1E, $2C, $9F, $1A, $9F, $1F, $2B, $22, $1E, $27, $1D
db $62, $E9, $00, $1B, $69, $6B, $71, $6A, $70, $5D, $65, $6A, $9F, $70, $6B, $73, $61, $6E
db $63, $09, $00, $1B, $8F, $91, $97, $90, $96, $83, $8B, $90, $9F, $96, $91, $99, $87, $94
; your uncle recovers
db $62, $66, $00, $25, $32, $28, $2E, $2B, $9F, $2E, $27, $1C, $25, $1E, $9F, $2B, $1E, $1C, $28, $2F, $1E, $2B, $2C
db $62, $EB, $00, $13, $75, $6B, $71, $6E, $9F, $64, $6B, $71, $6F, $61
db $63, $0B, $00, $13, $9B, $91, $97, $94, $9F, $8A, $91, $97, $95, $87
; finger webs for sale
db $62, $66, $00, $27, $1F, $22, $27, $20, $1E, $2B, $9F, $30, $1E, $1B, $2C, $9F, $1F, $28, $2B, $9F, $2C, $1A, $25, $1E
db $62, $E8, $00, $1F, $76, $6B, $6E, $5D, $77, $6F, $9F, $73, $5D, $70, $61, $6E, $62, $5D, $68, $68
db $63, $08, $00, $1F, $9C, $91, $94, $83, $9D, $95, $9F, $99, $83, $96, $87, $94, $88, $83, $8E, $8E
; the witch and assistant
db $62, $64, $00, $2D, $2D, $21, $1E, $9F, $30, $22, $2D, $1C, $21, $9F, $1A, $27, $1D, $9F, $1A, $2C, $2C, $22, $2C, $2D, $1A, $27, $2D
db $62, $EB, $00, $13, $69, $5D, $63, $65, $5F, $9F, $6F, $64, $6B, $6C
db $63, $0B, $00, $13, $8F, $83, $89, $8B, $85, $9F, $95, $8A, $91, $92
; twin lumberjacks
db $62, $68, $00, $1F, $2D, $30, $22, $27, $9F, $25, $2E, $26, $1B, $1E, $2B, $23, $1A, $1C, $24, $2C
db $62, $E9, $00, $1B, $73, $6B, $6B, $60, $6F, $69, $61, $6A, $77, $6F, $9F, $64, $71, $70
db $63, $09, $00, $1B, $99, $91, $91, $86, $95, $8F, $87, $90, $9D, $95, $9F, $8A, $97, $96
; ocarina boy plays again
db $62, $64, $00, $2D, $28, $1C, $1A, $2B, $22, $27, $1A, $9F, $1B, $28, $32, $9F, $29, $25, $1A, $32, $2C, $9F, $1A, $20, $1A, $22, $27
db $62, $E9, $00, $19, $64, $5D, $71, $6A, $70, $61, $60, $9F, $63, $6E, $6B, $72, $61
db $63, $09, $00, $19, $8A, $83, $97, $90, $96, $87, $86, $9F, $89, $94, $91, $98, $87
; venus. queen of faeries
db $62, $64, $00, $2D, $2F, $1E, $27, $2E, $2C, $37, $9F, $2A, $2E, $1E, $1E, $27, $9F, $28, $1F, $9F, $1F, $1A, $1E, $2B, $22, $1E, $2C
db $62, $EA, $00, $17, $73, $65, $6F, $64, $65, $6A, $63, $9F, $73, $61, $68, $68
db $63, $0A, $00, $17, $99, $8B, $95, $8A, $8B, $90, $89, $9F, $99, $87, $8E, $8E
; the dwarven swordsmiths
db $62, $64, $00, $2D, $2D, $21, $1E, $9F, $1D, $30, $1A, $2B, $2F, $1E, $27, $9F, $2C, $30, $28, $2B, $1D, $2C, $26, $22, $2D, $21, $2C
db $62, $EC, $00, $0F, $6F, $69, $65, $70, $64, $61, $6E, $75
db $63, $0C, $00, $0F, $95, $8F, $8B, $96, $8A, $87, $94, $9B
; the bug-catching kid
db $62, $66, $00, $27, $2D, $21, $1E, $9F, $1B, $2E, $20, $36, $1C, $1A, $2D, $1C, $21, $22, $27, $20, $9F, $24, $22, $1D
db $62, $E9, $00, $19, $67, $5D, $67, $5D, $6E, $65, $67, $6B, $9F, $70, $6B, $73, $6A
db $63, $09, $00, $19, $8D, $83, $8D, $83, $94, $8B, $8D, $91, $9F, $96, $91, $99, $90
; the lost old man
db $62, $48, $00, $1F, $2D, $21, $1E, $9F, $25, $28, $2C, $2D, $9F, $28, $25, $1D, $9F, $26, $1A, $27
db $62, $E9, $00, $1B, $60, $61, $5D, $70, $64, $9F, $69, $6B, $71, $6A, $70, $5D, $65, $6A
db $63, $09, $00, $1B, $86, $87, $83, $96, $8A, $9F, $8F, $91, $97, $90, $96, $83, $8B, $90
; the forest thief
db $62, $68, $00, $1F, $2D, $21, $1E, $9F, $1F, $28, $2B, $1E, $2C, $2D, $9F, $2D, $21, $22, $1E, $1F
db $62, $EB, $00, $13, $68, $6B, $6F, $70, $9F, $73, $6B, $6B, $60, $6F
db $63, $0B, $00, $13, $8E, $91, $95, $96, $9F, $99, $91, $91, $86, $95
; master sword
db $62, $66, $00, $27, $1A, $27, $1D, $9F, $2D, $21, $1E, $9F, $26, $1A, $2C, $2D, $1E, $2B, $9F, $2C, $30, $28, $2B, $1D
db $62, $A8, $00, $1D, $4A, $43, $3C, $3C, $47, $4A, $9F, $38, $3E, $38, $40, $45, $52, $52, $52
db $62, $EC, $00, $0F, $62, $6B, $6E, $61, $72, $61, $6E, $78
db $63, $0C, $00, $0F, $88, $91, $94, $87, $98, $87, $94, $9E
;--------------------------------------------------------------------------------
; org $0EECC0 ; PC 0x76CC0 poiters for above scenes
; dw $0000, $003C, $006A, $00AC, $00EA, $012A, $015D, $019D, $01D4, $020C, $0249, $0284, $02B7, $02F1, $0329, $0359, $039C
;================================================================================
org $30A000 ; $30A000 (0x182000) - $30A07F (0x18007F)
RNGSingleItemTable:
db $08, $09, $0A, $0B, $FF, $FF, $FF, $FF
db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
db $FF, $FF, $FF, $FF, $FF, $FF, $FF
RNGSingleTableSize:
db $04
org $30A080 ; $30A080 (0x182080) - $30A0FF (0x1800FF)
RNGMultiItemTable:
db $31, $36, $40, $46, $FF, $FF, $FF, $FF
db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
db $FF, $FF, $FF, $FF, $FF, $FF, $FF
RNGMultiTableSize:
db $04
;================================================================================
;PC 0x50563: $C5, $76 ; move tile and turn into chest orig: $3F, $14
;PC 0x50599: $38; lock door into room orig: $00
;PC 0xE9A5: $10, $00, $58 ; borrow unused Ice Palace dungeon secret to fill chest orig: $7E, $00, $24
;--------------------------------------------------------------------------------
;00:Fighter's Sword (1) and Fighter's Shield (1)
;01:Master Sword (2)
;02:Tempered Sword (3)
;03:Golden Sword (4)
;04:Fighter's Shield (1)
;05:Red Shield (2)
;06:Mirror Shield (3)
;07:FireRod
;08:IceRod
;09:Hammer
;0A:HookShot
;0B:Bow
;0C:Boomerang (Alternate = 10 Arrows)
;0D:Powder
;0E:Bee
;0F:Bombos

;10:Ether
;11:Quake
;12:Lamp (Alternate = 5 Rupees)
;13:Shovel
;14:Flute
;15:Red Cane
;16:Bottle
;17:Heart Piece
;18:Blue Cane
;19:Cape
;1A:Mirror
;1B:Power Glove (1)
;1C:Titan Mitts (2)
;1D:Book
;1E:Flippers
;1F:Moon Pearl

;20:Crystal
;21:Net
;22:Blue Mail (2)
;23:Red Mail (3)
;24:Small Key
;25:Compass
;26:Heart Piece Completion Heart
;27:Bomb
;28:3 Bombs
;29:Mushroom
;2A:Red Boomerang (Alternate = 300 Rupees)
;2B:Red Potion (with bottle)
;2C:Green Potion (with bottle)
;2D:Blue Potion (with bottle)
;2E:Red Potion (without bottle)
;2F:Green Potion (without bottle)

;30:Blue Potion (without bottle)
;31:10 Bombs
;32:Big Key
;33:Map
;34:1 Rupee
;35:5 Rupees
;36:20 Rupees
;37:Pendant 1
;38:Pendant 2
;39:Pendant 3
;3A:Bow And Arrows (Different from "Bow", thrown into Fairy Fountains)
;3B:Bow And Silver Arrows
;3C:Bee
;3D:Fairy
;3E:Boss Heart
;3F:Sanctuary Heart

;40:100 Rupees
;41:50 Rupees
;42:Heart
;43:Arrow
;44:10 Arrows
;45:Magic
;46:300 Rupees
;47:20 Rupees
;48:Gold Bee
;49:Fighter's Sword (1) (without shield, thrown into Fairy Fountains)
;4A:Flute
;4B:Boots

;4C:Max Bombs
;4D:Max Arrows
;4E:Half Magic
;4F:Quarter Magic

;50:Master Sword (No Special Handling)

;51:+5 Bombs
;52:+10 Bombs
;53:+5 Arrows
;54:+10 Arrows

;55:Programmable Item 1
;56:Programmable Item 2
;57:Programmable Item 3

;58:Upgrade-Only Silver Arrows

;59:Rupoor
;5A:Null Item

;5B:Red Clock
;5C:Blue Clock
;5D:Green Clock

;5E:Progressive Sword
;5F:Progressive Shield
;60:Progressive Armor
;61:Progressive Lifting Glove

;62:RNG Pool Item (Single)
;63:RNG Pool Item (Multi)

;6A:Goal Item (Single/Triforce)
;6B:Goal Item (Multi/Power Star)

;DO NOT PLACE FREE DUNGEON ITEMS WITHIN THEIR OWN DUNGEONS - USE THE NORMAL VARIANTS

;70 - Map of Light World
;71 - Map of Dark World
;72 - Map of Ganon's Tower
;73 - Map of Turtle Rock
;74 - Map of Thieves' Town
;75 - Map of Tower of Hera
;76 - Map of Ice Palace
;77 - Map of Skull Woods
;78 - Map of Misery Mire
;79 - Map of Dark Palace
;7A - Map of Swamp Palace
;7B - Map of Agahnim's Tower
;7C - Map of Desert Palace
;7D - Map of Eastern Palace
;7E - Map of Hyrule Castle
;7F - Map of Sewers

;80 - Compass of Light World
;81 - Compass of Dark World
;82 - Compass of Ganon's Tower
;83 - Compass of Turtle Rock
;84 - Compass of Thieves' Town
;85 - Compass of Tower of Hera
;86 - Compass of Ice Palace
;87 - Compass of Skull Woods
;88 - Compass of Misery Mire
;89 - Compass of Dark Palace
;8A - Compass of Swamp Palace
;8B - Compass of Agahnim's Tower
;8C - Compass of Desert Palace
;8D - Compass of Eastern Palace
;8E - Compass of Hyrule Castle
;8F - Compass of Sewers

;90 - Skull Key
;91 - Reserved
;92 - Big Key of Ganon's Tower
;93 - Big Key of Turtle Rock
;94 - Big Key of Thieves' Town
;95 - Big Key of Tower of Hera
;96 - Big Key of Ice Palace
;97 - Big Key of Skull Woods
;98 - Big Key of Misery Mire
;99 - Big Key of Dark Palace
;9A - Big Key of Swamp Palace
;9B - Big Key of Agahnim's Tower
;9C - Big Key of Desert Palace
;9D - Big Key of Eastern Palace
;9E - Big Key of Hyrule Castle
;9F - Big Key of Sewers

;A0 - Small Key of Sewers
;A1 - Small Key of Hyrule Castle
;A2 - Small Key of Eastern Palace
;A3 - Small Key of Desert Palace
;A4 - Small Key of Agahnim's Tower
;A5 - Small Key of Swamp Palace
;A6 - Small Key of Dark Palace
;A7 - Small Key of Misery Mire
;A8 - Small Key of Skull Woods
;A9 - Small Key of Ice Palace
;AA - Small Key of Tower of Hera
;AB - Small Key of Thieves' Town
;AC - Small Key of Turtle Rock
;AD - Small Key of Ganon's Tower
;AE - Reserved
;AF - Generic Small Key
;--------------------------------------------------------------------------------
org $308400 ; PC 0x180400
;================================================================================
;Vortexes
org $05AF79 ; PC 0x2AF79 (sprite_warp_vortex.asm:18) (BNE)
db #$D0 ; #$D0 - Light-to-Dark (Default), #$F0 - Dark-to-Light, #$42 - Both Directions
;Mirror
org $07A943 ; PC 013A943 (Bank07.asm:6548) (BNE)
db #$D0 ; #$D0 - Dark-to-Light (Default), #$F0 - Light-to-Dark, #$42 - Both Directions
;Residual Portal
org $07A96D ; PC 013A96D (Bank07.asm:6579) (BEQ)
db #$F0 ; #$F0 - Light Side (Default), #$D0 - Dark Side, #$42 - Both Sides
org $07A9A7 ; PC 013A9A7 (Bank07.asm:6622) (BNE)
db #$D0 ; #$D0 - Light Side (Default), #$F0 - Dark Side, #$42 - Both Sides
;================================================================================
org $0DDBEC ; <- 6DBEC
dw #10000 ; Rupee Limit +1
org $0DDBF1 ; <- 6DBF1
dw #9999 ; Rupee Limit
;================================================================================
;2B:Bottle Already Filled w/ Red Potion
;2C:Bottle Already Filled w/ Green Potion
;2D:Bottle Already Filled w/ Blue Potion
;3C:Bottle Already Filled w/ Bee
;3D:Bottle Already Filled w/ Fairy
;48:Bottle Already Filled w/ Gold Bee
;================================================================================
; $2F8000 - $2F83FF - RNG Block
;================================================================================
; $7EC025 - $7EC034 - Item OAM Table
;================================================================================
; $7F5000 - Redraw Flag
; $7F5001 - Flipper Softlock Possible
; $7F5002 - L/R Rotate
; $7F5003 - HexToDec 1st Digit
; $7F5004 - HexToDec 2nd Digit
; $7F5005 - HexToDec 3rd Digit
; $7F5006 - HexToDec 4th Digit
; $7F5007 - HexToDec 5th Digit
; $7F5008 - Skip Sprite_DrawMultiple EOR
; $7F5009 - Always Zero
; $7F5010 - Scratch Space (Callee Preserved)
; $7F5020 - Scratch Space (Caller Preserved)
; $7F5030 - Jar Cursor Status
; $7F5031 - HUD Master Sword Flag
; $7F5032 - Ganon Warp Chain Flag
; $7F5033 - Force Heart Spawn Counter
; $7F5034 - Skip Heart Collection Save Counter
; $7F5035 - Alternate Text Pointer Flag ; 0=Disable
; $7F5036 - Padding Byte (Must be Zero)
; $7F5037 - Stats Boss Kills
; $7F5038 - Stats Lag Time
; $7F5039 - Stats Lag Time
; $7F503A - Stats Lag Time
; $7F503B - Stats Lag Time
; $7F503C - Stats Rupee Total
; $7F503D - Stats Rupee Total
; $7F503E - Stats Item Total
; $7F503F - Bonk Repeat
; $7F5040 - Free Item Dialog Temporary
; $7F5041 - Unused
; $7F5042 - Tile Upload Offset Override (Low)
; $7F5043 - Tile Upload Offset Override (High)
; $7F5044 - $7F504F - Unused
; $7F5050 - $7F506F - Shop Block
; $7F5070 - $7F507E - Unused
; $7F507E - Clock Status
; $7F507F - Always Zero
; $7F5080 - $7F5083 - Clock Hours
; $7F5084 - $7F5087 - Clock Minutes
; $7F5088 - $7F508B - Clock Seconds
; $7F508C - $7F508F - Clock Temporary
; $7F5090 - RNG Item Lock-In
; $7F5091 - Item Animation Busy Flag
; $7F5092 - Potion Animation Busy Flags (Health)
; $7F5093 - Potion Animation Busy Flags (Magic)
; $7F5094 - Dialog Offset Pointer (Low)
; $7F5095 - Dialog Offset Pointer (High)
; $7F5096 - Dialog Offset Pointer Return (Low)
; $7F5097 - Dialog Offset Pointer Return (High)
; $7F5098 - Water Entry Index
; $7F5099 - Last Entered Overworld Door ID
; $7F509A - (Reserved)

; $7F50A0 - Event Parameter 1

; $7F50B0 - $7F50BF - Downstream Reserved (Enemizer)

; $7F50C0 - Sword Modifier
; $7F50C1 - Shield Modifier (Not Implemented)
; $7F50C2 - Armor Modifier
; $7F50C3 - Magic Modifier
; $7F50C4 - Light Cone Modifier
; $7F50C5 - Cucco Attack Modifier
; $7F50C6 - Old Man Dash Modifier
; $7F50C7 - Ice Physics Modifier

; $7F50D0 - $7F50FF - Block Cypher Parameters
; $7F5100 - $7F51FF - Block Cypher Buffer
; $7F5200 - $7F52FF - RNG Pointer Block
;
; $7F5700 - $7F57FF - Dialog Buffer
;================================================================================
!BIGRAM = "$7EC900";
; $7EC900 - Big RAM Buffer ($1F00)
;================================================================================
org $30FF00 ; PC 0x187F00
NameHashTable: ; change this for each new version - MOVE THIS TO BANK $30
db $57, $41, $D6, $7A, $E0, $10, $8A, $97, $A2, $89, $82, $45, $46, $1C, $DF, $F7
db $55, $0F, $1D, $56, $AC, $29, $DC, $D1, $25, $2A, $C5, $92, $42, $B7, $BE, $50
db $64, $62, $31, $E8, $49, $63, $40, $5F, $C9, $47, $F6, $0B, $FA, $FC, $E4, $F0
db $E6, $8F, $6D, $B1, $68, $A4, $D3, $0E, $54, $5D, $6B, $CF, $20, $69, $33, $07
db $2C, $4D, $32, $77, $C1, $95, $7B, $DE, $66, $8C, $35, $84, $86, $7C, $44, $1A
db $3E, $15, $D4, $0C, $B5, $90, $4C, $B2, $26, $1E, $38, $C0, $76, $9C, $2B, $7F
db $5E, $D5, $75, $B6, $E3, $7D, $8D, $72, $3A, $CB, $6F, $5B, $AD, $BD, $F1, $BB
db $05, $9A, $F4, $03, $02, $FF, $DA, $4F, $93, $B3, $14, $EC, $EE, $D7, $F9, $96
db $A7, $13, $CA, $BF, $88, $19, $A3, $78, $24, $87, $3C, $9E, $B4, $27, $C2, $AF
db $80, $C4, $C8, $6C, $E9, $94, $F8, $8B, $3D, $34, $A6, $53, $17, $22, $F3, $A5
db $1B, $2E, $06, $39, $D2, $43, $73, $12, $09, $58, $30, $5C, $99, $98, $9F, $ED
db $37, $67, $EA, $BA, $E7, $D9, $81, $08, $7E, $BC, $70, $5A, $51, $C3, $B9, $61
db $36, $4B, $A8, $01, $65, $3B, $EF, $59, $04, $18, $79, $0D, $DD, $CE, $CC, $AE
db $83, $21, $EB, $6E, $0A, $71, $B0, $11, $85, $C7, $A1, $FD, $E5, $16, $48, $FB
db $F2, $23, $2F, $28, $9B, $AA, $AB, $D0, $6A, $9D, $C6, $2D, $00, $FE, $E1, $3F
db $A0, $4A, $B8, $4E, $74, $1F, $8E, $A9, $F5, $CD, $60, $91, $DB, $D8, $52, $E2
;================================================================================
org $30A100 ; PC 0x182100 - 0x182304
EntranceDoorFrameTable:
; data for multi-entrance caves
dw $0816, $0000, $0000, $0000, $0000, $0000, $0000, $0000
dw $0000, $0000, $0000, $0000, $05cc, $05d4, $0bb6, $0b86
dw $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000
dw $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000
dw $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000
dw $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000
dw $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000
dw $0000, $0000, $0000
; simple caves:
dw $0000, $0000, $0DE8, $0B98, $14CE, $0000, $1C50, $FFFF
dw $1466, $0000, $1AB6, $0B98, $1AB6, $040E, $9C0C, $1530
dw $0A98, $0000, $0000, $0000, $0000, $0000, $0000, $0816
dw $0DE8, $0000, $0000, $0000, $0000, $09AC, $0000, $0000
dw $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000
dw $041A, $0000, $091E, $09AC, $0000, $0000, $0000, $0000
dw $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000
dw $0000, $0AA8, $07AA, $0000, $0000, $0000, $0000, $0000
dw $0000, $0000, $0000, $0000, $0000, $0000
EntranceAltDoorFrameTable:
dw $0000, $01aa, $8124, $87be, $8158, $0000, $0000, $0000
dw $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000
dw $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000
dw $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000
dw $0000, $0000, $0000, $82be, $0000, $0000, $0000, $0000
dw $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000
dw $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000
dw $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000
dw $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000
dw $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000
dw $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000
dw $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000
dw $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000
dw $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000
dw $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000
dw $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000
dw $0000
;===============================================================================
org $30B000 ; PC 0x183000 - 0x183054
StartingEquipment:
dw $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000
dw $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000
dw $0000, $0000, $0000, $0000, $0000, $0000, $1818, $FF00
dw $0000, $0000, $0000, $0000, $F800, $0000, $0000, $0000
dw $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000
dw $0000, $0000
;===============================================================================
org $30C000 ; PC 0x184000 - 0x184007
ItemSubstitutionRules:
;db [item][quantity][substitution][pad] - CURRENT LIMIT 16 ENTRIES
db $12, $01, $35, $FF
db $FF, $FF, $FF, $FF
;================================================================================
;shop_config - t--- --qq
; t - 0=Shop - 1=TakeAny
; qq - # of items for sale
org $30C800 ; PC 0x184800 - 0x184FFF
ShopTable:
;db [id][roomID-low][roomID-high][doorID][zero][shop_config][pad][pad]
db $FF, $FF, $FF, $FF, $00, $03, $00, $00
ShopContentsTable:
;db [id][item][price-low][price-high][max][repl_id][repl_price-low][repl_price-high]
db $FF, $AF, $50, $00, $00, $FF, $00, $00
db $FF, $27, $0A, $00, $00, $FF, $00, $00
db $FF, $12, $F4, $01, $01, $2F, $3C, $00
db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
;================================================================================
org $30D000
MSUTrackList:
db $00,$01,$03,$03,$03,$03,$03,$03
db $01,$03,$01,$03,$03,$03,$03,$03
db $03,$03,$03,$01,$03,$03,$03,$03
db $03,$03,$03,$03,$03,$01,$03,$03
db $03,$01,$01,$FF,$FF,$FF,$FF,$FF
db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
;================================================================================
