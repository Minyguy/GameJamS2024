extends CharacterBody2D


const SPEED = 100.0
const JUMP_VELOCITY = -400.0
var DIRECTION_WALK = 1 # Rightwards, Leftwards = -1
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var ground = get_parent().find_child("TileMap")

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	var map_coords = ground.local_to_map(ground.to_local(position))
	if (ground.get_cell_tile_data(0, Vector2(map_coords.x+DIRECTION_WALK, map_coords.y)) != null) or (ground.get_cell_tile_data(0, Vector2(map_coords.x+DIRECTION_WALK, map_coords.y+1)) == null):
		DIRECTION_WALK *= -1
	
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	if DIRECTION_WALK:
		velocity.x = DIRECTION_WALK * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
	for index in get_slide_collision_count():
		var collisionStuff := get_slide_collision(index)
		var body := collisionStuff.get_collider()
		if body.name == "Bullet":
			DIRECTION_WALK *= -1
