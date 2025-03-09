extends MeshInstance3D

@export var outline_color: Color = Color(1, 0, 0, 1)  # Bright red for high contrast
@export var outline_width: float = 0.2

func _ready():
	# Use call_deferred to ensure mesh is fully loaded
	call_deferred("create_mesh_outline")

func create_mesh_outline():
	if mesh:
		var mesh_outline = mesh.create_outline(outline_width)
		var new_mesh = MeshInstance3D.new()
		new_mesh.name = "Outline"
		add_child(new_mesh)
		new_mesh.mesh = mesh_outline
		
		# Create an unshaded material that ignores lighting
		var outline_material = StandardMaterial3D.new()
		outline_material.albedo_color = outline_color
		outline_material.emission_enabled = true  # Make it emit light
		outline_material.emission = outline_color  # Same color as albedo
		outline_material.emission_energy = 2.0  # Make it glow
		outline_material.flags_unshaded = true  # Ignore lighting
		outline_material.cull_mode = StandardMaterial3D.CULL_BACK  # Show front faces
		
		# Apply the material to the outline mesh
		new_mesh.material_override = outline_material
	else:
		print("Error: Mesh is null, cannot create outline")
