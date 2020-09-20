;=======================================
;
; MSU-1 Enhanced Audio Patch
; Zelda no Densetsu - Kamigami no Triforce
; Modified for VT Randomizer
;
; Author: qwertymodo
;
; Track List:
;
;  1 - Title ~ Link to the Past
;  2 - Hyrule Field
;  3 - Time of Falling Rain
;  4 - The Silly Pink Rabbit
;  5 - Forest of Mystery
;  6 - Seal of Seven Maidens
;  7 - Kakariko Village
;  8 - Dimensional Shift (Mirror)
;  9 - Dark Golden Land
; 10 - Unsealing the Master Sword
; 11 - Beginning of the Journey
; 12 - Soldiers of Kakariko Village
; 13 - Black Mist
; 14 - Guessing Game House
; 15 - Dark Woods
; 16 - Majestic Castle
; 17 - Lost Ancient Ruins
; 18 - Dank Dungeons
; 19 - Great Victory!
; 20 - Safety in the Sanctuary
; 21 - Anger of the Guardians
; 22 - Dungeon of Shadows
; 23 - Fortune Teller
; 24 - Dank Dungeons (Copy)
; 25 - Princess Zelda's Rescue
; 26 - Meeting the Maidens
; 27 - The Goddess Appears
; 28 - Priest of the Dark Order
; 29 - Release of Ganon
; 30 - Ganon's Message
; 31 - The Prince of Darkness
; 32 - Power of the Gods
; 33 - Epilogue ~ Beautiful Hyrule
; 34 - Staff Roll
;
; Dungeon-specific tracks
;
; 35 - Eastern Palace
; 36 - Desert Palace
; 37 - Agahnim's Tower
; 38 - Swamp Palace
; 39 - Palace of Darkness
; 40 - Misery Mire
; 41 - Skull Woods
; 42 - Ice Palace
; 43 - Tower of Hera
; 44 - Thieves' Town
; 45 - Turtle Rock
; 46 - Ganon's Tower
; 59 - Ganon's Tower (Upstairs)
;
; Bosses
;
; 47 - Eastern Palace
; 48 - Desert Palace
; 49 - Agahnim's Tower
; 50 - Swamp Palace
; 51 - Palace of Darkness
; 52 - Misery Mire
; 53 - Skull Woods
; 54 - Ice Palace
; 55 - Tower of Hera
; 56 - Thieves' Town
; 57 - Turtle Rock
; 58 - Ganon's Tower
;
; Additional tracks
;
; 60 - Light World OW (after ped pull)
; 61 - Dark World OW (with all crystals)
;
;=======================================

!REG_MSU_STATUS = $2000

!REG_MSU_ID_0 = $2002
!REG_MSU_ID_1 = $2003
!REG_MSU_ID_2 = $2004
!REG_MSU_ID_3 = $2005
!REG_MSU_ID_4 = $2006
!REG_MSU_ID_5 = $2007

!REG_MSU_ID_01 = $2002
!REG_MSU_ID_23 = $2004
!REG_MSU_ID_45 = $2006


!VAL_MSU_ID_0 = #$53    ;   'S'
!VAL_MSU_ID_1 = #$2D    ;   '-'
!VAL_MSU_ID_2 = #$4D    ;   'M'
!VAL_MSU_ID_3 = #$53    ;   'S'
!VAL_MSU_ID_4 = #$55    ;   'U'
!VAL_MSU_ID_5 = #$31    ;   '1'

!VAL_MSU_ID_01 = #$2D53 ;   'S-'
!VAL_MSU_ID_23 = #$534D ;   'MS'
!VAL_MSU_ID_45 = #$3155 ;   'U1'


!REG_MSU_TRACK = $2004
!REG_MSU_TRACK_LO = $2004
!REG_MSU_TRACK_HI = $2005
!REG_MSU_VOLUME = $2006
!REG_MSU_CONTROL = $2007


