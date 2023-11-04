extends Button


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://scenes/chess_board.tscn")

func _on_card_view_button_pressed():
	get_tree().change_scene_to_file("res://scenes/card_viewer.tscn")

func _on_exit_button_pressed():
	get_tree().quit()
