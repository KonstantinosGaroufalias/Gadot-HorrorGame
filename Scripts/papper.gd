extends StaticBody3D


@export var paper_material: StandardMaterial3D
@export var paper_ui_texture: Texture2D


var toggle: bool = false

func _ready():
	$paper_mesh.material_override = paper_material
	
func interact():
	toggle = !toggle
	$AudioStreamPlayer.play()
	get_node("/root/" + get_tree().current_scene.name + "/UI/paper").texture = paper_ui_texture
	get_node("/root/" + get_tree().current_scene.name + "/UI/paper").visible = toggle
	get_node("/root/" + get_tree().current_scene.name + "/Player").movable = !toggle
	get_node("/root/" + get_tree().current_scene.name + "/Player/head").movable = !toggle
