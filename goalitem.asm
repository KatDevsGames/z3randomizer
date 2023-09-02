GoalItemGanonCheck:
	LDA.w SpriteTypeTable, X : CMP.b #$D6 : BNE .success ; skip if not ganon
		JSL.l CheckGanonVulnerability
		BCS .success

		.fail
		LDA.w SpriteActivity, X : CMP.b #17 : !BLT .success ; decmial 17 because Acmlm's chart is decimal
		LDA.b #$00
RTL
		.success
		LDA.b OAMOffsetY : CMP.b #$80 ; thing we wrote over
RTL
;--------------------------------------------------------------------------------
;Carry clear = ganon invincible
;Carry set = ganon vulnerable
CheckGanonVulnerability:
	PHX
	LDA.l GanonVulnerableMode
	ASL
	TAX

	; Carry
	;  0 - invulnerable
	;  1 - vulnerable
	JSR (.goals, X)

	PLX
	RTL


.goals
	dw .vulnerable
	dw .invulnerable
	dw .all_dungeons
	dw .crystals_and_aga
	dw .crystals
	dw .goal_item
	dw .light_speed
	dw .crystals_and_bosses
	dw .bosses_only
	dw .all_dungeons_no_agahnim
	dw .all_items
	dw .completionist

; 00 = always vulnerable
.vulnerable
.success
	SEC
	RTS

; 01 = always invulnerable
.invulnerable
.fail
	CLC
	RTS

; 02 = All dungeons
.all_dungeons
	LDA.l ProgressIndicator : CMP.b #$03 : BCC .fail ; require post-aga world state

; 09 = All dungeons except agahnim
.all_dungeons_no_agahnim
	LDA.l PendantsField : AND.b #$07 : CMP.b #$07 : BNE .fail ; require all pendants
	LDA.l CrystalsField : AND.b #$7F : CMP.b #$7F : BNE .fail ; require all crystals
	LDA.l OverworldEventDataWRAM+$5B : AND.b #$20 : BEQ .fail ; require aga2 defeated (pyramid hole open)
	BRA .success

; 03 = crystals and aga 2
.crystals_and_aga
	LDA.l OverworldEventDataWRAM+$5B : AND.b #$20 : BEQ .fail ; check aga2 first then bleed in

; 04 = crystals only
.crystals
	JSL CheckEnoughCrystalsForGanon
	RTS

; 05 = require goal item
.goal_item
        REP #$20
	LDA.l GoalCounter : CMP.l GoalItemRequirement
        SEP #$20
	RTS

; 06 = light speed
.light_speed
	BRA .fail

; 07 = Crystals and bosses
.crystals_and_bosses
	JSL CheckEnoughCrystalsForGanon ; check crystals first then bleed in to next
	BCC .fail

; 08 = Crystal bosses but no crystals
.bosses_only
	JMP CheckForCrystalBossesDefeated

; 09 = 100% item collection rate
.all_items
        REP #$20
        LDA.l TotalItemCounter : CMP.l TotalItemCount
        SEP #$20
        RTS

; 0A = 100% item collection rate and all dungeons
.completionist
        REP #$20
        LDA.l TotalItemCounter : CMP.l TotalItemCount
        SEP #$20
        BCC .fail
        BRA .all_dungeons

;--------------------------------------------------------------------------------
GetRequiredCrystalsForTower:
	BEQ + : JSL.l BreakTowerSeal_ExecuteSparkles : + ; thing we wrote over
	LDA.l GanonsTowerOpenTarget : CMP.b #$00 : BNE + : JML.l Ancilla_BreakTowerSeal_stop_spawning_sparkles : +
	LDA.l GanonsTowerOpenTarget : CMP.b #$01 : BNE + : JML.l Ancilla_BreakTowerSeal_draw_single_crystal : +
	LDA.l GanonsTowerOpenTarget : DEC #2 : TAX
JML.l GetRequiredCrystalsForTower_continue
;--------------------------------------------------------------------------------
GetRequiredCrystalsInX:
	LDA.l GanonsTowerOpenTarget : CMP.b #$00 : BNE +
		TAX
		RTL
	+

	TXA

- 	CMP.l GanonsTowerOpenTarget : BCC +
	SBC.l GanonsTowerOpenTarget ; carry guaranteed set
	BRA -

	+ INC : CMP.l GanonsTowerOpenTarget : BNE +
		LDA.b #$08
	+ : DEC : TAX
RTL
;--------------------------------------------------------------------------------
CheckEnoughCrystalsForGanon:
        REP #$20
	LDA.l CrystalCounter
	CMP.l GanonVulnerableTarget
        SEP #$20
RTL
;--------------------------------------------------------------------------------
CheckTowerOpen:
        LDA.l GanonsTowerOpenMode : ASL : TAX
        JSR.w (.tower_open_modes,X)
RTL
        .tower_open_modes
        dw .vanilla
        dw .arbitrary_cmp

        .vanilla
        LDA.l CrystalsField
        AND.b #$7F : CMP.b #$7F
        RTS

        .arbitrary_cmp
        REP #$30
        LDA.l GanonsTowerOpenAddress : TAX
        LDA.l $7E0000,X
        CMP.l GanonsTowerOpenTarget
        SEP #$30
        RTS

;---------------------------------------------------------------------------------------------------
CheckAgaForPed:
        REP #$20
        LDA.l GanonVulnerableMode
        CMP.w #$0006 : BNE .vanilla

.light_speed
        SEP #$20
        LDA.l OverworldEventDataWRAM+$80 ; check ped flag
        AND.b #$40
        BEQ .force_blue_ball

.vanilla ; run vanilla check for phase
        SEP #$20
        LDA.w SpriteAux, X
        CMP.b #$02
        RTL

.force_blue_ball
        LDA.b #$01 : STA.w SpriteAuxTable, Y
        LDA.b #$20 : STA.w SpriteTimer, Y
        CLC ; skip the RNG check
        RTL

;---------------------------------------------------------------------------------------------------
CheckForCrystalBossesDefeated:
	PHB : PHX : PHY

	LDA.b #CrystalPendantFlags_2>>16
	PHA : PLB

	REP #$30

	; count of number of bosses killed
	STZ.b Scrap00

	LDY.w #10

.next_check
	LDA.w CrystalPendantFlags_2-2,Y
	BIT.w #$0040
	BEQ ++

	TYA
	ASL
	TAX

	LDA.l DrawHUDDungeonItems_boss_room_ids-4,X
	TAX
	LDA.l RoomDataWRAM.l,X

	AND.w #$0800
	BEQ ++

	INC.b Scrap00

++	DEY
	BPL .next_check

	SEP #$30
	PLY : PLX : PLB

	LDA.b Scrap00 : CMP.l GanonVulnerableTarget


	RTS
;---------------------------------------------------------------------------------------------------
CheckPedestalPull:
; Out: c - Successful ped pull if set, do nothing if unset.
        PHX
        LDA.l PedCheckMode : ASL : TAX
        JSR.w (.pedestal_modes,X)
        PLX
RTL

        .pedestal_modes
        dw .vanilla
        dw .arbitrary_cmp

        .vanilla
        LDA.l PendantsField
        AND.b #$07 : CMP.b #$07 : BNE ..nopull
                SEC
                RTS
        ..nopull
        CLC
        RTS

        .arbitrary_cmp
        REP #$30
        LDA.l PedPullAddress : TAX
        LDA.l $7E0000,X
        CMP.l PedPullTarget
        SEP #$30
        RTS
