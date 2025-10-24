extends Node

@export var player: CharacterBody2D
@export var starting_spawn_interval := Vector2(2, 3.5)
@export var spawner_offset: Vector2

var spawn_interval := starting_spawn_interval

var time_passed : float = 0.0
var current_spawn_interval : float = 0.0

@onready var weights := {
	"red_ambulance": 10,
	"blue_ambulance": 5
}

@onready var obstacles := {
	"red_ambulance": preload("res://scenes/obstacles/ambulance.tscn"),
	"blue_ambulance": preload("res://scenes/obstacles/blue_ambulance.tscn")
}

var sumWeights := 0

func _ready() -> void:
	randomize()
	set_new_spawn_interval()
	
	for weight in weights.values():
		sumWeights += weight

func _process(delta: float) -> void:
	time_passed += delta
	# print(str(time_passed), " / ", str(current_spawn_interval))
	
	if time_passed >= current_spawn_interval:
		
		spawn_clone()
		time_passed = 0
		set_new_spawn_interval()
	
	spawn_interval = starting_spawn_interval * (Global.difficulty ** 3)

func set_new_spawn_interval():
	current_spawn_interval = randf_range(spawn_interval.x, spawn_interval.y)
	
func spawn_clone():
	var clone = chooseObstacle().instantiate()
	clone.position = Vector2(player.position.x, Global.y(player.position.x) / 2) + spawner_offset
	clone.init()
	add_child(clone)
	
func chooseObstacle() -> PackedScene:
	var maxIncreases = 5
	var increases = 0
	
	var r = randi() % sumWeights
	var n = randf_range(0, 1)
	while(n > Global.difficulty):
		n = randf_range(0, 1)
		r += 1
		increases += 1
		
		if increases >= maxIncreases:
			break
	
	for key in weights.keys():
		r -= weights.get(key)
		if r < 0:
			return obstacles.get(key)
	return obstacles.get(weights.keys()[len(weights.keys()) - 1])
