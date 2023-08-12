RenderCharSetColorExtended_init:
    stz.b Scrap0C
    jsl Attract_DecompressStoryGfx
    rtl

RenderCharSetColorExtended_close:
    stz.b Scrap0C
    lda.w GameModeCache
    sta.b GameMode
    rtl

RenderCharSetColorExtended:
    pha
    and.b #$10
    cmp.b #$10
    beq .inverted
    lda.b #$00
    bra .end
.inverted
    lda.b #$01
.end
    sta.b Scrap0C
    pla
    and.b #$07 : asl : asl
    rtl

RenderCharToMapExtended:
    phx : tya : asl #2 : tax
    lda.l FontProperties, x : bit.w #$0001 : bne .uncompressed
.compressed
    plx
    lda.w #$0000
    sta.b Scrap00
    lda.w #$007f
    sta.b Scrap02
    lda.w #$0000
    clc : adc.w #$0020
    sta.b Scrap03
    lda.w #$007f
    sta.b Scrap05
    jml RenderCharToMapExtended_return

.uncompressed    
    lda.l FontProperties+$2, x
    plx
    clc : adc.w #(NewFont&$ffff)
    sta.b Scrap00
    clc : adc.w #$0100
    pha
    lda.w #(NewFont>>16)
    sta.b Scrap02
    pla : sta.b Scrap03
    lda.w #(NewFont>>16)
    sta.b Scrap05
    jml RenderCharToMapExtended_return

RenderCharLookupWidthDraw:
    rep #$30
    phx : lda.b Scrap09 : and.w #$fffe : tax
    lda.l FontProperties, x
    bmi .thin
.wide
    plx : sep #$30
    lda.b Scrap09 : and.b #$03 : tay
    lda.w $fd7c, y : tay
    jml RenderCharLookupWidthDraw_return
.thin
    xba : and.w #$004f : bne .vwf
    plx : sep #$30
    lda.b Scrap09 : and.b #$03 : phx : tax
    lda.l RenderCharThinTable, x : tay : plx
    jml RenderCharLookupWidthDraw_return
.vwf
    and.w #$000f : tay
    plx : sep #$30
    lda.b Scrap09 : and.b #$03 : phx : tax
    cpx.b #$00 : bne +
    tya : bra ++
+   lda.l RenderCharThinTable, x
++  tay : plx : jml RenderCharLookupWidthDraw_return


RenderCharLookupWidth:
    phx : lda.b Scrap09 : and.w #$fffe : tax
    lda.l FontProperties, x
    bmi .thin
.wide
    plx : lda.w $fd7c, x : clc
    rtl
.thin
    xba : and.w #$004f : bne .vwf
    plx : lda.l RenderCharThinTable, x : clc
    rtl
.vwf
    and.w #$000f     
    plx : cpx.w #$0000 : beq + : lda.l RenderCharThinTable, x
+   clc : rtl

RenderCharThinTable:
    db $08, $00, $ff

RenderCharExtended:
    pha
    asl : asl : tax
    lda.l FontProperties, x : and.w #$00ff : bne .renderUncompressed

.renderOriginal
    pla : asl : tax : asl : adc.b Scrap0E
    jml RenderCharExtended_returnOriginal

.renderUncompressed
    pla : phb : pea.w NewFont>>8 : plb : plb
    lda.l FontProperties+$2, x
    tay

    lda.b Scrap0C
    bne .inverted

    ldx.w #$0000
-
    lda.w NewFont, y
    sta.l $7EBFC0, x
    lda.w NewFont+$100, y
    sta.l $7EBFC0+$16, x
    inx #02
    iny #02
    cpx.w #$0010
    bne -
    bra .end

.inverted
    ldx.w #$0000
-
    lda.w NewFontInverted, y
    sta.l $7EBFC0, x
    lda.w NewFontInverted+$100, y
    sta.l $7EBFC0+$16, x
    inx #02
    iny #02
    cpx.w #$0010
    bne -

.end    
    plb
    jml RenderCharExtended_returnUncompressed

; Table of font properties and tilemap offset
; Properties are these for now:
;  tv--wwww -------u
;  t = thin spacing (0 px instead of 3 px)
;  u = uncompressed character loaded from offset
;  v = use variable width rendering for this character (thin spacing must be set as well)
;  w = character width for VWF rendering

