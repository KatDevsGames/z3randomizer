; $7F50D0 - $7F50FF - Block Cypher Parameters
; $7F5100 - $7F51FF - Block Cypher Buffer
!v = "$7F5100"
!n = "$04"
!MXResult = "$06"
!dpScratch = "$08"
!keyBase = "$7F50D0"


!y = "$7F50E0"
!z = "$7F50E4"
!sum = "$7F50E8"

!p = "$7F50EC"
!rounds = "$05"
!e = "$7F50F0"

!upperScratch = "$7F50F2"

CryptoDelta:
dl #$9e3779b9

macro LSR32(value,k)
	LDX.w <k>
	
	?loop:
	LDA <value>+2
	LSR : STA <value>+2 ; do top part
	PHP ; push carry
	LDA <value>
	LSR ; do bottom part
	PLP ; pull carry
	BCC ?nc
		ORA #$80 ; pull in carry
	?nc:
	STA <value>
	
	DEX
	CPX.w #$0000 : BNE ?loop
endmacro

macro ASL32(value,k)
	LDX.w <k>
	
	?loop:
	LDA <value>
	LSR : STA <value> ; do bottom part
	PHP ; push carry
	LDA <value>+2
	LSR
	PLP ; pull carry
	ADC.w #$0000
	STA <value>+2 ; do top part
	
	DEX
	CPX.w #$0000 : BNE ?loop
endmacro

