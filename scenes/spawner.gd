extends Node

@export var ambulance: PackedScene
@export var player: CharacterBody2D
@export var spawn_interval: Vector2 = Vector2(2, 20)
@export var spawner_offset: Vector2

var time_passed = 0.0
var current_spawn_interval = 0.0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	set_new_spawn_interval()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time_passed += delta
	if time_passed >= current_spawn_interval:
		print("Should be spawning...")
		spawn_clone()
		time_passed = 0.0

func set_new_spawn_interval():
	current_spawn_interval = randf_range(spawn_interval.x, spawn_interval.y)
	
func spawn_clone():
	var clone = ambulance.instantiate()
	clone.position = Vector2(player.position.x, Global.y(player.position.x) / 2) + spawner_offset
	# Random rotation between 0 and 2*PI radians
	clone.rotation = randf() * TAU
	add_child(clone)
	print("Spawned a clone!")
