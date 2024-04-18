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
var passenger_direction
var left_right
var cooldown = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	
	match subtype:
		"Link":
			_animated_sprite.play("portal_link")
		"Door":
			var level = get_parent()
			
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
		do_teleport("none", false, passenger_direction)
	else:
		scale = scale.move_toward(Vector2(1, 1),0.003)
	
	if cooldown > 0:
		cooldown -= delta
		if cooldown < 0:
			cooldown = 0


func _on_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if(cooldown <= 0):
		if(subtype == "Door"):
			if(body.TYPE in approved_types):
				if(body.TYPE == "Enemy"):
					if(body.visible):
						if(body.get_tp_cooldown() <= 0):
							print("TELEPORTING " + body.TYPE)
							
							body.start_teleport(self, global_position, left_right)
							passenger_direction = left_right
							cooldown = 2


func do_teleport(_object, _new, _is_left):
	if(_object != null):
		passenger_direction = _is_left
		if(_is_left):
			print("Sending passenger in direction left")
		else:
			print("Sending passenger in direction right")
		if(scale == Vector2(1.3,1.3) and passenger != null):
			
			# 4 is the number for string 
			if typeof(get_next_portal(_is_left)) == 4:
				summon_passenger()
			
			else:
				print(scale)
				print("Sent "+ passenger.name)
				print("to " + get_next_portal(_is_left).name)
				get_next_portal(_is_left).do_teleport(passenger, true, _is_left)
				passenger = null
				
				scale = scale.move_toward(Vector2(1, 1),0.01)
			teleporting = false
		
		if(_new):
			teleporting = true
			_object.global_position = global_position
			passenger = _object
			scale = Vector2(1.3,1.3)

func get_next_portal(is_left):
	if is_left:
		return left_portal
	else:
		return right_portal

func summon_passenger():
	passenger.stop_teleport()
	passenger.position -= global_position.direction_to(get_next_portal(not passenger_direction).global_position)*5
	passenger = null
	
