extends Node2D

const map_selection_scene: PackedScene = preload("res://scenes/ui/map_selection/map_selection.tscn")
const lava_map_scene: PackedScene = preload("res://scenes/maps/lava_map/lava_map.tscn")


func _ready():
	var map_selection_instance = map_selection_scene.instantiate()
	add_child(map_selection_instance)


func _process(delta):
	var ws = DisplayServer.window_get_size()
	ProjectSettings.set("display/window/size/viewport_height", ws.y)
	ProjectSettings.set("display/window/size/viewport_width", ws.x)
	
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()


func start_game():
	add_child(lava_map_scene.instantiate())
