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
var link_counter = 0
var link_list = []
var shrink_away_list = []
func start_worming(new_position):
	queue_delete_portals()
	scale = Vector2(0.1, 0.1)
	visible = true
	worming = true
	moving = false
	position = new_position
	direction = position.direction_to(player.position)*-1
	link_counter = 7
	link_list.append(summon_portal(1))

# Called when the node enters the scene tree for the first time.
func _ready():
	#visible = false
	print("PORTAL IS SPAWNED")
	print(position)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	
	shrink_away_portals()
	rotation -= 2*delta
	if rotation < 0:
		rotation += 2*PI
	pass
	
	if worming:
		if moving:
			direction = direction.rotated(0.03*sign(   global_position.direction_to(get_global_mouse_position()).angle_to(-direction)  ))
			position += direction*speed*delta
			
			var map_coords = ground.local_to_map(ground.to_local(global_position))
			if(ground.get_cell_tile_data(0, map_coords) == null):
				moving = false
				worming = false
				link_list.append(summon_portal(2))
				
				visible = false
				player.stop_worming()
				camera.switch_target(player)
			
			elif not link_counter:
				link_list.append(summon_portal(0))
				link_counter = 7
			else:
				link_counter -= 1
	
		else:
			scale = scale.move_toward(Vector2(1,1), 0.09)
			if scale == Vector2(1,1):
				moving = true
	

func summon_portal(thing: int):
	match thing:
		0:
			var portal_instance = PortalDoor.instantiate()
			add_sibling(portal_instance)
			portal_instance.set_subtype("Link")
			portal_instance.global_position = global_position
			portal_instance.rotation = direction.angle()
			return portal_instance
		1:
			var portal_instance = PortalDoor.instantiate()
			add_sibling(portal_instance)
			portal_instance.set_subtype("Door")
			portal_instance.global_position = global_position
			portal_instance.rotation = direction.angle()
			return portal_instance
		2:
			var portal_instance = PortalDoor.instantiate()
			add_sibling(portal_instance)
			portal_instance.set_subtype("Door")
			portal_instance.global_position = global_position
			portal_instance.z_index += 1
			portal_instance.rotation = PI+direction.angle()
			return portal_instance
		_:
			print("SOMETHING IS WRONG")

func queue_delete_portals():
	shrink_away_list += link_list.duplicate()
	link_list = []

func shrink_away_portals():
	var delete_link_list = []
	for link in (shrink_away_list):
		
		if(shrink_link(link)):
			delete_link_list.append(link)
		pass
	
	for del in delete_link_list:
		shrink_away_list.erase(del)

func shrink_link(object):
	if object.scale == Vector2(0.01, 0.01):
		object.queue_free()
		return true
	else:
		object.scale = object.scale.move_toward(Vector2(0.01, 0.01), 0.04)
		return false



func _on_area_entered(area):
	if link_list.size() > 1:
		if ( (area != link_list[-1]) and (area != link_list[-2]) and (area in link_list) ): 
			queue_delete_portals()
			camera.switch_target(player)
			worming = false
			visible = false
