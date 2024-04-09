extends Node2D
@onready var Camera = find_child("Camera2D")
@onready var target = %Player
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func switch_target(new_target):
	target = new_target
	global_position = new_target.global_position
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_position = target.position
