class_name Pawn extends ChessManTemplate

func visible(pos, board):
	var visible_squares = []
	
	var pos_f = pos[0].unicode_at(0)
	var pos_r = pos[1].unicode_at(0)
	
	var dir_f = 0
	
	if board.board[pos].team == "white":
		dir_f = 1
	else:
		dir_f = -1
	
	for dir_r in [-1, 1]:
		var new_pos = String(char(pos_f + dir_r) + char(pos_r + dir_f))
		if board.valid_pos(new_pos):
			visible_squares.append(new_pos)
	
	return visible_squares

func movable(pos, board):
	var diagonals = visible(pos, board)
	var possible = []
	
	for square in diagonals:
		if board.board[square].team != self.team and board.board[square].team != "" or square == board.en_passant_square:
			possible.append(square)
	
	# Now get jumps and en passant rules
	var pos_f = pos[0].unicode_at(0)
	var pos_r = pos[1].unicode_at(0)
	
	var dir_f = 0
	
	if board.board[pos].team == "white":
		dir_f = 1
	else:
		dir_f = -1
	
	if board.valid_pos(String(char(pos_f) + char(pos_r + dir_f))) and board.board[String(char(pos_f) + char(pos_r + dir_f))].name == "":
		possible.append(String(char(pos_f) + char(pos_r + dir_f)))
		if pos[1] in "27":
			if board.board[String(char(pos_f) + char(pos_r + (2*dir_f)))].name == "":
				possible.append(String(char(pos_f) + char(pos_r + (2*dir_f))))
	
	for p in possible.size():
		if board.board[possible[p]].name == "duck":
			possible.pop_at(p)
			break
			
	return possible

func _init(team):
	super(team, "pawn", "p")
