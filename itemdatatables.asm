;------------------------------------------------------------------------------
; Item Data Tables
;------------------------------------------------------------------------------
; This module contains several statically mapped tables related to items, item
; receipts, and item graphics. There are 256 item receipt indexes and the tables are
; written column-major, meaning each "column" property of every table entry is
; written adjacent to each other (e.g., ItemReceipts_offset_y is one byte per item.
; All 256 bytes for each item are written in receipt ID order, then 256 bytes are
; written for ItemReceipts_offset_x, etc.) The addresses and description of each
; table and column are described immediately below. The tables themselves are below
; the documentation.
;
; The tables and documentation here should provide the knowledge and capability
; to add an item into an unclaimed receipt ID or replace some existing items, although
; you should prefer to use unclaimed space or reuse randomizer item slots as some
; vanilla behavior is still hard-coded.
;
; Some of the entries in these tables are word-length vectors, or pointers to
; code the randomizer ROM runs on item pickup or resolution (e.g., resolving a
; progressive sword that's a standing item.) We provide all our own routines plus
; some for "skipping" these steps when not necessary. If you want an item to potentially
; resolve to a different one, or to run some custom code on pickup, you will have to use
; ItemSubstitutionRules in tables.asm or claim some free space in this bank to put your
; own code with vectors to it in the appropriate tables.
;------------------------------------------------------------------------------

;------------------------------------------------------------------------------
; ItemReceiptGraphicsROM - $A28000 (0x110000 PC)
;------------------------------------------------------------------------------
; Where the custom uncompressed 4bpp item graphics are stored. See customitems.4bpp
; and customitems.png for reference. Offsets into this label should written to
; ItemReceiptGraphicsOffsets & StandingItemGraphicsOffsets without the high byte
; (0x8000) set.
;
; We can understand this buffer as being divided into an 8x8 grid with most sprites
; occupying a 16x16 space and narrow sprites occupying an 8x16 space. The first 16x16
; item tile is a blank one-color sprite, the second 16x16 is the triforce piece,
; and the third is the fighter sword sprite. 
;
; Every 8x8 4bpp tile from left to right is offset by 0x20. From top to bottom
; the offset is 0x200. This means that each "row" of 8x8 tiles should be written
; contiguously, but to write the next tile(s) below the base upper-left address
; should be incremented by 0x200.
;------------------------------------------------------------------------------

;------------------------------------------------------------------------------
; ItemReceipts
;------------------------------------------------------------------------------
; .offset_y   [0x01] - $A2B000 (0x113000 PC)
;             • Sprite Y offset from default position
; .offset_x   [0x01] - $A2B100 (0x113100 PC)
;             • Sprite X offset from default position
; .graphics   [0x01] - $A2B200 (0x113200 PC)
;             • Sprite index for compressed graphics
; .target     [0x02] - $A2B300 (0x113300 PC)
;             • Target address in save buffer in bank $7E
; .value      [0x01] - $A2B500 (0x113500 PC)
;             • Value written to target address
; .behavior   [0x02] - $A2B600 (0x113600 PC)
;             • Vector to code in this bank that runs on item pickup
; .resolution [0x02] - $A2B600 (0x113600 PC)
;             • Vector to code in this bank that can resolve to new item (e.g. for progressive items)
;------------------------------------------------------------------------------

;------------------------------------------------------------------------------
; SpriteProperties
;------------------------------------------------------------------------------
; For the most part item sprites are identical in all contexts, but some
; sprites have two graphics, chest/npc graphics and standing item graphics.
;------------------------------------------------------------------------------
; .chest_width      [0x01] - $A2BA00 (0x11CA00 PC)
; .standing_width   [0x01] - $A2BB00 (0x11CB00 PC)
;                   • $00 = 8x16 sprite | $02 = 16x16 sprite
; .chest_palette    [0x01] - $A2BC00 (0x11CC00 PC)
; .standing_palette [0x01] - $A2BD00 (0x11CD00 PC)
;                   • l - - - - c c c
;                   c = palette index | l = load palette from .palette_addr
; .palette_addr     [0x02] - $A2BE00 (0x11CE00 PC)
;                   • Pointer to 8-color palette in bank $9B (see custompalettes.asm)
;                   • If an item has two sprites, this should be the chest sprite for
;                     dark rooms.
;------------------------------------------------------------------------------

;------------------------------------------------------------------------------
; InventoryTable
;------------------------------------------------------------------------------
; .properties [0x01] - $A2C000 (0x114000 PC)
;             • - - - - - - - -  p k w o a y s t
;             t = Count for total item counter | s = Count for total in shops
;             y = Y item                       | a = A item
;             o = Bomb item                    | w = Bow item
;             k = Chest Key                    | p = Crystal prize behavior (sparkle, etc) if set
; .stamp      [0x02] - $A2C200 (0x114200 PC)
;             • Pointer to address in bank $7E. Stamps 32-bit frame time if stats not locked.
; .stat       [0x02] - $A2C400 (0x114400 PC)
;             • Pointer to address in bank $7E. Increments byte by one if stats not locked.
;------------------------------------------------------------------------------

;------------------------------------------------------------------------------
; ItemReceiptGraphicsOffsets - $22C600 (0x114600)
; StandingItemGraphicsOffsets - $22C800 (0x114800)
;------------------------------------------------------------------------------
; Each receipt ID has one word-length entry. Decompressed vanilla item graphics
; are located starting at BigDecompressionBuffer. The graphics routines use the
; fact that the high bit is set for these in this table to know to load from the
; buffer. Custom graphics are offset from ItemReceiptGraphicsRom, allocated in
; LTTP_RND_GeneralBugfixes.asm and written to with decompressed customitems.4bpp
; (see customitems.png for reference.)
;
; ItemReceiptGraphicsOffsets is used for chest items and items link holds up while
; in an item receipt post. StandingItemGraphicsOffsets is for standing items in
; heart piece, heart container, and shop locations.
;------------------------------------------------------------------------------

ItemReceipts:
	.offset_y     : fillbyte $00   : fill 256
	.offset_x     : fillbyte $00   : fill 256
	.graphics     : fillbyte $00   : fill 256   ; item_graphics_indices
	.target       : fillword $0000 : fill 256*2 ; item_target_addr
	.value        : fillbyte $00   : fill 256   ; item_values
	.behavior     : fillword $0000 : fill 256*2 ; ItemBehavior
	.resolution   : fillword $0000 : fill 256*2 ; ReceiptResolution


macro ReceiptProps(id, y, x, gfx, sram, value, behavior, res)
	pushpc

	org ItemReceipts_offset_y+<id>        : db <y>
	org ItemReceipts_offset_x+<id>        : db <x>
	org ItemReceipts_graphics+<id>        : db <gfx>
	org ItemReceipts_target+<id>+<id>     : dw <sram>
	org ItemReceipts_value+<id>           : db <value>
	org ItemReceipts_behavior+<id>+<id>   : dw ItemBehavior_<behavior>
	org ItemReceipts_resolution+<id>+<id> : dw ResolveLootID_<res>

	pullpc
endmacro

%ReceiptProps($00, -5, 0, $06, $F359, $01, sword_shield, skip) ; 00 - Fighter sword & Shield
%ReceiptProps($01, -5, 4, $18, $F359, $02, master_sword, skip) ; 01 - Master sword
%ReceiptProps($02, -5, 4, $18, $F359, $03, tempered_sword, skip) ; 02 - Tempered sword
%ReceiptProps($03, -5, 4, $18, $F359, $04, gold_sword, skip) ; 03 - Golden sword
%ReceiptProps($04, -5, 4, $2D, $F35A, $01, fighter_shield, skip) ; 04 - Fighter shield
%ReceiptProps($05, -4, 0, $20, $F35A, $02, red_shield, skip) ; 05 - Fire shield
%ReceiptProps($06, -4, 0, $2E, $F35A, $03, mirror_shield, skip) ; 06 - Mirror shield
%ReceiptProps($07, -5, 4, $09, $F345, $01, skip, skip) ; 07 - Fire rod
%ReceiptProps($08, -5, 4, $09, $F346, $01, skip, skip) ; 08 - Ice rod
%ReceiptProps($09, -4, 4, $0A, $F34B, $01, skip, skip) ; 09 - Hammer
%ReceiptProps($0A, -4, 4, $08, $F342, $01, skip, skip) ; 0A - Hookshot
%ReceiptProps($0B, -4, 4, $05, $F340, $01, bow, skip) ; 0B - Bow
%ReceiptProps($0C, -2, 5, $10, $F341, $01, blue_boomerang, skip) ; 0C - Blue Boomerang
%ReceiptProps($0D, -4, 0, $0B, $F344, $02, powder, skip) ; 0D - Powder
%ReceiptProps($0E, -4, 0, $2C, $F35C, $FF, skip, skip) ; 0E - Bottle refill (bee)
%ReceiptProps($0F, -4, 0, $1B, $F347, $01, skip, skip) ; 0F - Bombos
%ReceiptProps($10, -4, 0, $1A, $F348, $01, skip, skip) ; 10 - Ether
%ReceiptProps($11, -4, 0, $1C, $F349, $01, skip, skip) ; 11 - Quake
%ReceiptProps($12, -4, 0, $14, $F34A, $01, skip, skip) ; 12 - Lamp
%ReceiptProps($13, -4, 4, $19, $F34C, $01, shovel, skip) ; 13 - Shovel
%ReceiptProps($14, -4, 0, $0C, $F34C, $02, flute_inactive, skip) ; 14 - Flute
%ReceiptProps($15, -4, 4, $07, $F350, $01, skip, skip) ; 15 - Somaria
%ReceiptProps($16, -4, 0, $1D, $F35C, $FF, skip, bottles) ; 16 - Bottle
%ReceiptProps($17, -4, 0, $2F, $F36B, $FF, skip, skip) ; 17 - Heart piece
%ReceiptProps($18, -4, 4, $07, $F351, $01, skip, skip) ; 18 - Byrna
%ReceiptProps($19, -4, 0, $15, $F352, $01, skip, skip) ; 19 - Cape
%ReceiptProps($1A, -4, 0, $12, $F353, $02, skip, skip) ; 1A - Mirror
%ReceiptProps($1B, -4, 0, $0D, $F354, $01, skip, skip) ; 1B - Glove
%ReceiptProps($1C, -4, 0, $0D, $F354, $02, skip, skip) ; 1C - Mitts
%ReceiptProps($1D, -4, 0, $0E, $F34E, $01, skip, skip) ; 1D - Book
%ReceiptProps($1E, -4, 0, $11, $F356, $01, skip, skip) ; 1E - Flippers
%ReceiptProps($1F, -4, 0, $17, $F357, $01, skip, skip) ; 1F - Pearl
%ReceiptProps($20, -4, 0, $28, $F37A, $FF, dungeon_crystal, skip) ; 20 - Crystal
%ReceiptProps($21, -4, 0, $27, $F34D, $01, skip, skip) ; 21 - Net
%ReceiptProps($22, -4, 0, $04, $F35B, $FF, blue_mail, skip) ; 22 - Blue mail
%ReceiptProps($23, -5, 0, $04, $F35B, $02, red_mail, skip) ; 23 - Red mail
%ReceiptProps($24, -4, 4, $0F, $F36F, $FF, skip, skip) ; 24 - Small key
%ReceiptProps($25, -4, 0, $16, $F364, $FF, dungeon_compass, skip) ; 25 - Compass
%ReceiptProps($26, -4, 0, $03, $F36C, $FF, skip, skip) ; 26 - Heart container from 4/4
%ReceiptProps($27, -4, 0, $13, $F375, $FF, skip, skip) ; 27 - Bomb
%ReceiptProps($28, -4, 0, $01, $F375, $FF, skip, skip) ; 28 - 3 bombs
%ReceiptProps($29, -4, 0, $1F, $F344, $FF, mushroom, skip) ; 29 - Mushroom
%ReceiptProps($2A, -2, 5, $10, $F341, $02, red_boomerang, skip) ; 2A - Red boomerang
%ReceiptProps($2B, -4, 0, $1E, $F35C, $FF, skip, bottles) ; 2B - Full bottle (red)
%ReceiptProps($2C, -4, 0, $1E, $F35C, $FF, skip, bottles) ; 2C - Full bottle (green)
%ReceiptProps($2D, -4, 0, $1E, $F35C, $FF, skip, bottles) ; 2D - Full bottle (blue)
%ReceiptProps($2E, -4, 0, $1E, $F36D, $FF, skip, skip) ; 2E - Potion refill (red)
%ReceiptProps($2F, -4, 0, $1E, $F36E, $FF, skip, skip) ; 2F - Potion refill (green)
%ReceiptProps($30, -4, 0, $1E, $F36E, $FF, skip, skip) ; 30 - Potion refill (blue)
%ReceiptProps($31, -4, 0, $30, $F375, $FF, skip, skip) ; 31 - 10 bombs
%ReceiptProps($32, -4, 0, $22, $F366, $FF, dungeon_bigkey, skip) ; 32 - Big key
%ReceiptProps($33, -4, 0, $21, $F368, $FF, dungeon_map, skip) ; 33 - Map
%ReceiptProps($34, -2, 4, $24, $F360, $FF, skip, skip) ; 34 - 1 rupee
%ReceiptProps($35, -2, 4, $24, $F360, $FF, skip, skip) ; 35 - 5 rupees
%ReceiptProps($36, -2, 4, $24, $F360, $EC, skip, skip) ; 36 - 20 rupees
%ReceiptProps($37, -4, 0, $23, $F374, $FF, pendant, skip) ; 37 - Green pendant
%ReceiptProps($38, -4, 0, $39, $F374, $FF, pendant, skip) ; 38 - Red pendant
%ReceiptProps($39, -4, 0, $39, $F374, $FF, pendant, skip) ; 39 - Blue pendant
%ReceiptProps($3A, -4, 0, $29, $F340, $01, bow_and_arrows, skip) ; 3A - Bow And Arrows
%ReceiptProps($3B, -4, 0, $2A, $F340, $03, silver_bow, skip) ; 3B - Silver Bow
%ReceiptProps($3C, -4, 0, $2C, $F35C, $FF, skip, skip) ; 3C - Full bottle (bee)
%ReceiptProps($3D, -4, 0, $2B, $F35C, $FF, skip, skip) ; 3D - Full bottle (fairy)
%ReceiptProps($3E, -4, 0, $03, $F36C, $FF, skip, skip) ; 3E - Boss heart
%ReceiptProps($3F, -4, 0, $03, $F36C, $FF, skip, skip) ; 3F - Sanc heart
%ReceiptProps($40, -4, 0, $34, $F360, $9C, skip, skip) ; 40 - 100 rupees
%ReceiptProps($41, -4, 0, $35, $F360, $CE, skip, skip) ; 41 - 50 rupees
%ReceiptProps($42, -2, 4, $31, $F372, $FF, skip, skip) ; 42 - Heart
%ReceiptProps($43, -2, 4, $33, $F376, $01, single_arrow, skip) ; 43 - Arrow
%ReceiptProps($44, -4, 0, $02, $F376, $0A, skip, skip) ; 44 - 10 arrows
%ReceiptProps($45, -2, 4, $32, $F373, $FF, skip, skip) ; 45 - Small magic
%ReceiptProps($46, -4, 0, $36, $F360, $FF, skip, skip) ; 46 - 300 rupees
%ReceiptProps($47, -4, 0, $37, $F360, $FF, skip, skip) ; 47 - 20 rupees green
%ReceiptProps($48, -4, 0, $2C, $F35C, $FF, skip, skip) ; 48 - Full bottle (good bee)
%ReceiptProps($49, -5, 4, $06, $F359, $01, fighter_sword, skip) ; 49 - Tossed fighter sword
%ReceiptProps($4A, -4, 0, $0C, $F34C, $03, flute_active, skip) ; 4A - Active Flute
%ReceiptProps($4B, -4, 0, $38, $F355, $01, skip, skip) ; 4B - Boots
%ReceiptProps($4C, -4, 0, $39, $F375, $32, bombs_50, skip) ; 4C - Bomb capacity (50)
%ReceiptProps($4D, -4, 0, $3A, $F376, $46, arrows_70, skip) ; 4D - Arrow capacity (70)
%ReceiptProps($4E, -4, 0, $3B, $F373, $80, magic_2, magic) ; 4E - 1/2 magic
%ReceiptProps($4F, -4, 0, $3C, $F373, $80, magic_4, skip) ; 4F - 1/4 magic
%ReceiptProps($50, -5, 4, $18, $F359, $02, master_sword_safe, skip) ; 50 - Safe master sword
%ReceiptProps($51, -4, 0, $42, $F375, $FF, bombs_5, skip) ; 51 - Bomb capacity (+5)
%ReceiptProps($52, -4, 0, $3E, $F375, $FF, bombs_10, skip) ; 52 - Bomb capacity (+10)
%ReceiptProps($53, -4, 0, $3F, $F376, $FF, arrows_5, skip) ; 53 - Arrow capacity (+5)
%ReceiptProps($54, -4, 0, $40, $F376, $FF, arrows_10, skip) ; 54 - Arrow capacity (+10)
%ReceiptProps($55, -4, 0, $00, $F41A, $FF, programmable_1, skip) ; 55 - Programmable item 1
%ReceiptProps($56, -4, 0, $00, $F41C, $FF, programmable_2, skip) ; 56 - Programmable item 2
%ReceiptProps($57, -4, 0, $00, $F41E, $FF, programmable_3, skip) ; 57 - Programmable item 3
%ReceiptProps($58, -4, 0, $41, $F340, $FF, silver_arrows, skip) ; 58 - Upgrade-only Silver Arrows
%ReceiptProps($59, -4, 4, $24, $F360, $FF, rupoor, skip) ; 59 - Rupoor
%ReceiptProps($5A, -4, 0, $47, $F36A, $FF, skip, skip) ; 5A - Nothing
%ReceiptProps($5B, -4, 0, $4B, $F454, $FF, red_clock, skip) ; 5B - Red clock
%ReceiptProps($5C, -4, 0, $4B, $F454, $FF, blue_clock, skip) ; 5C - Blue clock
%ReceiptProps($5D, -4, 0, $4B, $F454, $FF, green_clock, skip) ; 5D - Green clock
%ReceiptProps($5E, -4, 0, $FE, $F359, $FF, prog_sword, prog_sword) ; 5E - Progressive sword
%ReceiptProps($5F, -4, 0, $FF, $F35A, $FF, prog_shield, shields) ; 5F - Progressive shield
%ReceiptProps($60, -4, 0, $FD, $F35B, $FF, prog_mail, armor) ; 60 - Progressive armor
%ReceiptProps($61, -4, 0, $0D, $F354, $FF, skip, gloves) ; 61 - Progressive glove
%ReceiptProps($62, -4, 0, $FF, $F36A, $FF, skip, rng_single) ; 62 - RNG pool item (single)
%ReceiptProps($63, -4, 0, $FF, $F36A, $FF, skip, rng_multi) ; 63 - RNG pool item (multi)
%ReceiptProps($64, -4, 0, $FF, $F340, $FF, skip, progressive_bow) ; 64 - Progressive bow
%ReceiptProps($65, -4, 0, $FF, $F340, $FF, skip, progressive_bow_2) ; 65 - Progressive bow
%ReceiptProps($66, -4, 0, $FF, $F36A, $FF, skip, skip) ; 66 - 
%ReceiptProps($67, -4, 0, $FF, $F36A, $FF, skip, skip) ; 67 - 
%ReceiptProps($68, -4, 0, $FF, $F36A, $FF, skip, skip) ; 68 - 
%ReceiptProps($69, -4, 0, $FF, $F36A, $FF, skip, skip) ; 69 - 
%ReceiptProps($6A, -4, 0, $49, $F36A, $FF, triforce, skip) ; 6A - Triforce
%ReceiptProps($6B, -4, 0, $50, $F36A, $FF, goal_item, skip) ; 6B - Power star
%ReceiptProps($6C, -4, 0, $49, $F36A, $FF, goal_item, skip) ; 6C - Triforce Piece
%ReceiptProps($6D, -4, 0, $FF, $F36A, $FF, request_F0, skip) ; 6D - Server request item
%ReceiptProps($6E, -4, 0, $FF, $F36A, $FF, request_F1, skip) ; 6E - Server request item (dungeon drop)
%ReceiptProps($6F, -4, 0, $FF, $F36A, $FF, request_F2, skip) ; 6F - 
%ReceiptProps($70, -4, 0, $21, $F36A, $FF, free_map, skip) ; 70 - Map of Light World
%ReceiptProps($71, -4, 0, $21, $F36A, $FF, free_map, skip) ; 71 - Map of Dark World
%ReceiptProps($72, -4, 0, $21, $F36A, $FF, free_map, skip) ; 72 - Map of Ganon's Tower
%ReceiptProps($73, -4, 0, $21, $F36A, $FF, free_map, skip) ; 73 - Map of Turtle Rock
%ReceiptProps($74, -4, 0, $21, $F36A, $FF, free_map, skip) ; 74 - Map of Thieves' Town
%ReceiptProps($75, -4, 0, $21, $F36A, $FF, free_map, skip) ; 75 - Map of Tower of Hera
%ReceiptProps($76, -4, 0, $21, $F36A, $FF, free_map, skip) ; 76 - Map of Ice Palace
%ReceiptProps($77, -4, 0, $21, $F36A, $FF, free_map, skip) ; 77 - Map of Skull Woods
%ReceiptProps($78, -4, 0, $21, $F36A, $FF, free_map, skip) ; 78 - Map of Misery Mire
%ReceiptProps($79, -4, 0, $21, $F36A, $FF, free_map, skip) ; 79 - Map of Dark Palace
%ReceiptProps($7A, -4, 0, $21, $F36A, $FF, free_map, skip) ; 7A - Map of Swamp Palace
%ReceiptProps($7B, -4, 0, $21, $F36A, $FF, free_map, skip) ; 7B - Map of Agahnim's Tower
%ReceiptProps($7C, -4, 0, $21, $F36A, $FF, free_map, skip) ; 7C - Map of Desert Palace
%ReceiptProps($7D, -4, 0, $21, $F36A, $FF, free_map, skip) ; 7D - Map of Eastern Palace
%ReceiptProps($7E, -4, 0, $21, $F36A, $FF, hc_map, skip) ; 7E - Map of Hyrule Castle
%ReceiptProps($7F, -4, 0, $21, $F36A, $FF, hc_map, skip) ; 7F - Map of Sewers
%ReceiptProps($80, -4, 0, $16, $F36A, $FF, free_compass, skip) ; 80 - Compass of Light World
%ReceiptProps($81, -4, 0, $16, $F36A, $FF, free_compass, skip) ; 81 - Compass of Dark World
%ReceiptProps($82, -4, 0, $16, $F36A, $FF, free_compass, skip) ; 82 - Compass of Ganon's Tower
%ReceiptProps($83, -4, 0, $16, $F36A, $FF, free_compass, skip) ; 83 - Compass of Turtle Rock
%ReceiptProps($84, -4, 0, $16, $F36A, $FF, free_compass, skip) ; 84 - Compass of Thieves' Town
%ReceiptProps($85, -4, 0, $16, $F36A, $FF, free_compass, skip) ; 85 - Compass of Tower of Hera
%ReceiptProps($86, -4, 0, $16, $F36A, $FF, free_compass, skip) ; 86 - Compass of Ice Palace
%ReceiptProps($87, -4, 0, $16, $F36A, $FF, free_compass, skip) ; 87 - Compass of Skull Woods
%ReceiptProps($88, -4, 0, $16, $F36A, $FF, free_compass, skip) ; 88 - Compass of Misery Mire
%ReceiptProps($89, -4, 0, $16, $F36A, $FF, free_compass, skip) ; 89 - Compass of Dark Palace
%ReceiptProps($8A, -4, 0, $16, $F36A, $FF, free_compass, skip) ; 8A - Compass of Swamp Palace
%ReceiptProps($8B, -4, 0, $16, $F36A, $FF, free_compass, skip) ; 8B - Compass of Agahnim's Tower
%ReceiptProps($8C, -4, 0, $16, $F36A, $FF, free_compass, skip) ; 8C - Compass of Desert Palace
%ReceiptProps($8D, -4, 0, $16, $F36A, $FF, free_compass, skip) ; 8D - Compass of Eastern Palace
%ReceiptProps($8E, -4, 0, $16, $F36A, $FF, hc_compass, skip) ; 8E - Compass of Hyrule Castle
%ReceiptProps($8F, -4, 0, $16, $F36A, $FF, hc_compass, skip) ; 8F - Compass of Sewers
%ReceiptProps($90, -4, 0, $22, $F36A, $FF, skip, skip) ; 90 - Skull key
%ReceiptProps($91, -4, 0, $22, $F36A, $FF, skip, skip) ; 91 - Reserved
%ReceiptProps($92, -4, 0, $22, $F36A, $FF, free_bigkey, skip) ; 92 - Big key of Ganon's Tower
%ReceiptProps($93, -4, 0, $22, $F36A, $FF, free_bigkey, skip) ; 93 - Big key of Turtle Rock
%ReceiptProps($94, -4, 0, $22, $F36A, $FF, free_bigkey, skip) ; 94 - Big key of Thieves' Town
%ReceiptProps($95, -4, 0, $22, $F36A, $FF, free_bigkey, skip) ; 95 - Big key of Tower of Hera
%ReceiptProps($96, -4, 0, $22, $F36A, $FF, free_bigkey, skip) ; 96 - Big key of Ice Palace
%ReceiptProps($97, -4, 0, $22, $F36A, $FF, free_bigkey, skip) ; 97 - Big key of Skull Woods
%ReceiptProps($98, -4, 0, $22, $F36A, $FF, free_bigkey, skip) ; 98 - Big key of Misery Mire
%ReceiptProps($99, -4, 0, $22, $F36A, $FF, free_bigkey, skip) ; 99 - Big key of Dark Palace
%ReceiptProps($9A, -4, 0, $22, $F36A, $FF, free_bigkey, skip) ; 9A - Big key of Swamp Palace
%ReceiptProps($9B, -4, 0, $22, $F36A, $FF, free_bigkey, skip) ; 9B - Big key of Agahnim's Tower
%ReceiptProps($9C, -4, 0, $22, $F36A, $FF, free_bigkey, skip) ; 9C - Big key of Desert Palace
%ReceiptProps($9D, -4, 0, $22, $F36A, $FF, free_bigkey, skip) ; 9D - Big key of Eastern Palace
%ReceiptProps($9E, -4, 0, $22, $F36A, $FF, hc_bigkey, skip) ; 9E - Big key of Hyrule Castle
%ReceiptProps($9F, -4, 0, $22, $F36A, $FF, hc_bigkey, skip) ; 9F - Big key of Sewers
%ReceiptProps($A0, -4, 4, $0F, $F36A, $FF, hc_smallkey, skip) ; A0 - Small key of Sewers
%ReceiptProps($A1, -4, 4, $0F, $F36A, $FF, hc_smallkey, skip) ; A1 - Small key of Hyrule Castle
%ReceiptProps($A2, -4, 4, $0F, $F36A, $FF, free_smallkey, skip) ; A2 - Small key of Eastern Palace
%ReceiptProps($A3, -4, 4, $0F, $F36A, $FF, free_smallkey, skip) ; A3 - Small key of Desert Palace
%ReceiptProps($A4, -4, 4, $0F, $F36A, $FF, free_smallkey, skip) ; A4 - Small key of Agahnim's Tower
%ReceiptProps($A5, -4, 4, $0F, $F36A, $FF, free_smallkey, skip) ; A5 - Small key of Swamp Palace
%ReceiptProps($A6, -4, 4, $0F, $F36A, $FF, free_smallkey, skip) ; A6 - Small key of Dark Palace
%ReceiptProps($A7, -4, 4, $0F, $F36A, $FF, free_smallkey, skip) ; A7 - Small key of Misery Mire
%ReceiptProps($A8, -4, 4, $0F, $F36A, $FF, free_smallkey, skip) ; A8 - Small key of Skull Woods
%ReceiptProps($A9, -4, 4, $0F, $F36A, $FF, free_smallkey, skip) ; A9 - Small key of Ice Palace
%ReceiptProps($AA, -4, 4, $0F, $F36A, $FF, free_smallkey, skip) ; AA - Small key of Tower of Hera
%ReceiptProps($AB, -4, 4, $0F, $F36A, $FF, free_smallkey, skip) ; AB - Small key of Thieves' Town
%ReceiptProps($AC, -4, 4, $0F, $F36A, $FF, free_smallkey, skip) ; AC - Small key of Turtle Rock
%ReceiptProps($AD, -4, 4, $0F, $F36A, $FF, free_smallkey, skip) ; AD - Small key of Ganon's Tower
%ReceiptProps($AE, -4, 4, $0F, $F36A, $FF, skip, skip) ; AE - Reserved
%ReceiptProps($AF, -4, 4, $0F, $F36A, $FF, generic_smallkey, skip) ; AF - Generic small key
%ReceiptProps($B0, -4, 0, $28, $F36A, $FF, free_crystal, skip) ; B0 - Crystal 6 
%ReceiptProps($B1, -4, 0, $28, $F36A, $FF, free_crystal, skip) ; B1 - Crystal 1 
%ReceiptProps($B2, -4, 0, $28, $F36A, $FF, free_crystal, skip) ; B2 - Crystal 5 
%ReceiptProps($B3, -4, 0, $28, $F36A, $FF, free_crystal, skip) ; B3 - Crystal 7 
%ReceiptProps($B4, -4, 0, $28, $F36A, $FF, free_crystal, skip) ; B4 - Crystal 2 
%ReceiptProps($B5, -4, 0, $28, $F36A, $FF, free_crystal, skip) ; B5 - Crystal 4 
%ReceiptProps($B6, -4, 0, $28, $F36A, $FF, free_crystal, skip) ; B6 - Crystal 3 
%ReceiptProps($B7, -4, 0, $49, $F36A, $FF, skip, skip) ; B7 - Reserved 
%ReceiptProps($B8, -4, 0, $49, $F36A, $FF, skip, skip) ; B8 - 
%ReceiptProps($B9, -4, 0, $49, $F36A, $FF, skip, skip) ; B9 - 
%ReceiptProps($BA, -4, 0, $49, $F36A, $FF, skip, skip) ; BA - 
%ReceiptProps($BB, -4, 0, $49, $F36A, $FF, skip, skip) ; BB - 
%ReceiptProps($BC, -4, 0, $49, $F36A, $FF, skip, skip) ; BC - 
%ReceiptProps($BD, -4, 0, $49, $F36A, $FF, skip, skip) ; BD - 
%ReceiptProps($BE, -4, 0, $49, $F36A, $FF, skip, skip) ; BE - 
%ReceiptProps($BF, -4, 0, $49, $F36A, $FF, skip, skip) ; BF - 
%ReceiptProps($C0, -4, 0, $49, $F36A, $FF, skip, skip) ; C0 - 
%ReceiptProps($C1, -4, 0, $49, $F36A, $FF, skip, skip) ; C1 - 
%ReceiptProps($C2, -4, 0, $49, $F36A, $FF, skip, skip) ; C2 - 
%ReceiptProps($C3, -4, 0, $49, $F36A, $FF, skip, skip) ; C3 - 
%ReceiptProps($C4, -4, 0, $49, $F36A, $FF, skip, skip) ; C4 - 
%ReceiptProps($C5, -4, 0, $49, $F36A, $FF, skip, skip) ; C5 - 
%ReceiptProps($C6, -4, 0, $49, $F36A, $FF, skip, skip) ; C6 - 
%ReceiptProps($C7, -4, 0, $49, $F36A, $FF, skip, skip) ; C7 - 
%ReceiptProps($C8, -4, 0, $49, $F36A, $FF, skip, skip) ; C8 - 
%ReceiptProps($C9, -4, 0, $49, $F36A, $FF, skip, skip) ; C9 - 
%ReceiptProps($CA, -4, 0, $49, $F36A, $FF, skip, skip) ; CA - 
%ReceiptProps($CB, -4, 0, $49, $F36A, $FF, skip, skip) ; CB - 
%ReceiptProps($CC, -4, 0, $49, $F36A, $FF, skip, skip) ; CC - 
%ReceiptProps($CD, -4, 0, $49, $F36A, $FF, skip, skip) ; CD - 
%ReceiptProps($CE, -4, 0, $49, $F36A, $FF, skip, skip) ; CE - 
%ReceiptProps($CF, -4, 0, $49, $F36A, $FF, skip, skip) ; CF - 
%ReceiptProps($D0, -4, 0, $49, $F36A, $FF, skip, skip) ; D0 - 
%ReceiptProps($D1, -4, 0, $49, $F36A, $FF, skip, skip) ; D1 - 
%ReceiptProps($D2, -4, 0, $49, $F36A, $FF, skip, skip) ; D2 - 
%ReceiptProps($D3, -4, 0, $49, $F36A, $FF, skip, skip) ; D3 - 
%ReceiptProps($D4, -4, 0, $49, $F36A, $FF, skip, skip) ; D4 - 
%ReceiptProps($D5, -4, 0, $49, $F36A, $FF, skip, skip) ; D5 - 
%ReceiptProps($D6, -4, 0, $49, $F36A, $FF, skip, skip) ; D6 - 
%ReceiptProps($D7, -4, 0, $49, $F36A, $FF, skip, skip) ; D7 - 
%ReceiptProps($D8, -4, 0, $49, $F36A, $FF, skip, skip) ; D8 - 
%ReceiptProps($D9, -4, 0, $49, $F36A, $FF, skip, skip) ; D9 - 
%ReceiptProps($DA, -4, 0, $49, $F36A, $FF, skip, skip) ; DA - 
%ReceiptProps($DB, -4, 0, $49, $F36A, $FF, skip, skip) ; DB - 
%ReceiptProps($DC, -4, 0, $49, $F36A, $FF, skip, skip) ; DC - 
%ReceiptProps($DD, -4, 0, $49, $F36A, $FF, skip, skip) ; DD - 
%ReceiptProps($DE, -4, 0, $49, $F36A, $FF, skip, skip) ; DE - 
%ReceiptProps($DF, -4, 0, $49, $F36A, $FF, skip, skip) ; DF - 
%ReceiptProps($E0, -4, 0, $49, $F36A, $FF, skip, skip) ; E0 - 
%ReceiptProps($E1, -4, 0, $49, $F36A, $FF, skip, skip) ; E1 - 
%ReceiptProps($E2, -4, 0, $49, $F36A, $FF, skip, skip) ; E2 - 
%ReceiptProps($E3, -4, 0, $49, $F36A, $FF, skip, skip) ; E3 - 
%ReceiptProps($E4, -4, 0, $49, $F36A, $FF, skip, skip) ; E4 - 
%ReceiptProps($E5, -4, 0, $49, $F36A, $FF, skip, skip) ; E5 - 
%ReceiptProps($E6, -4, 0, $49, $F36A, $FF, skip, skip) ; E6 - 
%ReceiptProps($E7, -4, 0, $49, $F36A, $FF, skip, skip) ; E7 - 
%ReceiptProps($E8, -4, 0, $49, $F36A, $FF, skip, skip) ; E8 - 
%ReceiptProps($E9, -4, 0, $49, $F36A, $FF, skip, skip) ; E9 - 
%ReceiptProps($EA, -4, 0, $49, $F36A, $FF, skip, skip) ; EA - 
%ReceiptProps($EB, -4, 0, $49, $F36A, $FF, skip, skip) ; EB - 
%ReceiptProps($EC, -4, 0, $49, $F36A, $FF, skip, skip) ; EC - 
%ReceiptProps($ED, -4, 0, $49, $F36A, $FF, skip, skip) ; ED - 
%ReceiptProps($EE, -4, 0, $49, $F36A, $FF, skip, skip) ; EE - 
%ReceiptProps($EF, -4, 0, $49, $F36A, $FF, skip, skip) ; EF - 
%ReceiptProps($F0, -4, 0, $49, $F36A, $FF, skip, skip) ; F0 - 
%ReceiptProps($F1, -4, 0, $49, $F36A, $FF, skip, skip) ; F1 - 
%ReceiptProps($F2, -4, 0, $49, $F36A, $FF, skip, skip) ; F2 - 
%ReceiptProps($F3, -4, 0, $49, $F36A, $FF, skip, skip) ; F3 - 
%ReceiptProps($F4, -4, 0, $49, $F36A, $FF, skip, skip) ; F4 - 
%ReceiptProps($F5, -4, 0, $49, $F36A, $FF, skip, skip) ; F5 - 
%ReceiptProps($F6, -4, 0, $49, $F36A, $FF, skip, skip) ; F6 - 
%ReceiptProps($F7, -4, 0, $49, $F36A, $FF, skip, skip) ; F7 - 
%ReceiptProps($F8, -4, 0, $49, $F36A, $FF, skip, skip) ; F8 - 
%ReceiptProps($F9, -4, 0, $49, $F36A, $FF, skip, skip) ; F9 - 
%ReceiptProps($FA, -4, 0, $49, $F36A, $FF, skip, skip) ; FA - 
%ReceiptProps($FB, -4, 0, $49, $F36A, $FF, skip, skip) ; FB - 
%ReceiptProps($FC, -4, 0, $49, $F36A, $FF, skip, skip) ; FC - 
%ReceiptProps($FD, -4, 0, $49, $F36A, $FF, skip, skip) ; FD - 
%ReceiptProps($FE, -4, 0, $49, $F36A, $FF, skip, skip) ; FE - Server request (async)
%ReceiptProps($FF, -4, 0, $49, $F36A, $FF, skip, skip) ; FF - 

;------------------------------------------------------------------------------
; Palettes: l - - - - c c c
; c = Color Index | l = Load palette data from ROM
SpriteProperties:
        .chest_width         : fillbyte $00   : fill 256
        .standing_width      : fillbyte $00   : fill 256
        .chest_palette       : fillbyte $00   : fill 256
        .standing_palette    : fillbyte $00   : fill 256
        .palette_addr        : fillword $0000 : fill 256*2 ; bank $9B

macro SpriteProps(id, chest_width, standing_width, chest_pal, standing_pal, addr)
	pushpc
    
	org SpriteProperties_chest_width+<id>         : db <chest_width>
	org SpriteProperties_standing_width+<id>      : db <standing_width>
	org SpriteProperties_chest_palette+<id>       : db <chest_pal>
	org SpriteProperties_standing_palette+<id>    : db <standing_pal>
	org SpriteProperties_palette_addr+<id>+<id>   : dw <addr>

	pullpc
endmacro

%SpriteProps($00, 0, 2, $05, $02, PalettesVanilla_blue_ice+$0E)         ; 00 - Fighter sword & Shield
%SpriteProps($01, 0, 2, $05, $05, PalettesCustom_master_sword)          ; 01 - Master sword
%SpriteProps($02, 0, 2, $05, $01, PalettesCustom_tempered_sword)        ; 02 - Tempered sword
%SpriteProps($03, 0, 2, $05, $04, PalettesCustom_golden_sword)          ; 03 - Golden sword
%SpriteProps($04, 0, 0, $05, $80, PalettesCustom_fighter_shield)        ; 04 - Fighter shield
%SpriteProps($05, 2, 2, $05, $80, PalettesCustom_red_shield)            ; 05 - Fire shield
%SpriteProps($06, 2, 2, $05, $80, PalettesCustom_mirror_shield)         ; 06 - Mirror shield
%SpriteProps($07, 0, 0, $01, $01, PalettesVanilla_red_melon+$0E)        ; 07 - Fire rod
%SpriteProps($08, 0, 0, $02, $02, PalettesVanilla_blue_ice+$0E)         ; 08 - Ice rod
%SpriteProps($09, 0, 0, $01, $01, PalettesVanilla_red_melon+$0E)        ; 09 - Hammer
%SpriteProps($0A, 0, 0, $01, $01, PalettesVanilla_red_melon+$0E)        ; 0A - Hookshot
%SpriteProps($0B, 0, 0, $01, $01, PalettesVanilla_red_melon+$0E)        ; 0B - Bow
%SpriteProps($0C, 0, 0, $02, $02, PalettesVanilla_blue_ice+$0E)         ; 0C - Blue Boomerang
%SpriteProps($0D, 2, 2, $02, $02, PalettesVanilla_blue_ice+$0E)         ; 0D - Powder
%SpriteProps($0E, 2, 2, $02, $02, PalettesVanilla_blue_ice+$0E)         ; 0E - Bottle refill (bee)
%SpriteProps($0F, 2, 2, $04, $04, PalettesVanilla_green_blue_guard+$0E) ; 0F - Bombos
%SpriteProps($10, 2, 2, $04, $04, PalettesVanilla_green_blue_guard+$0E) ; 10 - Ether
%SpriteProps($11, 2, 2, $04, $04, PalettesVanilla_green_blue_guard+$0E) ; 11 - Quake
%SpriteProps($12, 2, 2, $01, $01, PalettesVanilla_red_melon+$0E)        ; 12 - Lamp
%SpriteProps($13, 0, 0, $01, $01, PalettesVanilla_red_melon+$0E)        ; 13 - Shovel
%SpriteProps($14, 2, 2, $02, $02, PalettesVanilla_blue_ice+$0E)         ; 14 - Flute
%SpriteProps($15, 0, 0, $01, $01, PalettesVanilla_red_melon+$0E)        ; 15 - Somaria
%SpriteProps($16, 2, 2, $01, $01, PalettesVanilla_red_melon+$0E)        ; 16 - Bottle
%SpriteProps($17, 2, 2, $01, $01, PalettesVanilla_red_melon+$0E)        ; 17 - Heart piece
%SpriteProps($18, 0, 0, $02, $02, PalettesVanilla_blue_ice+$0E)         ; 18 - Byrna
%SpriteProps($19, 2, 2, $01, $01, PalettesVanilla_red_melon+$0E)        ; 19 - Cape
%SpriteProps($1A, 2, 2, $02, $02, PalettesVanilla_blue_ice+$0E)         ; 1A - Mirror
%SpriteProps($1B, 2, 2, $01, $01, PalettesVanilla_red_melon+$0E)        ; 1B - Glove
%SpriteProps($1C, 2, 2, $04, $04, PalettesVanilla_green_blue_guard+$0E) ; 1C - Mitts
%SpriteProps($1D, 2, 2, $04, $04, PalettesVanilla_green_blue_guard+$0E) ; 1D - Book
%SpriteProps($1E, 2, 2, $02, $02, PalettesVanilla_blue_ice+$0E)         ; 1E - Flippers
%SpriteProps($1F, 2, 2, $01, $01, PalettesVanilla_red_melon+$0E)        ; 1F - Pearl
%SpriteProps($20, 2, 2, $86, $86, PalettesCustom_crystal)               ; 20 - Crystal
%SpriteProps($21, 2, 2, $01, $01, PalettesVanilla_red_melon+$0E)        ; 21 - Net
%SpriteProps($22, 2, 2, $02, $02, PalettesVanilla_blue_ice+$0E)         ; 22 - Blue mail
%SpriteProps($23, 2, 2, $01, $01, PalettesVanilla_red_melon+$0E)        ; 23 - Red mail
%SpriteProps($24, 0, 0, $02, $04, PalettesVanilla_blue_ice+$0E)         ; 24 - Small key
%SpriteProps($25, 2, 2, $02, $02, PalettesVanilla_blue_ice+$0E)         ; 25 - Compass
%SpriteProps($26, 2, 2, $01, $01, PalettesVanilla_red_melon+$0E)        ; 26 - Heart container from 4/4
%SpriteProps($27, 2, 2, $02, $02, PalettesVanilla_blue_ice+$0E)         ; 27 - Bomb
%SpriteProps($28, 2, 2, $02, $02, PalettesVanilla_blue_ice+$0E)         ; 28 - 3 bombs
%SpriteProps($29, 2, 2, $04, $04, PalettesVanilla_green_blue_guard+$0E) ; 29 - Mushroom
%SpriteProps($2A, 0, 0, $01, $01, PalettesVanilla_red_melon+$0E)        ; 2A - Red boomerang
%SpriteProps($2B, 2, 2, $01, $01, PalettesVanilla_red_melon+$0E)        ; 2B - Full bottle (red)
%SpriteProps($2C, 2, 2, $04, $04, PalettesVanilla_green_blue_guard+$0E) ; 2C - Full bottle (green)
%SpriteProps($2D, 2, 2, $02, $02, PalettesVanilla_blue_ice+$0E)         ; 2D - Full bottle (blue)
%SpriteProps($2E, 2, 2, $01, $01, PalettesVanilla_red_melon+$0E)        ; 2E - Potion refill (red)
%SpriteProps($2F, 2, 2, $04, $04, PalettesVanilla_green_blue_guard+$0E) ; 2F - Potion refill (green)
%SpriteProps($30, 2, 2, $02, $02, PalettesVanilla_blue_ice+$0E)         ; 30 - Potion refill (blue)
%SpriteProps($31, 2, 2, $02, $02, PalettesVanilla_blue_ice+$0E)         ; 31 - 10 bombs
%SpriteProps($32, 2, 2, $04, $04, PalettesVanilla_green_blue_guard+$0E) ; 32 - Big key
%SpriteProps($33, 2, 2, $04, $04, PalettesVanilla_green_blue_guard+$0E) ; 33 - Map
%SpriteProps($34, 0, 0, $04, $04, PalettesVanilla_green_blue_guard+$0E) ; 34 - 1 rupee
%SpriteProps($35, 0, 0, $02, $02, PalettesVanilla_blue_ice+$0E)         ; 35 - 5 rupees
%SpriteProps($36, 0, 0, $01, $01, PalettesVanilla_red_melon+$0E)        ; 36 - 20 rupees
%SpriteProps($37, 2, 2, $04, $04, PalettesVanilla_green_blue_guard+$0E) ; 37 - Green pendant
%SpriteProps($38, 2, 2, $01, $01, PalettesVanilla_red_melon+$0E)        ; 38 - Red pendant
%SpriteProps($39, 2, 2, $02, $02, PalettesVanilla_blue_ice+$0E)         ; 39 - Blue pendant
%SpriteProps($3A, 2, 2, $02, $02, PalettesVanilla_blue_ice+$0E)         ; 3A - Bow And Arrows
%SpriteProps($3B, 2, 2, $01, $01, PalettesVanilla_red_melon+$0E)        ; 3B - Silver Bow
%SpriteProps($3C, 2, 2, $02, $02, PalettesVanilla_blue_ice+$0E)         ; 3C - Full bottle (bee)
%SpriteProps($3D, 2, 2, $02, $02, PalettesVanilla_blue_ice+$0E)         ; 3D - Full bottle (fairy)
%SpriteProps($3E, 2, 2, $01, $01, PalettesVanilla_red_melon+$0E)        ; 3E - Boss heart
%SpriteProps($3F, 2, 2, $01, $01, PalettesVanilla_red_melon+$0E)        ; 3F - Sanc heart
%SpriteProps($40, 2, 2, $04, $04, PalettesVanilla_green_blue_guard+$0E) ; 40 - 100 rupees
%SpriteProps($41, 2, 2, $04, $04, PalettesVanilla_green_blue_guard+$0E) ; 41 - 50 rupees
%SpriteProps($42, 0, 0, $01, $01, PalettesVanilla_red_melon+$0E)        ; 42 - Heart
%SpriteProps($43, 0, 0, $02, $02, PalettesVanilla_blue_ice+$0E)         ; 43 - Arrow
%SpriteProps($44, 2, 2, $02, $02, PalettesVanilla_blue_ice+$0E)         ; 44 - 10 arrows
%SpriteProps($45, 0, 0, $04, $04, PalettesVanilla_green_blue_guard+$0E) ; 45 - Small magic
%SpriteProps($46, 2, 2, $04, $04, PalettesVanilla_green_blue_guard+$0E) ; 46 - 300 rupees
%SpriteProps($47, 2, 2, $04, $04, PalettesVanilla_green_blue_guard+$0E) ; 47 - 20 rupees green
%SpriteProps($48, 2, 2, $02, $02, PalettesVanilla_blue_ice+$0E)         ; 48 - Full bottle (good bee)
%SpriteProps($49, 0, 2, $05, $02, PalettesCustom_fighter_shield)        ; 49 - Tossed fighter sword
%SpriteProps($4A, 2, 2, $02, $02, PalettesVanilla_blue_ice+$0E)         ; 4A - Active Flute
%SpriteProps($4B, 2, 2, $01, $01, PalettesVanilla_red_melon+$0E)        ; 4B - Boots
%SpriteProps($4C, 2, 2, $04, $04, PalettesVanilla_green_blue_guard+$0E) ; 4C - Bomb capacity (50)
%SpriteProps($4D, 2, 2, $04, $04, PalettesVanilla_green_blue_guard+$0E) ; 4D - Arrow capacity (70)
%SpriteProps($4E, 2, 2, $04, $04, PalettesVanilla_green_blue_guard+$0E) ; 4E - 1/2 magic
%SpriteProps($4F, 2, 2, $04, $04, PalettesVanilla_green_blue_guard+$0E) ; 4F - 1/4 magic
%SpriteProps($50, 0, 2, $05, $02, PalettesCustom_master_sword)          ; 50 - Safe master sword
%SpriteProps($51, 2, 2, $04, $04, PalettesVanilla_green_blue_guard+$0E) ; 51 - Bomb capacity (+5)
%SpriteProps($52, 2, 2, $04, $04, PalettesVanilla_green_blue_guard+$0E) ; 52 - Bomb capacity (+10)
%SpriteProps($53, 2, 2, $04, $04, PalettesVanilla_green_blue_guard+$0E) ; 53 - Arrow capacity (+5)
%SpriteProps($54, 2, 2, $04, $04, PalettesVanilla_green_blue_guard+$0E) ; 54 - Arrow capacity (+10)
%SpriteProps($55, 2, 2, $04, $04, $0000)                                ; 55 - Programmable item 1
%SpriteProps($56, 2, 2, $04, $04, $0000)                                ; 56 - Programmable item 2
%SpriteProps($57, 2, 2, $04, $04, $0000)                                ; 57 - Programmable item 3
%SpriteProps($58, 2, 2, $01, $01, PalettesVanilla_red_melon+$0E)        ; 58 - Upgrade-only Silver Arrows
%SpriteProps($59, 0, 0, $03, $03, PalettesCustom_off_black)             ; 59 - Rupoor
%SpriteProps($5A, 2, 2, $01, $01, $0000)                                ; 5A - Nothing
%SpriteProps($5B, 2, 2, $01, $01, PalettesVanilla_red_melon+$0E)        ; 5B - Red clock
%SpriteProps($5C, 2, 2, $02, $02, PalettesVanilla_blue_ice+$0E)         ; 5C - Blue clock
%SpriteProps($5D, 2, 2, $04, $04, PalettesVanilla_green_blue_guard+$0E) ; 5D - Green clock
%SpriteProps($5E, 2, 2, $FF, $FF, $0000)                                ; 5E - Progressive sword
%SpriteProps($5F, 2, 2, $FF, $FF, $0000)                                ; 5F - Progressive shield
%SpriteProps($60, 2, 2, $FF, $FF, $0000)                                ; 60 - Progressive armor
%SpriteProps($61, 2, 2, $FF, $FF, $0000)                                ; 61 - Progressive glove
%SpriteProps($62, 2, 2, $FF, $FF, $0000)                                ; 62 - RNG pool item (single)
%SpriteProps($63, 2, 2, $FF, $FF, $0000)                                ; 63 - RNG pool item (multi)
%SpriteProps($64, 2, 2, $FF, $FF, $0000)                                ; 64 - Progressive bow
%SpriteProps($65, 2, 2, $FF, $FF, $0000)                                ; 65 - Progressive bow
%SpriteProps($66, 2, 2, $00, $00, $0000)                                ; 66 - 
%SpriteProps($67, 2, 2, $00, $00, $0000)                                ; 67 - 
%SpriteProps($68, 2, 2, $00, $00, $0000)                                ; 68 - 
%SpriteProps($69, 2, 2, $00, $00, $0000)                                ; 69 - 
%SpriteProps($6A, 2, 2, $04, $04, PalettesVanilla_green_blue_guard+$0E) ; 6A - Triforce
%SpriteProps($6B, 2, 2, $04, $04, PalettesVanilla_green_blue_guard+$0E) ; 6B - Power star
%SpriteProps($6C, 2, 2, $04, $04, PalettesVanilla_green_blue_guard+$0E) ; 6C - Triforce Piece
%SpriteProps($6D, 2, 2, $FF, $FF, $0000)                                ; 6D - Server request item
%SpriteProps($6E, 2, 2, $FF, $FF, $0000)                                ; 6E - Server request item (dungeon drop)
%SpriteProps($6F, 2, 2, $FF, $FF, $0000)                                ; 6F - 
%SpriteProps($70, 2, 2, $04, $04, PalettesVanilla_green_blue_guard+$0E) ; 70 - Map of Light World
%SpriteProps($71, 2, 2, $04, $04, PalettesVanilla_green_blue_guard+$0E) ; 71 - Map of Dark World
%SpriteProps($72, 2, 2, $04, $04, PalettesVanilla_green_blue_guard+$0E) ; 72 - Map of Ganon's Tower
%SpriteProps($73, 2, 2, $04, $04, PalettesVanilla_green_blue_guard+$0E) ; 73 - Map of Turtle Rock
%SpriteProps($74, 2, 2, $04, $04, PalettesVanilla_green_blue_guard+$0E) ; 74 - Map of Thieves' Town
%SpriteProps($75, 2, 2, $04, $04, PalettesVanilla_green_blue_guard+$0E) ; 75 - Map of Tower of Hera
%SpriteProps($76, 2, 2, $04, $04, PalettesVanilla_green_blue_guard+$0E) ; 76 - Map of Ice Palace
%SpriteProps($77, 2, 2, $04, $04, PalettesVanilla_green_blue_guard+$0E) ; 77 - Map of Skull Woods
%SpriteProps($78, 2, 2, $04, $04, PalettesVanilla_green_blue_guard+$0E) ; 78 - Map of Misery Mire
%SpriteProps($79, 2, 2, $04, $04, PalettesVanilla_green_blue_guard+$0E) ; 79 - Map of Dark Palace
%SpriteProps($7A, 2, 2, $04, $04, PalettesVanilla_green_blue_guard+$0E) ; 7A - Map of Swamp Palace
%SpriteProps($7B, 2, 2, $04, $04, PalettesVanilla_green_blue_guard+$0E) ; 7B - Map of Agahnim's Tower
%SpriteProps($7C, 2, 2, $04, $04, PalettesVanilla_green_blue_guard+$0E) ; 7C - Map of Desert Palace
%SpriteProps($7D, 2, 2, $04, $04, PalettesVanilla_green_blue_guard+$0E) ; 7D - Map of Eastern Palace
%SpriteProps($7E, 2, 2, $04, $04, PalettesVanilla_green_blue_guard+$0E) ; 7E - Map of Hyrule Castle
%SpriteProps($7F, 2, 2, $04, $04, PalettesVanilla_green_blue_guard+$0E) ; 7F - Map of Sewers
%SpriteProps($80, 2, 2, $02, $02, PalettesVanilla_blue_ice+$0E)         ; 80 - Compass of Light World
%SpriteProps($81, 2, 2, $02, $02, PalettesVanilla_blue_ice+$0E)         ; 81 - Compass of Dark World
%SpriteProps($82, 2, 2, $02, $02, PalettesVanilla_blue_ice+$0E)         ; 82 - Compass of Ganon's Tower
%SpriteProps($83, 2, 2, $02, $02, PalettesVanilla_blue_ice+$0E)         ; 83 - Compass of Turtle Rock
%SpriteProps($84, 2, 2, $02, $02, PalettesVanilla_blue_ice+$0E)         ; 84 - Compass of Thieves' Town
%SpriteProps($85, 2, 2, $02, $02, PalettesVanilla_blue_ice+$0E)         ; 85 - Compass of Tower of Hera
%SpriteProps($86, 2, 2, $02, $02, PalettesVanilla_blue_ice+$0E)         ; 86 - Compass of Ice Palace
%SpriteProps($87, 2, 2, $02, $02, PalettesVanilla_blue_ice+$0E)         ; 87 - Compass of Skull Woods
%SpriteProps($88, 2, 2, $02, $02, PalettesVanilla_blue_ice+$0E)         ; 88 - Compass of Misery Mire
%SpriteProps($89, 2, 2, $02, $02, PalettesVanilla_blue_ice+$0E)         ; 89 - Compass of Dark Palace
%SpriteProps($8A, 2, 2, $02, $02, PalettesVanilla_blue_ice+$0E)         ; 8A - Compass of Swamp Palace
%SpriteProps($8B, 2, 2, $02, $02, PalettesVanilla_blue_ice+$0E)         ; 8B - Compass of Agahnim's Tower
%SpriteProps($8C, 2, 2, $02, $02, PalettesVanilla_blue_ice+$0E)         ; 8C - Compass of Desert Palace
%SpriteProps($8D, 2, 2, $02, $02, PalettesVanilla_blue_ice+$0E)         ; 8D - Compass of Eastern Palace
%SpriteProps($8E, 2, 2, $02, $02, PalettesVanilla_blue_ice+$0E)         ; 8E - Compass of Hyrule Castle
%SpriteProps($8F, 2, 2, $02, $02, PalettesVanilla_blue_ice+$0E)         ; 8F - Compass of Sewers
%SpriteProps($90, 2, 2, $04, $04, PalettesVanilla_green_blue_guard+$0E) ; 90 - Skull key
%SpriteProps($91, 2, 2, $04, $04, $0000)                                ; 91 - Reserved
%SpriteProps($92, 2, 2, $04, $04, PalettesVanilla_green_blue_guard+$0E) ; 92 - Big key of Ganon's Tower
%SpriteProps($93, 2, 2, $04, $04, PalettesVanilla_green_blue_guard+$0E) ; 93 - Big key of Turtle Rock
%SpriteProps($94, 2, 2, $04, $04, PalettesVanilla_green_blue_guard+$0E) ; 94 - Big key of Thieves' Town
%SpriteProps($95, 2, 2, $04, $04, PalettesVanilla_green_blue_guard+$0E) ; 95 - Big key of Tower of Hera
%SpriteProps($96, 2, 2, $04, $04, PalettesVanilla_green_blue_guard+$0E) ; 96 - Big key of Ice Palace
%SpriteProps($97, 2, 2, $04, $04, PalettesVanilla_green_blue_guard+$0E) ; 97 - Big key of Skull Woods
%SpriteProps($98, 2, 2, $04, $04, PalettesVanilla_green_blue_guard+$0E) ; 98 - Big key of Misery Mire
%SpriteProps($99, 2, 2, $04, $04, PalettesVanilla_green_blue_guard+$0E) ; 99 - Big key of Dark Palace
%SpriteProps($9A, 2, 2, $04, $04, PalettesVanilla_green_blue_guard+$0E) ; 9A - Big key of Swamp Palace
%SpriteProps($9B, 2, 2, $04, $04, PalettesVanilla_green_blue_guard+$0E) ; 9B - Big key of Agahnim's Tower
%SpriteProps($9C, 2, 2, $04, $04, PalettesVanilla_green_blue_guard+$0E) ; 9C - Big key of Desert Palace
%SpriteProps($9D, 2, 2, $04, $04, PalettesVanilla_green_blue_guard+$0E) ; 9D - Big key of Eastern Palace
%SpriteProps($9E, 2, 2, $04, $04, PalettesVanilla_green_blue_guard+$0E) ; 9E - Big key of Hyrule Castle
%SpriteProps($9F, 2, 2, $04, $04, PalettesVanilla_green_blue_guard+$0E) ; 9F - Big key of Sewers
%SpriteProps($A0, 0, 0, $02, $04, PalettesVanilla_blue_ice+$0E)         ; A0 - Small key of Sewers
%SpriteProps($A1, 0, 0, $02, $04, PalettesVanilla_blue_ice+$0E)         ; A1 - Small key of Hyrule Castle
%SpriteProps($A2, 0, 0, $02, $04, PalettesVanilla_blue_ice+$0E)         ; A2 - Small key of Eastern Palace
%SpriteProps($A3, 0, 0, $02, $04, PalettesVanilla_blue_ice+$0E)         ; A3 - Small key of Desert Palace
%SpriteProps($A4, 0, 0, $02, $04, PalettesVanilla_blue_ice+$0E)         ; A4 - Small key of Agahnim's Tower
%SpriteProps($A5, 0, 0, $02, $04, PalettesVanilla_blue_ice+$0E)         ; A5 - Small key of Swamp Palace
%SpriteProps($A6, 0, 0, $02, $04, PalettesVanilla_blue_ice+$0E)         ; A6 - Small key of Dark Palace
%SpriteProps($A7, 0, 0, $02, $04, PalettesVanilla_blue_ice+$0E)         ; A7 - Small key of Misery Mire
%SpriteProps($A8, 0, 0, $02, $04, PalettesVanilla_blue_ice+$0E)         ; A8 - Small key of Skull Woods
%SpriteProps($A9, 0, 0, $02, $04, PalettesVanilla_blue_ice+$0E)         ; A9 - Small key of Ice Palace
%SpriteProps($AA, 0, 0, $02, $04, PalettesVanilla_blue_ice+$0E)         ; AA - Small key of Tower of Hera
%SpriteProps($AB, 0, 0, $02, $04, PalettesVanilla_blue_ice+$0E)         ; AB - Small key of Thieves' Town
%SpriteProps($AC, 0, 0, $02, $04, PalettesVanilla_blue_ice+$0E)         ; AC - Small key of Turtle Rock
%SpriteProps($AD, 0, 0, $02, $04, PalettesVanilla_blue_ice+$0E)         ; AD - Small key of Ganon's Tower
%SpriteProps($AE, 2, 2, $02, $02, $0000)                                ; AE - Reserved
%SpriteProps($AF, 0, 0, $02, $04, PalettesVanilla_blue_ice+$0E)         ; AF - Generic small key
%SpriteProps($B0, 2, 2, $80, $80, PalettesCustom_crystal)               ; B0 - Crystal 6
%SpriteProps($B1, 2, 2, $80, $80, PalettesCustom_crystal)               ; B1 - Crystal 1
%SpriteProps($B2, 2, 2, $80, $80, PalettesCustom_crystal)               ; B2 - Crystal 5
%SpriteProps($B3, 2, 2, $80, $80, PalettesCustom_crystal)               ; B3 - Crystal 7
%SpriteProps($B4, 2, 2, $80, $80, PalettesCustom_crystal)               ; B4 - Crystal 2
%SpriteProps($B5, 2, 2, $80, $80, PalettesCustom_crystal)               ; B5 - Crystal 4
%SpriteProps($B6, 2, 2, $80, $80, PalettesCustom_crystal)               ; B6 - Crystal 3
%SpriteProps($B7, 2, 2, $80, $80, $0000)                                ; B7 - Reserved
%SpriteProps($B8, 2, 2, $04, $04, $0000)                                ; B8 - 
%SpriteProps($B9, 2, 2, $04, $04, $0000)                                ; B9 - 
%SpriteProps($BA, 2, 2, $04, $04, $0000)                                ; BA - 
%SpriteProps($BB, 2, 2, $04, $04, $0000)                                ; BB - 
%SpriteProps($BC, 2, 2, $04, $04, $0000)                                ; BC - 
%SpriteProps($BD, 2, 2, $04, $04, $0000)                                ; BD - 
%SpriteProps($BE, 2, 2, $04, $04, $0000)                                ; BE - 
%SpriteProps($BF, 2, 2, $04, $04, $0000)                                ; BF - 
%SpriteProps($C0, 2, 2, $04, $04, $0000)                                ; C0 - 
%SpriteProps($C1, 2, 2, $04, $04, $0000)                                ; C1 - 
%SpriteProps($C2, 2, 2, $04, $04, $0000)                                ; C2 - 
%SpriteProps($C3, 2, 2, $04, $04, $0000)                                ; C3 - 
%SpriteProps($C4, 2, 2, $04, $04, $0000)                                ; C4 - 
%SpriteProps($C5, 2, 2, $04, $04, $0000)                                ; C5 - 
%SpriteProps($C6, 2, 2, $04, $04, $0000)                                ; C6 - 
%SpriteProps($C7, 2, 2, $04, $04, $0000)                                ; C7 - 
%SpriteProps($C8, 2, 2, $04, $04, $0000)                                ; C8 - 
%SpriteProps($C9, 2, 2, $04, $04, $0000)                                ; C9 - 
%SpriteProps($CA, 2, 2, $04, $04, $0000)                                ; CA - 
%SpriteProps($CB, 2, 2, $04, $04, $0000)                                ; CB - 
%SpriteProps($CC, 2, 2, $04, $04, $0000)                                ; CC - 
%SpriteProps($CD, 2, 2, $04, $04, $0000)                                ; CD - 
%SpriteProps($CE, 2, 2, $04, $04, $0000)                                ; CE - 
%SpriteProps($CF, 2, 2, $04, $04, $0000)                                ; CF - 
%SpriteProps($D0, 2, 2, $04, $04, $0000)                                ; D0 - 
%SpriteProps($D1, 2, 2, $04, $04, $0000)                                ; D1 - 
%SpriteProps($D2, 2, 2, $04, $04, $0000)                                ; D2 - 
%SpriteProps($D3, 2, 2, $04, $04, $0000)                                ; D3 - 
%SpriteProps($D4, 2, 2, $04, $04, $0000)                                ; D4 - 
%SpriteProps($D5, 2, 2, $04, $04, $0000)                                ; D5 - 
%SpriteProps($D6, 2, 2, $04, $04, $0000)                                ; D6 - 
%SpriteProps($D7, 2, 2, $04, $04, $0000)                                ; D7 - 
%SpriteProps($D8, 2, 2, $04, $04, $0000)                                ; D8 - 
%SpriteProps($D9, 2, 2, $04, $04, $0000)                                ; D9 - 
%SpriteProps($DA, 2, 2, $04, $04, $0000)                                ; DA - 
%SpriteProps($DB, 2, 2, $04, $04, $0000)                                ; DB - 
%SpriteProps($DC, 2, 2, $04, $04, $0000)                                ; DC - 
%SpriteProps($DD, 2, 2, $04, $04, $0000)                                ; DD - 
%SpriteProps($DE, 2, 2, $04, $04, $0000)                                ; DE - 
%SpriteProps($DF, 2, 2, $04, $04, $0000)                                ; DF - 
%SpriteProps($E0, 2, 2, $04, $04, $0000)                                ; E0 - 
%SpriteProps($E1, 2, 2, $04, $04, $0000)                                ; E1 - 
%SpriteProps($E2, 2, 2, $04, $04, $0000)                                ; E2 - 
%SpriteProps($E3, 2, 2, $04, $04, $0000)                                ; E3 - 
%SpriteProps($E4, 2, 2, $04, $04, $0000)                                ; E4 - 
%SpriteProps($E5, 2, 2, $04, $04, $0000)                                ; E5 - 
%SpriteProps($E6, 2, 2, $04, $04, $0000)                                ; E6 - 
%SpriteProps($E7, 2, 2, $04, $04, $0000)                                ; E7 - 
%SpriteProps($E8, 2, 2, $04, $04, $0000)                                ; E8 - 
%SpriteProps($E9, 2, 2, $04, $04, $0000)                                ; E9 - 
%SpriteProps($EA, 2, 2, $04, $04, $0000)                                ; EA - 
%SpriteProps($EB, 2, 2, $04, $04, $0000)                                ; EB - 
%SpriteProps($EC, 2, 2, $04, $04, $0000)                                ; EC - 
%SpriteProps($ED, 2, 2, $04, $04, $0000)                                ; ED - 
%SpriteProps($EE, 2, 2, $04, $04, $0000)                                ; EE - 
%SpriteProps($EF, 2, 2, $04, $04, $0000)                                ; EF - 
%SpriteProps($F0, 2, 2, $04, $04, $0000)                                ; F0 - 
%SpriteProps($F1, 2, 2, $04, $04, $0000)                                ; F1 - 
%SpriteProps($F2, 2, 2, $04, $04, $0000)                                ; F2 - 
%SpriteProps($F3, 2, 2, $04, $04, $0000)                                ; F3 - 
%SpriteProps($F4, 2, 2, $04, $04, $0000)                                ; F4 - 
%SpriteProps($F5, 2, 2, $04, $04, $0000)                                ; F5 - 
%SpriteProps($F6, 2, 2, $04, $04, $0000)                                ; F6 - 
%SpriteProps($F7, 2, 2, $04, $04, $0000)                                ; F7 - 
%SpriteProps($F8, 2, 2, $04, $04, $0000)                                ; F8 - 
%SpriteProps($F9, 2, 2, $04, $04, $0000)                                ; F9 - 
%SpriteProps($FA, 2, 2, $04, $04, $0000)                                ; FA - 
%SpriteProps($FB, 2, 2, $04, $04, $0000)                                ; FB - 
%SpriteProps($FC, 2, 2, $04, $04, $0000)                                ; FC - 
%SpriteProps($FD, 2, 2, $04, $04, $0000)                                ; FD - 
%SpriteProps($FE, 2, 2, $FF, $FF, $0000)                                ; FE - Server request (async)
%SpriteProps($FF, 2, 2, $04, $04, $0000)                                ; FF - 

;------------------------------------------------------------------------------
; Properties: - - - - - - - -  p k w o a y s t
; t = Count for total item counter | s = Count for total in shops
; y = Y item                       | a = A item
; o = Bomb item                    | w = Bow item
; k = Chest Key                    | p = Crystal prize behavior (sparkle, etc) if set
InventoryTable:
	.properties : fillword $0000 : fill 256*2 ; See above
	.stamp      : fillword $0000 : fill 256*2 ; Address to stamp with 32-bit time (bank $7E)
	.stat       : fillword $0000 : fill 256*2 ; Address to increment by one (bank $7E)

macro InventoryItem(id, props, stamp, stat)
	pushpc
	org InventoryTable_properties+<id>+<id> : dw <props>
	org InventoryTable_stamp+<id>+<id>      : dw <stamp>
	org InventoryTable_stat+<id>+<id>       : dw <stat>
	pullpc
endmacro

%InventoryItem($00, $0081, SwordTime, $0000) ; 00 - Fighter sword & Shield
%InventoryItem($01, $0081, SwordTime, $0000) ; 01 - Master sword
%InventoryItem($02, $0001, SwordTime, $0000) ; 02 - Tempered sword
%InventoryItem($03, $0081, SwordTime, $0000) ; 03 - Butter sword
%InventoryItem($04, $0081, $0000, $0000) ; 04 - Fighter shield
%InventoryItem($05, $0081, $0000, $0000) ; 05 - Fire shield
%InventoryItem($06, $0081, $0000, $0000) ; 06 - Mirror shield
%InventoryItem($07, $0085, $0000, $0000) ; 07 - Fire rod
%InventoryItem($08, $0085, $0000, $0000) ; 08 - Ice rod
%InventoryItem($09, $0085, $0000, $0000) ; 09 - Hammer
%InventoryItem($0A, $0085, $0000, $0000) ; 0A - Hookshot
%InventoryItem($0B, $0085, $0000, $0000) ; 0B - Bow
%InventoryItem($0C, $0085, $0000, $0000) ; 0C - Blue Boomerang
%InventoryItem($0D, $0085, $0000, $0000) ; 0D - Powder
%InventoryItem($0E, $0081, $0000, $0000) ; 0E - Bottle refill (bee)
%InventoryItem($0F, $0085, $0000, $0000) ; 0F - Bombos
%InventoryItem($10, $0085, $0000, $0000) ; 10 - Ether
%InventoryItem($11, $0085, $0000, $0000) ; 11 - Quake
%InventoryItem($12, $0085, $0000, $0000) ; 12 - Lamp
%InventoryItem($13, $0085, $0000, $0000) ; 13 - Shovel
%InventoryItem($14, $0085, FluteTime, $0000) ; 14 - Flute (inactive)
%InventoryItem($15, $0085, $0000, $0000) ; 15 - Somaria
%InventoryItem($16, $0085, $0000, $0000) ; 16 - Bottle
%InventoryItem($17, $0001, $0000, HeartPieceCounter) ; 17 - Heart piece
%InventoryItem($18, $0085, $0000, $0000) ; 18 - Byrna
%InventoryItem($19, $0085, $0000, $0000) ; 19 - Cape
%InventoryItem($1A, $0085, MirrorTime, $0000) ; 1A - Mirror
%InventoryItem($1B, $0089, $0000, $0000) ; 1B - Glove
%InventoryItem($1C, $0089, $0000, $0000) ; 1C - Mitts
%InventoryItem($1D, $0085, $0000, $0000) ; 1D - Book
%InventoryItem($1E, $0089, $0000, $0000) ; 1E - Flippers
%InventoryItem($1F, $0081, $0000, $0000) ; 1F - Pearl
%InventoryItem($20, $0080, $0000, $0000) ; 20 - Crystal
%InventoryItem($21, $0085, $0000, $0000) ; 21 - Net
%InventoryItem($22, $0081, $0000, $0000) ; 22 - Blue mail
%InventoryItem($23, $0081, $0000, $0000) ; 23 - Red mail
%InventoryItem($24, $0041, $0000, SmallKeyCounter) ; 24 - Small key
%InventoryItem($25, $0001, $0000, $0000) ; 25 - Compass
%InventoryItem($26, $0000, $0000, $0000) ; 26 - Heart container from 4/4
%InventoryItem($27, $0015, $0000, $0000) ; 27 - Bomb
%InventoryItem($28, $0015, $0000, $0000) ; 28 - 3 bombs
%InventoryItem($29, $0085, $0000, $0000) ; 29 - Mushroom
%InventoryItem($2A, $0005, $0000, $0000) ; 2A - Red boomerang
%InventoryItem($2B, $0085, $0000, $0000) ; 2B - Full bottle (red)
%InventoryItem($2C, $0085, $0000, $0000) ; 2C - Full bottle (green)
%InventoryItem($2D, $0085, $0000, $0000) ; 2D - Full bottle (blue)
%InventoryItem($2E, $0080, $0000, $0000) ; 2E - Potion refill (red)
%InventoryItem($2F, $0080, $0000, $0000) ; 2F - Potion refill (green)
%InventoryItem($30, $0080, $0000, $0000) ; 30 - Potion refill (blue)
%InventoryItem($31, $0011, $0000, $0000) ; 31 - 10 bombs
%InventoryItem($32, $0001, $0000, $0000) ; 32 - Big key
%InventoryItem($33, $0001, $0000, $0000) ; 33 - Map
%InventoryItem($34, $0001, $0000, $0000) ; 34 - 1 rupee
%InventoryItem($35, $0001, $0000, $0000) ; 35 - 5 rupees
%InventoryItem($36, $0001, $0000, $0000) ; 36 - 20 rupees
%InventoryItem($37, $0000, $0000, $0000) ; 37 - Green pendant
%InventoryItem($38, $0000, $0000, $0000) ; 38 - Red pendant
%InventoryItem($39, $0000, $0000, $0000) ; 39 - Blue pendant
%InventoryItem($3A, $00A5, $0000, $0000) ; 3A - Bow And Arrows
%InventoryItem($3B, $00A5, $0000, $0000) ; 3B - Silver Bow
%InventoryItem($3C, $0085, $0000, $0000) ; 3C - Full bottle (bee)
%InventoryItem($3D, $0085, $0000, $0000) ; 3D - Full bottle (fairy)
%InventoryItem($3E, $0001, $0000, HeartContainerCounter) ; 3E - Boss heart
%InventoryItem($3F, $0081, $0000, HeartContainerCounter) ; 3F - Sanc heart
%InventoryItem($40, $0001, $0000, $0000) ; 40 - 100 rupees
%InventoryItem($41, $0001, $0000, $0000) ; 41 - 50 rupees
%InventoryItem($42, $0001, $0000, $0000) ; 42 - Heart
%InventoryItem($43, $0001, $0000, $0000) ; 43 - Arrow
%InventoryItem($44, $0001, $0000, $0000) ; 44 - 10 arrows
%InventoryItem($45, $0001, $0000, $0000) ; 45 - Small magic
%InventoryItem($46, $0001, $0000, $0000) ; 46 - 300 rupees
%InventoryItem($47, $0001, $0000, $0000) ; 47 - 20 rupees green
%InventoryItem($48, $0085, $0000, $0000) ; 48 - Full bottle (good bee)
%InventoryItem($49, $0081, SwordTime, $0000) ; 49 - Tossed fighter sword
%InventoryItem($4A, $0085, FluteTime, $0000) ; 4A - Active Flute
%InventoryItem($4B, $0089, BootsTime, $0000) ; 4B - Boots
%InventoryItem($4C, $0015, $0000, CapacityUpgrades) ; 4C - Bomb capacity (50)
%InventoryItem($4D, $0001, $0000, CapacityUpgrades) ; 4D - Arrow capacity (70)
%InventoryItem($4E, $0081, $0000, CapacityUpgrades) ; 4E - 1/2 magic
%InventoryItem($4F, $0081, $0000, CapacityUpgrades) ; 4F - 1/4 magic
%InventoryItem($50, $0081, SwordTime, $0000) ; 50 - Master Sword (safe)
%InventoryItem($51, $0015, $0000, CapacityUpgrades) ; 51 - Bomb capacity (+5)
%InventoryItem($52, $0015, $0000, CapacityUpgrades) ; 52 - Bomb capacity (+10)
%InventoryItem($53, $0001, $0000, CapacityUpgrades) ; 53 - Arrow capacity (+5)
%InventoryItem($54, $0001, $0000, CapacityUpgrades) ; 54 - Arrow capacity (+10)
%InventoryItem($55, $0001, $0000, $0000) ; 55 - Programmable item 1
%InventoryItem($56, $0001, $0000, $0000) ; 56 - Programmable item 2
%InventoryItem($57, $0001, $0000, $0000) ; 57 - Programmable item 3
%InventoryItem($58, $0081, $0000, $0000) ; 58 - Upgrade-only Silver Arrows
%InventoryItem($59, $0001, $0000, $0000) ; 59 - Rupoor
%InventoryItem($5A, $0001, $0000, $0000) ; 5A - Nothing
%InventoryItem($5B, $0081, $0000, $0000) ; 5B - Red clock
%InventoryItem($5C, $0081, $0000, $0000) ; 5C - Blue clock
%InventoryItem($5D, $0081, $0000, $0000) ; 5D - Green clock
%InventoryItem($5E, $0081, $0000, $0000) ; 5E - Progressive sword
%InventoryItem($5F, $0081, $0000, $0000) ; 5F - Progressive shield
%InventoryItem($60, $0081, $0000, $0000) ; 60 - Progressive armor
%InventoryItem($61, $0089, $0000, $0000) ; 61 - Progressive glove
%InventoryItem($62, $0001, $0000, $0000) ; 62 - RNG pool item (single)
%InventoryItem($63, $0001, $0000, $0000) ; 63 - RNG pool item (multi)
%InventoryItem($64, $00A5, $0000, $0000) ; 64 - Progressive bow
%InventoryItem($65, $00A5, $0000, $0000) ; 65 - Progressive bow
%InventoryItem($66, $0001, $0000, $0000) ; 66 -
%InventoryItem($67, $0001, $0000, $0000) ; 67 -
%InventoryItem($68, $0001, $0000, $0000) ; 68 -
%InventoryItem($69, $0001, $0000, $0000) ; 69 -
%InventoryItem($6A, $0081, $0000, $0000) ; 6A - Triforce
%InventoryItem($6B, $0081, $0000, $0000) ; 6B - Power star
%InventoryItem($6C, $0081, $0000, $0000) ; 6C - Triforce Piece
%InventoryItem($6D, $0001, $0000, $0000) ; 6D - Server request item
%InventoryItem($6E, $0001, $0000, $0000) ; 6E - Server request item (dungeon drop)
%InventoryItem($6F, $0001, $0000, $0000) ; 6F -
%InventoryItem($70, $0001, $0000, $0000) ; 70 - Map of Light World
%InventoryItem($71, $0001, $0000, $0000) ; 71 - Map of Dark World
%InventoryItem($72, $0001, $0000, $0000) ; 72 - Map of Ganon's Tower
%InventoryItem($73, $0001, $0000, $0000) ; 73 - Map of Turtle Rock
%InventoryItem($74, $0001, $0000, $0000) ; 74 - Map of Thieves' Town
%InventoryItem($75, $0001, $0000, $0000) ; 75 - Map of Tower of Hera
%InventoryItem($76, $0001, $0000, $0000) ; 76 - Map of Ice Palace
%InventoryItem($77, $0001, $0000, $0000) ; 77 - Map of Skull Woods
%InventoryItem($78, $0001, $0000, $0000) ; 78 - Map of Misery Mire
%InventoryItem($79, $0001, $0000, $0000) ; 79 - Map of Dark Palace
%InventoryItem($7A, $0001, $0000, $0000) ; 7A - Map of Swamp Palace
%InventoryItem($7B, $0001, $0000, $0000) ; 7B - Map of Agahnim's Tower
%InventoryItem($7C, $0001, $0000, $0000) ; 7C - Map of Desert Palace
%InventoryItem($7D, $0001, $0000, $0000) ; 7D - Map of Eastern Palace
%InventoryItem($7E, $0001, $0000, $0000) ; 7E - Map of Hyrule Castle
%InventoryItem($7F, $0001, $0000, $0000) ; 7F - Map of Sewers
%InventoryItem($80, $0001, $0000, $0000) ; 80 - Compass of Light World
%InventoryItem($81, $0001, $0000, $0000) ; 81 - Compass of Dark World
%InventoryItem($82, $0001, $0000, $0000) ; 82 - Compass of Ganon's Tower
%InventoryItem($83, $0001, $0000, $0000) ; 83 - Compass of Turtle Rock
%InventoryItem($84, $0001, $0000, $0000) ; 84 - Compass of Thieves' Town
%InventoryItem($85, $0001, $0000, $0000) ; 85 - Compass of Tower of Hera
%InventoryItem($86, $0001, $0000, $0000) ; 86 - Compass of Ice Palace
%InventoryItem($87, $0001, $0000, $0000) ; 87 - Compass of Skull Woods
%InventoryItem($88, $0001, $0000, $0000) ; 88 - Compass of Misery Mire
%InventoryItem($89, $0001, $0000, $0000) ; 89 - Compass of Dark Palace
%InventoryItem($8A, $0001, $0000, $0000) ; 8A - Compass of Swamp Palace
%InventoryItem($8B, $0001, $0000, $0000) ; 8B - Compass of Agahnim's Tower
%InventoryItem($8C, $0001, $0000, $0000) ; 8C - Compass of Desert Palace
%InventoryItem($8D, $0001, $0000, $0000) ; 8D - Compass of Eastern Palace
%InventoryItem($8E, $0001, $0000, $0000) ; 8E - Compass of Hyrule Castle
%InventoryItem($8F, $0001, $0000, $0000) ; 8F - Compass of Sewers
%InventoryItem($90, $0081, $0000, $0000) ; 90 - Skull key
%InventoryItem($91, $0001, $0000, $0000) ; 91 - Reserved
%InventoryItem($92, $0001, $0000, $0000) ; 92 - Big key of Ganon's Tower
%InventoryItem($93, $0001, $0000, $0000) ; 93 - Big key of Turtle Rock
%InventoryItem($94, $0001, $0000, $0000) ; 94 - Big key of Thieves' Town
%InventoryItem($95, $0001, $0000, $0000) ; 95 - Big key of Tower of Hera
%InventoryItem($96, $0001, $0000, $0000) ; 96 - Big key of Ice Palace
%InventoryItem($97, $0001, $0000, $0000) ; 97 - Big key of Skull Woods
%InventoryItem($98, $0001, $0000, $0000) ; 98 - Big key of Misery Mire
%InventoryItem($99, $0001, $0000, $0000) ; 99 - Big key of Dark Palace
%InventoryItem($9A, $0001, $0000, $0000) ; 9A - Big key of Swamp Palace
%InventoryItem($9B, $0001, $0000, $0000) ; 9B - Big key of Agahnim's Tower
%InventoryItem($9C, $0001, $0000, $0000) ; 9C - Big key of Desert Palace
%InventoryItem($9D, $0001, $0000, $0000) ; 9D - Big key of Eastern Palace
%InventoryItem($9E, $0001, $0000, $0000) ; 9E - Big key of Hyrule Castle
%InventoryItem($9F, $0001, $0000, $0000) ; 9F - Big key of Sewers
%InventoryItem($A0, $0041, $0000, SmallKeyCounter) ; A0 - Small key of Sewers
%InventoryItem($A1, $0041, $0000, SmallKeyCounter) ; A1 - Small key of Hyrule Castle
%InventoryItem($A2, $0041, $0000, SmallKeyCounter) ; A2 - Small key of Eastern Palace
%InventoryItem($A3, $0041, $0000, SmallKeyCounter) ; A3 - Small key of Desert Palace
%InventoryItem($A4, $0041, $0000, SmallKeyCounter) ; A4 - Small key of Agahnim's Tower
%InventoryItem($A5, $0041, $0000, SmallKeyCounter) ; A5 - Small key of Swamp Palace
%InventoryItem($A6, $0041, $0000, SmallKeyCounter) ; A6 - Small key of Dark Palace
%InventoryItem($A7, $0041, $0000, SmallKeyCounter) ; A7 - Small key of Misery Mire
%InventoryItem($A8, $0041, $0000, SmallKeyCounter) ; A8 - Small key of Skull Woods
%InventoryItem($A9, $0041, $0000, SmallKeyCounter) ; A9 - Small key of Ice Palace
%InventoryItem($AA, $0041, $0000, SmallKeyCounter) ; AA - Small key of Tower of Hera
%InventoryItem($AB, $0041, $0000, SmallKeyCounter) ; AB - Small key of Thieves' Town
%InventoryItem($AC, $0041, $0000, SmallKeyCounter) ; AC - Small key of Turtle Rock
%InventoryItem($AD, $0041, $0000, SmallKeyCounter) ; AD - Small key of Ganon's Tower
%InventoryItem($AE, $0001, $0000, $0000) ; AE - Reserved
%InventoryItem($AF, $0001, $0000, SmallKeyCounter) ; AF - Generic small key
%InventoryItem($B0, $0080, $0000, $0000) ; B0 - Crystal 6
%InventoryItem($B1, $0080, $0000, $0000) ; B1 - Crystal 1
%InventoryItem($B2, $0080, $0000, $0000) ; B2 - Crystal 5
%InventoryItem($B3, $0080, $0000, $0000) ; B3 - Crystal 7
%InventoryItem($B4, $0080, $0000, $0000) ; B4 - Crystal 2
%InventoryItem($B5, $0080, $0000, $0000) ; B5 - Crystal 4
%InventoryItem($B6, $0080, $0000, $0000) ; B6 - Crystal 3
%InventoryItem($B7, $0000, $0000, $0000) ; B7 - Reserved
%InventoryItem($B8, $0001, $0000, $0000) ; B8 -
%InventoryItem($B9, $0001, $0000, $0000) ; B9 -
%InventoryItem($BA, $0001, $0000, $0000) ; BA -
%InventoryItem($BB, $0001, $0000, $0000) ; BB -
%InventoryItem($BC, $0001, $0000, $0000) ; BC -
%InventoryItem($BD, $0001, $0000, $0000) ; BD -
%InventoryItem($BE, $0001, $0000, $0000) ; BE -
%InventoryItem($BF, $0001, $0000, $0000) ; BF -
%InventoryItem($C0, $0001, $0000, $0000) ; C0 -
%InventoryItem($C1, $0001, $0000, $0000) ; C1 -
%InventoryItem($C2, $0001, $0000, $0000) ; C2 -
%InventoryItem($C3, $0001, $0000, $0000) ; C3 -
%InventoryItem($C4, $0001, $0000, $0000) ; C4 -
%InventoryItem($C5, $0001, $0000, $0000) ; C5 -
%InventoryItem($C6, $0001, $0000, $0000) ; C6 -
%InventoryItem($C7, $0001, $0000, $0000) ; C7 -
%InventoryItem($C8, $0001, $0000, $0000) ; C8 -
%InventoryItem($C9, $0001, $0000, $0000) ; C9 -
%InventoryItem($CA, $0001, $0000, $0000) ; CA -
%InventoryItem($CB, $0001, $0000, $0000) ; CB -
%InventoryItem($CC, $0001, $0000, $0000) ; CC -
%InventoryItem($CD, $0001, $0000, $0000) ; CD -
%InventoryItem($CE, $0001, $0000, $0000) ; CE -
%InventoryItem($CF, $0001, $0000, $0000) ; CF -
%InventoryItem($D0, $0001, $0000, $0000) ; D0 -
%InventoryItem($D1, $0001, $0000, $0000) ; D1 -
%InventoryItem($D2, $0001, $0000, $0000) ; D2 -
%InventoryItem($D3, $0001, $0000, $0000) ; D3 -
%InventoryItem($D4, $0001, $0000, $0000) ; D4 -
%InventoryItem($D5, $0001, $0000, $0000) ; D5 -
%InventoryItem($D6, $0001, $0000, $0000) ; D6 -
%InventoryItem($D7, $0001, $0000, $0000) ; D7 -
%InventoryItem($D8, $0001, $0000, $0000) ; D8 -
%InventoryItem($D9, $0001, $0000, $0000) ; D9 -
%InventoryItem($DA, $0001, $0000, $0000) ; DA -
%InventoryItem($DB, $0001, $0000, $0000) ; DB -
%InventoryItem($DC, $0001, $0000, $0000) ; DC -
%InventoryItem($DD, $0001, $0000, $0000) ; DD -
%InventoryItem($DE, $0001, $0000, $0000) ; DE -
%InventoryItem($DF, $0001, $0000, $0000) ; DF -
%InventoryItem($E0, $0001, $0000, $0000) ; E0 -
%InventoryItem($E1, $0001, $0000, $0000) ; E1 -
%InventoryItem($E2, $0001, $0000, $0000) ; E2 -
%InventoryItem($E3, $0001, $0000, $0000) ; E3 -
%InventoryItem($E4, $0001, $0000, $0000) ; E4 -
%InventoryItem($E5, $0001, $0000, $0000) ; E5 -
%InventoryItem($E6, $0001, $0000, $0000) ; E6 -
%InventoryItem($E7, $0001, $0000, $0000) ; E7 -
%InventoryItem($E8, $0001, $0000, $0000) ; E8 -
%InventoryItem($E9, $0001, $0000, $0000) ; E9 -
%InventoryItem($EA, $0001, $0000, $0000) ; EA -
%InventoryItem($EB, $0001, $0000, $0000) ; EB -
%InventoryItem($EC, $0001, $0000, $0000) ; EC -
%InventoryItem($ED, $0001, $0000, $0000) ; ED -
%InventoryItem($EE, $0001, $0000, $0000) ; EE -
%InventoryItem($EF, $0001, $0000, $0000) ; EF -
%InventoryItem($F0, $0001, $0000, $0000) ; F0 -
%InventoryItem($F1, $0001, $0000, $0000) ; F1 -
%InventoryItem($F2, $0001, $0000, $0000) ; F2 -
%InventoryItem($F3, $0001, $0000, $0000) ; F3 -
%InventoryItem($F4, $0001, $0000, $0000) ; F4 -
%InventoryItem($F5, $0001, $0000, $0000) ; F5 -
%InventoryItem($F6, $0001, $0000, $0000) ; F6 -
%InventoryItem($F7, $0001, $0000, $0000) ; F7 -
%InventoryItem($F8, $0001, $0000, $0000) ; F8 -
%InventoryItem($F9, $0001, $0000, $0000) ; F9 -
%InventoryItem($FA, $0001, $0000, $0000) ; FA -
%InventoryItem($FB, $0001, $0000, $0000) ; FB -
%InventoryItem($FC, $0001, $0000, $0000) ; FC -
%InventoryItem($FD, $0001, $0000, $0000) ; FD -
%InventoryItem($FE, $0001, $0000, $0000) ; FE - Server request (async)
%InventoryItem($FF, $0001, $0000, $0000) ; FF -

ItemReceiptGraphicsOffsets:
	dw $0860                               ; 00 - Fighter Sword and Shield
	dw BigDecompressionBuffer+$11C0        ; 01 - Master Sword
	dw BigDecompressionBuffer+$11C0        ; 01 - Tempered Sword
	dw BigDecompressionBuffer+$11C0        ; 03 - Butter Sword
	dw BigDecompressionBuffer+$09E0        ; 04 - Fighter Shield
	dw BigDecompressionBuffer+$1940        ; 05 - Fire Shield
	dw BigDecompressionBuffer+$0C80        ; 06 - Mirror Shield
	dw BigDecompressionBuffer+$1C80        ; 07 - Fire Rod
	dw BigDecompressionBuffer+$1C80        ; 08 - Ice Rod
	dw BigDecompressionBuffer+$1CA0        ; 09 - Hammer
	dw BigDecompressionBuffer+$1C60        ; 0A - Hookshot
	dw BigDecompressionBuffer+$1C00        ; 0B - Bow
	dw BigDecompressionBuffer+$1DE0        ; 0C - Boomerang
	dw BigDecompressionBuffer+$1CC0        ; 0D - Powder
	dw BigDecompressionBuffer+$09A0        ; 0E - Bottle Refill (bee)
	dw BigDecompressionBuffer+$1440        ; 0F - Bombos
	dw BigDecompressionBuffer+$1400        ; 10 - Ether
	dw BigDecompressionBuffer+$1480        ; 11 - Quake
	dw BigDecompressionBuffer+$10C0        ; 12 - Lamp
	dw BigDecompressionBuffer+$11E0        ; 13 - Shovel
	dw BigDecompressionBuffer+$0C40        ; 14 - Flute
	dw BigDecompressionBuffer+$1C40        ; 15 - Somaria
	dw BigDecompressionBuffer+$14C0        ; 16 - Bottle
	dw BigDecompressionBuffer+$0C00        ; 17 - Heartpiece
	dw BigDecompressionBuffer+$1C40        ; 18 - Byrna
	dw BigDecompressionBuffer+$1100        ; 19 - Cape
	dw BigDecompressionBuffer+$1040        ; 1A - Mirror
	dw BigDecompressionBuffer+$1D40        ; 1B - Glove
	dw BigDecompressionBuffer+$1D40        ; 1C - Mitts
	dw BigDecompressionBuffer+$1D80        ; 1D - Book
	dw BigDecompressionBuffer+$1000        ; 1E - Flippers
	dw BigDecompressionBuffer+$1180        ; 1F - Pearl
	dw BigDecompressionBuffer+$08A0        ; 20 - Crystal
	dw BigDecompressionBuffer+$0860        ; 21 - Net
	dw BigDecompressionBuffer+$1900        ; 22 - Blue Mail
	dw BigDecompressionBuffer+$1900        ; 23 - Red Mail
	dw BigDecompressionBuffer+$1DC0        ; 24 - Small Key
	dw BigDecompressionBuffer+$1140        ; 25 - Compbutt
	dw BigDecompressionBuffer+$18C0        ; 26 - Heart Container from 4/4
	dw BigDecompressionBuffer+$1080        ; 27 - Bomb
	dw BigDecompressionBuffer+$1840        ; 28 - 3 bombs
	dw BigDecompressionBuffer+$1540        ; 29 - Mushroom
	dw BigDecompressionBuffer+$1DE0        ; 2A - Red boomerang
	dw BigDecompressionBuffer+$1500        ; 2B - Full bottle (red)
	dw BigDecompressionBuffer+$1500        ; 2C - Full bottle (green)
	dw BigDecompressionBuffer+$1500        ; 2D - Full bottle (blue)
	dw BigDecompressionBuffer+$1500        ; 2E - Potion refill (red)
	dw BigDecompressionBuffer+$1500        ; 2F - Potion refill (green)
	dw BigDecompressionBuffer+$1500        ; 30 - Potion refill (blue)
	dw BigDecompressionBuffer+$1D00        ; 31 - 10 bombs
	dw BigDecompressionBuffer+$15C0        ; 32 - Big key
	dw BigDecompressionBuffer+$1580        ; 33 - Map
	dw BigDecompressionBuffer+$0800        ; 34 - 1 rupee
	dw BigDecompressionBuffer+$0800        ; 35 - 5 rupees
	dw BigDecompressionBuffer+$0800        ; 36 - 20 rupees
	dw $0820                               ; 37 - Green pendant
	dw BigDecompressionBuffer+$0080        ; 38 - Blue pendant
	dw BigDecompressionBuffer+$0080        ; 39 - Red pendant
	dw BigDecompressionBuffer+$0920        ; 3A - Tossed bow
	dw BigDecompressionBuffer+$08E0        ; 3B - Silver bow
	dw BigDecompressionBuffer+$09A0        ; 3C - Full bottle (bee)
	dw BigDecompressionBuffer+$0960        ; 3D - Full bottle (fairy)
	dw BigDecompressionBuffer+$18C0        ; 3E - Boss heart
	dw BigDecompressionBuffer+$18C0        ; 3F - Sanc heart
	dw BigDecompressionBuffer+$0D20        ; 40 - 100 rupees
	dw BigDecompressionBuffer+$0D60        ; 41 - 50 rupees
	dw BigDecompressionBuffer+$0CC0        ; 42 - Heart
	dw BigDecompressionBuffer+$0D00        ; 43 - Arrow
	dw BigDecompressionBuffer+$1880        ; 44 - 10 arrows
	dw BigDecompressionBuffer+$0CE0        ; 45 - Small magic
	dw BigDecompressionBuffer+$0DA0        ; 46 - 300 rupees
	dw BigDecompressionBuffer+$0000        ; 47 - 20 rupees green
	dw BigDecompressionBuffer+$09A0        ; 48 - Full bottle (good bee)
	dw BigDecompressionBuffer+$1C20        ; 49 - Tossed fighter sword
	dw BigDecompressionBuffer+$0C40        ; 4A - Active Flute
	dw BigDecompressionBuffer+$0040        ; 4B - Boots

	; Rando items
	dw $04A0                               ; 4C - Bomb capacity (50)
	dw $05A0                               ; 4D - Arrow capacity (70)
	dw $01A0                               ; 4E - 1/2 magic
	dw $01E0                               ; 4F - 1/4 magic
	dw $00E0                               ; 50 - Safe master sword
	dw $0420                               ; 51 - Bomb capacity (+5)
	dw $0460                               ; 52 - Bomb capacity (+10)
	dw $0520                               ; 53 - Arrow capacity (+5)
	dw $0560                               ; 54 - Arrow capacity (+10)
	dw $0                                  ; 55 - Programmable item 1
	dw $0                                  ; 56 - Programmable item 2
	dw $0                                  ; 57 - Programmable item 3
	dw $05E0                               ; 58 - Upgrade-only silver arrows
	dw $0                                  ; 59 - Rupoor
	dw $0020                               ; 5A - Nothing
	dw $0DE0                               ; 5B - Red clock
	dw $0DE0                               ; 5C - Blue clock
	dw $0DE0                               ; 5D - Green clock
	dw $0                                  ; 5E - Progressive sword
	dw $0                                  ; 5F - Progressive shield
	dw $0                                  ; 60 - Progressive armor
	dw $0                                  ; 61 - Progressive glove
	dw $0                                  ; 62 - RNG pool item (single)
	dw $0                                  ; 63 - RNG pool item (multi)
	dw $0                                  ; 64 - Progressive bow
	dw $0                                  ; 65 - Progressive bow
	dw $0                                  ; 66 -
	dw $0                                  ; 67 -
	dw $0                                  ; 68 -
	dw $0                                  ; 69 -
	dw $0060                               ; 6A - Triforce
	dw $11E0                               ; 6B - Power star
	dw $0060                               ; 6C - Triforce Piece
	dw $0                                  ; 6D - Server request item
	dw $0                                  ; 6E - Server request item (dungeon drop)
	dw $0                                  ; 6F -

	dw BigDecompressionBuffer+$1580        ; 70 - Map of Light World
	dw BigDecompressionBuffer+$1580        ; 71 - Map of Dark World
	dw BigDecompressionBuffer+$1580        ; 72 - Map of Ganon's Tower
	dw BigDecompressionBuffer+$1580        ; 73 - Map of Turtle Rock
	dw BigDecompressionBuffer+$1580        ; 74 - Map of Thieves' Town
	dw BigDecompressionBuffer+$1580        ; 75 - Map of Tower of Hera
	dw BigDecompressionBuffer+$1580        ; 76 - Map of Ice Palace
	dw BigDecompressionBuffer+$1580        ; 77 - Map of Skull Woods
	dw BigDecompressionBuffer+$1580        ; 78 - Map of Misery Mire
	dw BigDecompressionBuffer+$1580        ; 79 - Map of Dark Palace
	dw BigDecompressionBuffer+$1580        ; 7A - Map of Swamp Palace
	dw BigDecompressionBuffer+$1580        ; 7B - Map of Agahnim's Tower
	dw BigDecompressionBuffer+$1580        ; 7C - Map of Desert Palace
	dw BigDecompressionBuffer+$1580        ; 7D - Map of Eastern Palace
	dw BigDecompressionBuffer+$1580        ; 7E - Map of Hyrule Castle
	dw BigDecompressionBuffer+$1580        ; 7F - Map of Sewers

	dw BigDecompressionBuffer+$1140        ; 80 - Compass of Light World
	dw BigDecompressionBuffer+$1140        ; 81 - Compass of Dark World
	dw BigDecompressionBuffer+$1140        ; 82 - Compass of Ganon's Tower
	dw BigDecompressionBuffer+$1140        ; 83 - Compass of Turtle Rock
	dw BigDecompressionBuffer+$1140        ; 84 - Compass of Thieves' Town
	dw BigDecompressionBuffer+$1140        ; 85 - Compass of Tower of Hera
	dw BigDecompressionBuffer+$1140        ; 86 - Compass of Ice Palace
	dw BigDecompressionBuffer+$1140        ; 87 - Compass of Skull Woods
	dw BigDecompressionBuffer+$1140        ; 88 - Compass of Misery Mire
	dw BigDecompressionBuffer+$1140        ; 89 - Compass of Dark Palace
	dw BigDecompressionBuffer+$1140        ; 8A - Compass of Swamp Palace
	dw BigDecompressionBuffer+$1140        ; 8B - Compass of Agahnim's Tower
	dw BigDecompressionBuffer+$1140        ; 8C - Compass of Desert Palace
	dw BigDecompressionBuffer+$1140        ; 8D - Compass of Eastern Palace
	dw BigDecompressionBuffer+$1140        ; 8E - Compass of Hyrule Castle
	dw BigDecompressionBuffer+$1140        ; 8F - Compass of Sewers
	dw $0                                  ; 90 - Skull key
	dw $0                                  ; 91 - Reserved

	dw BigDecompressionBuffer+$15C0        ; 92 - Big key of Ganon's Tower
	dw BigDecompressionBuffer+$15C0        ; 93 - Big key of Turtle Rock
	dw BigDecompressionBuffer+$15C0        ; 94 - Big key of Thieves' Town
	dw BigDecompressionBuffer+$15C0        ; 95 - Big key of Tower of Hera
	dw BigDecompressionBuffer+$15C0        ; 96 - Big key of Ice Palace
	dw BigDecompressionBuffer+$15C0        ; 97 - Big key of Skull Woods
	dw BigDecompressionBuffer+$15C0        ; 98 - Big key of Misery Mire
	dw BigDecompressionBuffer+$15C0        ; 99 - Big key of Dark Palace
	dw BigDecompressionBuffer+$15C0        ; 9A - Big key of Swamp Palace
	dw BigDecompressionBuffer+$15C0        ; 9B - Big key of Agahnim's Tower
	dw BigDecompressionBuffer+$15C0        ; 9C - Big key of Desert Palace
	dw BigDecompressionBuffer+$15C0        ; 9D - Big key of Eastern Palace
	dw BigDecompressionBuffer+$15C0        ; 9E - Big key of Hyrule Castle
	dw BigDecompressionBuffer+$15C0        ; 9F - Big key of Sewers

	dw BigDecompressionBuffer+$1DC0        ; A0 - Small key of Sewers
	dw BigDecompressionBuffer+$1DC0        ; A1 - Small key of Hyrule Castle
	dw BigDecompressionBuffer+$1DC0        ; A2 - Small key of Eastern Palace
	dw BigDecompressionBuffer+$1DC0        ; A3 - Small key of Desert Palace
	dw BigDecompressionBuffer+$1DC0        ; A4 - Small key of Agahnim's Tower
	dw BigDecompressionBuffer+$1DC0        ; A5 - Small key of Swamp Palace
	dw BigDecompressionBuffer+$1DC0        ; A6 - Small key of Dark Palace
	dw BigDecompressionBuffer+$1DC0        ; A7 - Small key of Misery Mire
	dw BigDecompressionBuffer+$1DC0        ; A8 - Small key of Skull Woods
	dw BigDecompressionBuffer+$1DC0        ; A9 - Small key of Ice Palace
	dw BigDecompressionBuffer+$1DC0        ; AA - Small key of Tower of Hera
	dw BigDecompressionBuffer+$1DC0        ; AB - Small key of Thieves' Town
	dw BigDecompressionBuffer+$1DC0        ; AC - Small key of Turtle Rock
	dw BigDecompressionBuffer+$1DC0        ; AD - Small key of Ganon's Tower
	dw $0                                  ; AE - Reserved
	dw BigDecompressionBuffer+$1DC0        ; AF - Generic small key
	dw BigDecompressionBuffer+$08A0        ; B0 - Crystal 6
	dw BigDecompressionBuffer+$08A0        ; B1 - Crystal 1
	dw BigDecompressionBuffer+$08A0        ; B2 - Crystal 5
	dw BigDecompressionBuffer+$08A0        ; B3 - Crystal 7
	dw BigDecompressionBuffer+$08A0        ; B4 - Crystal 2
	dw BigDecompressionBuffer+$08A0        ; B5 - Crystal 4
	dw BigDecompressionBuffer+$08A0        ; B6 - Crystal 3
	dw $0                                  ; B7 - Reserved
	dw $0                                  ; B8 -
	dw $0                                  ; B9 -
	dw $0                                  ; BA -
	dw $0                                  ; BB -
	dw $0                                  ; BC -
	dw $0                                  ; BD -
	dw $0                                  ; BE -
	dw $0                                  ; BF -
	dw $0                                  ; C0 -
	dw $0                                  ; C1 -
	dw $0                                  ; C2 -
	dw $0                                  ; C3 -
	dw $0                                  ; C4 -
	dw $0                                  ; C5 -
	dw $0                                  ; C6 -
	dw $0                                  ; C7 -
	dw $0                                  ; C8 -
	dw $0                                  ; C9 -
	dw $0                                  ; CA -
	dw $0                                  ; CB -
	dw $0                                  ; CC -
	dw $0                                  ; CD -
	dw $0                                  ; CE -
	dw $0                                  ; CF -
	dw $0                                  ; D0 -
	dw $0                                  ; D1 -
	dw $0                                  ; D2 -
	dw $0                                  ; D3 -
	dw $0                                  ; D4 -
	dw $0                                  ; D5 -
	dw $0                                  ; D6 -
	dw $0                                  ; D7 -
	dw $0                                  ; D8 -
	dw $0                                  ; D9 -
	dw $0                                  ; DA -
	dw $0                                  ; DB -
	dw $0                                  ; DC -
	dw $0                                  ; DD -
	dw $0                                  ; DE -
	dw $0                                  ; DF -
	dw $0                                  ; E0 -
	dw $0                                  ; E1 -
	dw $0                                  ; E2 -
	dw $0                                  ; E3 -
	dw $0                                  ; E4 -
	dw $0                                  ; E5 -
	dw $0                                  ; E6 -
	dw $0                                  ; E7 -
	dw $0                                  ; E8 -
	dw $0                                  ; E9 -
	dw $0                                  ; EA -
	dw $0                                  ; EB -
	dw $0                                  ; EC -
	dw $0                                  ; ED -
	dw $0                                  ; EE -
	dw $0                                  ; EF -
	dw $0                                  ; F0 -
	dw $0                                  ; F1 -
	dw $0                                  ; F2 -
	dw $0                                  ; F3 -
	dw $0                                  ; F4 -
	dw $0                                  ; F5 -
	dw $0                                  ; F6 -
	dw $0                                  ; F7 -
	dw $0                                  ; F8 -
	dw $0                                  ; F9 -
	dw $0                                  ; FA -
	dw $0                                  ; FB -
	dw $0                                  ; FC -
	dw $0                                  ; FD -
	dw $0                                  ; FE - Server request (async)
	dw $0                                  ; FF -

;===================================================================================================
; The table below is for "standing" items, either in heart piece locations, boss heart locations
; or shops etc. Generally we do not and shouldn't use different gfx for this purpose, so this is
; mostly a copy of the previous table. However some items, such as swords, use a separate sprite
; for receipt and non-receipt drawing.
;===================================================================================================
StandingItemGraphicsOffsets:
	dw $0860                               ; 00 - Fighter Sword and Shield
	dw $00E0                               ; 01 - Master Sword
	dw $0120                               ; 02 - Tempered Sword
	dw $0160                               ; 03 - Butter Sword
	dw BigDecompressionBuffer+$09E0        ; 04 - Fighter Shield
	dw BigDecompressionBuffer+$1940        ; 05 - Fire Shield
	dw BigDecompressionBuffer+$0C80        ; 06 - Mirror Shield
	dw BigDecompressionBuffer+$1C80        ; 07 - Fire Rod
	dw BigDecompressionBuffer+$1C80        ; 08 - Ice Rod
	dw BigDecompressionBuffer+$1CA0        ; 09 - Hammer
	dw BigDecompressionBuffer+$1C60        ; 0A - Hookshot
	dw BigDecompressionBuffer+$1C00        ; 0B - Bow
	dw BigDecompressionBuffer+$1DE0        ; 0C - Boomerang
	dw BigDecompressionBuffer+$1CC0        ; 0D - Powder
	dw BigDecompressionBuffer+$09A0        ; 0E - Bottle Refill (bee)
	dw BigDecompressionBuffer+$1440        ; 0F - Bombos
	dw BigDecompressionBuffer+$1400        ; 10 - Ether
	dw BigDecompressionBuffer+$1480        ; 11 - Quake
	dw BigDecompressionBuffer+$10C0        ; 12 - Lamp
	dw BigDecompressionBuffer+$11E0        ; 13 - Shovel
	dw BigDecompressionBuffer+$0C40        ; 14 - Flute
	dw BigDecompressionBuffer+$1C40        ; 15 - Somaria
	dw BigDecompressionBuffer+$14C0        ; 16 - Bottle
	dw BigDecompressionBuffer+$0C00        ; 17 - Heartpiece
	dw BigDecompressionBuffer+$1C40        ; 18 - Byrna
	dw BigDecompressionBuffer+$1100        ; 19 - Cape
	dw BigDecompressionBuffer+$1040        ; 1A - Mirror
	dw BigDecompressionBuffer+$1D40        ; 1B - Glove
	dw BigDecompressionBuffer+$1D40        ; 1C - Mitts
	dw BigDecompressionBuffer+$1D80        ; 1D - Book
	dw BigDecompressionBuffer+$1000        ; 1E - Flippers
	dw BigDecompressionBuffer+$1180        ; 1F - Pearl
	dw BigDecompressionBuffer+$08A0        ; 20 - Crystal
	dw BigDecompressionBuffer+$0860        ; 21 - Net
	dw BigDecompressionBuffer+$1900        ; 22 - Blue Mail
	dw BigDecompressionBuffer+$1900        ; 23 - Red Mail
	dw BigDecompressionBuffer+$1DC0        ; 24 - Small Key
	dw BigDecompressionBuffer+$1140        ; 25 - Compbutt
	dw BigDecompressionBuffer+$18C0        ; 26 - Heart Container from 4/4
	dw BigDecompressionBuffer+$1080        ; 27 - Bomb
	dw BigDecompressionBuffer+$1840        ; 28 - 3 bombs
	dw BigDecompressionBuffer+$1540        ; 29 - Mushroom
	dw BigDecompressionBuffer+$1DE0        ; 2A - Red boomerang
	dw BigDecompressionBuffer+$1500        ; 2B - Full bottle (red)
	dw BigDecompressionBuffer+$1500        ; 2C - Full bottle (green)
	dw BigDecompressionBuffer+$1500        ; 2D - Full bottle (blue)
	dw BigDecompressionBuffer+$1500        ; 2E - Potion refill (red)
	dw BigDecompressionBuffer+$1500        ; 2F - Potion refill (green)
	dw BigDecompressionBuffer+$1500        ; 30 - Potion refill (blue)
	dw BigDecompressionBuffer+$1D00        ; 31 - 10 bombs
	dw BigDecompressionBuffer+$15C0        ; 32 - Big key
	dw BigDecompressionBuffer+$1580        ; 33 - Map
	dw BigDecompressionBuffer+$0800        ; 34 - 1 rupee
	dw BigDecompressionBuffer+$0800        ; 35 - 5 rupees
	dw BigDecompressionBuffer+$0800        ; 36 - 20 rupees
	dw $0820                               ; 37 - Green pendant
	dw BigDecompressionBuffer+$0080        ; 38 - Blue pendant
	dw BigDecompressionBuffer+$0080        ; 39 - Red pendant
	dw BigDecompressionBuffer+$0920        ; 3A - Tossed bow
	dw BigDecompressionBuffer+$08E0        ; 3B - Silvers
	dw BigDecompressionBuffer+$09A0        ; 3C - Full bottle (bee)
	dw BigDecompressionBuffer+$0960        ; 3D - Full bottle (fairy)
	dw BigDecompressionBuffer+$18C0        ; 3E - Boss heart
	dw BigDecompressionBuffer+$18C0        ; 3F - Sanc heart
	dw BigDecompressionBuffer+$0D20        ; 40 - 100 rupees
	dw BigDecompressionBuffer+$0D60        ; 41 - 50 rupees
	dw BigDecompressionBuffer+$0CC0        ; 42 - Heart
	dw BigDecompressionBuffer+$0D00        ; 43 - Arrow
	dw BigDecompressionBuffer+$1880        ; 44 - 10 arrows
	dw BigDecompressionBuffer+$0CE0        ; 45 - Small magic
	dw BigDecompressionBuffer+$0DA0        ; 46 - 300 rupees
	dw BigDecompressionBuffer+$0000        ; 47 - 20 rupees green
	dw BigDecompressionBuffer+$09A0        ; 48 - Full bottle (good bee)
	dw $00A0                               ; 49 - Tossed fighter sword
	dw BigDecompressionBuffer+$0C40        ; 4A - Active Flute
	dw BigDecompressionBuffer+$0040        ; 4B - Boots

	; Rando items
	dw $04A0                               ; 4C - Bomb capacity (50)
	dw $05A0                               ; 4D - Arrow capacity (70)
	dw $01A0                               ; 4E - 1/2 magic
	dw $01E0                               ; 4F - 1/4 magic
	dw $00E0                               ; 50 - Safe master sword
	dw $0420                               ; 51 - Bomb capacity (+5)
	dw $0460                               ; 52 - Bomb capacity (+10)
	dw $0520                               ; 53 - Arrow capacity (+5)
	dw $0560                               ; 54 - Arrow capacity (+10)
	dw $0                                  ; 55 - Programmable item 1
	dw $0                                  ; 56 - Programmable item 2
	dw $0                                  ; 57 - Programmable item 3
	dw $05E0                               ; 58 - Upgrade-only silver arrows
	dw $0                                  ; 59 - Rupoor
	dw $0020                               ; 5A - Nothing
	dw $0DE0                               ; 5B - Red clock
	dw $0DE0                               ; 5C - Blue clock
	dw $0DE0                               ; 5D - Green clock
	dw $0                                  ; 5E - Progressive sword
	dw $0                                  ; 5F - Progressive shield
	dw $0                                  ; 60 - Progressive armor
	dw $0                                  ; 61 - Progressive glove
	dw $0                                  ; 62 - RNG pool item (single)
	dw $0                                  ; 63 - RNG pool item (multi)
	dw $0                                  ; 64 - Progressive bow
	dw $0                                  ; 65 - Progressive bow
	dw $0                                  ; 66 -
	dw $0                                  ; 67 -
	dw $0                                  ; 68 -
	dw $0                                  ; 69 -
	dw $0060                               ; 6A - Triforce
	dw $11E0                               ; 6B - Power star
	dw $0060                               ; 6C - Triforce Piece
	dw $0                                  ; 6D - Server request item
	dw $0                                  ; 6E - Server request item (dungeon drop)
	dw $0                                  ; 6F -

	dw BigDecompressionBuffer+$1580        ; 70 - Map of Light World
	dw BigDecompressionBuffer+$1580        ; 71 - Map of Dark World
	dw BigDecompressionBuffer+$1580        ; 72 - Map of Ganon's Tower
	dw BigDecompressionBuffer+$1580        ; 73 - Map of Turtle Rock
	dw BigDecompressionBuffer+$1580        ; 74 - Map of Thieves' Town
	dw BigDecompressionBuffer+$1580        ; 75 - Map of Tower of Hera
	dw BigDecompressionBuffer+$1580        ; 76 - Map of Ice Palace
	dw BigDecompressionBuffer+$1580        ; 77 - Map of Skull Woods
	dw BigDecompressionBuffer+$1580        ; 78 - Map of Misery Mire
	dw BigDecompressionBuffer+$1580        ; 79 - Map of Dark Palace
	dw BigDecompressionBuffer+$1580        ; 7A - Map of Swamp Palace
	dw BigDecompressionBuffer+$1580        ; 7B - Map of Agahnim's Tower
	dw BigDecompressionBuffer+$1580        ; 7C - Map of Desert Palace
	dw BigDecompressionBuffer+$1580        ; 7D - Map of Eastern Palace
	dw BigDecompressionBuffer+$1580        ; 7E - Map of Hyrule Castle
	dw BigDecompressionBuffer+$1580        ; 7F - Map of Sewers

	dw BigDecompressionBuffer+$1140        ; 80 - Compass of Light World
	dw BigDecompressionBuffer+$1140        ; 81 - Compass of Dark World
	dw BigDecompressionBuffer+$1140        ; 82 - Compass of Ganon's Tower
	dw BigDecompressionBuffer+$1140        ; 83 - Compass of Turtle Rock
	dw BigDecompressionBuffer+$1140        ; 84 - Compass of Thieves' Town
	dw BigDecompressionBuffer+$1140        ; 85 - Compass of Tower of Hera
	dw BigDecompressionBuffer+$1140        ; 86 - Compass of Ice Palace
	dw BigDecompressionBuffer+$1140        ; 87 - Compass of Skull Woods
	dw BigDecompressionBuffer+$1140        ; 88 - Compass of Misery Mire
	dw BigDecompressionBuffer+$1140        ; 89 - Compass of Dark Palace
	dw BigDecompressionBuffer+$1140        ; 8A - Compass of Swamp Palace
	dw BigDecompressionBuffer+$1140        ; 8B - Compass of Agahnim's Tower
	dw BigDecompressionBuffer+$1140        ; 8C - Compass of Desert Palace
	dw BigDecompressionBuffer+$1140        ; 8D - Compass of Eastern Palace
	dw BigDecompressionBuffer+$1140        ; 8E - Compass of Hyrule Castle
	dw BigDecompressionBuffer+$1140        ; 8F - Compass of Sewers
	dw $0                                  ; 90 - Skull key
	dw $0                                  ; 91 - Reserved

	dw BigDecompressionBuffer+$15C0        ; 92 - Big key of Ganon's Tower
	dw BigDecompressionBuffer+$15C0        ; 93 - Big key of Turtle Rock
	dw BigDecompressionBuffer+$15C0        ; 94 - Big key of Thieves' Town
	dw BigDecompressionBuffer+$15C0        ; 95 - Big key of Tower of Hera
	dw BigDecompressionBuffer+$15C0        ; 96 - Big key of Ice Palace
	dw BigDecompressionBuffer+$15C0        ; 97 - Big key of Skull Woods
	dw BigDecompressionBuffer+$15C0        ; 98 - Big key of Misery Mire
	dw BigDecompressionBuffer+$15C0        ; 99 - Big key of Dark Palace
	dw BigDecompressionBuffer+$15C0        ; 9A - Big key of Swamp Palace
	dw BigDecompressionBuffer+$15C0        ; 9B - Big key of Agahnim's Tower
	dw BigDecompressionBuffer+$15C0        ; 9C - Big key of Desert Palace
	dw BigDecompressionBuffer+$15C0        ; 9D - Big key of Eastern Palace
	dw BigDecompressionBuffer+$15C0        ; 9E - Big key of Hyrule Castle
	dw BigDecompressionBuffer+$15C0        ; 9F - Big key of Sewers

	dw BigDecompressionBuffer+$1DC0        ; A0 - Small key of Sewers
	dw BigDecompressionBuffer+$1DC0        ; A1 - Small key of Hyrule Castle
	dw BigDecompressionBuffer+$1DC0        ; A2 - Small key of Eastern Palace
	dw BigDecompressionBuffer+$1DC0        ; A3 - Small key of Desert Palace
	dw BigDecompressionBuffer+$1DC0        ; A4 - Small key of Agahnim's Tower
	dw BigDecompressionBuffer+$1DC0        ; A5 - Small key of Swamp Palace
	dw BigDecompressionBuffer+$1DC0        ; A6 - Small key of Dark Palace
	dw BigDecompressionBuffer+$1DC0        ; A7 - Small key of Misery Mire
	dw BigDecompressionBuffer+$1DC0        ; A8 - Small key of Skull Woods
	dw BigDecompressionBuffer+$1DC0        ; A9 - Small key of Ice Palace
	dw BigDecompressionBuffer+$1DC0        ; AA - Small key of Tower of Hera
	dw BigDecompressionBuffer+$1DC0        ; AB - Small key of Thieves' Town
	dw BigDecompressionBuffer+$1DC0        ; AC - Small key of Turtle Rock
	dw BigDecompressionBuffer+$1DC0        ; AD - Small key of Ganon's Tower
	dw $0                                  ; AE - Reserved
	dw BigDecompressionBuffer+$1DC0        ; AF - Generic small key
	dw BigDecompressionBuffer+$08A0        ; B0 - Crystal 6
	dw BigDecompressionBuffer+$08A0        ; B1 - Crystal 1
	dw BigDecompressionBuffer+$08A0        ; B2 - Crystal 5
	dw BigDecompressionBuffer+$08A0        ; B3 - Crystal 7
	dw BigDecompressionBuffer+$08A0        ; B4 - Crystal 2
	dw BigDecompressionBuffer+$08A0        ; B5 - Crystal 4
	dw BigDecompressionBuffer+$08A0        ; B6 - Crystal 3
	dw $0                                  ; B7 - Reserved
	dw $0                                  ; B8 -
	dw $0                                  ; B9 -
	dw $0                                  ; BA -
	dw $0                                  ; BB -
	dw $0                                  ; BC -
	dw $0                                  ; BD -
	dw $0                                  ; BE -
	dw $0                                  ; BF -
	dw $0                                  ; C0 -
	dw $0                                  ; C1 -
	dw $0                                  ; C2 -
	dw $0                                  ; C3 -
	dw $0                                  ; C4 -
	dw $0                                  ; C5 -
	dw $0                                  ; C6 -
	dw $0                                  ; C7 -
	dw $0                                  ; C8 -
	dw $0                                  ; C9 -
	dw $0                                  ; CA -
	dw $0                                  ; CB -
	dw $0                                  ; CC -
	dw $0                                  ; CD -
	dw $0                                  ; CE -
	dw $0                                  ; CF -
	dw $0                                  ; D0 -
	dw $0                                  ; D1 -
	dw $0                                  ; D2 -
	dw $0                                  ; D3 -
	dw $0                                  ; D4 -
	dw $0                                  ; D5 -
	dw $0                                  ; D6 -
	dw $0                                  ; D7 -
	dw $0                                  ; D8 -
	dw $0                                  ; D9 -
	dw $0                                  ; DA -
	dw $0                                  ; DB -
	dw $0                                  ; DC -
	dw $0                                  ; DD -
	dw $0                                  ; DE -
	dw $0                                  ; DF -
	dw $0                                  ; E0 -
	dw $0                                  ; E1 -
	dw $0                                  ; E2 -
	dw $0                                  ; E3 -
	dw $0                                  ; E4 -
	dw $0                                  ; E5 -
	dw $0                                  ; E6 -
	dw $0                                  ; E7 -
	dw $0                                  ; E8 -
	dw $0                                  ; E9 -
	dw $0                                  ; EA -
	dw $0                                  ; EB -
	dw $0                                  ; EC -
	dw $0                                  ; ED -
	dw $0                                  ; EE -
	dw $0                                  ; EF -
	dw $0                                  ; F0 -
	dw $0                                  ; F1 -
	dw $0                                  ; F2 -
	dw $0                                  ; F3 -
	dw $0                                  ; F4 -
	dw $0                                  ; F5 -
	dw $0                                  ; F6 -
	dw $0                                  ; F7 -
	dw $0                                  ; F8 -
	dw $0                                  ; F9 -
	dw $0                                  ; FA -
	dw $0                                  ; FB -
	dw $0                                  ; FC -
	dw $0                                  ; FD -
	dw $0                                  ; FE - Server request (async)
	dw $0                                  ; FF -
