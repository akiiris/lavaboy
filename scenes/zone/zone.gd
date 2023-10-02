extends Node2D

func _ready():
	$LockTimer.wait_time = randf_range(0, 30)
	$LockTimer.start()

func _on_lock_timer_timeout():
	var tween = create_tween()
	tween.tween_property($Sprite2D, "modulate", Color("ec646097"), 2.0)
	if not $Area2D.get_overlapping_bodies().is_empty():
		print("Kunti died!")
	
	$Sprite2D.visible = true
	$StaticBody/Col.disabled = false
