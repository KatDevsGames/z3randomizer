;================================================================================
; Item Tables
;--------------------------------------------------------------------------------
org $308000 ; bank #$30 ; PC 0x180000 - 0x180006 [encrypted]
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
; 0x180006 - 0x18000F (unused) [encrypted]
;--------------------------------------------------------------------------------
org $308010 ; PC 0x180010 - 0x180017 [encrypted]
SpriteItemValues:
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
; 0x180017 - 0x18001F (unused) [encrypted]
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
org $308024 ; PC 0x180024 - 0x180027
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

org $308029 ; PC 0x180029 - 0x18002A
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
; 0x18002B- 0x180030 (Unused)
;--------------------------------------------------------------------------------
org $308031 ; PC 0x180031
EnableEasterEggs:
db #$00 ; #$00 = Off (default) - #$01 = On
;--------------------------------------------------------------------------------
; 0x180032 (unused)
;--------------------------------------------------------------------------------
org $308033 ; PC 0x180033
HeartBeep:
db #$20 ; #$00 = Off - #$20 = Normal (default) - #$40 = Half Speed - #$80 = Quarter Speed
;--------------------------------------------------------------------------------
org $308034 ; PC 0x180034 - 0x180035
StartingMaxBombs:
db #10 ; #10 = Default (10 decimal)
StartingMaxArrows:
db #30 ; #30 = Default (30 decimal)
;--------------------------------------------------------------------------------
org $308036 ; PC 0x180036 - 0x180037
RupoorDeduction:
dw #$000A ; #$0A - Default (10 decimal)
;--------------------------------------------------------------------------------
org $308038 ; PC 0x180038 -0x18003A
LampConeSewers:
db #$01 ; #$00 = Off - #$01 = On (default)
LampConeLightWorld:
db #$01 ; #$00 = Off (default) - #$01 = On
LampConeDarkWorld:
db #$00 ; #$00 = Off (default) - #$01 = On
;--------------------------------------------------------------------------------
org $30803B ; PC 0x18003B - PC 0x18003C
MapMode:
db #$00 ; #$00 = Always On (default) - #$01 = Require Map Item
CompassMode:
db #$00 ; #$00 = Off (default) - #$01 = Display Dungeon Count w/Compass - #$02 = Display Dungeon Count Always
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
; #$03 = Require "NumberOfCrystalsRequiredForGanon" Crystals and Aga2
; #$04 = Require "NumberOfCrystalsRequiredForGanon" Crystals
; #$05 = Require "GoalItemRequirement" Goal Items
; #$06 = Light Speed
; #$07 = Require All Crystals and Crystal Bosses
; #$08 = Require All Crystal Bosses only
;--------------------------------------------------------------------------------
org $30803F ; PC 0x18003F
HammerableGanon:
db #$00 ; #$00 = Off (default) - #$01 = On
;--------------------------------------------------------------------------------
; 0x180040 - (unused)
;--------------------------------------------------------------------------------
org $308041 ; PC 0x180041
AllowSwordlessMedallionUse:
db #$00 ; #$00 = Off (default) - #$01 = Medallion Pads - #$02 = Always
;--------------------------------------------------------------------------------
org $308042 ; PC 0x180042
PermitSQFromBosses:
db #$00 ; #$00 = Off (default) - #$01 = On
;--------------------------------------------------------------------------------
; 0x180043 (unused)
;--------------------------------------------------------------------------------
org $308044 ; PC 0x180044
AllowHammerTablets:
db #$00 ; #$00 = Off (default) - #$01 = On
;--------------------------------------------------------------------------------
org $30805D ; PC 0x18005D
AllowHammerEvilBarrierWithFighterSword:
db #$00 ; #$00 = Off (default) - #$01 = On
;--------------------------------------------------------------------------------
org $308045 ; PC 0x180045
HUDDungeonItems:
 ; display ---edcba a: Small Keys, b: Big Key, c: Map, d: Compass, e: Bosses
db #$00
;--------------------------------------------------------------------------------
; 0x180046 (unused)
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
org $30804A ; PC 0x18004A
InvertedMode:
db #$00 ; #$00 = Normal (default) - #$01 = Inverted
;--------------------------------------------------------------------------------
org $30804B ; PC 0x18004B
QuickSwapFlag:
db #$00 ; #$00 = Off (default) - #$01 = On
;--------------------------------------------------------------------------------
org $30804C ; PC 0x18004C
SmithTravelsFreely:
db #$00 ; #$00 = Off (default) - #$01 = On (frog/smith can enter multi-entrance doors)
;--------------------------------------------------------------------------------
org $30804D ; PC 0x18004D
EscapeAssist: ; ScrubMode:
db #$00
;---- -mba
;m - Infinite Magic
;b - Infinite Bombs
;a - Infinite Arrows
;--------------------------------------------------------------------------------
org $30804E ; PC 0x18004E
UncleRefill:
db #$00
;---- -mba
;m - Refill Magic
;b - Refill Bombs
;a - Refill Arrows
;--------------------------------------------------------------------------------
org $30804F ; PC 0x18004F
ByrnaInvulnerability:
db #$01 ; #$00 = Off - #$01 = On (default)
;--------------------------------------------------------------------------------
org $308050 ; PC 0x180050 - 0x18005C
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
;--------------------------------------------------------------------------------
org $30805E ; PC 0x18005E - Number of crystals required to enter GT
NumberOfCrystalsRequiredForTower:
db #$07 ; #$07 = 7 Crystals
org $30805F ; PC 0x18005F - Number of crystals required to kill Ganon
NumberOfCrystalsRequiredForGanon:
db #$07 ; #$07 = 7 Crystals
;--------------------------------------------------------------------------------
org $308060 ; PC 0x180060 - 0x18007E
ProgrammableItemLogicJump_1:
JSL.l $000000 : RTL
ProgrammableItemLogicJump_2:
JSL.l $000000 : RTL
ProgrammableItemLogicJump_3:
JSL.l $000000 : RTL

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
; 0x18007F (unused)
;--------------------------------------------------------------------------------
org $308070 ; PC 0x180070 - 0x18007F
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
org $308080 ; PC 0x180080 - 0x180083
Upgrade5BombsRefill:
db #$00
Upgrade10BombsRefill:
db #$00
Upgrade5ArrowsRefill:
db #$00
Upgrade10ArrowsRefill:
db #$00
;--------------------------------------------------------------------------------
org $308084 ; PC 0x180084 - 0x180085
PotionHealthRefill:
db #$A0 ; #$A0 - Full Refill (Default)
PotionMagicRefill:
db #$80 ; #$80 - Full Refill (Default)
;--------------------------------------------------------------------------------
org $308086 ; PC 0x180086
GanonAgahRNG:
db #$00 ; $00 = static rng, $01 = no extra blue balls/warps
;--------------------------------------------------------------------------------
org $308087 ; PC 0x180087
IsEncrypted:
dw #$0000 ; $0000 = not encrypted, $0001 = encrypted with static key, $0002 = Encrypted w/ passcode entry screen
;--------------------------------------------------------------------------------
org $308089 ; PC 0x180089
TurtleRockAutoOpenFix:
db #$00 ; #$00 - Normal, #$01 - Open TR Entrance if exiting from it
;--------------------------------------------------------------------------------
org $30808A ; PC 0x18008A
BlockCastleDoorsInRain:
db #$00 ; #$00 - Normal, $01 - Block them (Used by Entrance Rando in Standard Mode)
;--------------------------------------------------------------------------------
; 0x18008B-0x18008D (unused)
;--------------------------------------------------------------------------------
org $30808E ; PC 0x18008E
FakeBoots:
db $00 ; #$00 = Off (default) - #$01 = On
;--------------------------------------------------------------------------------
; 0x18008F (unused)
;--------------------------------------------------------------------------------
org $308090 ; PC 0x180090 - 0x180097
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
ProgressiveBowLimit:
db #$02 ; #$02 - 2 Bows (default)
ProgressiveBowReplacement:
db #$47 ; #$47 - 20 Rupees (default)
;--------------------------------------------------------------------------------
; 0x18009A - 0x18009C one mind
;--------------------------------------------------------------------------------
org $30809A ; PC 0x18009A
OneMindPlayerCount:
db 0
org $30809B ;  PC 0x18009B - 0x18009C
OneMindTimer:
dw 0
;--------------------------------------------------------------------------------
; 0x18009D - Dungeon map icons
; .... ...b
;
;  b - boss icon
;--------------------------------------------------------------------------------
org $30809D
DungeonMapIcons:
db $01
;--------------------------------------------------------------------------------
; 0x18009E - 0x18009F (unused)
;--------------------------------------------------------------------------------
org $3080A0 ; PC 0x1800A0 - 0x1800A4
Bugfix_MirrorlessSQToLW:
db #$01 ; #$00 = Original Behavior - #$01 = Randomizer Behavior (Default)
Bugfix_SwampWaterLevel:
db #$01 ; #$00 = Original Behavior - #$01 = Randomizer Behavior (Default)
Bugfix_PreAgaDWDungeonDeathToFakeDW:
db #$01 ; #$00 = Original Behavior - #$01 = Randomizer Behavior (Default)
Bugfix_SetWorldOnAgahnimDeath:
db #$01 ; #$00 = Original Behavior - #$01 = Randomizer Behavior (Default)
Bugfix_PodEG:
db #$01 ; #$00 = Original Behavior - #$01 = Randomizer Behavior (Default)
;--------------------------------------------------------------------------------
; 0x1800A5 - 0x1800AF (unused)
;--------------------------------------------------------------------------------
org $3080B0 ; 0x1800B0-0x1800BF
StaticDecryptionKey:
dd $00000000, $00000000, $00000000, $00000000
;--------------------------------------------------------------------------------
org $3080C0 ; 0x1800C0-0x1800C7 [encrypted]
KnownEncryptedValue:
db $31, $41, $59, $26, $53, $58, $97, $93
;--------------------------------------------------------------------------------
; 0x1800C8 - 0x1800FF (unused)
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
; Bank 30 resumes below at HeartPieceOutdoorValues
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

org $02D592+$03
Music_Castle:
db $10,$10,$10
org $02D592+$24
Music_AgaTower:
db $10
org $02D592+$81
Music_Sewer:
db $10

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
Music_Skull_Drop:
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
; OWG EDM bridge sign text pointer (Message id of the upper left of map05 = map05)
;--------------------------------------------------------------------------------
org $07F501
dw #$018E
;--------------------------------------------------------------------------------
; GT sign text pointer (Message id of the upper right of map43 = map44)
;--------------------------------------------------------------------------------
org $07F57F
dw #$0190
;--------------------------------------------------------------------------------
; Pyramid sign text pointer (Message id of the upper left of map5B = map5B)
;--------------------------------------------------------------------------------
org $07F5AD
dw #$0191
;--------------------------------------------------------------------------------
; HC (inverted) left sign text pointer (Message id of the upper left of map1B = map1B)
;--------------------------------------------------------------------------------
org $07F52D
dw #$0190
;--------------------------------------------------------------------------------
; HC (inverted) right sign text pointer (Message id of the upper right of map1B = map1C)
;--------------------------------------------------------------------------------
org $07F52F
dw #$0191

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
;Crystal 8: $80
;--------------------------------------------------------------------------------
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
org $308140 ; PC 0x180140 - 0x18014A [encrypted]
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
;--------------------------------------------------------------------------------
; 0x18014B - 0x18014F (unused) [encrypted]
;================================================================================
org $308150 ; PC 0x180150 - 0x180159 [encrypted]
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
;--------------------------------------------------------------------------------
; 0x180159 - 0x18015F (unused) [encrypted]
;================================================================================
org $308160 ; PC 0x180160 - 0x180162
BonkKey_Desert:
	db #$24 ; #$24 = Small Key (default)
