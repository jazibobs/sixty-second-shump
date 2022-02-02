extends KinematicBody2D


const UP_DIRECTION := Vector2.UP

export var speed := 400
var _velocity := Vector2.ZERO

func _physics_process(_delta: float):
	
	var _horizontal_direction = (
		Input.get_action_strength("move_right") 
		- Input.get_action_strength("move_left")
	)
	
	_velocity.x = _horizontal_direction * speed
	_velocity.y = 0
	_velocity = move_and_slide(_velocity, UP_DIRECTION)
