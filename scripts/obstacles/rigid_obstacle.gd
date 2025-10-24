extends RigidBody2D

class_name RigidObstacle

var Indicator := preload("res://scenes/indicator.tscn")

func init():
	spawn_arrow()

func spawn_arrow(color := Color.WHITE):
	var arrow = Indicator.instantiate()
	add_child(arrow)
	arrow.modulate = color
