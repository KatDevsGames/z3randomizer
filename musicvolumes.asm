; All addresses in this file that are marked with a "." have been tested on their own and verified to be correct.
; Addresses that are commented out are correct, but either the tracks are already muted in vanilla, or they're unused by the game.
; I kept those addresses listed anyway.

;== Music volume (set everything to 0 for a no-music seed) ==

!VOLUME_00 = $00
!VOLUME_14 = $14
!VOLUME_3C = $3C
!VOLUME_50 = $50
!VOLUME_5A = $5A
!VOLUME_64 = $64
!VOLUME_78 = $78
!VOLUME_82 = $82
!VOLUME_8C = $8C
!VOLUME_A0 = $A0
!VOLUME_AA = $AA
!VOLUME_B4 = $B4
!VOLUME_C8 = $C8
!VOLUME_D2 = $D2
!VOLUME_DC = $DC
!VOLUME_E6 = $E6
!VOLUME_F0 = $F0
!VOLUME_FA = $FA
!VOLUME_FF = $FF

;== File select ==
org $1A9D28 ; <- D1D28 .
db #!VOLUME_8C ; $8C
org $1A9D41 ; <- D1D41 .
db #!VOLUME_8C ; $8C
org $1A9D5C ; <- D1D5C .
db #!VOLUME_8C ; $8C
org $1A9D77 ; <- D1D77 .
db #!VOLUME_8C ; $8C
org $1A9D92 ; <- D1D92 .
db #!VOLUME_C8 ; $C8
org $1A9DBD ; <- D1DBD .
db #!VOLUME_C8 ; $C8
org $1A9DEB ; <- D1DEB .
db #!VOLUME_C8 ; $C8
;org $1A9EEE ; <- D1EEE . (silent track)
;db #!VOLUME_8C ; $8C

;== Title Theme (Triforce jingle) ==
org $1A9F5D ; <- D1F5D .
db #!VOLUME_C8 ; $C8
org $1A9F9F ; <- D1F9F .
db #!VOLUME_C8 ; $C8
org $1A9FBD ; <- D1FBD .
db #!VOLUME_C8 ; $C8
org $1A9FDC ; <- D1FDC .
db #!VOLUME_C8 ; $C8
org $1A9FEA ; <- D1FEA .
db #!VOLUME_C8 ; $C8

;== Light World ==
org $1AA047 ; <- D2047 .
db #!VOLUME_FA ; $FA
org $1AA085 ; <- D2085 .
db #!VOLUME_FF ; $FF
org $1AA0CA ; <- D20CA .
db #!VOLUME_C8 ; $C8
org $1AA10A ; <- D210A .
db #!VOLUME_E6 ; $E6
org $1AA13F ; <- D213F .
db #!VOLUME_DC ; $DC
org $1AA174 ; <- D2174 .
db #!VOLUME_DC ; $DC
org $1AA1BB ; <- D21BB .
db #!VOLUME_C8 ; $C8
org $1AA1C5 ; <- D21C5 .
db #!VOLUME_FF ; $FF
org $1AA1CD ; <- D21CD .
db #!VOLUME_B4 ; $B4
org $1AA279 ; <- D2279 .
db #!VOLUME_B4 ; $B4
org $1AA29E ; <- D229E .
db #!VOLUME_DC ; $DC	
org $1AA2C9 ; <- D22C9 .
db #!VOLUME_C8 ; $C8
org $1AA2DC ; <- D22DC .
db #!VOLUME_E6 ; $E6
org $1AA349 ; <- D2349 .
db #!VOLUME_78 ; $78
org $1AA426 ; <- D2426 .
db #!VOLUME_DC ; $DC
org $1AA447 ; <- D2447 .
db #!VOLUME_E6 ; $E6
org $1AA49C ; <- D249C .
db #!VOLUME_A0 ; $A0
org $1AA4C2 ; <- D24C2 .
db #!VOLUME_FA ; $FA
org $1AA4CD ; <- D24CD .
db #!VOLUME_A0 ; $A0
org $1AA4EC ; <- D24EC .
db #!VOLUME_FA ; $FA
org $1AA5A4 ; <- D25A4 .
db #!VOLUME_FA ; $FA
org $1AA754 ; <- D2754 .
db #!VOLUME_C8 ; $C8

;== Escape ==
org $1AA84C ; <- D284C .
db #!VOLUME_C8 ; $C8
org $1AA866 ; <- D2866 .
db #!VOLUME_C8 ; $C8
org $1AA887 ; <- D2887 .
db #!VOLUME_C8 ; $C8
org $1AA8A0 ; <- D28A0 .
db #!VOLUME_C8 ; $C8
org $1AA8BA ; <- D28BA .
db #!VOLUME_C8 ; $C8
org $1AA8DB ; <- D28DB .
db #!VOLUME_C8 ; $C8
org $1AA8F4 ; <- D28F4 .
db #!VOLUME_C8 ; $C8
org $1AA93E ; <- D293E .
db #!VOLUME_C8 ; $C8
org $1AAB88 ; <- D2B88 .
db #!VOLUME_D2 ; $D2

;== Bunny ==
org $1AABF3 ; <- D2BF3 .
db #!VOLUME_C8 ; $C8
org $1AAC09 ; <- D2C09 .
db #!VOLUME_A0 ; $A0
org $1AAC1F ; <- D2C1F .
db #!VOLUME_C8 ; $C8
org $1AAC53 ; <- D2C53 .
db #!VOLUME_A0 ; $A0
org $1AAC69 ; <- D2C69 .
db #!VOLUME_C8 ; $C8
;org $1AACA1 ; <- D2CA1 . (silent track)
;db #!VOLUME_C8 ; $C8
org $1AACAF ; <- D2CAF .
db #!VOLUME_A0 ; $A0
org $1AACC5 ; <- D2CC5 .
db #!VOLUME_C8 ; $C8
org $1AACEB ; <- D2CEB .
db #!VOLUME_A0 ; $A0
org $1AAD05 ; <- D2D05 .
db #!VOLUME_C8 ; $C8
org $1AAD73 ; <- D2D73 .
db #!VOLUME_C8 ; $C8
org $1AAD91 ; <- D2D91 .
db #!VOLUME_A0 ; $A0
org $1AADAF ; <- D2DAF .
db #!VOLUME_C8 ; $C8

