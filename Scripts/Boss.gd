extends KinematicBody2D

var max_health = 100
var current_health = max_health
var health_bar_width
var new_health_width
var rng = RandomNumberGenerator.new()

var laser_speed := 5
var laser = preload("res://Scenes/Laser.tscn")
var lasers = []
var laser_wait = false

func _ready():
	health_bar_width = $HealthBar/CurrentHealth.scale.y 
	# print("Init width:", health_bar_width)
	new_health_width = health_bar_width
	rng.randomize()


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
			if laser_wait == true:
				shot.get_node("CollisionShape2D").disabled = true
				
			shot.position.y += laser_speed
		
			if shot.position.y < 0:
				shot.queue_free()


func fire_weapon():
	var colors = [Color(0.937, 0.968, 255.0),
		  Color(0.909, 0.859, 0.490),
		  Color(0.333, 0.549, 0.549),
		  Color(0.509, 0.125, 0.290),
		  Color(0.478, 0.898, 0.509),
		  Color(0.623, 1, 0.796)]
	
	var which_gun = rng.randi_range(0, 5)
	var gun_positions = [0, 0, 0, 0]
	
		
	var laser_instance_l = laser.instance()
	var laser_instance_r = laser.instance()
	
	laser_instance_l.modulate = colors[randi() % colors.size()]
	laser_instance_r.modulate = colors[randi() % colors.size()]
	
	
	if which_gun == 0:
		gun_positions = [30, 30]
	elif which_gun == 1:
		gun_positions = [64, 22]
	elif which_gun == 2:
		gun_positions = [80, 22]
	elif which_gun == 3:
		gun_positions = [110, 30]
	elif which_gun == 4:
		gun_positions = [120, 30]
	elif which_gun == 5:
		gun_positions = [156, 43]
		
	laser_instance_l.position.x = -gun_positions[0]
	laser_instance_l.position.y = gun_positions[1]
	
	laser_instance_r.position.x = gun_positions[0]
	laser_instance_r.position.y = gun_positions[1]
	
	add_child(laser_instance_l)
	add_child(laser_instance_r)
	
	$LaserSfx.play() 
	
	lasers.append(laser_instance_l)
	lasers.append(laser_instance_r)

func _on_Area2D_body_entered(body):
	if "Laser" in body.name:
		get_tree().get_root().get_node("Main").points += 50
		current_health -= 1
		new_health_width = health_bar_width * (float(current_health) / float(max_health))
		# print(new_health_width)
		
		if current_health == 0:
			laser_wait = true
			$DeathSfx.play()
			$Sprite.play("Damage")
			yield($DeathSfx, "finished")
			visible = false
			get_tree().get_root().get_node("Main").points += 5000
			queue_free()
		else:
			get_node("DamageParticles").emitting = true
			$TakeDamageSfx.play()
			body.queue_free()


func _on_Boss_tree_exiting():
	get_tree().get_root().get_node("Main").boss_defeat()
