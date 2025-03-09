extends StaticBody3D

var interactable = true
var opened = false


# Called when the node enters the scene tree for the first time.
func interact():
	if get_parent().get_parent().locked == true && get_parent().get_parent().key == null:
		get_parent().get_parent().locked = false
	if interactable == true && get_parent().get_parent().locked == false:
		interactable = false
		opened = !opened
		if opened == false:
			$close.play()
			$AnimationPlayer.play("close")
		if opened == true:
			$open.play()
			$AnimationPlayer.play("open")
		await get_tree().create_timer(1.5,false).timeout
		interactable = true
	if interactable== true && get_parent().get_parent().locked == true:
		$locked.play()
		$AnimationPlayer.play("locked")
		await get_tree().create_timer(1,false).timeout
		interactable = true
