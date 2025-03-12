extends MeshInstance3D

@export var update_collisions: bool = false

func _process(delta):
	if update_collisions:
		update_collisions = false
		generate_collisions()
		
func generate_collisions():
	# Iterate through all children that need collision shapes
	for child in get_children():
		if child is MeshInstance3D:
			# Create collision shape that matches the mesh
			var static_body = StaticBody3D.new()
			var collision_shape = CollisionShape3D.new()
			# Set up collision shape based on mesh properties
			# ...
			static_body.add_child(collision_shape)
			child.add_child(static_body)
