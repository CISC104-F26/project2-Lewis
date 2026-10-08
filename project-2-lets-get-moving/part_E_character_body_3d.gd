extends CharacterBody3D

#some controls are from the "Basic Movement" CharecterBody3D script 
#i have added comments to all the new parts

enum states {
	standing,
	crouching,
	sliding
}
var player_state
var is_standing: bool
var direction: Vector3
var acceleration: float
var friction_factor: float #1/x th of velocity is lost per frame
var mouse_sensitivity = .005

#movement parameters
const JUMP_VELOCITY = 6.0
var terminal_v: float
const STANDING_ACC = 30
const AIR_ACC = 10
const CROUCHING_ACC = 20
const NORMAL_FRICT = 25
const SLIDING_FRICT = 120
const CROUCHING_TERMINAL = 4
const STANDING_TERMINAL = 10
const AIR_TERMINAL = 12

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	player_state = states.standing
	
#process mouse motion input
func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		#yaw rotate entire body
		rotate_y(-event.relative.x * mouse_sensitivity)
		#pitch rotate camera only; with clamp (in process)
		$Camera3D.rotate_x(-event.relative.y * mouse_sensitivity)

func _process(delta: float) -> void:
	#you can flip!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	if is_on_floor(): 
		$Camera3D.rotation_degrees.x = clamp($Camera3D.rotation_degrees.x, -70, 70)
		if Input.is_action_just_pressed("fly_up"): velocity.y = JUMP_VELOCITY
		#walljump
	elif is_on_wall(): 
		velocity += (get_gravity()/2) * delta
		if Input.is_action_just_pressed("fly_up"): 
			velocity.y += JUMP_VELOCITY / 1.1
			velocity.x += get_wall_normal().x * JUMP_VELOCITY
			velocity.z += get_wall_normal().z * JUMP_VELOCITY
	else: velocity += get_gravity() * delta
	
	#change camera sensitivity with scroll wheel
	if Input.is_action_just_pressed("scroll_up"): mouse_sensitivity += mouse_sensitivity / 20
	elif Input.is_action_just_pressed("scroll_down"): mouse_sensitivity -= mouse_sensitivity / 20
	
	#get input dir
	var input_direction := Input.get_vector("move_left","move_right","move_up","move_down")
	
	#crouch (1/2 height and movement speed)
	if Input.is_action_pressed("fly_down"):
		player_state = states.crouching
	#slide (applies velocity in direction of camera and reduces friction)
	elif Input.is_action_pressed("slide"):
		if player_state != states.sliding and is_on_floor(): 
			direction = -global_transform.basis.z.normalized()
			velocity.x = direction.x * terminal_v
			velocity.z = direction.z * terminal_v
		player_state = states.sliding
	else: player_state = states.standing
		
	#set parameters based on state
	match player_state:
		states.crouching:
			acceleration = CROUCHING_ACC
			$CollisionShape3D.shape.height = 1
			friction_factor = NORMAL_FRICT
			terminal_v = CROUCHING_TERMINAL
		states.standing:
			terminal_v = STANDING_TERMINAL
			acceleration = STANDING_ACC
			if Input.is_action_pressed("sprint") and is_on_floor(): 
				acceleration *= 1.5
				terminal_v *= 1.5
			$CollisionShape3D.shape.height = 2
			friction_factor = NORMAL_FRICT
		states.sliding:
			$CollisionShape3D.shape.height = 1
			friction_factor = SLIDING_FRICT
	
	if not is_on_floor() and player_state != states.sliding: acceleration = AIR_ACC
	
	if input_direction and player_state != states.sliding:
		direction = (transform.basis * Vector3(input_direction.x, 0, input_direction.y)).normalized()
		velocity.x += direction.x * acceleration * delta
		velocity.z += direction.z * acceleration * delta
	
	#apply friction to dampen velocity
	if velocity.length() > terminal_v or is_on_floor():
		velocity.x -= (velocity.x / friction_factor)
		velocity.z -= (velocity.z / friction_factor)
	
	
	move_and_slide()
	#print(states.find_key(player_state))
	#print(velocity.length())
	#print(terminal_v)
