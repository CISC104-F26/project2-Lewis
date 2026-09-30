extends CharacterBody3D

const JUMP_VELOCITY = 6
var friction_factor = 15 #1/x th of velocity is lost per frame
var mouse_sensitivity = .005
var is_standing: bool
var direction: Vector3

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
	is_standing = true
	var move_speed = 5
	#change camera sensitivity with scroll wheel
	if Input.is_action_just_pressed("scroll_up"): mouse_sensitivity += mouse_sensitivity * 0.1
	elif Input.is_action_just_pressed("scroll_down"): mouse_sensitivity -= mouse_sensitivity / 20
	
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	if Input.is_action_pressed("fly_down"):
		is_standing = false
		move_speed /= 2
		
	if Input.is_action_just_pressed("slide") and is_on_floor() and is_standing:
		is_standing = false
		direction = -global_transform.basis.z.normalized()
		move_speed *= 2
		velocity.x = direction.x * move_speed
		velocity.z = direction.z * move_speed
		
	elif Input.is_action_pressed("slide"):
		is_standing = false
		friction_factor = 120
	
	else:
		var input_direction := Input.get_vector("move_left","move_right","move_up","move_down")
		if input_direction:
			friction_factor = 15
			direction = (transform.basis * Vector3(input_direction.x, 0, input_direction.y)).normalized()
			velocity.x = direction.x * move_speed
			velocity.z = direction.z * move_speed
			#sprint speed when on floor and with dir input only
			if Input.is_action_pressed("sprint") and is_standing:
				velocity.x *= 2
				velocity.z *= 2
				
	#if theres no imput and youre on floor: apply friction to dampen velocity
	if is_on_floor():
		if Input.is_action_just_pressed("fly_up") and is_standing: velocity.y = JUMP_VELOCITY
		velocity.x -= (velocity.x / friction_factor)
		velocity.z -= (velocity.z / friction_factor)
		
	if is_standing: 
		$CollisionShape3D.shape.height = 2
	else: 
		$CollisionShape3D.shape.height = 1
	move_and_slide()
