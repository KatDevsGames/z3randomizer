; Scrap04 used for n
; Scrap06 used for rounds
; Scrap08 use for dpScratch/MXResult (lower 32 of dpScratch)

CryptoDelta:
dd #$9e3779b9

; For use in an unrolled loop
macro LSR32Single(value)
	CLC;
	LDA.b <value>+2 : ROR : STA.b <value>+2 ; do top part
	LDA.b <value> : ROR : STA.b <value> ; do bottom part
	; ROR handles the carry from the upper byte for us
endmacro

macro ASL32Single(value)
	CLC
	LDA.b <value> : ROL : STA.b <value> ; do bottom part
	LDA.b <value>+2 : ROL : STA.b <value>+2 ; do top part
	; ROL handles the carry from the lower byte for us
endmacro

CryptoMX:
	PHX

	; upperScratch = (z>>5 ^ y <<2)
	LDA.w z : STA.b Scrap08
	LDA.w z+2 : STA.b Scrap08+2
	%LSR32Single(Scrap08)
	%LSR32Single(Scrap08)
	%LSR32Single(Scrap08)
	%LSR32Single(Scrap08)
	%LSR32Single(Scrap08)
	;%LSR32(Scrap08,#$05)

	LDA.w y : STA.b Scrap08+4
	LDA.w y+2 : STA.b Scrap08+6
	%ASL32Single(Scrap08+4)
	%ASL32Single(Scrap08+4)
	;%ASL32(Scrap08+4,#$02)

	LDA.b Scrap08 : EOR.b Scrap08+4 : STA.w CryptoScratch
	LDA.b Scrap08+2 : EOR.b Scrap08+6 : STA.w CryptoScratch+2

	;================================
	; upperscratch2 = (y>>3^z<<4)

	LDA.w z : STA.b Scrap08
	LDA.w z+2 : STA.b Scrap08+2
	%ASL32Single(Scrap08)
	%ASL32Single(Scrap08)
	%ASL32Single(Scrap08)
	%ASL32Single(Scrap08)
	;%ASL32(Scrap08,#$04)

	LDA.w y : STA.b Scrap08+4
	LDA.w y+2 : STA.b Scrap08+6
	%LSR32Single(Scrap08+4)
	%LSR32Single(Scrap08+4)
	%LSR32Single(Scrap08+4)
	;%LSR32(Scrap08+4,#$03)

	LDA.b Scrap08 : EOR.b Scrap08+4 : STA.w CryptoScratch+4
	LDA.b Scrap08+2 : EOR.b Scrap08+6 : STA.w CryptoScratch+6

	;================================
	; upperscratch = upperscratch + upperscratch2 ( == (z>>5^y<<2) + (y>>3^z<<4) )

	LDA.w CryptoScratch : !ADD.w CryptoScratch+4 : STA.w CryptoScratch
	LDA.w CryptoScratch+2 : ADC.w CryptoScratch+6 : STA.w CryptoScratch+2

	;================================
	; dpscratch = sum^y

	LDA.w Sum : EOR.w y : STA.b Scrap08
	LDA.w Sum+2 : EOR.w y+2 : STA.b Scrap08+2

	;================================
	; dpscratch2 =  (k[p&3^e]^z)

	LDA.w p : AND.w #$0003 : EOR.w e : ASL #2 : TAX ; put (p&3)^e into X
	LDA.w KeyBase, X : EOR.w z : STA.b Scrap08+4
	LDA.w KeyBase+2, X : EOR.w z+2 : STA.b Scrap08+6

	;================================
	; upperscratch2 =  dpscratch + dpscratch2 (== (sum^y) + (k[p&3^e]^z))
	LDA.b Scrap08 : !ADD.b Scrap08+4 : STA.w CryptoScratch+4
	LDA.b Scrap08+2 : ADC.b Scrap08+6 : STA.w CryptoScratch+6

	;================================
	; MXResult = uppserscratch ^ upperscratch2

	LDA.w CryptoScratch : EOR.w CryptoScratch+4 : STA.b Scrap08
	LDA.w CryptoScratch+2 : EOR.w CryptoScratch+6 : STA.b Scrap08+2
	PLX
RTS

XXTEA_Decode:
	PHP : PHB
		SEP #$30 ; set 8-bit accumulator and index

		LDA.b #$7F : PHA : PLB

		STZ.b Scrap04+1 ; set upper byte of n to be zero, so it can safely be accessed in 16-bit mode

		; search for lookup table index to avoid division and multiplication
		LDX.b #0
		-
			LDA.l .n_lookup, X
			CMP.b Scrap04 : !BLT +
			INX
			BRA -
		+
		; rounds = 6 + 52/n;
		LDA.l .round_counts, X : STA.b Scrap06 : STZ.b Scrap06+1

		REP #$20 ; set 16-bit accumulator

		; sum = rounds*DELTA;
		TXA : ASL #2 : TAX
		LDA.l .initial_sums, X : STA.w Sum
		LDA.l .initial_sums+2, X : STA.w Sum+2

		; y = v[0];
		LDA.w v : STA.w y
		LDA.w v+2 : STA.w y+2
		---
			LDA.w Sum : LSR #2 : AND.w #$0003 : STA.w e ; e = (sum >> 2) & 3;

			LDA.b Scrap04 : DEC : STA.w p
			-- BEQ + ; for (p=n-1; p>0; p--) {
				; z = v[p-1];
				ASL #2 : TAX
				LDA.w v-4, X : STA.w z
				LDA.w v-4+2, X : STA.w z+2

				; y = v[p] -= MX;
				JSR CryptoMX
				LDA.w p : ASL #2 : TAX
				LDA.w v, X : !SUB.b Scrap08 : STA.w v, X : STA.w y
				LDA.w v+2, X : SBC.b Scrap08+2 : STA.w v+2, X : STA.w y+2

			LDA.w p : DEC : STA.w p : BRA -- ; }
			+

			; z = v[n-1];
			LDA.b Scrap04 : DEC : ASL #2 : TAX
			LDA.w v, X : STA.w z
			LDA.w v+2, X : STA.w z+2

			; y = v[0] -= MX;
			JSR CryptoMX
			LDA.w v : !SUB.b Scrap08 : STA.w v : STA.w y
			LDA.w v+2 : SBC.b Scrap08+2 : STA.w v+2 : STA.w y+2

			; sum -= DELTA;
			LDA.w Sum : !SUB.l CryptoDelta : STA.w Sum
			LDA.w Sum+2 : SBC.l CryptoDelta+2 : STA.w Sum+2

		DEC.b Scrap06 : BEQ + : JMP --- : + ; } while (--rounds);
	PLB : PLP
RTL

; Note: uncomment any values from these tables that correspond to values of n actually in use
; (unused values are commented out to improve performance/ avoid wasting space)
.n_lookup
;db 52 ; n > 52
;db 26 ; n is 27 to 52
;db 17 ; n is 18 to 26
;db 13 ; n is 14 to 17
;db 10 ; n is 11 to 13
;db 8  ; n is 9 to 10
;db 7  ; n is 8
;db 6  ; n is 7
;db 5  ; n is 6
;db 4  ; n is 5
;db 3  ; n is 4
;db 2  ; n is 3
db 1  ; n is 2

.round_counts
;db 6  ; n > 52
;db 7  ; n is 27 to 52
;db 8  ; n is 18 to 26
;db 9  ; n is 14 to 17
;db 10 ; n is 11 to 13
;db 11 ; n is 9 to 10
;db 12 ; n is 8
;db 13 ; n is 7
;db 14 ; n is 6
;db 16 ; n is 5
;db 19 ; n is 4
;db 23 ; n is 3
db 32 ; n is 2

.initial_sums
;dd (6*$9e3779b9)&$ffffffff  ; n > 52
;dd (7*$9e3779b9)&$ffffffff  ; n is 27 to 52
;dd (8*$9e3779b9)&$ffffffff  ; n is 18 to 26
;dd (9*$9e3779b9)&$ffffffff  ; n is 14 to 17
;dd (10*$9e3779b9)&$ffffffff ; n is 11 to 13
;dd (11*$9e3779b9)&$ffffffff ; n is 9 to 10
;dd (12*$9e3779b9)&$ffffffff ; n is 8
;dd (13*$9e3779b9)&$ffffffff ; n is 7
;dd (14*$9e3779b9)&$ffffffff ; n is 6
;dd (16*$9e3779b9)&$ffffffff ; n is 5
;dd (19*$9e3779b9)&$ffffffff ; n is 4
;dd (23*$9e3779b9)&$ffffffff ; n is 3
dd (32*$9e3779b9)&$ffffffff	; n is 2

