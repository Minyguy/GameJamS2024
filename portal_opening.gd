extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	print("PORTAL IS SPAWNED")
	print(position)
	pass # Replace with function body.
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rotation -= 2*delta
	if rotation < 0:
		rotation += 2*PI
	pass
