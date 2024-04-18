extends Node2D
@export var Camera : Node2D
@export var target : Node2D
# Called when the node enters the scene tree for the first time.
func _ready():
	print("trying to find stuff")
	print(target.name)
	print(Camera.name)
	target = get_parent().find_child("Player")
	Camera = get_child(0)
	pass

func switch_target(new_target):
	target = new_target
	global_position = new_target.global_position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_position = target.position
