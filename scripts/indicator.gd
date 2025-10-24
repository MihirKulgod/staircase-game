extends Node2D

var player : Node2D = null
@export var min_distance := 80

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	
func _process(_delta: float) -> void:
	rotation = -get_parent().rotation
	global_position = Vector2(min(get_parent().global_position.x, player.global_position.x + 200), Global.y(player.global_position.x/2) - min_distance)
	
	var distance = get_parent().global_position.y - global_position.y
	if distance >= -20:
		queue_free()
	else:
		visible = (0 == (int(Global.time_elapsed * 100) / 8) % 2)

func set_color(color : Color):
	modulate = color
