YourSpriteCredits:
db 2
db 55
db "                            "

;===================================================================================================

CreditsLineTable:
	fillword CreditsLineBlank : fill 800

;===================================================================================================

!CLINE = -1

;---------------------------------------------------------------------------------------------------

macro smallcredits(space, text)
	!CLINE #= !CLINE+1
	table "creditscharmapsmall.txt"

	?line:
		db <space>
		db 2*(?end-?text)-1
	?text:
		db "<text>"
	?end:

	pushpc
	org CreditsLineTable+!CLINE+!CLINE : dw ?line
	pullpc

endmacro

;---------------------------------------------------------------------------------------------------

macro bigcredits(space, text)
	!CLINE #= !CLINE+1
	table "creditscharmapbighi.txt"

	?line_top:
		db <space>
		db 2*(?endA-?textA)-1
	?textA:
		db "<text>"
	?endA:

	pushpc
	org CreditsLineTable+!CLINE+!CLINE : dw ?line_top
	pullpc


	table "creditscharmapbiglo.txt"
	?line_bottom:
		db <space>
		db 2*(?endB-?textB)-1
	?textB:
		db "<text>"
	?endB:


	!CLINE #= !CLINE+1
	pushpc
	org CreditsLineTable+!CLINE+!CLINE : dw ?line_bottom
	pullpc

endmacro

;---------------------------------------------------------------------------------------------------

macro preline()
	!CLINE #= !CLINE+1
	pushpc
	org CreditsLineTable+!CLINE+!CLINE : dw CreditsPreLine
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

CreditsPreLine:
	db $00, $01, $9F

CreditsLineBlank:
	db $FF

;---------------------------------------------------------------------------------------------------

%preline()
%smallcredits(6, "ORIGINAL GAME STAFF")

%blankline()

%preline()
%smallcredits(7, "EXECUTIVE PRODUCER")

%blankline()

%bigcredits(8, "HIROSHI YAMAUCHI")

%blankline()
%blankline()

%preline()

%smallcredits(12, "PRODUCER")

%blankline()

%bigcredits(8, "SHIGERU MIYAMOTO")

%blankline()
%blankline()

%smallcredits(12, "DIRECTOR")

%blankline()

%bigcredits(9, "TAKASHI TEZUKA")

%blankline()
%blankline()

%smallcredits(9, "SCRIPT WRITER")

%blankline()

%bigcredits(9, "KENSUKE TANABE")

%blankline()
%blankline()

%preline()
%smallcredits(6, "ASSISTANT DIRECTORS")

%blankline()
%blankline()

%bigcredits(7, "YASUHISA YAMAMURA")

%blankline()

%bigcredits(9, "YOICHI YAMADA")

%blankline()
%blankline()

%smallcredits(3, "SCREEN GRAPHICS DESIGNERS")


%preline()
%preline()
%smallcredits(8, "OBJECT DESIGNERS")

%blankline()

%bigcredits(8, "SOICHIRO TOMITA")

%blankline()

%bigcredits(9, "TAKAYA IMAMURA")

%blankline()
%blankline()

%preline()
%smallcredits(5, "BACK GROUND DESIGNERS")

%blankline()
%blankline()

%bigcredits(8, "MASANAO ARIMOTO")

%blankline()

%bigcredits(7, "TSUYOSHI WATANABE")

%blankline()
%blankline()

%smallcredits(8, "PROGRAM DIRECTOR")

%blankline()

%bigcredits(8, "TOSHIHIKO NAKAGO")

%blankline()
%blankline()

%smallcredits(8, "MAIN PROGRAMMER")

%blankline()

%bigcredits(8, "YASUNARI SOEJIMA")

%blankline()
%blankline()

%smallcredits(7, "OBJECT PROGRAMMER")

%blankline()

%bigcredits(9, "KAZUAKI MORITA")

%blankline()
%blankline()

%preline()

%smallcredits(10, "PROGRAMMERS")

%blankline()

%bigcredits(8, "TATSUO NISHIYAMA")

%blankline()

