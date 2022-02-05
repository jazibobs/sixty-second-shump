extends Node2D

enum TouchState {TOUCHED, UNTOUCHED}
enum EnemyState {STILL, ATTACK}

onready var LeftBtn = $CanvasLayer/UI/VBoxContainer/TouchControls/LeftBtn
onready var RightBtn = $CanvasLayer/UI/VBoxContainer/TouchControls/RightBtn
onready var FireBtn = $CanvasLayer/UI/VBoxContainer/TouchControls/FireBtn

var rng = RandomNumberGenerator.new()
var points = 0

var enemy_state = EnemyState.STILL
var enemy_starting_x = 38
var enemy_starting_y = -40
var enemy_spawn_value
var enemy_speed = 3
var enemy = preload("res://Scenes/Enemy.tscn")
var enemy_level_2 = preload("res://Scenes/EnemyLevel2.tscn")
var boss_enemy = preload("res://Scenes/Boss.tscn")
var current_enemies = []
var player_wins = false


func _ready():
	player_wins = false
	rng.randomize()
	get_tree().paused = false
	$CanvasLayer/UI/VBoxContainer/TouchControls/RetryBtn.visible = false
	$CanvasLayer/UI/VBoxContainer/TouchControls/ReturnBtn.visible = false
	$CanvasLayer/Logo.visible = false
	$CanvasLayer/Congratulations.visible = false
	enemy_spawn_value = 0


func _physics_process(_delta):	
	var enemy_fire = rng.randi_range(0, 60)
	get_node("CanvasLayer/UI/VBoxContainer/PointsInformation/PointsValue").text = str("%05d" % points)
	
	for e in current_enemies:
		if !is_instance_valid(e):
			current_enemies.erase(e)
		elif is_instance_valid(e):
			
			if enemy_state == EnemyState.ATTACK:
				e.position.y  += enemy_speed
			elif enemy_state == EnemyState.STILL:
				e.position.y = e.position.y
				
			if e.position.y > 900:
				e.queue_free()
	
	if enemy_fire == 20 and current_enemies.size() > 0:
		var rand_enemy = randi() % current_enemies.size()
		if is_instance_valid(current_enemies[rand_enemy]) and current_enemies[rand_enemy].laser_wait == false:
			current_enemies[rand_enemy].fire_weapon()
	
	if player_wins and $BossMusic.playing and $BossMusic.volume_db > -80.0:
		# print("Decrease volume!")
		$BossMusic.volume_db -= 0.5
		
	
	if $BossMusic.volume_db < -65.0 and !$GameoverMusic.playing:
		$BossMusic.stop()
		$GameoverMusic.play()
		$CanvasLayer/UI/VBoxContainer/TouchControls/RetryBtn.visible = true
		$CanvasLayer/Logo.visible = true
		$CanvasLayer/Congratulations.visible = true
		

func boss_defeat():
	print("Bossed it")
	player_wins = true


func wave_1():
	for _e in range(0, 5):
		var enemy_instance = enemy.instance()
		enemy_instance.position.y = -40
		enemy_instance.position.x = enemy_starting_x
		enemy_starting_x += 75
		get_tree().get_root().call_deferred("add_child", enemy_instance)
		current_enemies.append(enemy_instance)
		
		
func wave_2():
	enemy_starting_x = 37
	for e in range(0, 7):
		var enemy_instance = enemy.instance()
		if e % 2 == 0:
			enemy_instance.position.y = -120
		else:
			enemy_instance.position.y = -40
		enemy_instance.position.x = enemy_starting_x
		enemy_starting_x += 50
		get_tree().get_root().call_deferred("add_child", enemy_instance)
		current_enemies.append(enemy_instance)


func wave_3():
	enemy_starting_x = 37
	enemy_starting_y = -38
	for e in range(0, 12):
		var enemy_instance = enemy.instance()
		enemy_instance.position.x = enemy_starting_x
		enemy_instance.position.y = enemy_starting_y
		if e > 6:
			enemy_starting_x -= 43
		else:
			enemy_starting_x += 43
		enemy_starting_y -= 80
		get_tree().get_root().call_deferred("add_child", enemy_instance)
		current_enemies.append(enemy_instance)


