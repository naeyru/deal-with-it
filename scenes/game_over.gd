extends Node2D


var game_over_text = "Game Over!"

# Called when the node enters the scene tree for the first time.
func _ready():
	$Label.text = game_over_text


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_play_again_pressed():
	get_tree().change_scene_to_file("res://scenes/main_game.tscn")


func _on_main_menu_pressed():
	get_tree().change_scene_to_file("res://scenes/start_menu.tscn")
