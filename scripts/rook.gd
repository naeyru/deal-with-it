class_name Rook extends ChessManTemplate

func visible(pos, board):
	var visible_squares = []
	
	var pos_f = pos[0].unicode_at(0)
	var pos_r = pos[1].unicode_at(0)
	
	for f_dir in [-1, 1]:
		var npos_f = pos_f + f_dir
		var new_pos = String(char(npos_f) + char(pos_r))
		
		while board.valid_pos(new_pos):
			visible_squares.append(new_pos)
			if board.board[new_pos].name != "":
				break
			npos_f += f_dir
			new_pos = String(char(npos_f) + char(pos_r))
	
	for r_dir in [-1, 1]:
		var npos_r = pos_r + r_dir
		var new_pos = String(char(pos_f) + char(npos_r))
		
		while board.valid_pos(new_pos):
			visible_squares.append(new_pos)
			if board.board[new_pos].name != "":
				break
			npos_r += r_dir
			new_pos = String(char(pos_f) + char(npos_r))
	
	return visible_squares


func movable(pos, board):
	var possible = self.visible(pos, board)
	var movable = []

	for piece in possible:
		if board.board[piece].team != self.team:
			movable.append(piece)
	
	return movable

func _init(team):
	super(team, "rook", "r")
