;================================================================================
; SRAM Labels & Assertions
;--------------------------------------------------------------------------------
; Labels for values in SRAM and assertions that ensure they're correct and
; at the expected addresses. All values larger than one byte are little endian.
;--------------------------------------------------------------------------------
; $7EF000 - $7EF4FF in WRAM maps to the first $4FF bytes in SRAM (Bank $70)
; $7F6000 - $7F6FFF in WRAM maps to the next 4k bytes, occupying the 2nd and 3rd vanilla
; save file locations. ($700500 - $701500)
;--------------------------------------------------------------------------------
pushpc
org 0 ; This module writes no bytes. Asar gives bank cross errors without this.
SaveDataWRAM = $7EF000

;================================================================================
; Room Data ($7EF000 - $7EF27F
;--------------------------------------------------------------------------------
; Each room has two bytes. There are 296 ($128) rooms in the ROM. The data beyond
; $7EF24F is unused. The current room index is located at $A0 in WRAM (16-bits.)
;
; The quadrant bits from left to right correspond to quadrants 4 (northwest), 3 (northeast),
; 2 (southwest), and 1 (southeast), which is the same as they are laid out on the screen from
; left to right, top to bottom.
;
; The .l sub-label should be used when the accumulator is in 16-bit mode and we want to
; load both bytes or store to both bytes at once. The .high and .low sub-labels should be used
; when in 8-bit mode and we only want to load or store one byte
;
; Example: We can use RoomDataWRAM[$37].high to read or write the pot key in the first
; floodable room in Swamp Palace (bit $04). To check if a boss has been killed we can
; take the room index for a boss room (e.g. $07 for Tower of Hera) and bitmask $FF00
; like this: RoomDataWRAM[$07].l : AND.w #$FF00
;--------------------------------------------------------------------------------
; .high Byte:  d d d d b k u t
; .low Byte:   s e h c q q q q
;
; d = Door opened (key, bomb wall, etc)
; b = Boss kill / Heart Container
; k = Key / Heart Piece
; u = Second key
; t = Chest 4 / Rupee floor / Swamp drains / Bombable floor / Mire wall
; s = Chest 3 / Bomable floor / PoD or Desert wall
; e = Chest 2
; h = Chest 1
; c = Chest 0
; q = Quadrant visits
;--------------------------------------------------------------------------------
struct RoomDataWRAM $7EF000
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
; be OverworldEventDataWRAM+$1B or OverworldEventDataWRAM+27)
;--------------------------------------------------------------------------------
; - i o - - - b -
;
; i = Free-standing item collected. Also used for sprites like the castle tower barrier
; o = Overlay active
; b = Bomb wall opened
;--------------------------------------------------------------------------------
OverworldEventDataWRAM = $7EF280

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
EquipmentWRAM:                  ;
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
BootsEquipment: skip 1          ; $01 = Boots | This only shows menu item, see: AbilityFlags
FlippersEquipment: skip 1       ; $01 = Flippers
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
CurrentRupees: skip 2           ; \ DisplayRupees holds the number on the HUD. It will always
DisplayRupees: skip 2           ; / increment/decrement to match CurrentRupees if not equal (16-bit integers)
;--------------------------------------------------------------------------------
CompassField: skip 2            ; Dungeon item bitfields
BigKeyField: skip 2             ; Low byte:  w i h b t g - -
MapField: skip 2                ; w = Skull Woods | i = Ice Palace    | h = Hera | b = Thieves' Town
                                ; t = Turtle Rock | g = Ganon's Tower
                                ;------------------------------------------------
                                ; High Byte: x c e d a s p m
                                ; x = Sewers       | c = Hyrule Castle | e = Eastern Palace | d = Desert Palace
                                ; a = Castle Tower | s = Swamp Palace  | p = PoD            | m = Mire
;--------------------------------------------------------------------------------
                                ; HUD & other equipment