;== Lost Woods ==
org $1AAE3D ; <- D2E3D .
db #!VOLUME_C8 ; $C8
org $1AAE66 ; <- D2E66 .
db #!VOLUME_B4 ; $B4
org $1AAE70 ; <- D2E70 .
db #!VOLUME_B4 ; $B4
org $1AAEAB ; <- D2EAB .
db #!VOLUME_B4 ; $B4
org $1AAEE6 ; <- D2EE6 .
db #!VOLUME_A0 ; $A0
org $1AAF00 ; <- D2F00 .
db #!VOLUME_82 ; $82
org $1AAF36 ; <- D2F36 .
db #!VOLUME_C8 ; $C8
org $1AAF46 ; <- D2F46 .
db #!VOLUME_C8 ; $C8
org $1AAF6F ; <- D2F6F .
db #!VOLUME_C8 ; $C8
;org $1AAFCF ; <- D2FCF . (unused track)
;db #!VOLUME_C8 ; $C8
;org $1AAFDF ; <- D2FDF . (unused track)
;db #!VOLUME_C8 ; $C8
;org $1AB02B ; <- D302B . (unused track)
;db #!VOLUME_C8 ; $C8
org $1AB086 ; <- D3086 .
db #!VOLUME_C8 ; $C8
org $1AB099 ; <- D3099 .
db #!VOLUME_C8 ; $C8
org $1AB0A5 ; <- D30A5 .
db #!VOLUME_C8 ; $C8
org $1AB0CD ; <- D30CD .
db #!VOLUME_C8 ; $C8
org $1AB0F6 ; <- D30F6 .
db #!VOLUME_C8 ; $C8
org $1AB11D ; <- D311D .
db #!VOLUME_8C ; $8C
org $1AB154 ; <- D3154 .
db #!VOLUME_C8 ; $C8
org $1AB184 ; <- D3184 .
db #!VOLUME_C8 ; $C8
org $1AB1D1 ; <- D31D1 .
db #!VOLUME_8C ; $8C

;== Episode III - A Link to the Past randomizer ==
org $1AB33A ; <- D333A .
db #!VOLUME_C8 ; $C8
org $1AB3D9 ; <- D33D9 .
db #!VOLUME_C8 ; $C8
org $1AB49F ; <- D349F .
db #!VOLUME_C8 ; $C8
org $1AB54A ; <- D354A .
db #!VOLUME_C8 ; $C8
org $1AB5E5 ; <- D35E5 .
db #!VOLUME_C8 ; $C8
org $1AB624 ; <- D3624 .
db #!VOLUME_C8 ; $C8
org $1AB63C ; <- D363C .
db #!VOLUME_C8 ; $C8
org $1AB64A ; <- D364A .
db #!VOLUME_D2 ; $D2
org $1AB672 ; <- D3672 .
db #!VOLUME_C8 ; $C8
org $1AB691 ; <- D3691 .
db #!VOLUME_C8 ; $C8
org $1AB69F ; <- D369F .
db #!VOLUME_D2 ; $D2
org $1AB6B4 ; <- D36B4 .
db #!VOLUME_C8 ; $C8
org $1AB6C6 ; <- D36C6 .
db #!VOLUME_C8 ; $C8
org $1AB724 ; <- D3724 .
db #!VOLUME_C8 ; $C8
;org $1AB73B ; <- D373B . (muted track)
;db #!VOLUME_00 ; $00
org $1AB747 ; <- D3747 .
db #!VOLUME_D2 ; $D2
;org $1AB75B ; <- D375B . (muted track)
;db #!VOLUME_00 ; $00
org $1AB767 ; <- D3767 .
db #!VOLUME_C8 ; $C8

;== Kakariko ==
org $1AB8CB ; <- D38CB .
db #!VOLUME_C8 ; $C8
org $1AB8ED ; <- D38ED .
db #!VOLUME_A0 ; $A0
org $1ABB1D ; <- D3B1D .
db #!VOLUME_C8 ; $C8
org $1ABB2F ; <- D3B2F .
db #!VOLUME_C8 ; $C8
org $1ABB55 ; <- D3B55 .
db #!VOLUME_C8 ; $C8
org $1ABB70 ; <- D3B70 .
db #!VOLUME_C8 ; $C8
org $1ABB81 ; <- D3B81 .
db #!VOLUME_C8 ; $C8
org $1ABB97 ; <- D3B97 .
db #!VOLUME_B4 ; $B4
org $1ABBAC ; <- D3BAC .
db #!VOLUME_B4 ; $B4
org $1ABBBF ; <- D3BBF .
db #!VOLUME_C8 ; $C8
org $1ABBE8 ; <- D3BE8 .
db #!VOLUME_B4 ; $B4
org $1ABC0D ; <- D3C0D .
db #!VOLUME_B4 ; $B4
org $1ABC39 ; <- D3C39 .
db #!VOLUME_B4 ; $B4
org $1ABC68 ; <- D3C68 .
db #!VOLUME_B4 ; $B4
org $1ABC91 ; <- D3C91 .
db #!VOLUME_A0 ; $A0
org $1ABC9F ; <- D3C9F .
db #!VOLUME_B4 ; $B4
org $1ABCBC ; <- D3CBC .
db #!VOLUME_B4 ; $B4
org $1ABCD3 ; <- D3CD3 .
db #!VOLUME_A0 ; $A0
org $1ABCE8 ; <- D3CE8 .
db #!VOLUME_A0 ; $A0

;== Mirror Sounds ==
org $1ABD34 ; <- D3D34 .
db #!VOLUME_C8 ; $C8
org $1ABD55 ; <- D3D55 .
db #!VOLUME_C8 ; $C8
org $1ABD6E ; <- D3D6E .
db #!VOLUME_C8 ; $C8
org $1ABDAA ; <- D3DAA .
db #!VOLUME_FA ; $FA
org $1ABDC6 ; <- D3DC6 .
db #!VOLUME_C8 ; $C8
org $1ABE04 ; <- D3E04 . (this track sounds awesome on its own)
db #!VOLUME_C8 ; $C8
org $1ABE38 ; <- D3E38 .
db #!VOLUME_C8 ; $C8

