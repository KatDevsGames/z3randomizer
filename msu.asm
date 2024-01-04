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

!VAL_MSU_ID_01 = $2D53 ; 'S-'
!VAL_MSU_ID_23 = $534D ; 'MS'
!VAL_MSU_ID_45 = $3155 ; 'U1'

!FLAG_MSU_PLAY = $01
!FLAG_MSU_REPEAT = $02
!FLAG_MSU_RESUME = $04
!FLAG_MSU_STATUS_TRACK_MISSING = $08
!FLAG_MSU_STATUS_AUDIO_PLAYING = $10
!FLAG_MSU_STATUS_AUDIO_REPEATING = $20
!FLAG_MSU_STATUS_AUDIO_BUSY = $40
!FLAG_MSU_STATUS_DATA_BUSY = $80

!FLAG_RESUME_CANCEL = $01
!FLAG_RESUME_FADEIN = $02

!VAL_COMMAND_STOP_PLAYBACK = $F0
!VAL_COMMAND_FADE_OUT = $F1
!VAL_COMMAND_FADE_HALF = $F2
!VAL_COMMAND_FULL_VOLUME = $F3
!VAL_COMMAND_MUTE_SPC = $FA
!VAL_COMMAND_UNMUTE_SPC = $FB
!VAL_COMMAND_LOAD_NEW_BANK = $FF

!VAL_VOLUME_INCREMENT = $10
!VAL_VOLUME_DECREMENT = $02
!VAL_VOLUME_HALF = $80
!VAL_VOLUME_FULL = $FF

;================================================================================
; Check if A has an overworld track
;--------------------------------------------------------------------------------
IsOverworldTrack:
    CMP.b #02 : BEQ .yes ;  2 - Hyrule Field
    CMP.b #03 : BEQ .yes ;  3 - Time of Falling Rain
    CMP.b #04 : BEQ .yes ;  4 - The Silly Pink Rabbit
    CMP.b #05 : BEQ .yes ;  5 - Forest of Mystery
    CMP.b #07 : BEQ .yes ;  7 - Kakariko Village
    CMP.b #09 : BEQ .yes ;  9 - Dark Golden Land
    CMP.b #15 : BEQ .yes ; 15 - Dark Woods
    CMP.b #60 : BEQ .yes ; 60 - Light World OW (after ped pull)
    CMP.b #61 : BEQ .yes ; 61 - Dark World OW (with all crystals)
    .no
    CLC : RTS
.yes
SEC : RTS
;--------------------------------------------------------------------------------

;================================================================================
; Check if the track in A should be resumed
;--------------------------------------------------------------------------------
IsResumableTrack:
    PHA
    LDA.l MSUResumeType : BEQ +
        PLA
        JSR IsOverworldTrack
        RTS
    +
    PLA
    SEC
RTS
;--------------------------------------------------------------------------------

;================================================================================
; Extended OST/SPC fallback, decide which track to actually play
;--------------------------------------------------------------------------------
CheckMusicLoadRequest:
    PHP : PHB : PHD : REP #$30 : PHA : PHX : PHY
    LDA.w #$0000 : TCD : SEP #$20 : PHA : PLB
        LDA.w MusicControlRequest : BEQ .skip+3 : BMI .skip+3
        CMP.w CurrentControlRequest : BNE .continue
        CMP.b #22 : BNE .skip   ; Check GT when mirroring from upstairs
        LDA.w CurrentMSUTrack : CMP.b #59 : BNE .skip
        LDA.b #$00 : STA.w CurrentControlRequest
        BRA .continue
.skip
        LDA.w MusicControlRequest
        STA.w MusicControl : STZ.w MusicControlRequest
    REP #$30 : PLY : PLX : PLA : PLD : PLB : PLP
    RTL
        