!FLAG_MSU_PLAY = #$01
!FLAG_MSU_REPEAT = #$02
!FLAG_MSU_STATUS_TRACK_MISSING = #$08
!FLAG_MSU_STATUS_AUDIO_PLAYING = #$10
!FLAG_MSU_STATUS_AUDIO_REPEATING = #$20
!FLAG_MSU_STATUS_AUDIO_BUSY = #$40
!FLAG_MSU_STATUS_DATA_BUSY = #$80


!REG_CURRENT_MSU_TRACK = $010B
!REG_CURRENT_VOLUME = $0127
!REG_TARGET_VOLUME = $0129
!REG_CURRENT_TRACK = $0130
!REG_CURRENT_COMMAND = $0133

!REG_SPC_CONTROL = $2140
!REG_NMI_FLAGS = $4210

!VAL_COMMAND_STOP_PLAYBACK = #$F0
!VAL_COMMAND_FADE_OUT = #$F1
!VAL_COMMAND_FADE_HALF = #$F2
!VAL_COMMAND_FULL_VOLUME = #$F3
!VAL_COMMAND_MUTE_SPC = #$FA
!VAL_COMMAND_UNMUTE_SPC = #$FB
!VAL_COMMAND_LOAD_NEW_BANK = #$FF

!VAL_VOLUME_INCREMENT = #$10
!VAL_VOLUME_DECREMENT = #$02
!VAL_VOLUME_HALF = #$80
!VAL_VOLUME_FULL = #$FF

;================================================================================
; Extended OST/SPC fallback, decide which track to actually play
;--------------------------------------------------------------------------------
CheckMusicLoadRequest:
    PHP : REP #$10 : PHA : PHX : PHY
        LDA !REG_MUSIC_CONTROL_REQUEST : BEQ .skip+3 : BMI .skip+3
        CMP !REG_CURRENT_COMMAND : BNE .continue
        CMP.b #22 : BNE .skip   ; Check GT when mirroring from upstairs
        LDA !REG_CURRENT_MSU_TRACK : CMP.b #59 : BNE .skip
        LDA.b #$00 : STA !REG_CURRENT_COMMAND
        BRA .continue
.skip
        LDA !REG_MUSIC_CONTROL_REQUEST
        STA !REG_MUSIC_CONTROL : STZ !REG_MUSIC_CONTROL_REQUEST
    PLY : PLX : PLA : PLP
    RTL
        
.continue
        LDA TournamentSeed : BNE +++
        LDA !REG_MSU_PACK_REQUEST
        CMP !REG_MSU_PACK_CURRENT : BEQ +++
        CMP !REG_MSU_PACK_COUNT : !BLT ++
        CMP #$FE : !BLT +
                    STA !REG_MSU_PACK_CURRENT
                    SEP #$10
                        LDA #$00
                        LDX #$07
                        -
                            STA !REG_MSU_FALLBACK_TABLE,X
                        DEX : BPL -
                    REP #$10
                    BRA +++
                + : LDA !REG_MSU_PACK_CURRENT : STA !REG_MSU_PACK_REQUEST
            ++ : STA !REG_MSU_PACK_CURRENT
            JSL MSUInit_check_fallback
        +++

        LDA !REG_MUSIC_CONTROL_REQUEST : CMP #$08 : BEQ ++  ; Mirror SFX is not affected by NoBGM or pack $FE
            LDA NoBGM : BNE +
            LDA !REG_MSU_PACK_CURRENT : CMP #$FE : BNE ++
                + : BRL .mute
        ++

        LDX !REG_MSU_ID_01 : CPX !VAL_MSU_ID_01 : BEQ +
            - : BRL .unmute
        +
        LDX !REG_MSU_ID_23 : CPX !VAL_MSU_ID_23 : BNE -
        LDX !REG_MSU_ID_45 : CPX !VAL_MSU_ID_45 : BNE -

        SEP #$10
            ;  Load alternate or dungeon-specific tracks
            LDA !REG_MUSIC_CONTROL_REQUEST

            CMP.b #02 : BEQ .lightworld
            CMP.b #09 : BEQ .darkworld
            CMP.b #13 : BEQ .darkwoods
            CMP.b #15 : BEQ .darkwoods
            CMP.b #16 : BEQ .castle
            CMP.b #17 : BEQ .dungeon
            CMP.b #22 : BEQ .dungeon
            CMP.b #21 : BNE .check_fallback

