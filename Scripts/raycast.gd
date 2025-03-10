extends RayCast3D

var int_text
var last_hit

func _ready():
	int_text = get_node("/root/" + get_tree().current_scene.name + "/UI/interact_text")
	if int_text == null:
		print("Error: interact_text node not found!")

func _process(delta):
	if is_colliding():
		var hit = get_collider()
		if hit != null:
			#print("Colliding with: ", hit.name)
			
			if hit.has_method("interact"):
				int_text.visible = true  # Show interaction text
				if Input.is_action_just_pressed("interact"):
					hit.interact()
			else:
				int_text.visible = false
			
			if hit.has_method("scare"):
				if last_hit != hit:
					if last_hit != null and last_hit.has_method("stop_scare"):
						last_hit.stop_scare()  # Stop previous scare if needed
					last_hit = hit
				
				hit.scare()
			else:
				if last_hit != null and last_hit.has_method("stop_scare"):
					last_hit.stop_scare()
					last_hit = null  # Reset last_hit when no longer colliding
		else:
			int_text.visible = false
	else:
		int_text.visible = false
		if last_hit != null and last_hit.has_method("stop_scare"):
			last_hit.stop_scare()
			last_hit = null  # Reset last_hit when no longer colliding