CryptoMX:
	PHX
	LDA !z : STA !dpScratch
	LDA !z+2 : STA !dpScratch+2
	%LSR32(!dpScratch,#$05)
	
	LDA !y : STA !dpScratch+4
	LDA !y+2 : STA !dpScratch+6
	%ASL32(!dpScratch+4,#$02)
	
	LDA !dpScratch : EOR !dpScratch+4 : STA !upperScratch
	LDA !dpScratch+2 : EOR !dpScratch+6 : STA !upperScratch+2
	
	;================================
	
	LDA !z : STA !dpScratch
	LDA !z+2 : STA !dpScratch+2
	%ASL32(!dpScratch,#$04)
	
	LDA !y : STA !dpScratch+4
	LDA !y+2 : STA !dpScratch+6
	%LSR32(!dpScratch,#$03)
	
	LDA !dpScratch : EOR !dpScratch+4 : STA !upperScratch+4
	LDA !dpScratch+2 : EOR !dpScratch+6 : STA !upperScratch+6
	
	;================================
	
	LDA !upperScratch : !ADD !upperScratch+4 : STA !upperScratch
	LDA !upperScratch+2 : ADC !upperScratch+6 : STA !upperScratch+2
	
	;================================
	
	LDA !sum : EOR !y : STA !dpScratch
	LDA !sum+2 : EOR !y+2 : STA !dpScratch+2
	
	;================================
	
	LDA !p : AND.w #$0003 : EOR !e : ASL #2 : TAX ; put (p&3)^e into X
	LDA !keyBase, X : EOR !z : STA !upperScratch+4
	LDA !keyBase+2, X : EOR !z+2 : STA !upperScratch+6
	
	;================================
	
	LDA !upperScratch : EOR !upperScratch+4 : STA !MXResult
	LDA !upperScratch+2 : EOR !upperScratch+6 : STA !MXResult+2
	PLX
RTS

!DIVIDEND_LOW = $4204
!DIVIDEND_HIGH = $4205
!DIVISOR = $4206
!QUOTIENT_LOW = $4214
!QUOTIENT_HIGH = $4215

XXTEA_Decode:
	PHP
		SEP #$20 ; set 8-bit accumulator
		
		; rounds = 6 + 52/n;
		LDA.b #52 : STA !DIVIDEND_LOW ; decimal 52
		STZ !DIVIDEND_HIGH
		LDA !n : STA !DIVISOR
		; NOP #8 ; do something useful here?
		LDA.b #$06
		NOP #6
		!ADD !QUOTIENT_LOW
		STA !rounds
		
		; sum = rounds*DELTA;
		LDA CryptoDelta : STA !dpScratch
		LDA CryptoDelta+1 : STA !dpScratch+1
		LDA CryptoDelta+2 : STA !dpScratch+2
		LDA CryptoDelta+3 : STA !dpScratch+3
		JSR .multiply
		LDA !dpScratch
		STA !sum
		
		; y = v[0];
		REP #$20 ; set 16-bit accumulator
		LDA !v : STA !y
		LDA !v+2 : STA !y+2
		---
			LDA !sum : LSR #2 : AND #$03 : STA !e ; e = (sum >> 2) & 3;
			
			LDA !n : !SUB #$01 : STA !p ; for (p=n-1; p>0; p--) {
			--
				; z = v[p-1];
				DEC : ASL #2 : TAX
				LDA !v, X : STA !z
				LDA !v+2, X : STA !z+2
				
				; y = v[p] -= MX;
				JSR CryptoMX
				LDA !p : ASL #2 : TAX
				LDA !v, X : !SUB !MXResult : STA !v, X : STA !y
				LDA !v+2, X : SBC !MXResult+2 : STA !v+2, X : STA !y+2
				
			LDA !p : DEC : STA !p : BNE -- ; }
			
			; z = v[n-1];
			LDA !n : DEC : ASL #2 : TAX
			LDA !v, X : STA !z
			LDA !v+2, X : STA !z+2
			
			; y = v[0] -= MX;
			JSR CryptoMX
			LDA !v : !SUB !MXResult : STA !v : STA !y
			LDA !v+2 : SBC !MXResult+2 : STA !v+2 : STA !y+2
			
			; sum -= DELTA;
			LDA !sum : !SUB CryptoDelta : STA !sum
			LDA !sum+2 : !SUB CryptoDelta+2 : STA !sum+2
			
		LDA !rounds : BEQ + : BRL --- : + ; } while (--rounds);
	PLP
RTL

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

.multiply
           LDA     #$00
           STA     !upperScratch+4   ;Clear upper half of
           STA     !upperScratch+5   ;!upperScratchuct
           STA     !upperScratch+6
           STA     !upperScratch+7
           LDX     #$20     ;Set binary count to 32
.shift_r
           LSR     !dpScratch+3   ;Shift multiplyer right
           ROR     !dpScratch+2
           ROR     !dpScratch+1
           ROR     !dpScratch
           BCC     .rotate_r ;Go rotate right if c = 0
           LDA     !upperScratch+4    ;Get upper half of !upperScratchuct
           !ADD    !rounds   ; and add multiplicand to it
           STA     !upperScratch+4
           LDA     !upperScratch+5
           ADC.w   #$00
           STA     !upperScratch+5
           LDA     !upperScratch+6
           ADC.w   #$00
           STA     !upperScratch+6
           LDA     !upperScratch+7
           ADC.w   #$00
.rotate_r
           ROR     a        ;Rotate partial !upperScratchuct
           STA     !upperScratch+7   ; right
           ROR     !upperScratch+6
           ROR     !upperScratch+5
           ROR     !upperScratch+4
           ROR     !upperScratch+3
           ROR     !upperScratch+2
           ROR     !upperScratch+1
           ROR     !upperScratch
           DEX              ;Decrement bit count and
           BNE     .shift_r ; loop until 32 bits are done
           ;LDA     MULXP1   ;Add dps and put sum in MULXP2
           ;!ADD    MULXP2
           ;STA     MULXP2
RTS

;BTEA will encode or decode n words as a single block where n > 1
;
;v is the n word data vector
;k is the 4 word key
;n is negative for decoding
;if n is zero result is 1 and no coding or decoding takes place, otherwise the result is zero
;assumes 32 bit 'long' and same endian coding and decoding
;#include <stdint.h>
;#define DELTA 0x9e3779b9
;#define MX (((z>>5^y<<2) + (y>>3^z<<4)) ^ ((sum^y) + (key[(p&3)^e] ^ z)))
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