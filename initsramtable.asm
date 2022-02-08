;================================================================================
; Initial SRAM table.
;--------------------------------------------------------------------------------
; The ROM copies blocks of bytes from here on save file init. This table has an
; identical layout to the first $500 bytes of SRAM, although some values such as
; the file validity value, file name, and inverse checksum are skipped.
;
; NOTE: Set InitProgressIndicator to $80 for standard mode with instant post-aga
; world state
;
; See sram.asm for further documentation on how to write to this table.
;--------------------------------------------------------------------------------

fillword $0000 ; Zero out the table
fill $500      ;

org $30B000 ; PC 0x183000
InitRoomDataWRAM:
org $30B060 ; PC 0x183060
InitATAltarRoom: dw $0000 ; aga curtains
org $30B092 ; PC 0x183092
InitSWBackEntryRoom: dw $0000 ; skull woods curtains (?)

org $30B20C
dw $F000, $F000 ; Pre-open kak bomb hut & brewery

org $30B280 ; PC 0x183280 - 0x1832FF
InitOverworldEvents:
org $30B282 ; PC 0x183282 - Lumberjacks
InitLumberjackOW: db $00
org $30B29B ; PC 0x18329B - Open castle gate
InitHyruleCastleOW: db $20
org $30B2DB ; PC 0x1832DB - Pyramid hole
InitPyramidOW: db $00
org $30B2C3 ; PC 0x1832C3 - GT
InitDDMWestOW: db $00


org $30B340 ; PC 0x183340
StartingEquipment:
StartingBow: skip 1                     ; PC 0x183340
StartingBoomerang: skip 1               ; PC 0x183341
StartingHookshot: skip 1                ; PC 0x183342
StartingBombs: skip 1                   ; PC 0x183343
StartingPowder: skip 1                  ; PC 0x183344
StartingFireRod: skip 1                 ; PC 0x183345
StartingIceRod: skip 1                  ; PC 0x183346
StartingBombos: skip 1                  ; PC 0x183347
StartingEther: skip 1                   ; PC 0x183348
StartingQuake: skip 1                   ; PC 0x183349
StartingLamp: skip 1                    ; PC 0x18334A
StartingHammer: skip 1                  ; PC 0x18334B
StartingFlute: skip 1                   ; PC 0x18334C
StartingBugNet: skip 1                  ; PC 0x18334D
StartingBookOfMudora: skip 1            ; PC 0x18334E
StartingBottleIndex: skip 1             ; PC 0x18334F
StartingSomaria: skip 1                 ; PC 0x183350
StartingByrna: skip 1                   ; PC 0x183351
StartingCape: skip 1                    ; PC 0x183352
StartingMirror: skip 1                  ; PC 0x183353
StartingGlove: skip 1                   ; PC 0x183354
StartingBoots: skip 1                   ; PC 0x183355
StartingFlippers: skip 1                ; PC 0x183356
StartingMoonPearl: skip 1               ; PC 0x183357
skip 1                                  ; PC 0x183358
StartingSword: skip 1                   ; PC 0x183359
StartingShield: skip 1                  ; PC 0x18335A
StartingArmor: skip 1                   ; PC 0x18335B
StartingBottleContentsOne: skip 1       ; PC 0x18335C
StartingBottleContentsTwo: skip 1       ; PC 0x18335D
StartingBottleContentsThree: skip 1     ; PC 0x18335E
StartingBottleContentsFour: skip 1      ; PC 0x18335F
StartingCurrentRupees: skip 2           ; PC 0x183360 \ Write same value to both
StartingDisplayRupees: skip 2           ; PC 0x183362 / of these
StartingCompasses: skip 2               ; PC 0x183364
StartingBigKeys: skip 2                 ; PC 0x183366
StartingMaps: skip 2                    ; PC 0x183368
skip 1                                  ; PC 0x18336A
StartingQuarterHearts: skip 1           ; PC 0x18336B
StartingHealth: db $18                  ; PC 0x18336C
StartingMaximumHealth: db $18           ; PC 0x18336D
StartingMagic: skip 1                   ; PC 0x18336E
StartingSmallKeys: db $FF               ; PC 0x18336F
StartingBombCapacityUpgrade: skip 1     ; PC 0x183370
StartingArrowCapacityUpgrade: skip 1    ; PC 0x183371
InitHeartsFiller: skip 1                ; PC 0x183372
InitMagicFiller: skip 1                 ; PC 0x183373
StartingPendants: skip 1                ; PC 0x183374
InitBombsFiller: skip 1                 ; PC 0x183375
InitArrowsFiller: skip 1                ; PC 0x183376
StartingArrows: skip 1                  ; PC 0x183377
skip 1                                  ; PC 0x183378
InitAbilityFlags: db $68                ; PC 0x183379
StartingCrystals: skip 1                ; PC 0x18337A
StartingMagicConsumption: skip 1        ; PC 0x18337B
StartingDungeonKeys:                    ;
StartingSewerKeys: skip 1               ; PC 0x18337C
StartingHyruleCastleKeys: skip 1        ; PC 0x18337D
StartingEasternKeys: skip 1             ; PC 0x18337E
StartingDesertKeys: skip 1              ; PC 0x18337F
StartingCastleTowerKeys: skip 1         ; PC 0x183380
StartingSwampKeys: skip 1               ; PC 0x183381
StartingPalaceOfDarknessKeys: skip 1    ; PC 0x183382
StartingMireKeys: skip 1                ; PC 0x183383
StartingSkullWoodsKeys: skip 1          ; PC 0x183384
StartingIcePalaceKeys: skip 1           ; PC 0x183385
StartingHeraKeys: skip 1                ; PC 0x183386
StartingThievesTownKeys: skip 1         ; PC 0x183387
StartingTurtleRockKeys: skip 1          ; PC 0x183388
StartingGanonsTowerKeys: skip 1         ; PC 0x183389
skip 1                                  ; PC 0x18338A
StartingGenericKeys: skip 1             ; PC 0x18338B
InitInventoryTracking: skip 2           ; PC 0x18338C \ Need to set bits here for silver arrows,
InitBowTracking: skip 2                 ; PC 0x18338E / boomerangs, powder/mushroom, etc 
InitItemLimitCounts: skip 16            ; PC 0x183390
skip 37                                 ;
InitProgressIndicator: db $02           ; PC 0x1833C5 - Set to $80 for instant post-aga with standard
InitProgressFlags: db $14               ; PC 0x1833C6 - Set to $00 for standard
InitMapIcons: skip 1                    ; PC 0x1833C7
InitStartingEntrance: db $01            ; PC 0x1833C8 - Set to $00 for standard
InitNpcFlagsVanilla: skip 1             ; PC 0x1833C9
InitCurrentWorld: skip 1                ; PC 0x1833CA
skip 1                                  ; PC 0x1833CB
InitFollowerIndicator: skip 1           ; PC 0x1833CC
InitFollowerXCoord: skip 2              ; PC 0x1833CD
InitFollowerYCoord: skip 2              ; PC 0x1833CF
InitDroppedFollowerIndoors: skip 1      ; PC 0x1833D1
InitDroppedFollowerLayer: skip 1        ; PC 0x1833D2
InitFollowerDropped: skip 1             ; PC 0x1833D3

