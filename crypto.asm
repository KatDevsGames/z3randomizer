; $7F50D0 - $7F50FF - Block Cypher Parameters
; $7F5100 - $7F51FF - Block Cypher Buffer
!v = "$7F5100"
!n = "$04"
!MXResult = "$08" ; an alternate name for the lower 32 bits of dpScratch
!dpScratch = "$08"
!keyBase = "$7F50D0"


!y = "$7F50E0"
!z = "$7F50E4"
!sum = "$7F50E8"

!p = "$7F50EC"
!rounds = "$06"
!e = "$7F50F0"

!upperScratch = "$7F50F2"

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

;macro LSR32(value,k)
;	LDX.b <k>
;	?loop:
;	%LSR32Single(<value>,<k>)
;	DEX : CPX.b #$00 : BNE ?loop
;endmacro

;macro ASL32(value,k)
;	LDX.b <k>
;	?loop:
;	%LSR32Single(<value>,<k>)
;	DEX : CPX.b #$00 : BNE ?loop
;endmacro

CryptoMX:
	PHX

	; upperScratch = (z>>5 ^ y <<2)
	LDA.w !z : STA.b !dpScratch
	LDA.w !z+2 : STA.b !dpScratch+2
	%LSR32Single(!dpScratch)
	%LSR32Single(!dpScratch)
	%LSR32Single(!dpScratch)
	%LSR32Single(!dpScratch)
	%LSR32Single(!dpScratch)
	;%LSR32(!dpScratch,#$05)

	LDA.w !y : STA.b !dpScratch+4
	LDA.w !y+2 : STA.b !dpScratch+6
	%ASL32Single(!dpScratch+4)
	%ASL32Single(!dpScratch+4)
	;%ASL32(!dpScratch+4,#$02)

	LDA.b !dpScratch : EOR.b !dpScratch+4 : STA.w !upperScratch
	LDA.b !dpScratch+2 : EOR.b !dpScratch+6 : STA.w !upperScratch+2

	;================================
	; upperscratch2 = (y>>3^z<<4)

	LDA.w !z : STA.b !dpScratch
	LDA.w !z+2 : STA.b !dpScratch+2
	%ASL32Single(!dpScratch)
	%ASL32Single(!dpScratch)
	%ASL32Single(!dpScratch)
	%ASL32Single(!dpScratch)
	;%ASL32(!dpScratch,#$04)

	LDA.w !y : STA.b !dpScratch+4
	LDA.w !y+2 : STA.b !dpScratch+6
	%LSR32Single(!dpScratch+4)
	%LSR32Single(!dpScratch+4)
	%LSR32Single(!dpScratch+4)
	;%LSR32(!dpScratch+4,#$03)

	LDA.b !dpScratch : EOR.b !dpScratch+4 : STA.w !upperScratch+4
	LDA.b !dpScratch+2 : EOR.b !dpScratch+6 : STA.w !upperScratch+6

	;================================
	; upperscratch = upperscratch + upperscratch2 ( == (z>>5^y<<2) + (y>>3^z<<4) )

	LDA.w !upperScratch : !ADD.w !upperScratch+4 : STA.w !upperScratch
	LDA.w !upperScratch+2 : ADC.w !upperScratch+6 : STA.w !upperScratch+2

	;================================
	; dpscratch = sum^y

	LDA.w !sum : EOR.w !y : STA.b !dpScratch
	LDA.w !sum+2 : EOR.w !y+2 : STA.b !dpScratch+2

	;================================
	; dpscratch2 =  (k[p&3^e]^z)

	LDA.w !p : AND.w #$0003 : EOR.w !e : ASL #2 : TAX ; put (p&3)^e into X
	LDA.w !keyBase, X : EOR.w !z : STA.b !dpScratch+4
	LDA.w !keyBase+2, X : EOR.w !z+2 : STA.b !dpScratch+6

	;================================
	; upperscratch2 =  dpscratch + dpscratch2 (== (sum^y) + (k[p&3^e]^z))
	LDA.b !dpScratch : !ADD.b !dpScratch+4 : STA.w !upperScratch+4
	LDA.b !dpScratch+2 : ADC.b !dpScratch+6 : STA.w !upperScratch+6

	;================================
	; MXResult = uppserscratch ^ upperscratch2

	LDA.w !upperScratch : EOR.w !upperScratch+4 : STA.b !MXResult
	LDA.w !upperScratch+2 : EOR.w !upperScratch+6 : STA.b !MXResult+2
	PLX
RTS

;!DIVIDEND_LOW = $4204
;!DIVIDEND_HIGH = $4205
;!DIVISOR = $4206
;!QUOTIENT_LOW = $4214
;!QUOTIENT_HIGH = $4215

XXTEA_Decode:
	PHP : PHB
		SEP #$30 ; set 8-bit accumulator and index

		LDA.b #$7F : PHA : PLB

		STZ.b !n+1 ; set upper byte of n to be zero, so it can safely be accessed in 16-bit mode

		; search for lookup table index to avoid division and multiplication
		LDX.b #0
		-
			LDA.l .n_lookup, X
			CMP.b !n : !BLT +
			INX
			BRA -
		+
		; rounds = 6 + 52/n;
		LDA.l .round_counts, X : STA.b !rounds : STZ.b !rounds+1

		REP #$20 ; set 16-bit accumulator

		; sum = rounds*DELTA;
		TXA : ASL #2 : TAX
		LDA.l .initial_sums, X : STA.w !sum
		LDA.l .initial_sums+2, X : STA.w !sum+2

		; y = v[0];
		LDA.w !v : STA.w !y
		LDA.w !v+2 : STA.w !y+2
		---
			LDA.w !sum : LSR #2 : AND.w #$0003 : STA.w !e ; e = (sum >> 2) & 3;

			LDA.b !n : DEC : STA.w !p
			-- BEQ + ; for (p=n-1; p>0; p--) {
				; z = v[p-1];
				ASL #2 : TAX
				LDA.w !v-4, X : STA.w !z
				LDA.w !v-4+2, X : STA.w !z+2

				; y = v[p] -= MX;
				JSR CryptoMX
				LDA.w !p : ASL #2 : TAX
				LDA.w !v, X : !SUB.b !MXResult : STA.w !v, X : STA.w !y
				LDA.w !v+2, X : SBC.b !MXResult+2 : STA.w !v+2, X : STA.w !y+2

			LDA.w !p : DEC : STA.w !p : BRA -- ; }
			+

			; z = v[n-1];
			LDA.b !n : DEC : ASL #2 : TAX
			LDA.w !v, X : STA.w !z
			LDA.w !v+2, X : STA.w !z+2

			; y = v[0] -= MX;
			JSR CryptoMX
			LDA.w !v : !SUB.b !MXResult : STA.w !v : STA.w !y
			LDA.w !v+2 : SBC.b !MXResult+2 : STA.w !v+2 : STA.w !y+2

			; sum -= DELTA;
			LDA.w !sum : !SUB.l CryptoDelta : STA.w !sum
			LDA.w !sum+2 : SBC.l CryptoDelta+2 : STA.w !sum+2

		DEC !rounds : BEQ + : JMP --- : + ; } while (--rounds);
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

;void btea(uint32_t *v, int n, uint32_t const key[4]) {
;  uint32_t y, z, sum;
;  unsigned p, rounds, e;

;  } else if (n < -1) {  /* Decoding Part */
;    n = -n;
;    rounds = 6 + 52/n;
;    sum = rounds*DELTA;
;    y = v[0];
;    do {
;      e = (sum >> 2) & 3;
;      for (p=n-1; p>0; p--) {
;        z = v[p-1];
;        y = v[p] -= MX;
;      }
;      z = v[n-1];
;      y = v[0] -= MX;
;      sum -= DELTA;
;    } while (--rounds);
;  }

;BTEA will encode or decode n words as a single block where n > 1
;
;v is the n word data vector
;k is the 4 word key
;n is negative for decoding
;if n is zero result is 1 and no coding or decoding takes place, otherwise the result is zero
;assumes 32 bit 'long' and same endian coding and decoding
;#include <stdint.h>
;#define DELTA 0x9e3779b9
;#define MX ((((z>>5)^(y<<2)) + ((y>>3)^(z<<4))) ^ ((sum^y) + (key[(p&3)^e] ^ z)))
;
;void btea(uint32_t *v, int n, uint32_t const key[4]) {
;  uint32_t y, z, sum;
;  unsigned p, rounds, e;
;  if (n > 1) {          /* Coding Part */
;    rounds = 6 + 52/n;
;    sum = 0;
;    z = v[n-1];
;    do {
;      sum += DELTA;
;      e = (sum >> 2) & 3;
;      for (p=0; p<n-1; p++) {
;        y = v[p+1];
;        z = v[p] += MX;
;      }
;      y = v[0];
;      z = v[n-1] += MX;
;    } while (--rounds);
;  } else if (n < -1) {  /* Decoding Part */
;    n = -n;
;    rounds = 6 + 52/n;
;    sum = rounds*DELTA;
;    y = v[0];
;    do {
;      e = (sum >> 2) & 3;
;      for (p=n-1; p>0; p--) {
;        z = v[p-1];
;        y = v[p] -= MX;
;      }
;      z = v[n-1];
;      y = v[0] -= MX;
;      sum -= DELTA;
;    } while (--rounds);
;  }
;}