%bigcredits(8, "YUICHI YAMAMOTO")

%blankline()

%bigcredits(8, "YOSHIHIRO NOMOTO")

%blankline()

%bigcredits(11, "EIJI NOTO")

%blankline()

%bigcredits(8, "SATORU TAKAHATA")

%blankline()

%bigcredits(9, "TOSHIO IWAWAKI")

%blankline()

%bigcredits(6, "SHIGEHIRO KASAMATSU")

%blankline()

%bigcredits(8, "YASUNARI NISHIDA")

%blankline()
%blankline()

%smallcredits(9, "SOUND COMPOSER")

%blankline()

%bigcredits(11, "KOJI KONDO")

%blankline()
%blankline()

%smallcredits(10, "COORDINATORS")

%blankline()

%bigcredits(11, "KEIZO KATO")

%blankline()

%bigcredits(9, "TAKAO SHIMIZU")

%blankline()
%blankline()

%preline()
%smallcredits(8, "PRINTED ART WORK")

%blankline()

%bigcredits(9, "YOICHI KOTABE")

%blankline()

%bigcredits(10, "HIDEKI FUJII")

%blankline()

%bigcredits(8, "YOSHIAKI KOIZUMI")

%blankline()

%bigcredits(9, "YASUHIRO SAKAI")

%blankline()

%bigcredits(8, "TOMOAKI KUROUME")

%blankline()
%blankline()

%smallcredits(7, "SPECIAL THANKS TO")

%blankline()

%bigcredits(9, "NOBUO OKAJIMA")

%blankline()

%bigcredits(7, "YASUNORI TAKETANI")

%blankline()

%bigcredits(10, "KIYOSHI KODA")

%blankline()

%bigcredits(7, "TAKAMITSU KUZUHARA")

%blankline()

%bigcredits(9, "HIRONOBU KAKUI")

%blankline()

%bigcredits(7, "SHIGEKI YAMASHIRO")

%blankline()

%preline()
%preline()
%preline()
%preline()
%preline()

%smallcredits(4, "RANDOMIZER CONTRIBUTORS")

%blankline()
%blankline()

%preline()
%preline()
%smallcredits(8, "ITEM RANDOMIZER")

%blankline()

%bigcredits(2, "KATDEVSGAMES         VEETORP")

%blankline()

%bigcredits(2, "CHRISTOSOWEN       DESSYREQT")

%blankline()

%bigcredits(2, "SMALLHACKER           SYNACK")

%blankline()
%blankline()

%smallcredits(6, "ENTRANCE RANDOMIZER")

%blankline()

%bigcredits(2, "AMAZINGAMPHAROS   LLCOOLDAVE")

%blankline()

%bigcredits(9, "KEVINCATHCART")

%blankline()
%blankline()

%preline()
%smallcredits(8, "ENEMY RANDOMIZER")

%blankline()

%bigcredits(2, "ZARBY89              SOSUKE3")

%blankline()

%bigcredits(10, "ENDEROFGAMES")

%blankline()
%blankline()

%smallcredits(8, "DOOR RANDOMIZER")

%blankline()

%bigcredits(2, "AERINON             COMPILING")

%blankline()
%blankline()

%smallcredits(6, "FESTIVE RANDOMIZER")

%blankline()

%bigcredits(2, "KAN                    TOTAL")

%blankline()

%bigcredits(2, "CATOBAT            DINSAPHIR")

%blankline()
%blankline()

%smallcredits(7, "SPRITE DEVELOPMENT")

%blankline()
%blankline()

%bigcredits(2, "MIKETRETHEWEY         IBAZLY")

%blankline()
%bigcredits(2, "FISH_WAFFLE64        KRELBEL")

%blankline()

%bigcredits(2, "TWROXAS              ARTHEAU")

%blankline()

%bigcredits(2, "GLAN               TARTHORON")

%blankline()

%smallcredits(9, "YOUR SPRITE BY")

%addarbline(YourSpriteCredits)

%blankline()
%blankline()

%smallcredits(10, "MSU1 SUPPORT")

