extends Control

func _on_again_button_button_up():
	get_tree().root.get_node("Game").start_game()
	queue_free()
