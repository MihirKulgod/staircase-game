extends CharacterBody2D

@export var speed: float = 130.0  # Horizontal speed
@export var gravity: float = 1200.0  # Downward gravity
@export var jump_power: float = 10 # Controls how high the player can jump
@export var slam_power: float = 25 # Controls how fast the player slams downward

@export var segment_scene: PackedScene
@export var segment_offset: Vector2 = Vector2(192, -192)
@export var segment_interval: int = 128

@onready var anim := $AnimatedSprite2D

var next_spawn_x: float = 0.0

func _ready():
	pass

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
			velocity.y = -jump_power * factor
			anim.play("jump")
		else: # Trying out a ground slam that happens when you press space mid-air
			velocity.y = slam_power * factor
			anim.play("dive")
	
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
		print("Spawned new segment at X =", new_segment.global_position.x)


func anim_finished() -> void:
	if anim.animation == "dive":
		anim.play("dive_loop")


func hurtbox_collision(body: Node2D) -> void:
	get_tree().reload_current_scene()
	Global.time_elapsed = 0
	Global.score = 0
