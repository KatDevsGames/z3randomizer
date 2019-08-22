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
!REG_MUSIC_CONTROL = $012B
;!REG_MUSIC_CONTROL = $012C
!REG_MUSIC_CONTROL_REQUEST = $012C
!REG_CURRENT_TRACK = $0130
!REG_CURRENT_COMMAND = $0133

!REG_SPC_CONTROL = $2140
!REG_NMI_FLAGS = $4210

; $7EF50A0 - $7EF50AF Reserved block in main RAM
!REG_MSU_FALLBACK_TABLE = $7F50A0   ; 8 bytes
!REG_MSU_DELAYED_COMMAND = $7F50A9
!REG_MSU_PACK_COUNT = $7F50AA
!REG_MSU_PACK_CURRENT = $7F50AB

!VAL_COMMAND_FADE_OUT = #$F1
!VAL_COMMAND_FADE_HALF = #$F2
!VAL_COMMAND_FULL_VOLUME = #$F3
!VAL_COMMAND_LOAD_NEW_BANK = #$FF

!VAL_VOLUME_INCREMENT = #$10
!VAL_VOLUME_DECREMENT = #$02
!VAL_VOLUME_HALF = #$80
!VAL_VOLUME_FULL = #$FF

CheckMusicLoadRequest:
    PHP : REP #$10 : PHA : PHX
        LDA !REG_MUSIC_CONTROL_REQUEST : BEQ .done : BMI .done
        
    +;  ; Shut down NMI until music loads
        STZ $4200
        
        ; Set SPC into loader mode
        LDA.b #$FF : STA $2140

        LDA NoBGM : BNE .mute
        LDX !REG_MSU_ID_01 : CPX !VAL_MSU_ID_01 : BNE .unmute
        LDX !REG_MSU_ID_23 : CPX !VAL_MSU_ID_23 : BNE .unmute
        LDX !REG_MSU_ID_45 : CPX !VAL_MSU_ID_45 : BNE .unmute

        ; TODO: actually look up the current track in the table
        LDA !REG_MSU_FALLBACK_TABLE : BEQ .unmute

.mute
        LDA.b #SPCMutePayload : STA $00
        LDA.b #SPCMutePayload>>8 : STA $01
        LDA.b #SPCMutePayload>>16
        BRA .load

.unmute
        LDA.b #SPCUnmutePayload : STA $00
        LDA.b #SPCUnmutePayload>>8 : STA $01
        LDA.b #SPCUnmutePayload>>16

.load
        JSL Sound_LoadLightWorldSongBank_do_load
    
        ; Re-enable NMI and joypad
        LDA.b #$81 : STA $4200

        LDA $10
            CMP #$07 : BEQ .sfx_indoors : CMP #$0E : BEQ .sfx_indoors
            CMP #$09 : BNE .done

.sfx_outdoors
        SEP #$10
            ; PreOverworld_LoadProperties.noWarpVortex ; Bank02.asm:820
            LDX.b #$05
            LDA $7EF3C5 : CMP.b #$02 : BCS +
                LDX.b #$01 : +
            STX $012D
        REP #$10

.done
        LDA !REG_MUSIC_CONTROL_REQUEST : STA !REG_MUSIC_CONTROL : STZ !REG_MUSIC_CONTROL_REQUEST
    PLX : PLA : PLP
    RTL

.sfx_indoors
        LDA !REG_MUSIC_CONTROL_REQUEST : STA !REG_MUSIC_CONTROL : STZ !REG_MUSIC_CONTROL_REQUEST
    PLX : PLA : PLP
    JML Module_PreDungeon_setAmbientSfx

msu_init:
    PHP : REP #$20
        LDA #$0000
        STA !REG_MSU_VOLUME
        STA !REG_MSU_PACK_COUNT

        LDA !REG_MSU_ID_01 : CMP !VAL_MSU_ID_01 : BNE .done
        LDA !REG_MSU_ID_23 : CMP !VAL_MSU_ID_23 : BNE .done
        LDA !REG_MSU_ID_45 : CMP !VAL_MSU_ID_45 : BNE .done

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
.done
    PLP
    RTL

