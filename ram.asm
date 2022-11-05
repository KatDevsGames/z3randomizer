;================================================================================
; RAM Labels & Assertions
;--------------------------------------------------------------------------------
; This module is primarily concerned with labeling WRAM addresses used by the
; randomizer and documenting their usage.
;
; See the JP 1.0 disassembly for reference as well
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

SpritePosYLow = $7E0D00 ; all $10 bytes
SpritePosXLow = $7E0D10
SpritePosYHigh = $7E0D20
SpritePosXHigh = $7E0D30

SpriteAuxTable = $7E0DA0 ; 0x1F bytes
SpriteAITable = $7E0DD0

SpriteTypeTable = $7E0E20

SpriteDirectionTable = $7E0EB0

ToastBuffer = $7E1E0E ; 2 bytes DoToast

ScratchBufferNV = $7E1E70 ; Callee preserved, not ok to clobber
ScratchBufferV = $7E1E80 ; Caller preserved, okay to clobber

;1E90
ClockHours = $7E1E90 ; Clock Hours
ClockMinutes = $7E1E94 ; Clock Minutes
ClockSeconds = $7E1E98 ; Clock Seconds
ClockBuffer = $7E1E9C ; Clock Temporary
;1EA0
;1EB0
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
RedrawFlag = $7F5000

SpriteSkipEOR = $7F5008

MSReceived = $7F5031
; GanonWarpChain = $7F5032
ForceHeartSpawn = $7F5033
SkipHeartSave = $7F5034
AltTextFlag = $7F5035 ; two bytes, next must be zero. 0=disable
BossKills = $7F5037
LagTime = $7F5038
RupeesCollected = $7F503C ; 2 bytes
NonChestCounter = $7F503E

TileUploadOffsetOverride = $7F5042

NMIAux = $7F5044

ShopId = $7F5050
ShopType = $7F5051
ShopInventory = $7F5052 ; 0x0C
ShopState = $7F505F
ShopCapacity = $7F5060
ShopScratch = $7F5061
ShopSRAMIndex = $7F5062
ShopMerchant = $7F5063
; ShopDMATimer = $7F5064 unused
ShopPriceColumn = $7F5066 ; two bytes

OneMindId = $7F5072
OneMindTimerRAM = $7F5073

ClockStatus = $7F507E ; 2 bytes 
                      ; ---- --dn
                      ; d - dnf
                      ; n - negative

RNGLockIn = $7F5090 ; RNG Item
BusyItem = $7F5091
BusyHealth = $7F5092
BusyMagic = $7F5093
DialogOffsetPointer = $7F5094 ; 2 bytes
DialogReturnPointer = $7F5096 ; 2 bytes

StalfosBombDamage = $7F509D
ValidKeyLoaded = $7F509E

SwordModifier = $7F50C0
ShieldModifier = $7F50C1 ; not implemented
ArmorModifier = $7F50C2
MagicModifier = $7F50C3
LightConeModifier = $7F50C4
CuccoStormer = $7F50C5 ; non-zero write causes storm, needs to be zeroed
OldManDash = $7F50C6
IceModifier = $7F50C7
InfiniteArrows = $7F50C8
InfiniteBombs = $7F50C9
InfiniteMagic = $7F50CA
DPadInverter = $7F50CB ; fill in values
OHKOFlag = $7F50CC
SpriteSwapper = $7F50CD
BootsModifier = $7F50CE

; $7F50D0 - $7F50FF - Block Cypher Parameters
; $7F5100 - $7F51FF - Block Cypher Buffer

; Crypto buffer ($7F50D0 - $7F51FF)
KeyBase = $7F50D0
y = $7F50E0
z = $7F50E4
Sum = $7F50E8
p = $7F50EC
e = $7F50F0
CryptoScratch = $7F50F2
CryptoBuffer = $7F5100
v = $7F5100

RNGPointers = $7F5200 ; $FF bytes 

RxBuffer = $7F5300 ; $00-$5F buffer $60-7E reserved
RxStatus = $7F537F ; 1 byte
TxBuffer = $7F5380 ; $80 - $EF buffer $F0 - $FE reserved
TxStatus = $7F53FF ; $F0 - $FE

