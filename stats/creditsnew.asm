;===================================================================================================
; LEAVE THIS HERE FOR PHP WRITES
;===================================================================================================
YourSpriteCreditsHi:
db 2
db 55
db "                            " ; $238002

YourSpriteCreditsLo:
db 2
db 55
db "                            " ; $238020

;===================================================================================================

CreditsLineTable:
	fillword CreditsLineBlank : fill 800

;===================================================================================================

!CLINE = -1

;---------------------------------------------------------------------------------------------------

macro smallcredits(text, color)
	!CLINE #= !CLINE+1
	table "creditscharmapsmall_<color>.txt"

	?line:
		db (32-(?end-?text))/2
		db 2*(?end-?text)-1
	?text:
		db "<text>"
	?end:

	pushpc
	org CreditsLineTable+!CLINE+!CLINE : dw ?line
	pullpc

endmacro

;---------------------------------------------------------------------------------------------------
macro bigcredits(text)
	!CLINE #= !CLINE+1
	table "creditscharmapbighi.txt"

	?line_top:
		db (32-(?end-?text))/2
		db 2*(?end-?text)-1
	?text:
		db "<text>"
	?end:

	pushpc
	org CreditsLineTable+!CLINE+!CLINE : dw ?line_top
	pullpc


	table "creditscharmapbiglo.txt"
	?line_bottom:
		db (32-(?end-?text))/2
		db 2*(?end-?text)-1
		db "<text>"


	!CLINE #= !CLINE+1
	pushpc
	org CreditsLineTable+!CLINE+!CLINE : dw ?line_bottom
	pullpc

endmacro

;---------------------------------------------------------------------------------------------------

macro bigcreditsleft(text)
	!CLINE #= !CLINE+1
	table "creditscharmapbighi.txt"

	?line_top:
		db 2
		db 2*(?end-?text)-1
	?text:
		db "<text>"
	?end:

	pushpc
	org CreditsLineTable+!CLINE+!CLINE : dw ?line_top
	pullpc


	table "creditscharmapbiglo.txt"
	?line_bottom:
		db 2
		db 2*(?end-?text)-1
		db "<text>"


	!CLINE #= !CLINE+1
	pushpc
	org CreditsLineTable+!CLINE+!CLINE : dw ?line_bottom
	pullpc

endmacro

;---------------------------------------------------------------------------------------------------

macro emptyline()
	!CLINE #= !CLINE+1
	pushpc
	org CreditsLineTable+!CLINE+!CLINE : dw CreditsEmptyLine
	pullpc
endmacro

macro blankline()
	!CLINE #= !CLINE+1
	pushpc
	org CreditsLineTable+!CLINE+!CLINE : dw CreditsLineBlank
	pullpc
endmacro

macro addarbline(l)
	!CLINE #= !CLINE+1
	pushpc
	org CreditsLineTable+!CLINE+!CLINE : dw <l>
	pullpc
endmacro

;===================================================================================================

CreditsEmptyLine:
	db $00, $01, $9F

CreditsLineBlank:
	db $FF

;---------------------------------------------------------------------------------------------------

%emptyline()
%smallcredits("ORIGINAL GAME STAFF", "yellow")

%blankline()
%blankline()

%smallcredits("EXECUTIVE PRODUCER", "green")

%blankline()

%bigcredits("HIROSHI YAMAUCHI")

%blankline()
%blankline()

%smallcredits("PRODUCER", "yellow")

%blankline()

%bigcredits("SHIGERU MIYAMOTO")

%blankline()
%blankline()

%smallcredits("DIRECTOR", "red")

%blankline()

%bigcredits("TAKASHI TEZUKA")

%blankline()
%blankline()

%smallcredits("SCRIPT WRITER", "green")

%blankline()

%bigcredits("KENSUKE TANABE")

%blankline()
%blankline()

%smallcredits("ASSISTANT DIRECTORS", "yellow")

%blankline()

%bigcredits("YASUHISA YAMAMURA")

%blankline()

%bigcredits("YOICHI YAMADA")

%blankline()
%blankline()

%smallcredits("SCREEN GRAPHICS DESIGNERS", "green")

%emptyline()
%emptyline()

%smallcredits("OBJECT DESIGNERS", "yellow")

%blankline()

%bigcredits("SOICHIRO TOMITA")

%blankline()

%bigcredits("TAKAYA IMAMURA")

%blankline()
%blankline()

%smallcredits("BACK GROUND DESIGNERS", "yellow")

%blankline()

%bigcredits("MASANAO ARIMOTO")

%blankline()

%bigcredits("TSUYOSHI WATANABE")

%blankline()
%blankline()

%smallcredits("PROGRAM DIRECTOR", "red")

%blankline()

%bigcredits("TOSHIHIKO NAKAGO")

%blankline()
%blankline()

%smallcredits("MAIN PROGRAMMER", "yellow")

%blankline()

%bigcredits("YASUNARI SOEJIMA")