;.boss
            LDA $040C : LSR : !ADD.b #45
            BRA .check_fallback-3
.lightworld
            PHA
                LDA $7EF300 : AND.b #$40 : BEQ +
                    PLA
                    LDA.b #60 : BRA .check_fallback-3
                +
            -- : PLA : BRA .check_fallback-3
.darkworld
            PHA
                LDA $7EF37A : CMP.b #$7F : BNE --
            - : PLA
            LDA.b #61 : BRA .check_fallback-3 
.darkwoods
            PHA
                LDA $7EF37A : CMP.b #$7F : BEQ -
                LDA $7EF3CA : BEQ --
                LDA $8A : CMP #$40 : BNE --
            PLA
            LDA.b #15 : BRA .check_fallback-3
.castle
            LDA $040C
            CMP.b #$08 : BNE .check_fallback  ; Hyrule Castle 2
.dungeon
            LDA $040C : LSR : !ADD.b #33 : STA !REG_MUSIC_CONTROL_REQUEST

.check_fallback
            LDX !REG_MUSIC_CONTROL_REQUEST
            LDA MusicShuffleTable-1,X : DEC : PHA
                AND.b #$07 : TAY
                PLA : LSR #3 : TAX
            LDA !REG_MSU_FALLBACK_TABLE,X : BEQ .secondary_fallback : CMP.b #$FF : BEQ .mute
            
            - : CPY #$00 : BEQ +
                LSR : DEY : BRA -
            +
            
            AND.b #$01 : BEQ .secondary_fallback

.mute
            LDA.b !VAL_COMMAND_MUTE_SPC
            BRA .load

.secondary_fallback
            LDX !REG_MUSIC_CONTROL_REQUEST : LDA MSUExtendedFallbackList-1,X
            PHX
                TAX : LDA MusicShuffleTable-1,X
            PLX
            CMP !REG_MUSIC_CONTROL_REQUEST : BEQ .unmute
            CPX #35 : !BLT +
                CPX #47 : !BLT .dungeon_fallback
            +

            STA !REG_MUSIC_CONTROL_REQUEST
            BRA .check_fallback

.dungeon_fallback
                PHB : REP #$10
                    LDX $040C
                    LDA.b #Music_Eastern>>16 : PHA : PLB    ; Set bank to music pointers
                    LDY $00 : PHY
                        REP #$20
                            LDA MSUDungeonFallbackList,X : STA $00
                        SEP #$20
                        LDA ($00)
                PLY : STY $00 : SEP #$10 : PLB
                TAX : LDA MusicShuffleTable-1,X
                STA !REG_MUSIC_CONTROL_REQUEST
                BRL .check_fallback

.unmute
            LDA.b !VAL_COMMAND_UNMUTE_SPC

.load
        REP #$10
        STZ $4200
        STA !REG_SPC_CONTROL
        - : CMP !REG_SPC_CONTROL : BNE -    ; Wait until mute/unmute command is ACK'ed
        STZ !REG_SPC_CONTROL
        - : LDA !REG_SPC_CONTROL : BNE -    ; Wait until mute/unmute command is completed
        LDA.b #$81 : STA $4200

        LDA !REG_MUSIC_CONTROL_REQUEST : CMP.b #08 : BEQ .done+3    ; No SFX during warp track

        LDA $10
            CMP.b #$07 : BEQ .sfx_indoors
            CMP.b #$0E : BEQ .sfx_indoors
            CMP.b #$09 : BNE .done

.sfx_outdoors
        SEP #$10
            LDX.b #$09

            LDA $8A             ; Dark Death Mountain
            CMP.b #$43 : BEQ + : CMP.b #$45 : BEQ + : CMP.b #$47 : BEQ +
                LDX.b #$05
            +

            CMP.b #$70 : BNE +    ; Misery Mire
                LDA $7EF2F0 : AND.b #$20 : BEQ .rain
            +

            LDA $7EF3C5 : CMP.b #$02 : BCS +