;== Dark World ==
org $1ABF0C ; <- D3F0C .
db #!VOLUME_A0 ; $A0
org $1ABF45 ; <- D3F45 .
db #!VOLUME_78 ; $78
org $1ABF65 ; <- D3F65 .
db #!VOLUME_C8 ; $C8
org $1ABF82 ; <- D3F82 .
db #!VOLUME_A0 ; $A0
org $1ABFA6 ; <- D3FA6 .
db #!VOLUME_C8 ; $C8
org $1AC01E ; <- D401E .
db #!VOLUME_B4 ; $B4
org $1AC04F ; <- D404F .
db #!VOLUME_C8 ; $C8
org $1AC05F ; <- D405F .
db #!VOLUME_A0 ; $A0
org $1AC087 ; <- D4087 .
db #!VOLUME_C8 ; $C8
org $1AC139 ; <- D4139 .
db #!VOLUME_A0 ; $A0
org $1AC148 ; <- D4148 .
db #!VOLUME_8C ; $8C
org $1AC17A ; <- D417A .
db #!VOLUME_C8 ; $C8
org $1AC198 ; <- D4198 .
db #!VOLUME_A0 ; $A0
org $1AC1A0 ; <- D41A0 .
db #!VOLUME_C8 ; $C8
org $1AC1D5 ; <- D41D5 .
db #!VOLUME_A0 ; $A0
org $1AC1F6 ; <- D41F6 .
db #!VOLUME_A0 ; $A0
org $1AC22B ; <- D422B .
db #!VOLUME_A0 ; $A0
org $1AC25C ; <- D425C .
db #!VOLUME_C8 ; $C8
org $1AC270 ; <- D4270 .
db #!VOLUME_A0 ; $A0
org $1AC290 ; <- D4290 .
db #!VOLUME_B4 ; $B4
org $1AC2B1 ; <- D42B1 .
db #!VOLUME_A0 ; $A0
org $1AC2EB ; <- D42EB .
db #!VOLUME_78 ; $78
org $1AC306 ; <- D4306 (Volume fade) .
db #!VOLUME_5A ; $5A
org $1AC319 ; <- D4319 .
db #!VOLUME_C8 ; $C8
org $1AC334 ; <- D4334 .
db #!VOLUME_A0 ; $A0
org $1AC33C ; <- D433C .
db #!VOLUME_C8 ; $C8
org $1AC371 ; <- D4371 .
db #!VOLUME_A0 ; $A0
org $1AC3A6 ; <- D43A6 .
db #!VOLUME_A0 ; $A0
org $1AC3DB ; <- D43DB .
db #!VOLUME_A0 ; $A0
org $1AC3EF ; <- D43EF .
db #!VOLUME_C8 ; $C8
org $1AC40C ; <- D440C .
db #!VOLUME_C8 ; $C8
org $1AC41E ; <- D441E .
db #!VOLUME_A0 ; $A0
org $1AC43E ; <- D443E .
db #!VOLUME_B4 ; $B4
org $1AC452 ; <- D4452 .
db #!VOLUME_C8 ; $C8
org $1AC494 ; <- D4494 .
db #!VOLUME_C8 ; $C8
org $1AC4B5 ; <- D44B5 .
db #!VOLUME_C8 ; $C8
org $1AC512 ; <- D4512 .
db #!VOLUME_C8 ; $C8
org $1AC56F ; <- D456F .
db #!VOLUME_B4 ; $B4
org $1AC597 ; <- D4597 .
db #!VOLUME_A0 ; $A0
org $1AC5D1 ; <- D45D1 .
db #!VOLUME_C8 ; $C8
org $1AC5EF ; <- D45EF .
db #!VOLUME_C8 ; $C8
org $1AC682 ; <- D4682 .
db #!VOLUME_C8 ; $C8
org $1AC6C3 ; <- D46C3 .
db #!VOLUME_C8 ; $C8

;== Getting Master Sword ==
org $1AC731 ; <- D4731 .
db #!VOLUME_DC ; $DC
org $1AC753 ; <- D4753 .
db #!VOLUME_DC ; $DC
org $1AC774 ; <- D4774 .
db #!VOLUME_DC ; $DC
org $1AC795 ; <- D4795 .
db #!VOLUME_DC ; $DC
org $1AC7B6 ; <- D47B6 .
db #!VOLUME_DC ; $DC
org $1AC7D3 ; <- D47D3 .
db #!VOLUME_B4 ; $B4

;== Hostile Kakariko Guards ==
org $1AC83C ; <- D483C .
db #!VOLUME_C8 ; $C8
org $1AC848 ; <- D4848 .
db #!VOLUME_C8 ; $C8
org $1AC855 ; <- D4855 .
db #!VOLUME_C8 ; $C8
org $1AC862 ; <- D4862 .
db #!VOLUME_C8 ; $C8
org $1AC86F ; <- D486F .
db #!VOLUME_C8 ; $C8
org $1AC87C ; <- D487C .
db #!VOLUME_C8 ; $C8
org $1AC8B9 ; <- D48B9 .
db #!VOLUME_78 ; $78
org $1AC8FF ; <- D48FF .
db #!VOLUME_78 ; $78

;== Title theme (after triforce jingle) ==
org $1ACA1C ; <- D4A1C .
db #!VOLUME_C8 ; $C8
org $1ACA3B ; <- D4A3B .
db #!VOLUME_C8 ; $C8
org $1ACA60 ; <- D4A60 .
db #!VOLUME_C8 ; $C8
org $1ACAA5 ; <- D4AA5 .
db #!VOLUME_DC ; $DC
org $1ACAE4 ; <- D4AE4 .
db #!VOLUME_DC ; $DC
org $1ACB27 ; <- D4B27 .
db #!VOLUME_C8 ; $C8
org $1ACB3C ; <- D4B3C .
db #!VOLUME_A0 ; $A0
org $1ACB96 ; <- D4B96 .
db #!VOLUME_DC ; $DC
org $1ACBAB ; <- D4BAB .
db #!VOLUME_A0 ; $A0
org $1ACC03 ; <- D4C03 .
db #!VOLUME_A0 ; $A0
org $1ACC53 ; <- D4C53 .
db #!VOLUME_A0 ; $A0
org $1ACC7A ; <- D4C7A .
db #!VOLUME_C8 ; $C8
org $1ACC7F ; <- D4C7F .
db #!VOLUME_A0 ; $A0
org $1ACCA5 ; <- D4CA5 .
db #!VOLUME_DC ; $DC

;== Skull Woods ==
org $1ACD12 ; <- D4D12 .
db #!VOLUME_C8 ; $C8
org $1ACD43 ; <- D4D43 .
db #!VOLUME_B4 ; $B4
org $1ACD81 ; <- D4D81 .
db #!VOLUME_C8 ; $C8
org $1ACD9C ; <- D4D9C .
db #!VOLUME_A0 ; $A0
org $1ACDCC ; <- D4DCC .
db #!VOLUME_B4 ; $B4
org $1ACE90 ; <- D4E90 .
db #!VOLUME_C8 ; $C8
org $1ACEBA ; <- D4EBA .
db #!VOLUME_B4 ; $B4
org $1ACED6 ; <- D4ED6 .
db #!VOLUME_C8 ; $C8
org $1ACEE2 ; <- D4EE2 .
db #!VOLUME_C8 ; $C8
org $1ACF0B ; <- D4F0B .
db #!VOLUME_B4 ; $B4
org $1ACFE5 ; <- D4FE5 .
db #!VOLUME_B4 ; $B4
org $1AD005 ; <- D5005 .
db #!VOLUME_C8 ; $C8
org $1AD012 ; <- D5012 .
db #!VOLUME_B4 ; $B4
org $1AD02E ; <- D502E .
db #!VOLUME_C8 ; $C8
org $1AD03C ; <- D503C .
db #!VOLUME_C8 ; $C8
org $1AD081 ; <- D5081 .
db #!VOLUME_C8 ; $C8

