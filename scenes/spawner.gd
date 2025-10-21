extends Node

@export var ambulance: PackedScene
@export var player: CharacterBody2D
@export var starting_spawn_interval := Vector2(2, 3.5)
@export var spawner_offset: Vector2

var spawn_interval := starting_spawn_interval

var time_passed : float = 0.0
var current_spawn_interval : float = 0.0

func _ready() -> void:
	randomize()
	set_new_spawn_interval()

func _process(delta: float) -> void:
	time_passed += delta
	# print(str(time_passed), " / ", str(current_spawn_interval))
	
	if time_passed >= current_spawn_interval:
		
		spawn_clone()
		time_passed = 0
		set_new_spawn_interval()
	
	spawn_interval = starting_spawn_interval * Global.difficulty

func set_new_spawn_interval():
	current_spawn_interval = randf_range(spawn_interval.x, spawn_interval.y)
	
func spawn_clone():
	var clone = ambulance.instantiate()
	clone.position = Vector2(player.position.x, Global.y(player.position.x) / 2) + spawner_offset
	clone.init()
	add_child(clone)
