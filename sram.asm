;================================================================================
; SRAM Labels & Assertions
;--------------------------------------------------------------------------------
; Labels for values in SRAM and assertions that ensure they're correct and
; at the expected addresses. All values larger than one byte are little endian.
;--------------------------------------------------------------------------------
; $7EF000 - $7EF4FF in WRAM maps to the first $4FF bytes in SRAM (Bank $70)
; $7F6000 - $7F6FFF in WRAM maps to the next 4k bytes, occupying the 2nd and 3rd vanilla
;                   save file locations. ($700500 - $701500)
;--------------------------------------------------------------------------------
org 0 ; This module writes no bytes. Asar gives bank cross errors without this.

;================================================================================
; Room Data ($7EF000 - $7EF27F
;--------------------------------------------------------------------------------
; Each room has two bytes. There are 296 ($128) rooms in the ROM. The data beyond
; $7EF24F is unused. The current room index is located at $A0 in WRAM (16-bits.)
;
; The quadrant bits from left to right correspond to quadrants
; 4 (northwest), 3 (northeast), 2 (southwest), and 1 (southeast), which is the same
; as they are laid out on the screen from left to right, top to bottom.
;
; Example: We can use RoomData[$37].high to read or write the pot key in the first
; floodable room in Swamp Palace ($04)
;--------------------------------------------------------------------------------
; .high Byte:  d d d d b k u r
; .low Byte:   c c c c q q q q
;
; d = Door opened (key, bomb wall, etc)
; b = Boss kill / Heart Piece
; k = Key
; u = Second key
; t = Chest 4 / Rupee floor / Swamp drains
; s = Chest 3 / Bomable floor / PoD or Desert wall
; e = Chest 2
; h = Chest 1
; c = Chest 0
; q = Quadrant visits
;--------------------------------------------------------------------------------
struct RoomData $7EF000
    .l
    .low: skip 1
    .high: skip 1
endstruct align 2

;================================================================================
; Overworld Event Data ($7EF280 - $7EF33F)
;--------------------------------------------------------------------------------
; Each overworld area has one byte. The overworld screen index is located at $8A
; in WRAM (16-bits.) 
;
; This label can be indexed with a plus symbol (e.g. The Hyrule Castle screen would
; be OverworldEventData+$1B or OverworldEventData+27)
;--------------------------------------------------------------------------------
; - i o - - - b -
;
; i = Free-standing item collected. Also used for sprites like the castle tower barrier
; o = Overlay active
; b = Secondary overlay active
;--------------------------------------------------------------------------------
OverworldEventData = $7EF280

;================================================================================
; Items & Equipment ($7EF340 - $7EF38B)
;--------------------------------------------------------------------------------
; Current equipment labels & values
; Values will represent current menu selection in cases where player can switch
; items (e.g. holding powder and mushroom at the same time.)
;
; $00 = None
;--------------------------------------------------------------------------------
base $7EF340
WRAMEquipment:                  ;
BowEquipment: skip 1            ; $01 = Bow              | $02 = Bow & Arrows
                                ; $03 = Silver Arrow Bow | $04 = Bow & Silver Arrows
BoomerangEquipment: skip 1      ; $01 = Blue | $02 = Red
HookshotEquipment: skip 1       ; $01 = Hookshot
BombsEquipment: skip 1          ; Number of bombs currently held (8-bit integer)
PowderEquipment: skip 1         ; $01 = Mushroom | $02 = Powder
FireRodEquipment: skip 1        ; $01 = Fire Rod
IceRodEquipment: skip 1         ; $01 = Ice Rod
BombosEquipment: skip 1         ; $01 = Bombos Medallion
EtherEquipment: skip 1          ; $01 = Ether Medallion
QuakeEquipment: skip 1          ; $01 = Quake Medallion
LampEquipment: skip 1           ; $01 = Lamp
HammerEquipment: skip 1         ; $01 = Hammer
FluteEquipment: skip 1          ; $01 = Shovel | $02 = Inactive Flute | $03 = Active Flute
BugNetEquipment: skip 1         ; $01 = Bug Net
BookOfMudoraEquipment: skip 1   ; $01 = Book of Mudora
BottleIndex: skip 1             ; Current bottle in menu. 1-based index into BottleContents below
SomariaEquipment: skip 1        ; $01 = Cane of Somaria
ByrnaEquipment: skip 1          ; $01 = Cane of Byrna
CapeEquipment: skip 1           ; $01 = Magic Cape
MirrorEquipment: skip 1         ; $01 = Scroll (graphic only) | $02 = Mirror
GloveEquipment: skip 1          ; $01 = Power Gloves | $02 = Titan's Mitts
BootsEquipment: skip 1          ; \ $01 = Boots/Flippers | These only show menu item
FlippersEquipment: skip 1       ; / Correct bits must be set in AbilityFlags to dash/swim
MoonPearlEquipment: skip 1      ; $01 = Moon Pearl
skip 1                          ; Not used
SwordEquipment: skip 1          ; $01 = Fighter | $02 = Master | $03 = Tempered | $04 = Gold
ShieldEquipment: skip 1         ; $01 = Fighter | $02 = Red    | $03 = Mirror
ArmorEquipment: skip 1          ; $00 = Green   | $01 = Blue   | $02 = Red
BottleContents:                 ; \  Bottle Contents
BottleContentsOne: skip 1       ;  |
BottleContentsTwo: skip 1       ;  | $00 = No Bottle  | $01 = Mushroom     | $02 = Empty Bottle
BottleContentsThree: skip 1     ;  | $03 = Red Potion | $04 = Green Potion | $05 = Blue Potion
BottleContentsFour: skip 1      ; /  $06 = Fairy      | $07 = Bee          | $08 = Good Bee
TargetRupees: skip 2            ; \ CurrentRupees will always increment or decrement to match
CurrentRupees: skip 2           ; / TargetRupees if not equal (16-bit integer)
;--------------------------------------------------------------------------------
CompassField: skip 2            ; Dungeon item bitfields
BigKeyField: skip 2             ; High byte:  - - g r t h i s
MapField: skip 2                ; g = Ganon's Tower | r = Turtle Rock | t = Thieves' Town
                                ; h = Tower of Hera | i = Ice Palace  | s = Skull Woods
                                ;------------------------------------------------
                                ; Low Byte: m d s a t e h p
                                ; m = Misery Mire   | d = Palace of Darkness | s = Swamp Palace
                                ; a = Aga Tower     | t = Desert Palace      | e = Eastern Palace
                                ; h = Hyrule Castle | s = Sewer Passage
;--------------------------------------------------------------------------------
                                ; HUD & other equipment
skip 1                          ; Wishing Pond Rupee (Unused)
HeartPieceQuarter: skip 1       ; Heart pieces of four for health upgrade. Wraps around to $00 after $03.
HealthCapacity: skip 1          ; \ Health Capacity & Current Health
CurrentHealth: skip 1           ; / Max value is $A0 | $04 = half heart | $08 = heart
CurrentMagic: skip 1            ; Current magic | Max value is $80
CurrentSmallKeys: skip 1        ; Number of small keys held for current dungeon (integer)
BombCapacityUpgrades: skip 1    ; \ Bomb & Arrow Capacity Upgrades
ArrowCapacityUpgrades: skip 1   ; / Indicates flatly how many can be held above vanilla max (integers)
HeartsFiller: skip 1            ; Hearts collected yet to be filled. Write in multiples of $08
MagicFiller: skip 1             ; Magic collected yet to be filled
PendantsField: skip 1           ; - - - - - g b r (bitfield)
                                ; g = Green (Courage) | b = Blue (Power) | r = Red (Wisdom)
BombsFiller: skip 1             ; Bombs collected yet to be filled (integer)
ArrowsFiller: skip 1            ; Arrows collected yet to be filled (integer)
CurrentArrows: skip 1           ; Current arrows (integer)
skip 1                          ; Unknown
AbilityFlags: skip 1            ; - r t - p d s - (bitfield)
                                ; r = Read | t = Talk | p = Pull | d = Dash
                                ; s = Swim
CrystalsField: skip 1           ; - 3 4 2 7 5 1 6 (bitfield)
MagicConsumption: skip 1        ; $00 = Normal | $01 = Half Magic | $02 = Quarter Magic
;--------------------------------------------------------------------------------
                                ; Small keys earned per dungeon (integers)
DungeonKeys:                    ;
SewerKeys: skip 1               ;
HyruleCastleKeys: skip 1        ;
EasternKeys: skip 1             ; Eastern Palace small keys
DesertKeys: skip 1              ; Desert Palace small keys
CastleTowerKeys: skip 1         ; Agahnim's Tower small keys
SwampKeys: skip 1               ; Swamp Palace small keys
PalaceOfDarknessKeys: skip 1    ; Palace of Darkness small keys
MireKeys: skip 1                ; Misery Mire small keys
SkullWoodsKeys: skip 1          ; Skull Woods small keys
IcePalaceKeys: skip 1           ; Ice Palace small keys
HeraKeys: skip 1                ; Tower of Hera small keys
ThievesTownKeys: skip 1         ; Thieves' Town small keys
TurtleRockKeys: skip 1          ; Turtle Rock small keys
GanonsTowerKeys: skip 1         ; Ganon's Tower small keys
skip 1                          ; Unused
CurrentGenericKeys: skip 1      ; Generic small keys

;================================================================================
; Tracking & Indicators ($7EF38C - $7EF3F0)
;--------------------------------------------------------------------------------
InventoryTracking: skip 2       ; b r m p n s k f  - - - - - - o q (bitfield)
                                ; b = Blue Boomerang   | r = Red Boomerang  | m = Mushroom Current
                                ; p = Magic Powder     | n = Mushroom Past  | s = Shovel
                                ; k = Inactive Flute   | f = Active Flute   | o = Any bomb acquired
                                ; q = Quickswap locked
BowTracking: skip 2             ; b s p - - - - - (bitfield)
                                ; b = Bow | s = Silver Arrows Upgrade | p = Second Progressive Bow
                                ; The front end writes two distinct progressive bow items. p
                                ; indicates whether the "second" has been found independent of
                                ; the first
ItemLimitCounts: skip 24        ; Keeps track of limited non-progressive items such as lamp.
                                ; See: ItemSubstitutionRules in tables.asm
                                ; Right now this is only used for three items but extra space is
skip 29                         ; reserved
ProgressIndicator: skip 1       ; $00 = Pre-Uncle | $01 = Post-Uncle item | $02 = Zelda Rescued
                                ; $03 = Agahnim 1 defeated
                                ; $04 and above don't do anything. $00-$02 used in standard mode
ProgressFlags: skip 1           ; - - - u - z - s (bitfield)
                                ; u = Uncle left house | z = Mantle | s = Uncle item obtained
MapIcons: skip 1                ; Used for deciding which icons to display on OW map
                                ; $03 = Pendants  | $04 = Master Sword | $05 = Skull at Hyrule Castle
                                ; $06 = Crystal 1 | $07 = All Crystals | $08 = Skull at Ganon's Tower
StartingEntrance: skip 1        ; Starting entrance to use
                                ; $00 = Link's House         | $01 = Menu or Pyramid w/ Aga dead & mirror
                                ; $02 = Zelda's Cell         | $03 = Secret Passage or HC if entered (escape)
                                ; $04 = Throne Room (escape) | $05 = Old Man Cave w/ Old Man
NpcFlagsVanilla: skip 1         ; - - b p s - m h (bitfield)
                                ; b = Frog rescued    | p = Purple Chest | s = Stumpy (tree kid)
                                ; m = Bottle Merchant | h = Hobo
CurrentWorld: skip 1            ; $00 = Light World | $40 = Dark World
skip 1                          ; Unused
FollowerIndicator: skip 1       ; $00 = No Follower  | $01 = Zelda    | $04 = Old Man
                                ; $06 = Blind Maiden | $07 = Frog     | $08 = Dwarf
                                ; $09 = Locksmith    | $0A = Kiki     | $0C = Purple Chest
                                ; $0D = Big Bomb
FollowerXCoord: skip 2          ; \ Cached X and Y overworld coordinates of dropped follower
FollowerYCoord: skip 2          ; / (16-bit integers)
DroppedFollowerIndoors: skip 1  ; $00 = Dropped follower outdoors | $01 = Dropped follower indoors
DroppedFollowerLayer: skip 1    ; $00 = Upper layer | $01 =.lower layer
FollowerDropped: skip 1         ; Set to $80 when a follower exists and has been dropped somewhere
                                ; $00 otherwise
skip 5                          ; Unused
skip 8                          ; Unused
FileValidity: skip 2            ; Always $55AA. Don't write.

;================================================================================
; Rando-Specific Assignments & Game Stats ($7EF3F1 - $7EF4FF)
;--------------------------------------------------------------------------------
skip 28                         ; Unused
GameCounter: skip 2             ; Number of deaths and save + quits (16-bit integer)
PostGameCounter: skip 2         ; Initialized to $FFFF, replaced with GameCounter on goal completion
                                ; Number is displayed on file select when not $FFFF. Max 999 (16-bit integer)
skip 13                         ;
NpcFlags: skip 2                ; l - c s t k z o (bitfield)
                                ; l = Library  | c = Catfish   | s = Sahasrahla | t = Stumpy
                                ; k = Sick Kid | z = King Zora | o = Old Man
                                ;
                                ; b - p m f s b e (bitfield)
                                ; b = Magic Bat      | p = Potion Shop (Powder) | m = Lost Woods (Mushroom)
                                ; f = Fairy (unused) | s = Smith                | b = Bombos Tablet
                                ; e = Ether Tablet
skip 2                          ; Unused
MapOverlay: skip 2              ; Used to reveal dungeon prizes on the map in modes where maps,
                                ; Saha, and the bomb shop guy reveal dungeon prizes (bitfield)
                                ; \  - - g r t h i s
                                ;  | g = Ganon's Tower | r = Turtle Rock | t = Thieves' Town
                                ; /  h = Tower of Hera | i = Ice Palace  | s = Skull Woods
                                ; \  m d s a t e h p
                                ;  | m = Misery Mire   | d = Palace of Darkness | s = Swamp Palace
                                ;  | a = Aga Tower     | t = Desert Palace      | e = Eastern Palace
                                ; /  h = Hyrule Castle | s = Sewer Passage
HudFlag:                        ;
IgnoreFaeries:                  ;
HasGroveItem:                   ;
GeneralFlags: skip 1            ; - - h - - i - g (bitfield)
                                ; h = HUD Flag       | i = ignore faeries | g = has diggable grove item
HighestSword: skip 1            ; Highest sword level (integer)
GoalCounter: skip 2             ; Goal items collected (16-bit integer)
ProgrammableItemOne: skip 2     ; \  Reserved for programmable items
ProgrammableItemTwo: skip 2     ;  |
ProgrammableItemThree: skip 2   ; /
BonkCounter: skip 1             ; Number of times the player has bonked (integer)
YAItemCounter: skip 1           ; y y y y y a a a (packed integers)
                                ; Number of Y and A items collected represented as packed integers
HighestShield: skip 1           ; Highest Shield level
TotalItemCounter: skip 2        ; Total items collected (integer)
SwordBossKills: skip 2          ; t t t t g g g g  f f f f m m m m (packed integers)
                                ; t = Tempered Sword boss kills | g = Gold Sword boss kills
                                ; f = Fighter Sword boss kills  | m = Master Sword boss kills
BigKeysBigChests: skip 1        ; k k k k c c c c (packed integers)
                                ; k = Big Keys collected | c = Big Chests opened
MapsCompasses: skip 1           ; m m m m c c c c (packed integers)
                                ; m = Maps collected | c = Compasses collected
PendantCounter: skip 1          ; Number of pendants collected (integer)
PreGTBKLocations: skip 1        ; Locations checked in GT before finding the big key
                                ; b = Big Bomb Acquired                     | s = Silver Arrows Acquired
                                ; c = GT locations collected before big key
RupeesSpent: skip 2             ; Rupees spent (16-bit integer)
SaveQuitCounter: skip 1         ; Number of times player has saved and quit (integer)
LoopFrames: skip 4              ; Frame counter incremented during frame hook (32-bit integer)
PreBootsLocations: skip 2       ; Number of locations checked before getting boots (integer)
PreMirrorLocations: skip 2      ; Number of locations checked before getting mirror (integer)
PreFluteLocations: skip 2       ; Number of locations checked before getting flute (integer)
skip 2                          ; Unused
OverworldMirrors: skip 1        ; Number of times mirror used on overworld (integer)
UnderworldMirrors: skip 1       ; Number of times mirror used in underworld (integer)
ScreenTransitions: skip 2       ; Number of screen transitions (16-bit integer)
NMIFrames: skip 4               ; Frame counter incremented during NMI hook (32-bit integer)
ChestsOpened: skip 1            ; Number of chests opened. Doesn't count NPC, free standing items etc (integer)
StatsLocked: skip 1             ; Set to $01 when goal is completed; game stops counting stats.
MenuFrames: skip 4              ; Total menu time in frames (32-bit integer)
HeartContainerCounter: skip 1   ; Total number of heart containers collected (integer)
DeathCounter: skip 1            ; Number of deaths (integer)
skip 1                          ; Reserved
FluteCounter: skip 1            ; Number of times fluted (integer)
skip 4                          ;
RNGItem: skip 2                 ; RNG Item
SwordlessBossKills: skip 1      ; Number of bosses killed without a sword (integer)
FaerieRevivalCounter: skip 1    ; Number of faerie revivals (integer)
ChallengeTimer: skip 4          ; Timer used for OHKO etc
SwordTime: skip 4               ; Time first sword found in frames (32-bit integer) 
BootsTime: skip 4               ; Time boots found in frames (32-bit integer)
FluteTime: skip 4               ; Time flute found in frames (32-bit integer)
MirrorTime: skip 4              ; Time mirror found in frames (32-bit integer)
ChestTurnCounter: skip 1        ; Number of chest turns (integer)
CapacityUpgrades: skip 1        ; Number of capacity upgrades collected (integer)
DamageCounter: skip 2           ; Damage taken by player (16-bit integer)
MagicCounter: skip 2            ; Magic used by player (16-bit integer)
HighestMail: skip 1             ; Highest mail level
SmallKeyCounter: skip 1         ; Total Number of small keys collected (integer)     
HeartPieceCounter: skip 1       ; Total Number of heartpieces collected (integer)     
CrystalCounter: skip 1          ; Total Number of crystals collected (integer)     
skip 46                         ; Unused
ServiceRequestReceive:          ;
ServiceRequestTransmit:         ;
ServiceRequest: skip 8          ; Service request block. See servicerequest.asm
skip 42                         ; Unused 
                                ; \  Dungeon locations checked counters (integers)
SewersLocations: skip 1         ;  | Sewer Passage
HCLocations: skip 1             ;  | Hyrule Castle
EPLocations: skip 1             ;  | Eastern Palace
DPLocations: skip 1             ;  | Desert Palace
CTLocations: skip 1             ;  | Agahnim's Tower
SPLocations: skip 1             ;  | Swamp Palace
PDLocations: skip 1             ;  | Palace of Darkness
MMLocations: skip 1             ;  | Misery Mire
SWLocations: skip 1             ;  | Skull Woods
IPLocations: skip 1             ;  | Ice Palace
THLocations: skip 1             ;  | Tower of Hera
TTLocations: skip 1             ;  | Thieves' Town
TRLocations: skip 1             ;  | Turtle Rock
GTLocations: skip 1             ; /  Ganon's Tower
DungeonChestKeys:               ; \  Chest Key Counters. Only counts keys placed in chests. (integers)
SewerChestKeys: skip 1          ;  | Sewer Passage
HCChestKeys: skip 1             ;  | Hyrule Castle
EPChestKeys: skip 1             ;  | Eastern Palace
DPChestKeys: skip 1             ;  | Desert Palace
CTChestKeys: skip 1             ;  | Agahnim's Tower
SPChestKeys: skip 1             ;  | Swamp Palace
PDChestKeys: skip 1             ;  | Palace of Darkness
MMChestKeys: skip 1             ;  | Misery Mire
SWChestKeys: skip 1             ;  | Skull Woods
IPChestKeys: skip 1             ;  | Ice Palace
THChestKeys: skip 1             ;  | Tower of Hera
TTChestKeys: skip 1             ;  | Thieves' Town
TRChestKeys: skip 1             ;  | Turtle Rock
GTChestKeys: skip 1             ; /  Ganon's Tower
skip 2                          ; Reserved, may be indexed into and have junk generic key data written
FileMarker: skip 1              ; $FF = Active save file | $00 = Inactive save file
skip 13                         ; Unused
InverseChecksum: skip 2         ; Vanilla Inverse Checksum. Don't write unless computing checksum.

;================================================================================
; Expanded SRAM ($7F6000 - $7F6FFF)
;--------------------------------------------------------------------------------
; This $1000 byte segment is saved beginning where the second save file was in SRAM
; beginning at $700500
;--------------------------------------------------------------------------------
base $7F6000                    ; $1000 byte buffer we place beginning at second save file
ExtendedFileNameWRAM: skip 24   ; File name, 12 word-length characters.
RoomPotData: skip 592           ; Table for expanded pot shuffle. One word per room.
PurchaseCounts: skip 96         ; Keeps track of shop purchases
PrivateBlock: skip 512          ; Reserved for 3rd party developers
DummyValue: skip 1              ; $01 if you're a real dummy

;================================================================================
; Direct SRAM Assignments ($700000 - $7080000)
;--------------------------------------------------------------------------------
; Label assignments for the actual cartridge SRAM, expanded to 32k. Used mainly
; for burning in values such as the ROM name directly or when we only have to read
; a small amount of data which is not currently in the WRAM mirror.
;--------------------------------------------------------------------------------
base $700000                    ;
skip $0340                      ;
SRAMEquipment: skip 76          ;
InventoryTrackingSRAM: skip 2   ;
BowTrackingSRAM: skip 2         ;
skip 368                        ;
ExtendedFileNameSRAM: skip 24   ; We read and write the file name directly from and to SRAM (24 bytes)
skip $1AE8                      ;
RomNameSRAM: skip 21            ; ROM name from $FFC0, burned in during init (21 bytes)
                                ; If value in the ROM doesn't match SRAM, save is cleared.
RomVersionSRAM: skip 4          ; ALTTPR ROM version. Low byte is the version, high byte writes
                                ; $01 for now (32-bits total)
skip 4071                       ;
PasswordSRAM: skip 16           ; Password value (16 bytes)

base off

;================================================================================
; Assertions
;================================================================================
; Vanilla Assertions
;--------------------------------------------------------------------------------
; All of these need to pass for the base rom to build or something is probably
; very wrong.
;--------------------------------------------------------------------------------
assert WRAMEquipment          = $7EF340, "WRAMEquipment labeled at incorrect address"
assert BowEquipment           = $7EF340, "BowEquipment labeled at incorrect address"
assert BoomerangEquipment     = $7EF341, "BoomerangEquipment labeled at incorrect address"
assert HookshotEquipment      = $7EF342, "HookshotEquipment labeled at incorrect address"
assert BombsEquipment         = $7EF343, "BombsEquipment labeled at incorrect address"
assert PowderEquipment        = $7EF344, "PowderEquipment labeled at incorrect address"
assert FireRodEquipment       = $7EF345, "FireRodEquipment labeled at incorrect address"
assert IceRodEquipment        = $7EF346, "IceRodEquipment labeled at incorrect address"
assert BombosEquipment        = $7EF347, "BombosEquipment labeled at incorrect address"
assert EtherEquipment         = $7EF348, "EtherEquipment labeled at incorrect address"
assert QuakeEquipment         = $7EF349, "QuakeEquipment labeled at incorrect address"
assert LampEquipment          = $7EF34A, "LampEquipment labeled at incorrect address"
assert HammerEquipment        = $7EF34B, "HammerEquipment labeled at incorrect address"
assert FluteEquipment         = $7EF34C, "FluteEquipment labeled at incorrect address"
assert BugNetEquipment        = $7EF34D, "BugNetEquipment labeled at incorrect address"
assert BookOfMudoraEquipment  = $7EF34E, "BookOfMudoraEquipment labeled at incorrect address"
assert BottleIndex            = $7EF34F, "BottleIndex labeled at incorrect address"
assert SomariaEquipment       = $7EF350, "SomariaEquipment labeled at incorrect address"
assert ByrnaEquipment         = $7EF351, "ByrnaEquipment labeled at incorrect address"
assert CapeEquipment          = $7EF352, "CapeEquipment labeled at incorrect address"
assert MirrorEquipment        = $7EF353, "MirrorEquipment labeled at incorrect address"
assert GloveEquipment         = $7EF354, "GloveEquipment labeled at incorrect address"
assert BootsEquipment         = $7EF355, "BootsEquipment labeled at incorrect address"
assert FlippersEquipment      = $7EF356, "FlippersEquipment labeled at incorrect address"
assert MoonPearlEquipment     = $7EF357, "MoonPearlEquipment labeled at incorrect address"
assert SwordEquipment         = $7EF359, "SwordEquipment labeled at incorrect address"
assert ShieldEquipment        = $7EF35A, "ShieldEquipment labeled at incorrect address"
assert ArmorEquipment         = $7EF35B, "ArmorEquipment labeled at incorrect address"
assert BottleContentsOne      = $7EF35C, "BottleContentsOne labeled at incorrect address"
assert BottleContentsTwo      = $7EF35D, "BottleContentsTwo labeled at incorrect address"
assert BottleContentsThree    = $7EF35E, "BottleContentsThree labeled at incorrect address"
assert BottleContentsFour     = $7EF35F, "BottleContentsFour labeled at incorrect address"
assert TargetRupees           = $7EF360, "TargetRupees labeled at incorrect address"
assert CurrentRupees          = $7EF362, "CurrentRupees labeled at incorrect address"
;--------------------------------------------------------------------------------
assert CompassField           = $7EF364, "Compass bitfield labeled at incorrect address"
assert BigKeyField            = $7EF366, "Big Key item bitfield labeled at incorrect address"
assert MapField               = $7EF368, "Map item bitfield labeled at incorrect address"
;--------------------------------------------------------------------------------
assert HeartPieceQuarter      = $7EF36B, "HeartPieceQuarter labeled at incorrect address"
assert HealthCapacity         = $7EF36C, "HealthCapacity labeled at incorrect address"
assert CurrentHealth          = $7EF36D, "CurrentHealth labeled at incorrect address"
assert CurrentMagic           = $7EF36E, "CurrentMagic labeled at incorrect address"
assert CurrentSmallKeys       = $7EF36F, "CurrentSmallKeys labeled at incorrect address"
assert BombCapacityUpgrades   = $7EF370, "BombCapacityUpgrades labeled at incorrect address"
assert ArrowCapacityUpgrades  = $7EF371, "ArrowCapacityUpgrades labeled at incorrect address"
assert HeartsFiller           = $7EF372, "HeartsFiller labeled at incorrect address"
assert MagicFiller            = $7EF373, "MagicFiller labeled at incorrect address"
assert PendantsField          = $7EF374, "PendantsField labeled at incorrect address"
assert BombsFiller            = $7EF375, "BombsFiller labeled at incorrect address"
assert ArrowsFiller           = $7EF376, "ArrowsFiller labeled at incorrect address"
assert CurrentArrows          = $7EF377, "CurrentArrows labeled at incorrect address"
assert AbilityFlags           = $7EF379, "AbilityFlags labeled at incorrect address"
assert CrystalsField          = $7EF37A, "CrystalsField labeled at incorrect address"
assert MagicConsumption       = $7EF37B, "MagicConsumption labeled at incorrect address"
;--------------------------------------------------------------------------------
assert SewerKeys              = $7EF37C, "SewerKeys labeled at incorrect address"
assert HyruleCastleKeys       = $7EF37D, "HyruleCastleKeys labeled at incorrect address"
assert EasternKeys            = $7EF37E, "EasternKeys labeled at incorrect address"
assert DesertKeys             = $7EF37F, "DesertKeys labeled at incorrect address"
assert CastleTowerKeys        = $7EF380, "CastleTowerKeys labeled at incorrect address"
assert SwampKeys              = $7EF381, "SwampKeys labeled at incorrect address"
assert PalaceOfDarknessKeys   = $7EF382, "PalaceOfDarknessKeys labeled at incorrect address"
assert MireKeys               = $7EF383, "MireKeys labeled at incorrect address"
assert SkullWoodsKeys         = $7EF384, "SkullWoodsKeys labeled at incorrect address"
assert IcePalaceKeys          = $7EF385, "IcePalaceKeys labeled at incorrect address"
assert HeraKeys               = $7EF386, "HeraKeys labeled at incorrect address"
assert ThievesTownKeys        = $7EF387, "ThievesTownKeys labeled at incorrect address"
assert TurtleRockKeys         = $7EF388, "TurtleRockKeys labeled at incorrect address"
assert GanonsTowerKeys        = $7EF389, "GanonsTowerKeys labeled at incorrect address"
assert CurrentGenericKeys     = $7EF38B, "CurrentGenericKeys labeled at incorrect address"
;--------------------------------------------------------------------------------
assert ProgressIndicator      = $7EF3C5, "ProgressIndicator labeled at incorrect address"
assert ProgressFlags          = $7EF3C6, "ProgressFlags labeled at incorrect address"
assert MapIcons               = $7EF3C7, "MapIcons labeled at incorrect address"
assert StartingEntrance       = $7EF3C8, "StartingEntrance labeled at incorrect address"
assert NpcFlagsVanilla        = $7EF3C9, "NpcFlagsVanilla labeled at incorrect address"
assert CurrentWorld           = $7EF3CA, "CurrentWorld labeled at incorrect address"
assert FollowerIndicator      = $7EF3CC, "FollowerIndicator labeled at incorrect address"
assert FollowerXCoord         = $7EF3CD, "FollowerXCoord labeled at incorrect address"
assert FollowerYCoord         = $7EF3CF, "FollowerYCoord labeled at incorrect address"
assert DroppedFollowerIndoors = $7EF3D1, "DroppedFollowerIndoors labeled at incorrect address"
assert DroppedFollowerLayer   = $7EF3D2, "DroppedFollowerLayer labeled at incorrect address"
assert FollowerDropped        = $7EF3D3, "FollowerDropped labeled at incorrect address"
assert FileValidity           = $7EF3E1, "FileValidity labeled at incorrect address"
assert InverseChecksum        = $7EF4FE, "InverseChecksum labeled at incorrect address"

;================================================================================
; Randomizer Assertions
;--------------------------------------------------------------------------------
; Trackers and other third party consumers may depend on these values.
;--------------------------------------------------------------------------------
assert InventoryTracking      = $7EF38C, "InventoryTracking labeled at incorrect address"
assert BowTracking            = $7EF38E, "BowTracking labeled at incorrect address"
assert ItemLimitCounts        = $7EF390, "ItemLimitCounts labeled at incorrect address"
;--------------------------------------------------------------------------------
assert GameCounter            = $7EF3FF, "GameCounter labeled at incorrect address"
assert PostGameCounter        = $7EF401, "PostGameCounter labeled at incorrect address"
assert NpcFlags               = $7EF410, "NPCFlags labeled at incorrect address"
assert MapOverlay             = $7EF414, "MapOverlay labeled at incorrect address"
assert GeneralFlags           = $7EF416, "GeneralFlags labeled at incorrect address"
assert HighestSword           = $7EF417, "HighestSword labeled at incorrect address"
assert GoalCounter            = $7EF418, "GoalCounter labeled at incorrect address"
assert ProgrammableItemOne    = $7EF41A, "ProgrammableItemOne labeled at incorrect address"
assert ProgrammableItemTwo    = $7EF41C, "ProgrammableItemTwo labeled at incorrect address"
assert ProgrammableItemThree  = $7EF41E, "ProgrammableItemThree labeled at incorrect address"
assert BonkCounter            = $7EF420, "BonkCounter labeled at incorrect address"
assert YAItemCounter          = $7EF421, "YAItemCounter labeled at incorrect address"
assert HighestShield          = $7EF422, "HighestShield labeled at incorrect address"
assert TotalItemCounter       = $7EF423, "TotalItemCounter labeled at incorrect address"
assert SwordBossKills         = $7EF425, "SwordBossKills labeled at incorrect address"
assert BigKeysBigChests       = $7EF427, "BigKeysBigChests labeled at incorrect address"
assert MapsCompasses          = $7EF428, "MapsCompasses labeled at incorrect address"
assert PendantCounter         = $7EF429, "PendantCounter labeled at incorrect address"
assert PreGTBKLocations       = $7EF42A, "PreGTBKLocations labeled at incorrect address"
assert RupeesSpent            = $7EF42B, "RupeesSpent labeled at incorrect address"
assert SaveQuitCounter        = $7EF42D, "SaveQuitCounter labeled at incorrect address"
assert LoopFrames             = $7EF42E, "LoopFrames labeled at incorrect address"
assert PreBootsLocations      = $7EF432, "PreBootsLocations labeled at incorrect address"
assert PreMirrorLocations     = $7EF434, "PreMirrorLocations labeled at incorrect address"
assert PreFluteLocations      = $7EF436, "PreFluteLocations labeled at incorrect address"
assert OverworldMirrors       = $7EF43A, "OverworldMirrors labeled at incorrect address"
assert UnderworldMirrors      = $7EF43B, "UnderworldMirrors labeled at incorrect address"
assert ScreenTransitions      = $7EF43C, "ScreenTransitions labeled at incorrect address"
assert NMIFrames              = $7EF43E, "NMIFrames labeled at incorrect address"
assert ChestsOpened           = $7EF442, "ChestsOpened labeled at incorrect address"
assert StatsLocked            = $7EF443, "StatsLocked labeled at incorrect address"
assert MenuFrames             = $7EF444, "MenuFrames labeled at incorrect address"
assert HeartContainerCounter  = $7EF448, "HeartContainerCounter labeled at incorrect address"
assert DeathCounter           = $7EF449, "DeathCounter labeled at incorrect address"
assert FluteCounter           = $7EF44B, "FluteCounter labeled at incorrect address"
assert RNGItem                = $7EF450, "RNGItem labeled at incorrect address"
assert SwordlessBossKills     = $7EF452, "SwordlessBossKills labeled at incorrect address"
assert FaerieRevivalCounter   = $7EF453, "FaerieRevivalCounter labeled at incorrect address"
assert ChallengeTimer         = $7EF454, "ChallengeTimer labeled at incorrect address"
assert SwordTime              = $7EF458, "SwordTime labeled at incorrect address"
assert BootsTime              = $7EF45C, "BootsTime labeled at incorrect address"
assert FluteTime              = $7EF460, "FluteTime labeled at incorrect address"
assert MirrorTime             = $7EF464, "MirrorTime labeled at incorrect address"
assert ChestTurnCounter       = $7EF468, "ChestTurnCounter labeled at incorrect address"
assert CapacityUpgrades       = $7EF469, "CapacityUpgrades labeled at incorrect address"
assert DamageCounter          = $7EF46A, "DamageCounter labeled at incorrect address"
assert MagicCounter           = $7EF46C, "MagicCounter labeled at incorrect address"
assert HighestMail            = $7EF46E, "HighestMail labeled at incorrect address"
assert SmallKeyCounter        = $7EF46F, "SmallKeyCounter labeled at incorrect address"
assert HeartPieceCounter      = $7EF470, "HeartPieceCounter labeled at incorrect address"
assert CrystalCounter         = $7EF471, "CrystalCounter labeled at incorrect address"
;--------------------------------------------------------------------------------
assert ServiceRequest         = $7EF4A0, "ServiceRequest labeled at incorrect address"
;--------------------------------------------------------------------------------
assert SewersLocations        = $7EF4D2, "SewersLocations labeled at incorrect address"
assert HCLocations            = $7EF4D3, "HCLocations labeled at incorrect address"
assert EPLocations            = $7EF4D4, "EPLocations labeled at incorrect address"
assert DPLocations            = $7EF4D5, "DPLocations labeled at incorrect address"
assert CTLocations            = $7EF4D6, "CTLocations labeled at incorrect address"
assert SPLocations            = $7EF4D7, "SPLocations labeled at incorrect address"
assert PDLocations            = $7EF4D8, "PDLocations labeled at incorrect address"
assert MMLocations            = $7EF4D9, "MMLocations labeled at incorrect address"
assert SWLocations            = $7EF4DA, "SWLocations labeled at incorrect address"
assert IPLocations            = $7EF4DB, "IPLocations labeled at incorrect address"
assert THLocations            = $7EF4DC, "THLocations labeled at incorrect address"
assert TTLocations            = $7EF4DD, "TTLocations labeled at incorrect address"
assert TRLocations            = $7EF4DE, "TRLocations labeled at incorrect address"
assert GTLocations            = $7EF4DF, "GTLocations labeled at incorrect address"
assert SewerChestKeys         = $7EF4E0, "SewerChestKeys labeled at incorrect address"
assert HCChestKeys            = $7EF4E1, "HCChestKeys labeled at incorrect address"
assert EPChestKeys            = $7EF4E2, "EPChestKeys labeled at incorrect address"
assert DPChestKeys            = $7EF4E3, "DPChestKeys labeled at incorrect address"
assert CTChestKeys            = $7EF4E4, "ATChestKeys labeled at incorrect address"
assert SPChestKeys            = $7EF4E5, "SPChestKeys labeled at incorrect address"
assert PDChestKeys            = $7EF4E6, "PDChestKeys labeled at incorrect address"
assert MMChestKeys            = $7EF4E7, "MMChestKeys labeled at incorrect address"
assert SWChestKeys            = $7EF4E8, "SWChestKeys labeled at incorrect address"
assert IPChestKeys            = $7EF4E9, "IPChestKeys labeled at incorrect address"
assert THChestKeys            = $7EF4EA, "THChestKeys labeled at incorrect address"
assert TTChestKeys            = $7EF4EB, "TTChestKeys labeled at incorrect address"
assert TRChestKeys            = $7EF4EC, "TRChestKeys labeled at incorrect address"
assert GTChestKeys            = $7EF4ED, "GChestKeys labeled at incorrect address"
assert FileMarker             = $7EF4F0, "FileMarker labeled at incorrect address"
;--------------------------------------------------------------------------------
assert ExtendedFileNameWRAM   = $7F6000, "ExtendedFilenameWRAM labeled at incorrect address"
assert RoomPotData            = $7F6018, "RoomPotData labeled at incorrect address"
assert PurchaseCounts         = $7F6268, "PurchaseCounts labeled at incorrect address"
assert PrivateBlock           = $7F62C8, "PrivateBlock labeled at incorrect address"
assert DummyValue             = $7F64C8, "DummyValue labeled at incorrect address"

;================================================================================
; Direct SRAM Assertions
;--------------------------------------------------------------------------------
assert SRAMEquipment          = $700340, "SRAMEquipment labeled at incorrect address"
assert InventoryTrackingSRAM  = $70038C, "InventoryTracking labeled at incorrect address"
assert BowTrackingSRAM        = $70038E, "BowTracking labeled at incorrect address"
assert ExtendedFileNameSRAM   = $700500, "ExtendedFilenameSRAM labeled at incorrect address"
assert RomNameSRAM            = $702000, "RomNameSRAM at incorrect address"
assert RomVersionSRAM         = $702015, "RomVersionSRAM at incorrect address"
assert PasswordSRAM           = $703000, "PasswordSRAM at incorrect address"

;--------------------------------------------------------------------------------
; MOVED TODO
;--------------------------------------------------------------------------------
; CapacityUpgrades: 7ef452 -> 7ef469
; file name: 3e3-3f0, -> 7ef500
; shop purchase counts: 7ef302 -> 7ef51a - 7ef579
; GoalCounter: 7ef418 -> 7ef418 (2 bytes)
;HighestMail: 7ef424 -> 7ef470
;HighestShield: 7ef422 -> swords usingHighestSword, shields removed from general flags
; SmallKeyCounter: 7ef424 -> 7ef471
; ServiceSequence: removed
; SwordsShields: 7ef422 -> swords usingHighestSword
; PreMirrorLocations: 7ef432 -> 7ef434, PreBoots and PreMirror now 2 bytes
; Heart Pieces: 7ef429 ->  7ef470
; Pendant counter: 7ef429, now an integer
; SwordlessBosses: 7ef452, now an integer
; 
; DungeonLocations values and labels moved to block right before ChestKeys block
; starting at address 7ef472
;
; bombs (?), silvers, and pre gtbk at $7ef42a now just pre gtbk
;
; whole file name now at $7F6000/706000, first four still at vanilla location
;
; password_sram: 701000 -> 703000
;--------------------------------------------------------------------------------
; ADDED
;--------------------------------------------------------------------------------
;
; PreFluteLocations      = $7EF436[0x02]
; ServiceRequest         = $7EF4A0[0x08]
; VERSION                = $7F6018[0x04]
; RoomPotData            = $7F601C[0x250]
; PurchaseCounts         = $7F601C[0x60]
; DummyValue             = $7F607C[0x02]
;
;--------------------------------------------------------------------------------
; TODO
;--------------------------------------------------------------------------------
; figure out why ChestsOpened is wrong
;
