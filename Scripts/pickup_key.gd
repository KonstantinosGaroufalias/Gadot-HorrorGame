extends StaticBody3D
var key

func interact():
	get_node("/root/" + get_tree().current_scene.name + "/PlayerSounds/pickup").play()
	queue_free()
