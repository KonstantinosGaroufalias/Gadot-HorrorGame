extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$cutscene_anim_player.play("beggining")
	$cutscene_cam.current = true
	await get_tree().create_timer(6.1,false).timeout
	get_node("/root/"+get_tree().current_scene.name+"/Player").movable = true
	get_node("/root/"+get_tree().current_scene.name+"/Player/head/Camera3D").current = true
	get_node("/root/"+get_tree().current_scene.name+"/Player/head").movable = true

	$cutscene_cam.current = false
	queue_free()