.continue
        LDA.l TournamentSeed : BNE +++
        LDA.l MSUPackRequest
        CMP.l MSUPackCurrent : BEQ +++
        CMP.l MSUPackCount : !BLT ++
        CMP.b #$FE : !BLT +
                    STA.l MSUPackCurrent
                    SEP #$10
                        LDA.b #$00
                        LDX.b #$07
                        -
                            STA.l MSUFallbackTable,X
                        DEX : BPL -
                    REP #$10
                    BRA +++
                + : LDA.l MSUPackCurrent : STA.l MSUPackRequest
            ++ : STA.l MSUPackCurrent
            JSL MSUInit_check_fallback
        +++

        LDA.w MusicControlRequest : CMP.b #$08 : BEQ ++  ; Mirror SFX is not affected by NoBGM or pack $FE
            LDA.l NoBGM : BNE +
            LDA.l MSUPackCurrent : CMP.b #$FE : BNE ++
                + : JMP .mute
        ++

        LDX.w MSUID : CPX.w #!VAL_MSU_ID_01 : BEQ +
            - : JMP .unmute
        +
        LDX.w MSUID+2 : CPX.w #!VAL_MSU_ID_23 : BNE -
        LDX.w MSUID+4 : CPX.w #!VAL_MSU_ID_45 : BNE -

        SEP #$10
            ;  Load alternate or dungeon-specific tracks
            LDA.w MusicControlRequest

            CMP.b #02 : BEQ .lightworld
            CMP.b #09 : BEQ .darkworld
            CMP.b #13 : BEQ .darkwoods
            CMP.b #15 : BEQ .darkwoods
            CMP.b #16 : BEQ .castle
            CMP.b #17 : BEQ .dungeon
            CMP.b #22 : BEQ .dungeon
            CMP.b #21 : BNE .check_fallback

;.boss
            LDA.w DungeonID : LSR : !ADD.b #45
            BRA .check_fallback-3
.lightworld
            PHA
                LDA.l OverworldEventDataWRAM+$80 : AND.b #$40 : BEQ +
                    PLA
                    LDA.b #60 : BRA .check_fallback-3
                +
            -- : PLA : BRA .check_fallback-3
.darkworld
            PHA
                LDA.l CrystalsField : CMP.b #$7F : BNE --
            - : PLA
            LDA.b #61 : BRA .check_fallback-3 
.darkwoods
            PHA
                LDA.l CrystalsField : CMP.b #$7F : BEQ -
                LDA.l CurrentWorld : BEQ --
                LDA.b OverworldIndex : CMP #$40 : BNE --
            PLA
            LDA.b #15 : BRA .check_fallback-3
.castle
            LDA.w DungeonID
            CMP.b #$08 : BNE .check_fallback  ; Hyrule Castle 2
.dungeon
            LDA.w DungeonID : LSR : !ADD.b #33 : STA.w MusicControlRequest

.check_fallback
            LDX.w MusicControlRequest
            LDA.l MusicShuffleTable-1,X : DEC : PHA
                AND.b #$07 : TAY
                PLA : LSR #3 : TAX
            LDA.l MSUFallbackTable,X : BEQ .secondary_fallback : CMP.b #$FF : BEQ .mute
            
            - : CPY #$00 : BEQ +
                LSR : DEY : BRA -
            +
            
            AND.b #$01 : BEQ .secondary_fallback

.mute
            LDA.b #!VAL_COMMAND_MUTE_SPC
            BRA .load

.secondary_fallback
            LDX.w MusicControlRequest : LDA.l MSUExtendedFallbackList-1,X
            PHX
                TAX : LDA.l MusicShuffleTable-1,X
            PLX
            CMP.w MusicControlRequest : BEQ .unmute
            CPX #35 : !BLT +
                CPX #47 : !BLT .dungeon_fallback
            +

            STA.w MusicControlRequest
            BRA .check_fallback

