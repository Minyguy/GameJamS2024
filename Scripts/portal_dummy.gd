extends Area2D
@onready var type = "Portal"
@onready var subtype = "Link"
@onready var _animated_sprite = $Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	if subtype == "Door":
		_animated_sprite.play("portal_link")
	pass # Replace with function body.

func set_subtype(new_subtype):
	subtype = new_subtype

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match subtype:
		"Door":
			_animated_sprite.play("portal_door")

		"Link":
			_animated_sprite.play("portal_link")

		_:
			print("PROBLEM WITH PORTAL SUBTYPE")
