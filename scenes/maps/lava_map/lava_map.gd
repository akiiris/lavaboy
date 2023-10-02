extends Node2D

var time_started
var time_score_thing

func _ready():
	time_started = Time.get_ticks_msec()


func _process(delta):
	time_score_thing = (Time.get_ticks_msec()-time_started)/1000.0
	get_node("Player/Camera/Score").text = str(time_score_thing) + "s"
