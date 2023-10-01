extends Node2D

const map_selection_scene: PackedScene = preload("res://scenes/ui/map_selection/map_selection.tscn")
var map_selection_instance = map_selection_scene.instantiate()

const lava_map_scene: PackedScene = preload("res://scenes/maps/lava_map/lava_map.tscn")


func _ready():
	add_child(map_selection_instance)


func _process(delta):
	var ws = DisplayServer.window_get_size()
	ProjectSettings.set("display/window/size/viewport_height", ws.y)
	ProjectSettings.set("display/window/size/viewport_width", ws.x)


func start_game(map):
	add_child(map)
