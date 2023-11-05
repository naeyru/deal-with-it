extends Node2D

var files = "abcdefgh"
var ranks = "12345678"
var ranks_reverse = "87654321"

var visual_board = {}
var board = ChessBoard.new()
var chess_square = preload("res://scenes/chess_square.tscn")

var first_selected = ""
var second_selected = ""

var textures = {
	"black_bishop": preload("res://media/pieces/dark_bishop.svg"),
	"black_king": preload("res://media/pieces/dark_king.svg"),
	"black_queen": preload("res://media/pieces/dark_queen.svg"),
	"black_rook": preload("res://media/pieces/dark_rook.svg"),
	"black_knight": preload("res://media/pieces/dark_knight.svg"),
	"black_pawn": preload("res://media/pieces/dark_pawn.svg"),
	"white_bishop": preload("res://media/pieces/light_bishop.svg"),
	"white_king": preload("res://media/pieces/light_king.svg"),
	"white_queen": preload("res://media/pieces/light_queen.svg"),
	"white_rook": preload("res://media/pieces/light_rook.svg"),
	"white_knight": preload("res://media/pieces/light_knight.svg"),
	"white_pawn": preload("res://media/pieces/light_pawn.svg"),
	"duck": preload("res://media/pieces/duck.svg"),
	"empty": preload("res://media/pieces/empty.png")
}


# FEN
func vis_load_fen(fen):
	var fen_parsed = fen.split(' ')
	var fen_pieces = fen_parsed[0].split('/')
	
	var r = 9
	
	for rank in fen_pieces:
		r -= 1
		var f = 1
		
		for piece in rank:
			if piece.to_lower() not in "kqrbnpd":
				for i in int(piece):
					self.visual_board[String(char(f+96) + str(r))].texture_index = "empty"
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
					self.visual_board[location].texture_index = team + "_king"
				elif temp == "q":
					self.visual_board[location].texture_index = team + "_queen"
				elif temp == "r":
					self.visual_board[location].texture_index = team + "_rook"
				elif temp == "b":
					self.visual_board[location].texture_index = team + "_bishop"
				elif temp == "n":
					self.visual_board[location].texture_index = team + "_knight"
				elif temp == "p":
					self.visual_board[location].texture_index = team + "_pawn"
				elif temp == "d":
					self.visual_board[location].texture_index = "duck"
				
				f += 1


func init_empty_board():
	var light_color = Color("#ccffff")
	var dark_color = Color("#333333")
	var light = true
	var dist = 50
	for r in ranks_reverse.length():
		for f in files.length():
			var str_pos = String(files[f] + ranks_reverse[r])
			visual_board[str_pos] = chess_square.instantiate()
			visual_board[str_pos].position += Vector2(f - 3.5, r - 3.5) * dist
			visual_board[str_pos].pos = str_pos
			
			if light:
				visual_board[str_pos].square_color = light_color
			else:
				visual_board[str_pos].square_color = dark_color
			
			light = not light
			
			add_child(visual_board[str_pos])
		light = not light
	
	self.vis_load_fen(self.board.save_fen())
	

# Called when the node enters the scene tree for the first time.
func _ready():
	init_empty_board()
	self.vis_load_fen(self.board.save_fen())


# Signal
signal square_selected(pos)
signal win_game(team)  # Who won?

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Input
	for r in ranks:
		for f in files:
			if visual_board[f + r].selected:
				square_selected.emit(f + r)
				visual_board[f + r].selected = false


func _on_square_selected(pos):
	if first_selected == "":
		self.first_selected = pos
	elif first_selected == pos:
		self.first_selected = ""
	else:
		self.second_selected = pos
		self.board.safe_move(self.first_selected, self.second_selected)
		self.vis_load_fen(self.board.save_fen())
		
		# Mate detection. HEAVY.
		var temp_search_w = board.get_pieces_of_team("white")
		var temp_search_b = board.get_pieces_of_team("black")
		var white_king = null
		var black_king = null
		
		for r in ranks:
			for f in files:
				if board.board[f + r].name == "king":
					if board.board[f + r].team == "white":
						white_king = f + r
					else:
						black_king = f + r
				
		if self.board.active_turn == "w" and board.get_legal_moves_at(white_king) == []:
			if self.board.is_checkmate("white"):
				win_game.emit("black")
			elif self.board.is_stalemate("white"):
				win_game.emit("white")
		elif board.get_legal_moves_at(black_king) == []:
			if self.board.is_checkmate("black"):
				win_game.emit("white")
			elif self.board.is_stalemate("black"):
				win_game.emit("")
			
		self.board.print_board_info()
		self.first_selected = ""
		self.second_selected = ""


func _on_win_game(team):
	print("fucking nerd lmao")