skip 1                          ; Wishing Pond Rupee (Unused)
HeartPieceQuarter: skip 1       ; Heart pieces of four for health upgrade. Wraps around to $00 after $03.
MaximumHealth: skip 1           ; \ Max Health & Current Health
CurrentHealth: skip 1           ; / Max value for both is $A0 | $04 = half heart | $08 = heart
CurrentMagic: skip 1            ; Current magic | Max value is $80
CurrentSmallKeys: skip 1        ; Number of small keys held for current dungeon (integer)
BombCapacity: skip 1            ; \ Bomb & Arrow Capacity Upgrades
ArrowCapacity: skip 1           ; / Indicates flatly how many can be held (integers)
HeartsFiller: skip 1            ; Hearts collected yet to be filled. Write in multiples of $08
MagicFiller: skip 1             ; Magic collected yet to be filled
PendantsField: skip 1           ; - - - - - g b r (bitfield)
                                ; g = Green (Courage) | b = Blue (Power) | r = Red (Wisdom)
BombsFiller: skip 1             ; Bombs collected yet to be filled (integer)
ArrowsFiller: skip 1            ; Arrows collected yet to be filled (integer)
CurrentArrows: skip 1           ; Current arrows (integer)
skip 1                          ; Unknown
AbilityFlags: skip 1            ; l r t u p b s h (bitfield)
                                ; l = Lift | r = Read | t = Talk | u = Unused but set by default
                                ; p = Pull | b = Dash | s = Swim | h = Pray (unused)
CrystalsField: skip 1           ; - w b s t i p m (bitfield)
                                ; w = Skull Woods | b = Thieves' Town      | s = Swamp Palace | t = Turtle Rock
                                ; i = Ice Palace  | p = Palace of Darkness | m = Misery Mire
MagicConsumption: skip 1        ; $00 = Normal | $01 = Half Magic | $02 = Quarter Magic
;--------------------------------------------------------------------------------
                                ; Small keys earned per dungeon (integers)
DungeonKeys:                    ;
SewerKeys: skip 1               ; \ HC and Sewers small keys increment together
HyruleCastleKeys: skip 1        ; /
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
InventoryTracking: skip 2       ; - - - - - - o q  b r m p n s k f (bitfield)
                                ; b = Blue Boomerang   | r = Red Boomerang  | m = Mushroom Current
                                ; p = Magic Powder     | n = Mushroom Past  | s = Shovel
                                ; k = Inactive Flute   | f = Active Flute   | o = Any bomb acquired
                                ; q = Quickswap locked
BowTracking: skip 2             ; b s p f - - - -  - - - - - - - - (bitfield)
                                ; b = Any Bow               | s = Silver Arrows Upgrade | p = Second Progressive Bow
                                ; f = First progressive bow
                                ; The front end writes two distinct progressive bow items. p
                                ; indicates whether the "second" has been found independent of
                                ; the first
ItemLimitCounts: skip 16        ; Keeps track of limited non-progressive items such as lamp.
                                ; See: ItemSubstitutionRules in tables.asm
                                ; Right now this is only used for three items but extra space is
                                ; reserved
skip 37                         ; Unused
ProgressIndicator: skip 1       ; $00 = Pre-Uncle | $01 = Post-Uncle item | $02 = Zelda Rescued
                                ; $03 = Agahnim 1 defeated
                                ; $04 and above don't do anything. $00-$02 used in standard mode
ProgressFlags: skip 1           ; - - - h - z - u (bitfield)
                                ; h = Uncle left house | z = Zelda rescued | u = Uncle item obtained
MapIcons: skip 1                ; Used for deciding which icons to display on OW map
                                ; $03 = Pendants  | $04 = Master Sword | $05 = Skull at Hyrule Castle
                                ; $06 = Crystal 1 | $07 = All Crystals | $08 = Skull at Ganon's Tower
StartingEntrance: skip 1        ; Starting entrance to use
                                ; $00 = Link's House         | $01 = Menu or Pyramid w/ Aga dead & mirror
                                ; $02 = Zelda's Cell         | $03 = Secret Passage or HC if entered (escape)
                                ; $04 = Throne Room (escape) | $05 = Old Man Cave w/ Old Man
NpcFlagsVanilla: skip 1         ; - - d p s - b h (bitfield)
                                ; d = Frog rescued         | p = Purple Chest | s = Tree Kid (unused)
                                ; b = Bottle Merchant item | h = Hobo item
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
FileNameVanillaWRAM: skip 8     ; First four characters of file name
FileValidity: skip 2            ; Always $55AA. Don't write.