.rain
                LDX.b #$01
            +
            STX $012D
        REP #$10

.done
        LDA !REG_MUSIC_CONTROL_REQUEST : STA !REG_MUSIC_CONTROL : STZ !REG_MUSIC_CONTROL_REQUEST
    PLY : PLX : PLA : PLP
    RTL

.sfx_indoors
        LDA !REG_MUSIC_CONTROL_REQUEST : STA !REG_MUSIC_CONTROL : STZ !REG_MUSIC_CONTROL_REQUEST
    PLY : PLX : PLA : PLP
    PHP : SEP #$20 : LDA.b #$05 : STA $012D : PLP
    JML Module_PreDungeon_setAmbientSfx
;--------------------------------------------------------------------------------

;================================================================================
; Fade out music if we're changing tracks on a stair transition
;--------------------------------------------------------------------------------
SpiralStairsPreCheck:
    REP #$20    ; thing we wrote over
    LDA $A0
    CMP.w #$000C : BNE +
        LDA !REG_CURRENT_MSU_TRACK : AND.w #$00FF : CMP.w #59 : BNE .done
        BRA .fade
    +

    CMP.w #$006B : BNE .done+2

    LDA TournamentSeed : CMP.w #$0001 : BEQ +
        LDA !REG_MSU_ID_01 : CMP !VAL_MSU_ID_01 : BNE .done
        LDA !REG_MSU_ID_23 : CMP !VAL_MSU_ID_23 : BNE .done
        LDA !REG_MSU_ID_45 : CMP !VAL_MSU_ID_45 : BNE .done
    +

    LDA $7EF366 : AND.w #$0004 : BEQ .done                      ; Check that we have the GT big key
    LDA !REG_MSU_FALLBACK_TABLE+7 : AND.w #$0004 : BEQ .done    ; Check that we have the extended track

.fade
    LDX.b #$F1 : STX !REG_MUSIC_CONTROL_REQUEST

.done
    LDA $A0     ; thing we wrote over
    RTL
;--------------------------------------------------------------------------------

;================================================================================
; Change music on stair transition (ToH/GT)
;--------------------------------------------------------------------------------
SpiralStairsPostCheck:
    LDA $A0
    CMP.w #$000C : BNE +
        ; Ganon's tower entrance
        LDX $0130 : CPX.b #$F1 : BNE .done  ; Check that we were fading out

        LDX #22 : STX !REG_MUSIC_CONTROL_REQUEST
        BRA .done
    +

    CMP.w #$006B : BNE .done

    ; Ganon's tower upstairs (with big key)
    LDX $0130 : CPX.b #$F1 : BNE .done  ; Check that we were fading out

    LDX #59 : STX !REG_MUSIC_CONTROL_REQUEST

.done
    LDX.b #$1C : LDA $A0    ; thing we wrote over
    RTL
;--------------------------------------------------------------------------------

;================================================================================
; Make sure expanded OST tracks load properly after death/fairy revival
;--------------------------------------------------------------------------------
StoreMusicOnDeath:
    STA.l $7EC227   ; thing we wrote over
    LDA !REG_MSU_STATUS : BIT !FLAG_MSU_STATUS_AUDIO_PLAYING : BEQ .done
    LDA !REG_CURRENT_MSU_TRACK : STA.l $7EC227
.done
    RTL
;--------------------------------------------------------------------------------

;================================================================================
; Check if MSU-1 is enabled and scan for missing tracks
;--------------------------------------------------------------------------------
MSUInit:
    PHP

    LDA NoBGM : BNE .done

    REP #$20

        LDA !REG_MSU_ID_01 : CMP !VAL_MSU_ID_01 : BNE .done
        LDA !REG_MSU_ID_23 : CMP !VAL_MSU_ID_23 : BNE .done
        LDA !REG_MSU_ID_45 : CMP !VAL_MSU_ID_45 : BNE .done

