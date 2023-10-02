extends Control

func _on_again_button_button_up():
	if $AgainButton.is_hovered():
		get_tree().root.get_node("Game").start_game()
		queue_free()


func _on_music_start_timer_timeout():
	$Music.play()