;================================================================================
; Rando-Specific Assignments & Game Stats ($7EF3F1 - $7EF4FF)
;--------------------------------------------------------------------------------
skip 28                         ; Unused
GameCounter: skip 2             ; Number of deaths and save + quits (16-bit integer)
PostGameCounter: skip 2         ; Initialized to $FFFF, replaced with GameCounter on goal completion
                                ; Number is displayed on file select when not $FFFF. Max 999 (16-bit integer)
CompassCountDisplay: skip 2     ; Compass count display flags (bitfield)
                                ; Sets a flag if the total item count has been displayed on HUD
                                ; Low byte:  w i h b t g - -
                                ; w = Skull Woods | i = Ice Palace    | h = Hera | b = Thieves' Town
                                ; t = Turtle Rock | g = Ganon's Tower
                                ; High Byte: x c e d a s p m
                                ; x = Sewers       | c = Hyrule Castle | e = Eastern Palace | d = Desert Palace
                                ; a = Castle Tower | s = Swamp Palace  | p = PoD            | m = Mire
skip 10                         ;
Aga2Duck: skip 1                ; Used in lieu of pyramid hole for checking if the duck should come
                                ; 0 = Haven't called post-Aga 2 bird | 1 = Have called post-Aga 2 bird
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
skip 1                          ; Unused
DungeonsCompleted: skip 2       ; Bitfield indicating whether a dungeon's prize has been collected.
                                ; This has the same shape as the dungeon item bitfields.
MapCountDisplay: skip 2         ;
CrystalCounter: skip 2          ; Total Number of crystals collected (integer)
skip 40                         ; Unused
ServiceSequence:                ; See servicerequest.asm
ServiceSequenceRx: skip 8       ; Service sequence receive
ServiceSequenceTx: skip 8       ; Service sequence transmit
DungeonAbsorbedKeys:            ; \  Absorbed key counters (integers)
SewerAbsorbedKeys: skip 1       ;  | Sewer Passage
HCAbsorbedKeys: skip 1          ;  | Hyrule Castle
EPAbsorbedKeys: skip 1          ;  | Eastern Palace
DPAbsorbedKeys: skip 1          ;  | Desert Palace
CTAbsorbedKeys: skip 1          ;  | Agahnim's Tower
SPAbsorbedKeys: skip 1          ;  | Swamp Palace
PDAbsorbedKeys: skip 1          ;  | Palace of Darkness
MMAbsorbedKeys: skip 1          ;  | Misery Mire
SWAbsorbedKeys: skip 1          ;  | Skull Woods
IPAbsorbedKeys: skip 1          ;  | Ice Palace
THAbsorbedKeys: skip 1          ;  | Tower of Hera
TTAbsorbedKeys: skip 1          ;  | Thieves' Town
TRAbsorbedKeys: skip 1          ;  | Turtle Rock
GTAbsorbedKeys: skip 1          ; /  Ganon's Tower
skip 2                          ; Reserved for previous table
DungeonLocationsChecked:        ; \  Dungeon locations checked counters (integers)
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
GTLocations: skip 1             ; /  Ganon's Tower:
skip 2                          ; Reserved for previous table
skip 16                         ; Currently occupied by multiworld stuff in DR, can be reclaimed
DungeonCollectedKeys:           ; \  Chest Key Counters. Only counts keys placed in chests. (integers)
SewerCollectedKeys: skip 1      ;  | Sewer Passage
HCCollectedKeys: skip 1         ;  | Hyrule Castle
EPCollectedKeys: skip 1         ;  | Eastern Palace
DPCollectedKeys: skip 1         ;  | Desert Palace
CTCollectedKeys: skip 1         ;  | Agahnim's Tower
SPCollectedKeys: skip 1         ;  | Swamp Palace
PDCollectedKeys: skip 1         ;  | Palace of Darkness
MMCollectedKeys: skip 1         ;  | Misery Mire
SWCollectedKeys: skip 1         ;  | Skull Woods
IPCollectedKeys: skip 1         ;  | Ice Palace
THCollectedKeys: skip 1         ;  | Tower of Hera
TTCollectedKeys: skip 1         ;  | Thieves' Town
TRCollectedKeys: skip 1         ;  | Turtle Rock
GTCollectedKeys: skip 1         ; /  Ganon's Tower
skip 2                          ; Reserved for previous table
FileMarker: skip 1              ; $FF = Active save file | $00 = Inactive save file
skip 13                         ; Unused
InverseChecksumWRAM: skip 2     ; Vanilla Inverse Checksum. Don't write unless computing checksum.