func wave_4():
	enemy_starting_x = 38
	enemy_starting_y = -120
	for e in range(0, 5):
		var enemy_instance = enemy_level_2.instance()
		enemy_instance.position.y = enemy_starting_y
		enemy_instance.position.x = enemy_starting_x
		
		if e > 1:
			enemy_starting_y -= 60
		else:
			enemy_starting_y += 60
		
		enemy_starting_x += 75
		get_tree().get_root().call_deferred("add_child", enemy_instance)
		current_enemies.append(enemy_instance)


func wave_5():
	enemy_starting_x = 37
	for e in range(0, 7):
		var enemy_instance = enemy_level_2.instance()
		if e % 2 == 0:
			enemy_instance.position.y = -120
		else:
			enemy_instance.position.y = -40
		enemy_instance.position.x = enemy_starting_x
		enemy_starting_x += 50
		get_tree().get_root().call_deferred("add_child", enemy_instance)
		current_enemies.append(enemy_instance)
	
	
func wave_6():
	var boss_instance = boss_enemy.instance()
	boss_instance.position.x = 187.5
	boss_instance.position.y = -40
	get_tree().get_root().call_deferred("add_child", boss_instance)
	current_enemies.append(boss_instance)


func _on_Timer_timeout():
	# print(enemy_spawn_value)
	if enemy_spawn_value == 0:
		wave_1()
	elif enemy_spawn_value == 95:
		wave_2()
	elif enemy_spawn_value == 200:
		wave_3()
	elif enemy_spawn_value == 310:
		wave_4()
	elif enemy_spawn_value == 435:
		wave_5()
	elif enemy_spawn_value == 585:
		wave_6()
		
	if enemy_spawn_value > 570 and $BgMusic.volume_db > -80.0:
		$BgMusic.volume_db -= 1.5
	
	if enemy_spawn_value == 599 and $BossMusic.playing == false:
		$BgMusic.stop()
		$BossMusic.play()
	
	if enemy_spawn_value > 0 and enemy_spawn_value < 15:
		enemy_state = EnemyState.ATTACK
	elif enemy_spawn_value > 35 and enemy_spawn_value < 115:
		enemy_state = EnemyState.ATTACK
	elif enemy_spawn_value > 155 and enemy_spawn_value < 230:
		enemy_state = EnemyState.ATTACK
	elif enemy_spawn_value > 230 and enemy_spawn_value < 327:
		enemy_state = EnemyState.ATTACK
	elif enemy_spawn_value > 345 and enemy_spawn_value < 355:
		enemy_state = EnemyState.ATTACK
	elif enemy_spawn_value > 395 and enemy_spawn_value < 430:
		enemy_state = EnemyState.ATTACK
	elif enemy_spawn_value > 435 and enemy_spawn_value < 455:
		enemy_state = EnemyState.ATTACK
	elif enemy_spawn_value > 520 and enemy_spawn_value < 598:
		enemy_state = EnemyState.ATTACK
	else:
		enemy_state = EnemyState.STILL
	
	enemy_spawn_value += 1
	


func _on_LeftBtn_pressed():
	_manage_button_look(LeftBtn, TouchState.TOUCHED)


func _on_LeftBtn_released():
	_manage_button_look(LeftBtn, TouchState.UNTOUCHED)


func _on_RightBtn_pressed():
	_manage_button_look(RightBtn, TouchState.TOUCHED)


func _on_RightBtn_released():
	_manage_button_look(RightBtn, TouchState.UNTOUCHED)


func _on_FireBtn_pressed():
	_manage_button_look(FireBtn, TouchState.TOUCHED)


func _on_FireBtn_released():
	_manage_button_look(FireBtn, TouchState.UNTOUCHED)


func _manage_button_look(node, state):
	if state == TouchState.TOUCHED:
		node.modulate.a = 1
	elif state == TouchState.UNTOUCHED:
		node.modulate.a = 0.75


func _on_RetryBtn_pressed():
	for e in current_enemies:
		e.queue_free()
	
	var lasers = get_tree().get_nodes_in_group("Lasers")
	
	for shot in lasers:
		var children = shot.get_children()
		for child in children:
			child.queue_free()
		shot.queue_free()
	
	return get_tree().reload_current_scene()


func _on_ReturnBtn_pressed():
	return get_tree().change_scene("res://Scenes/Title.tscn")
