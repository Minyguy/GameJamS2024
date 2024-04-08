extends RigidBody2D
@onready var speed = 0;
const TYPE = "Bullet"

func _ready():
	speed = 400
	var radius = 50
	linear_velocity = get_parent().get_node("Player").position.direction_to(get_global_mouse_position()-position)*speed
	pass

func _process(delta):
	pass