;================================================================================
; Expanded SRAM ($7F6000 - $7F6FFF)
;--------------------------------------------------------------------------------
; This $1000 byte segment is saved beginning where the second save file was in SRAM
; beginning at $700500
;--------------------------------------------------------------------------------
base $7F6000                     ; $1000 byte buffer we place beginning at second save file
ExtendedSaveDataWRAM:            ;
ExtendedFileNameWRAM: skip 24    ; File name, 12 word-length characters.
RoomPotData: skip 592            ; Table for expanded pot shuffle. One word per room.
SpritePotData: skip 592          ; Table for expanded pot shuffle. One word per room.
PurchaseCounts: skip 96          ; Keeps track of shop purchases
PrivateBlockPersistent: skip 513 ; Reserved for 3rd party developers

;================================================================================
; Direct SRAM Assignments ($700000 - $7080000)
;--------------------------------------------------------------------------------
; Label assignments for the actual cartridge SRAM, expanded to 32k. Used mainly
; for burning in values such as the ROM name directly or when we only have to read
; a small amount of data which is not currently in the WRAM mirror.
;--------------------------------------------------------------------------------
base $700000                    ;
CartridgeSRAM:                  ;
RoomDataSRAM:                   ;
skip $280                       ;
OverworldEventDataSRAM:         ;
skip $C0                        ;
EquipmentSRAM: skip 3           ;
BombsEquipmentSRAM: skip 31     ;
DisplayRupeesSRAM: skip 21      ;
CurrentArrowsSRAM: skip 21      ;
InventoryTrackingSRAM: skip 2   ;
BowTrackingSRAM: skip 2         ;
skip 53                         ;
ProgressIndicatorSRAM: skip 1   ;
skip 19                         ;
FileNameVanillaSRAM: skip 8     ; First four characters of file name
FileValiditySRAM: skip 2        ;
skip 283                        ;
InverseChecksumSRAM: skip 2     ;
ExtendedSaveDataSRAM:           ;
ExtendedFileNameSRAM: skip 24   ; We read and write the file name directly from and to SRAM (24 bytes)
skip $1AE4                      ;
RomVersionSRAM: skip 4          ; ALTTPR ROM version. Low byte is the version, high byte writes
                                ; $01 for now (32-bits total)
RomNameSRAM: skip 21            ; ROM name from $FFC0, burned in during init (21 bytes)
                                ; If value in the ROM doesn't match SRAM, save is cleared.
PasswordSRAM: skip 16           ; Password value (16 bytes)
skip 8155                       ;
SaveBackupSRAM:                 ; Backup copy of save ram. Game will attempt to use this if
                                ; checksum on file select screen load fails.
base off

;================================================================================
; Assertions
;================================================================================
macro assertSRAM(label, address)
  assert <label> = <address>, "<label> labeled at incorrect address."
endmacro

