extends Area2D

@onready var player = %Player
@onready var camera = %Camera_tracker
@onready var direction := Vector2(0, 0)
@onready var ground = %TileMap
@onready var worming := false
@onready var moving := false
@onready var speed = 200
@onready var turn_speed = 0.03
@onready var PortalDoor = preload("res://Subscenes/portal.tscn")

@onready var PortalList : Node2D 
var portal : Area2D
var prev_portal : Area2D
var link_counter = 0
var link_list = []
var shrink_away_list = []
var door_1 : Area2D

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
	
	shrink_away_portals(delta)
	rotation -= 2*delta
	if rotation < 0:
		rotation += 2*PI
	pass
	
	if worming:
		if moving:
			direction = direction.rotated(turn_speed*sign(   global_position.direction_to(get_global_mouse_position()).angle_to(-direction)  ))
			position += direction*speed*delta
			
			var map_coords = ground.local_to_map(ground.to_local(global_position))
			if(ground.get_terrain_set_at_global(global_position) == -1):
				moving = false
				worming = false
				
				link_list.append(summon_portal(2))
				
				visible = false
				player.stop_worming()
				camera.switch_target(player)
				
			elif ground.get_terrain_set_at_global(global_position) == 1:
				queue_delete_portals()
				camera.switch_target(player)
				player.stop_worming()
				worming = false
				visible = false
			
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
		
		# Link
		0:
			
			var portal_instance = PortalDoor.instantiate()
			
			#left and right portal is how a "tunnel" knows where things should go
			portal_instance.left_portal = prev_portal
			
			prev_portal.right_portal = portal_instance
			
			# Door is the ends of the tunnel, while Link is the inbetweens
			portal_instance.set_subtype("Link")
			portal_instance.left_right = "link"
			portal_instance.global_position = global_position
			portal_instance.rotation = direction.angle()
			
			prev_portal = portal_instance
			add_sibling(portal_instance)
			return portal_instance
		
		# Initial Door
		1:
			
			var portal_instance = PortalDoor.instantiate()
			door_1 = portal_instance
			portal_instance.set_subtype("Door")
			portal_instance.global_position = global_position
			portal_instance.rotation = direction.angle()
			portal_instance.left_portal = "Air"
			prev_portal = portal_instance
			portal_instance.approved_types = ["Enemy", "Player"]
			prev_portal.right_portal = portal_instance
			portal_instance.left_right = false
			add_sibling(portal_instance)
			return portal_instance
		
		# Final Door
		2:
			
			var portal_instance = PortalDoor.instantiate()
			
			portal_instance.set_subtype("Door")
			portal_instance.global_position = global_position
			portal_instance.z_index += 1
			portal_instance.rotation = PI+direction.angle()
			portal_instance.left_portal = prev_portal
			portal_instance.right_portal = "Air"
			portal_instance.approved_types = ["Enemy", "Player"]
			prev_portal.right_portal = portal_instance
			portal_instance.left_right = true
			add_sibling(portal_instance)
			door_1.portal_completed = true
			portal_instance.portal_completed = true
			return portal_instance
		_:
			print("SOMETHING IS WRONG")

func queue_delete_portals():
	shrink_away_list += link_list.duplicate()
	link_list = []

func shrink_away_portals(delta):
	var delete_link_list = []
	for link in (shrink_away_list):
		
		if(shrink_link(link, delta)):
			delete_link_list.append(link)
		pass
	
	
	if(delete_link_list.size() > 0):
		print("DELETING")
		print(delete_link_list.size())
		print("PORTALS")
	for del in delete_link_list:
		shrink_away_list.erase(del)
		del.queue_free()

func shrink_link(object, delta):
	if (abs(object.scale.x) <= 0.1) and (abs(object.scale.y) <= 0.1):
		return true
	else:
		object.scale = object.scale.move_toward(Vector2(0, 0), delta*7)
		return false



func _on_area_entered(area):
	if worming:
		if link_list.size() > 1:
			if ( (area != link_list[-1]) and (area != link_list[-2]) and (area in link_list) ): 
				queue_delete_portals()
				camera.switch_target(player)
				worming = false
				visible = false
				player.stop_worming()
