extends Node2D
@export var Camera : Camera2D
@export var target : Node2D
@onready var base_limit_top : int
@onready var base_limit_right : int
@onready var base_limit_bot : int
@onready var base_limit_left : int

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
	if base_limit_bot != null:
		Camera.limit_bottom = base_limit_bot
	if base_limit_right != null:
		Camera.limit_right = base_limit_right
	if base_limit_top != null:
		Camera.limit_top = base_limit_top
	if base_limit_left != null:
		Camera.limit_left = base_limit_left 

func set_new_limits(camera_limit_left, camera_limit_top, camera_limit_right, camera_limit_bot):
	base_limit_left = camera_limit_left
	base_limit_top = camera_limit_top
	base_limit_right = camera_limit_right
	base_limit_bot = camera_limit_bot
