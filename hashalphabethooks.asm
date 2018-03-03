;--------------------------------------------------------------------------------
!FSTILE_SPACE = "$0188"

!FSTILE_BRACKET_OPEN_TOP = "$1D8A"
!FSTILE_BRACKET_OPEN_BOTTOM = "$1D9A"

!FSTILE_BRACKET_CLOSE_TOP = "$1D8B"
!FSTILE_BRACKET_CLOSE_BOTTOM = "$1D9B"

!FSTILE_A_TOP = "$1D4A"
!FSTILE_A_BOTTOM = "$1D5A"

!FSTILE_H_TOP = "$1D61"
!FSTILE_H_BOTTOM = "$1D71"

!FSTILE_S_TOP = "$1D6C"
!FSTILE_S_BOTTOM = "$1D7C"
;--------------------------------------------------------------------------------
org $0CDE60 ; <- 65E60
FileSelect_CopyFile_Top:
db $62, $A5, $00, $15
dw $1D4C, !FSTILE_SPACE, $1D68, !FSTILE_SPACE, $1D69, !FSTILE_SPACE, $1D82, !FSTILE_SPACE, !FSTILE_SPACE, !FSTILE_SPACE, !FSTILE_SPACE
;dw $1CAC, !FSTILE_SPACE, $1D23, !FSTILE_SPACE, $1D89, !FSTILE_SPACE, $1D04, !FSTILE_SPACE, $1D89, !FSTILE_SPACE, $1D07
;--------------------------------------------------------------------------------
org $0CDE7A ; <- 65E7A
FileSelect_CopyFile_Bottom:
db $62, $C5, $00, $15
dw $1D5C, !FSTILE_SPACE, $1D78, !FSTILE_SPACE, $1D79, !FSTILE_SPACE, $1D92, !FSTILE_SPACE, !FSTILE_SPACE, !FSTILE_SPACE, !FSTILE_SPACE
;dw $1CBC, !FSTILE_SPACE, $1D33, !FSTILE_SPACE, $1D99, !FSTILE_SPACE, $1D14, !FSTILE_SPACE, $1D99, !FSTILE_SPACE, $1D17
;--------------------------------------------------------------------------------
org $0CDE94 ; <- 65E94
FileSelect_KillFile_Top:
db $63, $25, $00, $19
dw $1D64, !FSTILE_SPACE, $1D62, !FSTILE_SPACE, $1D65, !FSTILE_SPACE, $1D65, !FSTILE_SPACE, !FSTILE_SPACE, !FSTILE_SPACE, !FSTILE_SPACE, !FSTILE_SPACE, !FSTILE_SPACE
;dw $1D64, !FSTILE_SPACE, $1D62, !FSTILE_SPACE, $1D65, !FSTILE_SPACE, $1D65, !FSTILE_SPACE, $1D04, !FSTILE_SPACE, $1D89, !FSTILE_SPACE, $1D07
;--------------------------------------------------------------------------------
;org $0CDEB2 ; <- 65EB2
;FileSelect_KillFile_Bottom:
db $63, $45, $00, $19
dw $1D74, !FSTILE_SPACE, $1D72, !FSTILE_SPACE, $1D75, !FSTILE_SPACE, $1D75, !FSTILE_SPACE, !FSTILE_SPACE, !FSTILE_SPACE, !FSTILE_SPACE, !FSTILE_SPACE, !FSTILE_SPACE
;dw $1D74, !FSTILE_SPACE, $1D72, !FSTILE_SPACE, $1D75, !FSTILE_SPACE, $1D75, !FSTILE_SPACE, $1D14, !FSTILE_SPACE, $1D99, !FSTILE_SPACE, $1D17
;--------------------------------------------------------------------------------
;org $0CDDE8 ; <- 65DE8
;FileSelect_PlayerSelectText_Top:
;db $60, $62, $00, $37
;db $8A, $1D, $88, $01, $69, $1D, $88, $01, $65, $1D, $88, $01, $4A, $1D, $88, $01
;db $82, $1D, $88, $01, $4E, $1D, $88, $01, $6B, $1D, $88, $01, $88, $01, $6C, $1D
;db $88, $01, $4E, $1D, $88, $01, $65, $1D, $88, $01, $4E, $1D, $88, $01, $4C, $1D
;db $88, $01, $6D, $1D, $88, $01, $8B, $1D
;--------------------------------------------------------------------------------
;org $0CDE24 ; <- 65E24
;FileSelect_PlayerSelectText_Bottom:
;db $60, $82, $00, $37
;db $9A, $1D, $88, $01, $79, $1D, $88, $01, $75, $1D, $88, $01, $5A, $1D, $88, $01
;db $92, $1D, $88, $01, $5E, $1D, $88, $01, $7B, $1D, $88, $01, $88, $01, $7C, $1D
;db $88, $01, $5E, $1D, $88, $01, $75, $1D, $88, $01, $5E, $1D, $88, $01, $5C, $1D
;db $88, $01, $7D, $1D, $88, $01, $9B, $1D
;--------------------------------------------------------------------------------