FontProperties:
;      props, offset
    dw $0000, $0000     ; 00
    dw $0000, $0000     ; 01
    dw $0000, $0000     ; 02
    dw $0000, $0000     ; 03
    dw $0000, $0000     ; 04
    dw $0000, $0000     ; 05
    dw $0000, $0000     ; 06
    dw $0000, $0000     ; 07
    dw $0000, $0000     ; 08
    dw $0000, $0000     ; 09
    dw $0000, $0000     ; 0A
    dw $0000, $0000     ; 0B
    dw $0000, $0000     ; 0C
    dw $0000, $0000     ; 0D
    dw $0000, $0000     ; 0E
    dw $0000, $0000     ; 0F

    dw $0000, $0000     ; 10
    dw $0000, $0000     ; 11
    dw $0000, $0000     ; 12
    dw $0000, $0000     ; 13
    dw $0000, $0000     ; 14
    dw $0000, $0000     ; 15
    dw $0000, $0000     ; 16
    dw $0000, $0000     ; 17
    dw $0000, $0000     ; 18
    dw $0000, $0000     ; 19
    dw $0000, $0000     ; 1A
    dw $0000, $0000     ; 1B
    dw $0000, $0000     ; 1C
    dw $0000, $0000     ; 1D
    dw $0000, $0000     ; 1E
    dw $0000, $0000     ; 1F

    dw $0000, $0000     ; 20
    dw $0000, $0000     ; 21
    dw $0000, $0000     ; 22
    dw $0000, $0000     ; 23
    dw $0000, $0000     ; 24
    dw $0000, $0000     ; 25
    dw $0000, $0000     ; 26
    dw $0000, $0000     ; 27
    dw $0000, $0000     ; 28
    dw $0000, $0000     ; 29
    dw $0000, $0000     ; 2A
    dw $0000, $0000     ; 2B
    dw $0000, $0000     ; 2C
    dw $0000, $0000     ; 2D
    dw $0000, $0000     ; 2E
    dw $0000, $0000     ; 2F

    dw $0000, $0000     ; 30
    dw $0000, $0000     ; 31
    dw $0000, $0000     ; 32
    dw $0000, $0000     ; 33
    dw $0000, $0000     ; 34
    dw $0000, $0000     ; 35
    dw $0000, $0000     ; 36
    dw $0000, $0000     ; 37
    dw $0000, $0000     ; 38
    dw $0000, $0000     ; 39
    dw $0000, $0000     ; 3A
    dw $0000, $0000     ; 3B
    dw $0000, $0000     ; 3C
    dw $0000, $0000     ; 3D
    dw $0000, $0000     ; 3E
    dw $0000, $0000     ; 3F

    dw $0000, $0000     ; 40
    dw $0000, $0000     ; 41
    dw $0000, $0000     ; 42
    dw $0000, $0000     ; 43
    dw $0000, $0000     ; 44
    dw $0000, $0000     ; 45
    dw $0000, $0000     ; 46
    dw $0000, $0000     ; 47
    dw $0000, $0000     ; 48
    dw $0000, $0000     ; 49
    dw $0000, $0000     ; 4A
    dw $0000, $0000     ; 4B
    dw $0000, $0000     ; 4C
    dw $0000, $0000     ; 4D
    dw $0000, $0000     ; 4E
    dw $8001, $0DF0     ; 4F ; <sp>

    dw $0000, $0000     ; 50
    dw $0000, $0000     ; 51
    dw $0000, $0000     ; 52
    dw $0000, $0000     ; 53
    dw $0000, $0000     ; 54
    dw $0000, $0000     ; 55
    dw $0000, $0000     ; 56
    dw $0000, $0000     ; 57
    dw $0000, $0000     ; 58
    dw $0000, $0000     ; 59
    dw $0000, $0000     ; 5A
    dw $0000, $0000     ; 5B
    dw $0000, $0000     ; 5C
    dw $0000, $0000     ; 5D
    dw $0000, $0000     ; 5E
    dw $0000, $0000     ; 5F

    dw $0000, $0000     ; 60
    dw $0000, $0000     ; 61
    dw $0000, $0000     ; 62
    dw $0000, $0000     ; 63
    dw $0000, $0000     ; 64
    dw $0000, $0000     ; 65
    dw $0000, $0000     ; 66
    dw $0000, $0000     ; 67
    dw $0000, $0000     ; 68
    dw $0000, $0000     ; 69
    dw $0000, $0000     ; 6A
    dw $0000, $0000     ; 6B
    dw $0000, $0000     ; 6C
    dw $0000, $0000     ; 6D
    dw $0000, $0000     ; 6E
    dw $0000, $0000     ; 6F

    dw $0000, $0000     ; 70
    dw $0000, $0000     ; 71
    dw $0000, $0000     ; 72
    dw $0000, $0000     ; 73
    dw $0000, $0000     ; 74
    dw $0000, $0000     ; 75
    dw $0000, $0000     ; 76
    dw $0000, $0000     ; 77
    dw $0000, $0000     ; 78
    dw $0000, $0000     ; 79
    dw $0000, $0000     ; 7A
    dw $0000, $0000     ; 7B
    dw $0000, $0000     ; 7C
    dw $0000, $0000     ; 7D
    dw $0000, $0000     ; 7E
    dw $0000, $0000     ; 7F

    dw $0000, $0000     ; 80
    dw $0000, $0000     ; 81
    dw $0000, $0000     ; 82
    dw $0000, $0000     ; 83
    dw $0000, $0000     ; 84
    dw $0000, $0000     ; 85
    dw $0000, $0000     ; 86
    dw $0000, $0000     ; 87
    dw $0000, $0000     ; 88
    dw $0000, $0000     ; 89
    dw $0000, $0000     ; 8A
    dw $0000, $0000     ; 8B
    dw $0000, $0000     ; 8C
    dw $0000, $0000     ; 8D
    dw $0000, $0000     ; 8E
    dw $0000, $0000     ; 8F

    dw $0000, $0000     ; 90
    dw $0000, $0000     ; 91
    dw $0000, $0000     ; 92
    dw $0000, $0000     ; 93
    dw $0000, $0000     ; 94
    dw $0000, $0000     ; 95
    dw $0000, $0000     ; 96
    dw $8001, $0AD0     ; 97 ; /
    dw $8001, $0AE0     ; 98 ; •
    dw $8001, $02A0     ; 99 ; Cursor |>
    dw $0000, $0000     ; 9A ; smiley lookin JP char
    dw $8001, $06A0     ; 9B ; Link face left
    dw $8001, $06B0     ; 9C ; Link face right
    dw $8001, $06E0     ; 9D ; '
    dw $8001, $0AF0     ; 9E ; "
    dw $8001, $02E0     ; 9F ; ellipsis ...

    dw $8001, $0800     ; A0 ; 0
    dw $8001, $0810     ; A1
    dw $8001, $0820     ; A2
    dw $8001, $0830     ; A3
    dw $8001, $0840     ; A4
    dw $8001, $0850     ; A5
    dw $8001, $0860     ; A6
    dw $8001, $0870     ; A7
    dw $8001, $0880     ; A8
    dw $8001, $0890     ; A9 ; 9
    dw $8001, $0000     ; AA ; A
    dw $8001, $0010     ; AB
    dw $8001, $0020     ; AC
    dw $8001, $0030     ; AD
    dw $8001, $0040     ; AE
    dw $8001, $0050     ; AF

    dw $8001, $0060     ; B0
    dw $8001, $0070     ; B1
    dw $8001, $0080     ; B2
    dw $8001, $0090     ; B3
    dw $8001, $00A0     ; B4
    dw $8001, $00B0     ; B5
    dw $8001, $00C0     ; B6
    dw $8001, $00D0     ; B7
    dw $8001, $00E0     ; B8
    dw $8001, $00F0     ; B9
    dw $8001, $0200     ; BA
    dw $8001, $0210     ; BB
    dw $8001, $0220     ; BC
    dw $8001, $0230     ; BD
    dw $8001, $0240     ; BE
    dw $8001, $0250     ; BF

    dw $8001, $0260     ; C0
    dw $8001, $0270     ; C1
    dw $8001, $0280     ; C2
    dw $8001, $0290     ; C3 ; Z
    dw $8000, $0000     ; C4
    dw $8000, $0000     ; C5
    dw $8001, $06D0     ; C6 ; ?
    dw $8001, $06C0     ; C7 ; !
    dw $8001, $02D0     ; C8 ; ,
    dw $8001, $02B0     ; C9 ; -
    dw $8000, $0000     ; CA ; 🡄"
    dw $8000, $0000     ; CB ; 🡆
    dw $0000, $0000     ; CC ; Blank char
    dw $8001, $02C0     ; CD ; .
    dw $8001, $02F0     ; CE ; ~
    dw $8000, $0000     ; CF ;

    dw $8001, $0400     ; D0 ; a
    dw $8001, $0410     ; D1
    dw $8001, $0420     ; D2
    dw $8001, $0430     ; D3
    dw $8001, $0440     ; D4
    dw $8001, $0450     ; D5
    dw $8001, $0460     ; D6
    dw $8001, $0470     ; D7
    dw $8001, $0480     ; D8
    dw $8001, $0490     ; D9
    dw $8001, $04A0     ; DA
    dw $8001, $04B0     ; DB
    dw $8001, $04C0     ; DC
    dw $8001, $04D0     ; DD
    dw $8001, $04E0     ; DE
    dw $8001, $04F0     ; DF ; p

    dw $8001, $0600     ; E0 ; q
    dw $8001, $0610     ; E1
    dw $8001, $0620     ; E2
    dw $8001, $0630     ; E3
    dw $8001, $0640     ; E4
    dw $8001, $0650     ; E5
    dw $8001, $0660     ; E6
    dw $8001, $0670     ; E7
    dw $8001, $0680     ; E8
    dw $8001, $0690     ; E9 ; z
    dw $8001, $0A80     ; EA ; :
    dw $8001, $0A90     ; EB ; @ (thin)
    dw $8001, $0AA0     ; EC ; # (thin)
    dw $8001, $0A00     ; ED ; _
    dw $0000, $0000     ; EE
    dw $0000, $0000     ; EF

    dw $0000, $0000     ; F0
    dw $0000, $0000     ; F1
    dw $0000, $0000     ; F2
    dw $0000, $0000     ; F3
    dw $0000, $0000     ; F4
    dw $0000, $0000     ; F5
    dw $0000, $0000     ; F6
    dw $0000, $0000     ; F7
    dw $0000, $0000     ; F8
    dw $0000, $0000     ; F9
    dw $0000, $0000     ; FA
    dw $0000, $0000     ; FB
    dw $0000, $0000     ; FC
    dw $0000, $0000     ; FD
    dw $0000, $0000     ; FE
    dw $8001, $0DF0     ; FF ; <sp>
