extends CharacterBody3D

var direction: Vector3
var normal_speed = 50
var sprint_speed = 100

func _ready() -> void:
	pass


func _process(delta: float) -> void:
	if Input.is_action_pressed("move_up"): direction = Vector3(0,0,-1)
	elif Input.is_action_pressed("move_down"): direction = Vector3(0,0,1)
	elif Input.is_action_pressed("move_left"): direction = Vector3(-1,0,0)
	elif Input.is_action_pressed("move_right"): direction = Vector3(1,0,0)
	elif Input.is_action_pressed("fly_up"): direction = Vector3(0,1,0)
	elif Input.is_action_pressed("fly_down"): direction = Vector3(0,-1,0)
	else: direction = Vector3.ZERO
	
	if Input.is_action_pressed("sprint"): 
		position = position + (direction * sprint_speed * delta)
	else: 
		position = position + (direction * normal_speed * delta)