BonkKey_GTower:
	db #$24 ; #$24 = Small Key (default)
StandingKey_Hera:
	db #$24 ; #$24 = Small Key (default)
;--------------------------------------------------------------------------------
; 0x180163 - 0x180164 (unused)
;================================================================================
org $308165 ; PC 0x180165
GoalItemIcon:
dw #$280E ; #$280D = Star - #$280E = Triforce Piece (default)
;================================================================================
org $308167 ; PC 0x180167-0x180167
GoalItemRequirement:
dw $0000 ; #$0000 = Off (default) - #$XXXX = Require $XX Goal Items - #$FFFF = Counter-Only
;================================================================================
org $308169 ; PC 0x180169
AgahnimDoorStyle:
db #$01 ; #00 = Never Locked - #$01 = Locked During Escape (default) - #$02 = Locked Without 7 Crystals
;================================================================================
org $30816A ; PC 0x18016A
FreeItemText:
db #$00 ; #00 = Off (default)
;---o bmcs
;o - enabled for outside dungeon items
;b - enabled for inside big key items
;m - enabled for inside map items
;c - enabled for inside compass items
;s - enabled for inside small key items
;================================================================================
org $30816B ; PC 0x18016B - 0x18016D
HardModeExclusionCaneOfByrnaUsage:
db #$04, #$02, #$01 ; Normal, 1/2, 1/4 Magic
org $30816E ; PC 0x18016E - 308170
HardModeExclusionCapeUsage:
db #$04, #$08, #$10 ; Normal, 1/2, 1/4 Magic
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
db #$01 ; #00 = Fix Off (Default) - #$01 = Fix On
;================================================================================
org $308175 ; PC 0x180175 - 0x180179
ArrowMode:
db #$00 ; #00 = Normal (Default) - #$01 = Rupees
ArrowModeWoodArrowCost: ; keep these together
dw #$000A ; #$000A = 10 (Default)
ArrowModeSilverArrowCost: ; keep these together
dw #$0032 ; #$0032 = 50 (Default)
;================================================================================
org $30817A ; PC 0x18017A ; #$2000 for Eastern Palace
MapReveal_Sahasrahla:
dw #$0000
org $30817C ; PC 0x18017C ; #$0140 for Ice Palace and Misery Mire
MapReveal_BombShop:
dw #$0000
;================================================================================
org $30817E ; PC 0x18017E
Restrict_Ponds:
db #$01 ; #$00 = Original Behavior - #$01 - Restrict to Bottles (Default)
;================================================================================
org $30817F ; PC 0x18017F
DisableFlashing:
db #$00 ; #$00 = Flashing Enabled (Default) - #$01 = Flashing Disabled
;================================================================================
;---- --hb
;h - Hookshot
;b - Boomerang
org $308180 ; PC 0x180180
StunItemAction:
db #$03 ; #$03 = Hookshot and Boomerang (Default)
;================================================================================
org $308181 ; PC 0x180181
SilverArrowsUseRestriction:
db #$00 ; #$00 = Off (Default) - #$01 = Only At Ganon
;================================================================================
org $308182 ; PC 0x180182
SilverArrowsAutoEquip:
db #$01 ; #$00 = Off - #$01 = Collection Time (Default) - #$02 = Entering Ganon - #$03 = Collection Time & Entering Ganon
;================================================================================
org $308183 ; PC 0x180183
FreeUncleItemAmount:
dw #$12C ; 300 rupees (Default)
;--------------------------------------------------------------------------------
org $308185 ; PC 0x180185
RainDeathRefillTable:
RainDeathRefillMagic_Uncle:
db #$00
RainDeathRefillBombs_Uncle:
db #$00
RainDeathRefillArrows_Uncle:
db #$00
RainDeathRefillMagic_Cell:
db #$00
RainDeathRefillBombs_Cell:
db #$00
RainDeathRefillArrows_Cell:
db #$00
RainDeathRefillMagic_Mantle:
db #$00
RainDeathRefillBombs_Mantle:
db #$00
RainDeathRefillArrows_Mantle:
db #$00
;================================================================================
; 0x18018E - 0x18018F (unused)
;================================================================================
org $308190 ; PC 0x180190 - 0x180192
TimerStyle:
db #$00 ; #$00 = Off (Default) - #$01 Countdown - #$02 = Stopwatch
TimeoutBehavior:
db #$00 ; #$00 = DNF (Default) - #$01 = Sign Change (Requires TimerRestart == 1) - #$02 = OHKO - #$03 = End Game
TimerRestart:
db #$00 ; #$00 = Locked (Default) - #$01 = Restart
;--------------------------------------------------------------------------------
org $308193 ; PC 0x180193
ServerRequestMode:
db #$00 ; #$00 = Off (Default) - #$01 = Synchronous - #$02 = Asychronous
;---------------------------------------------------------------------------------
org $308194 ; PC 0x180194
TurnInGoalItems:
db #$01 ; #$00 = Instant win if last goal item collected. $01 = (Default) must turn in goal items
;--------------------------------------------------------------------------------
org $308195 ; PC 0x180195
ByrnaCaveSpikeDamage:
db #$08 ; #$08 = 1 Heart (default) - #$02 = 1/4 Heart
;--------------------------------------------------------------------------------
; 0x180196 - 0x1801FF (unused)
;================================================================================
org $308200 ; PC 0x180200 - 0x18020B
RedClockAmount:
dw #$4650, #$0000 ; $00004650 = +5 minutes
BlueClockAmount:
dw #$B9B0, #$FFFF ; $FFFFB9B0 = -5 minutes
GreenClockAmount:
dw #$0000, #$0000
;--------------------------------------------------------------------------------
; 0x18020C-0x18020F (unused)
;--------------------------------------------------------------------------------
;================================================================================
org $09E3BB ; PC 0x4E3BB
db $E4 ; Hera Basement Key (Set to programmable HP $EB) (set to $E4 for original hookable/boomable key behavior)
;================================================================================
org $308210 ; PC 0x180210
RandomizerSeedType:
db #$00 ; #$00 = Casual (default) - #$01 = Glitched - #$02 = Speedrunner - #$A0 = Super Metroid Combo - #$FF = Not Randomizer
;--------------------------------------------------------------------------------
org $308211 ; PC 0x180211
GameType:
;---- ridn
;r - room randomization
;i - item randomization
;d - door/entrance randomization
;n - enemy randomization
db #$00 ; #$00 = Not Randomized (default)
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
;--------------------------------------------------------------------------------
org $308215 ; PC 0x180215
SeedHash:
db $00, $01, $02, $03, $04
;--------------------------------------------------------------------------------
org $30821A ; PC 0x18021A
NoBGM:
db $00 ; $00 = BGM enabled (default) $01 = BGM disabled
org $30821B ; PC 0x18021B
FastFanfare:
db $00 ; $00 = Normal fanfare (default) $01 = Fast fanfare
org $30821C ; PC 0x18021C
MSUResumeType:
db $01 ; Type of tracks to resume #$00 = Everything - #$01 = Overworld (default)
org $30821D ; PC 0x18021D
MSUResumeTimer:
dw $0708 ; Number of frames on a different track until we no longer resume (0x708 = 1800 = ~30s)
;--------------------------------------------------------------------------------
; 0x18021F - 0x18021F (unused)
;================================================================================
; $308220 (0x180220) - $30823F (0x18023F)
; Plandomizer Author Name (ASCII) - Leave unused chars as 0
org $308220 ; PC 0x180220
;================================================================================
; $308240 (0x180420) - $308246 (0x180246)
; For starting areas in single entrance caves, we specify which row in the StartingAreaExitTable
; to use for exit information. Values are 1 based indexes, with 0 representing a multi-entrance cave
; start position.
; Position 0: Link's House
; Position 1: sanctuary
; Position 2: Zelda's cell
; Position 3: Wounded Uncle
; Position 4: Mantle
; Position 5: Middle of Old Man Cave
; Position 6: Old Man's House
org $308240 ; PC 0x180240
StartingAreaExitOffset:
db $00, $00, $00, $00, $00, $00, $00
;--------------------------------------------------------------------------------
org $308247 ; PC 0x180247
; For any starting areas in single entrance caves you can specify the overworld door here
; to enable drawing the doorframes These values should be the overworld door index+1.
; A value of zero will draw no door frame.
StartingAreaOverworldDoor:
db $00, $00, $00, $00, $00, $00, $00
;--------------------------------------------------------------------------------
; 0x18024E - 0x18024F (unused)
;-------------------------------------------------------------------------------
; $308250 (0x180250) - $30829F (0x18029F)
org $308250 ; PC 0x180250
StartingAreaExitTable:
; This has the same format as the main Exit table, except
; is stored row major instead of column major
; it lacks the last two columns and has 1 padding byte per row (the last byte)
dw $0112 : db $53 : dw $001e, $0400, $06e2, $0446, $0758, $046d, $075f : db $00, $00, $00
dw $0000 : db $00 : dw $0000, $0000, $0000, $0000, $0000, $0000, $0000 : db $00, $00, $00
dw $0000 : db $00 : dw $0000, $0000, $0000, $0000, $0000, $0000, $0000 : db $00, $00, $00
dw $0000 : db $00 : dw $0000, $0000, $0000, $0000, $0000, $0000, $0000 : db $00, $00, $00
;--------------------------------------------------------------------------------
; 0x1802A0 - 0x1802FF (unused)
;--------------------------------------------------------------------------------
; $308300 (0x180300) - $30834F (0x18034F)
org $308300 ; PC 0x180300
ExtraHole_Map16:
dw $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF
dw $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF
ExtraHole_Area:
dw $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF
dw $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF
ExtraHole_Entrance:
db $00, $00, $00, $00, $00, $00, $00, $00
db $00, $00, $00, $00, $00, $00, $00, $00
;--------------------------------------------------------------------------------
; $308350 (0x180350) - $30834F (0x18034F)
; Correspond to the three start options
; do not set for a starting location that is using a single entrance cave
org $308350 ; PC 0x180350
ShouldStartatExit:
db $00, $00, $00
;--------------------------------------------------------------------------------
; $308358 (0x180358) fixes major glitches
; 0x00 - fix
; otherwise dont fix various major glitches
org $308358
AllowAccidentalMajorGlitch:
db $00
;================================================================================
; 0x180359 - 0x1814FF (unused)
;================================================================================
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
org $30A080 ; $30A080 (0x182080) - $30A0FF (0x1820FF)
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
;--------------------------------------------------------------------------------
; Bank 30 continues down below at EntranceDoorFrameTable
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

;64:Progressive Bow
;65:Progressive Bow

;6A:Goal Item (Single/Triforce)
;6B:Goal Item (Multi/Power Star)