.dungeon_fallback
                PHB : REP #$10
                    LDX.w DungeonID
                    LDA.b #Music_Eastern>>16 : PHA : PLB    ; Set bank to music pointers
                    LDY.b Scrap00 : PHY
                        REP #$20
                            LDA.l MSUDungeonFallbackList,X : STA.b Scrap00
                        SEP #$20
                        LDA.b (Scrap00)
                PLY : STY.b Scrap00 : SEP #$10 : PLB
                TAX : LDA.l MusicShuffleTable-1,X
                STA.w MusicControlRequest
                JMP .check_fallback

.unmute
            LDA.b #!VAL_COMMAND_UNMUTE_SPC

.load
        REP #$10
        STZ.w NMITIMEN
        - : STA.w APUIO0 : CMP.w APUIO0 : BNE - ; Wait until mute/unmute command is ACK'ed
        - : STZ.w APUIO0 : LDA.w APUIO0 : BNE - ; Wait until mute/unmute command is completed
        LDA.b #$81 : STA.w NMITIMEN

        LDA.w MusicControlRequest : CMP.b #08 : BEQ .done+3    ; No SFX during warp track

        LDA.b GameMode
            CMP.b #$07 : BEQ .sfx_indoors
            CMP.b #$0E : BEQ .sfx_indoors
            CMP.b #$09 : BNE .done

.sfx_outdoors
        SEP #$10
            LDX.b #$09

            LDA.b OverworldIndex             ; Dark Death Mountain
            CMP.b #$43 : BEQ + : CMP.b #$45 : BEQ + : CMP.b #$47 : BEQ +
                LDX.b #$05
            +

            CMP.b #$70 : BNE +    ; Misery Mire
                LDA.l OverworldEventDataWRAM+$70 : AND.b #$20 : BEQ .rain
            +

            LDA.l ProgressIndicator : CMP.b #$02 : BCS +
.rain
                LDX.b #$01
            +
            STX.w SFX1
        REP #$10

.done
        LDA.w MusicControlRequest : STA.w MusicControl : STZ.w MusicControlRequest
        REP #$30 : PLY : PLX : PLA : PLD : PLB : PLP
    RTL

.sfx_indoors
        LDA.w MusicControlRequest : STA.w MusicControl : STZ.w MusicControlRequest
    SEP #$20 : LDA.b #$05 : STA.w SFX1
    REP #$30 : PLY : PLX : PLA : PLD : PLB : PLP
    JML Module_PreDungeon_setAmbientSfx
;--------------------------------------------------------------------------------

;================================================================================
; Fade out music if we're changing tracks on a stair transition
;--------------------------------------------------------------------------------
SpiralStairsPreCheck:
    REP #$20    ; thing we wrote over
    LDA.b RoomIndex
    CMP.w #$000C : BNE +
        LDA.w CurrentMSUTrack : AND.w #$00FF : CMP.w #59 : BNE .done
        BRA .fade
    +

    CMP.w #$006B : BNE .done+2

    LDA.l TournamentSeed : CMP.w #$0001 : BEQ +
        LDA.w MSUID : CMP.w #!VAL_MSU_ID_01 : BNE .done
        LDA.w MSUID+2 : CMP.w #!VAL_MSU_ID_23 : BNE .done
        LDA.w MSUID+4 : CMP.w #!VAL_MSU_ID_45 : BNE .done
    +

    LDA.l BigKeyField : AND.w #$0004 : BEQ .done           ; Check that we have the GT big key
    LDA.l MSUFallbackTable+7 : AND.w #$0004 : BEQ .done    ; Check that we have the extended track

.fade
    LDX.b #$F1 : STX.w MusicControlRequest

.done
    LDA.b RoomIndex    ; thing we wrote over
    RTL
;--------------------------------------------------------------------------------

