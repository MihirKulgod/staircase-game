extends RigidObstacle

var type := 0
@onready var anim := $AnimatedSprite2D

func init():
	rotation = -PI/6
	var mat = physics_material_override
	mat.friction = 0
	mat.bounce   = 0
	gravity_scale = 0.7
	
	spawn_arrow(Color(0.788, 0.0, 0.0, 1.0))
