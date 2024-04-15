extends Area2D
@onready var type = "Portal"
@onready var subtype
@onready var _animated_sprite = $Sprite2D
var left_portal
var right_portal
var portal_enabled : bool
signal entity_teleport(object)
var approved_types = []
var teleporting = false
var passenger
var left_right
var cooldown = 0

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

func assign_link(_portal: Area2D, forward: bool):
	if forward:
		right_portal = _portal
	else:
		left_portal = _portal

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
			
	if(teleporting):
		do_teleport("none", false)
	else:
		scale = scale.move_toward(Vector2(1, 1),0.003)


func _on_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if(cooldown <= 0):
		if(subtype == "Door"):
			if(body.TYPE in approved_types):
				if(body.TYPE == "Enemy"):
					if(body.visible):
						print("TELEPORTING " + body.TYPE)
						body.physics_enabled = false
						body.start_teleport(self, global_position)
						cooldown = 200


func do_teleport(_object, _new):
	if(_object != null):
		
		if(scale == Vector2(1.3,1.3) and passenger != null):
			
			# 4 is the number for string 
			if typeof(right_portal) == 4:
				print("Summon the enemy!")
				passenger.visible = true
				passenger.scale = Vector2(1,1)
				passenger.teleporting = false
				passenger = null
				
				
			else:
				print(scale)
				print("Sent "+ passenger.name)
				print("to " + right_portal.name)
				right_portal.do_teleport(passenger, true)
				print(right_portal.name)
				passenger = null
				
				scale = scale.move_toward(Vector2(1, 1),0.01)
			teleporting = false
		
		if(_new):
			teleporting = true
			_object.global_position = global_position
			passenger = _object
			scale = Vector2(1.3,1.3)
