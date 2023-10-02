extends Control


func _on_music_start_timer_timeout():
	$Music.play()


func _on_again_button_pressed():
	get_tree().root.get_node("Game").start_game()
	$Music.stop()
	queue_free()
