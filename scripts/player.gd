extends CharacterBody2D

@export var speed: float = 130.0  # Horizontal speed
@export var gravity: float = 1200.0  # Downward gravity
@export var jumpHeight: float = 38.0  # Jump strength of player

@export var segment_scene: PackedScene
@export var segment_offset: Vector2 = Vector2(192, -192) + 1 * Vector2(128, -128) + Vector2(128, 142)
@export var segment_interval: int = 128
@export var game_speed: float = 0.75  # Maybe slower for easier difficulties?

@onready var anim := $AnimatedSprite2D

var next_spawn_x: float = 0.0

func _ready():
	Global.set_game_speed(game_speed)

func _physics_process(delta):
	
	var factor = gravity * delta
	
	# Apply gravity
	if not is_on_floor():
		velocity.y += factor
	else:
		velocity.y = 0  # reset vertical velocity when on slope or floor
		if not anim.animation == "run":
			anim.play("run")
	
	# This is it guys, the only input we will ever need :D
	if Input.is_action_just_pressed("Space"):
		if is_on_floor():
			velocity.y = -jumpHeight * factor
			anim.play("jump")
	
	if not(is_on_floor()):
		if Input.is_action_just_pressed("Space"): 
			# Trying out a ground slam that happens when you press space mid-air
			Global.set_game_speed(0.3)
			anim.play("dive")
		if anim.animation == "dive_loop" or anim.animation == "dive":
			if Input.is_action_just_released("Space"):
				Global.set_game_speed(game_speed)
				velocity.y = 200 * factor
	else:
		Global.set_game_speed(game_speed)
	
	
	# Constant movement to the right 
	velocity.x = speed

	# Move and slide with slope handling
	move_and_slide()
	
	if global_position.x >= next_spawn_x - segment_interval:
		_spawn_segment()
		next_spawn_x += segment_interval   # Move the trigger to the next multiple

func _spawn_segment():
	if segment_scene:
		var new_segment = segment_scene.instantiate()
		get_tree().current_scene.add_child(new_segment)
		
		var y = Global.y(next_spawn_x) / 2
		new_segment.global_position = Vector2(next_spawn_x, y) + segment_offset


func anim_finished() -> void:
	if anim.animation == "dive":
		anim.play("dive_loop")


func hurtbox_collision(body: Node2D) -> void:
	get_tree().reload_current_scene()
	Global.time_elapsed = 0
	Global.score = 0
