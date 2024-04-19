extends Node2D

@onready var player_path = preload("res://Subscenes/player.tscn")
@onready var enemy_path = preload("res://Subscenes/player.tscn")
@onready var camera_tracker_path = preload("res://Subscenes/camera_tracker.tscn")
@onready var portal_controller_path = preload("res://Subscenes/portal.tscn")

@export var spawn_point : Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	var Camera_border = find_child("CameraBorderBottomRight")
	var Camera = find_child("Camera_tracker")
	Camera.set_new_limits(0, 0, Camera_border.global_position.x, Camera_border.global_position.y)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_entity_teleport(object):
	print(object.name + " SHOULD BE TELEPORTED")
	pass


func _on_goal_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if body.name == "Player":
		get_parent()._back_to_menu(true)
	pass # Replace with function body.
