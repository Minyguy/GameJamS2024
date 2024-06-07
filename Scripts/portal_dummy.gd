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

const teleport_time : int = 2 #Frames

var passengers = []
var passenger_direction : bool
var passenger_timer : float
var has_passenger : bool

var left_right
var cooldown := 0
var portal_completed : bool

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
	pass
	

func _physics_process(delta):
	match subtype:
		"Door":
			_animated_sprite.play("portal_door")

		"Link":
			_animated_sprite.play("portal_link")

		_:
			print("PROBLEM WITH PORTAL SUBTYPE")
	
	if(passengers.size() == 0):
		scale = scale.move_toward(Vector2(1, 1), 3*delta)
	
	if(has_passenger):
		for n in range(passengers.size()-1, -1, -1):
			passengers[n][2] += 1
			if passengers[n][2] > teleport_time:
				
				do_teleport(passengers[n])
				passengers.remove_at(n)
	
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

func receive_passenger(_object, _is_left):
	var new_passenger = [_object, _is_left, 0]
	
	if not new_passenger[1]:
		new_passenger[2] = 1
	has_passenger = true
	teleporting = true
	new_passenger[0].global_position = global_position
	passengers.append(new_passenger)
	scale = Vector2(1.3,1.3)

func do_teleport(passenger):
	if(passengers != [] and (portal_completed or subtype == "Link")):
		if(passenger[1]):
			print("Sending passenger in direction left")
		else:
			print("Sending passenger in direction right")
			
		# 4 is the number for string 
		if typeof(get_next_portal(passenger[1])) == 4:
			summon_passenger(passenger)
		
		else:
			get_next_portal(passenger[1]).receive_passenger(passenger[0],passenger[1])
		
		scale = scale.move_toward(Vector2(1, 1),0.03)
		if passengers.size() == 0:
			teleporting = false
			has_passenger = false


func get_next_portal(is_left):
	if is_left:
		return left_portal
	else:
		return right_portal

func summon_passenger(_passenger):
	_passenger[0].global_position -= global_position.direction_to(get_next_portal(not _passenger[1]).global_position)*8
	_passenger[0].velocity = -global_position.direction_to(get_next_portal(not _passenger[1]).global_position)*350
	_passenger[0].stop_teleport()
