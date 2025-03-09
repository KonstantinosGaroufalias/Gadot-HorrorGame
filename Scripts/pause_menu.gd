extends Control
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("pause"):
		get_tree().paused = !get_tree().paused
		visible = get_tree().paused
		if get_tree().paused == true:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		if get_tree().paused == false:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

			
func resume():
	get_tree().paused = !get_tree().paused
	visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func quit():
	get_tree().quit()
	
