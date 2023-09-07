;================================================================================
; RAM Labels & Assertions
;--------------------------------------------------------------------------------
; This module is primarily concerned with labeling WRAM addresses used by the
; randomizer and documenting their usage. We use a combination of base $[address]
; and WRAMLabel = $[address] here, favoring the former when we have larger blocks
; of contiguous ram labeled. A line is skipped when the next address is non-cotiguous,
; but comments will go in the empty space if multi-line. In some cases the label
; name can be descriptive enough without documentation. Or I just didn't know what it was.
;
; See the JP 1.0 disassembly for reference, specifically symbols_wram.asm
; (https://github.com/spannerisms/jpdasm/ - 19/11/2022)
;--------------------------------------------------------------------------------
pushpc
org 0

;================================================================================
; Bank 7E
;--------------------------------------------------------------------------------
;================================================================================
; Direct Page
;--------------------------------------------------------------------------------
base $7E0000
Scrap:
Scrap00: skip 1                   ; Used as short-term scratch space. If you need some short-term
Scrap01: skip 1                   ; RAM, you can often use these. Double check that the next use
Scrap02: skip 1                   ; of the addresses you want to use is a write.
Scrap03: skip 1                   ;
Scrap04: skip 1                   ;
Scrap05: skip 1                   ;
Scrap06: skip 1                   ;
Scrap07: skip 1                   ;
Scrap08: skip 1                   ;
Scrap09: skip 1                   ;
Scrap0A: skip 1                   ;
Scrap0B: skip 1                   ;
Scrap0C: skip 1                   ;
Scrap0D: skip 1                   ;
Scrap0E: skip 1                   ;
Scrap0F: skip 1                   ;
GameMode = $7E0010                ; Game mode & submode. Refer to disassembly.
GameSubMode = $7E0011             ;
NMIDoneFlag = $7E0012             ; $00 = Main loop done | $01 = Not done (lag)
INIDISPQ = $7E0013                ; Queue for INIDISP updates. Written during NMI.
NMISTRIPES = $7E0014              ; NMI update flags.
NMICGRAM = $7E0015                ; When non-zero, will trigger a specific gfx update
NMIHUD = $7E0016                  ; during NMI.
NMIINCR = $7E0017                 ;
NMIUP1100 = $7E0018               ;
UPINCVH = $7E0019                 ; Incremental upload VRAM high byte
LinkAbsoluteY = $7E0020           ; Link's absolute coordinates. Word length
LinkAbsoluteX = $7E0022           ;
FrameCounter = $7E001A            ; Increments every frame that the game isn't lagging
IndoorsFlag = $7E001B             ; $00 = Outdoors | $01 = Indoors
MAINDESQ = $7E001C                ; PPU register queues written during NMI
SUBDESQ = $7E001D                 ;
TMWQ = $7E001E                    ;
TSWQ = $7E001F                    ;
LinkPosY = $7E0020                ; Link's absolute x/y coordinates. Both are word length.
LinkPosX = $7E0022                ;
LinkPosZ = $7E0024                ; $FFFF when on ground
LinkPushDirection = $7E0026       ; - - - - u d l r
LinkRecoilY = $7E0027             ;
LinkRecoilX = $7E0028             ;
LinkRecoilZ = $7E0029             ;
LinkSubPixelVelocty = $7E002A     ; Word length
LinkAnimationStep = $7E002E       ;
LinkDirection = $7E002F           ; $00 = Up | $02 = Down | $04 = Left | $06 = Right
                                  ;
OAMOffsetY = $7E0044              ;
OAMOffsetX = $7E0045              ;
                                  ;
CapeTimer = $7E004C               ; Countdown for cape sapping magic Countdown for cape sapping magic..
LinkJumping = $7E004D             ; $00 = None | $01 = Bonk/damage/water | $02 = Ledge
                                  ;
Strafe = $7E0050                  ; ???
                                  ;
CapeOn = $7E0055                  ; Link invisible and untouchable when set.
BunnyFlagDP = $7E0056             ; $00 = Link | $01 = Bunny
                                  ;
LinkSlipping = $7E005B            ; $00 = None | $01 = Near pit
                                  ; $02 = Falling | $03 = Falling "more"
FallTimer = $7E005C               ; Timer for falling animation
LinkState = $7E005D               ; Main Link state handler
LinkSpeed = $7E005E               ; Main Link speed handler
                                  ;
LinkWalkDirection = $7E0067       ; - - - - u d l r
                                  ;
ScrapBuffer72 = $7E0072           ; Volatile scrap buffer. 5 bytes.
                                  ;
WorldCache = $7E007B              ; $00 = Light world | $40 bit set for dark world.
                                  ;
OverworldIndex = $7E008A          ; Overworld screen index. Word length. Dark world is OR $40 of
                                  ; light world screen in same position. Zeroed on UW entry.
OverlayID = $7E008C               ; Overworld overlay ID. One Byte.
                                  ;
OAMPtr = $7E0090                  ; Pointer used to indirectly address OAM buffer. 4 bytes.
BGMODEQ = $7E0094                 ; Various PPU queues handled during NMI
MOSAICQ = $7E0095                 ;
W12SELQ = $7E0096                 ;
W34SELQ = $7E0097                 ;
WOBJSELQ = $7E0098                ;
CGWSELQ = $7E0099                 ;
CGADSUBQ = $7E009A                ;
HDMAENQ = $7E009B                 ; HDMA enable flags
                                  ;
RoomIndex = $7E00A0               ; Underworld room index. Word length. High byte: $00 = EG1 | $01 = EG2
                                  ; Not zeroed on exit to overworld.
PreviousRoom = $7E00A2            ; Stores previous value of RoomIndex
                                  ;
CameraBoundH = $7E00A6            ; Which set of camera boundaries to use.
CameraBoundV = $7E00A7            ;
                                  ;
RoomTag = $7E00AE                 ; Room effects; e.g. kill room, shutter switch, etc. Word length.
                                  ;
SubSubModule = $7E00B0            ; Often used as a submodule, such as for transitions
                                  ;
ObjPtr = $7E00B7                  ; Pointer for drawing room objects. Three bytes.
ObjPtrOffset = $7E00BA            ; Used as an offset for ObjPointer. Word Length.
PlayerSpriteBank = $7E00BC        ;
ScrapBufferBD = $7E00BD           ; Another scrap buffer. $23 bytes.
FileSelectPosition = $7E00C8      ;
PasswordCodePosition = $7E00C8    ;
PasswordSelectPosition = $7E00C9  ;
                                  ;
BG1H = $7E00E0                    ; Background scroll registers
BG2H = $7E00E2                    ; For BG1 and BG2, these registers are used for calculations later for different writes to PPU.
BG3HOFSQL = $7E00E4               ; For BG3, the values are written directly to the PPU during NMI
BG1V = $7E00E6                    ; Since BG1 and BG2 are not written directly to PPU they are given different names from BG3.
BG2V = $7E00E8                    ;
BG3VOFSQL = $7E00EA               ;
                                  ;
LinkLayer = $7E00EE               ; Layer that Link is on. $00 = BG2 (upper) | $02 = BG1 (lower)
                                  ;
Joy1A_All = $7E00F0               ; Joypad input
Joy2A_All = $7E00F1               ; All = Current & previous frame
Joy1B_All = $7E00F2               ; New = Current frame
Joy2B_All = $7E00F3               ; Old = Previous frame
Joy1A_New = $7E00F4               ;
Joy2A_New = $7E00F5               ;
Joy1B_New = $7E00F6               ;
Joy2B_New = $7E00F7               ;
Joy1A_Old = $7E00F8               ;
Joy2A_Old = $7E00F9               ;
Joy1B_Old = $7E00FA               ;
Joy2B_Old = $7E00FB               ;

;================================================================================
; Mirrored WRAM
;--------------------------------------------------------------------------------
; Pages 0x00–0x1F of Bank7E are mirrored to every program bank ALTTP uses.
;--------------------------------------------------------------------------------

DeathReloadFlag = $7E010A         ; Flag set on death for dungeon reload
CurrentMSUTrack = $7E010B         ;
GameModeCache = $7E010C           ;
GameSubModeCache = $7E010D        ;
EntranceIndex = $7E010E           ; Entrance ID into underworld. Word length.
                                  ;
MedallionFlag = $7E0112           ; Medallion cutscene flag. $01 = Cutscene active.
                                  ;
VRAMUploadAddress = $7E0118       ; Incremental VRAM upload address. Low byte always 0. Word length.
                                  ;
BG1ShakeV = $7E011A               ; Applied to BG Scroll. Word Length.
BG1ShakeH = $7E011C               ;
                                  ;
CurrentVolume = $7E0127           ;
TargetVolume = $7E0129            ;
MusicControl = $7E012B            ;
MusicControlRequest = $7E012C     ;
SFX1 = $7E012D                    ;
SFX2 = $7E012E                    ;
SFX3 = $7E012F                    ;
LastAPUCommand = $7E0130          ; Last non-zero command given to SPC.
LastSFX1 = $7E0131                ; Last non-zero SFX1
MusicControlQueue = $7E0132       ; Used to queue up writes to MusicControlRequest
CurrentControlRequest = $7E0133   ; Last thing written to MusicControlRequest
LastAPU = $7E0134                 ; Stores last anything written to MusicControlRequest
                                  ;
SubModuleInterface = $7E0200      ; Word length. High byte expected to be $00.
ItemCursor = $7E0202              ; Current location of the item menu cursor.
                                  ;
BottleMenuCounter = $7E0205       ; Step counter for opening bottle menu
MenuFrameCounter = $7E0206        ; Incremented every menu frame. Never read.
MenuBlink = $7E0207               ; Incremented every frame and masked with $10 to blink cursor
                                  ;
RaceGameFlag = $7E021B            ;
                                  ;
MessageJunk = $7E0223             ; Zeroed but never used (?)
                                  ;
ShopPurchaseFlag = $7E0224        ; $01 = Shop purchase item receipt.
;CoolScratch = $7E0224            ; 0x5C bytes of free ram
ItemStackPtr = $7E0226            ; Pointer into Item GFX and VRAM target queues. Word length.
                                  ; If not zero, pointer should always be left pointing at the
                                  ; next available slot in the stack during the frame.
SpriteID = $7E0230                ; 0x10 bytes. Receipt ID for main loop sprite we're handling.
SpriteMetaData = $7E0240          ; 0x10 bytes. Sprite metadata. Used for prog bow tracking.
AncillaVelocityZ = $7E0294        ; 0x0A bytes
AncillaZCoord = $7E029E           ; 0x0A bytes
                                  ;
ItemReceiptID = $7E02D8           ;
ItemReceiptPose = $7E02DA         ; $00 = No pose | $01 = One hand up | $02 = Two hands up
                                  ;
BunnyFlag = $7E02E0               ; $00 = Link | $01 = Bunny
Poofing = $7E02E1                 ; Flags cape and bunny poof.
PoofTimer = $7E02E2               ; Countdown timer for poofing.
SwordCooldown = $7E02E3           ; Cooldown for sword after dashing through an enemy.
CutsceneFlag = $7E02E4            ; Flags various cutscenes.
                                  ;
ItemReceiptMethod = $7E02E9       ;
                                  ;
TileActBE = $7E02EF               ; Bitfield used by breakables and entrances. b b b b d d d d
                                  ; b = Breakables | d = Entrances
UseY1 = $7E0301                   ; Bitfield for Y-item usage: b p - a x z h r
                                  ; b = Boomerang                | p = Powder | a = Bow  | x = Hammer (tested, never set)
                                  ; z = Rods (tested, never set) | h = Hammer | r = Rods
CurrentYItem = $7E0303            ;
                                  ;
AButtonAct = $7E0308              ; Bitfield for A-actions. $80 = Carry/toss | $02 Prayer | $01 = Tree pull
CarryAct = $7E0309                ; Bitfield for carrying. $02 = Tossing | $01 = Lifting
                                  ;
TileActIce = $7E0348              ; Bitfield used by ice. Word length.
                                  ;
TileActDig = $7E035B              ; Bitfield used by diggable ground. Word length. High byte unused.
                                  ;
LinkZap = $7E0360                 ; When set, recoil zaps Link.
                                  ;
DamageReceived = $7E0373          ; Damage to deal to Link.
                                  ;
UseY2 = $7E037A                   ; - - b n c h - s
                                  ; b = Book | n = Net | c = Canes | h = Hookshot | s = Shovel
NoDamage = $7E037B                ; Prevents Link from receiving damage.
                                  ;
AncillaGeneral = $7E039F          ; General use buffer for front slot ancillae. $0F bytes.
                                  ;
AncillaTimer = $7E03B1            ; Used as a timer for ancilla.
                                  ;
AncillaSearch = $7E03C4           ; Used to search through ancilla when every front slot is occupied.
                                  ;
ForceSwordUp = $7E03EF            ; $01 = Force sword up pose.
FluteTimer = $7E03F0              ; Countdown timer for being able to use the flute
                                  ;
YButtonOverride = $7E03FC         ; Y override for minigames. $00 = Selected item | $01 = Shovel | $02 = Bow
                                  ;
RoomItemsTaken = $7E0403          ; Items taken in a room: b k u t s e h c
                                  ; b = boss kill/item         | k = key/heart piece (prevents crystals)
                                  ; u = 2nd key/heart piece    | t = chest 4/rupees/swamp drain/bomb floor/mire wall
                                  ; s = chest 3/pod or dp wall | e, h, c = chest 2, 1, 0
DungeonID = $7E040C               ; High byte mostly unused but sometimes read. Word length.
                                  ;
LayerAdjustment = $7E047A         ; Flags layer adjustments. Arms EG.
                                  ;
RoomIndexMirror = $7E048E         ; Mirrors RoomIndex
                                  ;
RespawnFlag = $7E04AA             ; If set, entrance loading is treated as a respawn. Word length.
Map16ChangeIndex = $7E04AC        ; Word length.
                                  ;
OWEntranceCutscene = $7E04C6      ;
                                  ;
HeartBeepTimer = $7E04CA          ;
                                  ;
CameraScrollN = $7E0618           ; Camera scroll trigger areas for directions NSEW
CameraScrollS = $7E061A           ; The higher boundary should always be +2 from the lower in
CameraScrollW = $7E061C           ; underworld and -2 in overworld.
CameraScrollE = $7E061E           ;
                                  ;
NMIAux = $7E0632                  ; Stores long address of NMI jump. Currently only used by shops.
                                  ;
SpriteRoomTag = $7E0642           ; Set high by sprites triggering room tags.
                                  ;
SomariaSwitchFlag = $7E0646       ; Set by Somaria when on a switch.
                                  ;
TileMapEntranceDoors = $7E0696    ; Tilemap location of entrance doors. Word length.
TileMapTile32 = $7E0698           ; Tilemap location of new tile32 objects, such as from graves/rocks. Word length.
                                  ;
SkipOAM = $7E0710                 ; Set to skip OAM updates. High byte written $FF with exploding walls
OWScreenSize = $7E0712            ; Flags overworld screen size.
                                  ;
OAMBuffer = $7E0800               ; Main OAM buffer sent to OAM. $200 bytes.
OAMBuffer2 = $7E0A00              ;
                                  ;
TransparencyFlag = $7E0ABD        ; Flags transparency effects e.g. in Thieves Town Hellway
                                  ;
OWTransitionFlag = $7E0ABF        ; Used for certain transitions like smith, witch, etc.
                                  ;
ItemGFXPtr = $7E0AFA              ; Pointer for item receipt graphics transfers
                                  ; $0000       - no transfer, do nothing
                                  ; bit 7 reset - offset into ROM table
                                  ; bit 7 set   - explicit bank7 address
ItemGFXTarget = $7E0AFC           ; target VRAM address
                                  ;
ArcVariable = $7E0B08             ; Arc variable. Word length.
OverlordXLow = $7E0B08            ; $08 bytes.
OverlordXHigh = $7E0B10           ; $08 bytes.
PlayerNameCursor = $7E0B12        ; Player name screen.
OverlordYLow = $7E0B18            ; $08 bytes.
OverlordYHigh = $7E0B20           ; $08 bytes.
                                  ;
EnemyStunTimer = $7E0B58          ; Auto-decrementing timer for stunned enemies. $10 bytes.
                                  ;
BowDryFire = $7E0B9A              ; If set, arrows are deleted immediately
                                  ;
SaveFileIndex = $7E0B9D           ;
                                  ;
SpriteAncillaInteract = $7E0BA0   ; If nonzero, ancillae do not interact with the sprite. $10 bytes.
                                  ;
AncillaCoordYLow = $7E0BFA        ;
AncillaCoordXLow = $7E0C04        ;
AncillaCoordYHigh = $7E0C0E       ;
AncillaCoordXHigh = $7E0C18       ;
                                  ;
AncillaVelocityY = $7E0C22        ; $0A bytes.
AncillaVelocityX = $7E0C2C        ; $0A bytes.
                                  ;
AncillaID = $7E0C4A               ; $0A bytes.
                                  ;
AncillaGet = $7E0C5E              ; Used by varius ancilla in various ways. $0F bytes.
                                  ;
AncillaLayer = $7E0C7C            ;
                                  ;
SpriteBump = $7E0CD2              ; See symbols_wram.asm. $10 bytes.
                                  ;
TreePullKills = $7E0CFB           ; Kills for tree pulls.
TreePullHits = $7E0CFC            ; Hits taken for tree pulls.
                                  ;
SpritePosYLow = $7E0D00           ; Sprite slot data. Each label has $10 bytes unless otherwise
SpritePosXLow = $7E0D10           ; specified. Some of these I'm not sure what they are. May
SpritePosYHigh = $7E0D20          ; have taken a guess or just made something up.
SpritePosXHigh = $7E0D30          ;
SpriteVelocityY = $7E0D40         ;
SpriteVelocityX = $7E0D50         ;
SpriteSubPixelY = $7E0D60         ;
SpriteSubPixelX = $7E0D70         ;
SpriteActivity = $7E0D80          ; Not sure what this is.
SpriteMovement = $7E0D90          ; Not sure what this is.
                                  ;
SpriteAuxTable = $7E0DA0          ; $20 bytes.
SpriteGFXControl = $7E0DC0        ;
SpriteAITable = $7E0DD0           ; AI state of sprites. $10 bytes.
SpriteMoveDirection = $7E0DE0     ; $00 = Right | $01 = Left | $02 = Down | $03 = Up
                                  ;
SpriteTimer = $7E0DF0             ;
                                  ;
SpriteTypeTable = $7E0E20         ; Which sprite occupies this slot. $10 bytes.
SpriteAux = $7E0E30               ;
SpriteOAMProperties = $7E0E40     ; h m w o o o o o | h = Harmless       | m = master sword? | w = walls?
                                  ;                 | o = OAM allocation
SpriteHitPoints = $7E0E50         ; Set from $0DB173
SpriteControl = $7E0E60           ; n i o s p p p t | n = Death animation? | i = Immune to attack/collion?
                                  ; o = Shadow      | p = OAM prop palette | t = OAM prop name table
SpriteItemType = $7E0E80          ; Sprite Item Type. Also used for jump table local. $10 bytes.
                                  ;
SpriteSpawnStep = $7E0ED0         ; Related to enemies spawning other sprites (eg pikit, zirro)
                                  ;
SpriteDirectionTable = $7E0EB0    ; Sprite direction. $10 bytes.
                                  ;
SpriteHalt = $7E0F00              ;
SpriteTimerE = $7E0F10            ; ?
                                  ;
SpriteLayer = $7E0F20             ;
                                  ;
SpriteOAMProp = $7E0F50           ;
                                  ;
SpriteZCoord = $7E0F70            ;
SpriteVelocityZ = $7E0F80         ;
SpriteSubPixelZ = $7E0F90         ;
                                  ;
CurrentSpriteSlot = $7E0FA0       ; Holds the current sprite/ancilla's index
                                  ;
FreezeSprites = $7E0FC1           ; "Seems to freeze sprites"
                                  ;
PrizePackIndexes = $7E0FC7        ; $07 bytes. One for each prize pack.
                                  ;
SpriteCoordCacheX = $7E0FD8       ;
SpriteCoordCacheY = $7E0FDA       ;
                                  ;
NoMenu = $7E0FFC                  ; When set prevents menu, mirror, medallions
                                  ;
GFXStripes = $7E1000              ; Used by stripes for arbitrary VRAM transfers. $100 bytes.
RoomStripes = $7E1100             ; Used for room drawing.
                                  ;
IrisPtr = $7E1B00                 ; Spotlight pointers for HDMA. $1C0 bytes (?).
                                  ;
MessageSubModule = $7E1CD8        ;
                                  ;
MessageCursor = $7E1CE8           ; Chosen option in message.
DelayTimer = $7E1CE9              ;
                                  ;
TextID = $7E1CF0                  ; Message ID and page. Word length.
                                  ;
UpdateHUDFlag = $7E1E03           ; Flag used to mark HUD updates and avoid heavy code segments.
                                  ;
ToastBuffer = $7E1E0E             ; Multiworld buffer. Word length.
                                  ;
MSUResumeTime = $7E1E6B           ; Mirrored MSU block
MSUResumeControl = $7E1E6F        ;
MSUFallbackTable = $7E1E70        ;
MSUDelayedCommand = $7E1E79       ;
MSUPackCount = $7E1E7A            ;
MSUPackCurrent = $7E1E7B          ;
MSUPackRequest = $7E1E7C          ;
MSULoadedTrack = $7E1E7D          ;
MSUResumeTrack = $7E1E7F          ;

ClockHours = $7E1E90              ; Clock Hours
ClockMinutes = $7E1E94            ; Clock Minutes
ClockSeconds = $7E1E98            ; Clock Seconds
ClockBuffer = $7E1E9C             ; Clock Temporary
ScratchBufferNV = $7E1EA0         ; Non-volatile scratch buffer. Must preserve values through return.
ScratchBufferV = $7E1EB0          ; Volatile scratch buffer. Can clobber at will.

;================================================================================
; UNMIRRORED WRAM
; Addresses from here on can only be accessed with long addressing
; or absolute addressing with the appropriate data bank set
;--------------------------------------------------------------------------------

TileUploadBuffer = $7EA180        ; 0x300 bytes
                                  ;
ItemGetGFX = $7EBD40              ; Item receipt graphics location
                                  ;
RoomFade = $7EC005                ; Flags fade to black on room transitions. Word length.
FadeTimer = $7EC007               ; Timer for transition fading and mosaics. Word length.
FadeDirection = $7EC009           ; Word length
FadeLevel = $7EC00B               ; Target fade level. Word length.
                                  ;
                                  ;
MosaicLevel = $7EC011             ; Word length. High byte unused
                                  ;
RoomDarkness = $7EC017            ; Darkness level of a room. High byte unused. Word length.
                                  ;
SpriteOAM = $7EC025               ;
                                  ;
EN_OWSCR2 = $7EC140               ; $7EC140-$7EC171 Used for caching with entrances.
EN_MAINDESQ = $7EC142             ; Copied from the JP disassembly.
EN_SUBDESQ = $7EC143              ;
EN_BG2VERT = $7EC144              ;
EN_BG2HORZ = $7EC146              ;
EN_POSY = $7EC148                 ;
EN_POSX = $7EC14A                 ;
EN_OWSCR = $7EC14C                ;
EN_OWTMAPI = $7EC14E              ;
EN_SCROLLATN = $7EC150            ;
EN_SCROLLATW = $7EC152            ;
EN_SCROLLAN = $7EC154             ;
EN_SCROLLBN = $7EC156             ;
EN_SCROLLAS = $7EC158             ;
EN_SCROLLBS = $7EC15A             ;
EN_OWTARGN = $7EC15C              ;
EN_OWTARGS = $7EC15E              ;
EN_OWTARGW = $7EC160              ;
EN_OWTARGE = $7EC162              ;
EN_AA0 = $7EC164                  ;
EN_BGSET1 = $7EC165               ;
EN_BGSET2 = $7EC166               ;
EN_SPRSET1 = $7EC167              ;
                                  ; 2 bytes free RAM.
EN_SCRMODYA = $7EC16A             ;
EN_SCRMODYB = $7EC16C             ;
EN_SCRMODXA = $7EC16E             ;
EN_SCRMODXB = $7EC170             ;
PegColor = $7EC172                ;
                                  ;
GameOverSongCache = $7EC227       ;
                                  ;
LastBGSet = $7EC2F8               ; Lists loaded sheets to check for decompression. 4 bytes.
                                  ;
PaletteBufferAux = $7EC300        ; Secondary and main palette buffer. See symbols_wram.asm
PaletteBuffer = $7EC500           ; in the disassembly.
HUDTileMapBuffer = $7EC700        ; HUD tile map buffer. $100 bytes (?)
HUDKeyIcon = $7EC726              ;
HUDGoalIndicator = $7EC72A        ;
HUDPrizeIcon = $7EC742            ;
HUDRupees = $7EC750               ;
HUDBombCount = $7EC75A            ;
HUDArrowCount = $7EC760           ;
HUDKeyDigits = $7EC764            ;
                                  ;
BigRAM = $7EC900                  ; Big buffer of free ram (0x1F00)
ItemGFXStack = $7ECB00            ; Pointers to source of decompressed item tiles deferred to NMI loading.
ItemGFXSBankStack = $7ECB20       ; Source bank byte for above.
ItemTargetStack = $7ECB40         ; Pointers to VRAM targets for ItemGFXStack.
TotalItemCountTiles = $7ECF00     ; Cached total item count tiles for HUD. Four words high to low.

;================================================================================
; Bank 7F
;--------------------------------------------------------------------------------
DecompressionBuffer = $7F0000      ; Decompression Buffer. $2000 bytes.

DecompBuffer2 = $7F4000            ; Another buffer

base $7F5000
RedrawFlag: skip 1                 ;
skip 2                             ; Unused
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
BowTrackingFlags: skip 2           ; Stores tracking bits for progressive bows before resolution to concrete item.
TileUploadOffsetOverride: skip 2   ; Offset override for loading sprite gfx
skip 3                             ;
skip 9                             ;
                                   ; Shop Block $7F5050 - $7F506F
ShopId: skip 1                     ; Shop ID. Used for indexing and loading inventory for custom shops
ShopType: skip 1                   ; Shop type. $FF = vanilla shop
                                   ; t d a v - - q q
                                   ; t = $01 - Take-any | d = $01 - Door check | a = $01 = Take-all
                                   ; v = Use alt vram   | q = Number of items
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
OHKOCached: skip 1                 ; "Old" OHKO flag state. Used to detect changes.
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
CompassTotalsWRAM: skip $10        ; \ Compass and map dungeon HUD display totals. Placed in WRAM
MapTotalsWRAM: skip $10            ; / on boot for tracking.
skip $30                           ; Reserved for general dungeon tracking data. May have over
                                   ; allocated here. Feel free to reassign.
MapCompassFlag: skip 2             ; Used to flag overworld map drawing.
skip $3E                           ; Unused
skip $260                          ; Unused
DialogBuffer: skip $100            ; Dialog Buffer
                                   ;
PrivateBlockWRAM = $7F7700         ; Reserved for 3rd party use. $500 bytes.
                                   ; See also: $200 bytes at PrivateBlockPersistent, copied to SRAM.
BigDecompressionBuffer = $7F8000   ; Reserved for large gfx decompression buffer. $5000 bytes.
                                   ; KEEP THIS AT $8000+
                                   ; its location at an address with bit 7 set is used for detecting
                                   ; ROM location versus RAM locations
                                   ;
MiniGameTime = $7FFE00             ; Time spent in mini game. 32-bits.
MiniGameTimeFinal = $7FFE04        ; Final mini game time. 32 bits.

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
%assertRAM(GameMode, $7E0010)
%assertRAM(GameSubMode, $7E0011)
%assertRAM(NMIDoneFlag, $7E0012)
%assertRAM(INIDISPQ, $7E0013)
%assertRAM(NMISTRIPES, $7E0014)
%assertRAM(NMICGRAM, $7E0015)
%assertRAM(NMIHUD, $7E0016)
%assertRAM(NMIINCR, $7E0017)
%assertRAM(NMIUP1100, $7E0018)
%assertRAM(UPINCVH, $7E0019)
%assertRAM(FrameCounter, $7E001A)
%assertRAM(IndoorsFlag, $7E001B)
%assertRAM(MAINDESQ, $7E001C)
%assertRAM(SUBDESQ, $7E001D)
%assertRAM(TMWQ, $7E001E)
%assertRAM(TSWQ, $7E001F)
%assertRAM(LinkPosY, $7E0020)
%assertRAM(LinkPosX, $7E0022)
%assertRAM(LinkPosZ, $7E0024)
%assertRAM(LinkPushDirection, $7E0026)
%assertRAM(LinkRecoilY, $7E0027)
%assertRAM(LinkRecoilX, $7E0028)
%assertRAM(LinkRecoilZ, $7E0029)
%assertRAM(LinkDirection, $7E002F)
%assertRAM(LinkAnimationStep, $7E002E)
%assertRAM(OAMOffsetY, $7E0044)
%assertRAM(OAMOffsetX, $7E0045)
%assertRAM(CapeTimer, $7E004C)
%assertRAM(LinkJumping, $7E004D)
%assertRAM(Strafe, $7E0050)
%assertRAM(CapeOn, $7E0055)
%assertRAM(BunnyFlagDP, $7E0056)
%assertRAM(LinkSlipping, $7E005B)
%assertRAM(FallTimer, $7E005C)
%assertRAM(LinkState, $7E005D)
%assertRAM(LinkSpeed, $7E005E)
%assertRAM(LinkWalkDirection, $7E0067)
%assertRAM(ScrapBuffer72, $7E0072)
%assertRAM(WorldCache, $7E007B)
%assertRAM(OverworldIndex, $7E008A)
%assertRAM(OverlayID, $7E008C)
%assertRAM(OAMPtr, $7E0090)
%assertRAM(BGMODEQ, $7E0094)
%assertRAM(MOSAICQ, $7E0095)
%assertRAM(W12SELQ, $7E0096)
%assertRAM(W34SELQ, $7E0097)
%assertRAM(WOBJSELQ, $7E0098)
%assertRAM(CGWSELQ, $7E0099)
%assertRAM(CGADSUBQ, $7E009A)
%assertRAM(HDMAENQ, $7E009B)
%assertRAM(RoomIndex, $7E00A0)
%assertRAM(PreviousRoom, $7E00A2)
%assertRAM(CameraBoundH, $7E00A6)
%assertRAM(CameraBoundV, $7E00A7)
%assertRAM(RoomTag, $7E00AE)
%assertRAM(SubSubModule, $7E00B0)
%assertRAM(ObjPtr, $7E00B7)
%assertRAM(ObjPtrOffset, $7E00BA)
%assertRAM(ScrapBufferBD, $7E00BD)
%assertRAM(PlayerSpriteBank, $7E00BC)
%assertRAM(FileSelectPosition, $7E00C8)
%assertRAM(PasswordCodePosition, $7E00C8)
%assertRAM(PasswordSelectPosition, $7E00C9)
%assertRAM(BG1H, $7E00E0)
%assertRAM(BG2H, $7E00E2)
%assertRAM(BG3HOFSQL, $7E00E4)
%assertRAM(BG1V, $7E00E6)
%assertRAM(BG2V, $7E00E8)
%assertRAM(BG3VOFSQL, $7E00EA)
%assertRAM(LinkLayer, $7E00EE)
%assertRAM(DeathReloadFlag, $7E010A)
%assertRAM(CurrentMSUTrack, $7E010B)
%assertRAM(GameModeCache, $7E010C)
%assertRAM(GameSubModeCache, $7E010D)
%assertRAM(EntranceIndex, $7E010E)
%assertRAM(MedallionFlag, $7E0112)
%assertRAM(VRAMUploadAddress, $7E0118)
%assertRAM(BG1ShakeV, $7E011A)
%assertRAM(BG1ShakeH, $7E011C)
%assertRAM(CurrentVolume, $7E0127)
%assertRAM(TargetVolume, $7E0129)
%assertRAM(CurrentControlRequest, $7E0133)
%assertRAM(MusicControl, $7E012B)
%assertRAM(MusicControlRequest, $7E012C)
%assertRAM(SFX1, $7E012D)
%assertRAM(SFX2, $7E012E)
%assertRAM(SFX3, $7E012F)
%assertRAM(LastAPUCommand, $7E0130)
%assertRAM(LastSFX1, $7E0131)
%assertRAM(MusicControlQueue, $7E0132)
%assertRAM(CurrentControlRequest, $7E0133)
%assertRAM(LastAPU, $7E0134)
%assertRAM(SubModuleInterface, $7E0200)
%assertRAM(ItemCursor, $7E0202)
%assertRAM(BottleMenuCounter, $7E0205)
%assertRAM(MenuBlink, $7E0207)
%assertRAM(RaceGameFlag, $7E021B)
%assertRAM(MessageJunk, $7E0223)
%assertRAM(ItemReceiptID, $7E02D8)
%assertRAM(ItemReceiptPose, $7E02DA)
%assertRAM(BunnyFlag, $7E02E0)
%assertRAM(Poofing, $7E02E1)
%assertRAM(PoofTimer, $7E02E2)
%assertRAM(SwordCooldown, $7E02E3)
%assertRAM(CutsceneFlag, $7E02E4)
%assertRAM(ItemReceiptMethod, $7E02E9)
%assertRAM(TileActBE, $7E02EF)
%assertRAM(UseY1, $7E0301)
%assertRAM(CurrentYItem, $7E0303)
%assertRAM(AButtonAct, $7E0308)
%assertRAM(TileActIce, $7E0348)
%assertRAM(TileActDig, $7E035B)
%assertRAM(LinkZap, $7E0360)
%assertRAM(DamageReceived, $7E0373)
%assertRAM(UseY2, $7E037A)
%assertRAM(NoDamage, $7E037B)
%assertRAM(AncillaGeneral, $7E039F)
%assertRAM(AncillaSearch, $7E03C4)
%assertRAM(ForceSwordUp, $7E03EF)
%assertRAM(FluteTimer, $7E03F0)
%assertRAM(YButtonOverride, $7E03FC)
%assertRAM(RoomItemsTaken, $7E0403)
%assertRAM(DungeonID, $7E040C)
%assertRAM(LayerAdjustment, $7E047A)
%assertRAM(RoomIndexMirror, $7E048E)
%assertRAM(RespawnFlag, $7E04AA)
%assertRAM(Map16ChangeIndex, $7E04AC)
%assertRAM(OWEntranceCutscene, $7E04C6)
%assertRAM(HeartBeepTimer, $7E04CA)
%assertRAM(CameraScrollN, $7E0618)
%assertRAM(CameraScrollS, $7E061A)
%assertRAM(CameraScrollW, $7E061C)
%assertRAM(CameraScrollE, $7E061E)
%assertRAM(NMIAux, $7E0632)
%assertRAM(SpriteRoomTag, $7E0642)
%assertRAM(SomariaSwitchFlag, $7E0646)
%assertRAM(TileMapEntranceDoors, $7E0696)
%assertRAM(TileMapTile32, $7E0698)
%assertRAM(SkipOAM, $7E0710)
%assertRAM(OWScreenSize, $7E0712)
%assertRAM(OAMBuffer, $7E0800)
%assertRAM(OAMBuffer2, $7E0A00)
%assertRAM(TransparencyFlag, $7E0ABD)
%assertRAM(OWTransitionFlag, $7E0ABF)
%assertRAM(TreePullKills, $7E0CFB)
%assertRAM(TreePullHits, $7E0CFC)
%assertRAM(ArcVariable, $7E0B08)
%assertRAM(OverlordXLow, $7E0B08)
%assertRAM(OverlordXHigh, $7E0B10)
%assertRAM(OverlordYLow, $7E0B18)
%assertRAM(OverlordYHigh, $7E0B20)
%assertRAM(EnemyStunTimer, $7E0B58)
%assertRAM(BowDryFire, $7E0B9A)
%assertRAM(SaveFileIndex, $7E0B9D)
%assertRAM(SpriteAncillaInteract, $7E0BA0)
%assertRAM(AncillaVelocityY, $7E0C22)
%assertRAM(AncillaVelocityX, $7E0C2C)
%assertRAM(AncillaID, $7E0C4A)
%assertRAM(AncillaGet, $7E0C5E)
%assertRAM(AncillaLayer, $7E0C7C)
%assertRAM(SpriteBump, $7E0CD2)
%assertRAM(SpritePosYLow, $7E0D00)
%assertRAM(SpritePosXLow, $7E0D10)
%assertRAM(SpritePosYHigh, $7E0D20)
%assertRAM(SpritePosXHigh, $7E0D30)
%assertRAM(SpriteVelocityY, $7E0D40)
%assertRAM(SpriteVelocityX, $7E0D50)
%assertRAM(SpriteSubPixelY, $7E0D60)
%assertRAM(SpriteSubPixelX, $7E0D70)
%assertRAM(SpriteActivity, $7E0D80)
%assertRAM(SpriteMovement, $7E0D90)
%assertRAM(SpriteAuxTable, $7E0DA0)
%assertRAM(SpriteGFXControl, $7E0DC0)
%assertRAM(SpriteAITable, $7E0DD0)
%assertRAM(SpriteMoveDirection, $7E0DE0)
%assertRAM(SpriteTimer, $7E0DF0)
%assertRAM(SpriteTypeTable, $7E0E20)
%assertRAM(SpriteAux, $7E0E30)
%assertRAM(SpriteOAMProperties, $7E0E40)
%assertRAM(SpriteHitPoints, $7E0E50)
%assertRAM(SpriteControl, $7E0E60)
%assertRAM(SpriteItemType, $7E0E80)
%assertRAM(SpriteSpawnStep, $7E0ED0)
%assertRAM(SpriteDirectionTable, $7E0EB0)
%assertRAM(SpriteHalt, $7E0F00)
%assertRAM(SpriteTimerE, $7E0F10)
%assertRAM(SpriteLayer, $7E0F20)
%assertRAM(SpriteOAMProp, $7E0F50)
%assertRAM(EN_OWSCR2, $7EC140)
%assertRAM(EN_MAINDESQ, $7EC142)
%assertRAM(EN_SUBDESQ, $7EC143)
%assertRAM(EN_BG2VERT, $7EC144)
%assertRAM(EN_BG2HORZ, $7EC146)
%assertRAM(EN_POSY, $7EC148)
%assertRAM(EN_POSX, $7EC14A)
%assertRAM(EN_OWSCR, $7EC14C)
%assertRAM(EN_OWTMAPI, $7EC14E)
%assertRAM(EN_SCROLLATN, $7EC150)
%assertRAM(EN_SCROLLATW, $7EC152)
%assertRAM(EN_SCROLLAN, $7EC154)
%assertRAM(EN_SCROLLBN, $7EC156)
%assertRAM(EN_SCROLLAS, $7EC158)
%assertRAM(EN_SCROLLBS, $7EC15A)
%assertRAM(EN_OWTARGN, $7EC15C)
%assertRAM(EN_OWTARGS, $7EC15E)
%assertRAM(EN_OWTARGW, $7EC160)
%assertRAM(EN_OWTARGE, $7EC162)
%assertRAM(EN_AA0, $7EC164)
%assertRAM(EN_BGSET1, $7EC165)
%assertRAM(EN_BGSET2, $7EC166)
%assertRAM(EN_SPRSET1, $7EC167)
%assertRAM(EN_SCRMODYA, $7EC16A)
%assertRAM(EN_SCRMODYB, $7EC16C)
%assertRAM(EN_SCRMODXA, $7EC16E)
%assertRAM(EN_SCRMODXB, $7EC170)
%assertRAM(SpriteZCoord, $7E0F70)
%assertRAM(SpriteVelocityZ, $7E0F80)
%assertRAM(SpriteSubPixelZ, $7E0F90)
%assertRAM(CurrentSpriteSlot, $7E0FA0)
%assertRAM(FreezeSprites, $7E0FC1)
%assertRAM(PrizePackIndexes, $7E0FC7)
%assertRAM(SpriteCoordCacheX, $7E0FD8)
%assertRAM(SpriteCoordCacheY, $7E0FDA)
%assertRAM(NoMenu, $7E0FFC)
%assertRAM(GFXStripes, $7E1000)
%assertRAM(RoomStripes, $7E1100)
%assertRAM(IrisPtr, $7E1B00)
%assertRAM(MessageSubModule, $7E1CD8)
%assertRAM(MessageCursor, $7E1CE8)
%assertRAM(DelayTimer, $7E1CE9)
%assertRAM(TextID, $7E1CF0)
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
%assertRAM(RoomFade, $7EC005)
%assertRAM(FadeTimer, $7EC007)
%assertRAM(FadeDirection, $7EC009)
%assertRAM(FadeLevel, $7EC00B)
%assertRAM(MosaicLevel, $7EC011)
%assertRAM(RoomDarkness, $7EC017)
%assertRAM(SpriteOAM, $7EC025)
%assertRAM(PegColor, $7EC172)
%assertRAM(GameOverSongCache, $7EC227)
%assertRAM(LastBGSet, $7EC2F8)
%assertRAM(PaletteBufferAux, $7EC300)
%assertRAM(PaletteBuffer, $7EC500)
%assertRAM(HUDTileMapBuffer, $7EC700)
%assertRAM(HUDKeyIcon, $7EC726)
%assertRAM(HUDGoalIndicator, $7EC72A)
%assertRAM(HUDPrizeIcon, $7EC742)
%assertRAM(HUDRupees, $7EC750)
%assertRAM(HUDBombCount, $7EC75A)
%assertRAM(HUDArrowCount, $7EC760)
%assertRAM(HUDKeyDigits, $7EC764)
%assertRAM(BigRAM, $7EC900)

%assertRAM(DecompressionBuffer, $7F0000)
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
%assertRAM(MapTotalsWRAM, $7F5420)
%assertRAM(MapCompassFlag, $7F5460)
%assertRAM(DialogBuffer, $7F5700)
%assertRAM(MiniGameTime, $7FFE00)
%assertRAM(MiniGameTimeFinal, $7FFE04)

pullpc
