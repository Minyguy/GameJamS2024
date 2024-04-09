extends Area2D

@onready var player = %Player
@onready var camera = %Camera_tracker
@onready var direction := Vector2(0, 0)
@onready var ground = %TileMap
@onready var worming := false
@onready var moving := false
@onready var speed = 200

@onready var PortalDoor = preload("res://Subscenes/portal.tscn")

@onready var PortalList : Node2D 

func start_worming(new_position):
	scale = Vector2(0.1, 0.1)
	visible = true
	worming = true
	moving = false
	position = new_position
	direction = position.direction_to(player.position)*-1
	
	var portal_instance = PortalDoor.instantiate()
	
	add_sibling(portal_instance)
	portal_instance.global_position = global_position

# Called when the node enters the scene tree for the first time.
func _ready():
	#visible = false
	print("PORTAL IS SPAWNED")
	print(position)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rotation -= 2*delta
	if rotation < 0:
		rotation += 2*PI
	pass
	
	if worming:
		if moving:
			direction = direction.move_toward(position.direction_to(get_global_mouse_position()),0.05).normalized()
			position += direction*speed*delta
			
			var map_coords = ground.local_to_map(ground.to_local(global_position))
			if(ground.get_cell_tile_data(0, map_coords) == null):
				moving = false
				worming = false
				var portal_instance = PortalDoor.instantiate()
				
				add_sibling(portal_instance)
				portal_instance.global_position = global_position
				print(global_position)
				print(portal_instance.global_position)
				visible = false
				player.stop_worming()
				camera.switch_target(player)
	
		else:
			scale = scale.move_toward(Vector2(1,1), 0.09)
			if scale == Vector2(1,1):
				moving = true
	