;================================================================================
; Change music on stair transition (ToH/GT)
;--------------------------------------------------------------------------------
SpiralStairsPostCheck:
    LDA.b RoomIndex
    CMP.w #$000C : BNE +
        ; Ganon's tower entrance
        LDX.w LastAPUCommand : CPX.b #$F1 : BNE .done  ; Check that we were fading out

        LDX.b #22 : STX.w MusicControlRequest
        BRA .done
    +

    CMP.w #$006B : BNE .done

    ; Ganon's tower upstairs (with big key)
    LDX.w LastAPUCommand : CPX.b #$F1 : BNE .done  ; Check that we were fading out

    LDX.b #59 : STX.w MusicControlRequest

.done
    LDX.b #$1C : LDA.b RoomIndex   ; thing we wrote over
    RTL
;--------------------------------------------------------------------------------

;================================================================================
; Make sure expanded OST tracks load properly after death/fairy revival
;--------------------------------------------------------------------------------
StoreMusicOnDeath:
    STA.l GameOverSongCache   ; thing we wrote over
    LDA.w MSUSTATUS : BIT.b #!FLAG_MSU_STATUS_AUDIO_PLAYING : BEQ .done
    LDA.w CurrentMSUTrack : STA.l GameOverSongCache
.done
    RTL
;--------------------------------------------------------------------------------

;================================================================================
; Check if MSU-1 is enabled and scan for missing tracks
;--------------------------------------------------------------------------------
MSUInit:
    PHP

    LDA.b #$00
    STA.l MSULoadedTrack
    STA.l MSUResumeTrack
    STA.l MSUResumeTime : STA.l MSUResumeTime+1 : STA.l MSUResumeTime+2 : STA.l MSUResumeTime+3
    STA.l MSUResumeControl

    LDA.l NoBGM : BNE .done

    REP #$20

        LDA.w MSUID : CMP.w #!VAL_MSU_ID_01 : BNE .done
        LDA.w MSUID+2 : CMP.w #!VAL_MSU_ID_23 : BNE .done
        LDA.w MSUID+4 : CMP.w #!VAL_MSU_ID_45 : BNE .done

; Count the number of available MSU-1 packs
        LDA.w #$0000
        LDX.b #$FF
        LDY.b #$01
    SEP #$20

.check_pack
    TYA
    REP #$20
        STA.w MSUTRACK
        !ADD.w #100
        INX
    SEP #$20
    TAY
.wait_pack
    LDA.w MSUSTATUS : BIT.b #!FLAG_MSU_STATUS_AUDIO_BUSY : BNE .wait_pack
    LDA.w MSUSTATUS : BIT.b #!FLAG_MSU_STATUS_TRACK_MISSING : BEQ .check_pack
    TXA : STA.l MSUPackCount
    BRA +

; Check the current MSU-1 pack for tracks that require SPC fallback
.check_fallback
        PHP : SEP #$10
        LDA.l NoBGM : BNE .done
    + : LDA.b #64
    LDX.b #7
    LDY.b #7

.check_track
    STA.w MSUTRACK
    STZ.w MSUTRACK+1
    PHA
    CLC

.wait_track
    LDA.w MSUSTATUS : BIT.b #!FLAG_MSU_STATUS_AUDIO_BUSY : BNE .wait_track
    LDA.w MSUSTATUS : BIT.b #!FLAG_MSU_STATUS_TRACK_MISSING : BNE +
        SEC
    +
    LDA.l MSUFallbackTable,X : ROL : STA.l MSUFallbackTable,X

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
; Stop MSU-1 audio track and save the current position when approriate
;--------------------------------------------------------------------------------
MSUStopPlaying:
PHA : XBA : PHA
    LDA.l MSULoadedTrack
    JSR IsResumableTrack : BCC +
        ; dont save if we already saved recently
        REP #$20
        LDA.l MSUResumeTrack : AND #$00FF : BEQ ++
            LDA.l NMIFrames : !SUB MSUResumeTime : PHA
            LDA.l NMIFrames+2 : SBC MSUResumeTime+2 : BNE +++
                PLA : CMP.l MSUResumeTimer : !BLT .too_early
                BRA ++
            +++
            PLA
        ++
        ; saving
        LDA.l NMIFrames : STA.l MSUResumeTime
        LDA.l NMIFrames+2 : STA.l MSUResumeTime+2
        SEP #$20

        LDA.l MSULoadedTrack : STA.l MSUResumeTrack
        LDA.b #$00 : STA.l MSULoadedTrack ; dont take this path if we're calling again
        LDA.b #!FLAG_MSU_RESUME : STA.w MSUCTL ; save this track's position
        PLA : XBA : PLA
        RTS
        .too_early
        SEP #$20
    +
    LDA.b #$00 : STA.w MSUCTL
