extends CharacterBody2D
const gravity = 2800
const FLOAT_MOD = 800.0

@export var SPEED = 300.0
@export var JUMP_VELOCITY = 1000
@export var portal_controller : Area2D
@export var camera : Node2D
@export var target : Marker2D

const TYPE := "Player"
var facing_right := true
var base_shoot_cd := 30
var curr_shoot_cd := 0
var mouse := Vector2(0,0)
var alive := true
var dying := false

# Variables related to platforming etc
var physics_enabled : bool

# Variables related to going through wormholes
var teleporting = false
var portal_position : Vector2
var portal : Node2D
var is_left_in_portal : bool
var in_portal := false
var post_tp_grow := false

# Variables related to Creating portals
var worm_time := false
var jumpChat := 0
var ground : TileMap

# Misc Variables
var bullet_path
var _animated_sprite
var shape

func stop_worming():
	worm_time = false

func shoot_bullet(speed, radius) -> int:
	var map_coords = ground.local_to_map(ground.to_local(target.global_position))
	if (ground.get_cell_tile_data(0, Vector2(map_coords.x, map_coords.y)) == null):
		var bulletInst = bullet_path.instantiate()
		
		add_sibling(bulletInst)
		bulletInst.linear_velocity = position.direction_to(get_global_mouse_position())*speed
		bulletInst.position = position + position.direction_to(get_global_mouse_position())*radius
		
		return 1
	else:
		return 0
	


func _ready() -> void:
	ground = get_parent().find_child("TileMap")
	target = $Target
	bullet_path = preload("res://Subscenes/Bullet.tscn")
	_animated_sprite = $Sprite2D
	shape = %CollisionShape2D

func _process(delta):
	
	# Handle worm_time gameplay
	if worm_time:
		pass
	
	# Handle plattformer gameplay
	else:
		if (alive):
			if not curr_shoot_cd:
				if Input.is_action_pressed("shoot"):
					shoot_bullet(300, 40)
					curr_shoot_cd = base_shoot_cd
			else:
				curr_shoot_cd = move_toward(curr_shoot_cd, 0, 1)    
				
			if Input.is_action_just_pressed("Start_Worming") and alive:
				if (target.target != null):
					pass
					#Go through portal
				
				
				else:
					var map_coords = ground.local_to_map(ground.to_local(target.global_position))
					if (ground.get_cell_tile_data(0, map_coords) != null):
						print("WORMTIME")
						
						#worm_time = true
						
						var worm_pos = global_position
						while ground.get_cell_tile_data(0, ground.local_to_map(ground.to_local(worm_pos))) == null:
							worm_pos += worm_pos.direction_to(target.global_position)
						portal_controller.start_worming(worm_pos)
						camera.switch_target(portal_controller)
				


func _physics_process(delta):

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	if position.y >= 3000:
		position = Vector2(150, 500)
		velocity.y = 0
		velocity.x = 0
	if not is_on_floor() and Input.is_action_pressed("jump") and alive:
		velocity.y += (gravity - FLOAT_MOD) * delta
		if velocity.y < 0:
			_animated_sprite.play("jumping")
		else:
			_animated_sprite.play("falling")
	elif not is_on_floor():
		if alive:
			velocity.y += gravity * delta
			if velocity.y < 0:
				_animated_sprite.play("jumping")
			else:
				_animated_sprite.play("falling")
	
	
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor() and alive and not worm_time:
		
		velocity.y = -JUMP_VELOCITY
		if jumpChat == 0:
			print("Hop")
			jumpChat = 1
		elif jumpChat == 1:
			print("Skip")
			jumpChat = 2
		elif jumpChat == 2:
			print("Jump")
			jumpChat = 0

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	
	if alive:
		if direction: 
			velocity.x = direction * SPEED
			
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
			velocity.x = move_toward(velocity.x, 0, SPEED)
			if is_on_floor():
				_animated_sprite.play("default")

	else:
		if dying:
			_animated_sprite.play("hit")
			if _animated_sprite.frame == 6:
				dying = false
				visible = false
				shape.disabled = true
	

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
		visible = true
		alive = true
		worm_time = false
		position = get_global_mouse_position()
		camera.switch_target(self)
		shape.disabled = false

	if Input.is_action_just_pressed("menu"):
		get_parent().get_parent()._back_to_menu()

func start_teleport(_portal, _position, is_left_direction):
	if(is_left_direction):
		print("Starting tp with direction left")
	else:
		print("Starting tp with direction right")
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