;== Minigame ==
org $1AD1A8 ; <- D51A8 .
db #!VOLUME_FA ; $FA
org $1AD1B1 ; <- D51B1 .
db #!VOLUME_C8 ; $C8
org $1AD1C7 ; <- D51C7 .
db #!VOLUME_C8 ; $C8
org $1AD1CF ; <- D51CF .
db #!VOLUME_C8 ; $C8
org $1AD1E6 ; <- D51E6 .
db #!VOLUME_FA ; $FA
org $1AD1EF ; <- D51EF .
db #!VOLUME_C8 ; $C8
org $1AD20C ; <- D520C .
db #!VOLUME_C8 ; $C8
org $1AD214 ; <- D5214 .
db #!VOLUME_C8 ; $C8
org $1AD231 ; <- D5231 .
db #!VOLUME_C8 ; $C8
org $1AD24E ; <- D524E .
db #!VOLUME_FA ; $FA
org $1AD257 ; <- D5257 .
db #!VOLUME_C8 ; $C8
org $1AD26D ; <- D526D .
db #!VOLUME_C8 ; $C8
org $1AD275 ; <- D5275 .
db #!VOLUME_C8 ; $C8
org $1AD29E ; <- D529E .
db #!VOLUME_FA ; $FA
org $1AD2AF ; <- D52AF .
db #!VOLUME_C8 ; $C8
org $1AD2BD ; <- D52BD .
db #!VOLUME_C8 ; $C8
org $1AD2CD ; <- D52CD .
db #!VOLUME_C8 ; $C8
org $1AD2DB ; <- D52DB .
db #!VOLUME_C8 ; $C8

;== Triforce Chamber ==
org $1AD424 ; <- D5424 .
db #!VOLUME_A0 ; $A0
org $1AD43F ; <- D543F .
db #!VOLUME_78 ; $78
org $1AD477 ; <- D5477 .
db #!VOLUME_DC ; $DC
org $1AD49C ; <- D549C .
db #!VOLUME_C8 ; $C8
org $1AD4BC ; <- D54BC .
db #!VOLUME_B4 ; $B4
org $1AD4D5 ; <- D54D5 .
db #!VOLUME_B4 ; $B4
org $1AD4F0 ; <- D54F0 .
db #!VOLUME_B4 ; $B4
org $1AD509 ; <- D5509 .
db #!VOLUME_B4 ; $B4
org $1AD543 ; <- D5543 .
db #!VOLUME_8C ; $8C

;== Credits fuck it i'm not testing this, they look right though. ===
org $1AD7D8 ; <- D57D8 .
db #!VOLUME_B4 ; $B4
org $1AD801 ; <- D5801 .
db #!VOLUME_C8 ; $C8
org $1AD817 ; <- D5817 .
db #!VOLUME_78 ; $78
org $1AD8A4 ; <- D58A4
db #!VOLUME_C8 ; $C8
org $1AD954 ; <- D5954
db #!VOLUME_3C ; $3C
org $1AD957 ; <- D5957 (Volume fade)
db #!VOLUME_78 ; $78
org $1AD9B9 ; <- D59B9
db #!VOLUME_B4 ; $B4
org $1ADA2F ; <- D5A2F (maybe a silent track?)
db #!VOLUME_B4 ; $B4
org $1ADA3D ; <- D5A3D
db #!VOLUME_DC ; $DC
org $1ADA4D ; <- D5A4D
db #!VOLUME_E6 ; $E6
org $1ADA68 ; <- D5A68
db #!VOLUME_C8 ; $C8
org $1ADA7F ; <- D5A7F
db #!VOLUME_C8 ; $C8
org $1ADACB ; <- D5ACB
db #!VOLUME_78 ; $78
org $1ADAE8 ; <- D5AE8
db #!VOLUME_78 ; $78
org $1ADAEB ; <- D5AEB (Volume fade)
db #!VOLUME_B4 ; $B4
org $1ADB47 ; <- D5B47
db #!VOLUME_50 ; $50
org $1ADB4A ; <- D5B4A (Volume fade)
db #!VOLUME_78 ; $78
org $1ADB5E ; <- D5B5E
db #!VOLUME_50 ; $50
org $1ADB6F ; <- D5B6F (Volume fade)
db #!VOLUME_8C ; $8C
org $1ADC12 ; <- D5C12
db #!VOLUME_C8 ; $C8
org $1ADD71 ; <- D5D71
db #!VOLUME_C8 ; $C8
org $1ADDDC ; <- D5DDC
db #!VOLUME_E6 ; $E6
org $1ADE10 ; <- D5E10
db #!VOLUME_C8 ; $C8
org $1ADE5E ; <- D5E5E
db #!VOLUME_B4 ; $B4
org $1ADE9A ; <- D5E9A
db #!VOLUME_C8 ; $C8
org $1ADF28 ; <- D5F28
db #!VOLUME_FF ; $FF
org $1ADF8B ; <- D5F8B
db #!VOLUME_C8 ; $C8
org $1ADFA4 ; <- D5FA4
db #!VOLUME_C8 ; $C8
org $1ADFE9 ; <- D5FE9
db #!VOLUME_B4 ; $B4
org $1AE045 ; <- D6045 .
db #!VOLUME_FA ; $FA

