extends Node2D

func _on_self_delete_timer_timeout():
	queue_free()
