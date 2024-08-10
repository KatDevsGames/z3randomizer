;================================================================================
; Item Tables
;--------------------------------------------------------------------------------
org $B08000 ; bank #$30 ; PC 0x180000 - 0x180006 [encrypted]
HeartPieceIndoorValues:
HeartPiece_Forest_Thieves:
	db $17 ; #$17 = Heart Piece
HeartPiece_Lumberjack_Tree:
	db $17
HeartPiece_Spectacle_Cave:
	db $17
HeartPiece_Circle_Bushes:
	db $17
HeartPiece_Graveyard_Warp:
	db $17
HeartPiece_Mire_Warp:
	db $17
HeartPiece_Smith_Pegs:
	db $17
;--------------------------------------------------------------------------------
; 0x180006 - 0x18000F (unused) [encrypted]
;--------------------------------------------------------------------------------
org $B08010 ; PC 0x180010 - 0x180017 [encrypted]
SpriteItemValues:
RupeeNPC_MoldormCave:
	db $46 ; #$46 = 300 Rupees
RupeeNPC_NortheastDarkSwampCave:
	db $46 ; #$46 = 300 Rupees
LibraryItem:
	db $1D ; #$1D = Book of Mudora
MushroomItem:
	db $29 ; #$29 = Mushroom
WitchItem:
	db $0D ; #$0D = Magic Powder
MagicBatItem:
	db $4E ; #$4E = Half Magic Item (Default) - #$FF = Use Original Logic - See "HalfMagic" Below
EtherItem:
	db $10 ; #$10 = Ether Medallion
BombosItem:
	db $0F ; #$0F = Bombos Medallion
;--------------------------------------------------------------------------------
; 0x180017 - 0x18001F (unused) [encrypted]
;--------------------------------------------------------------------------------
org $B08020 ; PC 0x180020
DiggingGameRNG:
	db $0F ; #$0F = 15 digs (default) (max ~30)
org $9DFD95 ; PC 0xEFD95
	db $0F ; #$0F = 15 digs (default) (max ~30)
org $B08021 ; PC 0x180021
ChestGameRNG:
db $00 ; #$00 = 2nd chest (default) - #$01 = 1st chest
;--------------------------------------------------------------------------------
;0 = Bombos
;1 = Ether
;2 = Quake
org $B08022 ; PC 0x180022
MireRequiredMedallion:
db $01 ; #$01 = Ether (default)

org $B08023 ; PC 0x180023
TRockRequiredMedallion:
db $02 ; #$02 = Quake (default)
;--------------------------------------------------------------------------------
org $B08024 ; PC 0x180024 - 0x180027
BigFairyHealth:
db $A0 ; #$A0 = Refill Health (default) - #$00 = Don't Refill Health
BigFairyMagic:
db $00 ; #$80 = Refill Magic - #$00 = Don't Refill Magic (default)
SpawnNPCHealth:
db $A0 ; #$A0 = Refill Health (default) - #$00 = Don't Refill Health
SpawnNPCMagic:
db $00 ; #$80 = Refill Magic - #$00 = Don't Refill Magic (default)
;--------------------------------------------------------------------------------
org $B08028 ; PC 0x180028
FairySword:
db $03 ; #$03 = Golden Sword (default)

PedestalMusicCheck:
;org $88C435 ; <- 44435 - ancilla_receive_item.asm : 125
;db $01 ; #$01 = Master Sword (default)
org $8589B0 ; PC 0x289B0 ; sprite_master_sword.asm : 179
PedestalSword:
db $01 ; #$01 = Master Sword (default)

org $B08029 ; PC 0x180029 - 0x18002A
SmithItemMode:
db $01 ; #$00 = Classic Tempering Process - #$01 = Quick Item Get (default)
SmithItem:
db $02 ; #$02 = Tempered Sword (default)
org $86B55C ; PC 0x3355C ; sprite_smithy_bros.asm : 634
SmithSword:
db $02 ; #$02 = Tempered Sword (default)

;--------------------------------------------------------------------------------
; 0x18002B- 0x180030 (Unused)
;--------------------------------------------------------------------------------
org $B08031 ; PC 0x180031
EnableEasterEggs:
db $00 ; #$00 = Off (default) - #$01 = On
;--------------------------------------------------------------------------------
; 0x180032 (unused)
;--------------------------------------------------------------------------------
org $B08033 ; PC 0x180033
HeartBeep:
db $20 ; #$00 = Off - #$20 = Normal (default) - #$40 = Half Speed - #$80 = Quarter Speed
;--------------------------------------------------------------------------------
; 0x180034 - 0x180035 (Unused)
;--------------------------------------------------------------------------------
org $B08036 ; PC 0x180036 - 0x180037
RupoorDeduction:
dw $000A ; #$0A - Default (10 decimal)
;--------------------------------------------------------------------------------
org $B08038 ; PC 0x180038
LampConeSewers:
db $01 ; #$00 = Off - #$01 = On (default)
;--------------------------------------------------------------------------------
org $308039 ; PC 0x180039
ItemCounterHUD:
db $00 ; $00 = Off | $01 = Display TotalItemCounter / TotalItemCount display on HUD
;--------------------------------------------------------------------------------
org $B0803A ; PC 0x18003A-0x18003C
MapHUDMode:
db #$00 ; #$00 = Off (default) - #$01 = Display Dungeon Count w/Map - #$02 = Display Dungeon Count Always
MapMode:
db $00 ; #$00 = Always On (default) - #$01 = Require Map Item
CompassMode:
db $00 ; #$00 = Off (default) - #$01 = Display Dungeon Count w/Compass - #$02 = Display Dungeon Count Always
       ; #$80 = Move prizes to custom postion - #$40 = Compasses are shuffled and must be obtained to show position if bit on
