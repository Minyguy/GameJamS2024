extends Marker2D
const radius = 30
@onready var player = get_parent()
# Called when the node enters the scene tree for the first time.
func _ready():
	var player = get_parent()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position = player.position.direction_to(get_global_mouse_position())*radius
	pass