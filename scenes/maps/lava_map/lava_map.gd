extends Node2D

var wisp_scene: PackedScene = preload("res://scenes/wisp/wisp.tscn")

var time_started
var time_score_thing

const WISP_SPAWN_CAP: int = 10


func _ready():
	time_started = Time.get_ticks_msec()


func _process(delta):
	time_score_thing = (Time.get_ticks_msec()-time_started)/1000.0
	get_node("Player/Camera/Score").text = str(time_score_thing) + "s"
	print($Wisps.get_children().size())


func spawn_wisp():
	var wisp_instance = wisp_scene.instantiate()
	$Wisps.add_child(wisp_instance)
	wisp_instance.global_position = Vector2(randf_range($WispSpawning/Marker1.global_position.x, $WispSpawning/Marker2.global_position.x), randf_range($WispSpawning/Marker1.global_position.y, $WispSpawning/Marker2.global_position.y))


func _on_wisp_spawn_timer_timeout():
	if $Wisps.get_children().size() < WISP_SPAWN_CAP:
		spawn_wisp()