;== Pre-credits ==
org $1AE51A ; <- D651A .
db #!VOLUME_C8 ; $C8
org $1AE53B ; <- D653B (Volume Fade) .
db #!VOLUME_3C ; $3C
org $1AE542 ; <- D6542 .
db #!VOLUME_C8 ; $C8
org $1AE566 ; <- D6566 .
db #!VOLUME_DC ; $DC
org $1AE58F ; <- D658F .
db #!VOLUME_B4 ; $B4
org $1AE5B3 ; <- D65B3 .
db #!VOLUME_8C ; $8C
org $1AE5D2 ; <- D65D2 .
db #!VOLUME_A0 ; $A0
org $1AE5ED ; <- D65ED .
db #!VOLUME_C8 ; $C8
org $1AE61D ; <- D661D .
db #!VOLUME_C8 ; $C8
org $1AE64F ; <- D664F .
db #!VOLUME_A0 ; $A0
org $1AE698 ; <- D6698 .
db #!VOLUME_A0 ; $A0
org $1AE6D7 ; <- D66D7 .
db #!VOLUME_C8 ; $C8
org $1AE6FF ; <- D66FF .
db #!VOLUME_A0 ; $A0
org $1AE72C ; <- D672C .
db #!VOLUME_DC ; $DC
org $1AE74A ; <- D674A .
db #!VOLUME_B4 ; $B4
org $1AE760 ; <- D6760 .
db #!VOLUME_8C ; $8C
org $1AE776 ; <- D6776 .
db #!VOLUME_C8 ; $C8
org $1AE7C0 ; <- D67C0 .
db #!VOLUME_DC ; $DC
org $1AE827 ; <- D6827 .
db #!VOLUME_B4 ; $B4
org $1AE878 ; <- D6878 .
db #!VOLUME_64 ; $64
org $1AE883 ; <- D6883 .
db #!VOLUME_64 ; $64
org $1AE8BD ; <- D68BD .
db #!VOLUME_C8 ; $C8

;== Holding the Triforce (part 1, more below) ==
org $1AE8E5 ; <- D68E5 .
db #!VOLUME_C8 ; $C8

