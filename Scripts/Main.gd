extends Node2D

enum TouchState {TOUCHED, UNTOUCHED}


func _on_LeftBtn_pressed():
	_manage_button_look($UI/VBoxContainer/TouchControls/LeftBtn, TouchState.TOUCHED)


func _on_LeftBtn_released():
	_manage_button_look($UI/VBoxContainer/TouchControls/LeftBtn, TouchState.UNTOUCHED)


func _on_RightBtn_pressed():
	_manage_button_look($UI/VBoxContainer/TouchControls/RightBtn, TouchState.TOUCHED)


func _on_RightBtn_released():
	_manage_button_look($UI/VBoxContainer/TouchControls/RightBtn, TouchState.UNTOUCHED)


func _on_FireBtn_pressed():
	_manage_button_look($UI/VBoxContainer/TouchControls/FireBtn, TouchState.TOUCHED)


func _on_FireBtn_released():
	_manage_button_look($UI/VBoxContainer/TouchControls/FireBtn, TouchState.UNTOUCHED)


func _manage_button_look(node, state):
	if state == TouchState.TOUCHED:
		node.modulate.a = 1
	elif state == TouchState.UNTOUCHED:
		node.modulate.a = 0.75
