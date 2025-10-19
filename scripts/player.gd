extends CharacterBody2D

@export var speed: float = 130.0  # Horizontal speed (pixels per second)
@export var gravity: float = 1200.0  # Downward gravity

@export var segment_scene: PackedScene
@export var segment_offset: Vector2 = Vector2(192, -192)
@export var segment_interval: int = 128

var next_spawn_x: float = 0.0

func _physics_process(delta):
	# Apply gravity
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.y = 0  # reset vertical velocity when on slope or floor

	# Constant movement to the right
	velocity.x = speed

	# Move and slide with slope handling
	move_and_slide()
	
	if global_position.x >= next_spawn_x:
		_spawn_segment()
		next_spawn_x += segment_interval   # Move the trigger to the next multiple

func _spawn_segment():
	if segment_scene:
		var new_segment = segment_scene.instantiate()
		get_tree().current_scene.add_child(new_segment)
		
		var y = Global.y(next_spawn_x)
		new_segment.global_position = Vector2(next_spawn_x, y) + segment_offset
		print("Spawned new segment at X =", new_segment.global_position.x)
