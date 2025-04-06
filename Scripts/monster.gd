extends CharacterBody3D

var SPEED = 2
var base_speed = 2  # Store original speed for resetting
var player
var caught = false
var distance: float
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
@export var scene_name: String
@export var destinations: Array[Node3D]
@export var walk_footsteps: Array[AudioStream]

# Animation variables
@onready var animation_player = $George/AnimationPlayer
var current_animation = ""

var rng
var current_destination
var chasing = false
var able_to_pick = false
var jumpscareTime = 2
var is_moving = false  # Track if monster is actually moving

# State management
enum MonsterState {PATROLLING, CHASING, CAUGHT}
var current_state = MonsterState.PATROLLING

# Memory system variables
var memory_timer = 0
var memory_duration = 3.0  # 3 seconds of memory
var last_saw_player = false
var last_known_position = Vector3.ZERO

func _ready():
	rng = RandomNumberGenerator.new()
	player = get_node("/root/" + get_tree().current_scene.name + "/Player")
	var random_dest = rng.randi_range(0, destinations.size() - 1)
	current_destination = destinations[random_dest]
	base_speed = SPEED
	
	# Connect the navigation signal
	$NavigationAgent3D.velocity_computed.connect(on_navigation_velocity_computed)
	
	# Start with idle animation
	update_animation()

func _process(delta: float) -> void:
	handle_footstep_sounds()
	update_animation()
	
	match current_state:
		MonsterState.PATROLLING:
			distance = current_destination.global_transform.origin.distance_to(global_transform.origin)
			update_target_location(current_destination.global_transform.origin)
			pick_new_destination()
			
		MonsterState.CHASING:
			var can_see_player = has_line_of_sight_to_player()
			
			if can_see_player:
				memory_timer = 0
				last_saw_player = true
				last_known_position = player.global_transform.origin
				update_target_location(player.global_transform.origin)
			else:
				if last_saw_player:
					memory_timer += delta
					update_target_location(last_known_position)
					
					if memory_timer >= memory_duration:
						$chase_sound.stop()
						forget_player()
			
			check_player_catch()
		MonsterState.CAUGHT:
			pass

func _physics_process(delta):
	if !visible or current_state == MonsterState.CAUGHT:
		$chase_sound.stop()
		is_moving = false
		return
		
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	var current_location = global_transform.origin
	var next_location = $NavigationAgent3D.get_next_path_position()
	var new_velocity = (next_location - current_location).normalized() * SPEED
	
	is_moving = new_velocity.length() > 0.1 && !$NavigationAgent3D.is_navigation_finished()
	
	# Animation blending
	if velocity.length() > 0.1 && is_on_floor():
		var blend = clamp(velocity.length() / SPEED, 0.0, 1.0)
		animation_player.speed_scale = blend
	
	$NavigationAgent3D.set_velocity(new_velocity)
	
	if velocity.length() > 0.1:
		var look_dir = atan2(-velocity.x, -velocity.z)
		rotation.y = look_dir

# New animation function
func update_animation():
	var target_animation = ""
	
	match current_state:
		MonsterState.PATROLLING:
			target_animation = "Walk" if is_moving else "Idle"
		MonsterState.CHASING:
			target_animation = "Run"
		MonsterState.CAUGHT:
			target_animation = "Punch"  # Change to your jumpscare animation name
	
	if target_animation != current_animation && animation_player.has_animation(target_animation):
		animation_player.play(target_animation)
		current_animation = target_animation

func has_line_of_sight_to_player():
	if player.has_method("is_hiding") && player.is_hiding:
		return false
		
	var space_state = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(
		global_transform.origin + Vector3(0, 1, 0),
		player.global_transform.origin + Vector3(0, 1, 0)
	)
	query.exclude = [self]
	
	var result = space_state.intersect_ray(query)
	return result && result.collider == player

func forget_player():
	current_state = MonsterState.PATROLLING
	memory_timer = 0
	last_saw_player = false
	SPEED = base_speed
	var random_dest = rng.randi_range(0, destinations.size() - 1)
	current_destination = destinations[random_dest]

func handle_footstep_sounds():
	if is_moving && velocity.length() > 0.1:
		var num = rng.randi_range(0, walk_footsteps.size() - 1)
		$footstep_sound.stream = walk_footsteps[num]
		$footstep_sound.play()
	elif !is_moving:
		$footstep_sound.stop()

func pick_new_destination():
	if !able_to_pick && distance <= $NavigationAgent3D.target_desired_distance:
		able_to_pick = true
		is_moving = false
		var wait_time = rng.randf_range(3.0, 7.0)
		await get_tree().create_timer(wait_time, false).timeout
		if current_state == MonsterState.PATROLLING && distance <= $NavigationAgent3D.target_desired_distance:
			var random_dest = rng.randi_range(0, destinations.size() - 1)
			current_destination = destinations[random_dest]
		is_moving = true
		able_to_pick = false

func check_player_catch():
	distance = global_transform.origin.distance_to(player.global_transform.origin)
	var player_is_hiding = player.has_method("is_hiding") && player.is_hiding
	
	if distance <= 2 && current_state == MonsterState.CHASING && !player_is_hiding:
		current_state = MonsterState.CAUGHT
		$chase_sound.stop()
		player.visible = false
		is_moving = false
		animation_player.play("Punch")  # Change to your jumpscare animation
		if !$jumpscare.playing:
			$jumpscare.play()
		SPEED = 0
		$jumpscare_camera.current = true
		await get_tree().create_timer(jumpscareTime, false).timeout
		get_tree().change_scene_to_file("res://Scenes/" + scene_name + ".tscn")

func update_target_location(target_location):
	$NavigationAgent3D.target_position = target_location

func on_navigation_velocity_computed(safe_velocity):
	velocity = safe_velocity
	move_and_slide()

func start_chasing():
	if current_state != MonsterState.CAUGHT:
		$chase_sound.play()
		current_state = MonsterState.CHASING
		SPEED = base_speed * 1.3
		last_saw_player = true
		memory_timer = 0
		last_known_position = player.global_transform.origin
