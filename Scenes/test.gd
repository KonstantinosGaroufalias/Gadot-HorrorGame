extends Node3D

@export var target_mesh: MeshInstance3D
@export var outline_color: Color = Color(1, 0.5, 0, 1)  # Orange outline
@export var outline_width: float = 0.05

func _ready():
	if target_mesh:
		apply_outline()

func apply_outline():
	# Create the outline duplicate
	var outline = target_mesh.duplicate()
	outline.name = "Outline"
	target_mesh.add_child(outline)
	
	# Create shader material
	var shader_material = ShaderMaterial.new()
	shader_material.shader = load_outline_shader()
	
	# Set shader parameters
	shader_material.set_shader_parameter("outline_color", outline_color)
	shader_material.set_shader_parameter("outline_width", outline_width)
	
	# Apply shader to the outline mesh
	for i in range(outline.get_surface_override_material_count()):
		outline.set_surface_override_material(i, shader_material)

func load_outline_shader():
	var shader = Shader.new()
	shader.code = """
	shader_type spatial;
	render_mode cull_front, unshaded;
	
	uniform vec4 outline_color : source_color = vec4(1.0, 0.5, 0.0, 1.0);
	uniform float outline_width : hint_range(0.0, 0.1) = 0.05;
	
	void vertex() {
		VERTEX += NORMAL * outline_width;
	}
	
	void fragment() {
		ALBEDO = outline_color.rgb;
		ALPHA = outline_color.a;
	}
	"""
	return shader

func remove_outline():
	if target_mesh.has_node("Outline"):
		target_mesh.get_node("Outline").queue_free()
