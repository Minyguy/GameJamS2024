extends Node2D

@onready var player_path = preload("res://Subscenes/player.tscn")
@onready var enemy_path = preload("res://Subscenes/player.tscn")
@onready var camera_tracker_path = preload("res://Subscenes/camera_tracker.tscn")
@onready var portal_controller_path = preload("res://Subscenes/portal.tscn")

@export var spawn_point : Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_entity_teleport(object):
	print(object.name + " SHOULD BE TELEPORTED")
	pass
