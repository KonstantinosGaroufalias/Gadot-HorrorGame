extends Control


# Called when the node enters the scene tree for the first time.
func play():
	get_tree().change_scene_to_file("res://Scenes/level1.tscn")
	
func quit():
	get_tree().quit()
	
