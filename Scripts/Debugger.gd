extends Node2D

enum TouchState {TOUCHED, UNTOUCHED}
enum EnemyState {STILL, ATTACK}

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
	wave_1()

func _physics_process(_delta):	
	var enemy_fire = rng.randi_range(0, 100)

	for e in current_enemies:
		if !is_instance_valid(e):
			current_enemies.erase(e)
		elif is_instance_valid(e):
			# Chance for enemy to fire back
			if enemy_fire == 20:
				e.fire_weapon()
			
			if enemy_state == EnemyState.ATTACK:
				e.position.y  += enemy_speed
			elif enemy_state == EnemyState.STILL:
				e.position.y = e.position.y
				
			if e.position.y > 900:
				e.queue_free()


func wave_1():
	for _e in range(0, 5):
		var enemy_instance = enemy.instance()
		enemy_instance.position.y = 80
		enemy_instance.position.x = enemy_starting_x
		enemy_starting_x += 75
		get_tree().get_root().call_deferred("add_child", enemy_instance)
		current_enemies.append(enemy_instance)