; Count the number of available MSU-1 packs
        LDA.w #$0000
        LDX.b #$FF
        LDY.b #$01
    SEP #$20

.check_pack
    TYA
    REP #$20
        STA !REG_MSU_TRACK
        !ADD.w #100
        INX
    SEP #$20
    TAY
.wait_pack
    LDA !REG_MSU_STATUS : BIT !FLAG_MSU_STATUS_AUDIO_BUSY : BNE .wait_pack
    LDA !REG_MSU_STATUS : BIT !FLAG_MSU_STATUS_TRACK_MISSING : BEQ .check_pack
    TXA : STA !REG_MSU_PACK_COUNT
    BRA +

; Check the current MSU-1 pack for tracks that require SPC fallback
.check_fallback
        PHP : SEP #$10
        LDA NoBGM : BNE .done
    + : LDA.b #64
    LDX.b #7
    LDY.b #7

.check_track
    STA !REG_MSU_TRACK_LO
    STZ !REG_MSU_TRACK_HI
    PHA
    CLC

.wait_track
    LDA !REG_MSU_STATUS : BIT !FLAG_MSU_STATUS_AUDIO_BUSY : BNE .wait_track
    LDA !REG_MSU_STATUS : BIT !FLAG_MSU_STATUS_TRACK_MISSING : BNE +
        SEC
    +
    LDA !REG_MSU_FALLBACK_TABLE,X : ROL : STA !REG_MSU_FALLBACK_TABLE,X

    DEY : BPL .next_track
        DEX : BPL +
            PLA
.done
            PLP
            RTL
        +
        LDY.b #7
.next_track
    PLA : DEC
    BRA .check_track

;--------------------------------------------------------------------------------

;================================================================================
; Play MSU-1 audio track
;--------------------------------------------------------------------------------
MSUMain:
    SEP #$20    ; set 8-BIT accumulator
    LDA $4210   ; thing we wrote over
    REP #$20    ; set 16-BIT accumulator
    LDA !REG_MSU_ID_01 : CMP !VAL_MSU_ID_01 : BEQ .continue
.nomsu
    SEP #$30
    JML SPCContinue
.continue
    LDA !REG_MSU_ID_23 : CMP !VAL_MSU_ID_23 : BNE .nomsu
    LDA !REG_MSU_ID_45 : CMP !VAL_MSU_ID_45 : BNE .nomsu
    SEP #$30
    LDX !REG_MUSIC_CONTROL : BEQ +
        BRL .command_ff
    +
    LDA !REG_MSU_DELAYED_COMMAND : BEQ .do_fade

.check_busy
    LDA !REG_MSU_STATUS : BIT !FLAG_MSU_STATUS_AUDIO_BUSY : BEQ .ready
    JML SPCContinue
.ready
    LDA !REG_MSU_STATUS : BIT !FLAG_MSU_STATUS_TRACK_MISSING : BEQ .start
    JML SPCContinue
.start
    LDA !VAL_VOLUME_FULL
    STA !REG_TARGET_VOLUME
    STA !REG_CURRENT_VOLUME
    STA !REG_MSU_VOLUME
    LDA !REG_CURRENT_MSU_TRACK : DEC : PHA
        AND.b #$07 : TAY
        PLA : LSR #3 : TAX
    LDA !REG_MSU_FALLBACK_TABLE,X : BEQ +++ : CMP.b #$FF : BEQ ++

    - : CPY #$00 : BEQ +
        LSR : DEY : BRA -
    +

    AND.b #$01 : BEQ +++
        ++ : LDA !REG_MSU_DELAYED_COMMAND
    +++ : STA !REG_MSU_CONTROL
    LDA.b #$00
    STA !REG_MSU_DELAYED_COMMAND
    JML SPCContinue

.do_fade:
    LDA !REG_CURRENT_VOLUME : CMP !REG_TARGET_VOLUME : BNE +
        JML SPCContinue
    + : BCC .increment
