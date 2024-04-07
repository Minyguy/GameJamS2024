extends CharacterBody2D

const FLOAT_MOD = 100.0
const SPEED = 300.0
const gravity = 2800
const JUMP_VELOCITY = 1000


var base_shoot_cd = 30
var curr_shoot_cd = 0
var mouse = Vector2(0,0)
var alive = true
var worm_time = false
var jumpChat = 0
var wormPortal = []
@onready var ground = get_parent().find_child("TileMap")
@onready var target = find_child("Target")
@onready var bullet_path = preload("res://Subscenes/Bullet.tscn")
@onready var portal_path = preload("res://Subscenes/Portal_Opening.tscn")
#@onready var portal_link_path = preload("res://Subscenes/Portal_Ground.tscn")

func _ready():
	#print(ground.has_tile(Vector2(0,0)))
	print(ground.get_cell_tile_data(0, Vector2(0,0)).terrain)
	print(ground.get_cell_tile_data(0, Vector2(1,0)))
	print(ground.get_cell_tile_data(0, Vector2(24,34)))

func shoot_bullet(direction, speed):
	
	var bulletInst = bullet_path.instantiate()
	add_sibling(bulletInst)

func _process(delta):
	
	if worm_time:
		pass
	else:
		if (alive and not worm_time):
			if not curr_shoot_cd:
				if Input.is_action_pressed("shoot"):
					print(get_global_mouse_position())
					shoot_bullet(get_global_mouse_position(),100)
					curr_shoot_cd = base_shoot_cd
			else:
				curr_shoot_cd = move_toward(curr_shoot_cd, 0, 1)    
				
			if Input.is_action_just_pressed("Start_Worming") and alive:
				
				
				
				var map_coords = ground.local_to_map(ground.to_local(target.global_position))
				print(map_coords)
				print(target.global_position)
				print(ground.get_cell_tile_data(0, map_coords))
				
				if (ground.get_cell_tile_data(0, map_coords) != null):
					print("WORMTIME")
					var portalInst = portal_path.instantiate()
					portalInst.position = target.position
					add_sibling(portalInst)
					portalInst.position = target.global_position
					#worm_time = true
				
		if(worm_time):
			pass


func _physics_process(delta):

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	
	if not is_on_floor() and Input.is_action_pressed("jump") and alive:
		velocity.y += gravity * delta - FLOAT_MOD * delta
	elif not is_on_floor():
		velocity.y += gravity * delta

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
	if direction and alive:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

	for index in get_slide_collision_count():
		var collisionStuff := get_slide_collision(index)
		var body := collisionStuff.get_collider()
		if body.name == "BasicEnemy":
			print("YOU DIE!!!!")
			alive = false
			
	if Input.is_action_just_pressed("dev_resurrect"):
		alive = true
		worm_time = false
		position = get_global_mouse_position()
