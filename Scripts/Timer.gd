extends HBoxContainer


enum TimerState { VISIBLE, HIDDEN }

export (int) var seconds
var ms = 0
var timer_on_screen = TimerState.VISIBLE

func _physics_process(_delta):
	if seconds == 0 and ms == 0 and timer_on_screen == TimerState.VISIBLE:
		$Timer.stop()
		_fade_out_timer()
	
	if seconds > 0 and ms <= 0:
		seconds -= 1
		ms = 10
	
	if seconds >= 10:
		$TimerValueSec.set_text(str(seconds))
	else:
		$TimerValueSec.set_text("0" + str(seconds))
	
	if ms >= 10:
		$TimerValueMs.set_text(str(ms))
	else:
		$TimerValueMs.set_text("0" + str(ms))


func _fade_out_timer():
	if get_node(".").modulate.a > 0:
		get_node(".").modulate.a -= 0.02
	else:
		timer_on_screen = TimerState.HIDDEN


func _on_Timer_timeout():
	ms -= 1
