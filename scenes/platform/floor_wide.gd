extends Node2D

func _process(_delta):
	var sv = get_tree().root.get_node("Game/LavaMap/FloorWideSV")
	$Sprite2D.texture = sv.get_texture()
	var ws = DisplayServer.window_get_size()
	sv.size = ws
	$Sprite2D.scale = Vector2( 1152.0 / ws.x, 648.0 / ws.y)
