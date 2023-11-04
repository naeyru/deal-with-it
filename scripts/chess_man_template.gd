# Template class
class_name ChessManTemplate

var team = ""
var name = ""
var notation = ""

func visible(pos, board): # Returns all pieces a piece can "see"
	pass

func movable(pos, board):  # Returns all possible piece movement opportunities
	pass

func _init(team="", name="", notation=""):
	self.team = team
	self.name = name
	self.notation = notation

func _to_string():
	return String("Type: " + self.name + "\nTeam: " + self.team + "\n")
