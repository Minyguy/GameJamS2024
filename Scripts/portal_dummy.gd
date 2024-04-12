extends Area2D
@onready var type = "Portal"
@onready var subtype
@onready var _animated_sprite = $Sprite2D
var left_portal : Object
var right_portal : Object
var portal_enabled : bool
signal entity_teleport(object)

# Called when the node enters the scene tree for the first time.
func _ready():
	
	print(subtype)
	match subtype:
		"Link":
			_animated_sprite.play("portal_link")
		"Door":
			var level = get_parent()
			if(level.has_method("_on_entity_teleport")):
				print("I had the method!")
			
			entity_teleport.connect(level._on_entity_teleport)
			entity_teleport.emit(self)


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


func _on_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	print(body.name + " SHOULD BE TELEPORTED")
	pass # Replace with function body.
