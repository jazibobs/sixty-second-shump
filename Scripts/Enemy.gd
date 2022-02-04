extends KinematicBody2D

var current_health = 3

func _physics_process(delta):
	if current_health == 0:
		$CollisionPolygon2D.disabled = true
		$Area2D/CollisionPolygon2D.disabled = true

func _on_Area2D_body_entered(body):
	
	if "Laser" in body.name:
		current_health -= 1
		
		if current_health == 0:
			$DeathSfx.play()
			$Sprite.play("Dead")
			yield($DeathSfx, "finished")
			queue_free()
		else:
			get_node("DamageParticles").emitting = true
			$TakeDamageSfx.play()
			body.queue_free()


func _on_Enemy_tree_exiting():
	if current_health == 0:
		get_tree().get_root().get_node("Main").points += 100
