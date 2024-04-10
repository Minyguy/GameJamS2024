extends Control
@onready var play_game = preload("res://Subscenes/root.tscn")
@onready var in_menu = true
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_pressed():
	if(in_menu):
		print("Hello from the main screen plugin!")
		var game = play_game.instantiate()
		add_child(game)
		in_menu = false
		pass # Replace with function body.