PLA : XBA : PLA
RTS
;--------------------------------------------------------------------------------

;================================================================================
; Play MSU-1 audio track
;--------------------------------------------------------------------------------
MSUMain:
    SEP #$20    ; set 8-BIT accumulator
    LDA.w RDNMI   ; thing we wrote over
    REP #$20    ; set 16-BIT accumulator
    LDA.w MSUID : CMP.w #!VAL_MSU_ID_01 : BEQ .continue
.nomsu
    SEP #$30
    -
    JML SPCContinue
.continue
    LDA.w MSUID+2 : CMP.w #!VAL_MSU_ID_23 : BNE .nomsu
    LDA.w MSUID+4 : CMP.w #!VAL_MSU_ID_45 : BNE .nomsu
    SEP #$30
    LDX.w MusicControl : BEQ +
        JMP .command_ff
    +
    LDA.l MSUDelayedCommand : BEQ .do_fade

.check_busy
    LDA.w MSUSTATUS : BIT.b #!FLAG_MSU_STATUS_AUDIO_BUSY : BNE -
.ready
    LDA.w MSUSTATUS : BIT.b #!FLAG_MSU_STATUS_TRACK_MISSING : BNE -
.start
    LDA.l MSUResumeControl : BIT.b #!FLAG_RESUME_CANCEL : BEQ +
        EOR.b #!FLAG_RESUME_CANCEL : STA.l MSUResumeControl
        REP #$20 : LDA.l MSULoadedTrack : STA.w MSUTRACK : SEP #$20
        BRA -
    +
    LDA.b #!VAL_VOLUME_FULL
    STA.w TargetVolume
    
    LDA.l MSUResumeControl : BIT.b #!FLAG_RESUME_FADEIN : BEQ +
        EOR.b #!FLAG_RESUME_FADEIN : STA.l MSUResumeControl
        LDA.b #$00
        BRA ++
    +
    LDA.b #!VAL_VOLUME_FULL
    ++
    STA.w CurrentVolume
    STA.w MSUVOL
    
    LDA.w CurrentMSUTrack : DEC : PHA
        AND.b #$07 : TAY
        PLA : LSR #3 : TAX
    LDA.l MSUFallbackTable,X : BEQ +++ : CMP.b #$FF : BEQ ++

    - : CPY #$00 : BEQ +
        LSR : DEY : BRA -
    +

    AND.b #$01 : BEQ +++
        ++ : LDA.l MSUDelayedCommand
    +++ : STA.w MSUCTL
    LDA.b #$00
    STA.l MSUDelayedCommand
    JML SPCContinue

.do_fade:
    LDA.w CurrentVolume : CMP.w TargetVolume : BNE +
        JML SPCContinue
    + : BCC .increment
.decrement
    SBC.b #!VAL_VOLUME_DECREMENT : BCC .mute
    CMP.w TargetVolume : !BGE .set
    LDA.w TargetVolume : BRA .set
.mute
    STZ.w CurrentVolume
    JSR MSUStopPlaying
    BRA .set
.increment
    ADC.b #!VAL_VOLUME_INCREMENT : BCS .max
    CMP.w TargetVolume : !BLT .set
    LDA.w TargetVolume : BRA .set
.max
    LDA.b #!VAL_VOLUME_FULL
.set
    STA.w CurrentVolume
    STA.w MSUVOL
    JML SPCContinue