.decrement
    SBC !VAL_VOLUME_DECREMENT : BCC .mute
    CMP !REG_TARGET_VOLUME : !BGE .set
    LDA !REG_TARGET_VOLUME : BRA .set
.mute
    STZ !REG_CURRENT_VOLUME
    STZ !REG_MSU_CONTROL
    BRA .set
.increment
    ADC !VAL_VOLUME_INCREMENT : BCS .max
    CMP !REG_TARGET_VOLUME : !BLT .set
    LDA !REG_TARGET_VOLUME : BRA .set
.max
    LDA !VAL_VOLUME_FULL
.set
    STA !REG_CURRENT_VOLUME
    STA !REG_MSU_VOLUME
    JML SPCContinue

.command_ff:
    CPX !VAL_COMMAND_LOAD_NEW_BANK : BNE .command_f3
    JML SPCContinue

.command_f3:
    CPX !VAL_COMMAND_FULL_VOLUME : BNE .command_f2
    LDA !VAL_VOLUME_FULL
    STA !REG_TARGET_VOLUME
    JML SPCContinue

.command_f2:
    CPX !VAL_COMMAND_FADE_HALF : BNE .command_f1
    LDA !VAL_VOLUME_HALF
    STA !REG_TARGET_VOLUME
    JML SPCContinue

.command_f1:
    CPX !VAL_COMMAND_FADE_OUT : BNE .command_f0
    STZ !REG_TARGET_VOLUME
    STZ !REG_CURRENT_MSU_TRACK
    JML SPCContinue

.command_f0:
    CPX !VAL_COMMAND_STOP_PLAYBACK : !BLT .load_track
    CPX !VAL_COMMAND_MUTE_SPC : BEQ +       ; Don't allow executing the mute/umute
    CPX !VAL_COMMAND_UNMUTE_SPC : BNE ++    ; commands during NMI like this
        + : LDA.b #$00 : STA !REG_MUSIC_CONTROL
    ++ : JML SPCContinue

.load_track:
    CPX !REG_CURRENT_MSU_TRACK : BNE +
    - : CPX #27 : BEQ +
        TXA
        BRA .done+1
    +
    CPX !REG_CURRENT_COMMAND : BEQ -
    LDA.b #$00 : XBA
    LDA !REG_MSU_PACK_CURRENT : BEQ +
    - : CMP !REG_MSU_PACK_COUNT : !BLT +
        !SUB !REG_MSU_PACK_COUNT : BRA -
    +

    PHX : PHA : TXA : PLX
    REP #$20
    BEQ +
    -
        !ADD.w #100
        DEX : BNE -
    +
        STA !REG_MSU_TRACK
    SEP #$20

    STZ !REG_MSU_CONTROL
    PLX
    STX !REG_CURRENT_MSU_TRACK
    LDA !REG_MSU_PACK_CURRENT : CMP #$FE : !BLT +
        LDA #$00 : BRA ++
        + : LDA MSUTrackList-1,X
    ++ : STA !REG_MSU_DELAYED_COMMAND
    LDA MSUExtendedFallbackList-1,X 
    CMP.b #17 : BEQ +
    CMP.b #22 : BEQ +
    CMP.b #35 : !BLT .done
    CMP.b #47 : !BGE .done

    + : PHB : REP #$10
        LDX $040C
        LDA.b #Music_Eastern>>16 : PHA : PLB    ; Set bank to music pointers
        LDY $00 : PHY
            REP #$20
                LDA MSUDungeonFallbackList,X : STA $00
            SEP #$20
            LDA ($00)
    PLY : STY $00 : SEP #$10 : PLB

.done
    - : TAX : CMP MSUExtendedFallbackList-1,X : BEQ +
        LDA MSUExtendedFallbackList-1,X : BRA -
    +
    STA !REG_MUSIC_CONTROL
    JML SPCContinue

;--------------------------------------------------------------------------------

