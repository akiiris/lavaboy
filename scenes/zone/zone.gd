extends Node2D

@export var lock_alpha_curve: CurveTexture

func _ready():
	$LockTimer.wait_time = randf_range(30, 120)
	$LockTimer.start()


func _process(delta):
	var s = lock_alpha_curve.curve.sample(get_percent())
	$Sprite2D.visible = true
	$Sprite2D.modulate.a = s


func _on_lock_timer_timeout():
	$Area2D/Col.disabled = false


func add_time(amt):
	$LockTimer.start($LockTimer.time_left + amt)
	

func reset_time():
	$LockTimer.start()


func get_percent():
	return $LockTimer.time_left / $LockTimer.wait_time


func _on_area_2d_body_entered(body):
	if body.has_method("die"):
		body.die()
	if body.is_in_group("delete_on_exit_bounds"):
		body.queue_free()

