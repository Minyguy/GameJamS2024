extends CharacterBody2D


const SPEED = 300.0
var base_shoot_cd = 30
var curr_shoot_cd = 0
var mouse = Vector2(0,0)
@onready var bullet_path = preload("res://Bullet.tscn")



func shoot_bullet(direction, speed):
	var bulletInst = bullet_path.instantiate()
	add_child(bulletInst)
	
	
	
func _physics_process(delta):

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	
	var direction = Vector2(Input.get_axis("ui_left", "ui_right"), Input.get_axis("ui_up", "ui_down"))
	if not curr_shoot_cd:
		if Input.is_action_pressed("shoot"):
			print(get_global_mouse_position())
			# shoot_bullet(get_global_mouse_position(),100)
			curr_shoot_cd = base_shoot_cd
	else:
		curr_shoot_cd = move_toward(curr_shoot_cd, 0, 1)    
	if direction:
		velocity = direction.normalized() * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)
	move_and_slide()
