extends Marker2D
const radius = 30
@onready var player = get_parent()
@onready var target
# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position = player.position.direction_to(get_global_mouse_position())*radius
	pass


func _on_area_2d_area_entered(area):
	if area.has_method("do_teleport"):
		if area.subtype == "Door":
			print("Target is selecting portal")
			target = area
			pass


func _on_area_2d_area_exited(area):
	if area.has_method("do_teleport"):
		if area.subtype == "Door":
			print("Target is no longer portal")
			target = null
			pass
