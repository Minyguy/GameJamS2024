extends CharacterBody2D


const SPEED = 150.0
const JUMP_VELOCITY = -400.0

var DIRECTION_WALK = 1 # Rightwards, Leftwards = -1
var teleporting = false
var portal
var portal_position
var in_portal
var tp_cooldown

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var ground = get_parent().find_child("TileMap")
@onready var _animated_sprite = $AnimatedSprite2D
@onready var TYPE = "Enemy"
@onready var physics_enabled = true

func _physics_process(delta):
	var flip_direction = false
	
	if (tp_cooldown > 0):
		tp_cooldown -= delta
	
	
	if(teleporting):
		# Havent entered toob yet
		if(visible):
			if scale == Vector2(0.45,-0.45):
				visible = false
				pass
			
			else:
				position = position.move_toward(portal_position, 6)
				scale = scale.move_toward(Vector2(0.45,-0.45), 0.15)
		
		# Has entered toob, send signal to portal
		else:
			if not in_portal:
				portal.do_teleport(self, true)
				in_portal = true
	
	
	else:
		# If on-floor
		if is_on_floor():
			_animated_sprite.play("run")
			
			# Move
			if DIRECTION_WALK:
				velocity.x = DIRECTION_WALK * SPEED
			else:
				velocity.x = move_toward(velocity.x, 0, SPEED)
			
			# Turn Around or jump when hole
			var map_coords = ground.local_to_map(ground.to_local(Vector2(position.x+DIRECTION_WALK*20, position.y)))
			if (ground.get_cell_tile_data(0, Vector2(map_coords.x, map_coords.y)) != null):
				flip_direction = true
			elif (ground.get_cell_tile_data(0, Vector2(map_coords.x, map_coords.y+1)) == null):
				if (ground.get_cell_tile_data(0, Vector2(map_coords.x+DIRECTION_WALK*4, map_coords.y+1)) != null):
					if (ground.get_cell_tile_data(0, Vector2(map_coords.x+DIRECTION_WALK*4, map_coords.y)) == null):
						velocity.y -= 405
						
					else:
						flip_direction = true
				else:
					flip_direction = true
		
		# If mid-air
		else:
			velocity.y += gravity * delta
			if velocity.y <= 0:
				_animated_sprite.play("run")
			else:
				_animated_sprite.play("fall")
		
		
		
		# Apply Movement
		if physics_enabled:
			move_and_slide()
		
		# Collision
		for index in get_slide_collision_count():
			var collisionStuff := get_slide_collision(index)
			var body := collisionStuff.get_collider()
			if (body.TYPE != null):
				if (body.TYPE == "Bullet") or (body.name == "Bullet"):
					if (body.global_position.x - global_position.x)*DIRECTION_WALK > 0:
						flip_direction = true
		
		if (flip_direction):
			DIRECTION_WALK *= -1
			scale.x *= -1

func start_teleport(_portal, _position):
	teleporting = true
	portal_position = _position
	portal = _portal
	

func get_tp_cooldown():
	return tp_cooldown
