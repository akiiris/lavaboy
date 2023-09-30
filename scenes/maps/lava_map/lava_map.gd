extends Node2D



func _ready():
	pass


func _process(delta):
	$Score.text = str(Time.get_ticks_msec()/1000.0)
