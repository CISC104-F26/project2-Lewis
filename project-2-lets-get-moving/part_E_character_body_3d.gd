extends CharacterBody3D

const JUMP_VELOCITY = 4.5
var move_speed = 100
var mouse_sensitivity = .005

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * mouse_sensitivity)
		$Camera3D.rotate_x(-event.relative.y * mouse_sensitivity)
		$Camera3D.rotation_degrees.x = clamp($Camera3D.rotation_degrees.x, -80, 80)
		print($Camera3D.rotation_degrees)

func _process(delta: float) -> void:
	#change camera sensitivity with scroll wheel
	if Input.is_action_just_pressed("scroll_up"): mouse_sensitivity += mouse_sensitivity * 0.1
	elif Input.is_action_just_pressed("scroll_down"): mouse_sensitivity -= mouse_sensitivity / 20
	
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("fly_up") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	var input_direction = Input.get_vector("move_left","move_right","move_up","move_down")
	var direction = (transform.basis * Vector3(input_direction.x, 0, input_direction.y)).normalized()
	if direction:
		velocity.x = direction.x
		velocity.z = direction.z
	else: 
		velocity.x = 0
		velocity.z = 0
	move_and_slide()
