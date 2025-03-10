extends StaticBody3D

@export var painting_mat: StandardMaterial3D
@export var scary_painting: StandardMaterial3D
@export var stare_time: float
@export var scare_time: float
@export var only_once: bool

var looking = false
var done = false

func _ready():
	$MeshInstance3D2.material_override = painting_mat

func scare():
	if not looking and not done:
		looking = true
		if only_once:
			done = true
		
		# Start a coroutine for the scare logic
		start_scare()

func stop_scare():
	looking = false

# Coroutine to handle the scare logic
func start_scare():
	var timer = get_tree().create_timer(stare_time, false)
	await timer.timeout
	
	# Check if still looking after the stare time
	if looking:
		$jumpscare.play()
		$MeshInstance3D2.material_override = scary_painting
		
		var scare_timer = get_tree().create_timer(scare_time, false)
		await scare_timer.timeout
		
		$jumpscare.stop()
		$MeshInstance3D2.material_override = painting_mat
		
	if not only_once:
		done = false  # Reset if multiple scares are allowed
