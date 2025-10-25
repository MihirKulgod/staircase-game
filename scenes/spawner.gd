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
var spawn_queue = [{
	"object": "red_ambulance",
	"count": 10, 
	"spawn_delay": 1, 
	"wait": 2
}, {
	"object": "blue_ambulance",
	"count": 100, 
	"spawn_delay": 0.1, 
	"wait": 2,
	"concurrent": true
}, {
	"object": "blue_ambulance",
	"count": 1, 
	"spawn_delay": 0.1, 
	"wait": 10,
}, 
] 

func _ready() -> void:
	randomize()
	set_new_spawn_interval()
	
	for weight in weights.values():
		sumWeights += weight

func _process(delta: float) -> void:
	time_passed += delta
	# First clear through the spawn queue
	# print(str(time_passed), " / ", str(current_spawn_interval))
	if len(spawn_queue) > 0:
		var to_spawn = spawn_queue[0]
		if to_spawn.get("concurrent") or time_passed > to_spawn.get("wait"):
			for i in range(to_spawn.get("count")):
				var delay = to_spawn.get("spawn_delay", 0.01)  #prevents spawning too fast
				spawn_after(to_spawn.get("object"), delay * i)
			spawn_queue.pop_front()
			time_passed = 0
			# Lemme know if we want to change this behaviour
			# we can set time_passed to negative if we want the next to spawn
			# AFTER we finished spawning
		return
	
	if time_passed >= current_spawn_interval:
		spawn_clone()
		time_passed = 0
		set_new_spawn_interval()

	spawn_interval = starting_spawn_interval * (Global.difficulty ** 3)

func set_new_spawn_interval():
	current_spawn_interval = randf_range(spawn_interval.x, spawn_interval.y)

func spawn_after(obj: String, sec: float):
	await get_tree().create_timer(sec).timeout
	spawn_clone(obj)
	
	
func spawn_clone(obj: String = ""):
	var obstacle_to_spawn
	obstacle_to_spawn = obstacles.get(obj)
	if not obstacle_to_spawn:
		obstacle_to_spawn = chooseObstacle()
	var clone = obstacle_to_spawn.instantiate()
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
