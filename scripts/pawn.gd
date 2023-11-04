class_name Pawn extends ChessManTemplate

func visible(pos, board):
	pass

func movable(pos, board):
	pass

func _init(team):
	super(team, "pawn", "p")
