;--------------------------------------------------------------------------------
CheckZSNES:
    SEP #$28
    LDA #$FF
    CLC
    ADC #$FF
    CMP #$64
    CLD
    BEQ .zsnes
    REP #$20
    LDA #$01FF : TCS ; thing we wrote over - initialize stack
JML.l ReturnCheckZSNES
.zsnes
; Set up video mode
    SEP #$30    ; X,Y,A are 8 bit numbers
    LDA #$80    ; screen off
    STA $2100   ; brightness + screen enable register
    LDA #$03
    STA $2105   ; video mode 3, 8x8 tiles, 256 color BG1, 16 color BG2
    STZ $2106   ; noplanes, no mosaic, = Mosaic register
    LDA #$01
    STA $210B   ; Set BG1 tile data offset to $2000
    STZ $210D   ; Plane 0 scroll x (first 8 bits)
    STZ $210D   ; Plane 0 scroll x (last 3 bits) #$0 - #$07ff
    LDA #$01
    STA $212C   ; Enable BG1
    LDA #$FF
    STA $210E   ; Set BG1 scroll register
    STA $210E
    STZ $212E   ; Window mask for Main Screen
    STZ $212F   ; Window mask for Sub Screen
    LDA #$30
    STA $2130   ; Color addition & screen addition init setting
    STZ $2131   ; Add/Sub sub designation for screen, sprite, color
    LDA #$E0
    STA $2132   ; color data for addition/subtraction
    STZ $2133   ; Screen setting (interlace x,y/enable SFX data)
    STZ $4200   ; Disable V-blank, interrupt, Joypad register
    
    REP #$10


; Load tilemap and tile data
    STZ $2116
    LDA #$0C
    STA $2107   ; Set BG1 tilemap offset to $1800 and size to 32x32
    STA $2117   ; VRAM write address $1800
    
    LDA #$80
    STA $2115   ; VRAM single word transfer, word increment
    LDX #$1801
    STX $4300   ; DMA destination: VMDATAL/VMDATAH, fixed source
    LDX.w #ZSNES_TileMap
    STX $4302   ; Low DMA source address
    LDA.b #ZSNES_TileMap>>16
    STA $4304   ; High DMA source address
    LDX.w #$800
    STX $4305   ; Transfer 2048 bytes
    LDA #$01
    STA $420B   ; Start DMA transfer
    
    LDX.w #ZSNES_Tiles
    STX $4302   ; Low DMA source address
    LDA.b #ZSNES_Tiles>>16
    STA $4304   ; High DMA source address
    LDX.w #$8000
    STX $4305   ; Transfer 32768 bytes
    LDA #$01
    STA $420B   ; Start DMA transfer
    
    LDX.w #$8000
    STX $4302   ; Low DMA source address
    LDA.b #$38 ; (ZSNES_Tiles>>16)+1
    STA $4304   ; High DMA source address
    LDX.w #$6040
    STX $4305   ; Transfer 24640 bytes
    LDA #$01
    STA $420B   ; Start DMA transfer

; Load CGRAM via DMA transfer

    STZ $2121   ; Start at color 0
    LDX #$2200
    STX $4300   ; DMA destination: CGDATA, byte increment
    LDX.w #ZSNES_Palette
    STX $4302   ; Low DMA source address
    LDA.b #ZSNES_Palette>>16
    STA $4304   ; High DMA source address
    LDX #$0200
    STX $4305   ; Transfer 512 bytes
    LDA #$01
    STA $420B   ; Start DMA transfer

    LDA #$0F    ; screen on, full brightness
    STA $2100   ; brightness + screen enable register
	
STP ; !
;--------------------------------------------------------------------------------
org $378000

ZSNES_Tiles:
    incbin zsnes_tiles.bin
    
ZSNES_TileMap:
    incbin zsnes_tilemap.bin

ZSNES_Palette:
    incbin zsnes_pal.bin
	