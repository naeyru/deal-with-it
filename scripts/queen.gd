class_name Queen extends ChessManTemplate

func visible(pos, board):
	return Rook.new("").visible(pos, board) + Bishop.new("").visible(pos, board)

func movable(pos, board):
	var possible = self.visible(pos, board)
	var movable = []

	for piece in possible:
		if board.board[piece].team != self.team:
			movable.append(piece)
	
	return movable

func _init(team):
	super(team, "queen", "q")
