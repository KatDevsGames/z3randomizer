;=======================================
; SPC engine changes
;
; Free space at $040F-07FF (probably)
;
; If we ever switch to ASAR we can rewrite
; this as actual SPC asm instead of this
; db jank.

; seek($0700)
db $68, $F0         ; CMP A,#$F0            ; the thing we overwrote
db $D0, $03         ; BNE +
db $5F, $81, $0A    ;   JMP SilenceSong     ; ($0A81)
db $68, $FA         ; + : CMP A,#$FA        ; new mute command $FA
db $D0, $1A         ; BNE +
db $E8, $00         ;   MOV A,#$00
db $C5, $4A, $0A    ;   MOV $0A4A,A         ; $0A49: MOV A,#$70 -> MOV A,#$00
db $C5, $F3, $0A    ;   MOV $0AF3,A         ; $0AF2: MOV $059,#$C0 -> MOV $059,#$00
db $C5, $32, $0C    ;   MOV $0C32,A         ; $0C32: MOVW $058,YA -> NOP #2
db $C5, $33, $0C    ;   MOV $0C33,A
db $E8, $C4         ;   MOV A,#$C4          ; $0D19: MOVW $058,YA -> MOV $058,A
db $C5, $19, $0D    ;   MOV $0D19,A
db $E8, $58         ;   MOV A,#$58
db $C5, $1A, $0D    ;   MOV $0D1A,A
db $2F, $21         ;   BRA ++
db $68, $FB         ; + : CMP A,#$FB        ; new unmute command $FB
db $F0, $03         ; BEQ +
db $5F, $9D, $0A    ;   JMP NewSongInput    ; ($0A9D)
db $E8, $70         ; + : MOV A,#$70
db $C5, $4A, $0A    ; MOV $0A4A,A           ; $0A49: MOV A,#$70
db $E8, $C0         ; MOV A,#$C0
db $C5, $F3, $0A    ; MOV $0AF3,A           ; $0AF2: MOV $059,#$C0
db $E8, $DA         ; MOV A,#$DA
db $C5, $32, $0C    ; MOV $0C32,A           ; $0C32: MOVW $058,YA
db $C5, $19, $0D    ; MOV $0D19,A           ; $0D19: MOVW $058,YA
db $E8, $58         ; MOV A,#$58
db $C5, $33, $0C    ; MOV $0C33,A
db $C5, $1A, $0D    ; MOV $0D1A,A
db $3F, $81, $0A    ; ++ : CALL SilenceSong  ; ($0A81)
db $FA, $00, $04    ; MOV $04, $00
db $6F              ; RET
