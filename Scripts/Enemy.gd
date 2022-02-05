extends KinematicBody2D

var max_health = 3
var current_health = max_health
var health_bar_width
var new_health_width

var laser_speed := 5
var laser = preload("res://Scenes/Laser.tscn")
var lasers = []
var laser_wait = false

func _ready():
	health_bar_width = $HealthBar/CurrentHealth.scale.y 
	# print("Init width:", health_bar_width)
	new_health_width = health_bar_width


func _physics_process(_delta):
	if current_health == 0:
		$CollisionPolygon2D.disabled = true
		$Area2D/CollisionPolygon2D.disabled = true
		
	if current_health == 3:
		$HealthBar/CurrentHealth.visible = false
	else:
		$HealthBar/CurrentHealth.visible = true
	
	$HealthBar/CurrentHealth.scale.y = new_health_width
	
	for shot in lasers:
		if !is_instance_valid(shot):
			lasers.erase(shot)
		
	for shot in lasers:
		if is_instance_valid(shot):
			shot.position.y += laser_speed
		
			if shot.position.y < 0:
				shot.queue_free()
				


func fire_weapon():
	pass

func _on_Area2D_body_entered(body):
	if "Laser" in body.name:
		current_health -= 1
		new_health_width = health_bar_width * (float(current_health) / float(max_health))
		# print(new_health_width)
		
		if current_health == 0:
			$DeathSfx.play()
			$Sprite.play("Damage")
			yield($DeathSfx, "finished")
			queue_free()
		else:
			get_node("DamageParticles").emitting = true
			$TakeDamageSfx.play()
			body.queue_free()


func _on_Enemy_tree_exiting():
	if current_health == 0:
		get_tree().get_root().get_node("Main").points += 100