;== More pre-credits stuff ==
org $1AE956 ; <- D6956 .
db #!VOLUME_C8 ; $C8
org $1AE973 ; <- D6973 .
db #!VOLUME_C8 ; $C8
org $1AE985 ; <- D6985 .
db #!VOLUME_A0 ; $A0
org $1AE9A8 ; <- D69A8 .
db #!VOLUME_C8 ; $C8
org $1AE9B8 ; <- D69B8 .
db #!VOLUME_DC ; $DC
org $1AE9D6 ; <- D69D6 .
db #!VOLUME_B4 ; $B4
org $1AE9F5 ; <- D69F5 .
db #!VOLUME_B4 ; $B4
org $1AEA05 ; <- D6A05 .
db #!VOLUME_B4 ; $B4
org $1AEA51 ; <- D6A51 .
db #!VOLUME_C8 ; $C8
org $1AEA86 ; <- D6A86 .
db #!VOLUME_C8 ; $C8
org $1AEAB1 ; <- D6AB1 .
db #!VOLUME_DC ; $DC
org $1AEAE9 ; <- D6AE9 .
db #!VOLUME_B4 ; $B4
org $1AEB6B ; <- D6B6B .
db #!VOLUME_8C ; $8C
org $1AEB96 ; <- D6B96 .
db #!VOLUME_C8 ; $C8
org $1AEC05 ; <- D6C05 .
db #!VOLUME_DC ; $DC
org $1AEC3E ; <- D6C3E .
db #!VOLUME_C8 ; $C8
org $1AEC5C ; <- D6C5C .
db #!VOLUME_A0 ; $A0
org $1AEC6F ; <- D6C6F .
db #!VOLUME_A0 ; $A0
org $1AEC8E ; <- D6C8E .
db #!VOLUME_A0 ; $A0
org $1AECB4 ; <- D6CB4 .
db #!VOLUME_A0 ; $A0
org $1AED4A ; <- D6D4A .
db #!VOLUME_C8 ; $C8
org $1AED7D ; <- D6D7D .
db #!VOLUME_A0 ; $A0
org $1AEDB3 ; <- D6DB3 .
db #!VOLUME_DC ; $DC
org $1AEDCF ; <- D6DCF .
db #!VOLUME_B4 ; $B4
org $1AEDF6 ; <- D6DF6 .
db #!VOLUME_8C ; $8C
org $1AEE0D ; <- D6E0D .
db #!VOLUME_8C ; $8C
org $1AEE20 ; <- D6E20 .
db #!VOLUME_B4 ; $B4
org $1AEE48 ; <- D6E48 .
db #!VOLUME_64 ; $64
org $1AEE76 ; <- D6E76 .
db #!VOLUME_64 ; $64
org $1AEE9C ; <- D6E9C .
db #!VOLUME_C8 ; $C8
org $1AEECB ; <- D6ECB .
db #!VOLUME_B4 ; $B4
org $1AEEFB ; <- D6EFB .
db #!VOLUME_64 ; $64
org $1AEF2D ; <- D6F2D .
db #!VOLUME_64 ; $64
org $1AEF80 ; <- D6F80 (i think this is unused, but i don't feel like confirming this one)
db #!VOLUME_C8 ; $C8
org $1AF17E ; <- D717E .
db #!VOLUME_C8 ; $C8

;== Holding the Triforce (part 2) ==
org $1AF190 ; <- D7190 .
db #!VOLUME_C8 ; $C8
org $1AF1AB ; <- D71AB .
db #!VOLUME_DC ; $DC
org $1AF1B9 ; <- D71B9 .
db #!VOLUME_C8 ; $C8
org $1AF1D4 ; <- D71D4 .
db #!VOLUME_B4 ; $B4
org $1AF1E6 ; <- D71E6 .
db #!VOLUME_B4 ; $B4
org $1AF203 ; <- D7203 .
db #!VOLUME_B4 ; $B4
org $1AF21E ; <- D721E .
db #!VOLUME_B4 ; $B4

;== More Credits ==
org $1AF3A1 ; <- D73A1 .
db #!VOLUME_8C ; $8C

;== Hyrule Castle ==
org $1B811D ; <- D811D .
db #!VOLUME_C8 ; $C8
;org $1B8139 ; <- D8139 . (silent track)
;db #!VOLUME_C8 ; $C8
;org $1B814C ; <- D814C . (silent track)
;db #!VOLUME_8C ; $8C
org $1B816B ; <- D816B .
db #!VOLUME_C8 ; $C8
org $1B818A ; <- D818A .
db #!VOLUME_C8 ; $C8
org $1B819E ; <- D819E .
db #!VOLUME_C8 ; $C8
org $1B81BE ; <- D81BE .
db #!VOLUME_C8 ; $C8
org $1B81DE ; <- D81DE .
db #!VOLUME_FA ; $FA
org $1B821E ; <- D821E .
db #!VOLUME_FA ; $FA
org $1B825D ; <- D825D .
db #!VOLUME_8C ; $8C
org $1B827D ; <- D827D .
db #!VOLUME_A0 ; $A0
org $1B829C ; <- D829C .
db #!VOLUME_C8 ; $C8
org $1B82BE ; <- D82BE .
db #!VOLUME_8C ; $8C
org $1B82E1 ; <- D82E1 .
db #!VOLUME_C8 ; $C8
org $1B8306 ; <- D8306 .
db #!VOLUME_C8 ; $C8
org $1B830E ; <- D830E .
db #!VOLUME_C8 ; $C8
org $1B8340 ; <- D8340 .
db #!VOLUME_8C ; $8C
org $1B835E ; <- D835E .
db #!VOLUME_C8 ; $C8
org $1B8394 ; <- D8394 .
db #!VOLUME_8C ; $8C
org $1B83AB ; <- D83AB .
db #!VOLUME_C8 ; $C8
org $1B83CA ; <- D83CA .
db #!VOLUME_C8 ; $C8
org $1B83F0 ; <- D83F0 .
db #!VOLUME_C8 ; $C8
org $1B83F8 ; <- D83F8 .
db #!VOLUME_C8 ; $C8
org $1B842C ; <- D842C .
db #!VOLUME_8C ; $8C
org $1B844B ; <- D844B .
db #!VOLUME_C8 ; $C8
org $1B8479 ; <- D8479 .
db #!VOLUME_C8 ; $C8
org $1B849E ; <- D849E .
db #!VOLUME_C8 ; $C8
org $1B84CB ; <- D84CB .
db #!VOLUME_C8 ; $C8
org $1B84EB ; <- D84EB .
db #!VOLUME_C8 ; $C8
org $1B84F3 ; <- D84F3 .
db #!VOLUME_C8 ; $C8
org $1B854A ; <- D854A .
db #!VOLUME_C8 ; $C8
org $1B8573 ; <- D8573 .
db #!VOLUME_C8 ; $C8
org $1B859D ; <- D859D .
db #!VOLUME_C8 ; $C8
org $1B85B4 ; <- D85B4 .
db #!VOLUME_C8 ; $C8
org $1B85CE ; <- D85CE .
db #!VOLUME_C8 ; $C8
org $1B862A ; <- D862A .
db #!VOLUME_C8 ; $C8
org $1B8681 ; <- D8681 .
db #!VOLUME_C8 ; $C8
org $1B8724 ; <- D8724 .
db #!VOLUME_B4 ; $B4
org $1B8732 ; <- D8732 .
db #!VOLUME_B4 ; $B4
org $1B8796 ; <- D8796 .
db #!VOLUME_8C ; $8C
org $1B87E3 ; <- D87E3 .
db #!VOLUME_C8 ; $C8
org $1B87FF ; <- D87FF .
db #!VOLUME_C8 ; $C8
org $1B887B ; <- D887B .
db #!VOLUME_C8 ; $C8
org $1B88C6 ; <- D88C6 .
db #!VOLUME_C8 ; $C8
org $1B88E3 ; <- D88E3 .
db #!VOLUME_C8 ; $C8
;org $1B8903 ; <- D8903 . (silent track)
;db #!VOLUME_8C ; $8C
org $1B892A ; <- D892A .
db #!VOLUME_8C ; $8C
org $1B8944 ; <- D8944 .
db #!VOLUME_C8 ; $C8
org $1B897B ; <- D897B .
db #!VOLUME_C8 ; $C8

;== Pendant Dungeon ==
org $1B8C97 ; <- D8C97 .
db #!VOLUME_C8 ; $C8
org $1B8CA4 ; <- D8CA4 .
db #!VOLUME_C8 ; $C8
org $1B8CB3 ; <- D8CB3 .
db #!VOLUME_C8 ; $C8
org $1B8CC2 ; <- D8CC2 .
db #!VOLUME_C8 ; $C8
org $1B8CD1 ; <- D8CD1 .
db #!VOLUME_C8 ; $C8
org $1B8D01 ; <- D8D01 .
db #!VOLUME_C8 ; $C8
org $1B8E2D ; <- D8E2D .
db #!VOLUME_DC ; $DC
org $1B8F0D ; <- D8F0D .
db #!VOLUME_DC ; $DC
;org $1B90F8 ; <- D90F8 (muted track)
;db #!VOLUME_00 ; $00

;== Caves ==
org $1B917B ; <- D917B .
db #!VOLUME_C8 ; $C8
org $1B918C ; <- D918C .
db #!VOLUME_C8 ; $C8
org $1B919A ; <- D919A .
db #!VOLUME_C8 ; $C8
org $1B91B5 ; <- D91B5 .
db #!VOLUME_C8 ; $C8
org $1B91D0 ; <- D91D0 .
db #!VOLUME_C8 ; $C8
org $1B91DD ; <- D91DD . (splashy sound)
db #!VOLUME_C8 ; $C8
org $1B91E8 ; <- D91E8 .
db #!VOLUME_8C ; $8C
org $1B9220 ; <- D9220 . (splashy sound)
db #!VOLUME_C8 ; $C8
org $1B922B ; <- D922B .
db #!VOLUME_8C ; $8C
org $1B9273 ; <- D9273 .
db #!VOLUME_C8 ; $C8
org $1B9284 ; <- D9284 .
db #!VOLUME_C8 ; $C8
org $1B9292 ; <- D9292 .
db #!VOLUME_C8 ; $C8
org $1B92AD ; <- D92AD .
db #!VOLUME_C8 ; $C8
org $1B92C8 ; <- D92C8 .
db #!VOLUME_C8 ; $C8
org $1B92D5 ; <- D92D5 . (splashy sound)
db #!VOLUME_C8 ; $C8
org $1B92E0 ; <- D92E0 .
db #!VOLUME_8C ; $8C
org $1B9311 ; <- D9311 .
db #!VOLUME_C8 ; $C8
org $1B9322 ; <- D9322 .
db #!VOLUME_C8 ; $C8
org $1B9330 ; <- D9330 .
db #!VOLUME_C8 ; $C8
org $1B934B ; <- D934B .
db #!VOLUME_C8 ; $C8
org $1B9366 ; <- D9366 .
db #!VOLUME_C8 ; $C8
org $1B9373 ; <- D9373 . (splashy sound)
db #!VOLUME_C8 ; $C8
org $1B937E ; <- D937E .
db #!VOLUME_8C ; $8C
org $1B93B6 ; <- D93B6 . (splashy sound)
db #!VOLUME_C8 ; $C8
org $1B93C1 ; <- D93C1 .
db #!VOLUME_8C ; $8C

;== Crystal/Pendant get ==
org $1B945E ; <- D945E .
db #!VOLUME_F0 ; $F0
org $1B94AA ; <- D94AA .
db #!VOLUME_FA ; $FA
org $1B94E0 ; <- D94E0 .
db #!VOLUME_DC ; $DC
org $1B9544 ; <- D9544 .
db #!VOLUME_DC ; $DC
org $1B95A8 ; <- D95A8 .
db #!VOLUME_DC ; $DC
org $1B960C ; <- D960C .
db #!VOLUME_A0 ; $A0
org $1B9652 ; <- D9652 .
db #!VOLUME_B4 ; $B4
org $1B967D ; <- D967D .
db #!VOLUME_F0 ; $F0
org $1B9698 ; <- D9698 .
db #!VOLUME_B4 ; $B4
org $1B96C2 ; <- D96C2 .
db #!VOLUME_F0 ; $F0

;== Sanctuary ==
org $1B97A6 ; <- D97A6 .
db #!VOLUME_C8 ; $C8
org $1B97C2 ; <- D97C2 .
db #!VOLUME_C8 ; $C8
org $1B97DC ; <- D97DC .
db #!VOLUME_C8 ; $C8
org $1B97FB ; <- D97FB .
db #!VOLUME_C8 ; $C8
org $1B9811 ; <- D9811 .
db #!VOLUME_C8 ; $C8
org $1B9828 ; <- D9828 .
db #!VOLUME_A0 ; $A0

;== Boss ==
;org $1B98FF ; <- D98FF . (silent track)
;db #!VOLUME_C8 ; $C8
org $1B996F ; <- D996F .
db #!VOLUME_C8 ; $C8
org $1B9982 ; <- D9982 .
db #!VOLUME_DC ; $DC
org $1B99A8 ; <- D99A8 .
db #!VOLUME_C8 ; $C8
org $1B99D5 ; <- D99D5 .
db #!VOLUME_C8 ; $C8
org $1B9A02 ; <- D9A02 .
db #!VOLUME_AA ; $AA
org $1B9A30 ; <- D9A30 .
db #!VOLUME_C8 ; $C8
org $1B9A4E ; <- D9A4E .
db #!VOLUME_C8 ; $C8
org $1B9A6B ; <- D9A6B .
db #!VOLUME_C8 ; $C8
org $1B9A88 ; <- D9A88 .
db #!VOLUME_C8 ; $C8
org $1B9A9E ; <- D9A9E .
db #!VOLUME_FA ; $FA
;org $1B9AE4 ; <- D9AE4 . (unused track) these three tracks go together
;db #!VOLUME_FA ; $FA
;org $1B9AF7 ; <- D9AF7 . (unused track)
;db #!VOLUME_C8 ; $C8
;org $1B9B1D ; <- D9B1D . (unused track)
;db #!VOLUME_C8 ; $C8
org $1B9B43 ; <- D9B43 .
db #!VOLUME_C8 ; $C8
org $1B9B56 ; <- D9B56 .
db #!VOLUME_DC ; $DC
org $1B9B7C ; <- D9B7C .
db #!VOLUME_C8 ; $C8
org $1B9BA9 ; <- D9BA9 .
db #!VOLUME_C8 ; $C8
org $1B9BD6 ; <- D9BD6 .
db #!VOLUME_AA ; $AA

;== Crystal Dungeon ==
org $1B9C84 ; <- D9C84 .
db #!VOLUME_C8 ; $C8
org $1B9C8D ; <- D9C8D .
db #!VOLUME_C8 ; $C8
org $1B9C95 ; <- D9C95 .
db #!VOLUME_F0 ; $F0
org $1B9CAC ; <- D9CAC .
db #!VOLUME_C8 ; $C8
org $1B9CBC ; <- D9CBC .
db #!VOLUME_B4 ; $B4
org $1B9CE8 ; <- D9CE8 .
db #!VOLUME_C8 ; $C8
org $1B9CF3 ; <- D9CF3 .
db #!VOLUME_C8 ; $C8
org $1B9CFD ; <- D9CFD .
db #!VOLUME_C8 ; $C8
org $1B9D46 ; <- D9D46 .
db #!VOLUME_C8 ; $C8
org $1B9DC0 ; <- D9DC0 .
db #!VOLUME_B4 ; $B4
org $1B9E49 ; <- D9E49 .
db #!VOLUME_B4 ; $B4
org $1B9EE6 ; <- D9EE6 .
db #!VOLUME_F0 ; $F0

;== Fortuneteller ==
org $1BA211 ; <- DA211 .
db #!VOLUME_64 ; $64
org $1BA233 ; <- DA233 .
db #!VOLUME_A0 ; $A0
org $1BA251 ; <- DA251 .
db #!VOLUME_E6 ; $E6
org $1BA26C ; <- DA26C .
db #!VOLUME_E6 ; $E6
org $1BA289 ; <- DA289 .
db #!VOLUME_FA ; $FA

;== Zelda's Lullaby ==
org $1BA35B ; <- DA35B .
db #!VOLUME_64 ; $64
org $1BA35E ; <- DA35E (Volume fade) .
db #!VOLUME_C8 ; $C8
org $1BA37B ; <- DA37B .
db #!VOLUME_64 ; $64
org $1BA37E ; <- DA37E (Volume fade) .
db #!VOLUME_C8 ; $C8
org $1BA38E ; <- DA38E .
db #!VOLUME_64 ; $64
org $1BA391 ; <- DA391 (Volume fade) .
db #!VOLUME_C8 ; $C8
org $1BA39F ; <- DA39F .
db #!VOLUME_64 ; $64
org $1BA3A2 ; <- DA3A2 (Volume fade) .
db #!VOLUME_A0 ; $A0
org $1BA3D5 ; <- DA3D5 .
db #!VOLUME_82 ; $82
org $1BA478 ; <- DA478 .
db #!VOLUME_C8 ; $C8
org $1BA49E ; <- DA49E .
db #!VOLUME_A0 ; $A0
org $1BA4C3 ; <- DA4C3 .
db #!VOLUME_C8 ; $C8
org $1BA4D7 ; <- DA4D7 .
db #!VOLUME_C8 ; $C8
org $1BA4F6 ; <- DA4F6 .
db #!VOLUME_C8 ; $C8
org $1BA515 ; <- DA515 .
db #!VOLUME_C8 ; $C8

;== Maidens ==
org $1BA5C3 ; <- DA5C3 .
db #!VOLUME_64 ; $64
org $1BA5C6 ; <- DA5C6 (Volume fade) .
db #!VOLUME_F0 ; $F0
org $1BA5DE ; <- DA5DE .
db #!VOLUME_78 ; $78
org $1BA608 ; <- DA608 .
db #!VOLUME_78 ; $78
org $1BA635 ; <- DA635 .
db #!VOLUME_78 ; $78
org $1BA662 ; <- DA662 .
db #!VOLUME_78 ; $78
org $1BA691 ; <- DA691 .
db #!VOLUME_64 ; $64
org $1BA694 ; <- DA694 (Volume fade) .
db #!VOLUME_DC ; $DC
org $1BA6A8 ; <- DA6A8 .
db #!VOLUME_64 ; $64
org $1BA6AB ; <- DA6AB (Volume fade) .
db #!VOLUME_DC ; $DC
org $1BA6DF ; <- DA6DF .
db #!VOLUME_64 ; $64
org $1BA6E2 ; <- DA6E2 (Volume fade) .
db #!VOLUME_C8 ; $C8
org $1BA710 ; <- DA710 .
db #!VOLUME_14 ; $14
org $1BA71F ; <- DA71F (Volume fade) .
db #!VOLUME_78 ; $78
org $1BA72B ; <- DA72B .
db #!VOLUME_A0 ; $A0
org $1BA736 ; <- DA736 (Volume fade) .
db #!VOLUME_3C ; $3C
org $1BA745 ; <- DA745 .
db #!VOLUME_A0 ; $A0
org $1BA752 ; <- DA752 (Volume fade) .
db #!VOLUME_3C ; $3C
org $1BA765 ; <- DA765 .
db #!VOLUME_A0 ; $A0
org $1BA772 ; <- DA772 (Volume fade) .
db #!VOLUME_3C ; $3C
org $1BA785 ; <- DA785 .
db #!VOLUME_A0 ; $A0
org $1BA792 ; <- DA792 (Volume fade) .
db #!VOLUME_3C ; $3C
org $1BA7A4 ; <- DA7A4 .
db #!VOLUME_14 ; $14
org $1BA7AF ; <- DA7AF (Volume fade) .
db #!VOLUME_78 ; $78
org $1BA7BB ; <- DA7BB .
db #!VOLUME_14 ; $14
org $1BA7C6 ; <- DA7C6 (Volume fade) .
db #!VOLUME_78 ; $78
org $1BA7D2 ; <- DA7D2 .
db #!VOLUME_14 ; $14
org $1BA7DD ; <- DA7DD (Volume fade) .
db #!VOLUME_78 ; $78

;== Fairy Fountain ==
org $1BA958 ; <- DA958 .
db #!VOLUME_8C ; $8C
org $1BA971 ; <- DA971 .
db #!VOLUME_8C ; $8C
org $1BA98C ; <- DA98C .
db #!VOLUME_8C ; $8C
org $1BA9A7 ; <- DA9A7 .
db #!VOLUME_8C ; $8C
org $1BA9C2 ; <- DA9C2 .
db #!VOLUME_C8 ; $C8
org $1BA9ED ; <- DA9ED .
db #!VOLUME_C8 ; $C8
org $1BAA1B ; <- DAA1B .
db #!VOLUME_C8 ; $C8
org $1BAA57 ; <- DAA57 .
db #!VOLUME_C8 ; $C8
org $1BAA68 ; <- DAA68 .
db #!VOLUME_B4 ; $B4
org $1BAA77 ; <- DAA77 .
db #!VOLUME_B4 ; $B4
org $1BAA88 ; <- DAA88 .
db #!VOLUME_B4 ; $B4
org $1BAA99 ; <- DAA99 .
db #!VOLUME_B4 ; $B4

;== Pre-Ganon Fight ==
org $1BABAF ; <- DABAF .
db #!VOLUME_C8 ; $C8
org $1BABC9 ; <- DABC9 .
db #!VOLUME_C8 ; $C8
org $1BABE2 ; <- DABE2 .
db #!VOLUME_C8 ; $C8
org $1BABF6 ; <- DABF6 .
db #!VOLUME_A0 ; $A0
org $1BAC0D ; <- DAC0D .
db #!VOLUME_A0 ; $A0
org $1BAC28 ; <- DAC28 .
db #!VOLUME_C8 ; $C8
org $1BAC46 ; <- DAC46 .
db #!VOLUME_C8 ; $C8
org $1BAC63 ; <- DAC63 .
db #!VOLUME_C8 ; $C8

;== Agah 2 defeated ==
;org $1BACB8 ; <- DACB8 . (silent track)
;db #!VOLUME_C8 ; $C8
org $1BACEC ; <- DACEC .
db #!VOLUME_C8 ; $C8
org $1BAD08 ; <- DAD08 .
db #!VOLUME_C8 ; $C8
org $1BAD25 ; <- DAD25 .
db #!VOLUME_C8 ; $C8
org $1BAD42 ; <- DAD42 .
db #!VOLUME_C8 ; $C8
org $1BAD5F ; <- DAD5F .
db #!VOLUME_C8 ; $C8

;== Ganon ==
org $1BAE17 ; <- DAE17 .
db #!VOLUME_C8 ; $C8
org $1BAE34 ; <- DAE34 .
db #!VOLUME_C8 ; $C8
org $1BAE51 ; <- DAE51 .
db #!VOLUME_C8 ; $C8
org $1BAE88 ; <- DAE88 .
db #!VOLUME_DC ; $DC
org $1BAEBE ; <- DAEBE .
db #!VOLUME_A0 ; $A0
org $1BAEC8 ; <- DAEC8 .
db #!VOLUME_DC ; $DC
org $1BAEE6 ; <- DAEE6 .
db #!VOLUME_DC ; $DC
org $1BAF04 ; <- DAF04 .
db #!VOLUME_B4 ; $B4
org $1BAF2E ; <- DAF2E .
db #!VOLUME_C8 ; $C8
org $1BAF55 ; <- DAF55 .
db #!VOLUME_C8 ; $C8
org $1BAF6B ; <- DAF6B .
db #!VOLUME_C8 ; $C8
org $1BAF81 ; <- DAF81 .
db #!VOLUME_C8 ; $C8
org $1BAFAC ; <- DAFAC .
db #!VOLUME_A0 ; $A0

;== Falling into the Ganon fight ==
org $1BB14F ; <- DB14F .
db #!VOLUME_C8 ; $C8
org $1BB16B ; <- DB16B .
db #!VOLUME_C8 ; $C8
org $1BB180 ; <- DB180 .
db #!VOLUME_C8 ; $C8
org $1BB195 ; <- DB195 .
db #!VOLUME_C8 ; $C8
org $1BB1AA ; <- DB1AA .
db #!VOLUME_C8 ; $C8
org $1BB1BF ; <- DB1BF .
db #!VOLUME_DC ; $DC