.command_ff:
    CPX.b #!VAL_COMMAND_LOAD_NEW_BANK : BNE .command_f3
    JML SPCContinue

.command_f3:
    CPX.b #!VAL_COMMAND_FULL_VOLUME : BNE .command_f2
    LDA.b #!VAL_VOLUME_FULL
    STA.w TargetVolume
    JML SPCContinue

.command_f2:
    CPX.b #!VAL_COMMAND_FADE_HALF : BNE .command_f1
    LDA.b #!VAL_VOLUME_HALF
    STA.w TargetVolume
    JML SPCContinue

.command_f1:
    CPX.b #!VAL_COMMAND_FADE_OUT : BNE .command_f0
    STZ.w TargetVolume
    STZ.w CurrentMSUTrack
    JML SPCContinue

.command_f0:
    CPX.b #!VAL_COMMAND_STOP_PLAYBACK : !BLT .load_track
    CPX.b #!VAL_COMMAND_MUTE_SPC : BEQ +       ; Don't allow executing the mute/umute
    CPX.b #!VAL_COMMAND_UNMUTE_SPC : BNE ++    ; commands during NMI like this
        + : LDA.b #$00 : STA.w MusicControl
    ++ : JML SPCContinue

.load_track:
    CPX.w CurrentMSUTrack : BNE +
    - : CPX.b #27 : BEQ +
        TXA
        JMP .done+1
    +
    CPX.w CurrentControlRequest : BEQ -
    LDA.b #$00 : XBA
    LDA.l MSUPackCurrent : BEQ +
    - : CMP.l MSUPackCount : !BLT +
        !SUB.l MSUPackCount : BRA -
    +

    JSR MSUStopPlaying

    PHX : PHA : TXA : PLX
    REP #$20
    BEQ +
    -
        !ADD.w #100
        DEX : BNE -
    +
        STA.w MSUTRACK
        STA.l MSULoadedTrack
    SEP #$20

    PLX
    TXA : CMP.l MSUResumeTrack : BNE + ; dont resume if too late
        REP #$20
            LDA.l NMIFrames : !SUB MSUResumeTime : PHA
            LDA.l NMIFrames+2 : SBC MSUResumeTime+2 : BNE ++
                PLA : CMP.l MSUResumeTimer : !BGE +++
                SEP #$20
                LDA.b #!FLAG_RESUME_FADEIN : BRA .done_resume
            ++
            PLA
        +++
        SEP #$20
        LDA.b #!FLAG_RESUME_CANCEL
        .done_resume:
        STA.l MSUResumeControl
        LDA.b #$00 : STA.l MSUResumeTrack
    +
    CPX #07 : BNE + ; Kakariko Village
        LDA.b GameMode : CMP #$07 : BNE +
        ; we're in link's house -> ignore
        LDA.b #$00
        BRA ++
    +
    TXA
    ++
    STA.l MSULoadedTrack
    STX.w CurrentMSUTrack
    LDA.l MSUPackCurrent : CMP #$FE : !BLT +
        LDA.b #$00 : BRA ++
        + : LDA.l MSUTrackList-1,X
    ++ : STA.l MSUDelayedCommand
    LDA.l MSUExtendedFallbackList-1,X 
    CMP.b #17 : BEQ +
    CMP.b #22 : BEQ +
    CMP.b #35 : !BLT .done
    CMP.b #47 : !BGE .done

    + : PHB : REP #$10
        LDX.w DungeonID
        LDA.b #Music_Eastern>>16 : PHA : PLB    ; Set bank to music pointers
        LDY.b Scrap00 : PHY
            REP #$20
                LDA.l MSUDungeonFallbackList,X : STA.b Scrap00
            SEP #$20
            LDA.b (Scrap00)
    PLY : STY.b Scrap00 : SEP #$10 : PLB

.done
    - : TAX : CMP.l MSUExtendedFallbackList-1,X : BEQ +
        LDA.l MSUExtendedFallbackList-1,X : BRA -
    +
    STA.w MusicControl
    JML SPCContinue

