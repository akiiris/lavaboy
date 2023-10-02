extends Node2D


func _process(_delta):
	$Sprite2D.texture = $SubViewport.get_texture()
	var ws = DisplayServer.window_get_size()
	$SubViewport.size = ws
	$Sprite2D.scale = Vector2( 1152.0 / ws.x, 648.0 / ws.y)


func interact(user):
	if user.has_method("try_consume_wisp"):
		if user.try_consume_wisp(1):
			activate()
		else:
			$FailSound.play()


func activate():
	$ActivateSound.play()
	$SubViewport/ActivateParticles.restart()
	$SubViewport/ActivateParticles.emitting = true


func _on_interact_area_area_entered(area):
	$SubViewport/DirectionalLight3D.light_energy = 3


func _on_interact_area_area_exited(area):
	$SubViewport/DirectionalLight3D.light_energy = 1
