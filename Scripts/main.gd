extends Control
@onready var sandbox = preload("res://Subscenes/sandbox.tscn")
@onready var level_1 = preload("res://Subscenes/level_1.tscn")
@onready var in_menu = true
@onready var in_select = false
var game
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_pressed():
	if(in_menu):
		print("Hello from the main screen plugin!")
		in_menu = false
		%MenuContainer.visible = false
		%level_select.visible = true
		pass # Replace with function body.

func _back_to_menu():
	game.free()
	%MenuContainer.visible = true
	in_menu = true


func _on_button_1_pressed():
	game = level_1.instantiate()
	add_child(game)
	%level_select.visible = false
