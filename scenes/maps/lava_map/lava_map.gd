extends Node2D



func _ready():
	pass


func _process(delta):
	var texture = $SubViewport.get_texture()
	$Player/SprPlayer.texture = texture
	
	$Score.text = str(Time.get_ticks_msec()/1000.0)
