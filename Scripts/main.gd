extends Control
@onready var sandbox = preload("res://Subscenes/sandbox.tscn")
@onready var level_1 = preload("res://Subscenes/level_1.tscn")
@onready var level_2 = preload("res://Subscenes/level_2.tscn")
@onready var level_3 = preload("res://Subscenes/level_3.tscn")
@onready var level_4 = preload("res://Subscenes/level_4.tscn")
@onready var level_5 = preload("res://Subscenes/level_5.tscn")
@onready var in_menu = true
@onready var in_select = false



var game
var level
var level_button : Button
var restart : bool = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if restart:
		game = level.instantiate()
		add_child(game)
		restart = false


func _on_button_pressed():
	if(in_menu):
		print("Hello from the main screen plugin!")
		in_menu = false
		%MenuContainer.visible = false
		%level_select.visible = true
		pass # Replace with function body.

func _back_to_menu(did_player_win):
	%MenuContainer.visible = true
	in_menu = true
	if did_player_win:
		%MenuContainer.visible = false
		%level_select.visible = true
		var win_icon : Texture2D = %WinButton.get_button_icon()
		level_button.set_button_icon(win_icon)
	game.queue_free()

func reset_level():
	game.queue_free()
	restart = true

func _on_button_1_pressed():
	game = level_1.instantiate()
	level = level_1
	level_button = %Button1
	add_child(game)
	%level_select.visible = false


func _on_button_2_pressed():
	game = level_2.instantiate()
	level = level_2
	level_button = %Button2
	add_child(game)
	%level_select.visible = false


func _on_button_3_pressed():
	game = level_3.instantiate()
	level = level_3
	level_button = %Button3
	add_child(game)
	%level_select.visible = false


func _on_button_4_pressed():
	game = level_4.instantiate()
	level = level_4
	level_button = %Button4
	add_child(game)
	%level_select.visible = false



func _on_button_5_pressed():
	game = level_5.instantiate()
	level = level_5
	level_button = %Button5
	add_child(game)
	%level_select.visible = false
