extends Node2D

const map_selection_scene: PackedScene = preload("res://scenes/ui/map_selection/map_selection.tscn")
var map_selection_instance = map_selection_scene.instantiate()
const player_scene: PackedScene = preload("res://scenes/player/player.tscn")

const lava_map_scene: PackedScene = preload("res://scenes/maps/lava_map/lava_map.tscn")


func _ready():
	add_child(map_selection_instance)


func _process(delta):
	pass


func start_game(map):
	add_child(map)
	var player_instance = player_scene.instantiate()
	map.add_child(player_instance)
	player_instance.global_position = map.get_node("PlayerSpawnpoint").global_position
