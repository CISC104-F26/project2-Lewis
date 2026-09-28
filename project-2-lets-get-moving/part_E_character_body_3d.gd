extends CharacterBody3D

var move_speed = 100
const JUMP_VELOCITY = 4.5

func _ready() -> void:
	pass


func _process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
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
