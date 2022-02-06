extends Node2D

onready var _transition_rect := $SceneTransition


func _on_Start_pressed() -> void:
	_transition_rect.transition_to("res://Scenes/Main.tscn")
	
	
func _on_Quit_pressed():
	return get_tree().quit()