msu_main:
    SEP #$20    ; set 8-BIT accumulator
    LDA $4210   ; thing we wrote over
    REP #$20    ; set 16-BIT accumulator
    LDA !REG_MSU_ID_01 : CMP !VAL_MSU_ID_01 : BEQ .continue
.nomsu
    SEP #$30
    JML spc_continue
.continue
    LDA !REG_MSU_ID_23 : CMP !VAL_MSU_ID_23 : BNE .nomsu
    LDA !REG_MSU_ID_45 : CMP !VAL_MSU_ID_45 : BNE .nomsu
    SEP #$30
    LDX !REG_MUSIC_CONTROL : BNE command_ff
    LDA !REG_MSU_DELAYED_COMMAND : BEQ do_fade

msu_check_busy:
    LDA !REG_MSU_STATUS : BIT !FLAG_MSU_STATUS_AUDIO_BUSY : BEQ .ready
    JML spc_continue
.ready
    LDA !REG_MSU_STATUS : BIT !FLAG_MSU_STATUS_TRACK_MISSING : BEQ .start
    BRL alternate_fallback
.start
    LDA !VAL_VOLUME_FULL
    STA !REG_TARGET_VOLUME
    STA !REG_CURRENT_VOLUME
    STA !REG_MSU_VOLUME
    LDA !REG_MSU_DELAYED_COMMAND
    STA !REG_MSU_CONTROL
    LDA #$00
    STA !REG_MSU_DELAYED_COMMAND
    JML spc_continue

do_fade:
    LDA !REG_CURRENT_VOLUME : CMP !REG_TARGET_VOLUME : BNE .continue
    JML spc_continue
.continue
    BCC .increment
.decrement
    SBC !VAL_VOLUME_DECREMENT : BCS .set
.mute
    STZ !REG_CURRENT_VOLUME
    STZ !REG_MSU_CONTROL
    BRA .set
.increment
    ADC !VAL_VOLUME_INCREMENT : BCC .set
    LDA !VAL_VOLUME_FULL
.set
    STA !REG_CURRENT_VOLUME
    STA !REG_MSU_VOLUME
    JML spc_continue

command_ff:
    CPX !VAL_COMMAND_LOAD_NEW_BANK : BNE command_f3
    JML spc_continue

command_f3:
    CPX !VAL_COMMAND_FULL_VOLUME : BNE command_f2
    STX !REG_SPC_CONTROL
    LDA !VAL_VOLUME_FULL
    STA !REG_TARGET_VOLUME
    JML spc_continue

command_f2:
    CPX !VAL_COMMAND_FADE_HALF : BNE command_f1
    STX !REG_SPC_CONTROL
    LDA !VAL_VOLUME_HALF
    STA !REG_TARGET_VOLUME
    JML spc_continue

command_f1:
    CPX !VAL_COMMAND_FADE_OUT : BNE load_track
    STX !REG_SPC_CONTROL
    STZ !REG_TARGET_VOLUME
    STZ !REG_CURRENT_MSU_TRACK
    JML spc_continue

load_track:
    CPX !REG_CURRENT_MSU_TRACK : BNE .check_dungeon
    CPX #$1B : BEQ .continue
    JML spc_continue

.check_dungeon
    ;  Convert dungeon tracks to dungeon-specific ones
    CPX #$10 : BEQ .castle
    CPX #$11 : BEQ .dungeon
    CPX #$16 : BEQ .dungeon
    CPX #$15 : BNE .continue
; boss
    LDA $040C : LSR : !ADD #$2D
    BRA .continue-1
.castle
    LDA $040C : CMP #$08 : BEQ .dungeon+3 : BRA .continue
.dungeon
    LDA $040C : LSR : !ADD #$21 : TAX
.continue
    CPX !REG_CURRENT_MSU_TRACK : BNE +
        JML spc_continue
    +
    LDA #$00 : XBA
    LDA !REG_MSU_PACK_CURRENT : BEQ +

    -
        CMP !REG_MSU_PACK_COUNT : !BLT +
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
    LDA.l MSUTrackList,x
    STA !REG_MSU_DELAYED_COMMAND
    STX !REG_CURRENT_MSU_TRACK
    JML spc_continue

