extends Node

var flashlight

func _ready():
	flashlight = get_node("/root/" + get_tree().current_scene.name + "/Player/head/flashlight")

func interact():
	get_node("/root/" + get_tree().current_scene.name + "/pickup").play()
	flashlight.picked_up = true
	queue_free()