org $30B3D9 ; PC 0x1833D9 - 0x1833F0
StaticFileName: ; The validity value ($55AA) must be written manually on SRAM init at $7003E1
dw $0181, $0162, $0168, $018C
dw $0166, $014E, $0162, $018C
dw $0165, $0162, $0167, $018C

org $30B401 ; PC 0x183401
InitDeathCounter:
dw $FFFF

;--------------------------------------------------------------------------------
; The following labels and their addresses are provided for convenience. You
; may want to write, for example, to InitHighestSword in addition to setting
; StartingSword. But any value can be written to the whole block from
; $30B000-$30B4FF (PC 0x183000-0x18034FF) and it will be initialized
; excluding ~28 bytes (File name, validity value, and checksum.)
;--------------------------------------------------------------------------------

org $30B414 ; PC 0x183414-0x183416
InitMapOverlay: dw $0000

org $30B417 ; PC 0x183417
InitHighestSword: db $00

org $30B414 ; PC 0x183418-0x183419
InitGoalCounter: dw $0000

org $30B422 ; PC 0x183422
InitHighestShield: db $00

org $30B428 ; PC 0x183428
InitMapsCompasses: db $00

org $30B429 ; PC 0x183429
InitPendantCounter: db $00

org $30B454 ; PC 0x183454-0x183457
InitChallengeTimer: dw $0000, $0000

org $30B46E ; PC 0x18346E
InitHighestMail: db $00

org $30B471 ; PC 0x183471
InitCrystalCounter: db $00
