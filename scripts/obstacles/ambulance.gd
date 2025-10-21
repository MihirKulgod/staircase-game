extends RigidObstacle

func init():
	rotation = randf_range(0, -PI/6)
	
	var mat = physics_material_override
	mat.friction = randf_range(0.0, 1.0)
	mat.bounce   = randf_range(0.0, 1.0) ** 3
