extends Camera2D

@export var target: Node2D

func _process(delta):
	if target:
		global_position = Vector2(target.position.x, Global.y(target.position.x)) + Vector2(-48, -80)