;--------------------------------------------------------------------------------
org $B0803D ; PC 0x18003D
PersistentFloodgate:
db $00 ; #$00 = Off (default) - #$01 = On
;--------------------------------------------------------------------------------
org $B0803E ; PC 0x18003E (unused)
;--------------------------------------------------------------------------------
org $B0803F ; PC 0x18003F
HammerableGanon:
db $00 ; #$00 = Off (default) - #$01 = On
;--------------------------------------------------------------------------------
; 0x180040 - (unused)
;--------------------------------------------------------------------------------
org $B08041 ; PC 0x180041
AllowSwordlessMedallionUse:
db $00 ; #$00 = Off (default) - #$01 = Medallion Pads - #$02 = Always
;--------------------------------------------------------------------------------
org $B08042 ; PC 0x180042
PermitSQFromBosses:
db $00 ; #$00 = Off (default) - #$01 = On
;--------------------------------------------------------------------------------
; 0x180043 (unused)
;--------------------------------------------------------------------------------
org $B08044 ; PC 0x180044
AllowHammerTablets:
db $00 ; #$00 = Off (default) - #$01 = On
;--------------------------------------------------------------------------------
org $B0805D ; PC 0x18005D
AllowHammerEvilBarrierWithFighterSword:
db $00 ; #$00 = Off (default) - #$01 = On
;--------------------------------------------------------------------------------
org $B08045 ; PC 0x180045
; display ---edcba a: Small Keys, b: Big Key, c: Map, d: Compass, e: Bosses
HUDDungeonItems:
db $00
;--------------------------------------------------------------------------------
; 0x180046 (unused)
;--------------------------------------------------------------------------------
org $B08048 ; PC 0x180048
MenuSpeed:
db $08 ; #$08 (default) - higher is faster - #$E8 = instant open
org $8DDD9A ; PC 0x6DD9A (equipment.asm:95) ; Menu Down Chime
db $11 ; #$11 = Vwoop Down (Default) - #$20 = Menu Chime
org $8DDF2A ; PC 0x6DF2A (equipment.asm:466) ; Menu Up Chime
db $12 ; #$12 = Vwoop Up (Default) - #$20 = Menu Chime
org $8DE0E9 ; PC 0x6E0E9 (equipment.asm:780) ; Menu Up Chime
db $12 ; #$12 = Vwoop Up (Default) - #$20 = Menu Chime
;--------------------------------------------------------------------------------
org $B08049 ; PC 0x180049
MenuCollapse:
db $00 ; #$00 = Press Start (default) - #$10 = Release Start
;--------------------------------------------------------------------------------
org $B0804A ; PC 0x18004A
InvertedMode:
db $00 ; #$00 = Normal (default) - #$01 = Inverted
;--------------------------------------------------------------------------------
org $B0804B ; PC 0x18004B
QuickSwapFlag:
db $00 ; #$00 = Off (default) - #$01 = On
;--------------------------------------------------------------------------------
org $B0804C ; PC 0x18004C
SmithTravelsFreely:
db $00 ; #$00 = Off (default) - #$01 = On (frog/smith can enter multi-entrance doors)
;--------------------------------------------------------------------------------
org $B0804D ; PC 0x18004D
EscapeAssist: ; ScrubMode:
db $00
;---- -mba
;m - Infinite Magic
;b - Infinite Bombs
;a - Infinite Arrows
;--------------------------------------------------------------------------------
org $B0804E ; PC 0x18004E
UncleRefill:
db $00
;---- -mba
;m - Refill Magic
;b - Refill Bombs
;a - Refill Arrows
;--------------------------------------------------------------------------------
org $B0804F ; PC 0x18004F
ByrnaInvulnerability:
db $01 ; #$00 = Off - #$01 = On (default)
;--------------------------------------------------------------------------------
org $B08050 ; PC 0x180050 - 0x18005C
CrystalPendantFlags_2:
    db $02 ; Ganons Tower - because 5D is not available right now - sewers doesn't get one
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
;No Icon: $80
;Aga1:    $01
;Aga2:    $02
;--------------------------------------------------------------------------------
org $B0805E ; PC 0x18005E - 0x18005F (Unused)
;--------------------------------------------------------------------------------
org $B08060 ; PC 0x180060 - 0x18007E
ProgrammableItemLogicJump_1:
JSL.l $000000 : RTL
ProgrammableItemLogicJump_2:
JSL.l $000000 : RTL
ProgrammableItemLogicJump_3:
JSL.l $000000 : RTL

