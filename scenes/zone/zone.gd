extends Node2D


func _ready():
	$LockTimer.wait_time = randf_range(0, 30)
	#$LockTimer.start()

func _on_lock_timer_timeout():
	var tween = create_tween()
	tween.tween_property($Sprite2D, "modulate", Color("ec646097"), 2.0)
	$Sprite2D.visible = true
	$Area2D/Col.disabled = false


func _on_area_2d_body_entered(body):
	if body.has_method("die"):
		body.die()
	if body.is_in_group("delete_on_exit_bounds"):
		body.queue_free()