;================================================================================
; Vanilla Assertions
;--------------------------------------------------------------------------------
; All of these need to pass for the base rom to build or something is probably
; very wrong.
;--------------------------------------------------------------------------------
%assertSRAM(EquipmentWRAM, $7EF340)
%assertSRAM(BowEquipment, $7EF340)
%assertSRAM(BoomerangEquipment, $7EF341)
%assertSRAM(HookshotEquipment, $7EF342)
%assertSRAM(BombsEquipment, $7EF343)
%assertSRAM(PowderEquipment, $7EF344)
%assertSRAM(FireRodEquipment, $7EF345)
%assertSRAM(IceRodEquipment, $7EF346)
%assertSRAM(BombosEquipment, $7EF347)
%assertSRAM(EtherEquipment, $7EF348)
%assertSRAM(QuakeEquipment, $7EF349)
%assertSRAM(LampEquipment, $7EF34A)
%assertSRAM(HammerEquipment, $7EF34B)
%assertSRAM(FluteEquipment, $7EF34C)
%assertSRAM(BugNetEquipment, $7EF34D)
%assertSRAM(BookOfMudoraEquipment, $7EF34E)
%assertSRAM(BottleIndex, $7EF34F)
%assertSRAM(SomariaEquipment, $7EF350)
%assertSRAM(ByrnaEquipment, $7EF351)
%assertSRAM(CapeEquipment, $7EF352)
%assertSRAM(MirrorEquipment, $7EF353)
%assertSRAM(GloveEquipment, $7EF354)
%assertSRAM(BootsEquipment, $7EF355)
%assertSRAM(FlippersEquipment, $7EF356)
%assertSRAM(MoonPearlEquipment, $7EF357)
%assertSRAM(SwordEquipment, $7EF359)
%assertSRAM(ShieldEquipment, $7EF35A)
%assertSRAM(ArmorEquipment, $7EF35B)
%assertSRAM(BottleContentsOne, $7EF35C)
%assertSRAM(BottleContentsTwo, $7EF35D)
%assertSRAM(BottleContentsThree, $7EF35E)
%assertSRAM(BottleContentsFour, $7EF35F)
%assertSRAM(CurrentRupees, $7EF360)
%assertSRAM(DisplayRupees, $7EF362)
;--------------------------------------------------------------------------------
%assertSRAM(CompassField, $7EF364)
%assertSRAM(BigKeyField, $7EF366)
%assertSRAM(MapField, $7EF368)
;--------------------------------------------------------------------------------
%assertSRAM(HeartPieceQuarter, $7EF36B)
%assertSRAM(MaximumHealth, $7EF36C)
%assertSRAM(CurrentHealth, $7EF36D)
%assertSRAM(CurrentMagic, $7EF36E)
%assertSRAM(CurrentSmallKeys, $7EF36F)
%assertSRAM(BombCapacity, $7EF370)
%assertSRAM(ArrowCapacity, $7EF371)
%assertSRAM(HeartsFiller, $7EF372)
%assertSRAM(MagicFiller, $7EF373)
%assertSRAM(PendantsField, $7EF374)
%assertSRAM(BombsFiller, $7EF375)
%assertSRAM(ArrowsFiller, $7EF376)
%assertSRAM(CurrentArrows, $7EF377)
%assertSRAM(AbilityFlags, $7EF379)
%assertSRAM(CrystalsField, $7EF37A)
%assertSRAM(MagicConsumption, $7EF37B)
;--------------------------------------------------------------------------------
%assertSRAM(DungeonKeys, $7EF37C)
%assertSRAM(SewerKeys, $7EF37C)
%assertSRAM(HyruleCastleKeys, $7EF37D)
%assertSRAM(EasternKeys, $7EF37E)
%assertSRAM(DesertKeys, $7EF37F)
%assertSRAM(CastleTowerKeys, $7EF380)
%assertSRAM(SwampKeys, $7EF381)
%assertSRAM(PalaceOfDarknessKeys, $7EF382)
%assertSRAM(MireKeys, $7EF383)
%assertSRAM(SkullWoodsKeys, $7EF384)
%assertSRAM(IcePalaceKeys, $7EF385)
%assertSRAM(HeraKeys, $7EF386)
%assertSRAM(ThievesTownKeys, $7EF387)
%assertSRAM(TurtleRockKeys, $7EF388)
%assertSRAM(GanonsTowerKeys, $7EF389)
%assertSRAM(CurrentGenericKeys, $7EF38B)
;--------------------------------------------------------------------------------
%assertSRAM(ProgressIndicator, $7EF3C5)
%assertSRAM(ProgressFlags, $7EF3C6)
%assertSRAM(MapIcons, $7EF3C7)
%assertSRAM(StartingEntrance, $7EF3C8)
%assertSRAM(NpcFlagsVanilla, $7EF3C9)
%assertSRAM(CurrentWorld, $7EF3CA)
%assertSRAM(FollowerIndicator, $7EF3CC)
%assertSRAM(FollowerXCoord, $7EF3CD)
%assertSRAM(FollowerYCoord, $7EF3CF)
%assertSRAM(DroppedFollowerIndoors, $7EF3D1)
%assertSRAM(DroppedFollowerLayer, $7EF3D2)
%assertSRAM(FollowerDropped, $7EF3D3)
%assertSRAM(FileNameVanillaWRAM, $7EF3D9)
%assertSRAM(FileValidity, $7EF3E1)
%assertSRAM(InverseChecksumWRAM, $7EF4FE)

