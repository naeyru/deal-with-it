extends Area2D

# Textures
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

var pos = ""  # e.g. a1, f7
var square_color = Color("#ffffff")  # Color object
var hover_color = Color("#ffff00")
var selected_color = Color("#ff0000")
var selected = false
var color_selected = false
var piece = "pawn"
var team = "white"
var label = null
var mouse_hovering = false
var texture_index = String(team + "_" + piece)
var dist = 50


func change_color(new_color = self.square_color):
	self.square_color = new_color


func _on_mouse_entered():
	self.mouse_hovering = true


func _on_mouse_exited():
	self.mouse_hovering = false


func _ready():
	$Label.text = "Location: " + self.pos
	$Label.visible = false


func _process(delta):  # Do all that needs to be done
	if self.color_selected:
		$SquareColor.modulate = self.selected_color
	
	if self.mouse_hovering:
		if not self.color_selected:
			$SquareColor.modulate = self.hover_color
		$Label.position = get_viewport().get_mouse_position() - Vector2(ProjectSettings.get_setting("display/window/size/viewport_width"), ProjectSettings.get_setting("display/window/size/viewport_height"))/2 + Vector2(15, 15)
		$Label.visible = true
	else:
		if not self.color_selected:
			$SquareColor.modulate = self.square_color
		$Label.visible = false
	
	if Input.is_action_just_pressed("ui_select") and self.mouse_hovering:
		self.selected = not self.selected
	
	$ChessPieceVisual.texture = self.textures[self.texture_index]
