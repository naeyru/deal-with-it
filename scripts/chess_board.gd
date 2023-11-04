class_name ChessBoard

var files = "abcdefgh"
var ranks = "12345678"


var board = {}


func _init(fen="rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1"):
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
					self.board[location] = Duck.new(team)
				
				f += 1

func out_board():
	for i in self.board:
		if self.board[i].team != "":
			print(i, ":\n", self.board[i])
