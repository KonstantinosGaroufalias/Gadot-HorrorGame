extends Area3D

@export var monster: CharacterBody3D

# Called when the node enters the scene tree for the first time.
func spawn_monster(body):
	if body == get_node("/root/"+ get_tree().current_scene.name + "/Player"):
		monster.visible = true
