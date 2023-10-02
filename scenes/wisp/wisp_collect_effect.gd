extends Node2D

func _ready():
	$Particles.emitting = true

func _on_self_delete_timer_timeout():
	visible = false
	queue_free()
