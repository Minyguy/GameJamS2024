extends CharacterBody2D


const SPEED = 150.0
const JUMP_VELOCITY = -400.0

var DIRECTION_WALK = 1 # Rightwards, Leftwards = -1
var teleporting = false
var portal
var portal_position
var in_portal
var tp_cooldown = 0
var is_left_in_portal
var post_tp_grow = false
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var ground = get_parent().find_child("TileMap")
@onready var _animated_sprite = $AnimatedSprite2D
@onready var TYPE = "Enemy"
@onready var physics_enabled = true

func _physics_process(delta):
	var flip_direction = false
	
	
	
	if post_tp_grow:
		scale.x = move_toward(scale.x, sign(scale.x), 0.1)
		scale.y = move_toward(scale.y, sign(scale.y), 0.1)
		if scale == Vector2(1, 1):
			post_tp_grow = false
	
	if(teleporting):
		process_teleporting()
	
	

	else:
		if (tp_cooldown > 0):
			tp_cooldown -= delta
			if tp_cooldown <= 0:
				tp_cooldown = 0
				print("Enemy can teleport again")
		
		# If on-floor
		if is_on_floor():
			_animated_sprite.play("run")
			
			# Move
			if DIRECTION_WALK:
				velocity.x = DIRECTION_WALK * SPEED
			else:
				velocity.x = move_toward(velocity.x, 0, SPEED)
			
			# Turn Around or jump when hole
			if ground.get_terrain_set_at_global(Vector2(global_position.x+DIRECTION_WALK*20, global_position.y)) != -1:
				flip_direction = true
			
			elif ground.get_terrain_set_at_global(Vector2(global_position.x+DIRECTION_WALK*20, global_position.y+32)) == -1:
				if (ground.get_terrain_set_at_global(Vector2(global_position.x+DIRECTION_WALK*4*32, global_position.y+32))) != null:
					if (ground.get_terrain_set_at_global(Vector2(global_position.x+DIRECTION_WALK*4*32, global_position.y)) == null):
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
				if (body.TYPE == "Bullet") or (body.name == "Bullet") or (body.TYPE == "Enemy"):
					if (body.global_position.x - global_position.x)*DIRECTION_WALK > 0:
						flip_direction = true
		
		if (flip_direction):
			DIRECTION_WALK *= -1
			scale.x *= -1





func start_teleport(_portal, _position, is_left_direction):
	if not _portal.portal_completed:
		return false
	if(is_left_direction):
		print("Starting tp with direction left")
	else:
		print("Starting tp with direction right")
	teleporting = true
	portal_position = _position
	portal = _portal
	tp_cooldown = 3
	is_left_in_portal = is_left_direction
	physics_enabled = false
	return true

func stop_teleport():
	teleporting = false
	in_portal = false
	physics_enabled = true
	visible = true
	post_tp_grow = true
	

func get_tp_cooldown():
	return tp_cooldown

func process_teleporting():
	# Havent entered toob yet
	if(visible):
		if scale == Vector2(sign(scale.x)*0.45,sign(scale.y)*0.45):
			visible = false
			pass
		
		else:
			position = position.move_toward(portal_position, 6)
			scale = scale.move_toward(Vector2(sign(scale.x)*0.45, sign(scale.y)*0.45), 0.15)
	
	# Has entered toob, send signal to portal
	else:
		if not in_portal:
			if(is_left_in_portal):
				print("Starting tp with direction left")
			else:
				print("Starting tp with direction right")
			portal.receive_passenger(self, is_left_in_portal)
			in_portal = true