;================================================================================
; Randomizer Assertions
;--------------------------------------------------------------------------------
; Trackers and other third party consumers may depend on these values.
;--------------------------------------------------------------------------------
%assertSRAM(InventoryTracking, $7EF38C)
%assertSRAM(BowTracking, $7EF38E)
%assertSRAM(ItemLimitCounts, $7EF390)
;--------------------------------------------------------------------------------
%assertSRAM(GameCounter, $7EF3FF)
%assertSRAM(PostGameCounter, $7EF401)
%assertSRAM(CompassCountDisplay, $7EF403)
%assertSRAM(Aga2Duck, $7EF40F)
%assertSRAM(NpcFlags, $7EF410)
%assertSRAM(MapOverlay, $7EF414)
%assertSRAM(HudFlag, $7EF416)
%assertSRAM(IgnoreFaeries, $7EF416)
%assertSRAM(HasGroveItem, $7EF416)
%assertSRAM(GeneralFlags, $7EF416)
%assertSRAM(HighestSword, $7EF417)
%assertSRAM(GoalCounter, $7EF418)
%assertSRAM(ProgrammableItemOne, $7EF41A)
%assertSRAM(ProgrammableItemTwo, $7EF41C)
%assertSRAM(ProgrammableItemThree, $7EF41E)
%assertSRAM(BonkCounter, $7EF420)
%assertSRAM(YAItemCounter, $7EF421)
%assertSRAM(HighestShield, $7EF422)
%assertSRAM(TotalItemCounter, $7EF423)
%assertSRAM(SwordBossKills, $7EF425)
%assertSRAM(BigKeysBigChests, $7EF427)
%assertSRAM(MapsCompasses, $7EF428)
%assertSRAM(PendantCounter, $7EF429)
%assertSRAM(PreGTBKLocations, $7EF42A)
%assertSRAM(RupeesSpent, $7EF42B)
%assertSRAM(SaveQuitCounter, $7EF42D)
%assertSRAM(LoopFrames, $7EF42E)
%assertSRAM(PreBootsLocations, $7EF432)
%assertSRAM(PreMirrorLocations, $7EF434)
%assertSRAM(PreFluteLocations, $7EF436)
%assertSRAM(OverworldMirrors, $7EF43A)
%assertSRAM(UnderworldMirrors, $7EF43B)
%assertSRAM(ScreenTransitions, $7EF43C)
%assertSRAM(NMIFrames, $7EF43E)
%assertSRAM(ChestsOpened, $7EF442)
%assertSRAM(StatsLocked, $7EF443)
%assertSRAM(MenuFrames, $7EF444)
%assertSRAM(HeartContainerCounter, $7EF448)
%assertSRAM(DeathCounter, $7EF449)
%assertSRAM(FluteCounter, $7EF44B)
%assertSRAM(RNGItem, $7EF450)
%assertSRAM(SwordlessBossKills, $7EF452)
%assertSRAM(FaerieRevivalCounter, $7EF453)
%assertSRAM(ChallengeTimer, $7EF454)
%assertSRAM(SwordTime, $7EF458)
%assertSRAM(BootsTime, $7EF45C)
%assertSRAM(FluteTime, $7EF460)
%assertSRAM(MirrorTime, $7EF464)
%assertSRAM(ChestTurnCounter, $7EF468)
%assertSRAM(CapacityUpgrades, $7EF469)
%assertSRAM(DamageCounter, $7EF46A)
%assertSRAM(MagicCounter, $7EF46C)
%assertSRAM(HighestMail, $7EF46E)
%assertSRAM(SmallKeyCounter, $7EF46F)
%assertSRAM(HeartPieceCounter, $7EF470)
%assertSRAM(DungeonsCompleted, $7EF472)
%assertSRAM(MapCountDisplay, $7EF474)
%assertSRAM(CrystalCounter, $7EF476)
;--------------------------------------------------------------------------------
%assertSRAM(ServiceSequence, $7EF4A0)
%assertSRAM(ServiceSequenceRx, $7EF4A0)
%assertSRAM(ServiceSequenceTx, $7EF4A8)
;--------------------------------------------------------------------------------
%assertSRAM(DungeonAbsorbedKeys, $7EF4B0)
%assertSRAM(SewerAbsorbedKeys, $7EF4B0)
%assertSRAM(HCAbsorbedKeys, $7EF4B1)
%assertSRAM(EPAbsorbedKeys, $7EF4B2)
%assertSRAM(DPAbsorbedKeys, $7EF4B3)
%assertSRAM(CTAbsorbedKeys, $7EF4B4)
%assertSRAM(SPAbsorbedKeys, $7EF4B5)
%assertSRAM(PDAbsorbedKeys, $7EF4B6)
%assertSRAM(MMAbsorbedKeys, $7EF4B7)
%assertSRAM(SWAbsorbedKeys, $7EF4B8)
%assertSRAM(IPAbsorbedKeys, $7EF4B9)
%assertSRAM(THAbsorbedKeys, $7EF4BA)
%assertSRAM(TTAbsorbedKeys, $7EF4BB)
%assertSRAM(TRAbsorbedKeys, $7EF4BC)
%assertSRAM(GTAbsorbedKeys, $7EF4BD)
%assertSRAM(DungeonLocationsChecked, $7EF4C0)
%assertSRAM(SewersLocations, $7EF4C0)
%assertSRAM(HCLocations, $7EF4C1)
%assertSRAM(EPLocations, $7EF4C2)
%assertSRAM(DPLocations, $7EF4C3)
%assertSRAM(CTLocations, $7EF4C4)
%assertSRAM(SPLocations, $7EF4C5)
%assertSRAM(PDLocations, $7EF4C6)
%assertSRAM(MMLocations, $7EF4C7)
%assertSRAM(SWLocations, $7EF4C8)
%assertSRAM(IPLocations, $7EF4C9)
%assertSRAM(THLocations, $7EF4CA)
%assertSRAM(TTLocations, $7EF4CB)
%assertSRAM(TRLocations, $7EF4CC)
%assertSRAM(GTLocations, $7EF4CD)
%assertSRAM(DungeonCollectedKeys, $7EF4E0)
%assertSRAM(SewerCollectedKeys, $7EF4E0)
%assertSRAM(HCCollectedKeys, $7EF4E1)
%assertSRAM(EPCollectedKeys, $7EF4E2)
%assertSRAM(DPCollectedKeys, $7EF4E3)
%assertSRAM(CTCollectedKeys, $7EF4E4)
%assertSRAM(SPCollectedKeys, $7EF4E5)
%assertSRAM(PDCollectedKeys, $7EF4E6)
%assertSRAM(MMCollectedKeys, $7EF4E7)
%assertSRAM(SWCollectedKeys, $7EF4E8)
%assertSRAM(IPCollectedKeys, $7EF4E9)
%assertSRAM(THCollectedKeys, $7EF4EA)
%assertSRAM(TTCollectedKeys, $7EF4EB)
%assertSRAM(TRCollectedKeys, $7EF4EC)
%assertSRAM(GTCollectedKeys, $7EF4ED)
%assertSRAM(FileMarker, $7EF4F0)
;--------------------------------------------------------------------------------
%assertSRAM(ExtendedSaveDataWRAM, $7F6000)
%assertSRAM(ExtendedFileNameWRAM, $7F6000)
%assertSRAM(RoomPotData, $7F6018)
%assertSRAM(SpritePotData, $7F6268)
%assertSRAM(PurchaseCounts, $7F64B8)
%assertSRAM(PrivateBlockPersistent, $7F6518)

