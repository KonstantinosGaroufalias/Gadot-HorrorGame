extends SpotLight3D

var picked_up = false


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("flashlight") && picked_up == true:
		$toggle.play()
		visible = !visible
