extends Node2D

func _process(_delta):
	$Sprite2D.texture = $SubViewport.get_texture()
	var ws = DisplayServer.window_get_size()
	$SubViewport.size = ws
	$Sprite2D.scale = Vector2( 1152.0 / ws.x, 648.0 / ws.y)


func activate():
	$SubViewport/AnimationPlayer.play("activate")


func finish_activate():
	$SubViewport/AnimationPlayer.play("active")



func _on_area_2d_body_entered(body):
	if body.has_method("die"):
		body.die()
