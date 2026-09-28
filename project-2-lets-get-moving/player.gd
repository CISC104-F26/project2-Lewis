extends Sprite2D

var normal_speed = 300
var sprint_speed = 600
var direction: Vector2

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("move_up"): direction = Vector2(0,-1)
	elif Input.is_action_pressed("move_down"): direction = Vector2(0,1)
	elif Input.is_action_pressed("move_left"): direction = Vector2(-1,0)
	elif Input.is_action_pressed("move_right"): direction = Vector2(1,0)
	else: direction = Vector2.ZERO
	
	if Input.is_action_pressed("sprint"):
		position = position + direction * sprint_speed * delta
	else: position = position + direction * normal_speed * delta
	
	if Input.is_action_just_pressed("click"):
		global_position = get_global_mouse_position()