%blankline()

%bigcredits(2, "QWERTYMODO")

%blankline()
%blankline()

%smallcredits(7, "PALETTE SHUFFLER")

%blankline()

%bigcredits(9, "NELSON AKA SWR")

%blankline()
%blankline()

%smallcredits(9, "SPECIAL THANKS")

%blankline()
%blankline()

%bigcredits(2, "SUPERSKUJ          EVILASH25")

%blankline()

%bigcredits(2, "MYRAMONG             JOSHRTA")

%blankline()

%bigcredits(2, "WALKINGEYE     MATHONNAPKINS")

%blankline()

%bigcredits(9, "SAKURATSUBASA")

%blankline()

%bigcredits(13, "AND...")

%blankline()

%bigcredits(1, "THE ALTTP RANDOMIZER COMMUNITY")

%blankline()
%blankline()

%smallcredits(7, "COMMUNITY DISCORD")

%blankline()
%blankline()

%bigcredits(3, "HTTPS://ALTTPR.COM/DISCORD")

%blankline()

%preline()
%preline()
%preline()
%preline()
%preline()
%preline()
%preline()
%preline()
%preline()
%preline()
%preline()
%preline()
%preline()
%preline()
%preline()
%preline()
%preline()
%preline()
%preline()
%preline()
%preline()
%preline()
%preline()
%preline()
%preline()

;===================================================================================================

print "Line number: !CLINE | Expected: 302"

;===================================================================================================

%smallcredits(6, "THE IMPORTANT STUFF")

%blankline()
%blankline()

%preline()
%smallcredits(11, "TIME FOUND")

%blankline()
%blankline()

%bigcredits(2, "FIRST SWORD")

%blankline()

%bigcredits(2, "PEGASUS BOOTS")

%blankline()

%bigcredits(2, "FLUTE")

%blankline()

%bigcredits(2, "MIRROR")

%blankline()
%blankline()

%preline()
%smallcredits(11, "BOSS KILLS")

%blankline()
%blankline()

%bigcredits(2, "SWORDLESS                /13")

%blankline()

%bigcredits(2, "FIGHTER'S SWORD          /13")

%blankline()

%bigcredits(2, "MASTER SWORD             /13")

%blankline()

%bigcredits(2, "TEMPERED SWORD           /13")

%blankline()

%bigcredits(2, "GOLD SWORD               /13")

%blankline()
%blankline()

%smallcredits(11, "GAME STATS")

%blankline()
%blankline()

%bigcredits(2, "GT BIG KEY               /22")

%blankline()

%bigcredits(2, "BONKS")

%blankline()

%bigcredits(2, "SAVE AND QUITS")

%blankline()

%bigcredits(2, "DEATHS")

%blankline()

%bigcredits(2, "FAERIE REVIVALS")

%blankline()

%bigcredits(2, "TOTAL MENU TIME")

%blankline()

%bigcredits(2, "TOTAL LAG TIME")

%blankline()
%blankline()


%blankline()
%blankline()


%blankline()
%blankline()


%blankline()
%blankline()


%blankline()

%preline()
%preline()
%preline()
%preline()
%preline()
%bigcredits(2, "COLLECTION RATE         /216")

%blankline()

%bigcredits(2, "TOTAL TIME")

%blankline()

%preline()
%preline()
%preline()
%preline()
%preline()
%preline()

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
!BONKS_X = 26
!BONKS_Y = 349
!SAVE_AND_QUITS_X = 26
!SAVE_AND_QUITS_Y = 352
!DEATHS_X = 26
!DEATHS_Y = 355
!FAERIE_REVIVALS_X = 26
!FAERIE_REVIVALS_Y = 358
!TOTAL_MENU_TIME_X = 19
!TOTAL_MENU_TIME_Y = 361
!TOTAL_LAG_TIME_X = 19
!TOTAL_LAG_TIME_Y = 364
!COLLECTION_RATE_X = 22
!COLLECTION_RATE_Y = 380
!TOTAL_TIME_X = 19
!TOTAL_TIME_Y = 383