org $B08061 ; PC 0x180061
ProgrammableItemLogicPointer_1:
dl $000000
org $B08066 ; PC 0x180066
ProgrammableItemLogicPointer_2:
dl $000000
org $B0806B ; PC 0x18006B
ProgrammableItemLogicPointer_3:
dl $000000
;--------------------------------------------------------------------------------
; 0x18007F (unused)
;--------------------------------------------------------------------------------
org $B08070 ; PC 0x180070 - 0x18007F
CrystalNumberTable:
db $69 ; Eastern
db $69 ; Hera
db $69 ; Desert
db $7F ; Darkness
db $6C ; Skull
db $7C ; TRock
db $6D ; Thieves
db $6F ; Mire
db $6E ; Ice
db $79 ; Swamp
db $00 ;
db $00 ;
db $00 ;
db $00 ;
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
org $B08080 ; PC 0x180080 - 0x180083 ; Default to fill on upgrade. Can be set to 0 to not fill.
Upgrade5BombsRefill:
db $32
Upgrade10BombsRefill:
db $32
Upgrade5ArrowsRefill:
db $46
Upgrade10ArrowsRefill:
db $46
;--------------------------------------------------------------------------------
org $B08084 ; PC 0x180084 - 0x180085
PotionHealthRefill:
db $A0 ; #$A0 - Full Refill (Default)
PotionMagicRefill:
db $80 ; #$80 - Full Refill (Default)
;--------------------------------------------------------------------------------
org $B08086 ; PC 0x180086
GanonAgahRNG:
db $00 ; $00 = static rng, $01 = no extra blue balls/warps
;--------------------------------------------------------------------------------
org $B08087 ; PC 0x180087
IsEncrypted:
dw $0000 ; $0000 = not encrypted, $0001 = encrypted with static key, $0002 = Encrypted w/ passcode entry screen
;--------------------------------------------------------------------------------
org $B08089 ; PC 0x180089
TurtleRockAutoOpenFix:
db $00 ; #$00 - Normal, #$01 - Open TR Entrance if exiting from it
;--------------------------------------------------------------------------------
org $B0808A ; PC 0x18008A
BlockCastleDoorsInRain:
db $00 ; #$00 - Normal, $01 - Block them (Used by Entrance Rando in Standard Mode)
;--------------------------------------------------------------------------------
; 0x18008B-0x18008D (unused)
;--------------------------------------------------------------------------------
org $B0808E ; PC 0x18008E
FakeBoots:
db $00 ; #$00 = Off (default) - #$01 = On
;--------------------------------------------------------------------------------
; 0x18008F (unused)
;--------------------------------------------------------------------------------
org $B08090 ; PC 0x180090 - 0x180097
ProgressiveSwordLimit:
db $04 ; #$04 - 4 Swords (default)
ProgressiveSwordReplacement:
db $47 ; #$47 - 20 Rupees (default)
ProgressiveShieldLimit:
db $03 ; #$03 - 3 Shields (default)
ProgressiveShieldReplacement:
db $47 ; #$47 - 20 Rupees (default)
ProgressiveArmorLimit:
db $02 ; #$02 - 2 Armors (default)
ProgressiveArmorReplacement:
db $47 ; #$47 - 20 Rupees (default)
BottleLimit:
db $04 ; #$04 - 4 Bottles (default)
BottleLimitReplacement:
db $47 ; #$47 - 20 Rupees (default)
ProgressiveBowLimit:
db $02 ; #$02 - 2 Bows (default)
ProgressiveBowReplacement:
db $47 ; #$47 - 20 Rupees (default)
;--------------------------------------------------------------------------------
; 0x18009A - 0x18009C one mind
;--------------------------------------------------------------------------------
org $B0809A ; PC 0x18009A
OneMindPlayerCount:
db 0
org $B0809B ;  PC 0x18009B - 0x18009C
OneMindTimerInit:
dw 0
;--------------------------------------------------------------------------------
; 0x18009D - Dungeon map icons
; .... ...b
;
;  b - boss icon
;--------------------------------------------------------------------------------
org $B0809D
DungeonMapIcons:
db $01
;--------------------------------------------------------------------------------
; 0x18009E - 0x18009F (unused)
;--------------------------------------------------------------------------------
org $B080A0 ; PC 0x1800A0 - 0x1800A4
Bugfix_MirrorlessSQToLW:
db $01 ; #$00 = Original Behavior - #$01 = Randomizer Behavior (Default)
Bugfix_SwampWaterLevel:
db $01 ; #$00 = Original Behavior - #$01 = Randomizer Behavior (Default)
Bugfix_PreAgaDWDungeonDeathToFakeDW:
db $01 ; #$00 = Original Behavior - #$01 = Randomizer Behavior (Default)
Bugfix_SetWorldOnAgahnimDeath:
db $01 ; #$00 = Original Behavior - #$01 = Randomizer Behavior (Default)
Bugfix_PodEG:
db $01 ; #$00 = Original Behavior - #$01 = Randomizer Behavior (Default)
;--------------------------------------------------------------------------------
; 0x1800A5 - 0x1800AF (unused)
;--------------------------------------------------------------------------------
org $B080B0 ; 0x1800B0-0x1800BF
StaticDecryptionKey:
dd $00000000, $00000000, $00000000, $00000000
;--------------------------------------------------------------------------------
org $B080C0 ; 0x1800C0-0x1800C7 [encrypted]
KnownEncryptedValue:
db $31, $41, $59, $26, $53, $58, $97, $93
;--------------------------------------------------------------------------------
; 0x1800C8 - 0x1800FF (unused)
;--------------------------------------------------------------------------------
org $B08100 ; PC 0x180100 (0x40 bytes)
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
org $898B7C ; PC 0x48B7C
EtherTablet:
	db $10 ; #$10 = Ether
org $88CAA9 ; PC 0x44AA9
	db $10 ; #$10 = Ether

org $898B81 ; PC 0x48B81
BombosTablet:
	db $0F ; #$0F = Bombos
org $88CAAE ; PC 0x44AAE
	db $0F ; #$0F = Bombos
