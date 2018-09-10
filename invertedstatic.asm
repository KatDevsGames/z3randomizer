;Statically mapped at $A1A000 Referenced by the front end. Do not move without coordination.
InvertedTileAttributeLookup:
	SEP #$20
	LDA $8A	: CMP.b #$47 : BEQ .turtleRock
	LDA Overworld_TileAttr, X
	JML.l Overworld_GetTileAttrAtLocation_continue
.turtleRock
	LDA Inverted_TR_TileAttributes, X
	JML.l Overworld_GetTileAttrAtLocation_continue
