@tool
extends Button
@onready var play_game = preload("res://Subscenes/root.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_print_hello_pressed():
	print("Hello from the main screen plugin!")
	pass


func _on_pressed():
	print("Hello from the main screen plugin!")
	var game = play_game.instantiate()
	add_child(game)
	pass # Replace with function body.
