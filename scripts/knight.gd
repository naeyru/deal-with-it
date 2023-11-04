class_name Knight extends ChessManTemplate

func visible(pos, board):
	var visible_squares = []
	
	var pos_f = pos[0].unicode_at(0)
	var pos_r = pos[1].unicode_at(0)
	
	for f_dir in [-2, 2]:
		for r_dir in [-1, 1]:
			var npos_f = pos_f + f_dir
			var npos_r = pos_r + r_dir
			var new_pos = String(char(npos_f) + char(npos_r))
		
			if board.valid_pos(new_pos):
				visible_squares.append(new_pos)
	
	for f_dir in [-1, 1]:
		for r_dir in [-2, 2]:
			var npos_f = pos_f + f_dir
			var npos_r = pos_r + r_dir
			var new_pos = String(char(npos_f) + char(npos_r))
		
			if board.valid_pos(new_pos):
				visible_squares.append(new_pos)
	
	return visible_squares

func movable(pos, board):
	var possible = self.visible(pos, board)
	var movable = []

	for piece in possible:
		if board.board[piece].team != self.team:
			movable.append(piece)
	
	return movable

func _init(team):
	super(team, "knight", "n")
