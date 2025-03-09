extends Node3D

@export var flash_lights_at_rand: bool
@export var min_time: float
@export var max_time: float
@export var min_flash_time: float
@export var max_flash_time: float
@export var loop_flashing: bool

var loop = true
var rng = RandomNumberGenerator.new()

func _ready():
	# Initialize the random number generator once
	rng.randomize()

func _process(delta):
	if loop && flash_lights_at_rand:
		loop = false
		var rand = rng.randf_range(min_time, max_time)
		await get_tree().create_timer(rand, false).timeout
		
		if loop_flashing:
			# Set animation to loop
			$AnimationPlayer.get_animation("flashing_light").loop_mode = Animation.LOOP_LINEAR
		else:
			# Set animation to not loop
			$AnimationPlayer.get_animation("flashing_light").loop_mode = Animation.LOOP_NONE
			loop = true  # Reset loop immediately if not loop_flashing
			
		$AnimationPlayer.play("flashing_light")
		
		if loop_flashing:
			var rand2 = rng.randf_range(min_flash_time, max_flash_time)
			await get_tree().create_timer(rand2, false).timeout
			$AnimationPlayer.get_animation("flashing_light").loop_mode = Animation.LOOP_NONE
			$AnimationPlayer.stop()  # Stop the animation
			loop = true  # Reset loop after flashing is done
