extends Camera2D

@onready var target = get_parent()

# Called when the node enters the scene tree for the first time.
func _ready():
	reparent(%Player)

func switch_target(new_target):
	reparent(new_target, true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
		
	pass
