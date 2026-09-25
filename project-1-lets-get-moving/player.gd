extends Sprite2D

var move_speed = 100
var direction: Vector2

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("move_up"): direction = Vector2(0,-1)
	elif Input.is_action_pressed("move_down"): direction = Vector2(0,1)
	elif Input.is_action_pressed("move_left"): direction = Vector2(-1,0)
	elif Input.is_action_pressed("move_right"): direction = Vector2(1,0)
	
	position = position + direction * move_speed * delta
