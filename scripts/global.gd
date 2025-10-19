extends Node

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()

func y(x):
	return -1 * x
