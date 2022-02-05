extends KinematicBody2D

var max_health = 6
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
		
	if current_health == 6:
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
	
	if laser_wait == true and lasers.size() == 0:
		queue_free()


func fire_weapon():
	var colors = [Color(0.937, 0.968, 255.0),
		  Color(0.909, 0.859, 0.490),
		  Color(0.333, 0.549, 0.549),
		  Color(0.509, 0.125, 0.290),
		  Color(0.478, 0.898, 0.509),
		  Color(0.623, 1, 0.796)]
		
	var laser_instance_l = laser.instance()
	var laser_instance_r = laser.instance()
	
	laser_instance_l.modulate = colors[randi() % colors.size()]
	laser_instance_r.modulate = colors[randi() % colors.size()]
	
	laser_instance_l.position.x = get_global_position().x - 16
	laser_instance_l.position.y = get_global_position().y + 50
	
	laser_instance_r.position.x = get_global_position().x + 16
	laser_instance_r.position.y = get_global_position().y + 50
	
	get_tree().get_root().call_deferred("add_child", laser_instance_l)
	get_tree().get_root().call_deferred("add_child", laser_instance_r)
	
	$LaserSfx.play() 
	
	lasers.append(laser_instance_l)
	lasers.append(laser_instance_r)

func _on_Area2D_body_entered(body):
	if "Laser" in body.name:
		current_health -= 1
		new_health_width = health_bar_width * (float(current_health) / float(max_health))
		# print(new_health_width)
		
		if current_health == 0:
			$DeathSfx.play()
			$Sprite.play("Damage")
			yield($DeathSfx, "finished")
			visible = false
			laser_wait = true
		else:
			get_node("DamageParticles").emitting = true
			$TakeDamageSfx.play()
			body.queue_free()



func _on_Enemy_tree_exiting():
	if current_health == 0:
		get_tree().get_root().get_node("Main").points += 500
