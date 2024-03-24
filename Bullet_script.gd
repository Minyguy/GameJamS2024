extends RigidBody2D
@onready var speed = 0;

func _ready():
	speed = 400
	linear_velocity = get_parent().get_node("Player").position.direction_to(get_global_mouse_position()-position)*speed
	print(linear_velocity)
	position = get_parent().get_node("Player").position + (get_parent().get_node("Player").position.direction_to(get_global_mouse_position())*50)
	print(linear_velocity)
	print("THIS SHOULD WORK")
	pass
	

	

func _process(delta):
	pass
	 
