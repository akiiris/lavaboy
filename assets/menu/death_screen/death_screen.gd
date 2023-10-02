extends Control

func _on_again_button_button_up():
	if $AgainButton.is_hovered():
		get_tree().root.get_node("Game").start_game()
		queue_free()
