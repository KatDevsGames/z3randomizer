Overworld_LoadNewTiles:
{
    ; add sign to EDM for OWG people to read
    LDA.b OverworldIndex : AND.w #$00FF : CMP.w #$0005 : BNE +
        LDA.w #$0101 : STA.l $7E2E18 ; #$0101 is the sign tile16 id, $7E2D98 is the position of the tile16 on map
    +

    ; GT sign
    LDA.l InvertedMode : AND.w #$00FF : BNE +
    LDA.b OverworldIndex : AND.w #$00FF : CMP.w #$0043 : BNE +
        LDA.w #$0101 : STA.l $7E2550
    +

    ; Pyramid sign
    LDA.l InvertedMode : AND.w #$00FF : BNE +
    LDA.b OverworldIndex : AND.w #$00FF : CMP.w #$005B : BNE +
        LDA.w #$0101 : STA.l $7E27B6 ; Moved sign near statue
        LDA.w #$05C2 : STA.l $7E27B4 ; added a pyramid peg on the left of the sign
    +

    SEP #$30
    LDA.l InvertedMode : BEQ .notInverted
    PHB

    ; Set the data bank to $7E.
    LDA.b #$7E : PHA : PLB
    REP #$30
    ; Use it as an index into a jump table.
    LDA.b OverworldIndex : CMP.w #$0080 : !BGE .noData
    ASL A : TAX

    JSR (Overworld_NewTilesTable, X)
    .noData
    PLB
    .notInverted
    REP #$30
    LDX.w #$001E : LDA.w #$0DBE

    RTL
}


