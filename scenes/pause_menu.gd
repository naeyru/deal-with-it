extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	self.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		self.visible = not self.visible


func _on_resume_pressed():
	self.visible = not self.visible


func _on_restart_pressed():
	get_tree().change_scene_to_file("res://scenes/main_game.tscn")


func _on_main_menu_pressed():
	get_tree().change_scene_to_file("res://scenes/start_menu.tscn")
