extends CharacterBody2D
const gravity = 2900
const FLOAT_MOD = 2500.0

@export var SPEED = 300.0
@export var SPEED_BOOST = 70.0
@export var JUMP_VELOCITY = 500
@export var portal_controller : Area2D
@export var camera : Node2D
@export var target : Marker2D

const base_coyote_time = 0.08 #Seconds
var coyote_time = base_coyote_time
const airtime_limit = 0.23
const TYPE := "Player"
var facing_right := true
var base_shoot_cd := 30
var curr_shoot_cd := 0
var mouse := Vector2(0,0)
var alive := true
var dying := false
var airtime := 0.0

# Variables related to platforming etc
var physics_enabled := true

# Variables related to going through wormholes
var teleporting := false
var portal_position : Vector2
var portal : Area2D
var is_left_in_portal : bool
var in_portal := false
var post_tp_grow := false
var spawnpoint : Vector2

# Variables related to Creating portals
var worm_time := false
var jumpChat := 0
var ground : TileMap

# Misc Variables
var bullet_path
var _animated_sprite : AnimatedSprite2D
var shape : CollisionShape2D
var speed_boost_timer = 0

func start_worming():
	
	var worm_pos = global_position
	while ground.get_terrain_set_at_global(worm_pos) == -1:
		worm_pos += worm_pos.direction_to(target.global_position)
	if ground.get_terrain_set_at_global(worm_pos) == 0:
		portal_controller.start_worming(worm_pos)
		camera.switch_target(portal_controller)
		worm_time = true

func stop_worming():
	worm_time = false

func shoot_bullet(speed, radius) -> int:
	var map_coords = ground.local_to_map(ground.to_local(target.global_position))
	if ground.get_terrain_set_at_global(target.global_position) == -1:
		var bulletInst = bullet_path.instantiate()
		
		add_sibling(bulletInst)
		bulletInst.linear_velocity = position.direction_to(get_global_mouse_position())*speed
		bulletInst.position = position + position.direction_to(get_global_mouse_position())*radius
		
		return 1
	else:
		return 0
	


func _ready():
	spawnpoint = global_position
	ground = get_parent().find_child("TileMap")
	target = $Target
	bullet_path = preload("res://Subscenes/Bullet.tscn")
	_animated_sprite = $Sprite2D
	shape = %CollisionShape2D

func _process(delta):
	#Grow to normal size
	if scale != Vector2(sign(scale.x)*1, sign(scale.y)*1) and not teleporting:
		scale = scale.move_toward(Vector2(sign(scale.x)*1, sign(scale.y)*1), 5*delta)
	

func _physics_process(delta):
	reduce_cooldowns(delta)
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	if position.y >= 3000:
		get_parent().get_parent().reset_level()
	
	if worm_time:
		pass
	
	elif teleporting:
		process_teleporting()
	
	elif (alive):
		if not curr_shoot_cd:
			if Input.is_action_pressed("shoot"):
				
				curr_shoot_cd = base_shoot_cd
				
			
		if Input.is_action_just_pressed("Start_Worming") and alive:
			if (target.target != null):
				start_teleport(target.target, target.target.global_position, target.target.left_right)
				#Go through portal
			
			
			else:
				if not worm_time:
					if (ground.get_terrain_set_at_global(target.global_position) == 0):
						start_worming()
	
		if Input.is_action_just_pressed("jump"):
			try_jump()
	
	if not is_on_floor():
		airtime += delta
		if Input.is_action_pressed("jump"):
			
			if airtime > airtime_limit or velocity.y > 0:
				velocity.y += (gravity) * delta
			else:
				velocity.y += (gravity - FLOAT_MOD) * delta
			if velocity.y < 0:
				_animated_sprite.play("jumping")
			else:
				_animated_sprite.play("falling")
		else:
			if alive:
				velocity.y += gravity * delta
				if velocity.y < 0:
					_animated_sprite.play("jumping")
				else:
					_animated_sprite.play("falling")
	else:
		airtime = 0
		coyote_time = base_coyote_time

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	
	if alive:
		if direction  and not worm_time: 
			velocity.x = move_toward(velocity.x, (SPEED + sign(speed_boost_timer)*SPEED_BOOST)*direction, SPEED*delta*8)
			
			if is_on_floor():
				_animated_sprite.play("running")
			if direction == -1:
				if facing_right:
					_animated_sprite.scale.x *= -1
					facing_right = false
			elif direction == 1:
				if not facing_right:
					_animated_sprite.scale.x *= -1
					facing_right = true
			
		else:
			if is_on_floor():
				velocity.x = move_toward(velocity.x, 0, SPEED*delta*6)
				_animated_sprite.play("default")

	else:
		if dying:
			_animated_sprite.play("hit")
			velocity = velocity.move_toward(Vector2(0,0), 100*delta)
			if _animated_sprite.frame == 6:
				dying = false
				visible = false
				shape.disabled = true
				velocity = Vector2(0,0)
	
	if not alive and not dying:
		get_parent().get_parent().reset_level()
	
	if(physics_enabled):
		move_and_slide()

		for index in get_slide_collision_count():
			var collisionStuff := get_slide_collision(index)
			var body := collisionStuff.get_collider()
			if body.name == "BasicEnemy":
				if alive:
					print("YOU DIE!!!!")
					alive = false
					dying = true


	if Input.is_action_just_pressed("dev_resurrect"):
		reset_player()

	if Input.is_action_just_pressed("menu"):
		get_parent().get_parent()._back_to_menu(false)

func start_teleport(_portal, _position, is_left_direction):
	if(is_left_direction):
		print("Player Preparing tp with direction left")
	else:
		print("Player Preparing tp with direction right")
	in_portal = false
	teleporting = true
	portal_position = _position
	portal = _portal
	is_left_in_portal = is_left_direction
	physics_enabled = false
	

func stop_teleport():
	teleporting = false
	in_portal = false
	physics_enabled = true
	visible = true
	post_tp_grow = true

func reduce_cooldowns(delta):
	curr_shoot_cd = move_toward(curr_shoot_cd, 0, 1*delta)
	speed_boost_timer = move_toward(speed_boost_timer, 0, delta)

func try_jump():
	if (is_on_floor() or airtime < coyote_time) and alive and not worm_time:
		velocity.y = -JUMP_VELOCITY

func reset_player():
	visible = true
	alive = true
	worm_time = false
	visible = true
	physics_enabled = true
	position = spawnpoint
	camera.switch_target(self)
	shape.disabled = false
	scale = Vector2(1,1)
	teleporting = false
	in_portal = false

func process_teleporting():
	# Havent entered toob yet
	if(visible):
		if scale.x <= sign(scale.x)*0.45 and scale.y <=sign(scale.y)*0.45:
			visible = false
			pass
		
		else:
			position = position.move_toward(portal_position, 6)
			scale = scale.move_toward(Vector2(sign(scale.x)*0.40, sign(scale.y)*0.40), 0.15)
	
	# Has entered toob, send signal to portal
	else:
		if not in_portal:
			if(is_left_in_portal):
				print("Player Starting tp with direction left")
			else:
				print("Player Starting tp with direction right")
			portal.receive_passenger(self, is_left_in_portal)
			in_portal = true


func _on_collectible_area_area_entered(area):
	print("FOUND AREA")
	print(area.name)
	print("-------")
	if area.has_method("get_type"):
		match(area.get_type()):
			"speed_boost":
				speed_boost_timer = 5
			_:
				print(area.name)
			
