class_name ChessBoard

var files = "abcdefgh"
var ranks = "12345678"

var active_turn = ""  # Should be w or b
var castle = ""
var en_passant_square = ""  # Should be - or square
var full_moves = 1
var board = {}


# Load fen, important for state management
func load_fen(fen):
	var fen_parsed = fen.split(' ')
	var fen_pieces = fen_parsed[0].split('/')
	
	var r = 9
	
	for rank in fen_pieces:
		r -= 1
		var f = 1
		
		for piece in rank:
			if piece.to_lower() not in "kqrbnpd":
				for i in int(piece):
					self.board[String(char(f+96) + str(r))] = Empty.new()
					f += 1
			else:
				var temp = piece.to_lower()
				var team = ""
				
				if temp == piece:
					team = "black"
				else:
					team = "white"
				
				var location = String(char(f+96) + str(r))
				
				if temp == "k":
					self.board[location] = King.new(team)
				elif temp == "q":
					self.board[location] = Queen.new(team)
				elif temp == "r":
					self.board[location] = Rook.new(team)
				elif temp == "b":
					self.board[location] = Bishop.new(team)
				elif temp == "n":
					self.board[location] = Knight.new(team)
				elif temp == "p":
					self.board[location] = Pawn.new(team)
				elif temp == "d":
					self.board[location] = Duck.new()
				
				f += 1
	
	self.active_turn = fen_parsed[1]
	self.castle = fen_parsed[2]
	self.en_passant_square = fen_parsed[3]
	self.full_moves = fen_parsed[5]


# Save fen, integral for state management
func save_fen():
	var fen = ""
	
	for r in "87654321":  # Ranks
		var n = 0
		
		for f in "abcdefgh":  # Files
			var location = f + r
			
			if self.board[location].name == "":
				n += 1
			else:
				if n > 0:
					fen += str(n)
					n = 0
				
				if self.board[location].team == "white":
					fen += self.board[location].notation.to_upper()
				else:
					fen += self.board[location].notation

		if n > 0:
			fen += str(n)
		
		if r != '1':
			fen += '/'

	fen += ' ' + self.active_turn + ' ' + self.castle + ' ' \
			+ self.en_passant_square + ' - ' + self.full_moves
	
	return fen


func visible_pieces(pos):
	var visible = []
	var temp_visible = []
	
	# Queens/Rooks
	temp_visible = Rook.new("").visible(pos, self)
	for square in temp_visible:
		if self.board[square].name in ["queen", "rook"]:
			visible.append(square)
	
	# Queens/Bishops
	temp_visible = Bishop.new("").visible(pos, self)
	for square in temp_visible:
		if self.board[square].name in ["queen", "bishop"]:
			visible.append(square)

	# Knights
	temp_visible = Knight.new("").visible(pos, self)
	for square in temp_visible:
		if self.board[square].name == "knight":
			visible.append(square)
	
	# King
	temp_visible = King.new("").visible(pos, self)
	for square in temp_visible:
		if self.board[square].name == "king":
			visible.append(square)
	
	# Pawn
	var diagonals = []
	
	var pos_f = pos[0].unicode_at(0)
	var pos_r = pos[1].unicode_at(0)
	
	for dir_f in [-1, 1]:
		for dir_r in [-1, 1]:
			if self.valid_pos(String(char(pos_f + dir_f) + char(pos_r + dir_r))):
				diagonals.append(String(char(pos_f + dir_f) + char(pos_r + dir_r)))
	
	for npos in diagonals:
		if self.board[npos].name == "pawn" and pos in self.board[npos].visible(npos, self):
			visible.append(npos)
	
	return visible


func attacking_pieces(pos, team):  # Is pos being attacked by team?
	var attacking = []
	var visible = self.visible_pieces(pos)
	
	for piece in visible:
		if self.board[piece].team == team:
			attacking.append(piece)
	
	return attacking


func is_check(team):
	var king_pos = ""
	var attacker = ""

	for r in ranks:
		for f in files:
			if self.board[f+r].team == team and self.board[f+r].name == "king":
				king_pos = f + r
	
	if team == "white":
		attacker = "black"
	else:
		attacker = "white"
	
	if self.attacking_pieces(king_pos, attacker) != []:
		return true
	
	return false


func move(pos, newpos):
	self.board[newpos] = self.board[pos]
	self.board[pos] = Empty.new()


