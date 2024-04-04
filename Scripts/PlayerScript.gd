extends CharacterBody2D

const FLOAT_MOD = 100.0
const SPEED = 300.0
const gravity = 2800
const JUMP_VELOCITY = 1000
var base_shoot_cd = 30
var curr_shoot_cd = 0
var mouse = Vector2(0,0)
@onready var bullet_path = preload("res://Subscenes/Bullet.tscn")



func shoot_bullet(direction, speed):
	
	var bulletInst = bullet_path.instantiate()
	add_sibling(bulletInst)

func _process(delta):
	if not curr_shoot_cd:
		if Input.is_action_pressed("shoot"):
			print(get_global_mouse_position())
			shoot_bullet(get_global_mouse_position(),100)
			curr_shoot_cd = base_shoot_cd
	else:
		curr_shoot_cd = move_toward(curr_shoot_cd, 0, 1)    
		
		
func _physics_process(delta):

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	
	if not is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y += gravity * delta - FLOAT_MOD * delta
	elif not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		print("JUMP")
		velocity.y = -JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