%blankline()
%blankline()

%smallcredits("OBJECT PROGRAMMER", "green")

%blankline()

%bigcredits("KAZUAKI MORITA")

%blankline()
%blankline()

%smallcredits("PROGRAMMERS", "yellow")

%blankline()

%bigcredits("TATSUO NISHIYAMA")

%blankline()

%bigcredits("YUICHI YAMAMOTO")

%blankline()

%bigcredits("YOSHIHIRO NOMOTO")

%blankline()

%bigcredits("EIJI NOTO")

%blankline()

%bigcredits("SATORU TAKAHATA")

%blankline()

%bigcredits("TOSHIO IWAWAKI")

%blankline()

%bigcredits("SHIGEHIRO KASAMATSU")

%blankline()

%bigcredits("YASUNARI NISHIDA")

%blankline()
%blankline()

%smallcredits("SOUND COMPOSER", "red")

%blankline()

%bigcredits("KOJI KONDO")

%blankline()
%blankline()

%smallcredits("COORDINATORS", "green")

%blankline()

%bigcredits("KEIZO KATO")

%blankline()

%bigcredits("TAKAO SHIMIZU")

%blankline()
%blankline()

%smallcredits("PRINTED ART WORK", "yellow")

%blankline()

%bigcredits("YOICHI KOTABE")

%blankline()

%bigcredits("HIDEKI FUJII")

%blankline()

%bigcredits("YOSHIAKI KOIZUMI")

%blankline()

%bigcredits("YASUHIRO SAKAI")

%blankline()

%bigcredits("TOMOAKI KUROUME")

%blankline()
%blankline()

%smallcredits("SPECIAL THANKS TO", "red")

%blankline()

%bigcredits("NOBUO OKAJIMA")

%blankline()

%bigcredits("YASUNORI TAKETANI")

%blankline()

%bigcredits("KIYOSHI KODA")

%blankline()

%bigcredits("TAKAMITSU KUZUHARA")

%blankline()

%bigcredits("HIRONOBU KAKUI")

%blankline()

%bigcredits("SHIGEKI YAMASHIRO")

%blankline()

%emptyline()
%emptyline()
%emptyline()
%emptyline()

;---------------------------------------------------------------------------------------------------

%smallcredits("RANDOMIZER CONTRIBUTORS", "red")

%blankline()
%blankline()

%smallcredits("ITEM RANDOMIZER", "yellow")

%blankline()

%bigcredits("KATDEVSGAMES         VEETORP")

%blankline()

%bigcredits("CHRISTOSOWEN       DESSYREQT")

%blankline()

%bigcredits("SMALLHACKER           SYNACK")

%blankline()
%blankline()

%smallcredits("ENTRANCE RANDOMIZER", "green")

%blankline()

%bigcredits("AMAZINGAMPHAROS   LLCOOLDAVE")

%blankline()

%bigcredits("KEVINCATHCART    CASSIDYMOEN")

%blankline()
%blankline()

%smallcredits("ENEMY RANDOMIZER", "yellow")

%blankline()

%bigcredits("ZARBY89              SOSUKE3")

%blankline()

%bigcredits("ENDEROFGAMES")

%blankline()
%blankline()

%smallcredits("DOOR RANDOMIZER", "green")

%blankline()

%bigcredits("AERINON             COMPILING")

%blankline()
%blankline()

%smallcredits("FESTIVE RANDOMIZER", "yellow")

%blankline()

%bigcredits("KAN                    TOTAL")

%blankline()

%bigcredits("CATOBAT            DINSAPHIR")

%blankline()
%blankline()

%smallcredits("SPRITE DEVELOPMENT", "green")

%blankline()

%bigcredits("MIKETRETHEWEY         IBAZLY")

%blankline()
%bigcredits("FISH_WAFFLE64        KRELBEL")

%blankline()

%bigcredits("ACHY                 ARTHEAU")

%blankline()

%bigcredits("GLAN                 TWROXAS")

%blankline()

%bigcredits("PLAGUEDONE         TARTHORON")

%blankline()
%blankline()

%smallcredits("YOUR SPRITE BY", "yellow")

%addarbline(YourSpriteCreditsHi)
%addarbline(YourSpriteCreditsLo)

%blankline()
%blankline()

%smallcredits("MSU SUPPORT", "green")

%blankline()

%bigcredits("QWERTYMODO")

%blankline()
%blankline()

%smallcredits("PALETTE SHUFFLER", "yellow")

%blankline()

%bigcredits("NELSON AKA SWR")

%blankline()
%blankline()

%smallcredits("SPECIAL THANKS", "red")

%blankline()

%bigcredits("SUPERSKUJ          EVILASH25")

%blankline()

%bigcredits("MYRAMONG             JOSHRTA")

%blankline()

%bigcredits("WALKINGEYE     MATHONNAPKINS")

%blankline()

%bigcredits("MICHAELK              FOUTON")

%blankline()

