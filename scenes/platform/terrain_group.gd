extends StaticBody2D

# For all intents and purposes, show_behind_parent is equivalent to visible

func _ready():
	$Timer.start(randf_range(55.0, 115.0))

# 5 seconds left
func _on_timer_timeout():
	for e in get_children():
		if not e is Timer:
			if e.modulate.a == 1:
				e.show_behind_parent = 0
			if e.modulate.a == 0:
				e.show_behind_parent = 1
			var t = create_tween()
			if e.modulate.a == 1:
				t.tween_property(e, "modulate", Color(1.0, 0.0, 0.0, 1.0), 4.8)
				t.chain().tween_property(e, "modulate", Color(1.0, 0.0, 0.0, 0.0), 0.2)
			if e.modulate.a == 0:
				e.modulate = Color(0.2, 0.2, 0.2, 0)
				t.tween_property(e, "modulate", Color(1.0, 1.0, 1.0, 0.1), 1.0)
	$FiveSecondTimer.start()

# Time's up
func _on_five_second_timer_timeout():
	for e in get_children():
		if e is CollisionShape2D:
			e.set_deferred("disabled", not e.disabled)
		if not e is Timer:
			if e.show_behind_parent:
				e.modulate = Color(1, 1, 1, 1)
			else:
				e.modulate.a = 0
	$Timer.start(randf_range(5.0, 25.0))