;6D:Server Request Item
;6E:Server Request Item (Dungeon Drop)

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
;================================================================================
;;Residual Portal
;org $0283E0 ; PC 0x103E0 (Bank02.asm:816) (BNE)
;db #$F0 ; #$D0 - Light Only (Default), #$F0 - Dark Only
;org $02B34D ; PC 0x1334D (Bank02.asm:7902) (BNE)
;db #$F0 ; #$D0 - Light Only (Default), #$F0 - Dark Only
;org $06DB78 ; PC 0x35B78 (Bank06.asm:2186) ($24)
;db #$8B ; #$24 - Light Style, #$8B - Dark Style
;;Portal indicator in dark world map
;org $0ABFBB ; Bank0a.asm:1005 (LDA $008A : CMP.b #$40 : BCS BRANCH_BETA)
;db $90 ;$90 (BCC) - Show in Dark World, $B0 (BCS) normal
;;--------------------------------------------------------------------------------
;;Vortexes
;org $05AF79 ; PC 0x2AF79 (sprite_warp_vortex.asm:18) (BNE)
;db #$F0 ; #$D0 - Light Only (Default), #$F0 - Dark Only
;org $0DB3C5 ; PC 0x6B3C5 (sprite_properties.asm:119) ($C4)
;db #$C6 ; #$C4 - Blue Portal, #$C6 - Red Portal
;;--------------------------------------------------------------------------------
;;Duck
;org $07A3F4 ; PC 0x3A3F4 (Bank07.asm:5772) (BNE)
;db #$F0 ; #$D0 - Light Only (Default), #$F0 - Dark Only
;org $02E849 ; PC 0x16849 (Bank02.asm:11641)
;;dw $0003, $0016, $0018, $002C, $002F, $0030, $003B, $003F ; Light World Flute Spots
;dw $0043, $0056, $0058, $006C, $006F, $0070, $007B, $007F ; Dark World Flute Spots
;org $02E8D5 ; PC 0x168D5 (Bank02.asm:11661) ($07B7)
;dw $07C8 ; $07B7 - Normal Location 3 Y (Default), $07C7 - Inverted Location 3 Y
;org $02E8F7; PC 0x168F7 (Bank02.asm:11661) ($07B7)
;dw $01F8 ; $0200 - Normal Location 3 X (Default), $0200 - Inverted Location 3 X
;;--------------------------------------------------------------------------------
;;Mirror
;org $07A943 ; PC 0x3A943 (Bank07.asm:6548) (BNE)
;db #$80 ; #$D0 - Dark-to-Light (Default), #$F0 - Light-to-Dark, #$80 - Both Directions, #$42 - Disabled
;;--------------------------------------------------------------------------------
;;Residual Portal
;org $07A96D ; PC 0x3A96D (Bank07.asm:6578) (BEQ)
;db #$D0 ; #$F0 - Light Side (Default), #$D0 - Dark Side
;;--------------------------------------------------------------------------------
;org $08D40C ; PC 0x4540C (ancilla_morph_poof.asm:48) (BEQ)
;db #$D0 ; #$F0 - Light Side (Default), #$D0 - Dark Side
;;--------------------------------------------------------------------------------
;; Spawn
; org $0280a6 ; <- Bank02.asm : 257 (LDA $7EF3CA : BEQ .inLightWorld)
;db #$D0 ; #F0 - default to light (Default), #$D0 - Default to dark
;;--------------------------------------------------------------------------------
;org $06B2AA ; <- 332AA sprite_smithy_bros.asm : 152 (JSL Sprite_ShowSolicitedMessageIfPlayerFacing)
;JSL Sprite_ShowMessageFromPlayerContact ; Inverted uses Sprite_ShowMessageFromPlayerContact
;;---------------------------------------------------------------------------------
org $00886e ; <- Bank00.asm : 1050 (LDA Overworld_TileAttr, X)
LDA Overworld_TileAttr, X ; use "JML InvertedTileAttributeLookup" for inverted
Overworld_GetTileAttrAtLocation_continue:
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
; $7F503F - Unused
; $7F5040 - Free Item Dialog Temporary
; $7F5041 - Epilepsy Safety Timer
; $7F5042 - Tile Upload Offset Override (Low)
; $7F5043 - Tile Upload Offset Override (High)
; $7F5044 - $7F5046 - NMI Auxiliary Function
; $7F5047 - $7F504F - Unused
; $7F5050 - $7F506F - Shop Block
; $7F5070 - Reserved for OneMind
; $7F5071 - Reserved for OneMind
; $7F5072 - OneMind player ID
; $7F5073 - $7F5074 - OneMind timer
; $7F5075 - $7F507D - Unused
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
; $7F509B - Unused
; $7F509C - Inverted Mode Duck Map Temporary
; $7F509D - Stalfos Bomb Damage Value
; $7F509E - Valid Key Loaded
; $7F509F - Text Box Defer Flag
; $7F50A0 - $7F50AF - MSU Block

; $7F50B0 - $7F50BF - Downstream Reserved (Enemizer)

; $7F50C0 - Sword Modifier
; $7F50C1 - Shield Modifier (Not Implemented)
; $7F50C2 - Armor Modifier
; $7F50C3 - Magic Modifier
; $7F50C4 - Light Cone Modifier
; $7F50C5 - Cucco Storm
; $7F50C6 - Old Man Dash Modifier
; $7F50C7 - Ice Physics Modifier
; $7F50C8 - Infinite Arrows Modifier
; $7F50C9 - Infinite Bombs Modifier
; $7F50CA - Infinite Magic Modifier
; $7F50CB - Invert D-Pad (Fill in values)
; $7F50CC - Temporary OHKO
; $7F50CD - Sprite Swapper
; $7F50CE - Boots Modifier (0=Off, 1=Always, 2=Never)

; $7F50D0 - $7F50FF - Block Cypher Parameters
; $7F5100 - $7F51FF - Block Cypher Buffer
; $7F5200 - $7F52FF - RNG Pointer Block
; $7F5300 - $7F53FF - Multiworld Block
; $7F5400 - $7F540F - MSU Block
; $7F5410 - $7F545F - Dungeon Tracking Block
; $7F5460 - $7F56FF - Unused

; $7F5700 - $7F57FF - Dialog Buffer
;
;================================================================================
!BIGRAM = "$7EC900";
; $7EC900 - Big RAM Buffer ($1F00)
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
;--------------------------------------------------------------------------------
; 0x182305 - 182FFF (unused)
;================================================================================
org $30B000 ; PC 0x183000 - 0x1834FF
incsrc initsramtable.asm

;--------------------------------------------------------------------------------
; 0x183500 - 183FFF (unused)
;================================================================================
org $30C000 ; PC 0x184000 - 0x184040
ItemSubstitutionRules:
;db [item][quantity][substitution][pad] - CURRENT LIMIT 16 ENTRIES
db $12, $01, $35, $FF
db $51, $06, $52, $FF
db $53, $06, $54, $FF
db $FF, $FF, $FF, $FF

org $30C041 ; PC 0x184041
ForceFileName:
db $00 ; $00 = Player picks name (default) - $01 = Use StaticFileName (initsramtable.asm)

;--------------------------------------------------------------------------------
; 0x18405B - 0x1847FF (unused)
;================================================================================
;shop_config - tdav --qq
; t - 0=Shop - 1=TakeAny
; d - 0=Check Door - 1=Skip Door Check
; a - 0=Shop/TakeAny - 1=TakeAll
; v - 0=normal vram, 1= alt vram
; qq - # of items for sale

;shopkeeper_config - ppp- -sss
; ppp - palette
; sss - sprite type
org $30C800 ; PC 0x184800 - 0x1848FF - max 32 shops ; do not exceed 36 tracked items sram_index > ($24)
ShopTable:
;db [id][roomID-low][roomID-high][doorID][zero][shop_config][shopkeeper_config][sram_index]
db $01, $15, $01, $5D, $00, $12, $04, $00
db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF

org $30C900 ; PC 0x184900 - 0x184FFF - max 224 entries
ShopContentsTable:
;db [id][item][price-low][price-high][max][repl_id][repl_price-low][repl_price-high]
db $01, $51, $64, $00, $07, $FF, $00, $00
db $01, $53, $64, $00, $07, $FF, $00, $00
db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF

;--------------------------------------------------------------------------------
; 0x185060 - 1850FF (unused)
;--------------------------------------------------------------------------------
org $30D100 ; PC 0x185100 - 0x18513F
UnusedTable: ; please do not move this - kkat
db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF

;================================================================================
org $30D800 ; PC 0x185800 - 0x18591F
MSUTrackList:
db $01,$03,$03,$03,$03,$03,$03,$01
db $03,$01,$03,$03,$03,$03,$03,$03
db $03,$03,$01,$03,$03,$03,$03,$03
db $01,$01,$03,$03,$01,$03,$03,$03
db $01,$01,$03,$03,$03,$03,$03,$03
db $03,$03,$03,$03,$03,$03,$03,$03
db $03,$03,$03,$03,$03,$03,$03,$03
db $03,$03,$03,$03,$03,$00,$00,$00

MSUExtendedFallbackList:
db $01,$02,$03,$04,$05,$06,$07,$08
db $09,$0A,$0B,$0C,$0D,$0E,$0D,$10
db $11,$12,$13,$14,$15,$16,$17,$18
db $19,$1A,$1B,$1C,$1D,$1E,$1F,$20
db $21,$22,$11,$11,$10,$16,$16,$16
db $16,$16,$11,$16,$16,$16,$15,$15
db $15,$15,$15,$15,$15,$15,$15,$15
db $15,$15,$16,$02,$09,$00,$00,$00

MusicShuffleTable:
db $01,$02,$03,$04,$05,$06,$07,$08
db $09,$0A,$0B,$0C,$0D,$0E,$0F,$10
db $11,$12,$13,$14,$15,$16,$17,$18
db $19,$1A,$1B,$1C,$1D,$1E,$1F,$20
db $21,$22,$23,$24,$25,$26,$27,$28
db $29,$2A,$2B,$2C,$2D,$2E,$2F,$30
db $31,$32,$33,$34,$35,$36,$37,$38
db $39,$3A,$3B,$3C,$3D,$3E,$3F,$40

MSUDungeonFallbackList:
dw Music_Sewer
dw Music_Castle
dw Music_Eastern
dw Music_Desert
dw Music_AgaTower
dw Music_Swamp
dw Music_Darkness
dw Music_Mire
dw Music_Skull
dw Music_Ice
dw Music_Hera
dw Music_Thieves
dw Music_TRock
dw Music_GTower
dw $0000
dw $0000

;--------------------------------------------------------------------------------
; 0x185920 - 1859FF (Reserved)
;--------------------------------------------------------------------------------

;--------------------------------------------------------------------------------
; 0x185A00 - 186BFF (room headers)
;--------------------------------------------------------------------------------
; BG2PROP
; PALETTE
; BLKSET
; SPRSET
; BGMOVE
; EFFECT1
; EFFECT2
; PLANES1
; PLANES2
; WARP
; STAIRS1
; STAIRS2
; STAIRS3
; STAIRS4
;--------------------------------------------------------------------------------
RoomHeaders:
org $30DA00 : RoomHeader_0000: ; pc 0x185A00
db $41, $21, $13, $22, $07, $3D, $00, $00, $00, $10, $C0, $00, $00, $04

org $30DA0E : RoomHeader_0001: ; pc 0x185A0E
db $C0, $00, $00, $04, $00, $00, $00, $00, $00, $00, $72, $00, $50, $52

org $30DA1C : RoomHeader_0002: ; pc 0x185A1C
db $C0, $1D, $04, $06, $00, $14, $00, $00, $00, $00, $11, $00, $18, $0D

org $30DA2A : RoomHeader_0003: ; pc 0x185A2A
db $C0, $07, $06, $19, $00, $00, $00, $00, $0C, $02, $12, $00, $00, $00

org $30DA38 : RoomHeader_0004: ; pc 0x185A38
db $00, $18, $0D, $26, $00, $26, $14, $00, $00, $00, $B5, $00, $08, $08

org $30DA46 : RoomHeader_0005: ; pc 0x185A46
db $00, $08, $08, $14, $00, $25, $00, $20, $06, $05, $0C, $00, $25, $00

org $30DA54 : RoomHeader_0006: ; pc 0x185A54
db $00, $08, $08, $14, $00, $25, $00, $20, $06, $05, $0C, $00, $25, $00

org $30DA62 : RoomHeader_0007: ; pc 0x185A62
db $20, $06, $05, $0C, $00, $25, $00, $00, $00, $17, $17, $C0, $07, $06

org $30DA70 : RoomHeader_0008: ; pc 0x185A70
db $C0, $07, $06, $07, $00, $00, $00, $00, $0F, $07, $19, $00, $27, $00

org $30DA7E : RoomHeader_0009: ; pc 0x185A7E
db $00, $0F, $07, $19, $00, $27, $00, $00, $00, $4B, $4A, $4A, $00, $0F

org $30DA8C : RoomHeader_000A: ; pc 0x185A8C
db $00, $0F, $07, $19, $00, $27, $00, $00, $00, $09, $3A, $01, $0F, $07

org $30DA9A : RoomHeader_000B: ; pc 0x185A9A
db $01, $0F, $07, $19, $00, $03, $00, $00, $00, $6A, $1B, $C0, $28, $0E

org $30DAA8 : RoomHeader_000C: ; pc 0x185AA8
db $C0, $28, $0E, $13, $00, $00, $00, $00, $00, $00, $6B, $8C, $8C, $40

org $30DAB6 : RoomHeader_000D: ; pc 0x185AB6
db $40, $1B, $0E, $18, $05, $38, $00, $00, $13, $0B, $1C, $00, $08, $00

org $30DAC4 : RoomHeader_000E: ; pc 0x185AC4
db $00, $13, $0B, $1C, $00, $08, $00, $00, $00, $00, $1E, $00, $21, $13

org $30DAD2 : RoomHeader_000F: ; pc 0x185AD2
db $00, $21, $13, $22, $00, $00, $00, $00, $01, $01, $01, $00, $00, $00

org $30DAE0 : RoomHeader_0010: ; pc 0x185AE0
db $00, $21, $13, $22, $00, $00, $00, $00, $01, $01, $01, $00, $00, $00

org $30DAEE : RoomHeader_0011: ; pc 0x185AEE
db $00, $01, $01, $01, $00, $00, $00, $08, $00, $00, $02, $C0, $1D, $04

org $30DAFC : RoomHeader_0012: ; pc 0x185AFC
db $C0, $1D, $04, $06, $00, $00, $00, $00, $18, $0D, $26, $00, $00, $00

org $30DB0A : RoomHeader_0013: ; pc 0x185B0A
db $00, $18, $0D, $26, $00, $00, $00, $00, $18, $0D, $1E, $00, $00, $00

org $30DB18 : RoomHeader_0014: ; pc 0x185B18
db $20, $18, $0D, $26, $00, $00, $00, $C0, $18, $0D, $26, $00, $00, $00

org $30DB26 : RoomHeader_0015: ; pc 0x185B26
db $C0, $18, $0D, $26, $00, $00, $00, $00, $00, $00, $B6, $90, $08, $08

org $30DB34 : RoomHeader_0016: ; pc 0x185B34
db $90, $08, $08, $11, $03, $00, $00, $00, $00, $00, $66, $20, $06, $05

org $30DB42 : RoomHeader_0017: ; pc 0x185B42
db $20, $06, $05, $19, $00, $35, $00, $00, $00, $27, $07, $27, $01, $0F

org $30DB50 : RoomHeader_0018: ; pc 0x185B50
db $00, $07, $06, $07, $00, $00, $00, $00, $22, $12, $07, $00, $00, $00

org $30DB5E : RoomHeader_0019: ; pc 0x185B5E
db $01, $0F, $07, $19, $00, $00, $00, $00, $0F, $07, $19, $00, $16, $00

org $30DB6C : RoomHeader_001A: ; pc 0x185B6C
db $00, $0F, $07, $19, $00, $16, $00, $00, $00, $00, $6A, $6A, $68, $0F

org $30DB7A : RoomHeader_001B: ; pc 0x185B7A
db $68, $0F, $07, $08, $00, $03, $1C, $00, $00, $00, $0B, $00, $1A, $0E

org $30DB88 : RoomHeader_001C: ; pc 0x185B88
db $00, $1A, $0E, $09, $00, $04, $3F, $00, $00, $00, $8C, $00, $1B, $0E

org $30DB96 : RoomHeader_001D: ; pc 0x185B96
db $00, $1B, $0E, $18, $00, $00, $00, $00, $00, $00, $4C, $20, $13, $0B

org $30DBA4 : RoomHeader_001E: ; pc 0x185BA4
db $20, $13, $0B, $1C, $00, $17, $00, $00, $00, $3E, $0E, $00, $13, $0B

org $30DBB2 : RoomHeader_001F: ; pc 0x185BB2
db $00, $13, $0B, $29, $00, $17, $00, $00, $00, $00, $3F, $20, $0C, $02

org $30DBC0 : RoomHeader_0020: ; pc 0x185BC0
db $20, $0C, $02, $12, $00, $15, $25, $01, $01, $01, $01, $00, $00, $00

org $30DBCE : RoomHeader_0021: ; pc 0x185BCE
db $01, $01, $01, $01, $00, $00, $00, $00, $18, $0D, $26, $00, $01, $00

org $30DBDC : RoomHeader_0022: ; pc 0x185BDC
db $01, $01, $01, $01, $00, $00, $00, $00, $18, $0D, $26, $00, $01, $00

org $30DBEA : RoomHeader_0023: ; pc 0x185BEA
db $00, $18, $0D, $26, $00, $00, $00, $00, $18, $0D, $1E, $00, $00, $00

org $30DBF8 : RoomHeader_0024: ; pc 0x185BF8
db $00, $18, $0D, $26, $00, $01, $00, $00, $0A, $08, $11, $00, $16, $00

org $30DC06 : RoomHeader_0025: ; pc 0x185C06
db $00, $0A, $08, $11, $00, $16, $00, $00, $00, $00, $76, $76, $76, $20

org $30DC14 : RoomHeader_0026: ; pc 0x185C14
db $00, $0A, $08, $11, $00, $16, $00, $00, $00, $00, $76, $76, $76, $20

org $30DC22 : RoomHeader_0027: ; pc 0x185C22
db $20, $06, $05, $19, $00, $36, $00, $00, $00, $31, $17, $31, $80, $0A

org $30DC30 : RoomHeader_0028: ; pc 0x185C30
db $80, $0A, $08, $11, $00, $32, $1B, $00, $00, $00, $38, $CC, $0E, $09

org $30DC3E : RoomHeader_0029: ; pc 0x185C3E
db $CC, $0E, $09, $1A, $02, $25, $00, $00, $0F, $07, $19, $00, $00, $00

org $30DC4C : RoomHeader_002A: ; pc 0x185C4C
db $00, $0F, $07, $19, $00, $00, $00, $C0, $0F, $07, $2B, $00, $16, $00

org $30DC5A : RoomHeader_002B: ; pc 0x185C5A
db $C0, $0F, $07, $2B, $00, $16, $00, $00, $00, $00, $3B, $00, $13, $0B

org $30DC68 : RoomHeader_002C: ; pc 0x185C68
db $00, $07, $06, $07, $00, $00, $00, $00, $22, $12, $07, $00, $00, $00

org $30DC76 : RoomHeader_002D: ; pc 0x185C76
db $00, $13, $0B, $1C, $00, $2A, $00, $C0, $07, $06, $19, $00, $00, $00

org $30DC84 : RoomHeader_002E: ; pc 0x185C84
db $00, $13, $0B, $1C, $00, $2A, $00, $C0, $07, $06, $19, $00, $00, $00

org $30DC92 : RoomHeader_002F: ; pc 0x185C92
db $C0, $07, $06, $19, $00, $00, $00, $00, $0C, $02, $12, $00, $00, $00

org $30DCA0 : RoomHeader_0030: ; pc 0x185CA0
db $00, $0C, $02, $12, $00, $00, $00, $00, $00, $00, $40, $20, $06, $05

org $30DCAE : RoomHeader_0031: ; pc 0x185CAE
db $20, $06, $05, $19, $00, $37, $04, $22, $00, $77, $27, $77, $01, $01

org $30DCBC : RoomHeader_0032: ; pc 0x185CBC
db $01, $01, $01, $01, $00, $00, $00, $00, $00, $00, $42, $00, $04, $05

org $30DCCA : RoomHeader_0033: ; pc 0x185CCA
db $00, $04, $05, $0B, $00, $15, $25, $80, $0A, $08, $11, $00, $00, $00

org $30DCD8 : RoomHeader_0034: ; pc 0x185CD8
db $80, $0A, $08, $11, $00, $00, $00, $00, $00, $00, $54, $80, $0A, $08

org $30DCE6 : RoomHeader_0035: ; pc 0x185CE6
db $80, $0A, $08, $11, $00, $00, $19, $80, $0A, $08, $11, $00, $00, $00

org $30DCF4 : RoomHeader_0036: ; pc 0x185CF4
db $80, $0A, $08, $11, $00, $00, $00, $80, $0A, $08, $11, $00, $00, $00

org $30DD02 : RoomHeader_0037: ; pc 0x185D02
db $80, $0A, $08, $11, $00, $00, $19, $80, $0A, $08, $11, $00, $00, $00

org $30DD10 : RoomHeader_0038: ; pc 0x185D10
db $80, $0A, $08, $11, $00, $00, $00, $00, $00, $00, $28, $20, $0D, $09

org $30DD1E : RoomHeader_0039: ; pc 0x185D1E
db $20, $0D, $09, $13, $00, $00, $00, $00, $00, $29, $20, $0F, $07, $19

org $30DD2C : RoomHeader_003A: ; pc 0x185D2C
db $20, $0F, $07, $19, $00, $00, $00, $00, $00, $0A, $0A, $00, $0F, $07

org $30DD3A : RoomHeader_003B: ; pc 0x185D3A
db $00, $0F, $07, $08, $00, $00, $00, $00, $00, $00, $2B, $00, $07, $06

org $30DD48 : RoomHeader_003C: ; pc 0x185D48
db $00, $07, $06, $13, $00, $00, $00, $20, $1A, $0E, $0C, $00, $33, $00

org $30DD56 : RoomHeader_003D: ; pc 0x185D56
db $20, $1A, $0E, $0C, $00, $33, $00, $00, $00, $96, $96, $CC, $13, $0B

org $30DD64 : RoomHeader_003E: ; pc 0x185D64
db $CC, $13, $0B, $29, $02, $02, $00, $00, $00, $00, $1E, $00, $13, $0B

org $30DD72 : RoomHeader_003F: ; pc 0x185D72
db $00, $13, $0B, $29, $00, $27, $14, $00, $00, $00, $1F, $5F, $C0, $00

org $30DD80 : RoomHeader_0040: ; pc 0x185D80
db $C0, $00, $02, $27, $00, $00, $00, $00, $00, $00, $30, $B0, $01, $00

org $30DD8E : RoomHeader_0041: ; pc 0x185D8E
db $01, $00, $00, $02, $00, $13, $00, $00, $00, $00, $42, $01, $01, $01

org $30DD9C : RoomHeader_0042: ; pc 0x185D9C
db $01, $01, $01, $01, $00, $00, $00, $00, $00, $00, $41, $32, $68, $04

org $30DDAA : RoomHeader_0043: ; pc 0x185DAA
db $68, $04, $05, $0A, $00, $00, $1D, $00, $17, $0A, $1B, $00, $01, $00

org $30DDB8 : RoomHeader_0044: ; pc 0x185DB8
db $00, $17, $0A, $1B, $00, $01, $00, $60, $17, $0A, $1B, $00, $01, $00

org $30DDC6 : RoomHeader_0045: ; pc 0x185DC6
db $60, $17, $0A, $1B, $00, $01, $00, $00, $00, $00, $BC, $00, $0A, $08

org $30DDD4 : RoomHeader_0046: ; pc 0x185DD4
db $00, $0A, $08, $11, $00, $3C, $00, $00, $0D, $09, $13, $00, $33, $34

org $30DDE2 : RoomHeader_0047: ; pc 0x185DE2
db $00, $0D, $09, $13, $00, $33, $34, $00, $0F, $07, $19, $00, $17, $00

org $30DDF0 : RoomHeader_0048: ; pc 0x185DF0
db $00, $0D, $09, $13, $00, $33, $34, $00, $0F, $07, $19, $00, $17, $00

org $30DDFE : RoomHeader_0049: ; pc 0x185DFE
db $00, $0D, $09, $13, $00, $33, $34, $00, $0F, $07, $19, $00, $17, $00

org $30DE0C : RoomHeader_004A: ; pc 0x185E0C
db $00, $0F, $07, $19, $00, $17, $00, $00, $00, $00, $09, $09, $00, $0F

org $30DE1A : RoomHeader_004B: ; pc 0x185E1A
db $00, $0F, $07, $08, $00, $01, $00, $00, $00, $09, $00, $1A, $0E, $0C

org $30DE28 : RoomHeader_004C: ; pc 0x185E28
db $00, $1A, $0E, $0C, $00, $00, $00, $00, $00, $00, $1D, $20, $1A, $0E

org $30DE36 : RoomHeader_004D: ; pc 0x185E36
db $20, $1A, $0E, $0C, $00, $32, $3F, $00, $00, $A6, $A6, $00, $13, $0B

org $30DE44 : RoomHeader_004E: ; pc 0x185E44
db $00, $13, $0B, $29, $00, $17, $00, $00, $00, $00, $6E, $00, $13, $0B

org $30DE52 : RoomHeader_004F: ; pc 0x185E52
db $00, $13, $0B, $1C, $00, $00, $00, $00, $00, $BE, $C0, $00, $00, $04

org $30DE60 : RoomHeader_0050: ; pc 0x185E60
db $C0, $00, $00, $04, $00, $00, $00, $00, $00, $00, $00, $00, $01, $01

org $30DE6E : RoomHeader_0051: ; pc 0x185E6E
db $C0, $00, $00, $03, $00, $00, $00, $00, $00, $00, $61, $C0, $00, $00

org $30DE7C : RoomHeader_0052: ; pc 0x185E7C
db $C0, $00, $00, $04, $00, $00, $00, $00, $00, $00, $00, $00, $01, $01

org $30DE8A : RoomHeader_0053: ; pc 0x185E8A
db $C0, $04, $05, $0A, $00, $03, $00, $00, $00, $00, $63, $20, $0A, $08

org $30DE98 : RoomHeader_0054: ; pc 0x185E98
db $20, $0A, $08, $11, $00, $00, $00, $00, $00, $34, $34, $01, $01, $10

org $30DEA6 : RoomHeader_0055: ; pc 0x185EA6
db $01, $01, $10, $0D, $00, $00, $00, $00, $0D, $09, $13, $00, $23, $00

org $30DEB4 : RoomHeader_0056: ; pc 0x185EB4
db $00, $0D, $09, $13, $00, $23, $00, $00, $0D, $09, $13, $00, $16, $00

org $30DEC2 : RoomHeader_0057: ; pc 0x185EC2
db $00, $0D, $09, $13, $00, $16, $00, $00, $0D, $09, $13, $00, $21, $28

org $30DED0 : RoomHeader_0058: ; pc 0x185ED0
db $00, $0D, $09, $13, $00, $21, $28, $C0, $0D, $09, $13, $00, $00, $00

org $30DEDE : RoomHeader_0059: ; pc 0x185EDE
db $C0, $0D, $09, $13, $00, $00, $00, $00, $10, $07, $15, $00, $25, $00

org $30DEEC : RoomHeader_005A: ; pc 0x185EEC
db $00, $10, $07, $15, $00, $25, $00, $C0, $1B, $0E, $0A, $00, $17, $00

org $30DEFA : RoomHeader_005B: ; pc 0x185EFA
db $C0, $1B, $0E, $0A, $00, $17, $00, $00, $1B, $0E, $0A, $00, $00, $00

org $30DF08 : RoomHeader_005C: ; pc 0x185F08
db $00, $1B, $0E, $0A, $00, $00, $00, $00, $00, $00, $5D, $00, $24, $0E

org $30DF16 : RoomHeader_005D: ; pc 0x185F16
db $00, $24, $0E, $23, $00, $09, $00, $00, $00, $00, $5C, $20, $13, $0B

org $30DF24 : RoomHeader_005E: ; pc 0x185F24
db $20, $13, $0B, $1C, $00, $00, $00, $00, $00, $7E, $7E, $00, $13, $0B

org $30DF32 : RoomHeader_005F: ; pc 0x185F32
db $00, $13, $0B, $1C, $00, $27, $00, $00, $00, $00, $3F, $7F, $C0, $00

org $30DF40 : RoomHeader_0060: ; pc 0x185F40
db $C0, $00, $00, $04, $00, $00, $00, $C0, $00, $00, $04, $00, $00, $00

org $30DF4E : RoomHeader_0061: ; pc 0x185F4E
db $C0, $00, $00, $04, $00, $00, $00, $08, $00, $00, $51, $00, $09, $05

org $30DF5C : RoomHeader_0062: ; pc 0x185F5C
db $C0, $00, $00, $04, $00, $00, $00, $C0, $00, $00, $04, $00, $00, $00

org $30DF6A : RoomHeader_0063: ; pc 0x185F6A
db $00, $09, $05, $0A, $00, $0D, $00, $00, $00, $00, $53, $E0, $23, $0A

org $30DF78 : RoomHeader_0064: ; pc 0x185F78
db $E0, $23, $0A, $21, $00, $17, $00, $00, $00, $00, $AB, $E0, $23, $0A

org $30DF86 : RoomHeader_0065: ; pc 0x185F86
db $E0, $23, $0A, $21, $00, $00, $00, $00, $00, $AC, $C0, $0A, $08, $11

org $30DF94 : RoomHeader_0066: ; pc 0x185F94
db $C0, $0A, $08, $11, $00, $3C, $00, $00, $00, $00, $16, $00, $0D, $09

org $30DFA2 : RoomHeader_0067: ; pc 0x185FA2
db $00, $0D, $09, $13, $00, $22, $00, $00, $0D, $09, $13, $00, $00, $00

org $30DFB0 : RoomHeader_0068: ; pc 0x185FB0
db $00, $0D, $09, $13, $00, $00, $00, $01, $0F, $07, $19, $00, $00, $00

org $30DFBE : RoomHeader_0069: ; pc 0x185FBE
db $01, $0F, $07, $19, $00, $00, $00, $00, $00, $00, $1A, $1A, $00, $1B

org $30DFCC : RoomHeader_006A: ; pc 0x185FCC
db $01, $0F, $07, $19, $00, $00, $00, $00, $00, $00, $1A, $1A, $00, $1B

org $30DFDA : RoomHeader_006B: ; pc 0x185FDA
db $00, $1B, $0E, $0A, $00, $08, $0B, $00, $00, $00, $0C, $00, $24, $0E

org $30DFE8 : RoomHeader_006C: ; pc 0x185FE8
db $00, $24, $0E, $23, $00, $03, $3F, $00, $00, $00, $A5, $00, $24, $0E

org $30DFF6 : RoomHeader_006D: ; pc 0x185FF6
db $00, $24, $0E, $23, $00, $05, $00, $00, $13, $0B, $1C, $00, $02, $00

org $30E004 : RoomHeader_006E: ; pc 0x186004
db $00, $13, $0B, $1C, $00, $02, $00, $00, $00, $00, $4E, $00, $01, $01

org $30E012 : RoomHeader_006F: ; pc 0x186012
db $00, $01, $01, $04, $00, $00, $00, $08, $00, $00, $71, $80, $C0, $01

org $30E020 : RoomHeader_0070: ; pc 0x186020
db $00, $01, $01, $04, $00, $00, $00, $08, $00, $00, $71, $80, $C0, $01

org $30E02E : RoomHeader_0071: ; pc 0x18602E
db $C0, $01, $01, $04, $00, $08, $00, $00, $00, $00, $70, $C0, $01, $01

org $30E03C : RoomHeader_0072: ; pc 0x18603C
db $C0, $01, $01, $04, $00, $00, $00, $08, $00, $00, $01, $00, $09, $05

org $30E04A : RoomHeader_0073: ; pc 0x18604A
db $00, $09, $05, $0A, $00, $17, $00, $00, $09, $05, $0A, $00, $27, $00

org $30E058 : RoomHeader_0074: ; pc 0x186058
db $00, $09, $05, $0A, $00, $27, $00, $00, $09, $05, $0A, $00, $01, $00

org $30E066 : RoomHeader_0075: ; pc 0x186066
db $00, $09, $05, $0A, $00, $01, $00, $80, $0A, $08, $11, $00, $00, $18

org $30E074 : RoomHeader_0076: ; pc 0x186074
db $80, $0A, $08, $11, $00, $00, $18, $00, $00, $00, $26, $26, $26, $C0

org $30E082 : RoomHeader_0077: ; pc 0x186082
db $C0, $06, $05, $19, $00, $00, $00, $00, $00, $A7, $31, $87, $87, $00

org $30E090 : RoomHeader_0078: ; pc 0x186090
db $00, $28, $0E, $13, $00, $03, $39, $00, $00, $9D, $00, $28, $0E, $13

org $30E09E : RoomHeader_0079: ; pc 0x18609E
db $00, $28, $0E, $13, $00, $03, $39, $00, $00, $9D, $00, $28, $0E, $13

org $30E0AC : RoomHeader_007A: ; pc 0x1860AC
db $00, $28, $0E, $13, $00, $03, $39, $00, $00, $9D, $00, $28, $0E, $13

org $30E0BA : RoomHeader_007B: ; pc 0x1860BA
db $00, $28, $0E, $13, $00, $03, $39, $00, $00, $9D, $00, $28, $0E, $13

org $30E0C8 : RoomHeader_007C: ; pc 0x1860C8
db $00, $28, $0E, $13, $00, $20, $00, $00, $28, $0E, $13, $00, $04, $3C

org $30E0D6 : RoomHeader_007D: ; pc 0x1860D6
db $00, $28, $0E, $13, $00, $04, $3C, $00, $00, $9B, $20, $13, $0B, $1C

org $30E0E4 : RoomHeader_007E: ; pc 0x1860E4
db $20, $13, $0B, $1C, $00, $2B, $17, $00, $00, $9E, $5E, $00, $13, $0B

org $30E0F2 : RoomHeader_007F: ; pc 0x1860F2
db $00, $13, $0B, $1C, $00, $00, $00, $00, $00, $00, $5F, $60, $01, $01

org $30E100 : RoomHeader_0080: ; pc 0x186100
db $60, $01, $01, $04, $00, $00, $00, $00, $00, $00, $70, $C0, $01, $01

org $30E10E : RoomHeader_0081: ; pc 0x18610E
db $C0, $01, $01, $04, $00, $00, $00, $00, $09, $05, $0A, $00, $0D, $00

org $30E11C : RoomHeader_0082: ; pc 0x18611C
db $C0, $01, $01, $04, $00, $00, $00, $00, $09, $05, $0A, $00, $0D, $00

org $30E12A : RoomHeader_0083: ; pc 0x18612A
db $00, $09, $05, $0A, $00, $0D, $00, $00, $09, $05, $0A, $00, $00, $00

org $30E138 : RoomHeader_0084: ; pc 0x186138
db $00, $09, $05, $0A, $00, $00, $00, $00, $09, $05, $0A, $00, $02, $00

org $30E146 : RoomHeader_0085: ; pc 0x186146
db $00, $09, $05, $0A, $00, $02, $00, $00, $06, $05, $19, $00, $3E, $01

org $30E154 : RoomHeader_0086: ; pc 0x186154
db $00, $06, $05, $19, $00, $3E, $01, $28, $00, $00, $77, $77, $00, $0B

org $30E162 : RoomHeader_0087: ; pc 0x186162
db $00, $06, $05, $19, $00, $3E, $01, $28, $00, $00, $77, $77, $00, $0B

org $30E170 : RoomHeader_0088: ; pc 0x186170
db $00, $0B, $05, $08, $00, $00, $00, $02, $00, $A9, $00, $28, $0E, $13

org $30E17E : RoomHeader_0089: ; pc 0x18617E
db $00, $0B, $05, $08, $00, $00, $00, $02, $00, $A9, $00, $28, $0E, $13

org $30E18C : RoomHeader_008A: ; pc 0x18618C
db $00, $28, $0E, $13, $00, $3A, $0C, $20, $28, $0E, $13, $00, $16, $00

org $30E19A : RoomHeader_008B: ; pc 0x18619A
db $00, $28, $0E, $13, $00, $3A, $0C, $20, $28, $0E, $13, $00, $16, $00

org $30E1A8 : RoomHeader_008C: ; pc 0x1861A8
db $20, $28, $0E, $13, $00, $16, $00, $28, $00, $1C, $0C, $0C, $1C, $00

org $30E1B6 : RoomHeader_008D: ; pc 0x1861B6
db $00, $28, $0E, $13, $00, $33, $29, $00, $13, $0B, $1C, $00, $00, $00

org $30E1C4 : RoomHeader_008E: ; pc 0x1861C4
db $00, $13, $0B, $1C, $00, $00, $00, $00, $00, $00, $AE, $80, $12, $0C

org $30E1D2 : RoomHeader_008F: ; pc 0x1861D2
db $80, $12, $0C, $16, $00, $25, $00, $00, $11, $0C, $1C, $00, $00, $00

org $30E1E0 : RoomHeader_0090: ; pc 0x1861E0
db $80, $12, $0C, $16, $00, $25, $00, $00, $11, $0C, $1C, $00, $00, $00

org $30E1EE : RoomHeader_0091: ; pc 0x1861EE
db $00, $11, $0C, $1C, $00, $00, $00, $00, $00, $00, $A0, $01, $11, $0C

org $30E1FC : RoomHeader_0092: ; pc 0x1861FC
db $01, $11, $0C, $1C, $00, $00, $00, $01, $11, $0C, $1C, $00, $16, $00

org $30E20A : RoomHeader_0093: ; pc 0x18620A
db $01, $11, $0C, $1C, $00, $16, $00, $08, $00, $00, $A2, $00, $25, $0E

org $30E218 : RoomHeader_0094: ; pc 0x186218
db $00, $25, $0E, $24, $00, $00, $00, $00, $25, $0E, $24, $00, $33, $00

org $30E226 : RoomHeader_0095: ; pc 0x186226
db $00, $25, $0E, $24, $00, $00, $00, $00, $25, $0E, $24, $00, $33, $00

org $30E234 : RoomHeader_0096: ; pc 0x186234
db $00, $25, $0E, $24, $00, $33, $00, $00, $00, $00, $3D, $68, $11, $0C

org $30E242 : RoomHeader_0097: ; pc 0x186242
db $68, $11, $0C, $1D, $00, $1C, $00, $00, $00, $D1, $D1, $00, $11, $0C

org $30E250 : RoomHeader_0098: ; pc 0x186250
db $00, $11, $0C, $1C, $00, $00, $00, $00, $00, $00, $D2, $01, $0B, $05

org $30E25E : RoomHeader_0099: ; pc 0x18625E
db $01, $0B, $05, $08, $00, $00, $00, $00, $00, $00, $DA, $00, $28, $0E

org $30E26C : RoomHeader_009A: ; pc 0x18626C
db $00, $28, $0E, $13, $00, $00, $00, $00, $00, $7D, $00, $28, $0E, $13

org $30E27A : RoomHeader_009B: ; pc 0x18627A
db $00, $28, $0E, $13, $00, $00, $00, $00, $00, $7D, $00, $28, $0E, $13

org $30E288 : RoomHeader_009C: ; pc 0x186288
db $00, $28, $0E, $13, $06, $00, $00, $00, $28, $0E, $13, $06, $00, $3B

org $30E296 : RoomHeader_009D: ; pc 0x186296
db $00, $28, $0E, $13, $06, $00, $3B, $00, $00, $7B, $20, $13, $0B, $1C

org $30E2A4 : RoomHeader_009E: ; pc 0x1862A4
db $20, $13, $0B, $1C, $00, $00, $00, $00, $00, $BE, $BE, $00, $13, $0B

org $30E2B2 : RoomHeader_009F: ; pc 0x1862B2
db $00, $13, $0B, $1C, $00, $17, $00, $00, $12, $0C, $1D, $00, $00, $00

org $30E2C0 : RoomHeader_00A0: ; pc 0x1862C0
db $00, $12, $0C, $1D, $00, $00, $00, $00, $00, $00, $91, $00, $11, $0C

org $30E2CE : RoomHeader_00A1: ; pc 0x1862CE
db $00, $11, $0C, $1D, $00, $00, $00, $C0, $11, $0C, $1D, $00, $00, $00

org $30E2DC : RoomHeader_00A2: ; pc 0x1862DC
db $C0, $11, $0C, $1D, $00, $00, $00, $00, $00, $00, $93, $60, $19, $0D

org $30E2EA : RoomHeader_00A3: ; pc 0x1862EA
db $00, $11, $0C, $1D, $00, $00, $00, $C0, $11, $0C, $1D, $00, $00, $00

org $30E2F8 : RoomHeader_00A4: ; pc 0x1862F8
db $60, $19, $0D, $17, $04, $25, $00, $00, $25, $0E, $24, $00, $07, $00

org $30E306 : RoomHeader_00A5: ; pc 0x186306
db $00, $25, $0E, $24, $00, $07, $00, $00, $00, $00, $6C, $00, $25, $0E

org $30E314 : RoomHeader_00A6: ; pc 0x186314
db $00, $25, $0E, $24, $00, $00, $00, $00, $00, $00, $4D, $00, $06, $05

org $30E322 : RoomHeader_00A7: ; pc 0x186322
db $00, $06, $05, $19, $00, $00, $00, $00, $00, $17, $C0, $0B, $05, $08

org $30E330 : RoomHeader_00A8: ; pc 0x186330
db $C0, $0B, $05, $08, $00, $03, $00, $C0, $0B, $05, $08, $00, $17, $00

org $30E33E : RoomHeader_00A9: ; pc 0x18633E
db $C0, $0B, $05, $08, $00, $17, $00, $00, $00, $89, $C0, $0B, $05, $08

org $30E34C : RoomHeader_00AA: ; pc 0x18634C
db $C0, $0B, $05, $08, $00, $17, $00, $00, $17, $0A, $1B, $00, $00, $00

org $30E35A : RoomHeader_00AB: ; pc 0x18635A
db $00, $17, $0A, $1B, $00, $00, $00, $00, $00, $00, $64, $E0, $17, $0A

org $30E368 : RoomHeader_00AC: ; pc 0x186368
db $E0, $17, $0A, $20, $00, $25, $00, $00, $13, $0B, $1C, $00, $27, $00

org $30E376 : RoomHeader_00AD: ; pc 0x186376
db $00, $13, $0B, $1C, $00, $27, $00, $00, $00, $00, $8E, $00, $13, $0B

org $30E384 : RoomHeader_00AE: ; pc 0x186384
db $00, $13, $0B, $1C, $00, $27, $00, $00, $00, $00, $8E, $00, $13, $0B

org $30E392 : RoomHeader_00AF: ; pc 0x186392
db $00, $13, $0B, $1C, $00, $00, $00, $00, $26, $02, $21, $00, $05, $02

org $30E3A0 : RoomHeader_00B0: ; pc 0x1863A0
db $00, $26, $02, $21, $00, $05, $02, $08, $00, $00, $40, $C0, $00, $11

org $30E3AE : RoomHeader_00B1: ; pc 0x1863AE
db $00, $11, $0C, $1D, $00, $00, $00, $02, $00, $B2, $C0, $11, $0C, $1D

org $30E3BC : RoomHeader_00B2: ; pc 0x1863BC
db $C0, $11, $0C, $1D, $00, $03, $0E, $C0, $11, $0C, $1D, $00, $27, $00

org $30E3CA : RoomHeader_00B3: ; pc 0x1863CA
db $C0, $11, $0C, $1D, $00, $27, $00, $00, $19, $0D, $17, $00, $00, $00

org $30E3D8 : RoomHeader_00B4: ; pc 0x1863D8
db $00, $19, $0D, $17, $00, $00, $00, $00, $00, $00, $C4, $01, $18, $0D

org $30E3E6 : RoomHeader_00B5: ; pc 0x1863E6
db $01, $18, $0D, $25, $00, $17, $00, $00, $00, $00, $04, $00, $18, $0D

org $30E3F4 : RoomHeader_00B6: ; pc 0x1863F4
db $00, $18, $0D, $1E, $00, $04, $3C, $00, $00, $00, $15, $00, $0B, $05

org $30E402 : RoomHeader_00B7: ; pc 0x186402
db $00, $18, $0D, $1E, $00, $00, $00, $20, $18, $0D, $26, $00, $00, $00

org $30E410 : RoomHeader_00B8: ; pc 0x186410
db $00, $0B, $05, $08, $00, $27, $00, $C0, $0B, $05, $08, $00, $00, $00

org $30E41E : RoomHeader_00B9: ; pc 0x18641E
db $C0, $0B, $05, $08, $00, $00, $00, $01, $0B, $05, $08, $00, $17, $00

org $30E42C : RoomHeader_00BA: ; pc 0x18642C
db $01, $0B, $05, $08, $00, $17, $00, $40, $17, $0A, $1B, $00, $00, $00

org $30E43A : RoomHeader_00BB: ; pc 0x18643A
db $40, $17, $0A, $1B, $00, $00, $00, $00, $17, $0A, $1B, $00, $17, $00

org $30E448 : RoomHeader_00BC: ; pc 0x186448
db $00, $17, $0A, $1B, $00, $17, $00, $00, $00, $00, $45, $00, $13, $0B

org $30E456 : RoomHeader_00BD: ; pc 0x186456
db $00, $13, $0B, $29, $00, $16, $00, $00, $00, $4F, $9E, $00, $13, $0B

org $30E464 : RoomHeader_00BE: ; pc 0x186464
db $00, $13, $0B, $29, $00, $16, $00, $00, $00, $4F, $9E, $00, $13, $0B

org $30E472 : RoomHeader_00BF: ; pc 0x186472
db $00, $13, $0B, $29, $00, $00, $00, $01, $00, $02, $27, $00, $02, $0F

org $30E480 : RoomHeader_00C0: ; pc 0x186480
db $01, $00, $02, $27, $00, $02, $0F, $00, $00, $00, $B0, $D0, $00, $11

org $30E48E : RoomHeader_00C1: ; pc 0x18648E
db $00, $11, $0C, $1D, $00, $33, $00, $C0, $11, $0C, $1D, $00, $27, $00

org $30E49C : RoomHeader_00C2: ; pc 0x18649C
db $C0, $11, $0C, $1D, $00, $27, $00, $C0, $11, $0C, $1D, $00, $00, $00

org $30E4AA : RoomHeader_00C3: ; pc 0x1864AA
db $C0, $11, $0C, $1D, $00, $00, $00, $00, $18, $0D, $25, $00, $00, $00

org $30E4B8 : RoomHeader_00C4: ; pc 0x1864B8
db $00, $18, $0D, $25, $00, $00, $00, $00, $00, $00, $B4, $00, $18, $0D

org $30E4C6 : RoomHeader_00C5: ; pc 0x1864C6
db $00, $18, $0D, $25, $00, $00, $00, $00, $18, $0D, $1E, $00, $33, $00

org $30E4D4 : RoomHeader_00C6: ; pc 0x1864D4
db $00, $18, $0D, $1E, $00, $00, $00, $20, $18, $0D, $26, $00, $00, $00

org $30E4E2 : RoomHeader_00C7: ; pc 0x1864E2
db $00, $18, $0D, $1E, $00, $33, $00, $00, $0B, $05, $09, $00, $15, $25

org $30E4F0 : RoomHeader_00C8: ; pc 0x1864F0
db $00, $0B, $05, $09, $00, $15, $25, $00, $0B, $05, $08, $00, $17, $00

org $30E4FE : RoomHeader_00C9: ; pc 0x1864FE
db $00, $0B, $05, $08, $00, $17, $00, $C0, $17, $0A, $1B, $00, $00, $00

org $30E50C : RoomHeader_00CA: ; pc 0x18650C
db $C0, $17, $0A, $1B, $00, $00, $00, $20, $13, $0B, $29, $00, $14, $00

org $30E51A : RoomHeader_00CB: ; pc 0x18651A
db $C0, $17, $0A, $1B, $00, $00, $00, $20, $13, $0B, $29, $00, $14, $00

org $30E528 : RoomHeader_00CC: ; pc 0x186528
db $C0, $17, $0A, $1B, $00, $00, $00, $20, $13, $0B, $29, $00, $14, $00

org $30E536 : RoomHeader_00CD: ; pc 0x186536
db $20, $13, $0B, $29, $00, $14, $00, $00, $00, $DE, $01, $00, $02, $21

org $30E544 : RoomHeader_00CE: ; pc 0x186544
db $20, $13, $0B, $29, $00, $14, $00, $00, $00, $DE, $01, $00, $02, $21

org $30E552 : RoomHeader_00CF: ; pc 0x186552
db $01, $00, $02, $21, $00, $0F, $00, $00, $00, $00, $C0, $E0, $00, $11

org $30E560 : RoomHeader_00D0: ; pc 0x186560
db $01, $00, $02, $21, $00, $0F, $00, $00, $00, $00, $C0, $E0, $00, $11

org $30E56E : RoomHeader_00D1: ; pc 0x18656E
db $00, $11, $0C, $1D, $00, $00, $00, $00, $00, $B1, $97, $00, $11, $0C

org $30E57C : RoomHeader_00D2: ; pc 0x18657C
db $00, $11, $0C, $1D, $00, $0A, $00, $00, $00, $00, $98, $00, $0B, $05

org $30E58A : RoomHeader_00D3: ; pc 0x18658A
db $00, $0B, $05, $08, $00, $06, $00, $00, $0B, $05, $08, $00, $17, $00

org $30E598 : RoomHeader_00D4: ; pc 0x186598
db $00, $0B, $05, $08, $00, $06, $00, $00, $0B, $05, $08, $00, $17, $00

org $30E5A6 : RoomHeader_00D5: ; pc 0x1865A6
db $00, $18, $0D, $25, $00, $00, $00, $00, $18, $0D, $1E, $00, $33, $00

org $30E5B4 : RoomHeader_00D6: ; pc 0x1865B4
db $00, $18, $0D, $1E, $00, $00, $00, $20, $18, $0D, $26, $00, $00, $00

org $30E5C2 : RoomHeader_00D7: ; pc 0x1865C2
db $00, $0B, $05, $08, $00, $06, $00, $00, $0B, $05, $08, $00, $17, $00

org $30E5D0 : RoomHeader_00D8: ; pc 0x1865D0
db $00, $0B, $05, $08, $00, $06, $00, $00, $0B, $05, $08, $00, $17, $00

org $30E5DE : RoomHeader_00D9: ; pc 0x1865DE
db $00, $0B, $05, $08, $00, $17, $00, $00, $0B, $05, $08, $00, $17, $00

org $30E5EC : RoomHeader_00DA: ; pc 0x1865EC
db $00, $0B, $05, $08, $00, $17, $00, $00, $00, $00, $99, $E0, $14, $0B

org $30E5FA : RoomHeader_00DB: ; pc 0x1865FA
db $C0, $17, $0A, $1B, $00, $00, $00, $20, $13, $0B, $29, $00, $14, $00

org $30E608 : RoomHeader_00DC: ; pc 0x186608
db $C0, $17, $0A, $1B, $00, $00, $00, $20, $13, $0B, $29, $00, $14, $00

org $30E616 : RoomHeader_00DD: ; pc 0x186616
db $E0, $14, $0B, $16, $00, $25, $00, $C0, $20, $06, $13, $00, $00, $00

org $30E624 : RoomHeader_00DE: ; pc 0x186624
db $E0, $14, $0B, $16, $00, $25, $00, $C0, $20, $06, $13, $00, $00, $00

org $30E632 : RoomHeader_00DF: ; pc 0x186632
db $C0, $20, $06, $13, $00, $00, $00, $00, $00, $00, $EF, $00, $26, $02

org $30E640 : RoomHeader_00E0: ; pc 0x186640
db $00, $26, $02, $21, $00, $01, $2A, $00, $00, $00, $D0, $C0, $07, $06

org $30E64E : RoomHeader_00E1: ; pc 0x18664E
db $C0, $07, $06, $28, $00, $00, $00, $00, $20, $06, $13, $00, $00, $00

org $30E65C : RoomHeader_00E2: ; pc 0x18665C
db $00, $20, $06, $13, $00, $00, $00, $C0, $20, $06, $09, $00, $00, $00

org $30E66A : RoomHeader_00E3: ; pc 0x18666A
db $C0, $20, $06, $09, $00, $00, $00, $01, $07, $14, $01, $00, $00, $00

org $30E678 : RoomHeader_00E4: ; pc 0x186678
db $01, $07, $14, $01, $00, $00, $00, $01, $07, $06, $01, $00, $00, $00

org $30E686 : RoomHeader_00E5: ; pc 0x186686
db $01, $07, $14, $01, $00, $00, $00, $01, $07, $06, $01, $00, $00, $00

org $30E694 : RoomHeader_00E6: ; pc 0x186694
db $01, $07, $06, $01, $00, $00, $00, $20, $07, $06, $13, $00, $00, $00

org $30E6A2 : RoomHeader_00E7: ; pc 0x1866A2
db $01, $07, $06, $01, $00, $00, $00, $20, $07, $06, $13, $00, $00, $00

org $30E6B0 : RoomHeader_00E8: ; pc 0x1866B0
db $20, $07, $06, $13, $00, $00, $00, $00, $00, $F8, $F8, $F8, $F8, $F8

org $30E6BE : RoomHeader_00E9: ; pc 0x1866BE
db $20, $20, $06, $13, $00, $00, $00, $00, $00, $FA, $FA, $20, $07, $06

org $30E6CC : RoomHeader_00EA: ; pc 0x1866CC
db $20, $20, $06, $13, $00, $00, $00, $00, $00, $FA, $FA, $20, $07, $06

org $30E6DA : RoomHeader_00EB: ; pc 0x1866DA
db $20, $07, $06, $19, $00, $00, $00, $00, $00, $FB, $FB, $20, $20, $06

org $30E6E8 : RoomHeader_00EC: ; pc 0x1866E8
db $20, $20, $06, $13, $00, $00, $00, $00, $00, $FD, $FD, $FD, $20, $20

org $30E6F6 : RoomHeader_00ED: ; pc 0x1866F6
db $20, $20, $06, $13, $00, $00, $00, $00, $00, $FD, $FD, $FD, $20, $20

org $30E704 : RoomHeader_00EE: ; pc 0x186704
db $20, $20, $06, $13, $00, $00, $00, $00, $00, $FE, $20, $20, $06, $13

org $30E712 : RoomHeader_00EF: ; pc 0x186712
db $20, $20, $06, $13, $00, $02, $00, $08, $00, $FF, $DF, $FF, $00, $02

org $30E720 : RoomHeader_00F0: ; pc 0x186720
db $01, $07, $06, $01, $00, $00, $00, $20, $07, $06, $13, $00, $00, $00

org $30E72E : RoomHeader_00F1: ; pc 0x18672E
db $01, $07, $06, $01, $00, $00, $00, $20, $07, $06, $13, $00, $00, $00

org $30E73C : RoomHeader_00F2: ; pc 0x18673C
db $00, $02, $03, $05, $00, $00, $02, $03, $0F, $00, $00, $00, $00, $07

org $30E74A : RoomHeader_00F3: ; pc 0x18674A
db $00, $02, $03, $05, $00, $00, $02, $03, $0F, $00, $00, $00, $00, $07

org $30E758 : RoomHeader_00F4: ; pc 0x186758
db $00, $02, $03, $0F, $00, $00, $00, $00, $07, $06, $13, $00, $00, $00

org $30E766 : RoomHeader_00F5: ; pc 0x186766
db $00, $02, $03, $0F, $00, $00, $00, $00, $07, $06, $13, $00, $00, $00

org $30E774 : RoomHeader_00F6: ; pc 0x186774
db $00, $07, $06, $13, $00, $00, $00, $00, $00, $00, $E8, $E8, $E8, $E8

org $30E782 : RoomHeader_00F7: ; pc 0x186782
db $00, $07, $06, $13, $00, $00, $00, $00, $00, $00, $E8, $E8, $E8, $E8

org $30E790 : RoomHeader_00F8: ; pc 0x186790
db $00, $07, $06, $13, $00, $00, $00, $00, $00, $00, $E8, $E8, $E8, $E8

org $30E79E : RoomHeader_00F9: ; pc 0x18679E
db $00, $20, $06, $13, $00, $00, $00, $C0, $20, $06, $13, $00, $00, $00

org $30E7AC : RoomHeader_00FA: ; pc 0x1867AC
db $C0, $20, $06, $13, $00, $00, $00, $00, $00, $00, $EA, $00, $07, $06

org $30E7BA : RoomHeader_00FB: ; pc 0x1867BA
db $00, $07, $06, $19, $00, $00, $00, $00, $00, $00, $EB, $00, $20, $06

org $30E7C8 : RoomHeader_00FC: ; pc 0x1867C8
db $00, $20, $06, $13, $00, $00, $00, $00, $00, $00, $ED, $ED, $00, $07

org $30E7D6 : RoomHeader_00FD: ; pc 0x1867D6
db $00, $20, $06, $13, $00, $00, $00, $00, $00, $00, $ED, $ED, $00, $07

org $30E7E4 : RoomHeader_00FE: ; pc 0x1867E4
db $00, $20, $06, $13, $00, $00, $00, $C0, $20, $06, $13, $00, $00, $00

org $30E7F2 : RoomHeader_00FF: ; pc 0x1867F2
db $00, $07, $06, $05, $00, $00, $00, $00, $00, $00, $EF, $00, $05, $03

org $30E800 : RoomHeader_0100: ; pc 0x186800
db $00, $05, $03, $28, $00, $00, $00, $00, $1F, $03, $05, $00, $00, $00

org $30E80E : RoomHeader_0101: ; pc 0x18680E
db $00, $02, $03, $0F, $00, $00, $00, $00, $15, $03, $0D, $00, $00, $00

org $30E81C : RoomHeader_0102: ; pc 0x18681C
db $00, $15, $03, $0D, $00, $00, $00, $00, $05, $03, $0F, $00, $00, $00

org $30E82A : RoomHeader_0103: ; pc 0x18682A
db $00, $05, $03, $0F, $00, $00, $00, $01, $15, $03, $0D, $00, $00, $00

org $30E838 : RoomHeader_0104: ; pc 0x186838
db $01, $15, $03, $0D, $00, $00, $00, $00, $1C, $0F, $10, $00, $00, $00

org $30E846 : RoomHeader_0105: ; pc 0x186846
db $00, $1C, $0F, $10, $00, $00, $00, $00, $1F, $03, $0F, $00, $00, $00

org $30E854 : RoomHeader_0106: ; pc 0x186854
db $00, $1F, $03, $0F, $00, $00, $00, $00, $02, $03, $01, $00, $00, $00

org $30E862 : RoomHeader_0107: ; pc 0x186862
db $00, $02, $03, $01, $00, $00, $00, $00, $02, $03, $0E, $00, $00, $00

org $30E870 : RoomHeader_0108: ; pc 0x186870
db $00, $02, $03, $0E, $00, $00, $00, $01, $05, $03, $05, $00, $00, $00

org $30E87E : RoomHeader_0109: ; pc 0x18687E
db $01, $05, $03, $05, $00, $00, $00, $01, $07, $06, $10, $00, $00, $00

org $30E88C : RoomHeader_010A: ; pc 0x18688C
db $01, $07, $06, $10, $00, $00, $00, $80, $0A, $08, $08, $00, $00, $1A

org $30E89A : RoomHeader_010B: ; pc 0x18689A
db $80, $0A, $08, $08, $00, $00, $1A, $00, $27, $06, $08, $00, $03, $00

org $30E8A8 : RoomHeader_010C: ; pc 0x1868A8
db $00, $27, $06, $08, $00, $03, $00, $00, $0A, $08, $11, $00, $00, $00

org $30E8B6 : RoomHeader_010D: ; pc 0x1868B6
db $00, $0A, $08, $11, $00, $00, $00, $00, $07, $14, $05, $00, $00, $00

org $30E8C4 : RoomHeader_010E: ; pc 0x1868C4
db $00, $07, $14, $05, $00, $00, $00, $00, $1E, $11, $05, $00, $00, $00

org $30E8D2 : RoomHeader_010F: ; pc 0x1868D2
db $00, $1F, $03, $05, $00, $00, $00, $00, $02, $03, $0F, $00, $00, $00

org $30E8E0 : RoomHeader_0110: ; pc 0x1868E0
db $00, $1F, $03, $05, $00, $00, $00, $00, $02, $03, $0F, $00, $00, $00

org $30E8EE : RoomHeader_0111: ; pc 0x1868EE
db $00, $1E, $11, $05, $00, $00, $00, $00, $07, $14, $05, $00, $00, $00

org $30E8FC : RoomHeader_0112: ; pc 0x1868FC
db $00, $07, $14, $05, $00, $00, $00, $00, $03, $10, $08, $00, $00, $00

org $30E90A : RoomHeader_0113: ; pc 0x18690A
db $00, $03, $10, $08, $00, $00, $00, $00, $07, $06, $07, $00, $00, $00

org $30E918 : RoomHeader_0114: ; pc 0x186918
db $00, $07, $06, $07, $00, $00, $00, $00, $22, $12, $07, $00, $00, $00

org $30E926 : RoomHeader_0115: ; pc 0x186926
db $00, $07, $06, $07, $00, $00, $00, $00, $22, $12, $07, $00, $00, $00

org $30E934 : RoomHeader_0116: ; pc 0x186934
db $00, $22, $12, $07, $00, $00, $00, $00, $20, $14, $05, $00, $00, $00

org $30E942 : RoomHeader_0117: ; pc 0x186942
db $00, $20, $14, $05, $00, $00, $00, $E0, $23, $0A, $0F, $00, $00, $00

org $30E950 : RoomHeader_0118: ; pc 0x186950
db $00, $05, $03, $0F, $00, $00, $00, $01, $15, $03, $0D, $00, $00, $00

org $30E95E : RoomHeader_0119: ; pc 0x18695E
db $E0, $23, $0A, $0F, $00, $00, $00, $00, $00, $00, $1D, $00, $1C, $0F

org $30E96C : RoomHeader_011A: ; pc 0x18696C
db $00, $1C, $0F, $05, $00, $00, $00, $C0, $07, $06, $08, $00, $00, $00

org $30E97A : RoomHeader_011B: ; pc 0x18697A
db $C0, $07, $06, $08, $00, $00, $00, $00, $23, $0A, $0F, $00, $00, $00

org $30E988 : RoomHeader_011C: ; pc 0x186988
db $00, $1F, $03, $05, $00, $00, $00, $00, $02, $03, $0F, $00, $00, $00

org $30E996 : RoomHeader_011D: ; pc 0x186996
db $00, $23, $0A, $0F, $00, $00, $00, $00, $00, $00, $19, $00, $20, $06

org $30E9A4 : RoomHeader_011E: ; pc 0x1869A4
db $00, $20, $06, $2A, $00, $00, $00, $00, $05, $03, $05, $00, $00, $00

org $30E9B2 : RoomHeader_011F: ; pc 0x1869B2
db $00, $05, $03, $05, $00, $00, $00, $00, $13, $06, $13, $00, $00, $00

org $30E9C0 : RoomHeader_0120: ; pc 0x1869C0
db $00, $13, $06, $13, $00, $00, $00, $00, $07, $06, $28, $00, $03, $00

org $30E9CE : RoomHeader_0121: ; pc 0x1869CE
db $00, $1E, $11, $05, $00, $00, $00, $00, $07, $14, $05, $00, $00, $00

org $30E9DC : RoomHeader_0122: ; pc 0x1869DC
db $00, $1E, $11, $05, $00, $00, $00, $00, $07, $14, $05, $00, $00, $00

org $30E9EA : RoomHeader_0123: ; pc 0x1869EA
db $00, $07, $06, $28, $00, $03, $00, $00, $07, $06, $28, $00, $00, $00

org $30E9F8 : RoomHeader_0124: ; pc 0x1869F8
db $00, $07, $06, $28, $00, $00, $00, $FF, $FF, $FF, $FF, $FF, $FF, $FF

org $30EA06 : RoomHeader_0125: ; pc 0x186A06
db $00, $07, $06, $28, $00, $00, $00, $FF, $FF, $FF, $FF, $FF, $FF, $FF

org $30EA14 : RoomHeader_0126: ; pc 0x186A14
db $00, $07, $06, $28, $00, $00, $00, $FF, $FF, $FF, $FF, $FF, $FF, $FF

org $30EA22 : RoomHeader_0127: ; pc 0x186A22
db $00, $20, $06, $2A, $00, $00, $00, $00, $05, $03, $05, $00, $00, $00

org $30EA30 : RoomHeader_0128: ; pc 0x186A30
db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF

org $30EA3E : RoomHeader_0129: ; pc 0x186A3E
db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF

org $30EA4C : RoomHeader_012A: ; pc 0x186A4C
db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF

org $30EA5A : RoomHeader_012B: ; pc 0x186A5A
db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF

org $30EA68 : RoomHeader_012C: ; pc 0x186A68
db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF

org $30EA76 : RoomHeader_012D: ; pc 0x186A76
db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF

org $30EA84 : RoomHeader_012E: ; pc 0x186A84
db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF

;--------------------------------------------------------------------------------
; Outlet IDs - 0x186B00
;--------------------------------------------------------------------------------
org $30EB00
RoomToOutlet:
db $FF, $FF, $FF, $3D, $FF, $FF, $FF, $FF ; 0x000-0x007
db $39, $FF, $FF, $FF, $38, $FF, $2E, $FF ; 0x008-0x00F
db $37, $FF, $01, $FF, $FF, $FF, $FF, $FF ; 0x010-0x017
db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; 0x018-0x01F
db $06, $FF, $FF, $16, $1A, $FF, $FF, $FF ; 0x020-0x027
db $26, $FF, $FF, $FF, $3C, $FF, $FF, $3A ; 0x028-0x02F
db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; 0x030-0x037
db $FF, $FF, $FF, $FF, $3B, $FF, $FF, $FF ; 0x038-0x03F
db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; 0x040-0x047
db $FF, $FF, $27, $FF, $FF, $FF, $FF, $FF ; 0x048-0x04F
db $FF, $FF, $FF, $FF, $FF, $33, $29, $2A ; 0x050-0x057
db $2B, $2C, $FF, $FF, $FF, $FF, $FF, $FF ; 0x058-0x05F
db $02, $03, $04, $0D, $FF, $FF, $FF, $FF ; 0x060-0x067
db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; 0x068-0x06F
db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $2D ; 0x070-0x077
db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; 0x078-0x07F
db $FF, $FF, $FF, $0C, $0A, $0B, $FF, $FF ; 0x080-0x087
db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; 0x088-0x08F
db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; 0x090-0x097
db $28, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; 0x098-0x09F
db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; 0x0A0-0x0A7
db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; 0x0A8-0x0AF
db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; 0x0B0-0x0B7
db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; 0x0B8-0x0BF
db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; 0x0C0-0x0C7
db $FF, $09, $FF, $FF, $FF, $FF, $FF, $FF ; 0x0C8-0x0CF
db $FF, $FF, $FF, $FF, $FF, $19, $34, $FF ; 0x0D0-0x0D7
db $FF, $FF, $FF, $35, $FF, $FF, $FF, $21 ; 0x0D8-0x0DF
db $25, $36, $13, $12, $31, $32, $2F, $30 ; 0x0E0-0x0E7
db $15, $FF, $24, $18, $FF, $1C, $1E, $20 ; 0x0E8-0x0EF
db $07, $08, $0E, $0F, $10, $11, $FF, $FF ; 0x0F0-0x0F7
db $14, $22, $23, $17, $FF, $1B, $1D, $1F ; 0x0F8-0x0FF
db $FF, $FF, $FF, $FF, $00, $FF, $FF, $FF ; 0x100-0x107
db $91, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; 0x108-0x10F
db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; 0x110-0x117
db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; 0x118-0x11F
db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; 0x120-0x127
db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; 0x128-0x12F
db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; 0x130-0x137
db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; 0x138-0x13F
db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; 0x140-0x147
db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; 0x148-0x14F
db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; 0x150-0x157
db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; 0x158-0x15F
db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; 0x160-0x167
db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; 0x168-0x16F
db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; 0x170-0x177
db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; 0x178-0x17F
db $4B, $4C, $4D, $FF, $FF, $FF, $FF, $FF ; 0x180-0x187
db $FF, $4E, $FF, $FF, $FF, $FF, $FF, $FF ; 0x188-0x18F
db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; 0x190-0x197
db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; 0x198-0x19F


;--------------------------------------------------------------------------------
; Exit data table pointers - 0x186CA0
;--------------------------------------------------------------------------------
org $30ECA0
dl NewOutletData_overworld_id
dl NewOutletData_exit_vram_addr
dl NewOutletData_vertical_scroll
dl NewOutletData_horizontal_scroll
dl NewOutletData_y_coordinate
dl NewOutletData_x_coordinate
dl NewOutletData_camera_trigger_y
dl NewOutletData_camera_trigger_x
dl NewOutletData_scroll_mod_y
dl NewOutletData_scroll_mod_x
dl NewOutletData_door_graphic
dl NewOutletData_door_graphic_location


;--------------------------------------------------------------------------------
; 0x186D00 - 186FFE (unused)
;--------------------------------------------------------------------------------
org $30EFFF ; PC 0x186FFF
BallNChainDungeon:
db $02

org $30F000 ; PC 0x187000-0x18700F
CompassTotalsROM:
db $08, $08, $06, $06, $02, $0A, $0E, $08, $08, $08, $06, $08, $0C, $1B, $00, $00

;--------------------------------------------------------------------------------
; 0x187010 - 187FFF (unused)
;--------------------------------------------------------------------------------

















