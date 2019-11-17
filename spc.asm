// Build with bass v15
// This code apparently triggers a pathalogical edge case
// which breaks forward labels, necessitating db-style branches
// but the code is really only for documentation anyway, we're
// using a compiled .bps patch for actual patch generation.

architecture wdc65816

macro rom_seek(variable address) {
    origin ((address & $7F0000) >> 1) | (address & $7FFF)
    base address
}

rom_seek($400000)   // Pad ROM to 0x200000

rom_seek($008901)
lda.b #(SPC.IntroSongBank & 0xFF); sta $00
lda.b #((SPC.IntroSongBank >> 8) & 0xFF); sta $01
lda.b #((SPC.IntroSongBank >> 16) & 0xFF); sta $02

rom_seek($348000)   // Seek to ROM offset 0x1A0000

architecture spc700

namespace SPC {
constant ENGINE_ENTRYPOINT = $0800
constant NEW_CODE_LENGTH = (EngineStart - NewCodeSection)
constant CODE_START = (ENGINE_ENTRYPOINT - NEW_CODE_LENGTH)

macro spc_seek(variable address) {
    origin (address & $FFFF) + (((START & $7F0000) >> 1) | (START & $7FFF)) - CODE_START
    base address
}

// Insert the original SPC transfer blocks up to the main engine code
insert IntroSongBank, "alttp.sfc", 0x0C8000, 0x7BCA
dw NEW_CODE_LENGTH + $0F9E  // New code is prepended to the original upload
dw CODE_START               // of length $0F9E to destination $0800


START:
spc_seek(CODE_START)
if pc() < $0700 {
    error "SPC code out of bounds (PC < $0700)"
}

// Any new code goes here.  DON'T DELETE THIS LABEL
// Labels not forward-declared (e.g. '+/++') don't work here
NewCodeSection:

SpecialCommand_Mute:
cmp #$F0                    // The thing we overwrote
// bne +
db $D0, $03
  jmp $0A81                 // SilenceSong
+; cmp #$FA                 // New mute command $FA
// bne +
db $D0, $1C
  sta $F4
  lda #$00
  sta $0A4A                 // $0A49: lda #$70 -> lda #$00
  sta $0AF3                 // $0AF2: MOV $059,#$C0 -> MOV $059,#$00
  sta $0C32                 // $0C32: MOVW $058,YA -> NOP #2
  sta $0C33
  lda #$C4                  // $0D19: MOVW $058,YA -> lda $058
  sta $0D19
  lda #$58
  sta $0D1A
  // bra ++
  db $2F, $23
+; cmp #$FB                 // New unmute command $FB
// beq +
db $F0, $03
  jmp $0A9D                 // NewSongInput
+;  sta $F4
lda #$70
sta $0A4A                   // $0A49: lda #$70
lda #$C0
sta $0AF3                   // $0AF2: MOV $059,#$C0
lda #$DA
sta $0C32                   // $0C32: MOVW $058,YA
sta $0D19                   // $0D19: MOVW $058,YA
lda #$58
sta $0C33
sta $0D1A
+; jsr $0A81                // SilenceSong
-; lda $F4
      bne -
      cmp $F4
      bne -
str $F4=$00                 // ACK the CPU
rts

EngineStart:
// Upload the main engine, along with the rest of the original transfer block
insert "alttp.sfc", 0x0CFBCE, 0x57B2

// Hook to check for new special mute commands FA, FB
spc_seek($0A73)             // $0A73: CMP A,#$F0
jmp SpecialCommand_Mute
nop

rom_seek($0C8000)
fill 0xD380

}   // namespace SPC