;--------------------------------------------------------------------------------

;================================================================================
; Wait for the fanfare music to start, or else it can get skipped entirely
;--------------------------------------------------------------------------------
FanfarePreload:
    STA.w MusicControlRequest  ; thing we wrote over
    PHA
        JSL CheckMusicLoadRequest
        WAI
    PLA
    - : CMP.w APUIO0 : BNE -
    JML AddReceivedItem_doneWithSoundEffects
;--------------------------------------------------------------------------------

;================================================================================
; Wait for pendant fanfare to finish
;--------------------------------------------------------------------------------
PendantFanfareWait:
    LDA.l TournamentSeed : BNE .spc
    LDA.l FastFanfare : BNE .done
    REP #$20
    LDA.w MSUID : CMP.w #!VAL_MSU_ID_01 : BNE .spc
    LDA.w MSUID+2 : CMP.w #!VAL_MSU_ID_23 : BNE .spc
    LDA.w MSUID+4 : CMP.w #!VAL_MSU_ID_45 : BNE .spc
    SEP #$20
    LDA.l MSUPackCurrent : CMP #$FE : !BGE .spc
    LDA.w MSUSTATUS : BIT.b #!FLAG_MSU_STATUS_TRACK_MISSING : BNE .spc
    LDA.l MSUDelayedCommand : BNE .continue
    LDA.w MSUSTATUS : BIT.b #!FLAG_MSU_STATUS_AUDIO_PLAYING : BEQ .done
.continue
    jml PendantFanfareContinue
.spc
    SEP #$20
    LDA.l APUIO0 : BNE .continue
.done
    jml PendantFanfareDone
;--------------------------------------------------------------------------------

;================================================================================
; Wait for crystal fanfare to finish
;--------------------------------------------------------------------------------
CrystalFanfareWait:
    LDA.l TournamentSeed : BNE .spc
    LDA.l FastFanfare : BNE .done
    REP #$20
    LDA.w MSUID : CMP.w #!VAL_MSU_ID_01 : BNE .spc
    LDA.w MSUID+2 : CMP.w #!VAL_MSU_ID_23 : BNE .spc
    LDA.w MSUID+4 : CMP.w #!VAL_MSU_ID_45 : BNE .spc
    SEP #$20
    LDA.l MSUPackCurrent : CMP.b #$FE : !BGE .spc
    LDA.w MSUSTATUS : BIT.b #!FLAG_MSU_STATUS_TRACK_MISSING : BNE .spc
    LDA.l MSUDelayedCommand : BNE .continue
    LDA.w MSUSTATUS : BIT.b #!FLAG_MSU_STATUS_AUDIO_PLAYING : BEQ .done
.continue    
    jml CrystalFanfareContinue
.spc
    SEP #$20
    LDA.l APUIO0 : BNE .continue
.done
    JML CrystalFanfareDone
;--------------------------------------------------------------------------------

;================================================================================
; Delay input scanning on startup/S&Q to avoid hard-lock from button mashing
;--------------------------------------------------------------------------------
StartupWait:
    LDA.b GameSubMode : CMP.b #$04 : BCC .done    ; thing we wrote over
    LDA.w APUIO0 : BEQ .done-1
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
    LDA.w MSUID : CMP.w #!VAL_MSU_ID_01 : BNE .done
    LDA.w MSUID+2 : CMP.w #!VAL_MSU_ID_23 : BNE .done
    LDA.w MSUID+4 : CMP.w #!VAL_MSU_ID_45 : BNE .done
    SEP #$20
.wait
    LDA.b Strafe : BNE .done
    LDA.w MSUSTATUS : BIT.b #!FLAG_MSU_STATUS_AUDIO_PLAYING : BNE .wait
.done
    SEP #$20
    LDA.b #$22
    RTL
;--------------------------------------------------------------------------------