;--------------------------------------------------------------------------------
org $85FBD2 ; PC 0x2FBD2 - sprite_mad_batter.asm:209 - (#$01)
HalfMagic:
db $01 ; #$01 = 1/2 Magic (default) - #$02 = 1/4 Magic
;--------------------------------------------------------------------------------
org $87ADA7 ; PC 0x3ADA7 - Bank07.asm:7216 - (db 4, 8, 8)
CapeMagicUse:
db $04, $08, $10 ; change to db $04, $08, $08 for original cape behavior
org $88DC42 ; PC 0x45C42 - ancilla_cane_spark.asm:200 - (db 4, 2, 1)
ByrnaMagicUsage:
db $04, #$02, #$01 ; normal, 1/2, 1/4 magic
;--------------------------------------------------------------------------------
;Dungeon Music
;org $82D592 ; PC 0x15592
;11 - Pendant Dungeon
;16 - Crystal Dungeon

org $82D592+$03
Music_Castle:
db $10,$10,$10
org $82D592+$24
Music_AgaTower:
db $10
org $82D592+$81
Music_Sewer:
db $10

org $82D592+$08
Music_Eastern:
db $11

org $82D592+$09
Music_Desert:
db $11, $11, $11, $11

org $82D592+$33
Music_Hera:
db $11
org $82907A ; 0x1107A - Bank02.asm:3089 (#$11)
Music_Hera2:
db $11
org $828B8C ; 0x10B8C - Bank02.asm:2231 (#$11)
Music_Hera3:
db $11

org $82D592+$26
Music_Darkness:
db $16

org $82D592+$25
Music_Swamp:
db $16

org $82D592+$28
Music_Skull:
db $16, $16, $16, $16

org $82D592+$76
Music_Skull_Drop:
db $16, $16, $16, $16

org $82D592+$34
Music_Thieves:
db $16

org $82D592+$2D
Music_Ice:
db $16

org $82D592+$27
Music_Mire:
db $16

org $82D592+$35
Music_TRock:
db $16
org $82D592+$15
Music_TRock2:
db $16
org $82D592+$18
Music_TRock3:
db $16, $16

org $82D592+$37
Music_GTower:
db $16

;--------------------------------------------------------------------------------
; OWG EDM bridge sign text pointer (Message id of the upper left of map05 = map05)
;--------------------------------------------------------------------------------
org $87F501
dw $018E
;--------------------------------------------------------------------------------
; GT sign text pointer (Message id of the upper right of map43 = map44)
;--------------------------------------------------------------------------------
org $87F57F
dw $0190
;--------------------------------------------------------------------------------
; Pyramid sign text pointer (Message id of the upper left of map5B = map5B)
;--------------------------------------------------------------------------------
org $87F5AD
dw $0191
;--------------------------------------------------------------------------------
; HC (inverted) left sign text pointer (Message id of the upper left of map1B = map1B)
;--------------------------------------------------------------------------------
org $87F52D
dw $0190
;--------------------------------------------------------------------------------
; HC (inverted) right sign text pointer (Message id of the upper right of map1B = map1C)
;--------------------------------------------------------------------------------
org $87F52F
dw $0191

;--------------------------------------------------------------------------------
;Map Pendant / Crystal Indicators - DEPRECATED in favor of WorldMapIcon_tile, don't use

org $8ABF2E ; PC 0x53F02
dw $0100 ; #$6234 - Master Sword

org $8ABEF8 ; PC 0x53EF8
MapObject_Eastern:
dw $6238 ; #$6038 - Green Pendant / Courage

org $8ABF1C ; PC 0x53F1C
MapObject_Desert:
dw $6034 ; #$6034 - Blue Pendant / Power

org $8ABF0A ; PC 0x53F0A
MapObject_Hera:
dw $6032 ; #$6032 - Red Pendant / Wisdom

org $8ABF00 ; PC 0x53F00
MapObject_Darkness:
dw $6434 ; #6434 - Crystal

org $8ABF6C ; PC 0x53F6C
MapObject_Swamp:
dw $6434 ; #6434 - Crystal

org $8ABF12 ; PC 0x53F12
MapObject_Skull:
dw $6434 ; #6434 - Crystal

org $8ABF36 ; PC 0x53F36
MapObject_Thieves:
dw $6434 ; #6434 - Crystal

org $8ABF5A ; PC 0x53F5A
MapObject_Ice:
dw $6432 ; #6434 - Crystal 5/6

org $8ABF48 ; PC 0x53F48
MapObject_Mire:
dw $6432 ; #6434 - Crystal 5/6

org $8ABF24 ; PC 0x53F24
MapObject_TRock:
dw $6434 ; #6434 - Crystal

;--------------------------------------------------------------------------------
org $82A09B ; PC 0x1209B - Bank02.asm:5802 - (pool MilestoneItem_Flags:)
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
org $81C6FC ; PC 0xC6FC - Bank01.asm:10344 - (db $00, $00, $01, $02, $00, $06, $06, $06, $06, $06, $03, $06, $06)
DungeonPrizeReceiptID:
	db $00 ; Sewers
	db $00 ; Hyrule Castle
	db $37 ; Eastern Palace
	db $39 ; Desert Palace
	db $00 ; Agahnim's Tower
	db $20 ; Swamp Palace
	db $20 ; Palace of Darkness
	db $20 ; Misery Mire
	db $20 ; Skull Woods
	db $20 ; Ice Palace
	db $38 ; Tower of Hera
	db $20 ; Thieves' Town
	db $20 ; Turtle Rock
;Ether/Nothing: $00
;Green Pendant: $01
;Blue Pendant: $02
;Red Pendant: $03
;Heart Container: $04
;Bombos: $05
;Crystal: $06
;--------------------------------------------------------------------------------
org $82885E ; PC 0x1085E - Bank02.asm:1606 - (dw $0006, $005A, $0029, $0090, $00DE, $00A4, $00AC, $000D) ; DEPRECATED - DISCONTINUE USE
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
;org $898B7D ; PC 0x48B7D - ancilla_init.asm:1630 - (db $37, $39, $38) ; DEPRECATED - DISCONTINUE USE
;PendantEastern:
;db $37
;PendantDesert:
;db $39
;PendantHera:
;db $38

;37:Pendant 1 Green / Courage
;38:Pendant 3 Red / Wisdom
;39:Pendant 2 Blue / Power
;--------------------------------------------------------------------------------
org $87B51D ; PC 0x3B51D
BlueBoomerangSubstitution:
db $FF ; no substitution
org $87B53B ; PC 0x3B53B
RedBoomerangSubstitution:
db $FF ; no substitution
;--------------------------------------------------------------------------------
;org $88D01A ; PC 0x4501A - ancilla_flute.asm - 42
;OldHauntedGroveItem:
;	db $14 ; #$14 = Flute
;--------------------------------------------------------------------------------
;2B:Bottle Already Filled w/ Red Potion
;2C:Bottle Already Filled w/ Green Potion
;2D:Bottle Already Filled w/ Blue Potion
;3C:Bottle Already Filled w/ Bee
;3D:Bottle Already Filled w/ Fairy
;48:Bottle Already Filled w/ Gold Bee
org $86C8FF ; PC 0x348FF
WaterfallPotion: ; <-------------------------- FAIRY POTION STUFF HERE
	db $2C ; #$2C = Green Potion
org $86C93B ; PC 0x3493B
PyramidPotion:
	db $2C ; #$2C = Green Potion
;--------------------------------------------------------------------------------
org $B08140 ; PC 0x180140 - 0x18014A [encrypted]
HeartPieceOutdoorValues:
HeartPiece_Spectacle:
	db $17
HeartPiece_Mountain_Warp:
	db $17
HeartPiece_Maze:
	db $17
HeartPiece_Desert:
	db $17
HeartPiece_Lake:
	db $17
HeartPiece_Swamp:
	db $17
HeartPiece_Cliffside:
	db $17
HeartPiece_Pyramid:
	db $17
HeartPiece_Digging:
	db $17
HeartPiece_Zora:
	db $17
HauntedGroveItem:
	db $14 ; #$14 = Flute
;--------------------------------------------------------------------------------
; 0x18014B - 0x18014F (unused) [encrypted]
;================================================================================
org $B08150 ; PC 0x180150 - 0x180159 [encrypted]
HeartContainerBossValues:
HeartContainer_ArmosKnights:
	db $3E ; #$3E = Boss Heart (putting pendants here causes main pendants to not drop for obvious (in retrospect) reasons)
HeartContainer_Lanmolas:
	db $3E
HeartContainer_Moldorm:
	db $3E
HeartContainer_HelmasaurKing:
	db $3E
HeartContainer_Arrghus:
	db $3E
HeartContainer_Mothula:
	db $3E
HeartContainer_Blind:
	db $3E
HeartContainer_Kholdstare:
	db $3E
HeartContainer_Vitreous:
	db $3E
HeartContainer_Trinexx:
	db $3E
;--------------------------------------------------------------------------------
; 0x180159 - 0x18015F (unused) [encrypted]
;================================================================================
org $B08160 ; PC 0x180160 - 0x180162
BonkKey_Desert:
	db $24 ; #$24 = Small Key (default)
BonkKey_GTower:
	db $24 ; #$24 = Small Key (default)
StandingKey_Hera:
	db $24 ; #$24 = Small Key (default)
;--------------------------------------------------------------------------------
; 0x180163 - 0x180164 (unused)
;================================================================================
org $B08165 ; PC 0x180165
GoalItemIcon:
dw $280E ; #$280D = Star - #$280E = Triforce Piece (default)
;================================================================================
org $B08167 ; PC 0x180167-0x180167
GoalItemRequirement:
dw $0000 ; #$0000 = Off (default) - #$XXXX = Require $XX Goal Items - #$FFFF = Counter-Only
;================================================================================
org $B08169 ; PC 0x180169
AgahnimDoorStyle:
db $01 ; #00 = Never Locked - #$01 = Locked During Escape (default) - #$02 = Locked Without 7 Crystals
;================================================================================
org $B0816A ; PC 0x18016A
FreeItemText:
db $00 ; #00 = Off (default)
;--po bmcs
;p - enabled for non-prize crystals
;o - enabled for outside dungeon items
;b - enabled for inside big key items
;m - enabled for inside map items
;c - enabled for inside compass items
;s - enabled for inside small key items
;================================================================================
org $B0816B ; PC 0x18016B - 0x18016D
HardModeExclusionCaneOfByrnaUsage:
db $04, #$02, #$01 ; Normal, 1/2, 1/4 Magic
org $B0816E ; PC 0x18016E - 308170
HardModeExclusionCapeUsage:
db $04, #$08, #$10 ; Normal, 1/2, 1/4 Magic
;================================================================================
org $B08171 ; PC 0x180171
GanonPyramidRespawn:
db $01 ; #00 = Do not respawn on Pyramid after Death - #$01 = Respawn on Pyramid after Death (default)
;================================================================================
org $B08172 ; PC 0x180172
GenericKeys:
db $00 ; #00 = Dungeon-Specific Keys (Default) - #$01 = Generic Keys
;================================================================================
org $B08173 ; PC 0x180173
Bob:
db $01 ; #00 = Off - #$01 = On (Default)
;================================================================================
org $B08174 ; PC 0x180174
; Flag to fix Fake Light World/Fake Dark World as caused by leaving the underworld
; to the other world (As can be caused by EG, Certain underworld clips, or Entance Randomizer).
; Currently, Fake Worlds triggered by other causes like YBA's Fake Flute, are not affected.
FixFakeWorld:
db $01 ; #00 = Fix Off (Default) - #$01 = Fix On
;================================================================================
org $B08175 ; PC 0x180175 - 0x180179
ArrowMode:
db $00 ; #00 = Normal (Default) - #$01 = Rupees
ArrowModeWoodArrowCost: ; keep these together
dw $000A ; #$000A = 10 (Default)
ArrowModeSilverArrowCost: ; keep these together
dw $0032 ; #$0032 = 50 (Default)
;================================================================================
org $B0817A ; PC 0x18017A ; #$2000 for Eastern Palace
MapReveal_Sahasrahla:
dw $0000
org $B0817C ; PC 0x18017C ; #$0140 for Ice Palace and Misery Mire
MapReveal_BombShop:
dw $0000
;================================================================================
org $B0817E ; PC 0x18017E
Restrict_Ponds:
db $01 ; #$00 = Original Behavior - #$01 - Restrict to Bottles (Default)
;================================================================================
org $B0817F ; PC 0x18017F
DisableFlashing:
db $00 ; #$00 = Flashing Enabled (Default) - #$01 = Flashing Disabled
;================================================================================
;---- --hb
;h - Hookshot
;b - Boomerang
org $B08180 ; PC 0x180180
StunItemAction:
db $03 ; #$03 = Hookshot and Boomerang (Default)
;================================================================================
org $B08181 ; PC 0x180181
SilverArrowsUseRestriction:
db $00 ; #$00 = Off (Default) - #$01 = Only At Ganon
;================================================================================
org $B08182 ; PC 0x180182
SilverArrowsAutoEquip:
db $01 ; #$00 = Off - #$01 = Collection Time (Default) - #$02 = Entering Ganon - #$03 = Collection Time & Entering Ganon
;================================================================================
org $B08183 ; PC 0x180183
FreeUncleItemAmount:
dw $12C ; 300 rupees (Default)
;--------------------------------------------------------------------------------
org $B08185 ; PC 0x180185
RainDeathRefillTable:
RainDeathRefillMagic_Uncle:
db $00
RainDeathRefillBombs_Uncle:
db $00
RainDeathRefillArrows_Uncle:
db $00
RainDeathRefillMagic_Cell:
db $00
RainDeathRefillBombs_Cell:
db $00
RainDeathRefillArrows_Cell:
db $00
RainDeathRefillMagic_Mantle:
db $00
RainDeathRefillBombs_Mantle:
db $00
RainDeathRefillArrows_Mantle:
db $00
;================================================================================
; 0x18018E - 0x18018F (unused)
;================================================================================
org $B08190 ; PC 0x180190 - 0x180192
TimerStyle:
db $00 ; #$00 = Off (Default) - #$01 Countdown - #$02 = Stopwatch
TimeoutBehavior:
db $00 ; #$00 = DNF (Default) - #$01 = Sign Change (Requires TimerRestart == 1) - #$02 = OHKO - #$03 = End Game
TimerRestart:
db $00 ; #$00 = Locked (Default) - #$01 = Restart
;--------------------------------------------------------------------------------
org $B08193 ; PC 0x180193
ServerRequestMode:
db $00 ; #$00 = Off (Default) - #$01 = Synchronous - #$02 = Asychronous
;---------------------------------------------------------------------------------
org $B08194 ; PC 0x180194
TurnInGoalItems:
db $01 ; #$00 = Instant win if last goal item collected. $01 = (Default) must turn in goal items
;--------------------------------------------------------------------------------
org $B08195 ; PC 0x180195
ByrnaCaveSpikeDamage:
db $08 ; #$08 = 1 Heart (default) - #$02 = 1/4 Heart
;--------------------------------------------------------------------------------
org $B08196     ; PC 0x180196-0x180197
TotalItemCount: ; Total item count for HUD. Only counts items that use "item get" animation.
dw $00D8        ; 216

org $B08198             ; PC 0x180198-0x1801A9
GanonsTowerOpenAddress: ; 0x180198-0x180199
dw CrystalCounter       ; Target address for GT open check
GanonsTowerOpenTarget:  ; 0x18019A-0x18019B
dw $0007                ; Target amount for GT open modes to compare
GanonsTowerOpenMode:    ; 0x18019C-0x18019D
dw $0001                ; $00 = Vanilla | $01 = Compare target with address
PedPullAddress:         ; 0x18019E-0x18019F
dw PendantCounter       ; Target address for ped pull check
PedPullTarget:          ; 0x1801A0-0x1801A1
dw $0003                ; Target amount for ped pull modes to check
PedCheckMode:           ; 0x1801A2-0x1801A3
dw $0000                ; $00 = vanilla | $01 = Compare address to target value
GanonVulnerableAddress: ; 0x1801A4-0x1801A5
dw CrystalCounter       ; Target address for ped pull check
GanonVulnerableTarget:  ; 0x1801A6-0x1801A7
dw $0007                ; Target amount for Ganon vulnerability modes to compare
GanonVulnerableMode:    ; 0x1801A8-0x1801A9
dw $0000                ; #$00 = Off (default)
                        ; #$01 = On
                        ; #$02 = Require All Dungeons
                        ; #$03 = Require "GanonVulnerableTarget" Crystals and Aga2
                        ; #$04 = Require "GanonVulnerableTarget" Crystals
                        ; #$05 = Require "GoalItemRequirement" Goal Items
                        ; #$06 = Light Speed
                        ; #$07 = Require All Crystals and Crystal Bosses
                        ; #$08 = Require All Crystal Bosses only
                        ; #$09 = Require All Dungeons No Agahnim
                        ; #$0A = Require 100% Item Collection
                        ; #$0B = Require 100% Item Collection and All Dungeons
;--------------------------------------------------------------------------------
; 0x18019A - 0x1801FF (unused)
;================================================================================
org $B08200 ; PC 0x180200 - 0x18020B
RedClockAmount:
dw $4650, #$0000 ; $00004650 = +5 minutes
BlueClockAmount:
dw $B9B0, #$FFFF ; $FFFFB9B0 = -5 minutes
GreenClockAmount:
dw $0000, #$0000
;--------------------------------------------------------------------------------
; 0x18020C-0x18020F (unused)
;--------------------------------------------------------------------------------
;================================================================================
org $89E3BB ; PC 0x4E3BB
db $E4 ; Hera Basement Key (Set to programmable HP $EB) (set to $E4 for original hookable/boomable key behavior)
;================================================================================
org $B08210 ; PC 0x180210
RandomizerSeedType:
db $00 ; #$00 = Casual (default) - #$01 = Glitched - #$02 = Speedrunner - #$A0 = Super Metroid Combo - #$FF = Not Randomizer
;--------------------------------------------------------------------------------
org $B08211 ; PC 0x180211
GameType:
;---- ridn
;r - room randomization
;i - item randomization
;d - door/entrance randomization
;n - enemy randomization
db $00 ; #$00 = Not Randomized (default)
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
org $B08212 ; PC 0x180212
WarningFlags:
db $00
;--------------------------------------------------------------------------------
org $B08213 ; PC 0x180213
TournamentSeed:
db $00 ; #$00 = Off (default) - #$01 = On
TournamentSeedInverse:
db $01 ; #$00 = On - #$01 = Off (Default)
;--------------------------------------------------------------------------------
org $B08215 ; PC 0x180215
SeedHash:
db $00, $01, $02, $03, $04
;--------------------------------------------------------------------------------
org $B0821A ; PC 0x18021A
NoBGM:
db $00 ; $00 = BGM enabled (default) $01 = BGM disabled
org $B0821B ; PC 0x18021B
FastFanfare:
db $00 ; $00 = Normal fanfare (default) $01 = Fast fanfare
org $B0821C ; PC 0x18021C
MSUResumeType:
db $01 ; Type of tracks to resume #$00 = Everything - #$01 = Overworld (default)
org $B0821D ; PC 0x18021D
MSUResumeTimer:
dw $0708 ; Number of frames on a different track until we no longer resume (0x708 = 1800 = ~30s)
;--------------------------------------------------------------------------------
; 0x18021F - 0x18021F (unused)
;================================================================================
; $308220 (0x180220) - $30823F (0x18023F)
; Plandomizer Author Name (ASCII) - Leave unused chars as 0
org $B08220 ; PC 0x180220
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
org $B08240 ; PC 0x180240
StartingAreaExitOffset:
db $00, $00, $00, $00, $00, $00, $00
;--------------------------------------------------------------------------------
org $B08247 ; PC 0x180247
; For any starting areas in single entrance caves you can specify the overworld door here
; to enable drawing the doorframes These values should be the overworld door index+1.
; A value of zero will draw no door frame.
StartingAreaOverworldDoor:
db $00, $00, $00, $00, $00, $00, $00
;--------------------------------------------------------------------------------
; 0x18024E - 0x18024F (unused)
;-------------------------------------------------------------------------------
; $308250 (0x180250) - $30829F (0x18029F)
org $B08250 ; PC 0x180250
StartingAreaExitTable:
; This has the same format as the main Exit table, except
; is stored row major instead of column major
; it lacks the last two columns and has 1 padding byte per row (the last byte)
dw $0112 : db $53 : dw $001e, $0400, $06e2, $0446, $0758, $046d, $075f : db $00, $00, $00
dw $0000 : db $00 : dw $0000, $0000, $0000, $0000, $0000, $0000, $0000 : db $00, $00, $00
dw $0000 : db $00 : dw $0000, $0000, $0000, $0000, $0000, $0000, $0000 : db $00, $00, $00
dw $0000 : db $00 : dw $0000, $0000, $0000, $0000, $0000, $0000, $0000 : db $00, $00, $00
;--------------------------------------------------------------------------------
; 0x1802A0 - 0x1802BF (unused)
;---------------------------------------------------------------------------------

;--------------------------------------------------------------------------------
; 0x1802C0 - 0x1802FF (unused)
;---------------------------------------------------------------------------------
;--------------------------------------------------------------------------------
; $308300 (0x180300) - $30834F (0x18034F)
org $B08300 ; PC 0x180300
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
org $B08350 ; PC 0x180350
ShouldStartatExit:
db $00, $00, $00
;--------------------------------------------------------------------------------
; $308358 (0x180358) fixes major glitches
; 0x00 - fix
; otherwise dont fix various major glitches
org $B08358
AllowAccidentalMajorGlitch:
db $00
;--------------------------------------------------------------------------------
; GFX pointers (0x180359 - 0x18035E)
; For 3rd party sprite stuff
;--------------------------------------------------------------------------------
org $B0835C
dl ItemReceiptGraphicsOffsets

org $B0835F
dl ItemReceiptGraphicsOffsets

; reserving up to 7F for more pointers as needed

;================================================================================
; 0x180380 - 0x1814FF (unused)
;================================================================================
; $309500 (0x181500) - $309FFF (0x181FFF) original 0x39C bytes
; Replacement Ending Sequence Text Data
; if you modify this table you will need to modify the pointers to it located at $0EECC0
org $B09500 ; PC 0x181500
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
db $62, $E8, $00, $1F, $76, $6B, $6E, $5D, $D9, $6F, $9F, $73, $5D, $70, $61, $6E, $62, $5D, $68, $68
db $63, $08, $00, $1F, $9C, $91, $94, $83, $EC, $95, $9F, $99, $83, $96, $87, $94, $88, $83, $8E, $8E
; the witch and assistant
db $62, $64, $00, $2D, $2D, $21, $1E, $9F, $30, $22, $2D, $1C, $21, $9F, $1A, $27, $1D, $9F, $1A, $2C, $2C, $22, $2C, $2D, $1A, $27, $2D
db $62, $EB, $00, $13, $69, $5D, $63, $65, $5F, $9F, $6F, $64, $6B, $6C
db $63, $0B, $00, $13, $8F, $83, $89, $8B, $85, $9F, $95, $8A, $91, $92
; twin lumberjacks
db $62, $68, $00, $1F, $2D, $30, $22, $27, $9F, $25, $2E, $26, $1B, $1E, $2B, $23, $1A, $1C, $24, $2C
db $62, $E9, $00, $1B, $73, $6B, $6B, $60, $6F, $69, $61, $6A, $D9, $6F, $9F, $64, $71, $70
db $63, $09, $00, $1B, $99, $91, $91, $86, $95, $8F, $87, $90, $EC, $95, $9F, $8A, $97, $96
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
db $62, $EC, $00, $0F, $62, $6B, $6E, $61, $72, $61, $6E, $E5
db $63, $0C, $00, $0F, $88, $91, $94, $87, $98, $87, $94, $F8
;--------------------------------------------------------------------------------
; org $8EECC0 ; PC 0x76CC0 poiters for above scenes
; dw $0000, $003C, $006A, $00AC, $00EA, $012A, $015D, $019D, $01D4, $020C, $0249, $0284, $02B7, $02F1, $0329, $0359, $039C
;================================================================================
org $B0A000 ; $30A000 (0x182000) - $30A07F (0x18007F)
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
org $B0A080 ; $30A080 (0x182080) - $30A0FF (0x1820FF)
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
;org $8283E0 ; PC 0x103E0 (Bank02.asm:816) (BNE)
;db $F0 ; #$D0 - Light Only (Default), #$F0 - Dark Only
;org $82B34D ; PC 0x1334D (Bank02.asm:7902) (BNE)
;db $F0 ; #$D0 - Light Only (Default), #$F0 - Dark Only
;org $86DB78 ; PC 0x35B78 (Bank06.asm:2186) ($24)
;db $8B ; #$24 - Light Style, #$8B - Dark Style
;;Portal indicator in dark world map
;org $8ABFBB ; Bank0a.asm:1005 (LDA $008A : CMP.b #$40 : BCS BRANCH_BETA)
;db $90 ;$90 (BCC) - Show in Dark World, $B0 (BCS) normal
;;--------------------------------------------------------------------------------
;;Vortexes
;org $85AF79 ; PC 0x2AF79 (sprite_warp_vortex.asm:18) (BNE)
;db $F0 ; #$D0 - Light Only (Default), #$F0 - Dark Only
;org $8DB3C5 ; PC 0x6B3C5 (sprite_properties.asm:119) ($C4)
;db $C6 ; #$C4 - Blue Portal, #$C6 - Red Portal
;;--------------------------------------------------------------------------------
;;Duck
;org $87A3F4 ; PC 0x3A3F4 (Bank07.asm:5772) (BNE)
;db $F0 ; #$D0 - Light Only (Default), #$F0 - Dark Only
;org $82E849 ; PC 0x16849 (Bank02.asm:11641)
;;dw $0003, $0016, $0018, $002C, $002F, $0030, $003B, $003F ; Light World Flute Spots
;dw $0043, $0056, $0058, $006C, $006F, $0070, $007B, $007F ; Dark World Flute Spots
;org $82E8D5 ; PC 0x168D5 (Bank02.asm:11661) ($07B7)
;dw $07C8 ; $07B7 - Normal Location 3 Y (Default), $07C7 - Inverted Location 3 Y
;org $82E8F7; PC 0x168F7 (Bank02.asm:11661) ($07B7)
;dw $01F8 ; $0200 - Normal Location 3 X (Default), $0200 - Inverted Location 3 X
;;--------------------------------------------------------------------------------
;;Mirror
;org $87A943 ; PC 0x3A943 (Bank07.asm:6548) (BNE)
;db $80 ; #$D0 - Dark-to-Light (Default), #$F0 - Light-to-Dark, #$80 - Both Directions, #$42 - Disabled
;;--------------------------------------------------------------------------------
;;Residual Portal
;org $87A96D ; PC 0x3A96D (Bank07.asm:6578) (BEQ)
;db $D0 ; #$F0 - Light Side (Default), #$D0 - Dark Side
;;--------------------------------------------------------------------------------
;org $88D40C ; PC 0x4540C (ancilla_morph_poof.asm:48) (BEQ)
;db $D0 ; #$F0 - Light Side (Default), #$D0 - Dark Side
;;--------------------------------------------------------------------------------
;; Spawn
; org $8280a6 ; <- Bank02.asm : 257 (LDA $7EF3CA : BEQ .inLightWorld)
;db $D0 ; #F0 - default to light (Default), #$D0 - Default to dark
;;--------------------------------------------------------------------------------
;org $86B2AA ; <- 332AA sprite_smithy_bros.asm : 152 (JSL Sprite_ShowSolicitedMessageIfPlayerFacing)
;JSL Sprite_ShowMessageFromPlayerContact ; Inverted uses Sprite_ShowMessageFromPlayerContact
;;---------------------------------------------------------------------------------
org $80886E ; <- Bank00.asm : 1050 (LDA Overworld_TileAttr, X)
LDA.l Overworld_TileAttr, X ; use "JML InvertedTileAttributeLookup" for inverted
Overworld_GetTileAttrAtLocation_continue:
;================================================================================
org $8DDBEC ; <- 6DBEC
dw 10000 ; Rupee Limit +1
org $8DDBF1 ; <- 6DBF1
dw 9999 ; Rupee Limit
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
;================================================================================;

org $B0A100 ; PC 0x182100 - 0x182304
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
org $B0B000 ; PC 0x183000 - 0x1834FF
incsrc initsramtable.asm

;--------------------------------------------------------------------------------
; 0x183500 - 183FFF (unused)
;================================================================================
org $B0C000 ; PC 0x184000 - 0x184040
ItemSubstitutionRules:
;db [item][quantity][substitution][pad] - CURRENT LIMIT 16 ENTRIES
db $12, $01, $35, $FF
db $51, $06, $52, $FF
db $53, $06, $54, $FF
db $FF, $FF, $FF, $FF

org $B0C041 ; PC 0x184041
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
org $B0C800 ; PC 0x184800 - 0x1848FF - max 32 shops ; do not exceed 36 tracked items sram_index > ($24)
ShopTable:
;db [id][roomID-low][roomID-high][doorID][zero][shop_config][shopkeeper_config][sram_index]
db $01, $15, $01, $5D, $00, $12, $04, $00
db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF

org $B0C900 ; PC 0x184900 - 0x184FFF - max 224 entries
ShopContentsTable:
;db [id][item][price-low][price-high][max][repl_id][repl_price-low][repl_price-high]
db $01, $51, $64, $00, $07, $FF, $00, $00
db $01, $53, $64, $00, $07, $FF, $00, $00
db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF

;--------------------------------------------------------------------------------
; 0x185060 - 1850FF (unused)
;--------------------------------------------------------------------------------
org $B0D100 ; PC 0x185100 - 0x18513F
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
org $B0D800 ; PC 0x185800 - 0x18591F
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
; 0x185A00 - 186BFF
;--------------------------------------------------------------------------------


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
org $B0EFFF ; PC 0x186FFF
BallNChainDungeon: ; Dungeon ID where ball n chain guard is located. Write
db $02             ; $FF to count ball and chain item for collection stats.

org $B0F000 ; PC 0x187000-0x18700F
CompassTotalsROM:
db $08, $08, $06, $06, $02, $0A, $0E, $08, $08, $08, $06, $08, $0C, $1B, $00, $00

org $B0F010
ChestKeys: ; PC 0x187010-0x18701F
db $01, $01, $00, $01, $02, $01, $06, $03, $03, $02, $01, $01, $04, $04, $00, $00

org $B0F020
HUDHeartColors: ; PC 0x187020
.index          ; $00 = Red | $01 = Blue | $02 = Green | $03 = Yellow
dw #$0000
.masks_game_hud    ; PC 0x187022
dw #$0400          ; Red
dw #$0C00          ; Blue
dw #$1C00          ; Green
dw #$0800          ; Yellow
.masks_file_select ; PC 0x18702A
dw #$0400          ; Red
dw #$0C00          ; Blue
dw #$1800          ; Green
dw #$0800          ; Yellow

org $B0F032 ; PC 0x187032
RomSpeed:
db $01      ; $01 = FastROM (default) | $00 = SlowROM

org $B0F033 ; PC 0x187033

;--------------------------------------------------------------------------------
; 0x187033 - 187FFF (unused)
;--------------------------------------------------------------------------------


;--------------------------------------------------------------------------------
; Overworld Map Tables
;--------------------------------------------------------------------------------
org $8ABDF6
WorldMapIcon_posx_vanilla:
dw $0F31 ; prize1
dw $08D0 ; prize2
dw $0108
dw $0F40

dw $0082
dw $0F11
dw $01D0
dw $0100

dw $0CA0
dw $0759
dw $FF00
dw $FF00

dw $FF00
dw $FFFF ; reserved - not used
dw $FFFF
dw $FFFF

org $8ABE16
WorldMapIcon_posy_vanilla:
dw $0620 ; prize1
dw $0080 ; prize2
dw $0D70
dw $0620

dw $00B0
dw $0103
dw $0780
dw $0CA0

dw $0DA0
dw $0ED0
dw $FF00
dw $FF00

dw $FF00
dw $FFFF ; reserved - not used
dw $FFFF
dw $FFFF

org $8ABE36
WorldMapIcon_posx_located:
dw $FF00 ; prize1
dw $FF00 ; prize2
dw $FF00
dw $FF00

dw $FF00
dw $FF00
dw $FF00
dw $FF00

dw $FF00
dw $FF00
dw $FF00
dw $FF00

dw $FF00
dw $FFFF ; reserved - not used
dw $FFFF
dw $FFFF

org $8ABE56
WorldMapIcon_posy_located:
dw $FF00 ; prize1
dw $FF00 ; prize2
dw $FF00
dw $FF00

dw $FF00
dw $FF00
dw $FF00
dw $FF00

dw $FF00
dw $FF00
dw $FF00
dw $FF00

dw $FF00
dw $FFFF ; reserved - not used
dw $FFFF
dw $FFFF

org $8ABE76
WorldMapIcon_tile:
db $38, $62 ; green pendant        ; Eastern Palace
db $32, $60 ; red pendant          ; Hera
db $34, $60 ; blue pendant         ; Desert
db $34, $64 ; crystal              ; PoD

db $34, $64 ; crystal              ; Skull Woods
db $34, $64 ; crystal              ; Turtle Rock
db $34, $64 ; crystal              ; Thieves Town
db $34, $64 ; crystal              ; Misery Mire

db $34, $64 ; crystal              ; Ice Palace
db $34, $64 ; crystal              ; Swamp Palace
db $32, $66 ; skull looking thing
db $00, $00 ; red x

db $00, $00 ; red x
db $00, $00 ; unused red x's
db $00, $00
db $00, $00

org $8ABE96
CompassExists:
; dw $37FC ; todo: convert to two bytes with masks? so much extra code...
; eastern hera desert pod skull trock thieves mire ice swamp gt at escape
db $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $00, $00, $00, $00, $00

; 0 = light world, 1 = dark world
org $8ABEA6
WorldCompassMask:
; eastern desert hera pod skull trock thieves mire ice swamp gt at escape x1 x2 x3
db $00, $00, $00, $01, $01, $01, $01, $01, $01, $01, $01, $00, $00, $00, $00, $00

; eastern desert hera pod skull trock thieves mire ice swamp gt at escape
MC_DungeonIdsForPrize:
db $02, $0A, $03, $06, $08, $0C, $0B, $07, $09, $05, $00, $04, $01
MC_SRAM_Offsets:
db $01, $00, $01, $01, $00, $00, $00, $01, $00, $01, $00, $01, $01
MC_Masks:
;   EP   TH   DP   PD   SK   TR   TT   MM
db $20, $20, $10, $02, $80, $08, $10, $01, $40, $04, $04, $08, $40
