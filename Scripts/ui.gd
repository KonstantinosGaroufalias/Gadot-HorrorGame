extends Label

func _ready():
	visible = false

func _process(delta):
	text = "FPS: %d" % Engine.get_frames_per_second()

func _input(event):
	if event.is_action_pressed("toggle_fps"):
		visible = !visible
