; WARNING: THIS CODE IS EXTREMELY FRAGILE

macro copybin(source, length)
    !copycount #= 0
    while !copycount+3 < <length>
        dd read4(pctosnes(<source>+!copycount))
        !copycount #= !copycount+4
    endif

    while !copycount < <length>
        db read1(pctosnes(<source>+!copycount))
        !copycount #= !copycount+1
    endif
endmacro

;@ pushpc
org $008901
LDA.b #SPCData : STA $00
LDA.b #SPCData>>8 : STA $01
LDA.b #SPCData>>16 : STA $02
;@ pullpc

SPCData:
;@ check bankcross off
%copybin($0C8000, $7BCA)

!SPCEngineStart = $0800
!SPCCodeStart = $07A7

dw ($0F9E+(!SPCEngineStart-!SPCCodeStart))
dw !SPCCodeStart

;@ pushpc
;@ pushbase

arch spc700
base !SPCCodeStart
org $34FBCE;-(!SPCEngineStart-!SPCCodeStart)
NewSPCCode:

SpecialCommand_Mute:
CMP A,#$F0      ; The thing we overwrote
BNE +
    JMP $0A81   ; SilenceSong
+
CMP A,#$FA      ; New mute command $FA
BNE +
    MOV $F4,A
    MOV A,#$00
    MOV $0A4A,A ; $0A49: MOV A,#$70 -> MOV A,#$00
    MOV $0AF3,A ; $0AF2: MOV $059,#$C0 -> MOV $059,#$00
    MOV $0C32,A ; $0C32: MOVW $058,YA -> NOP #2
    MOV $0C33,A
    MOV A,#$C4  ; $0D19: MOVW $058,YA -> MOV A,$058
    MOV $0D19,A
    MOV A,#$58
    MOV $0D1A,A
    BRA +++
+
CMP A,#$FB      ; New unmute command $FB
BEQ +
    JMP $0A9D   ; NewSongInput
+
MOV $F4,A
MOV A,#$70
MOV $0A4A,A     ; $0A49: MOV A,#$70
MOV A,#$C0
MOV $0AF3,A     ; $0AF2: MOV $059,#$C0
MOV A,#$DA
MOV $0C32,A     ; $0C32: MOVW $058,YA
MOV $0D19,A     ; $0D19: MOVW $058,YA
MOV A,#$58
MOV $0C33,A
MOV $0D1A,A
+++
CALL $0A81      ; SilenceSong
- : MOV A,$F4
    BNE -
    CMP A,$F4
    BNE -
MOV $F4,$00
RET

org !SPCEngineStart

arch 65816
SPCEngineStart:
;@ pullbase
;@ pullpc
skip !SPCEngineStart-!SPCCodeStart
%copybin($0CFBCE, $57B2)
SPCEngineEnd:
;@ check bankcross on

; Change track 15 (unused) to point to 13 (Death Mountain) so dark woods can be track 15
; Bank 1
org $1A9F15 ; PC 0x0D1F15 ; SPC $D01C
	dw #$2B00	; Set track 15 pointer to track 13's data

; Bank 2
org $359F6E ; PC 0x1A9F6E ; SPC $D01C
	dw #$2B00	; Set track 15 pointer to track 13's data

arch spc700
org $34FE9A ; PC 0x1A7E9A ; SPC $0A73
    JMP !SPCCodeStart : NOP
arch 65816
