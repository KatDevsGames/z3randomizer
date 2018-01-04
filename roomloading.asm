LoadRoomHook:
    JSL $01873A ; Dungeon_LoadRoom (Bank01.asm:726)
    REP #$10 ; 16 bit XY
        LDX $A0 ; Room ID
        LDA RoomCallbackTable, X
    SEP #$10 ; 8 bit XY
    JSL $00879c ; UseImplicitRegIndexedLocalJumpTable
; Callback routines:
    dl NoCallback ; 00
    dl IcePalace1 ; 01

NoCallback:
    RTL

!RL_TILE = 2
!RL_LINE = 128

macro setTilePointer(roomX, roomY, quadX, quadY)
    ; Left-to-right math. Should be equivalent to 0x7e2000+(roomX*2)+(roomY*128)+(quadX*64)+(quadY*4096)
    LDX.w #<quadY>*32+<roomY>*2+<quadX>*32+<roomX>*2
endmacro

macro writeTile()
    STA.l $7E2000,x
    INX #2
endmacro

!IP_BORDER = #$08D0
!IP_ICON_1 = #$0CCA
!IP_ICON_2 = #$0CCB
!IP_ICON_3 = #$0CDA
!IP_ICON_4 = #$0CDB

!IP1_X = 14
!IP1_Y = 18

IcePalace1:
    REP #$30 ; 16 AXY
        %setTilePointer(!IP1_X, !IP1_Y, 1, 1)
        LDA.w !IP_BORDER
        %writeTile()
        %writeTile()
        %writeTile()
        %writeTile()

        %setTilePointer(!IP1_X, !IP1_Y+1, 1, 1)
        %writeTile()
        LDA.w !IP_ICON_1 : %writeTile()
        LDA.w !IP_ICON_2 : %writeTile()
        LDA.w !IP_BORDER : %writeTile()

        %setTilePointer(!IP1_X, !IP1_Y+2, 1, 1)
        %writeTile()
        LDA.w !IP_ICON_3 : %writeTile()
        LDA.w !IP_ICON_4 : %writeTile()
        LDA.w !IP_BORDER : %writeTile()

        %setTilePointer(!IP1_X, !IP1_Y+3, 1, 1)
        %writeTile()
        %writeTile()
        %writeTile()
        %writeTile()
    SEP #$30 ; 8 AXY
    RTL

RoomCallbackTable:
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $00 ; 00x
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00 ; 01x
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00 ; 02x
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00 ; 03x
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00 ; 04x
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00 ; 05x
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00 ; 06x
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00 ; 07x
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00 ; 08x
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00 ; 09x
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00 ; 0Ax
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00 ; 0Bx
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00 ; 0Cx
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00 ; 0Dx
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00 ; 0Ex
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00 ; 0Fx
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00 ; 0Fx
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00 ; 10x
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00 ; 11x
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00 ; 12x