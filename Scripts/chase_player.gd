extends RayCast3D

func _process(delta):
	if is_colliding():
		var hit = get_collider()
		# Only detect player if they're not hiding
		if hit.name == "Player" && !hit.is_hiding && get_parent().current_state == get_parent().MonsterState.PATROLLING:
			get_parent().start_chasing()