MSUFallbackTable = $7F5460 ; 8 bytes
MSUDelayedCommand = $7F5469
MSUPackCount = $7F546A
MSUPackCurrent = $7F546B
MSUPackRequest = $7F546C
MSULoadedTrack = $7F546D ; 2 bytes
MSUResumeTrack = $7F546F 
MSUResumeTime = $7F5470 ; 4 bytes
MSUResumeControl = $7F5474 

CompassTotalsWRAM = $7F5410

DialogBuffer = $7F5700 ; $FF bytes

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
%assertRAM(CurrentMSUTrack, $7E010B)
%assertRAM(CurrentVolume, $7E0127)
%assertRAM(TargetVolume, $7E0129)
%assertRAM(CurrentControlRequest, $7E0133)
%assertRAM(MusicControl, $7E012B)
%assertRAM(MusicControlRequest, $7E012C)
%assertRAM(ItemReceiptID, $7E02D8)
%assertRAM(SpritePosYLow, $7E0D00)
%assertRAM(SpritePosXLow, $7E0D10)
%assertRAM(SpritePosYHigh, $7E0D20)
%assertRAM(SpritePosXHigh, $7E0D30)
%assertRAM(SpriteAuxTable, $7E0DA0)
%assertRAM(SpriteAITable, $7E0DD0)
%assertRAM(SpriteTypeTable, $7E0E20)
%assertRAM(SpriteDirectionTable, $7E0EB0)
%assertRAM(ToastBuffer, $7E1E0E)
%assertRAM(ScratchBufferNV, $7E1E70)
%assertRAM(ScratchBufferV, $7E1E80)
%assertRAM(ClockHours, $7E1E90)
%assertRAM(ClockMinutes, $7E1E94)
%assertRAM(ClockSeconds, $7E1E98)
%assertRAM(ClockBuffer, $7E1E9C)
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
%assertRAM(SpriteSkipEOR, $7F5008)
%assertRAM(MSReceived, $7F5031)
%assertRAM(ForceHeartSpawn, $7F5033)
%assertRAM(SkipHeartSave, $7F5034)
%assertRAM(AltTextFlag, $7F5035)
%assertRAM(BossKills, $7F5037)
%assertRAM(LagTime, $7F5038)
%assertRAM(RupeesCollected, $7F503C)
%assertRAM(NonChestCounter, $7F503E)
%assertRAM(TileUploadOffsetOverride, $7F5042)
%assertRAM(NMIAux, $7F5044)
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
%assertRAM(StalfosBombDamage, $7F509D)
%assertRAM(ValidKeyLoaded, $7F509E)
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
%assertRAM(DPadInverter, $7F50CB)
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
%assertRAM(MSUFallbackTable, $7F5460)
%assertRAM(MSUDelayedCommand, $7F5469)
%assertRAM(MSUPackCount, $7F546A)
%assertRAM(MSUPackCurrent, $7F546B)
%assertRAM(MSUPackRequest, $7F546C)
%assertRAM(MSULoadedTrack, $7F546D)
%assertRAM(MSUResumeTrack, $7F546F)
%assertRAM(MSUResumeTime, $7F5470)
%assertRAM(MSUResumeControl, $7F5474)
%assertRAM(CompassTotalsWRAM, $7F5410)
%assertRAM(DialogBuffer, $7F5700)


pullpc
;================================================================================
; Bank 7F
;--------------------------------------------------------------------------------

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
; $7F5010 - Unused
; $7F5020 - Unused
; $7F5030 - Unused
; $7F5031 - HUD Master Sword Flag
; $7F5032 - Unused
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
; $7F5041 - Unused
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
; $7F5098 - Water Entry Index
; $7F5099 - Last Entered Overworld Door ID
; $7F509A - (Reserved)
; $7F509B - Unused
; $7F509C - Unused
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
; $7F5460 - $7F549F - MSU Block
; $7F54A0 - $7F56FF - Unused

; $7F5700 - $7F57FF - Dialog Buffer

