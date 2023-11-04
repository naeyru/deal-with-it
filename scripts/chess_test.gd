@tool
extends EditorScript


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	print("Hello!")

# Custom code

func main():
	var myboard = ChessBoard.new()
	myboard.out_board()

func _run():
	main()
