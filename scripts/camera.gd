extends Camera2D

@export var target: Node2D
@export var camera_offset: Vector2

func _process(_delta):
	if target:
		global_position = Vector2(target.position.x, Global.y(target.position.x) / 2) + camera_offset
