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
var enemy_spawn_value = 0
var enemy_speed = 3
var enemy = preload("res://Scenes/Enemy.tscn")
var current_enemies = []

func _ready():
	rng.randomize()

func _physics_process(delta):
	var random = rng.randi_range(0, 100)
	
	get_node("CanvasLayer/UI/VBoxContainer/PointsInformation/PointsValue").text = str("%07d" % points)
	
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


func wave_1():
	for e in range(0, 5):
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
	enemy_starting_y = -40
	for e in range(0, 15):
		var enemy_instance = enemy.instance()
		enemy_instance.position.x = enemy_starting_x
		enemy_instance.position.y = enemy_starting_y
		if e > 6:
			enemy_starting_x -= 50
		else:
			enemy_starting_x += 50
		enemy_starting_y -= 70
		get_tree().get_root().call_deferred("add_child", enemy_instance)
		current_enemies.append(enemy_instance)

func _on_Timer_timeout():
	print(enemy_spawn_value)
	if enemy_spawn_value == 0:
		wave_1()
	elif enemy_spawn_value == 105:
		wave_2()
	elif enemy_spawn_value == 200:
		wave_3()
	
	if enemy_spawn_value > 0 and enemy_spawn_value < 15:
		enemy_state = EnemyState.ATTACK
	elif enemy_spawn_value > 45 and enemy_spawn_value < 125:
		enemy_state = EnemyState.ATTACK
	elif enemy_spawn_value > 155 and enemy_spawn_value < 230:
		enemy_state = EnemyState.ATTACK
	elif enemy_spawn_value > 230 and enemy_spawn_value < 400:
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
