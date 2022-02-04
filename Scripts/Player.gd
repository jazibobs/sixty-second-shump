extends KinematicBody2D

enum PlayerState {ACTIVE, DEAD}

const UP_DIRECTION := Vector2.UP

var status = PlayerState.ACTIVE
var speed := 750
var laser_speed := 5
var laser = preload("res://Scenes/Laser.tscn")
var lasers = []

var _velocity := Vector2.ZERO


func _physics_process(_delta: float):
	
	var _horizontal_direction = (
			Input.get_action_strength("move_right") 
			- Input.get_action_strength("move_left")
		)
	
	_velocity.x = _horizontal_direction * speed
	
	_velocity.y = 0
	_velocity = move_and_slide(_velocity, UP_DIRECTION)
	
	for shot in lasers:
		if !is_instance_valid(shot):
			lasers.erase(shot)
		
	for shot in lasers:
		if is_instance_valid(shot):
			shot.position.y -= laser_speed
		
			if shot.position.y < 0:
				shot.queue_free()
	
	if Input.is_action_just_pressed("fire_weapon") && status == PlayerState.ACTIVE:
		fire_weapon()
	
	if status == PlayerState.DEAD:
		$CollisionPolygon2D.disabled = true
		$Area2D/CollisionPolygon2D.disabled = true
		


func fire_weapon():
	var laser_instance = laser.instance()
	laser_instance.position.x = get_global_position().x
	laser_instance.position.y = get_global_position().y - 50
	get_tree().get_root().call_deferred("add_child", laser_instance)
	$LaserSfx.play(0.0)
	lasers.append(laser_instance)


func _on_Area2D_body_entered(body):
	if "Enemy" in body.name:
		status = PlayerState.DEAD
		_velocity = Vector2.ZERO
		get_node("DeadSfx").play(0.0)
		get_node("DamageParticles").emitting = true
		$ShipBody.play("Dead")
		yield($ShipBody, "animation_finished")
		queue_free()


func _on_Weapons_tree_exiting():
	get_tree().get_root().get_node("Main/CanvasLayer/UI/VBoxContainer/TimerInfomation/Timer").stop()
