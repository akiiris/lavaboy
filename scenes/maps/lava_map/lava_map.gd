extends Node2D

var wisp_scene: PackedScene = preload("res://scenes/wisp/wisp.tscn")
var meteor_scene: PackedScene = preload("res://scenes/hazard/meteor_strike.tscn")

var time_started
var time_score_thing

const WISP_SPAWN_CAP: int = 10


func _ready():
	time_started = Time.get_ticks_msec()


func _process(delta):
	time_score_thing = (Time.get_ticks_msec()-time_started)/1000.0
	get_node("Player/Camera/Score").text = str(time_score_thing).pad_decimals(0) + "s"
	$Player/Camera/WispCount.text = str($Player.wisps)
	
	for c in $Player/Camera/GridContainer.get_children():
		var p = $Zones.get_node(str(c.name)).get_percent()
		c.color = Color(p, p, p, c.color.a)
	
	var topleft = $"Zones/1".global_position
	var botright = $"Zones/12".global_position + Vector2(1148, 646)
	var ppos = $Player.global_position - topleft
	var diag = botright - topleft
	var xp = ppos.x / diag.x
	var yp = ppos.y / diag.y
	$Player/Camera/PlayerMarker.position.x = $Player/Camera/GridContainer.position.x + xp * $Player/Camera/GridContainer.size.x
	$Player/Camera/PlayerMarker.position.y = $Player/Camera/GridContainer.position.y + yp * $Player/Camera/GridContainer.size.y


func spawn_wisp():
	var wisp_instance = wisp_scene.instantiate()
	$Wisps.add_child(wisp_instance)
	wisp_instance.global_position = get_random_inner_map_pos()


func get_random_inner_map_pos():
	return Vector2(randf_range($WispSpawning/Marker1.global_position.x, $WispSpawning/Marker2.global_position.x), randf_range($WispSpawning/Marker1.global_position.y, $WispSpawning/Marker2.global_position.y))


func _on_wisp_spawn_timer_timeout():
	if $Wisps.get_children().size() < WISP_SPAWN_CAP:
		spawn_wisp()


func _on_bounds_body_exited(body):
	if body.is_in_group("delete_on_exit_bounds"):
		body.queue_free()


func _on_timer_timeout():
	$Music.play()


func _on_meteor_timer_timeout():
	var mi = meteor_scene.instantiate()
	$MeteorStrikes.add_child(mi)
	mi.global_position = $Player.global_position
	


func _on_saw_activate_delay_timeout():
	for s in $Saws.get_children():
		s.activate()


func _on_meteor_start_delay_timeout():
	$MeteorTimer.start()
