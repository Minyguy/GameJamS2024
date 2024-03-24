extends RigidBody2D
@onready var speed = 0;
@onready var direction = Vector2(1,1);

func _ready():
	pass

func set_properties(new_speed, new_direction):
	speed = new_speed
	direction = new_direction
	print(speed)
	print(direction)


func _process(delta):
	var velocity = direction.normalized() * speed
	velocity.x = move_toward(velocity.x, 0, speed)
	velocity.y = move_toward(velocity.y, 0, speed)
	 
