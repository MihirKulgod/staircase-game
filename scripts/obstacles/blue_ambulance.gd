extends RigidObstacle

var type := 0
@onready var anim := $AnimatedSprite2D

func init():
	rotation = 0
	var mat = physics_material_override
	mat.friction = 1
	mat.bounce   = 1.5
	
	gravity_scale = 0.8
	
	linear_velocity = Vector2(0, 0)
	global_position += Vector2(0, 0)
	
	spawn_arrow(Color(0.004, 0.415, 0.768, 1.0))
