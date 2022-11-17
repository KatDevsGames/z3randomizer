;================================================================================
; RAM Labels & Assertions
;--------------------------------------------------------------------------------
; This module is primarily concerned with labeling WRAM addresses used by the
; randomizer and documenting their usage.
;
; See the JP 1.0 disassembly for reference
; (https://github.com/spannerisms/jpdasm/ - 31/10/2022)
;--------------------------------------------------------------------------------
pushpc
org 0

;================================================================================
; Direct Page
;--------------------------------------------------------------------------------
base $7E0000
Scrap:
Scrap00: skip 1  ; Used as short-term scratch space. If you need some short-term
Scrap01: skip 1  ; RAM, you can often use these. Double check that the next use
Scrap02: skip 1  ; of the addresses you want to use is a write.
Scrap03: skip 1  ;
Scrap04: skip 1  ;
Scrap05: skip 1  ;
Scrap06: skip 1  ;
Scrap07: skip 1  ;
Scrap08: skip 1  ;
Scrap09: skip 1  ;
Scrap0A: skip 1  ;
Scrap0B: skip 1  ;
Scrap0C: skip 1  ;
Scrap0D: skip 1  ;
Scrap0E: skip 1  ;
Scrap0F: skip 1  ;


LinkPosY = $7E0020 ; 2 bytes
LinkPosX = $7E0022 ; 2 bytes

RoomIndex = $7E00A0 ; 2 bytes, UW room index

;================================================================================
; Bank 7E
;--------------------------------------------------------------------------------
;================================================================================
; Mirrored WRAM
;--------------------------------------------------------------------------------
; Pages 0x00–0x1F of Bank7E are mirrored to every program bank ALTTP uses.
;--------------------------------------------------------------------------------

CurrentMSUTrack = $7E010B
CurrentVolume = $7E0127
TargetVolume = $7E0129
CurrentControlRequest = $7E0133 ; Last thing written to MusicControlRequest
MusicControl = $7E012B
MusicControlRequest = $7E012C

ItemReceiptID = $7E02D8

NMIAux = $7E0632

SpritePosYLow = $7E0D00 ; all $10 bytes
SpritePosXLow = $7E0D10
SpritePosYHigh = $7E0D20
SpritePosXHigh = $7E0D30

SpriteAuxTable = $7E0DA0 ; 0x1F bytes
SpriteAITable = $7E0DD0

SpriteTypeTable = $7E0E20

SpriteDirectionTable = $7E0EB0

ToastBuffer = $7E1E0E ; 2 bytes DoToast

MSUResumeTime = $7E1E6B ; 4 bytes
MSUResumeControl = $7E1E6F
MSUFallbackTable = $7E1E70 ; 8 bytes
MSUDelayedCommand = $7E1E79
MSUPackCount = $7E1E7A
MSUPackCurrent = $7E1E7B
MSUPackRequest = $7E1E7C
MSULoadedTrack = $7E1E7D ; 2 bytes
MSUResumeTrack = $7E1E7F 

;1E90
ClockHours = $7E1E90 ; Clock Hours
ClockMinutes = $7E1E94 ; Clock Minutes
ClockSeconds = $7E1E98 ; Clock Seconds
ClockBuffer = $7E1E9C ; Clock Temporary
;1EA0
ScratchBufferNV = $7E1EA0 ; Callee preserved
;1EB0
ScratchBufferV = $7E1EB0 ; Caller preserved
;1EC0
;1ED0
;1EE0
;1EF0

;================================================================================
; UNMIRRORED WRAM
; Addresses from here on can only be accessed with long addressing
; or absolute addressing with the appropriate data bank set
;--------------------------------------------------------------------------------

TileUploadBuffer = $7EA180 ; 0x300 bytes
SpriteOAM = $7EC025        ;

; $7EC700 - Tile map buffer for HUD

HUDKeyIcon = $7EC726
HUDGoalIndicator = $7EC72A
HUDPrizeIcon = $7EC742
HUDRupees = $7EC750
HUDBombCount = $7EC75A
HUDArrowCount = $7EC760
HUDKeyDigits = $7EC764

BigRAM = $7EC900           ; Big buffer of free ram (0x1F00)

;================================================================================
; Bank 7F
;--------------------------------------------------------------------------------
base $7F5000
RedrawFlag: skip 1                 ;
skip 2                             ;
HexToDecDigit1: skip 1             ; Space for storing the result of hex to decimal conversion.
HexToDecDigit2: skip 1             ; Digits are stored from high to low.
HexToDecDigit3: skip 1             ;
HexToDecDigit4: skip 1             ;
HexToDecDigit5: skip 1             ;
SpriteSkipEOR: skip 2              ; Used in utilities.asm to determine when to skip drawing sprites. Zero-padded
skip $2B                           ; Unused
AltTextFlag: skip 2                ; dialog.asm: Determines whether to load from vanilla decompression buffer
                                   ; or from a secondary buffer (used for things like free dungeon item text)
BossKills: skip 1                  ;
LagTime: skip 4                    ; Computed during stats preparation for display
RupeesCollected: skip 2            ; Computed during stats preparation for display
NonChestCounter: skip 2            ; Computed during stats preparation for display
skip 2                             ; Unused
TileUploadOffsetOverride: skip 2   ; Offset override for loading sprite gfx
skip 3                             ;
skip 9                             ;
                                   ; Shop Block $7F5050 - $7F506F
ShopId: skip 1                     ; Shop ID. Used for indexing and loading inventory for custom shops
ShopType: skip 1                   ; Shop type. $FF = vanilla shop
                                   ; t - - - - - - -
                                   ; t = Take-any
ShopInventory: skip $0D            ; For three possible shop items, row major:
                                   ; [Item ID][Price low][Price High][Purchase Count]
ShopState: skip 1                  ; - - - - - l c r | Bitfield that determines whether to draw an item
ShopCapacity: skip 1               ; Four lower bits of shop_config in ShopTable, number of items 1-3
ShopScratch: skip 1                ; Scratch byte used in shop drawing routines
ShopSRAMIndex: skip 1              ; SRAM index for purchase counts
ShopMerchant: skip 1               ; Loaded from ShopTable and used to jump to one of four drawing routines
skip 2                             ; Unused
ShopPriceColumn: skip 3            ; Stores coordinates for drawing prices in shops
skip 7                             ;
skip 2                             ; Reserved for OneMind
OneMindId: skip 1                  ; Current OneMind player
OneMindTimerRAM: skip 2            ; Frame counter for OneMind
skip 9                             ; Unused
ClockStatus: skip 2                ; 2 bytes second always zero padding
                                   ; ---- --dn
                                   ; d - DNF mode
                                   ; n - Negative
skip $10                           ; Unused
RNGLockIn: skip 1                  ; Used for RNG item (currently unused by rando)
BusyItem: skip 1                   ; Flags for indicating when these things are "busy"
BusyHealth: skip 1                 ; e.g. doing some animation
BusyMagic: skip 1                  ; 
DialogOffsetPointer: skip 2        ; Offset and return pointer into new dialog buffer used
DialogReturnPointer: skip 2        ; for e.g. free dungeon item text.
skip 1                             ; Unused
PreviousOverworldDoor: skip 1      ; Previous overworld door is cached or initialized here
skip 1                             ; Reserved
skip 1                             ; Unused
DuckMapFlag: skip 1                ; Temporary flag used and reset by flute map drawing routine
StalfosBombDamage: skip 1          ; Relocated from damage table
ValidKeyLoaded: skip 1             ;
TextBoxDefer: skip 1               ; Flag used to defer post-item text boxes
skip $10                           ; Unused
skip $10                           ; Reserved for enemizer
                                   ; Most of these modifiers are intended to be written to by
                                   ; a 3rd party (e.g. Crowd Control.) Writer is responsible
                                   ; for zeroing.
SwordModifier: skip 1              ; Adds level to current sword. Doesn't change graphics.
ShieldModifier: skip 1             ; Not implemented
ArmorModifier: skip 1              ; Adds level to current mail. Doesn't change graphics.
MagicModifier: skip 1              ; Adds level to magic consumption (1/2, 1/4.)
LightConeModifier: skip 1          ; Gives lamp cone when set to 1
CuccoStormer: skip 1               ; Non-zero write causes storm.
OldManDash: skip 1                 ; Unused
IceModifier: skip 1                ; - - - g - - - i | Flipping either sets ice physics
InfiniteArrows: skip 1             ; Setting these to $01 will give infinite ammo. Set by
InfiniteBombs: skip 1              ; EscapeAssist.
InfiniteMagic: skip 1              ;
ControllerInverter: skip 1         ; $01 = D-pad | $02 = Buttons | $03 = Buttons and D-Pad
                                   ; >=$04 = Swap buttons and D-pad
OHKOFlag: skip 1                   ; Any non-zero write sets OHKO mode
SpriteSwapper: skip 1              ; Loads new link sprite and glove/armor palette. No gfx or
                                   ; code currently in base ROM for this.
BootsModifier: skip 1              ; $01 = Give dash ability
skip 1                             ; Unused
                                   ; Crypto Block ($7F50D0 - $7F51FF)
KeyBase: skip $10                  ;
y: skip 4                          ;
z: skip 4                          ;
Sum: skip 4                        ;
p: skip 4                          ;
e: skip 2                          ;
CryptoScratch: skip $0E            ;
CryptoBuffer:                      ;
v: skip $100                       ;
RNGPointers: skip $100             ; Pointers for static RNG
                                   ; Network I/O block. See servicerequest.asm. Rx and Tx channels
                                   ; also allocated 8 persistent bytes each in sram.asm.
RxBuffer: skip $7F                 ;
RxStatus: skip 1                   ;
TxBuffer: skip $7F                 ;
TxStatus: skip 1                   ;
skip $10                           ; Unused
CompassTotalsWRAM: skip $10        ; skip $10
skip $40                           ; Reserved for general dungeon tracking data. May have over
                                   ; allocated here. Feel free to reassign.
skip $40                           ; Unused
skip $260                          ; Unused
DialogBuffer: skip $100            ; Dialog Buffer

;================================================================================
; RAM Assertions
;--------------------------------------------------------------------------------
macro assertRAM(label, address)
  assert <label> = <address>, "<label> labeled at incorrect address."
endmacro

%assertRAM(Scrap00, $7E0000)
%assertRAM(Scrap01, $7E0001)
%assertRAM(Scrap02, $7E0002)
%assertRAM(Scrap03, $7E0003)
%assertRAM(Scrap04, $7E0004)
%assertRAM(Scrap05, $7E0005)
%assertRAM(Scrap06, $7E0006)
%assertRAM(Scrap07, $7E0007)
%assertRAM(Scrap08, $7E0008)
%assertRAM(Scrap09, $7E0009)
%assertRAM(Scrap0A, $7E000A)
%assertRAM(Scrap0B, $7E000B)
%assertRAM(Scrap0C, $7E000C)
%assertRAM(Scrap0D, $7E000D)
%assertRAM(Scrap0E, $7E000E)
%assertRAM(Scrap0F, $7E000F)


%assertRAM(LinkPosY, $7E0020)
%assertRAM(LinkPosX, $7E0022)
%assertRAM(RoomIndex, $7E00A0)
%assertRAM(CurrentMSUTrack, $7E010B)
%assertRAM(CurrentVolume, $7E0127)
%assertRAM(TargetVolume, $7E0129)
%assertRAM(CurrentControlRequest, $7E0133)
%assertRAM(MusicControl, $7E012B)
%assertRAM(MusicControlRequest, $7E012C)
%assertRAM(ItemReceiptID, $7E02D8)
%assertRAM(NMIAux, $7E0632)
%assertRAM(SpritePosYLow, $7E0D00)
%assertRAM(SpritePosXLow, $7E0D10)
%assertRAM(SpritePosYHigh, $7E0D20)
%assertRAM(SpritePosXHigh, $7E0D30)
%assertRAM(SpriteAuxTable, $7E0DA0)
%assertRAM(SpriteAITable, $7E0DD0)
%assertRAM(SpriteTypeTable, $7E0E20)
%assertRAM(SpriteDirectionTable, $7E0EB0)
%assertRAM(ToastBuffer, $7E1E0E)

%assertRAM(MSUResumeTime, $7E1E6B)
%assertRAM(MSUResumeControl, $7E1E6F)
%assertRAM(MSUFallbackTable, $7E1E70)
%assertRAM(MSUDelayedCommand, $7E1E79)
%assertRAM(MSUPackCount, $7E1E7A)
%assertRAM(MSUPackCurrent, $7E1E7B)
%assertRAM(MSUPackRequest, $7E1E7C)
%assertRAM(MSULoadedTrack, $7E1E7D)
%assertRAM(MSUResumeTrack, $7E1E7F)


%assertRAM(ClockHours, $7E1E90)
%assertRAM(ClockMinutes, $7E1E94)
%assertRAM(ClockSeconds, $7E1E98)
%assertRAM(ClockBuffer, $7E1E9C)
%assertRAM(ScratchBufferNV, $7E1EA0)
%assertRAM(ScratchBufferV, $7E1EB0)
%assertRAM(TileUploadBuffer, $7EA180)
%assertRAM(SpriteOAM, $7EC025)
%assertRAM(HUDKeyIcon, $7EC726)
%assertRAM(HUDGoalIndicator, $7EC72A)
%assertRAM(HUDPrizeIcon, $7EC742)
%assertRAM(HUDRupees, $7EC750)
%assertRAM(HUDBombCount, $7EC75A)
%assertRAM(HUDArrowCount, $7EC760)
%assertRAM(HUDKeyDigits, $7EC764)
%assertRAM(BigRAM, $7EC900)
%assertRAM(RedrawFlag, $7F5000)
%assertRAM(HexToDecDigit1, $7F5003)
%assertRAM(HexToDecDigit2, $7F5004)
%assertRAM(HexToDecDigit3, $7F5005)
%assertRAM(HexToDecDigit4, $7F5006)
%assertRAM(HexToDecDigit5, $7F5007)
%assertRAM(SpriteSkipEOR, $7F5008)



%assertRAM(AltTextFlag, $7F5035)
%assertRAM(BossKills, $7F5037)
%assertRAM(LagTime, $7F5038)
%assertRAM(RupeesCollected, $7F503C)
%assertRAM(NonChestCounter, $7F503E)
%assertRAM(TileUploadOffsetOverride, $7F5042)
%assertRAM(ShopId, $7F5050)
%assertRAM(ShopType, $7F5051)
%assertRAM(ShopInventory, $7F5052)
%assertRAM(ShopState, $7F505F)
%assertRAM(ShopCapacity, $7F5060)
%assertRAM(ShopScratch, $7F5061)
%assertRAM(ShopSRAMIndex, $7F5062)
%assertRAM(ShopMerchant, $7F5063)
%assertRAM(ShopPriceColumn, $7F5066)
%assertRAM(OneMindId, $7F5072)
%assertRAM(OneMindTimerRAM, $7F5073)
%assertRAM(ClockStatus, $7F507E)
%assertRAM(RNGLockIn, $7F5090)
%assertRAM(BusyItem, $7F5091)
%assertRAM(BusyHealth, $7F5092)
%assertRAM(BusyMagic, $7F5093)
%assertRAM(DialogOffsetPointer, $7F5094)
%assertRAM(DialogReturnPointer, $7F5096)
%assertRAM(PreviousOverworldDoor, $7F5099)
%assertRAM(DuckMapFlag, $7F509C)
%assertRAM(StalfosBombDamage, $7F509D)
%assertRAM(ValidKeyLoaded, $7F509E)
%assertRAM(TextBoxDefer, $7F509F)
%assertRAM(SwordModifier, $7F50C0)
%assertRAM(ShieldModifier, $7F50C1)
%assertRAM(ArmorModifier, $7F50C2)
%assertRAM(MagicModifier, $7F50C3)
%assertRAM(LightConeModifier, $7F50C4)
%assertRAM(CuccoStormer, $7F50C5)
%assertRAM(OldManDash, $7F50C6)
%assertRAM(IceModifier, $7F50C7)
%assertRAM(InfiniteArrows, $7F50C8)
%assertRAM(InfiniteBombs, $7F50C9)
%assertRAM(InfiniteMagic, $7F50CA)
%assertRAM(ControllerInverter, $7F50CB)
%assertRAM(OHKOFlag, $7F50CC)
%assertRAM(SpriteSwapper, $7F50CD)
%assertRAM(BootsModifier, $7F50CE)
%assertRAM(KeyBase, $7F50D0)
%assertRAM(y, $7F50E0)
%assertRAM(z, $7F50E4)
%assertRAM(Sum, $7F50E8)
%assertRAM(p, $7F50EC)
%assertRAM(e, $7F50F0)
%assertRAM(CryptoScratch, $7F50F2)
%assertRAM(CryptoBuffer, $7F5100)
%assertRAM(v, $7F5100)
%assertRAM(RNGPointers, $7F5200)
%assertRAM(RxBuffer, $7F5300)
%assertRAM(RxStatus, $7F537F)
%assertRAM(TxBuffer, $7F5380)
%assertRAM(TxStatus, $7F53FF)
%assertRAM(CompassTotalsWRAM, $7F5410)
%assertRAM(DialogBuffer, $7F5700)


pullpc
;================================================================================
; Bank 7F
;--------------------------------------------------------------------------------

;OLDSTUFF
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
; $7F5080 - $7F508F - unused
; $7F5090 - RNG Item Lock-In
; $7F5091 - Item Animation Busy Flag
; $7F5092 - Potion Animation Busy Flags (Health)
; $7F5093 - Potion Animation Busy Flags (Magic)
; $7F5094 - Dialog Offset Pointer (Low)
; $7F5095 - Dialog Offset Pointer (High)
; $7F5096 - Dialog Offset Pointer Return (Low)
; $7F5097 - Dialog Offset Pointer Return (High)
; $7F5098 - Unused
; $7F5099 - Last Entered Overworld Door ID
; $7F509A - (Reserved)
; $7F509B - Unused
; $7F509C - Duck Map Flag
; $7F509E - Valid Key Loaded
; $7F509F - Text Box Defer Flag
; $7F50A0 - $7F50AF - Unused

; $7F50B0 - $7F50BF - Downstream Reserved (Enemizer)

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
; $7F50CC - OHKO Flag
; $7F50CD - Sprite Swapper
; $7F50CE - Boots Modifier (0=Off, 1=Always, 2=Never)

; $7F50D0 - $7F50FF - Block Cypher Parameters
; $7F5100 - $7F51FF - Block Cypher Buffer
; $7F5200 - $7F52FF - RNG Pointer Block
; $7F5300 - $7F53FF - Multiworld Block
; $7F5400 - $7F540F - Unused
; $7F5410 - $7F545F - Dungeon Tracking Block
; $7F5460 - $7F56FF - Unused

; $7F5700 - $7F57FF - Dialog Buffer

