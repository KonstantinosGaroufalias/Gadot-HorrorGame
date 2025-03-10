extends Node3D

@export var flash_lights_at_rand: bool = true
@export var min_time: float = 1.0
@export var max_time: float = 3.0
@export var min_flash_time: float = 0.5
@export var max_flash_time: float = 2.0
@export var loop_flashing: bool = false

var loop = true
var rng = RandomNumberGenerator.new()

func _ready():
	# Initialize the random number generator once
	rng.randomize()
	$AudioStreamPlayer3D2.play()

func _process(delta):
	if loop and flash_lights_at_rand:
		loop = false
		
		# Wait for a random time before starting the flicker
		var rand_delay = rng.randf_range(min_time, max_time)
		await get_tree().create_timer(rand_delay).timeout
		
		# Start the flickering light animation
		$AnimationPlayer.play("flashing_light")
		$AudioStreamPlayer3D.play()  # Start audio playback
		
		if loop_flashing:
			# Wait for a random flash duration while looping
			var rand_flash_duration = rng.randf_range(min_flash_time, max_flash_time)
			await get_tree().create_timer(rand_flash_duration).timeout
			
			# Stop flashing after random duration
			$AnimationPlayer.stop()
			$AudioStreamPlayer3D.stop()  # Stop audio playback
			
		else:
			# Stop flashing immediately if not looping
			await $AnimationPlayer.animation_finished  # Wait for animation to finish
			$AudioStreamPlayer3D.stop()  # Stop audio playback
		
		# Reset loop for next cycle
		loop = true
