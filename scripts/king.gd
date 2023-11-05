class_name King extends ChessManTemplate

func visible(pos, board=null):
	var visible_squares = []
	
	var pos_f = pos[0].unicode_at(0)
	var pos_r = pos[1].unicode_at(0)
	
	for r in [-1, 0, 1]:
		for f in [-1, 0, 1]:
			var new_pos = String(char(pos_f + f) + char(pos_r + r))
			if new_pos != pos and ChessBoard.new().valid_pos(new_pos):
				visible_squares.append(new_pos)
	
	return visible_squares

func movable(pos, board):
	var possible = self.visible(pos, board)
	var movable = []

	for piece in possible:
		if board.board[piece].team != self.team and board.board[piece].name != "duck":
			movable.append(piece)
	
	return movable

func _init(team):
	super(team, "king", "k")