Overworld_NewTilesTable:
{
;LW
    ;00      01      02      03      04      05      06      07
dw return, return, return, map003, return, map005, return, map007
    ;08      09      10      11      12      13      14      15
dw return, return, return, return, return, return, return, return
    ;16      17      18      19      20      21      22      23
dw map016, return, return, return, map020, return, return, return
    ;24      25      26      27      28      29      30      31
dw return, return, return, map027, return, return, return, return
    ;32      33      34      35      36      37      38      39
dw return, return, return, return, return, return, return, return
    ;40      41      42      43      44      45      46      47
dw return, map041, return, return, return, return, return, return
    ;48      49      50      51      52      53      54      55
dw map049, return, map050, map051, return, map053, return, return
    ;56      57      58      59      60      61      62      63
dw return, return, map058, return, map060, return, return, return
;DW
    ;64      65      66      67      68      69      70      71
dw return, return, return, map068, return, map078, return, map071
    ;72      73      74      75      76      77      78      79
dw return, return, return, return, return, return, return, return
    ;80      81      82      83      84      85      86      87
dw map080, return, return, return, map084, return, return, return
    ;88      89      90      91      92      93      94      95
dw return, return, return, map091, return, return, return, return
    ;96      97      98      99     100     101     102     103
dw return, return, return, return, return, return, return, return
    ;104     105    106     107     108     109     110     111
dw return, return, return, return, return, return, return, map111
    ;112     113    114     115     116     117     118     119
dw map120, return, return, map115, return, map117, return, return
    ;120     121    122     123     124     125     126     127
dw return, return, return, return, return, return, return, return

return:
RTS

map003:
{
LDA.w #$021A : STA.w $29B6
LDA.w #$01F3 : STA.w $29B8
LDA.w #$00A0 : STA.w $29BA
LDA.w #$0104 : STA.w $29BC
LDA.w #$00C6 : STA.w $2A34
STA.w $2A38
STA.w $2A3A
LDA.w #$0034 : STA.w $2BE0
RTS
}

map005:
{
LDA.w #$0111 : STA.w $206E
STA.w $20EC
LDA.w #$0113 : STA.w $2070
STA.w $2072
LDA.w #$0112 : STA.w $2074
STA.w $20EE
STA.w $216C
LDA.w #$0116 : STA.w $20F0
STA.w $216E
LDA.w #$0117 : STA.w $20F2
LDA.w #$0118 : STA.w $20F4
LDA.w #$011C : STA.w $2170
LDA.w #$011D : STA.w $2172
LDA.w #$011E : STA.w $2174
LDA.w #$0130 : STA.w $21E2
STA.w $21F0
STA.w $22E2
STA.w $22F0
LDA.w #$0123 : STA.w $21EC
LDA.w #$0124 : STA.w $21EE
LDA.w #$0034 : STA.w $21F2
LDA.w #$0126 : STA.w $21F4
LDA.w #$0135 : STA.w $2262
STA.w $2270
STA.w $2362
STA.w $2370
LDA.w #$0136 : STA.w $2264
STA.w $2266
STA.w $226C
STA.w $226E
LDA.w #$0137 : STA.w $2268
STA.w $226A
LDA.w #$013C : STA.w $22E4
STA.w $22E6
STA.w $22EC
STA.w $22EE
LDA.w #$013D : STA.w $22E8
STA.w $22EA
LDA.w #$0144 : STA.w $2364
LDA.w #$0145 : STA.w $2366
LDA.w #$0146 : STA.w $2368
LDA.w #$0147 : STA.w $236A
LDA.w #$01B3 : STA.w $236C
LDA.w #$01B4 : STA.w $236E
LDA.w #$0139 : STA.w $2970
STA.w $2C6C
LDA.w #$014B : STA.w $2972
STA.w $2C6E
LDA.w #$016B : STA.w $29F0
STA.w $2CEC
LDA.w #$0182 : STA.w $29F2
STA.w $2CEE

.map014
LDA.w #$0034 : STA.w $3D4A

RTS
}

map007:
{
LDA.w #$021B : STA.w $259E
STA.w $25A2
STA.w $25A4
STA.w $261C
STA.w $2626
STA.w $269A
STA.w $26A8
STA.w $271A
STA.w $2728
STA.w $279A
STA.w $27A8
STA.w $281E
STA.w $2820
STA.w $2822
STA.w $2824
STA.w $2828
STA.w $289C
STA.w $28A6
STA.w $291E
STA.w $2924
LDA.w #$0134 : STA.w $269E
STA.w $26A4
LDA.w #$0034 : STA.w $2826
RTS
}

map016:
{
LDA.w #$0034 : STA.w $2B2E
RTS
}

map020:
{
LDA.w #$02F1 : STA.w $2422
LDA.w #$02F2 : STA.w $2424
LDA.w #$0184 : STA.w $24A2
STA.w $2522
LDA.w #$0185 : STA.w $24A4
STA.w $2524
RTS
}

map027: ;Castle map
{

LDA.w #$0485 : STA.w $2424
STA.w $2426
LDA.w #$0454 : STA.w $24A4
STA.w $24A6
LDA.w #$0476 : STA.w $2522
LDA.w #$0460 : STA.w $2524
STA.w $2526
LDA.w #$04D7 : STA.w $2528
LDA.w #$04DD : STA.w $2624
LDA.w #$04DE : STA.w $2626
LDA.w #$04E0 : STA.w $26A4
LDA.w #$04E1 : STA.w $26A6
LDA.w #$04E4 : STA.w $2724
LDA.w #$04E5 : STA.w $2726
LDA.w #$0034 : STA.w $27A4
STA.w $27A6

;Eye removed
LDA.w #$046D : STA.w $243E
STA.w $24BC
STA.w $24BE
STA.w $253E
STA.w $2440
STA.w $24C0
STA.w $24C2
STA.w $2540

;new trees
LDA.w #$0035 : STA.w $2C28
STA.w $2FAE
LDA.w #$0034 : STA.w $2C2C
STA.w $2C2E
STA.w $2CB6
STA.w $2D36
STA.w $2DB6
STA.w $2EB6
STA.w $2F30
STA.w $2F36
STA.w $2FAA
STA.w $2FB0
STA.w $2FB4
STA.w $2FB6
LDA.w #$00E2 : STA.w $2C36
STA.w $2FA8
LDA.w #$00AE : STA.w $2CAC
LDA.w #$00AF : STA.w $2CAE
LDA.w #$007E : STA.w $2CB0
LDA.w #$007F : STA.w $2CB2
LDA.w #$04BA : STA.w $2CB4
STA.w $2DB4
STA.w $2EB4
LDA.w #$00B0 : STA.w $2D2C
LDA.w #$0014 : STA.w $2D2E
LDA.w #$0015 : STA.w $2D30
LDA.w #$00A8 : STA.w $2D32
LDA.w #$04BB : STA.w $2D34
STA.w $2E34
STA.w $2F34
LDA.w #$0089 : STA.w $2DAC
LDA.w #$001C : STA.w $2DAE
LDA.w #$001D : STA.w $2DB0
LDA.w #$0076 : STA.w $2DB2
LDA.w #$00F1 : STA.w $2E2C
LDA.w #$004E : STA.w $2E2E
LDA.w #$004F : STA.w $2E30
LDA.w #$00D9 : STA.w $2E32
LDA.w #$009A : STA.w $2EAC
LDA.w #$009B : STA.w $2EAE
LDA.w #$009C : STA.w $2EB0
LDA.w #$0095 : STA.w $2EB2

LDA.w #$0034
STA.w $3028
STA.w $302C
LDA.w #$0035 : STA.w $302A
STA.w $3032
LDA.w #$00DA : STA.w $302E
LDA.w #$00E2 : STA.w $3030



LDA.w #$0485 : STA.w $2424
STA.w $2426
LDA.w #$0454 : STA.w $24A4
STA.w $24A6
LDA.w #$0476 : STA.w $2522
LDA.w #$0460 : STA.w $2524
STA.w $2526
LDA.w #$04D7 : STA.w $2528
LDA.w #$04DD : STA.w $2624
LDA.w #$04DE : STA.w $2626
LDA.w #$04E0 : STA.w $26A4
LDA.w #$04E1 : STA.w $26A6
LDA.w #$04E4 : STA.w $2724
LDA.w #$04E5 : STA.w $2726
LDA.w #$0034 : STA.w $27A4
STA.w $27A6

LDA.w #$0486 : STA.w $26B0
LDA.w #$0487 : STA.w $26B2
LDA.w #$0454 : STA.w $272C
STA.w $272E
LDA.w #$048E : STA.w $2730
LDA.w #$048F : STA.w $2732
LDA.w #$04CA : STA.w $27AC
LDA.w #$045E : STA.w $27AE
LDA.w #$0494 : STA.w $27B0
LDA.w #$0495 : STA.w $27B2
LDA.w #$049E : STA.w $27B4
LDA.w #$0499 : STA.w $282C
LDA.w #$0451 : STA.w $2830
LDA.w #$0034 : STA.w $28AC
STA.w $28AE
STA.w $28B0
LDA.w #$0454 : STA.w $274E
STA.w $2750
LDA.w #$0608 : STA.w $2752
LDA.w #$0459 : STA.w $27CE
STA.w $27D0
LDA.w #$045E : STA.w $27D2
LDA.w #$0451 : STA.w $284E
STA.w $2850
STA.w $2852
STA.w $282E
LDA.w #$0034 : STA.w $28CE
STA.w $28D0
STA.w $28D2


; CHECK IF AGAHNIM 2 IS DEAD AND WE HAVE ALREADY LANDED
LDA.w OverworldEventDataWRAM+$5B : AND.w #$0020 : BEQ .agahnim2Alive
LDA.w #$046D : STA.w $243E
LDA.w #$0E3A : STA.w $24BC
LDA.w #$0E3B : STA.w $24BE
LDA.w #$0E3E : STA.w $253C
LDA.w #$0E3F : STA.w $253E
LDA.w #$0490 : STA.w $25BE
LDA.w #$0E39 : STA.w $2440
LDA.w #$0E3C : STA.w $24C0
LDA.w #$0E3D : STA.w $24C2
LDA.w #$0E40 : STA.w $2540
LDA.w #$0E41 : STA.w $2542
LDA.w #$0491 : STA.w $25C0
.agahnim2Alive

; add sign for Tower Entry
LDA.w #$0101 : STA.w $7E222C
LDA.w #$0101 : STA.w $7E2252

RTS
}

map041:
{
LDA.w #$0034 : STA.w $2288
STA.w $2308
STA.w $2388
STA.w $2408
STA.w $2488
STA.w $248A
LDA.w #$0036 : STA.w $2386
RTS
}

map049:
{
LDA.w #$017E : STA.w $2050
STA.w $20CE
LDA.w #$00D1 : STA.w $2052
STA.w $2054
STA.w $2056
STA.w $2058
STA.w $205A
STA.w $205C
STA.w $205E
STA.w $21E6
STA.w $21E8
STA.w $21EA
STA.w $21EC
STA.w $21EE
STA.w $21F0
LDA.w #$00D2 : STA.w $2060
STA.w $20E2
STA.w $2164
LDA.w #$0183 : STA.w $20D0
STA.w $214E
LDA.w #$00C9 : STA.w $20D2
STA.w $20D4
STA.w $20D6
STA.w $20D8
STA.w $20DA
STA.w $20DC
STA.w $20DE
STA.w $2152
STA.w $2154
STA.w $2156
STA.w $2158
STA.w $215A
STA.w $215C
STA.w $215E
STA.w $2266
STA.w $2268
STA.w $226A
STA.w $226C
STA.w $226E
STA.w $2270
STA.w $22CC
LDA.w #$00D0 : STA.w $20E0
STA.w $2162
STA.w $21E4
LDA.w #$0153 : STA.w $2150
STA.w $21CE
STA.w $21D0
STA.w $2250
STA.w $22CE
LDA.w #$00C8 : STA.w $2160
STA.w $21E2
STA.w $2264
STA.w $28DA
STA.w $295C
LDA.w #$00DC : STA.w $21D2
STA.w $21D4
STA.w $21D6
STA.w $21D8
STA.w $21DA
STA.w $21DC
STA.w $21DE
STA.w $224C
LDA.w #$00CA : STA.w $21E0
STA.w $2262
STA.w $285A
STA.w $28DC
LDA.w #$0178 : STA.w $224E
LDA.w #$00E3 : STA.w $2252
STA.w $2254
LDA.w #$0186 : STA.w $22D0
STA.w $234E
LDA.w #$0034 : STA.w $22D2
STA.w $22D4
STA.w $22D6
STA.w $2350
STA.w $2352
STA.w $2354
STA.w $2356
STA.w $23D0
STA.w $23D2
STA.w $23D4
STA.w $23D6
STA.w $2452
STA.w $2454
STA.w $2456
STA.w $2458
STA.w $24D4
STA.w $24D6
STA.w $2554
STA.w $2556
STA.w $25D4
STA.w $25D6
STA.w $2656
LDA.w #$00D3 : STA.w $22E2
LDA.w #$0302 : STA.w $22E4
LDA.w #$00CC : STA.w $22E6
STA.w $22E8
STA.w $22EA
STA.w $22EC
STA.w $22EE
STA.w $22F0
STA.w $234C
LDA.w #$00CE : STA.w $2362
STA.w $23E2
STA.w $25D8
STA.w $2658
STA.w $26D8
STA.w $2758
LDA.w #$00C5 : STA.w $2364
STA.w $23E4
STA.w $25DC
STA.w $265C
STA.w $26DC
STA.w $275C
LDA.w #$06AB : STA.w $2366
STA.w $23E6
STA.w $2466
STA.w $24E4
STA.w $24E6
STA.w $2760
LDA.w #$00AA : STA.w $2368
LDA.w #$0384 : STA.w $236A
STA.w $236E
STA.w $23EC
STA.w $246A
STA.w $24E8
STA.w $24EA
STA.w $24EC
STA.w $24EE
LDA.w #$00AB : STA.w $236C
LDA.w #$0759 : STA.w $23C8
STA.w $244A
STA.w $24CC
STA.w $254E
STA.w $26D0
STA.w $2752
STA.w $27D4
LDA.w #$0757 : STA.w $23CA
STA.w $244C
STA.w $24CE
STA.w $2550
STA.w $26D2
STA.w $2754
LDA.w #$01FF : STA.w $23CC
STA.w $244E
STA.w $24D0
STA.w $2652
STA.w $26D4
STA.w $2756
LDA.w #$017C : STA.w $23CE
STA.w $2450
STA.w $24D2
STA.w $2654
STA.w $26D6
LDA.w #$015C : STA.w $23E0
LDA.w #$0100 : STA.w $245A
STA.w $24D8
LDA.w #$01C2 : STA.w $245C
LDA.w #$0218 : STA.w $245E
LDA.w #$0162 : STA.w $2460
LDA.w #$0106 : STA.w $2462
STA.w $24E0
STA.w $255C
LDA.w #$0107 : STA.w $2464
STA.w $24E2
LDA.w #$0104 : STA.w $24DA
STA.w $2558
LDA.w #$01D4 : STA.w $24DC
LDA.w #$0219 : STA.w $24DE
LDA.w #$0179 : STA.w $2552
STA.w $25D2
LDA.w #$0105 : STA.w $255A
LDA.w #$0166 : STA.w $255E
LDA.w #$0766 : STA.w $2560
LDA.w #$06B4 : STA.w $2562
STA.w $2564
STA.w $2566
STA.w $2568
STA.w $256A
STA.w $256C
STA.w $256E
STA.w $2570
LDA.w #$06E5 : STA.w $25D0
STA.w $2650
LDA.w #$00C4 : STA.w $25DA
STA.w $265A
STA.w $26DA
STA.w $275A
LDA.w #$0171 : STA.w $25DE
LDA.w #$0165 : STA.w $25E4
STA.w $25E6
STA.w $25E8
STA.w $25EA
STA.w $25EC
STA.w $25EE
STA.w $25F0
LDA.w #$06E4 : STA.w $27D2
STA.w $2852
STA.w $2854
STA.w $2856
STA.w $28D4
STA.w $28D6
STA.w $2956
STA.w $2958
STA.w $29D8
STA.w $29DA
LDA.w #$06E1 : STA.w $27D6
LDA.w #$02FD : STA.w $27D8
STA.w $2858
LDA.w #$00CF : STA.w $27DA
LDA.w #$06E7 : STA.w $28D8
STA.w $295A
STA.w $29DC


LDA.w #$0769 : STA.w $38F8
LDA.w #$06E1 : STA.w $38FA
STA.w $38FC
STA.w $38FE
LDA.w #$06E3 : STA.w $3978
LDA.w #$02E5 : STA.w $397A
STA.w $397E
LDA.w #$02EC : STA.w $397C
LDA.w #$02F0 : STA.w $39F8
LDA.w #$02F3 : STA.w $39FA
STA.w $39FC
STA.w $39FE


.map056
LDA.w #$0034 : STA.w $3D94

RTS
}

map060:
{
LDA.w #$02E5 : STA.w $27AE
STA.w $282C
STA.w $282E
STA.w $2832
STA.w $28AC
STA.w $28AE
STA.w $2928
STA.w $292C
STA.w $29A8
STA.w $29B0
STA.w $2A28
STA.w $2A30
STA.w $2AAC
STA.w $2AB2
LDA.w #$078A : STA.w $28AA
STA.w $28B0
STA.w $2AAA
STA.w $2B2A
STA.w $2B30
STA.w $2BAE
LDA.w #$02EB : STA.w $28B4
STA.w $2930
STA.w $29AE
STA.w $2A2C
STA.w $2A32
STA.w $2AAE
LDA.w #$02EC : STA.w $2934
STA.w $2B28
STA.w $2B2C
STA.w $2B2E
STA.w $2B32
RTS
}

map050:
{
LDA.w #$01D5 : STA.w $2486
LDA.w #$0165 : STA.w $2506
LDA.w #$0166 : STA.w $2508
STA.w $258A
LDA.w #$00C6 : STA.w $2586
STA.w $2608
STA.w $2688
STA.w $2708
STA.w $2788
STA.w $2806
STA.w $2808
LDA.w #$0171 : STA.w $2588
LDA.w #$021C : STA.w $260A
STA.w $268A
STA.w $270A
STA.w $278A
LDA.w #$0034 : STA.w $270E
STA.w $278E
STA.w $2790
STA.w $280E
STA.w $2810
STA.w $2812
STA.w $2814
STA.w $2816
STA.w $2818
STA.w $281A
STA.w $281C
STA.w $288E
STA.w $2892
STA.w $2894
STA.w $2896
STA.w $2898
STA.w $289A
STA.w $289C
STA.w $289E
STA.w $290E
STA.w $2910
STA.w $2912
STA.w $2918
STA.w $291A
STA.w $291C
STA.w $291E
STA.w $2920
STA.w $298C
STA.w $298E
STA.w $2990
STA.w $2992
STA.w $2998
STA.w $299A
STA.w $299E
STA.w $29A0
STA.w $2A06
STA.w $2A08
STA.w $2A0A
STA.w $2A0C
STA.w $2A10
STA.w $2A12
STA.w $2A14
STA.w $2A16
STA.w $2A18
STA.w $2A1C
STA.w $2A1E
STA.w $2A84
STA.w $2A86
STA.w $2A88
STA.w $2A8C
STA.w $2A8E
STA.w $2A90
STA.w $2A92
STA.w $2A94
STA.w $2A96
STA.w $2A98
STA.w $2A9A
STA.w $2A9C
STA.w $2B06
STA.w $2B0A
STA.w $2B0E
STA.w $2B12
STA.w $2B1A
STA.w $2B84
STA.w $2B86
STA.w $2B88
STA.w $2B8A
STA.w $2B8E
STA.w $2B92
STA.w $2B94
STA.w $2B98
STA.w $2B9A
STA.w $2C04
STA.w $2C08
STA.w $2C0A
STA.w $2C0E
STA.w $2C12
STA.w $2C14
STA.w $2C18
STA.w $2C86
STA.w $2C88
STA.w $2C8A
STA.w $2C90
STA.w $2C92
STA.w $2C94
STA.w $2C98
STA.w $2D0A
STA.w $2D0C
STA.w $2D10
STA.w $2D14
STA.w $2D16
STA.w $2D8A
STA.w $2D8C
STA.w $2D8E
STA.w $2D94
LDA.w #$016A : STA.w $278C
STA.w $280C
STA.w $2A82
STA.w $2B02
STA.w $2B82
STA.w $2C02
STA.w $2C82
LDA.w #$01FA : STA.w $288C
LDA.w #$00DA : STA.w $2890
STA.w $299C
STA.w $2B14
STA.w $2B16
STA.w $2B18
STA.w $2B96
STA.w $2C16
STA.w $2C96
STA.w $2D08
STA.w $2D92
LDA.w #$0186 : STA.w $290C
STA.w $298A
STA.w $2A04
LDA.w #$0036 : STA.w $2914
STA.w $2916
STA.w $2994
STA.w $2996
STA.w $2D12
LDA.w #$00E4 : STA.w $2986
LDA.w #$00E5 : STA.w $2988
LDA.w #$0100 : STA.w $29A2
LDA.w #$0071 : STA.w $2A0E
STA.w $2A1A
STA.w $2C8C
LDA.w #$015C : STA.w $2A20
STA.w $2A9E
STA.w $2B1C
STA.w $2C9A
STA.w $2D18
STA.w $2D96
LDA.w #$0104 : STA.w $2A22
LDA.w #$01D4 : STA.w $2A24
LDA.w #$0035 : STA.w $2A8A
STA.w $2B08
STA.w $2C06
STA.w $2D0E
STA.w $2D90
LDA.w #$0162 : STA.w $2AA0
STA.w $2B1E
STA.w $2B9C
STA.w $2D1A
STA.w $2D98
LDA.w #$00E2 : STA.w $2B04
STA.w $2B0C
STA.w $2B10
STA.w $2B8C
STA.w $2B90
STA.w $2C0C
STA.w $2C10
STA.w $2C8E
LDA.w #$00F8 : STA.w $2C1A
LDA.w #$00CE : STA.w $2C1C
STA.w $2C9C
LDA.w #$0160 : STA.w $2C84
STA.w $2D06
STA.w $2D88
LDA.w #$0167 : STA.w $2D04
STA.w $2D86
LDA.w #$0172 : STA.w $2E08
LDA.w #$015E : STA.w $2E0A
STA.w $2E0C
STA.w $2E0E
STA.w $2E10
STA.w $2E12
STA.w $2E14
LDA.w #$0174 : STA.w $2E16

RTS
}

map051:
{
LDA.w #$0034 : STA.w $22A8
RTS
}

map053:
{
LDA.w #$02F1 : STA.w $2BB0
LDA.w #$02F2 : STA.w $2BB2
LDA.w #$0184 : STA.w $2C30
LDA.w #$0185 : STA.w $2C32
LDA.w #$0392 : STA.w $2CB0
LDA.w #$0393 : STA.w $2CB2
LDA.w #$0394 : STA.w $2D30
LDA.w #$0395 : STA.w $2D32
LDA.w #$0034 : STA.w $2F56

RTS
}

map058:
{
LDA.w #$0774 : STA.w $2800
LDA.w #$06E1 : STA.w $2802
LDA.w #$0757 : STA.w $2804
STA.w $2886
LDA.w #$0779 : STA.w $2880
LDA.w #$02EC : STA.w $2882
LDA.w #$0759 : STA.w $2884
STA.w $2906
LDA.w #$02E5 : STA.w $2900
STA.w $2902
STA.w $2904
LDA.w #$076A : STA.w $2908
LDA.w #$02F3 : STA.w $2980
STA.w $2982
LDA.w #$02F1 : STA.w $2984
LDA.w #$02F2 : STA.w $2986
LDA.w #$038A : STA.w $2988
LDA.w #$0184 : STA.w $2A04
STA.w $2A84
STA.w $2B04
STA.w $2B84
LDA.w #$0185 : STA.w $2A06
STA.w $2A86
STA.w $2B06
STA.w $2B86

RTS
}

map068:
{
LDA.w #$0E96 : STA.w $235E
STA.w $23DE
STA.w $245E
STA.w $24DE
STA.w $255E
LDA.w #$0E97 : STA.w $2360
STA.w $23E0
STA.w $2460
STA.w $24E0
STA.w $2560
LDA.w #$0E94 : STA.w $25DE
LDA.w #$0E95 : STA.w $25E0
LDA.w #$0180 : STA.w $275E
LDA.w #$0181 : STA.w $2760
LDA.w #$0184 : STA.w $27DE
STA.w $285E
LDA.w #$0185 : STA.w $27E0
STA.w $2860
LDA.w #$0212 : STA.w $2BE0

RTS
}

map071:
{
LDA.w #$0398 : STA.w $25A0
LDA.w #$0522 : STA.w $25A2
LDA.w #$0125 : STA.w $2620
LDA.w #$0126 : STA.w $2622
LDA.w #$0239 : STA.w $269E
STA.w $26A4

RTS
}

map078:
{
LDA.w #$0239 : STA.w $3D4A
RTS
}

map080:
{
LDA.w #$020F : STA.w $2B2E
RTS
}

map084:
{
LDA.w #$02F3 : STA.w $2422
STA.w $2424
LDA.w #$00C9 : STA.w $24A2
STA.w $24A4
LDA.w #$00E3 : STA.w $2522
STA.w $2524
RTS
}

map091: ;Pyramid
{
LDA.w #$0323 : STA.w $39B6
LDA.w #$0324 : STA.w $39B8
STA.w $39BA
STA.w $39BC
STA.w $39BE
LDA.w #$02FE : STA.w $3A34
LDA.w #$02FF : STA.w $3A36
LDA.w #$0326 : STA.w $3A38
STA.w $3A3A
STA.w $3A3C
STA.w $3A3E
LDA.w #$039D : STA.w $3AB2
LDA.w #$0303 : STA.w $3AB4
LDA.w #$0232 : STA.w $3AB6
STA.w $3B34
LDA.w #$0233 : STA.w $3AB8
STA.w $3ABA
STA.w $3ABC
STA.w $3ABE
LDA.w #$03A2 : STA.w $3B32
LDA.w #$0235 : STA.w $3B36
STA.w $3BB4
LDA.w #$046A : STA.w $3B38
LDA.w #$0333 : STA.w $3B3A
STA.w $3B3C
STA.w $3B3E
LDA.w #$0034 : STA.w $3BB6
STA.w $3BBA
STA.w $3BBC
STA.w $3C3A
STA.w $3C3C
STA.w $3C3E

;Added Pegs on pyramid map
;{
STA.w $321C
STA.w $329C
STA.w $32A0

LDA.w #$0071 : STA.w $321E
LDA.w #$00DA : STA.w $3220
STA.w $329A
LDA.w #$00E1 : STA.w $329E
LDA.w #$0382 : STA.w $3318
LDA.w #$037C : STA.w $3322

LDA.w #$021B : STA.w $3218
STA.w $3222
STA.w $3298
STA.w $32A2
STA.w $331A
STA.w $331C
STA.w $331E
STA.w $3320
LDA.w #$00E2 : STA.w $321A
;}

LDA.w #$00F2 : STA.w $3BB8
LDA.w #$0108 : STA.w $3C38


;Warp Tile agah defeated
LDA.w #$0034 : STA.w $3BBE ;Tile when no warp
LDA.l ProgressIndicator : AND.w #$00FF : CMP.w #$0003 : BNE .agahnimAlive
LDA.w #$0212 : STA.w $3BBE ;warp
.agahnimAlive


LDA.w #$0324 : STA.w $39C0
STA.w $39C2
STA.w $39C4
LDA.w #$0325 : STA.w $39C6
LDA.w #$02D5 : STA.w $39C8
STA.w $39D2
LDA.w #$02CC : STA.w $39CC
STA.w $39D4
LDA.w #$0326 : STA.w $3A40
STA.w $3A42
STA.w $3A44
LDA.w #$0327 : STA.w $3A46
LDA.w #$02F7 : STA.w $3A48
LDA.w #$02E3 : STA.w $3A4C
STA.w $3A4E
LDA.w #$0233 : STA.w $3AC0
STA.w $3AC2
STA.w $3AC4
LDA.w #$0234 : STA.w $3AC6
STA.w $3B48
LDA.w #$02F6 : STA.w $3AC8
LDA.w #$0396 : STA.w $3ACA
LDA.w #$0333 : STA.w $3B40
STA.w $3B42
LDA.w #$03AA : STA.w $3B44
LDA.w #$03A3 : STA.w $3B46
STA.w $3BC8
LDA.w #$0397 : STA.w $3B4A
LDA.w #$0034 : STA.w $3BC0
STA.w $3BC2
STA.w $3BC6
STA.w $3C40
STA.w $3C42
LDA.w #$029C : STA.w $3BC4
LDA.w #$010A : STA.w $3C44
LDA.w #$010B : STA.w $3C46
STA.w $3C48
STA.w $3C4A
STA.w $3C4C
STA.w $3C4E
STA.w $3C50
STA.w $3C52
STA.w $3C54
STA.w $3C56
STA.w $3C58
STA.w $3C5A
STA.w $3C5C
STA.w $3C5E
STA.w $3C60
STA.w $3C62
STA.w $3C64
STA.w $3C66

RTS
}

map111:
{
LDA.w #$020F : STA.w $2BB2
RTS
}

map115:
{
LDA.w #$020F : STA.w $22A8
RTS
}

map120:
{
LDA.w #$0239 : STA.w $3D94
RTS
}

map117:
{
;118
LDA.w #$0239 : STA.w $2F50
LDA.w #$0BA3 : STA.w $2F52
STA.w $2FCE
STA.w $2FD0

;126

LDA.w #$0BA3 : STA.w $3054
STA.w $3056
STA.w $3058
STA.w $305A
STA.w $3254
STA.w $3256
STA.w $3258
STA.w $325A
LDA.w #$0BAC : STA.w $30D4
LDA.w #$0BAD : STA.w $30D6
STA.w $3156
STA.w $31D6
LDA.w #$0BA9 : STA.w $30D8
STA.w $3158
STA.w $31D8
LDA.w #$0BAA : STA.w $30DA
LDA.w #$0BC5 : STA.w $3154
LDA.w #$0BC8 : STA.w $315A
LDA.w #$0BCA : STA.w $31D4
LDA.w #$0BCD : STA.w $31DA
RTS
}