%bigcredits("BONTA                EMOSARU")

%blankline()

%bigcredits("SAKURATSUBASA")

%blankline()

%bigcredits("AND...")

%blankline()

%bigcredits("THE ALTTP RANDOMIZER COMMUNITY")

%blankline()
%blankline()

%smallcredits("COMMUNITY DISCORD", "green")

%blankline()

%bigcredits("HTTPS://ALTTPR.COM/DISCORD")

%blankline()

%emptyline()
%emptyline()
%emptyline()
%emptyline()
%emptyline()
%emptyline()
%emptyline()
%emptyline()
%emptyline()
%emptyline()
%emptyline()
%emptyline()
%emptyline()
%emptyline()
%emptyline()
%emptyline()
%emptyline()
%emptyline()
%emptyline()
%emptyline()
%emptyline()
%emptyline()
%emptyline()
%emptyline()
%emptyline()
%emptyline()
%emptyline()
%emptyline()

;===================================================================================================

print "Line number: !CLINE | Expected: 302"

if !CLINE > 302
	error "Too many credits lines. !CLINE > 302"

elseif !CLINE < 302
	warn "Too few credits lines. !CLINE < 302; Adding additional empties for alignment."

endif


; Set line always to line up with stats
!CLINE #= 302

;===================================================================================================

%smallcredits("THE IMPORTANT STUFF", "yellow")

%blankline()
%blankline()

%emptyline()
%smallcredits("TIME FOUND", "green")

%blankline()
%blankline()

%bigcreditsleft("FIRST SWORD")

%blankline()

%bigcreditsleft("PEGASUS BOOTS")

%blankline()

%bigcreditsleft("FLUTE")

%blankline()

%bigcreditsleft("MIRROR")

%blankline()
%blankline()

%emptyline()
%smallcredits("BOSS KILLS", "yellow")

%blankline()
%blankline()

%bigcreditsleft("SWORDLESS                /13")

%blankline()

%bigcreditsleft("FIGHTER'S SWORD          /13")

%blankline()

%bigcreditsleft("MASTER SWORD             /13")

%blankline()

%bigcreditsleft("TEMPERED SWORD           /13")

%blankline()

%bigcreditsleft("GOLD SWORD               /13")

%blankline()
%blankline()

%smallcredits("GAME STATS", "red")

%blankline()
%blankline()

%bigcreditsleft("GT BIG KEY               /22")

%blankline()

%bigcreditsleft("CHEST TURNS")

%blankline()

%bigcreditsleft("BONKS")

%blankline()

%bigcreditsleft("SAVE AND QUITS")

%blankline()

%bigcreditsleft("DEATHS")

%blankline()

%bigcreditsleft("FAERIE REVIVALS")

%blankline()

%bigcreditsleft("TOTAL MENU TIME")

%blankline()

%bigcreditsleft("TOTAL LAG TIME")

%blankline()
%blankline()


%blankline()
%blankline()


%blankline()
%blankline()


%blankline()
%blankline()


%blankline()

%emptyline()
%emptyline()
%bigcreditsleft("COLLECTION RATE         /216")

%blankline()

%bigcreditsleft("TOTAL TIME")

%blankline()

%emptyline()
%emptyline()
%emptyline()
%emptyline()
%emptyline()
%emptyline()

;---------------------------------------------------------------------------------------------------

!FIRST_SWORD_X = 19
!FIRST_SWORD_Y = 310
!PEGASUS_BOOTS_X = 19
!PEGASUS_BOOTS_Y = 313
!FLUTE_X = 19
!FLUTE_Y = 316
!MIRROR_X = 19
!MIRROR_Y = 319
!SWORDLESS_X = 23
!SWORDLESS_Y = 327
!FIGHTERS_SWORD_X = 23
!FIGHTERS_SWORD_Y = 330
!MASTER_SWORD_X = 23
!MASTER_SWORD_Y = 333
!TEMPERED_SWORD_X = 23
!TEMPERED_SWORD_Y = 336
!GOLD_SWORD_X = 23
!GOLD_SWORD_Y = 339
!GT_BIG_KEY_X = 23
!GT_BIG_KEY_Y = 346
!CHEST_TURNS_X = 26
!CHEST_TURNS_Y = 349
!BONKS_X = 26
!BONKS_Y = 352
!SAVE_AND_QUITS_X = 26
!SAVE_AND_QUITS_Y = 355
!DEATHS_X = 26
!DEATHS_Y = 358
!FAERIE_REVIVALS_X = 26
!FAERIE_REVIVALS_Y = 361
!TOTAL_MENU_TIME_X = 19
!TOTAL_MENU_TIME_Y = 364
!TOTAL_LAG_TIME_X = 19
!TOTAL_LAG_TIME_Y = 367
!COLLECTION_RATE_X = 22
!COLLECTION_RATE_Y = 380
!TOTAL_TIME_X = 19
!TOTAL_TIME_Y = 383
