extends Node3D


var sens = 0.2
#used without cutscene = false
var movable: bool = true

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion && movable == true:
		get_parent().rotate_y(deg_to_rad(-event.relative.x * sens))
		rotate_x(deg_to_rad(-event.relative.y * sens))
		rotation.x = clamp(rotation.x , deg_to_rad(-90),deg_to_rad(90))
