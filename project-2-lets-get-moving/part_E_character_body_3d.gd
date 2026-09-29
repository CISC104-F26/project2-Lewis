extends CharacterBody3D

const JUMP_VELOCITY = 6
const FRICTION_FACTOR = 15 #1/x th of velocity is lost per frame
var move_speed = 5 #sprint speed is 2x
var mouse_sensitivity = .005


func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
#process mouse motion input
func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		#yaw rotate entire body
		rotate_y(-event.relative.x * mouse_sensitivity)
		#pitch rotate camera only; with clamp
		$Camera3D.rotate_x(-event.relative.y * mouse_sensitivity)
		$Camera3D.rotation_degrees.x = clamp($Camera3D.rotation_degrees.x, -80, 80)

func _process(delta: float) -> void:
	#change camera sensitivity with scroll wheel
	if Input.is_action_just_pressed("scroll_up"): mouse_sensitivity += mouse_sensitivity * 0.1
	elif Input.is_action_just_pressed("scroll_down"): mouse_sensitivity -= mouse_sensitivity / 20
	
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("fly_up") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	var input_direction := Input.get_vector("move_left","move_right","move_up","move_down")
	var direction := (transform.basis * Vector3(input_direction.x, 0, input_direction.y)).normalized()
	if direction:
		velocity.x = direction.x * move_speed
		velocity.z = direction.z * move_speed
		#sprint speed when on floor and with dir input only
		if Input.is_action_pressed("sprint") && is_on_floor():
			velocity.x *= 2
			velocity.z *= 2
	#if theres no imput and youre on floor: apply friction to dampen velocity
	elif is_on_floor():
		velocity.x -= (velocity.x / FRICTION_FACTOR)
		velocity.z -= (velocity.z / FRICTION_FACTOR)
		
	print(velocity)
	move_and_slide()