func get_legal_moves_at(pos):
	var legal = []
	var new_board = ChessBoard.new()
	var team = ""
	
	for newpos in self.board[pos].movable(pos, self):
		new_board.load_fen(self.save_fen())
		new_board.move(pos, newpos)
		team = new_board.board[newpos].team
		
		if not new_board.is_check(team):
			legal.append(newpos)
	
	return legal

func set_piece(location, piece):
	var temp = piece.to_lower()
	var team = ""
	
	if temp == piece:
		team = "black"
	else:
		team = "white"
	
	if temp == "k":
		self.board[location] = King.new(team)
	elif temp == "q":
		self.board[location] = Queen.new(team)
	elif temp == "r":
		self.board[location] = Rook.new(team)
	elif temp == "b":
		self.board[location] = Bishop.new(team)
	elif temp == "n":
		self.board[location] = Knight.new(team)
	elif temp == "p":
		self.board[location] = Pawn.new(team)
	elif temp == "d":
		self.board[location] = Duck.new()

func safe_move(pos, newpos):
	var legal = self.get_legal_moves_at(pos)
	
	if self.active_turn == "w" and self.board[pos].team == "black":
		return false
	elif self.active_turn == "b" and self.board[pos].team == "white":
		return false
	
	if newpos in legal:
		self.move(pos, newpos)
		if self.board[newpos].name == "pawn":
			if newpos == self.en_passant_square:
				self.board[String(newpos[0] + pos[1])] = Empty.new()
				self.en_passant_square = "-"
			elif abs(int(pos[1]) - int(newpos[1])) == 2:
				if self.active_turn == "w":
					self.en_passant_square = String(newpos[0] + char(newpos[1].unicode_at(0) - 1))
				else:
					self.en_passant_square = String(newpos[0] + char(newpos[1].unicode_at(0) + 1))
			else:
				self.en_passant_square = "-"
		else:
			self.en_passant_square = "-"
				
		
		if self.active_turn == "w":  # DO CASTLING LOGIC HERE
			# King move: no castle opportunities
			if self.board[newpos].name == "king":
				var newcastle = ""
				for m in self.castle:
					if m not in "KQ":
						newcastle += m
				self.castle = newcastle
				
				# Rook move: no castle on side
			if self.board[newpos].name == "rook":
				var newcastle = ""
				for m in self.castle:
					var bad_side = ""
					if pos[0] == "a":
						bad_side = "K"
					else:
						bad_side = "Q"
					
					if m != bad_side:
						newcastle += m
				self.castle = newcastle
				
			self.active_turn = "b"
		else:
			# King move: no castle opportunities
			if self.board[newpos].name == "king":
				var newcastle = ""
				for m in self.castle:
					if m not in "kq":
						newcastle += m
				self.castle = newcastle
				
				# Rook move: no castle on side
			if self.board[newpos].name == "rook":
				var newcastle = ""
				for m in self.castle:
					var bad_side = ""
					if pos[0] == "a":
						bad_side = "k"
					else:
						bad_side = "q"
					
					if m != bad_side:
						newcastle += m
				self.castle = newcastle
			
			self.active_turn = "w"
			self.full_moves = str(int(self.full_moves) + 1)
		
		return true
	
	return false


func get_pieces_of_team(team):
	var pieces = []
	
	for r in ranks:
		for f in files:
			if self.board[f+r].team == team:
				pieces.append(f+r)
	
	return pieces


func get_legal_moves_of_team(team):
	var team_pieces = self.get_pieces_of_team(team)
	var moves = []
	
	for piece in team_pieces:
		moves += get_legal_moves_at(piece)
	
	return moves


func is_checkmate(team):  # Is team in checkmate?
	var team_pieces = self.get_pieces_of_team(team)
	
	if self.get_legal_moves_of_team(team) == [] and self.is_check(team):
		return true
		
	return false


func is_stalemate(team):
	var team_pieces = self.get_pieces_of_team(team)
	
	if self.get_legal_moves_of_team(team) == [] and not self.is_check(team):
		return true
		
	return false


func valid_pos(pos):
	if pos[0] not in files or pos[1] not in ranks:
		return false
	return true


# Initialize with default game
func _init(fen="rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1"):
	self.load_fen(fen)


func print_pieces():
	for i in self.board:
		if self.board[i].team != "":
			print(i, ":\n", self.board[i])


func print_board_info():
	print("Active turn: ", self.active_turn, "\nEn Passant Square: ", self.en_passant_square, "\nCastle: ", self.castle, "\nMoves: ", self.full_moves, "\n")
