extends RigidBody2D
@onready var speed = 0;

func _ready():
	speed = 400
	
	linear_velocity = Vector2(1,1).direction_to(get_global_mouse_position()-position)*speed
	#position = get_node(Player_CharacterBody2D).position
	print(linear_velocity)
	print("THIS SHOULD WORK")
	pass
	
func aim_at_mouse():
	linear_velocity = Vector2(1,1).direction_to(get_global_mouse_position()-position)*speed

	

func _process(delta):
	pass
	 
