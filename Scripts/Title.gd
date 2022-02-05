extends Node2D


func _on_Start_pressed():
	return get_tree().change_scene("res://Scenes/Main.tscn")
	


func _on_Quit_pressed():
	return get_tree().quit()