;================================================================================
; Wait for the fanfare music to start, or else it can get skipped entirely
;--------------------------------------------------------------------------------
FanfarePreload:
    STA !REG_MUSIC_CONTROL_REQUEST  ; thing we wrote over
    PHA
        JSL CheckMusicLoadRequest
        WAI
    PLA
    - : CMP !REG_SPC_CONTROL : BNE -
    JML AddReceivedItem_doneWithSoundEffects
;--------------------------------------------------------------------------------

;================================================================================
; Wait for pendant fanfare to finish
;--------------------------------------------------------------------------------
PendantFanfareWait:
    LDA TournamentSeed : BNE .spc
    LDA FastFanfare : BNE .done
    REP #$20
    LDA !REG_MSU_ID_01 : CMP !VAL_MSU_ID_01 : BNE .spc
    LDA !REG_MSU_ID_23 : CMP !VAL_MSU_ID_23 : BNE .spc
    LDA !REG_MSU_ID_45 : CMP !VAL_MSU_ID_45 : BNE .spc
    SEP #$20
    LDA !REG_MSU_PACK_CURRENT : CMP #$FE : !BGE .spc
    LDA !REG_MSU_STATUS : BIT !FLAG_MSU_STATUS_TRACK_MISSING : BNE .spc
    LDA !REG_MSU_DELAYED_COMMAND : BNE .continue
    LDA !REG_MSU_STATUS : BIT !FLAG_MSU_STATUS_AUDIO_PLAYING : BEQ .done
.continue
    jml PendantFanfareContinue
.spc
    SEP #$20
    LDA !REG_SPC_CONTROL : BNE .continue
.done
    jml PendantFanfareDone
;--------------------------------------------------------------------------------

;================================================================================
; Wait for crystal fanfare to finish
;--------------------------------------------------------------------------------
CrystalFanfareWait:
    LDA TournamentSeed : BNE .spc
    LDA FastFanfare : BNE .done
    REP #$20
    LDA !REG_MSU_ID_01 : CMP !VAL_MSU_ID_01 : BNE .spc
    LDA !REG_MSU_ID_23 : CMP !VAL_MSU_ID_23 : BNE .spc
    LDA !REG_MSU_ID_45 : CMP !VAL_MSU_ID_45 : BNE .spc
    SEP #$20
    LDA !REG_MSU_PACK_CURRENT : CMP #$FE : !BGE .spc
    LDA !REG_MSU_STATUS : BIT !FLAG_MSU_STATUS_TRACK_MISSING : BNE .spc
    LDA !REG_MSU_DELAYED_COMMAND : BNE .continue
    LDA !REG_MSU_STATUS : BIT !FLAG_MSU_STATUS_AUDIO_PLAYING : BEQ .done
.continue    
    jml CrystalFanfareContinue
.spc
    SEP #$20
    LDA !REG_SPC_CONTROL : BNE .continue
.done
    jml CrystalFanfareDone
;--------------------------------------------------------------------------------

;================================================================================
; Delay input scanning on startup/S&Q to avoid hard-lock from button mashing
;--------------------------------------------------------------------------------
StartupWait:
    LDA $11 : CMP.b #$04 : BCC .done    ; thing we wrote over
    LDA !REG_SPC_CONTROL : BEQ .done-1
    CMP.b #$01 : BEQ .done
    CLC
.done
    RTL
;--------------------------------------------------------------------------------

;================================================================================
; Wait for ending credits music to finish
;--------------------------------------------------------------------------------
EndingMusicWait:
    REP #$20
    LDA !REG_MSU_ID_01 : CMP !VAL_MSU_ID_01 : BNE .done
    LDA !REG_MSU_ID_23 : CMP !VAL_MSU_ID_23 : BNE .done
    LDA !REG_MSU_ID_45 : CMP !VAL_MSU_ID_45 : BNE .done
    SEP #$20
.wait
    LDA !REG_MSU_STATUS : BIT !FLAG_MSU_STATUS_AUDIO_PLAYING : BNE .wait
.done
    SEP #$20
    LDA.b #$22
    RTL
;--------------------------------------------------------------------------------