alternate_fallback:
    LDA !REG_CURRENT_MSU_TRACK : AND #$3F
    CMP #$0F : BEQ .woods           ;    15: dark woods
    CMP #$23 : !BLT spc_fallback    ;  < 35: normal tracks
    CMP #$2F : !BGE .boss           ;  > 46: boss-specific tracks
    CMP #$25 : BEQ .castle          ;    37: aga tower, fall back to hyrule castle
    BRA .dungeon                    ; 35-46: dungeon-specific tracks

.woods
    LDA #$0D : BRA .fallback
.boss
    LDA #$15 : BRA .fallback
.castle
    LDA #$10 : BRA .fallback

.dungeon
    PHB : REP #$10
        LDX $040C
        LDA.b #Music_Eastern>>16 : PHA : PLB    ; Set bank to music pointers
        LDY $00 : PHY
        REP #$20
            LDA MSUDungeonFallbackList,X : STA $00
        SEP #$20
        LDA ($00)
    PLY : STY $00 : SEP #$10 : PLB

.fallback
    STA !REG_CURRENT_MSU_TRACK
    TAX

    LDA #$00 : XBA
    LDA !REG_MSU_PACK_CURRENT : BEQ +

    -
        CMP !REG_MSU_PACK_COUNT : !BLT +
        !SUB !REG_MSU_PACK_COUNT : BRA -
    +

    PHA : TXA : PLX
    REP #$20
    BEQ +
    -
        !ADD.w #100
        DEX : BNE -
    +
        STA !REG_MSU_TRACK
    SEP #$20
    JML spc_continue

spc_fallback:
    LDA #$00
    STA !REG_MSU_DELAYED_COMMAND
    STZ !REG_MSU_CONTROL
    STZ !REG_CURRENT_MSU_TRACK
    STZ !REG_TARGET_VOLUME
    STZ !REG_CURRENT_VOLUME
    STZ !REG_MSU_VOLUME
    JML spc_continue

pendant_fanfare:
    LDA TournamentSeed : BNE .spc
    REP #$20
    LDA !REG_MSU_ID_01 : CMP !VAL_MSU_ID_01 : BNE .spc
    LDA !REG_MSU_ID_23 : CMP !VAL_MSU_ID_23 : BNE .spc
    LDA !REG_MSU_ID_45 : CMP !VAL_MSU_ID_45 : BNE .spc
    SEP #$20
    LDA !REG_MSU_STATUS : BIT !FLAG_MSU_STATUS_TRACK_MISSING : BNE .spc
    LDA !REG_MSU_DELAYED_COMMAND : BNE .continue
    LDA !REG_MSU_STATUS : BIT !FLAG_MSU_STATUS_AUDIO_PLAYING : BEQ .done
.continue
    jml pendant_continue
.spc
    SEP #$20
    LDA !REG_SPC_CONTROL : BNE .continue
.done
    jml pendant_done


crystal_fanfare:
    LDA TournamentSeed : BNE .spc
    REP #$20
    LDA !REG_MSU_ID_01 : CMP !VAL_MSU_ID_01 : BNE .spc
    LDA !REG_MSU_ID_23 : CMP !VAL_MSU_ID_23 : BNE .spc
    LDA !REG_MSU_ID_45 : CMP !VAL_MSU_ID_45 : BNE .spc
    SEP #$20
    LDA !REG_MSU_STATUS : BIT !FLAG_MSU_STATUS_TRACK_MISSING : BNE .spc
    LDA !REG_MSU_DELAYED_COMMAND : BNE .continue
    LDA !REG_MSU_STATUS : BIT !FLAG_MSU_STATUS_AUDIO_PLAYING : BEQ .done
.continue    
    jml crystal_continue
.spc
    SEP #$20
    LDA !REG_SPC_CONTROL : BNE .continue
.done
    jml crystal_done


ending_wait:
    REP #$20
    LDA !REG_MSU_ID_01 : CMP !VAL_MSU_ID_01 : BNE .done
    LDA !REG_MSU_ID_23 : CMP !VAL_MSU_ID_23 : BNE .done
    LDA !REG_MSU_ID_45 : CMP !VAL_MSU_ID_45 : BNE .done
    SEP #$20
.wait
    LDA !REG_MSU_STATUS : BIT !FLAG_MSU_STATUS_AUDIO_PLAYING : BNE .wait
.done
    SEP #$20
    LDA #$22
    RTL
