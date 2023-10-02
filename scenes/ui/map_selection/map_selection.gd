extends Node2D

@onready var game_node = get_tree().root.get_node("Game")

const lava_map_scene: PackedScene = preload("res://scenes/maps/lava_map/lava_map.tscn")

func _ready():
	$SubViewport/lava_boy_skeleton4.get_node("AnimationPlayer").play("renderwire_001")

func _process(delta):
	$Kunti.texture = $SubViewport.get_texture()
	var ws = DisplayServer.window_get_size()
	$SubViewport.size = ws
	$Kunti.scale = Vector2(1152.0 / ws.x, 648.0 / ws.y)


func _on_btn_play_pressed():
	if $BtnPlay.is_hovered():
		game_node.start_game()
		queue_free()


func _on_btn_quit_pressed():
	if $BtnQuit.is_hovered():
		get_tree().quit()


func _on_audio_stream_player_finished():
	$AudioStreamPlayer.play()
