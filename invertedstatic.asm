;Statically mapped at $A1A000 Referenced by the front end. Do not move without coordination.
InvertedTileAttributeLookup:
	SEP #$20
	LDA.b OverworldIndex : CMP.b #$47 : BEQ .turtleRock
	LDA.l Overworld_TileAttr, X
	JML.l Overworld_GetTileAttrAtLocation_continue
.turtleRock
	LDA.l Inverted_TR_TileAttributes, X
	JML.l Overworld_GetTileAttrAtLocation_continue