;================================================================================
; Direct SRAM Assertions
;--------------------------------------------------------------------------------
%assertSRAM(CartridgeSRAM, $700000)
%assertSRAM(RoomDataSRAM, $700000)
%assertSRAM(OverworldEventDataSRAM, $700280)
%assertSRAM(EquipmentSRAM, $700340)
%assertSRAM(BombsEquipmentSRAM, $700343)
%assertSRAM(DisplayRupeesSRAM, $700362)
%assertSRAM(CurrentArrowsSRAM, $700377)
%assertSRAM(InventoryTrackingSRAM, $70038C)
%assertSRAM(BowTrackingSRAM, $70038E)
%assertSRAM(ProgressIndicatorSRAM, $7003C5)
%assertSRAM(FileNameVanillaSRAM, $7003D9)
%assertSRAM(FileValiditySRAM, $7003E1)
%assertSRAM(InverseChecksumSRAM, $7004FE)
%assertSRAM(ExtendedSaveDataSRAM, $700500)
%assertSRAM(ExtendedFileNameSRAM, $700500)
%assertSRAM(RomVersionSRAM, $701FFC)
%assertSRAM(RomNameSRAM, $702000)
%assertSRAM(PasswordSRAM, $702015)
%assertSRAM(SaveBackupSRAM, $704000)

pullpc
